# Azure Deployment Plan: Alfri

> **Status:** Phase 3 implemented - CI/CD workflows in `.github/workflows/` automate build, test, and Azure release; provisioning/deployment not yet executed pending secret rotation approval and WIF setup
>
> Generated: 2026-05-25

## 1. Project Overview

**Goal:** Make the locally working Docker application reproducibly deployable to
Azure Container Apps, with automated image publication, secure configuration,
health verification, and rollback.

**Path:** Modify and modernize an existing Azure deployment. The deployed images
predate the current local Keycloak/frontend changes, so this is not a simple
image refresh.

## 2. Confirmed Azure Context

| Attribute | Value |
| --- | --- |
| Resource group | `alfri-rg` |
| Subscription | `Azure for Students` (`28becc2a-528b-4989-8673-fdc22f5fbff7`) |
| Existing location | `norwayeast` |
| Deployment classification | Low-cost development environment |
| Reliability/cost posture | Consumption/scale-to-zero; accept cold starts and defer production HA upgrades |

Existing resources:

| Resource | Type | Finding |
| --- | --- | --- |
| `alfriregistry` | Azure Container Registry Standard | Admin auth enabled; apps pull with password secret |
| `alfri-postgres` | PostgreSQL Flexible Server `Standard_B1ms` | Public network/password auth; HA and geo backup disabled |
| `alfri-env` | Container Apps environment | Log Analytics configured; zone redundancy disabled |
| `alfri-frontend` | Container App | Currently stopped intentionally; will remain scale-to-zero when idle |
| `alfri-backend` | Container App | Currently stopped intentionally; must become internal-only |
| `alfri-ml-service` | Container App | Currently stopped intentionally; internal-only |

## 3. Components Detected Locally

| Component | Technology | Local Runtime | Azure State |
| --- | --- | --- | --- |
| Frontend | Angular + Nginx | Running on `4200` | Container App exists, config contract differs |
| Backend | Spring Boot Java 21 | Running on `8080`, health passes | Container App image is stale |
| ML API | Flask + Gunicorn/models | Running on `5000`, readiness passes | Container App exists with mutable tag |
| Authentication | Keycloak + custom event listener | Running on `8180`, healthy | Not deployed in Azure |
| Database | PostgreSQL | Local Docker DB | Managed server exists; no Keycloak DB path confirmed |

## 4. Confirmed Findings And Remediation

