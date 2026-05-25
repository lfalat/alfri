#!/bin/sh
set -e

CONFIG="/usr/share/nginx/html/assets/config/config.json"

echo "[entrypoint] Substituting config values"
envsubst '${API_URL} ${ENVIRONMENT} ${KEYCLOAK_URL} ${KEYCLOAK_REALM} ${KEYCLOAK_CLIENT_ID}' \
  < "$CONFIG" > /tmp/config.json
mv /tmp/config.json "$CONFIG"

exec nginx -g "daemon off;"
