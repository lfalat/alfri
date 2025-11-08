# ml_service - Flask service skeleton

This package provides a minimal Flask service skeleton for ML model serving.

Structure
- ml_service/: package with app factory, configs, logging, and blueprints

Quickstart (dev)

1. Create a virtualenv and install requirements:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. Run the development server:

```bash
python -m ml_service.cli
```

3. Health checks:
- GET /health/live -> 200
- GET /health/ready -> 503 until models finish loading, then 200

Config
- MODEL_MAP: optional JSON env var with a mapping of model names -> metadata
- MODE: 'dev' or 'prod'

Docker
- Build: docker build -t ml_service .
- Run: docker run -p 5000:5000 ml_service