| Priority | Finding | Impact | Required Fix |
| --- | --- | --- | --- |
| Critical | Azure does not deploy Keycloak, while current backend and frontend require it | A deployment of current source cannot authenticate users or satisfy required backend configuration | Deploy a production-configured Keycloak app backed by PostgreSQL, or explicitly migrate authentication before deploying current source |
| Informational | Azure endpoints currently return HTTP 404 and apps report `Stopped` with zero replicas | Expected while development services are intentionally stopped | New deployment will support scale-to-zero; verification calls will cold-start services when testing |
| Critical | Cloud app settings do not match current source variables/profile | A new backend/frontend revision is expected to fail or point browsers at localhost | Define one Azure runtime contract and IaC-managed settings: backend database, ML, Keycloak, JWT; frontend API/Keycloak values |
| Critical | Plain Container App environment values are used for database/JWT settings; `BE/.env` is tracked | Credential disclosure and rotation risk | Rotate real credentials, remove tracked env secrets, add ignore coverage, provision Key Vault and secret references using managed identity |
| High | Current publishing workflow builds only backend/frontend to Docker Hub; Azure uses ACR and also needs ML/Keycloak images | Local state cannot be reproduced from CI/CD | Replace with an ACR/Container Apps release workflow that builds all required images from one commit and deploys them together |
| High | The tracked frontend entrypoint substitutes a JSON file containing literal localhost values and leaves Nginx targeting `localhost:8080` | The image builds but runtime Azure routing/configuration remains local-only | Render a container-specific browser config template and an internal-backend Nginx proxy at startup |
| High | Backend/frontend use stale March image tag; ML uses mutable `latest` last updated in January | Releases are inconsistent and rollback is unreliable | Tag every image with the same Git commit SHA; deploy by immutable tag or digest; retain revision rollback |
| High | ACR admin auth is enabled and Container Apps have no identity | Registry password compromise/pull failures on rotation | Assign managed identity and `AcrPull`; configure identity-based pulls; disable ACR admin credentials after migration |
| High | PostgreSQL is public with `AllowAzureServices`, password-only auth, no HA, minimal backup posture | Network exposure and weak credential posture; reliability is acceptable only as a development tradeoff | Enforce TLS and secret management now; retain low-cost server/backup posture unless the environment becomes production; consider private networking later |
| High | Production Keycloak realm material is local-only and includes test users/passwords | Auth redirect failure and unacceptable production accounts | Separate production realm initialization; configure HTTPS frontend redirects/origins and remove development users/passwords |
| Medium | Frontend Nginx proxies `/api` to its own `localhost:8080`; entrypoint templates different settings from Azure | API requests fail if the Nginx proxy route is used; runtime substitution is currently incomplete | Select one routing model: browser-to-public backend, or Nginx-to-internal backend using a templated backend URL |
| Medium | Backend production ML default is `http://python-service:8000`; Azure ML service is `alfri-ml-service` on port `5000` | Prediction calls fail after redeploy unless overridden correctly | Set `PYTHON_SERVICE_BASE_URL=http://alfri-ml-service` or standardize the property and internal service name |
| Medium | ML app readiness checks loaded models but not database; database startup failures are logged and ignored | Revision appears ready while clustering endpoints fail | Add dependency-aware readiness and alerts; use database connectivity settings appropriate for production |
| Medium | ML API-key protection is opt-in and currently not wired consistently | Internal ML endpoints have no application-level authorization, or break when enabled one-sidedly | Set shared secret through Key Vault references for ML and backend, or adopt managed service-to-service protection |
| High | Bundled sklearn model artifacts were serialized with `scikit-learn 1.5.0`, while the rebuilt ML image resolves `1.8.0` | Model inference may be behaviorally incompatible even though the permissive local runtime reports ready | Re-export all sklearn artifacts under one pinned runtime; set `FAIL_ON_MODEL_VERSION_MISMATCH=true` for Azure so readiness rejects incompatible artifacts until then |
| Medium | Backend only has default TCP ACA probes; ML/frontend have no explicit application-level probes | Configuration errors are not caught by readiness checks | Configure HTTP startup/readiness/liveness probes for backend and ML; provide a frontend health endpoint |
| Medium | Backend accepts CORS from any origin despite an Azure origin setting being present | Browser API exposure is broader than intended | Bind and enforce explicit allowed frontend origins, or use same-origin frontend proxy routing |
| Medium | No Key Vault or Application Insights resource is present in the resource group | Secret governance and diagnostics are limited | Add Key Vault, application telemetry, dashboards/alerts; retain Log Analytics integration |

## 5. Recommended Target Architecture

**Stack:** Azure Container Apps remains suitable for this CPU-based Docker
microservice workload. AKS is not required solely because the service performs
ML inference.

Agreed low-cost development routing:

| Component | Azure Service | Exposure |
| --- | --- | --- |
| Frontend Nginx/Angular | Container App | External HTTPS |
| Backend Spring API | Container App | Internal; reached through frontend reverse proxy |
| ML Flask service | Container App | Internal; reached only by backend |
| Keycloak | Container App | External HTTPS; reached by browser and backend |
| Application/Keycloak databases | PostgreSQL Flexible Server | Private access preferred |
| Images | Azure Container Registry | Managed-identity pulls |
| Secrets | Azure Key Vault | Managed-identity references in Container Apps |
| Logs | Existing Log Analytics | Preserve current logging; defer new Application Insights cost |

### Cost Profile

| App | Ingress | Proposed Resources | Scale |
| --- | --- | --- | --- |
| `alfri-frontend` | External | `0.25` CPU / `0.5Gi` | `min=0`, `max=1` |
| `alfri-backend` | Internal | `0.5` CPU / `1Gi` | `min=0`, `max=1` |
| `alfri-ml-service` | Internal | existing `1` CPU / `2Gi` initially | `min=0`, `max=1` |
| `alfri-keycloak` | External | `0.5` CPU / `1Gi`, increase only if startup proves insufficient | `min=0`, `max=1` |

