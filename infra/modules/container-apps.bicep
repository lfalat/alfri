targetScope = 'resourceGroup'

param location string
param containerAppsEnvironmentId string
param containerRegistryName string
param keyVaultUri string
param pgHost string
param pgDatabase string
param pgAdminUser string
param keycloakRealm string
param keycloakAdminUser string
param frontendFqdn string
param keycloakFqdn string
param frontendImageName string
param backendImageName string
param mlImageName string
param keycloakImageName string

// User-assigned managed identity resource IDs (created and role-assigned before
// this module runs, so ACR pull and Key Vault secret access are already granted).
param frontendIdentityId string
param backendIdentityId string
param mlIdentityId string
param keycloakIdentityId string

var registryServer = '${containerRegistryName}.azurecr.io'

// ── Frontend ───────────────────────────────────────────────────────────────────

resource frontendApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'alfri-frontend'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${frontendIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
      }
      registries: [
        {
          server: registryServer
          identity: frontendIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'alfri-frontend'
          image: frontendImageName
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            { name: 'BACKEND_URL', value: 'http://alfri-backend' }
            { name: 'API_URL', value: '/api' }
            { name: 'KEYCLOAK_URL', value: 'https://${keycloakFqdn}' }
            { name: 'KEYCLOAK_REALM', value: keycloakRealm }
            { name: 'KEYCLOAK_CLIENT_ID', value: 'alfri-frontend' }
            { name: 'ENVIRONMENT', value: 'azure-dev' }
          ]
          probes: [
            {
              type: 'Readiness'
              httpGet: { path: '/health', port: 80, scheme: 'HTTP' }
              initialDelaySeconds: 5
              periodSeconds: 10
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: { path: '/health', port: 80, scheme: 'HTTP' }
              initialDelaySeconds: 10
              periodSeconds: 30
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

// ── Backend ────────────────────────────────────────────────────────────────────

resource backendApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'alfri-backend'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${backendIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    configuration: {
      ingress: {
        external: false
        targetPort: 8080
        transport: 'auto'
      }
      registries: [
        {
          server: registryServer
          identity: backendIdentityId
        }
      ]
      secrets: [
        {
          name: 'pg-password'
          keyVaultUrl: '${keyVaultUri}secrets/pg-password'
          identity: backendIdentityId
        }
        {
          name: 'keycloak-admin-password'
          keyVaultUrl: '${keyVaultUri}secrets/keycloak-admin-password'
          identity: backendIdentityId
        }
        {
          name: 'keycloak-webhook-secret'
          keyVaultUrl: '${keyVaultUri}secrets/keycloak-webhook-secret'
          identity: backendIdentityId
        }
        {
          name: 'ml-api-key'
          keyVaultUrl: '${keyVaultUri}secrets/ml-api-key'
          identity: backendIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'alfri-backend'
          image: backendImageName
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          env: [
            { name: 'SPRING_PROFILES_ACTIVE', value: 'azure-dev' }
            { name: 'AZURE_PG_HOST', value: pgHost }
            { name: 'AZURE_PG_DATABASE', value: pgDatabase }
            { name: 'AZURE_PG_USER', value: pgAdminUser }
            { name: 'AZURE_PG_PASSWORD', secretRef: 'pg-password' }
            { name: 'KEYCLOAK_ISSUER_URI', value: 'https://${keycloakFqdn}/realms/${keycloakRealm}' }
            { name: 'KEYCLOAK_JWK_SET_URI', value: 'https://${keycloakFqdn}/realms/${keycloakRealm}/protocol/openid-connect/certs' }
            { name: 'KEYCLOAK_INTERNAL_ISSUER_URI', value: 'http://alfri-keycloak/realms/${keycloakRealm}' }
            { name: 'KEYCLOAK_REALM', value: keycloakRealm }
            { name: 'KEYCLOAK_CLIENT_ID', value: 'alfri-frontend' }
            { name: 'KEYCLOAK_ADMIN_REALM', value: 'master' }
            { name: 'KEYCLOAK_ADMIN_CLIENT_ID', value: 'admin-cli' }
            { name: 'KEYCLOAK_ADMIN_USERNAME', value: keycloakAdminUser }
            { name: 'KEYCLOAK_ADMIN_PASSWORD', secretRef: 'keycloak-admin-password' }
            { name: 'KEYCLOAK_EVENT_WEBHOOK_SECRET', secretRef: 'keycloak-webhook-secret' }
            { name: 'PYTHON_SERVICE_BASE_URL', value: 'http://alfri-ml-service' }
            { name: 'PYTHON_SERVICE_API_KEY', secretRef: 'ml-api-key' }
            { name: 'CORS_ALLOWED_ORIGINS', value: 'https://${frontendFqdn}' }
          ]
          probes: [
            {
              type: 'Startup'
              httpGet: { path: '/actuator/health/readiness', port: 8080, scheme: 'HTTP' }
              initialDelaySeconds: 30
              periodSeconds: 10
              failureThreshold: 12
            }
            {
              type: 'Readiness'
              httpGet: { path: '/actuator/health/readiness', port: 8080, scheme: 'HTTP' }
              periodSeconds: 10
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: { path: '/actuator/health/liveness', port: 8080, scheme: 'HTTP' }
              periodSeconds: 30
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

// ── ML Service ─────────────────────────────────────────────────────────────────

resource mlApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'alfri-ml-service'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${mlIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    configuration: {
      ingress: {
        external: false
        targetPort: 5000
        transport: 'auto'
      }
      registries: [
        {
          server: registryServer
          identity: mlIdentityId
        }
      ]
      secrets: [
        {
          name: 'pg-password'
          keyVaultUrl: '${keyVaultUri}secrets/pg-password'
          identity: mlIdentityId
        }
        {
          name: 'ml-api-key'
          keyVaultUrl: '${keyVaultUri}secrets/ml-api-key'
          identity: mlIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'alfri-ml-service'
          image: mlImageName
          resources: {
            cpu: json('1')
            memory: '2Gi'
          }
          env: [
            { name: 'MODE', value: 'prod' }
            { name: 'DATABASE_HOST', value: '${pgHost}:5432/${pgDatabase}' }
            { name: 'DATABASE_USER', value: pgAdminUser }
            { name: 'DATABASE_PASSWORD', secretRef: 'pg-password' }
            { name: 'DATABASE_SSLMODE', value: 'require' }
            { name: 'API_KEYS', secretRef: 'ml-api-key' }
          ]
          probes: [
            {
              type: 'Startup'
              httpGet: { path: '/health/ready', port: 5000, scheme: 'HTTP' }
              initialDelaySeconds: 30
              periodSeconds: 10
              failureThreshold: 12
            }
            {
              type: 'Readiness'
              httpGet: { path: '/health/ready', port: 5000, scheme: 'HTTP' }
              periodSeconds: 15
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: { path: '/health/live', port: 5000, scheme: 'HTTP' }
              periodSeconds: 30
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

// ── Keycloak ───────────────────────────────────────────────────────────────────

resource keycloakApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'alfri-keycloak'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${keycloakIdentityId}': {} }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
        transport: 'auto'
      }
      registries: [
        {
          server: registryServer
          identity: keycloakIdentityId
        }
      ]
      secrets: [
        {
          name: 'kc-db-password'
          keyVaultUrl: '${keyVaultUri}secrets/keycloak-db-password'
          identity: keycloakIdentityId
        }
        {
          name: 'keycloak-admin-password'
          keyVaultUrl: '${keyVaultUri}secrets/keycloak-admin-password'
          identity: keycloakIdentityId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'alfri-keycloak'
          image: keycloakImageName
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          args: ['start', '--import-realm']
          env: [
            { name: 'KC_DB', value: 'postgres' }
            { name: 'KC_DB_URL', value: 'jdbc:postgresql://${pgHost}:5432/keycloak?sslmode=require' }
            { name: 'KC_DB_USERNAME', value: 'keycloak' }
            { name: 'KC_DB_PASSWORD', secretRef: 'kc-db-password' }
            { name: 'KC_HOSTNAME', value: 'https://${keycloakFqdn}' }
            { name: 'KC_HOSTNAME_STRICT', value: 'false' }
            { name: 'KC_PROXY_HEADERS', value: 'xforwarded' }
            { name: 'KC_HTTP_ENABLED', value: 'true' }
            { name: 'KEYCLOAK_ADMIN', value: keycloakAdminUser }
            { name: 'KEYCLOAK_ADMIN_PASSWORD', secretRef: 'keycloak-admin-password' }
            { name: 'KC_HEALTH_ENABLED', value: 'true' }
            { name: 'KC_METRICS_ENABLED', value: 'true' }
            { name: 'KC_LOG_LEVEL', value: 'INFO,org.keycloak:DEBUG' }
          ]
          probes: [
            {
              type: 'Startup'
              httpGet: { path: '/health/ready', port: 8080, scheme: 'HTTP' }
              initialDelaySeconds: 60
              periodSeconds: 10
              failureThreshold: 18
            }
            {
              type: 'Readiness'
              httpGet: { path: '/health/ready', port: 8080, scheme: 'HTTP' }
              periodSeconds: 15
              failureThreshold: 3
            }
            {
              type: 'Liveness'
              httpGet: { path: '/health/live', port: 8080, scheme: 'HTTP' }
              periodSeconds: 30
              failureThreshold: 3
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}
