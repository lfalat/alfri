#!/bin/sh
set -eu

CONFIG_TEMPLATE="/usr/share/nginx/html/assets/config/config.template.json"
CONFIG="/usr/share/nginx/html/assets/config/config.json"
NGINX_TEMPLATE="/etc/nginx/templates/nginx.conf.template"

: "${BACKEND_URL:=http://backend:8080}"
: "${API_URL:=/api}"
: "${ENVIRONMENT:=development}"
: "${KEYCLOAK_URL:=http://localhost:8180}"
: "${KEYCLOAK_REALM:=alfri}"
: "${KEYCLOAK_CLIENT_ID:=alfri-frontend}"

echo "[entrypoint] Rendering browser and proxy configuration"
envsubst '${API_URL} ${ENVIRONMENT} ${KEYCLOAK_URL} ${KEYCLOAK_REALM} ${KEYCLOAK_CLIENT_ID}' \
  < "$CONFIG_TEMPLATE" > /tmp/config.json
mv /tmp/config.json "$CONFIG"
envsubst '${BACKEND_URL}' < "$NGINX_TEMPLATE" > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
