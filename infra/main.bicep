targetScope = 'resourceGroup'

@description('Azure location for new resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Existing Container Apps environment name.')
param containerAppsEnvironmentName string = 'alfri-env'

@description('Existing Azure Container Registry name.')
param containerRegistryName string = 'alfriregistry'

@description('Existing PostgreSQL Flexible Server name.')
param postgresServerName string = 'alfri-postgres'

@description('Name for the new Key Vault (must be globally unique, 3-24 chars).')
param keyVaultName string = 'alfri-kv'

@description('PostgreSQL admin username used by backend and ML service.')
param pgAdminUser string = 'alfri'

@description('PostgreSQL database name for the main application.')
param pgDatabase string = 'alfri'

@description('Keycloak realm name.')
param keycloakRealm string = 'alfri'

@description('Keycloak admin username (not a secret).')
param keycloakAdminUser string = 'admin'

@description('Object ID of the operator who will set Key Vault secrets. Leave empty to skip the Secrets Officer assignment.')
param operatorObjectId string = ''

@description('Frontend container image. azd deploy overrides this with the commit-SHA-tagged image.')
param frontendImageName string = 'alfriregistry.azurecr.io/alfri-frontend:latest'

@description('Backend container image. azd deploy overrides this.')
param backendImageName string = 'alfriregistry.azurecr.io/alfri-backend:latest'

@description('ML service container image. azd deploy overrides this.')
param mlImageName string = 'alfriregistry.azurecr.io/alfri-ml-service:latest'

@description('Keycloak container image. azd deploy overrides this.')
param keycloakImageName string = 'alfriregistry.azurecr.io/alfri-keycloak:latest'

// ── References to existing resources ──────────────────────────────────────────

resource containerAppsEnv 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: containerAppsEnvironmentName
}

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: containerRegistryName
}

resource postgresServer 'Microsoft.DBforPostgreSQL/flexibleServers@2023-06-01-preview' existing = {
  name: postgresServerName
}

// ── Derived values ─────────────────────────────────────────────────────────────

var pgHost = postgresServer.properties.fullyQualifiedDomainName
var envDefaultDomain = containerAppsEnv.properties.defaultDomain
var frontendFqdn = 'alfri-frontend.${envDefaultDomain}'
var keycloakFqdn = 'alfri-keycloak.${envDefaultDomain}'

// ── Keycloak PostgreSQL database ───────────────────────────────────────────────

resource keycloakDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2023-06-01-preview' = {
  name: 'keycloak'
  parent: postgresServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}

// ── Step 1: Managed identities ─────────────────────────────────────────────────
// Created first so principal IDs are available for role assignments.

module identities 'modules/identities.bicep' = {
  name: 'deploy-identities'
  params: {
    location: location
  }
}

// ── Step 2: Key Vault ──────────────────────────────────────────────────────────

module kv 'modules/keyvault.bicep' = {
  name: 'deploy-keyvault'
  params: {
    location: location
    keyVaultName: keyVaultName
  }
}

// ── Step 3: Role assignments ───────────────────────────────────────────────────
// Depends on both identities and Key Vault existing before assigning roles.
// Container Apps will not be created until this module succeeds (see step 4).

module roles 'modules/roles.bicep' = {
  name: 'deploy-roles'
  params: {
    containerRegistryName: containerRegistryName
    keyVaultName: kv.outputs.keyVaultName
    frontendPrincipalId: identities.outputs.frontendPrincipalId
    backendPrincipalId: identities.outputs.backendPrincipalId
    mlPrincipalId: identities.outputs.mlPrincipalId
    keycloakPrincipalId: identities.outputs.keycloakPrincipalId
    operatorObjectId: operatorObjectId
  }
}

// ── Step 4: Container Apps ─────────────────────────────────────────────────────
// Depends on roles so AcrPull and Key Vault Secrets User are in place before
// any revision is provisioned.

module apps 'modules/container-apps.bicep' = {
  name: 'deploy-container-apps'
  dependsOn: [roles]
  params: {
    location: location
    containerAppsEnvironmentId: containerAppsEnv.id
    containerRegistryName: containerRegistryName
    keyVaultUri: kv.outputs.keyVaultUri
    pgHost: pgHost
    pgDatabase: pgDatabase
    pgAdminUser: pgAdminUser
    keycloakRealm: keycloakRealm
    keycloakAdminUser: keycloakAdminUser
    frontendFqdn: frontendFqdn
    keycloakFqdn: keycloakFqdn
    frontendImageName: frontendImageName
    backendImageName: backendImageName
    mlImageName: mlImageName
    keycloakImageName: keycloakImageName
    frontendIdentityId: identities.outputs.frontendIdentityId
    backendIdentityId: identities.outputs.backendIdentityId
    mlIdentityId: identities.outputs.mlIdentityId
    keycloakIdentityId: identities.outputs.keycloakIdentityId
  }
}

// ── Outputs ────────────────────────────────────────────────────────────────────

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = registry.properties.loginServer
output AZURE_KEY_VAULT_ENDPOINT string = kv.outputs.keyVaultUri
output AZURE_KEY_VAULT_NAME string = kv.outputs.keyVaultName

output SERVICE_FRONTEND_NAME string = 'alfri-frontend'
output SERVICE_BACKEND_NAME string = 'alfri-backend'
output SERVICE_ML_SERVICE_NAME string = 'alfri-ml-service'
output SERVICE_KEYCLOAK_NAME string = 'alfri-keycloak'

output FRONTEND_FQDN string = frontendFqdn
output KEYCLOAK_FQDN string = keycloakFqdn
output POSTGRES_HOST string = pgHost