Cold starts are accepted. Keycloak cold starts will be the most visible latency
tradeoff; its probe timings will allow for JVM startup.

## 6. Automation Recipe

**Selected for implementation proposal:** Azure Developer CLI with Bicep
infrastructure, plus GitHub Actions release automation.

Rationale:

- Azure is the only deployment target identified and the existing platform is
  already Container Apps, ACR, and PostgreSQL.
- Bicep can capture the currently manual resource configuration and role
  assignments before any update is applied.
- GitHub Actions can test and build each image once, tag it by commit SHA, push
  to ACR with federated Azure login, and deploy a coordinated revision set.

Proposed release stages:

1. CI: backend tests, frontend build/tests, ML tests, Docker builds and local
   health checks using production-shaped non-secret configuration.
2. Publish: push `frontend`, `backend`, `ml-service`, and `keycloak` images to
   ACR with one commit-SHA tag; do not deploy `latest`.
3. Provision/update: use reviewed Bicep/AZD configuration for identity, secrets,
   ingress, probes, networking, and app settings.
4. Release: deploy ML/Keycloak/backend first, verify readiness, then frontend;
   use revision labels/traffic control for rollback.
5. Verify: exercise frontend config, Keycloak discovery/login path, backend
   health and authenticated API flow, ML readiness/prediction, and database
   migration state.

## 7. Provisioning Limit Checklist

This plan reuses `alfri-env`, `alfriregistry`, `alfri-postgres`, and Log
Analytics. It creates one Container App and one Key Vault; it updates three
existing Container Apps.

| Resource Type | Number To Deploy | Total After Deployment | Limit/Quota | Evidence |
| --- | ---: | ---: | ---: | --- |
| `Microsoft.App/containerApps` in existing environment | 1 (`alfri-keycloak`) | 4 apps; proposed max active cores `2.25` initially, `2.75` if Keycloak needs `1` CPU | `100` Consumption cores in `alfri-env` | `az containerapp env list-usages`; all apps `maxReplicas=1` |
| `Microsoft.KeyVault/vaults` | 1 | 1 vault with fewer than 10 initial secrets | Operational limit of `300` secret creates per 10 seconds per vault | Existing count `0`; Microsoft Learn Key Vault service limits |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | 1 logical DB (`keycloak`) under existing server | `alfri` plus `keycloak` DB | Existing server resource is reused; no additional server compute provisioned | Child database creation only |

`az quota list` was attempted for `Microsoft.App` but `Microsoft.Quota` is not
registered in the subscription. It is unnecessary for this existing-environment
addition because the Container Apps environment reports its Consumption-core
capacity directly. If later work creates a new environment or increases scale,
register `Microsoft.Quota` as an explicit approved preflight step.

## 8. Execution Plan

Phase 1 source/configuration work is implemented. Strict Azure ML readiness now
rejects incompatible serialized model artifacts until they are normalized.
Azure resource provisioning and deployment remain gated for later approval.

### Phase 1: Make The Application Cloud-Configurable

1. Remove tracked secret material from `BE/.env`, add repository-level env
   ignores/examples, and prepare secret rotation for any value used in Azure.
2. Commit and use the frontend runtime entrypoint; template Nginx so `/api`
   proxies to `http://alfri-backend`, while browser runtime configuration uses
   `/api` and the external Keycloak URL.
3. Add a backend `azure-dev` configuration contract for PostgreSQL TLS,
   internal ML URL, Keycloak external issuer/internal management endpoint,
   webhook secret, and health endpoints. Restrict CORS because the browser will
   reach the backend through same-origin frontend routing.
4. Standardize ML production configuration and the shared backend-to-ML API
   key input, make readiness expose unusable model/database state, and provide
   an Azure-target strict model-version compatibility gate.
5. Build a Keycloak Azure image containing the event-listener provider, theme,
   and an Azure-development realm import without seeded fixed-password users.
   Configure HTTPS redirect origins for the frontend FQDN.

### Phase 2: Capture Azure Configuration As Code ✓

