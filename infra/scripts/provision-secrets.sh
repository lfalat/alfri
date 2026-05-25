#!/usr/bin/env bash
# Replaces the placeholder secret values written by azd provision with real ones.
# Run this once after `azd provision` and before `azd deploy`.
#
# Prerequisites:
#   az login (with a principal that has Key Vault Secrets Officer on the vault)
#   az account set --subscription <id>
#
# Usage:
#   ./infra/scripts/provision-secrets.sh <KEY_VAULT_NAME>
#
# Secrets managed:
#   pg-password             PostgreSQL admin password (shared by backend and ML service)
#   keycloak-admin-password Keycloak admin console password (used by Keycloak and backend admin client)
#   keycloak-db-password    Password for the dedicated 'keycloak' PostgreSQL role
#   keycloak-webhook-secret Shared secret for Keycloak event webhook → backend
#   ml-api-key              API key shared between backend (caller) and ML service (verifier)

set -euo pipefail

KV="${1:?Usage: $0 <KEY_VAULT_NAME>}"

echo "Setting secrets in Key Vault: $KV"
echo "(values are read interactively and never written to disk)"
echo ""

read -r -s -p "pg-password (PostgreSQL admin password): " PG_PASS; echo
read -r -s -p "keycloak-admin-password: " KC_ADMIN_PASS; echo
read -r -s -p "keycloak-db-password (password for the 'keycloak' PG role): " KC_DB_PASS; echo
read -r -s -p "keycloak-webhook-secret: " KC_WEBHOOK; echo
read -r -s -p "ml-api-key: " ML_KEY; echo
echo ""

az keyvault secret set --vault-name "$KV" --name pg-password              --value "$PG_PASS"       --output none
az keyvault secret set --vault-name "$KV" --name keycloak-admin-password   --value "$KC_ADMIN_PASS" --output none
az keyvault secret set --vault-name "$KV" --name keycloak-db-password      --value "$KC_DB_PASS"    --output none
az keyvault secret set --vault-name "$KV" --name keycloak-webhook-secret   --value "$KC_WEBHOOK"    --output none
az keyvault secret set --vault-name "$KV" --name ml-api-key                --value "$ML_KEY"        --output none

echo "All secrets set in $KV."
echo ""
echo "Next step: run infra/scripts/init-keycloak-db.sh to create the keycloak PostgreSQL role."
