#!/usr/bin/env bash
# Creates the 'keycloak' PostgreSQL role and grants it full access to the
# 'keycloak' database (which is created by the Bicep deployment).
#
# This script is idempotent: running it again with the same or updated password
# will update the role's password without recreating it.
#
# Prerequisites:
#   psql installed and network access to the PostgreSQL server (TLS required)
#   The keycloak database already exists (created by azd provision / Bicep)
#
# Usage:
#   ./infra/scripts/init-keycloak-db.sh <PG_HOST> <PG_ADMIN_USER>
#
# Example:
#   ./infra/scripts/init-keycloak-db.sh alfri-postgres.postgres.database.azure.com alfri

set -euo pipefail

PG_HOST="${1:?Usage: $0 <PG_HOST> <PG_ADMIN_USER>}"
PG_ADMIN="${2:?Usage: $0 <PG_HOST> <PG_ADMIN_USER>}"

read -r -s -p "PostgreSQL admin password for '$PG_ADMIN': " PG_ADMIN_PASS; echo
read -r -s -p "Password to set for the 'keycloak' role: " KC_DB_PASS; echo
echo ""

export PGPASSWORD="$PG_ADMIN_PASS"
PSQL_BASE="psql --host=${PG_HOST} --port=5432 --username=${PG_ADMIN} --no-password"
export PGSSLMODE=require

echo "Creating/updating 'keycloak' role and granting database access..."

$PSQL_BASE --dbname=postgres <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'keycloak') THEN
    EXECUTE format('CREATE ROLE keycloak WITH LOGIN PASSWORD %L', '${KC_DB_PASS}');
    RAISE NOTICE 'Role keycloak created.';
  ELSE
    EXECUTE format('ALTER ROLE keycloak WITH PASSWORD %L', '${KC_DB_PASS}');
    RAISE NOTICE 'Role keycloak password updated.';
  END IF;
END
\$\$;
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
SQL

echo "Granting schema permissions in the keycloak database..."

$PSQL_BASE --dbname=keycloak <<SQL
GRANT ALL ON SCHEMA public TO keycloak;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO keycloak;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO keycloak;
SQL

echo "Done. The 'keycloak' role is ready."
echo ""
echo "Next step: run azd deploy (after setting real secrets with provision-secrets.sh)."
