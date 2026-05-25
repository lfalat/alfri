targetScope = 'resourceGroup'

param location string
param keyVaultName string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    // RBAC-based access control; Container Apps use Key Vault Secrets User role
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// Placeholder secrets — provision-secrets.sh overwrites these with real values
// before running azd deploy. Placeholders allow the provision step to succeed
// and role assignments to be wired while keeping containers at minReplicas=0.

resource pgPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'pg-password'
  parent: keyVault
  properties: {
    value: 'REPLACE_BEFORE_DEPLOY'
    attributes: { enabled: true }
  }
}

resource keycloakAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'keycloak-admin-password'
  parent: keyVault
  properties: {
    value: 'REPLACE_BEFORE_DEPLOY'
    attributes: { enabled: true }
  }
}

resource keycloakDbPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'keycloak-db-password'
  parent: keyVault
  properties: {
    value: 'REPLACE_BEFORE_DEPLOY'
    attributes: { enabled: true }
  }
}

resource keycloakWebhookSecretResource 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'keycloak-webhook-secret'
  parent: keyVault
  properties: {
    value: 'REPLACE_BEFORE_DEPLOY'
    attributes: { enabled: true }
  }
}

resource mlApiKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'ml-api-key'
  parent: keyVault
  properties: {
    value: 'REPLACE_BEFORE_DEPLOY'
    attributes: { enabled: true }
  }
}

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultName string = keyVault.name
