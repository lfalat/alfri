Local development README

Purpose
This document explains how to run the services locally for development and quick testing using Docker Compose.

Prerequisites
- Docker (Engine) and Docker Compose v2
- (Optional) Dapr CLI if you want to run Dapr sidecars locally

Files created/used
- `docker-compose.local.yml` - Compose file that builds and runs backend, frontend, python-service and a local Postgres DB
- `Dockerfile.backend`, `Dockerfile.python` - Dockerfiles for backend and python service
- `FE/Dockerfile` - existing Dockerfile for frontend (used automatically by compose)
- `.env.template` - copy this to `.env` and fill secrets

Quick start
1) Copy `.env.template` to `.env` and edit values if necessary:

```bash
cp .env.template .env
# edit .env and set values if you want to override defaults
```

2) Build and run all services (this builds images locally):

```bash
docker compose -f docker-compose.local.yml up --build
```

3) Verify services are up:
- Backend: http://localhost:8080/ (or health endpoint if present)
- Frontend (if using containerized dev server): http://localhost:4200/
- Python ML service: http://localhost:5000/
- Postgres: host `localhost:5432` (DB: alfri, user: alfri, password: changeme)
- Keycloak: http://localhost:8180/ (admin: `admin` / `admin` by default)

Local Keycloak
- The local compose file runs Keycloak on port `8180` because the backend already uses port `8080`.
- Keycloak uses the same local Postgres container as the app, but with a separate logical database named `keycloak`.
- A one-shot `keycloak-db-init` service creates the `keycloak` database if it does not exist. This works with both new and existing local Postgres volumes.
- The realm import lives in `docker/keycloak/import/alfri-realm.json` and creates realm `alfri`, public client `alfri-frontend`, ALFRI roles, and two local test users:
  - `admin@example.com` / `changeme`
  - `szathmary@stud.uniza.sk` / `changeme`

Notes and tips
- If you prefer live Angular development (hot reload), run `npm ci && ng serve` in `FE/` and set `VITE_API_BASE_URL` to `http://localhost:8080` in the dev environment.
- For Dapr local testing: install Dapr CLI (https://docs.dapr.io/getting-started/install-dapr/). Then start services with Dapr sidecars, e.g.:

```bash
# Start python service with Dapr
cd flask-server
dapr run --app-id alfri-python --app-port 5000 -- gunicorn -w 2 -b 0.0.0.0:5000 ml_service.wsgi:app

# Start backend with Dapr
# Note: backend exposes 8080 inside container; if running via docker compose you can start the backend container and then run dapr sidecar externally if desired.
dapr run --app-id alfri-backend --app-port 8080 -- java -jar /app/app.jar
```

- Do NOT commit `.env` to source control.

Troubleshooting
- If ports 8080/5000/4200/5432 are in use, stop the conflicting service or change port mappings in `docker-compose.local.yml`.
- If backend fails to connect to Postgres during first startup, ensure the DB has completed initialization; Docker Compose `depends_on` does not wait for DB readiness by default.
  You can either:
  - Wait a few seconds and restart the backend container, or
  - Use `wait-for-it` style entrypoint or customize the backend start script to wait for DB port to be available.

Contact
- For more help, tell me which step failed and paste logs from the failing container (e.g., `docker compose -f docker-compose.local.yml logs backend`).
