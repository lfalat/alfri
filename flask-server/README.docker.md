This project: Docker build & run instructions

This file explains how to build and run the ml_service container locally and verify the health endpoints.

Prerequisites
- Docker Engine (docker) installed and running on your machine
- (Optional) docker-compose if you prefer compose

Build image

```bash
# from project root
docker build -t ml_service_test:latest .
```

Run container (foreground)

```bash
# Run, mapping port 5000 from container to host
docker run --rm -p 5000:5000 --name ml_service_test ml_service_test:latest
```

Run container (background)

```bash
docker run -d --rm -p 5000:5000 --name ml_service_test ml_service_test:latest
```

Smoke tests (from host)

```bash
# /health/live should return 200
curl -i http://127.0.0.1:5000/health/live

# /health/ready may return 200 or 503 depending on model loading; 200 means models loaded successfully
curl -i http://127.0.0.1:5000/health/ready
```

Notes
- The Dockerfile creates a non-root user `app` and runs Gunicorn with 2 workers.
- A Docker HEALTHCHECK is configured to probe `/health/live`.
- If your models require system packages (e.g. for TensorFlow), add them to the Dockerfile before pip installs. The current image installs build-essential and gcc for building wheels, but removes them afterward to keep the image small.

If you want me to add a `docker-compose.yml` for development convenience or to adjust the number of workers or user, tell me the preferred settings and I will add it.

