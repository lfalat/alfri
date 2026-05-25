targetScope = 'resourceGroup'

param location string

// User-assigned managed identities are created independently of the Container
// Apps, so role assignments (AcrPull, Key Vault Secrets User) can be applied
// before any Container App revision is provisioned.

resource frontendIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'alfri-frontend-id'
  location: location
}

resource backendIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'alfri-backend-id'
  location: location
}

resource mlIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'alfri-ml-service-id'
  location: location
}

resource keycloakIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'alfri-keycloak-id'
  location: location
}

output frontendIdentityId string = frontendIdentity.id
output backendIdentityId string = backendIdentity.id
output mlIdentityId string = mlIdentity.id
output keycloakIdentityId string = keycloakIdentity.id

output frontendPrincipalId string = frontendIdentity.properties.principalId
output backendPrincipalId string = backendIdentity.properties.principalId
output mlPrincipalId string = mlIdentity.properties.principalId
output keycloakPrincipalId string = keycloakIdentity.properties.principalId
