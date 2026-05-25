# Azure Deployment Plan: Alfri

> **Status:** Planning - diagnostic analysis complete; implementation not approved
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
| Subscription ID | `28becc2a-528b-4989-8673-fdc22f5fbff7` |
| Existing location | `norwayeast` |
| Deployment classification | Requires user confirmation: development/demo or production |
| Reliability/cost posture | Requires user confirmation |

Existing resources:

| Resource | Type | Finding |
| --- | --- | --- |
| `alfriregistry` | Azure Container Registry Standard | Admin auth enabled; apps pull with password secret |
| `alfri-postgres` | PostgreSQL Flexible Server `Standard_B1ms` | Public network/password auth; HA and geo backup disabled |
| `alfri-env` | Container Apps environment | Log Analytics configured; zone redundancy disabled |
| `alfri-frontend` | Container App | Provisioned revision, zero replicas, public URL returns HTTP 404 |
| `alfri-backend` | Container App | Provisioned revision, zero replicas, public health URL returns HTTP 404 |
| `alfri-ml-service` | Container App | Internal app, zero replicas, configured to scale to zero |

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
| Critical | Azure endpoints currently return HTTP 404 and apps report `Stopped` with zero replicas | Application is not usable in Azure now | After configuration remediation, start/redeploy apps and verify endpoints; confirm whether stop was intentional for cost control |
| Critical | Cloud app settings do not match current source variables/profile | A new backend/frontend revision is expected to fail or point browsers at localhost | Define one Azure runtime contract and IaC-managed settings: backend database, ML, Keycloak, JWT; frontend API/Keycloak values |
| Critical | Plain Container App environment values are used for database/JWT settings; `BE/.env` is tracked | Credential disclosure and rotation risk | Rotate real credentials, remove tracked env secrets, add ignore coverage, provision Key Vault and secret references using managed identity |
| High | Current publishing workflow builds only backend/frontend to Docker Hub; Azure uses ACR and also needs ML/Keycloak images | Local state cannot be reproduced from CI/CD | Replace with an ACR/Container Apps release workflow that builds all required images from one commit and deploys them together |
| High | `FE/docker-entrypoint.sh` is required by the tracked Dockerfile but is not tracked | A clean CI checkout cannot build the current frontend image | Commit the runtime entrypoint with the associated frontend changes |
| High | Backend/frontend use stale March image tag; ML uses mutable `latest` last updated in January | Releases are inconsistent and rollback is unreliable | Tag every image with the same Git commit SHA; deploy by immutable tag or digest; retain revision rollback |
| High | ACR admin auth is enabled and Container Apps have no identity | Registry password compromise/pull failures on rotation | Assign managed identity and `AcrPull`; configure identity-based pulls; disable ACR admin credentials after migration |
| High | PostgreSQL is public with `AllowAzureServices`, password-only auth, no HA, minimal backup posture | Network exposure, weak credential posture, and material outage/data-recovery risk | Use private networking or tightly scoped connectivity; require TLS validation; choose HA/geo-backup/retention based on production requirements |
| High | Production Keycloak realm material is local-only and includes test users/passwords | Auth redirect failure and unacceptable production accounts | Separate production realm initialization; configure HTTPS frontend redirects/origins and remove development users/passwords |
| Medium | Frontend Nginx proxies `/api` to its own `localhost:8080`; entrypoint templates different settings from Azure | API requests fail if the Nginx proxy route is used; runtime substitution is currently incomplete | Select one routing model: browser-to-public backend, or Nginx-to-internal backend using a templated backend URL |
| Medium | Backend production ML default is `http://python-service:8000`; Azure ML service is `alfri-ml-service` on port `5000` | Prediction calls fail after redeploy unless overridden correctly | Set `PYTHON_SERVICE_BASE_URL=http://alfri-ml-service` or standardize the property and internal service name |
| Medium | ML app readiness checks loaded models but not database; database startup failures are logged and ignored | Revision appears ready while clustering endpoints fail | Add dependency-aware readiness and alerts; use database connectivity settings appropriate for production |
| Medium | ML API-key protection is opt-in and currently not wired consistently | Internal ML endpoints have no application-level authorization, or break when enabled one-sidedly | Set shared secret through Key Vault references for ML and backend, or adopt managed service-to-service protection |
| Medium | Backend only has default TCP ACA probes; ML/frontend have no explicit application-level probes | Configuration errors are not caught by readiness checks | Configure HTTP startup/readiness/liveness probes for backend and ML; provide a frontend health endpoint |
| Medium | Backend accepts CORS from any origin despite an Azure origin setting being present | Browser API exposure is broader than intended | Bind and enforce explicit allowed frontend origins, or use same-origin frontend proxy routing |
| Medium | No Key Vault or Application Insights resource is present in the resource group | Secret governance and diagnostics are limited | Add Key Vault, application telemetry, dashboards/alerts; retain Log Analytics integration |

## 5. Recommended Target Architecture

**Stack:** Azure Container Apps remains suitable for this CPU-based Docker
microservice workload. AKS is not required solely because the service performs
ML inference.

Recommended secure routing:

| Component | Azure Service | Exposure |
| --- | --- | --- |
| Frontend Nginx/Angular | Container App | External HTTPS |
| Backend Spring API | Container App | Internal; reached through frontend reverse proxy |
| ML Flask service | Container App | Internal; reached only by backend |
| Keycloak | Container App | External HTTPS; reached by browser and backend |
| Application/Keycloak databases | PostgreSQL Flexible Server | Private access preferred |
| Images | Azure Container Registry | Managed-identity pulls |
| Secrets | Azure Key Vault | Managed-identity references in Container Apps |
| Logs/metrics/traces | Log Analytics + Application Insights | Centralized diagnostics and alerts |

Alternative: keep the backend external and configure strict CORS if the SPA must
call it directly. This is simpler but exposes an additional public endpoint.

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

## 7. Execution Gate And Pending Decisions

No deployment or application remediation has been performed.

Before artifacts can be generated and validated, confirm:

1. Is `alfri-rg` intended for production, or is it a low-cost development/demo environment?
2. Should Azure run Keycloak to match local behavior, or should authentication be replaced with a managed identity provider as a separate migration?
3. Should the backend be internal behind the frontend proxy (recommended), or remain a public API?

After those answers, this plan must be finalized with resource quantities,
subscription/location confirmation, policy and quota checks, then approved
before execution.

## 8. Verification Evidence

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

## 9. References

- https://learn.microsoft.com/azure/container-apps/github-actions
- https://learn.microsoft.com/azure/container-apps/managed-identity-image-pull
- https://learn.microsoft.com/azure/container-apps/connect-apps
- https://learn.microsoft.com/azure/container-apps/health-probes
- https://learn.microsoft.com/azure/container-apps/manage-secrets
- https://learn.microsoft.com/azure/postgresql/security/security-overview
- https://learn.microsoft.com/azure/postgresql/high-availability/concepts-high-availability