1. `azure.yaml` and `infra/` created. `infra/main.bicep` uses `existing`
   references for `alfri-env`, `alfriregistry`, and `alfri-postgres`; no
   existing resources are recreated.
2. `infra/modules/keyvault.bicep` creates `alfri-kv` with RBAC authorization
   and five placeholder secrets (`pg-password`, `keycloak-admin-password`,
   `keycloak-db-password`, `keycloak-webhook-secret`, `ml-api-key`).
   `infra/scripts/provision-secrets.sh` populates real values interactively
   after provisioning.
3. `infra/modules/container-apps.bicep` enables system-assigned identity on all
   four Container Apps. `infra/modules/roles.bicep` assigns `AcrPull` to all
   four and `Key Vault Secrets User` to backend, ML, and Keycloak identities.
4. `infra/main.bicep` creates the `keycloak` PostgreSQL database as a Bicep
   resource. `infra/scripts/init-keycloak-db.sh` creates the dedicated
   `keycloak` role and grants schema permissions (idempotent; run once after
   provisioning).
5. Ingress: frontend and Keycloak external; backend and ML internal. HTTP
   startup/readiness/liveness probes configured for all four apps. All apps
   set to `minReplicas=0, maxReplicas=1`.

### Phase 3: Automate Build And Release ✓

1. `docker-build-push.yml`, `angular-build.yml`, and `maven.yml` deleted.
   Replaced by `ci.yml` (all-branch gate) and `release-azure.yml` (master
   release). Azure login uses OIDC workload identity federation via
   `azure/login@v2`; no client secret stored. Run
   `infra/scripts/setup-wif.sh <org>/<repo>` once to create the service
   principal and add the three required repository secrets.
2. Both workflows run backend (Maven), frontend (npm build), and ML (pytest)
   tests as a gate before any Docker build or push.
3. `release-azure.yml` builds all four images with `${{ github.sha }}` as the
   immutable tag; smoke-checks the frontend (`/health`) and ML service
   (`/health/live`) locally before pushing to ACR. Backend and Keycloak are
   built but not started locally (require external services).
4. Bicep `what-if` preview runs before `az deployment group create`; both
   target `infra/main.bicep` with `--mode Incremental` so no existing
   resources are deleted.
5. Images are deployed in dependency order via `az containerapp update`:
   ML → Keycloak → Backend → Frontend. Each step forces `min-replicas=1`,
   polls until `latestRevisionName == latestReadyRevisionName`, runs an
   external smoke test for Keycloak (OIDC discovery) and frontend (`/health`),
   then resets `min-replicas=0`.
6. Prior revisions are never deleted. On a failed step the prior revision
   remains active. Image tags are `${{ github.sha }}`; `latest` is never
   pushed.

### Phase 4: Validate The Development Deployment

1. Re-run local Compose health checks before cloud deployment.
2. Invoke the Azure validation workflow before provisioning or deploying.
3. Test Keycloak discovery and browser login redirect, frontend asset/runtime
   configuration, frontend-proxied backend health/API access, backend-to-ML
   calls, and Liquibase/database connectivity.
4. Confirm idle services scale back to zero after tests and document cold-start
   expectations for future developers.

## 9. Planned File Changes

| Area | Files/Artifacts |
| --- | --- |
| Plan and Azure orchestration | `.azure/deployment-plan.md`, `azure.yaml`, `infra/*.bicep` |
| CI/CD | `.github/workflows/*azure*.yml` replacing Docker Hub-only publishing |
| Frontend routing/runtime config | `FE/nginx.conf`, `FE/docker-entrypoint.sh`, `FE/docker-config.template.json`, `FE/Dockerfile` |
| Backend Azure profile/security | `BE/src/main/resources/application-azure-dev.yml`, relevant configuration and health/security classes |
| ML config/readiness | `flask-server/ml_service/config.py`, readiness/database handling, Docker build inputs if needed |
| Keycloak deployment | `docker/keycloak/Dockerfile.azure-dev`, Azure-development realm import/theme packaging |
| Secret hygiene | repository ignore/example env files; removal of tracked `BE/.env` content |

