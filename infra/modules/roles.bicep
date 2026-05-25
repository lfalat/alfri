targetScope = 'resourceGroup'

param containerRegistryName string
param keyVaultName string
param frontendPrincipalId string
param backendPrincipalId string
param mlPrincipalId string
param keycloakPrincipalId string

@description('Object ID of the human operator who will set Key Vault secrets. Leave empty to skip.')
param operatorObjectId string = ''

// Built-in role IDs (subscription-scoped, same across all Azure clouds)
var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
var kvSecretsUserRoleId = '4633458b-17de-408a-b874-0445c86b69e6'
var kvSecretsOfficerRoleId = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: containerRegistryName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

// ── AcrPull: all four Container Apps ──────────────────────────────────────────
// Enables identity-based image pulls. ACR admin credentials can be disabled
// once these are active and a successful pull has been verified.

resource acrPullFrontend 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, frontendPrincipalId, acrPullRoleId)
  scope: registry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: frontendPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource acrPullBackend 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, backendPrincipalId, acrPullRoleId)
  scope: registry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: backendPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource acrPullMl 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, mlPrincipalId, acrPullRoleId)
  scope: registry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: mlPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource acrPullKeycloak 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(registry.id, keycloakPrincipalId, acrPullRoleId)
  scope: registry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: keycloakPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// ── Key Vault Secrets User: backend, ML, Keycloak ─────────────────────────────
// Frontend has no Key Vault secrets (all its config values are non-sensitive).

resource kvSecretsBackend 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, backendPrincipalId, kvSecretsUserRoleId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', kvSecretsUserRoleId)
    principalId: backendPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource kvSecretsMl 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, mlPrincipalId, kvSecretsUserRoleId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', kvSecretsUserRoleId)
    principalId: mlPrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource kvSecretsKeycloak 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, keycloakPrincipalId, kvSecretsUserRoleId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', kvSecretsUserRoleId)
    principalId: keycloakPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// ── Key Vault Secrets Officer: human operator ─────────────────────────────────
// Allows the deploying user to write secrets via provision-secrets.sh.
// Skipped when operatorObjectId is not provided.

resource kvSecretsOfficerOperator 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(operatorObjectId)) {
  name: guid(keyVault.id, operatorObjectId, kvSecretsOfficerRoleId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', kvSecretsOfficerRoleId)
    principalId: operatorObjectId
    principalType: 'User'
  }
}
