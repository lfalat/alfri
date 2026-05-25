#!/usr/bin/env bash
# One-time setup: creates an Azure AD app registration with workload identity
# federation for GitHub Actions, then assigns the roles needed for the release
# workflow (AcrPush on alfriregistry, Contributor on alfri-rg).
#
# Prerequisites:
#   az login with a principal that has Owner on the target subscription
#   az account set --subscription <id>
#
# Usage:
#   ./infra/scripts/setup-wif.sh <GITHUB_ORG>/<REPO>
#
# Example:
#   ./infra/scripts/setup-wif.sh my-org/alfri

set -euo pipefail

REPO="${1:?Usage: $0 <GITHUB_ORG>/<REPO>}"
APP_NAME="alfri-cicd"
RESOURCE_GROUP="alfri-rg"
REGISTRY_NAME="alfriregistry"

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Subscription : $SUBSCRIPTION_ID"
echo "Tenant       : $TENANT_ID"
echo "GitHub repo  : $REPO"
echo ""

# Create app registration
echo "Creating app registration: $APP_NAME"
APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
echo "  appId: $APP_ID"

# Create service principal
echo "Creating service principal..."
az ad sp create --id "$APP_ID" --output none
SP_OID=$(az ad sp show --id "$APP_ID" --query id -o tsv)
echo "  SP objectId: $SP_OID"

# Federated credential: master branch pushes
echo "Adding federated credential for master branch pushes..."
az ad app federated-credential create --id "$APP_ID" --parameters "{
  \"name\": \"${APP_NAME}-master\",
  \"issuer\": \"https://token.actions.githubusercontent.com\",
  \"subject\": \"repo:${REPO}:ref:refs/heads/master\",
  \"audiences\": [\"api://AzureADTokenExchange\"]
}" --output none

# AcrPush on alfriregistry (build-and-push job)
echo "Assigning AcrPush on $REGISTRY_NAME..."
ACR_ID=$(az acr show --name "$REGISTRY_NAME" --resource-group "$RESOURCE_GROUP" --query id -o tsv)
az role assignment create \
  --assignee-object-id "$SP_OID" \
  --assignee-principal-type ServicePrincipal \
  --role AcrPush \
  --scope "$ACR_ID" \
  --output none

# Contributor on resource group (Bicep provision + Container App updates)
echo "Assigning Contributor on resource group $RESOURCE_GROUP..."
RG_ID=$(az group show --name "$RESOURCE_GROUP" --query id -o tsv)
az role assignment create \
  --assignee-object-id "$SP_OID" \
  --assignee-principal-type ServicePrincipal \
  --role Contributor \
  --scope "$RG_ID" \
  --output none

echo ""
echo "Setup complete. Add these three secrets to the GitHub repository ($REPO):"
echo ""
echo "  AZURE_CLIENT_ID       = $APP_ID"
echo "  AZURE_TENANT_ID       = $TENANT_ID"
echo "  AZURE_SUBSCRIPTION_ID = $SUBSCRIPTION_ID"
echo ""
echo "GitHub UI: Settings → Secrets and variables → Actions → New repository secret"