## 10. Deferred Development-Environment Tradeoffs

- ACR Premium/geo-replication is not implemented for a low-cost development
  environment.
- PostgreSQL HA and geo-redundant backup are not implemented now.
- Private network integration for PostgreSQL is deferred; TLS and secret
  protection are implemented first.
- Application Insights is deferred while existing Log Analytics remains in use.
- Services are allowed to scale to zero; cold-start latency is accepted.

## 11. Verification Evidence

| Check | Result |
| --- | --- |
| Local `docker compose` services | Backend/frontend/ML/Keycloak/PostgreSQL running; Keycloak and ML healthy |
| Local ML readiness | HTTP 200 |
| Local backend actuator health | HTTP 200 |
| Local Keycloak discovery | HTTP 200 |
| Azure frontend public config URL | HTTP 404 on 2026-05-25 |
| Azure backend public health URL | HTTP 404 on 2026-05-25 |
| Azure active revisions | Provisioned/healthy but zero replicas for all three deployed apps |
| Azure Advisor | High-availability recommendations for ACR; geo-redundant backup recommendation for PostgreSQL |
| Phase 1 static/config validation | `git diff --check`, realm JSON parsing, and `docker compose -f docker-compose.local.yml config --quiet` pass |
| Phase 1 frontend | Angular production build passes with existing Sass/CommonJS/bundle budget warnings; frontend image smoke renders `/api` proxy configuration and `/health` returns HTTP 200 |
| Phase 1 backend | Backend image builds under Java 21; `mvn -B test` in a Java 21 container passes with 1 test and 0 failures |
| Phase 1 ML unit suite | Final ML image runs 20 passing tests; it emits scikit-learn version mismatch warnings for checked-in KMeans artifacts |
| Phase 1 ML strict Azure-target readiness | With `FAIL_ON_MODEL_VERSION_MISMATCH=true`, preload rejects 8 incompatible sklearn artifacts and `/health/ready` returns expected HTTP 503 |
| Phase 1 Keycloak Azure-development image | Optimized Keycloak image with provider, theme, and seed-free realm builds successfully; existing custom internal SPI warning is recorded |
| Docker build context cleanup | Frontend context is about 20 kB and final ML context about 25 kB, excluding local dependency artifacts |
| Phase 2 Bicep compilation | `az bicep build` passes with zero errors on `main.bicep` and all three modules (`keyvault.bicep`, `container-apps.bicep`, `roles.bicep`) |
| Phase 2 static structure | `azure.yaml` maps four services to Container Apps; `infra/main.bicep` produces required AZD outputs (`SERVICE_*_NAME`, `AZURE_CONTAINER_REGISTRY_ENDPOINT`, `AZURE_KEY_VAULT_ENDPOINT`) |
| Phase 3 workflow structure | `ci.yml` (all branches) and `release-azure.yml` (master) created; three old workflows deleted; YAML is syntactically valid |
| Phase 3 WIF setup script | `infra/scripts/setup-wif.sh` creates app registration, federated credential, AcrPush + Contributor role assignments |
| sklearn model artifact normalization | `flask-server/requirements.txt` pinned to `scikit-learn==1.5.0`; 3 MODEL_MAP artifacts re-serialized (modelovanie_a_simulacia, principy_operacnych_systemov, vyvoj_aplikacii_internet_intranet); orphan MAS-pass-predict.pkl not in MODEL_MAP and left as-is; with `FAIL_ON_MODEL_VERSION_MISMATCH=true` container reports `models: ready` (HTTP 200 on /health/ready pending database) |

## 12. References

- https://learn.microsoft.com/azure/container-apps/github-actions
- https://learn.microsoft.com/azure/container-apps/managed-identity-image-pull
- https://learn.microsoft.com/azure/container-apps/connect-apps
- https://learn.microsoft.com/azure/container-apps/health-probes
- https://learn.microsoft.com/azure/container-apps/manage-secrets
- https://learn.microsoft.com/azure/postgresql/security/security-overview
- https://learn.microsoft.com/azure/postgresql/high-availability/concepts-high-availability
- https://www.keycloak.org/server/containers
- https://www.keycloak.org/server/importExport
