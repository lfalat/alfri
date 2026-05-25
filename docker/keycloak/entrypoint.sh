#!/bin/bash
set -eu
echo "[entrypoint] Importing realms..."
/opt/keycloak/bin/kc.sh import --dir /opt/keycloak/data/import --override false
echo "[entrypoint] Starting Keycloak..."
exec /opt/keycloak/bin/kc.sh start
