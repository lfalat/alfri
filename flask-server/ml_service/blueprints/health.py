"""Health endpoints blueprint

Provides:
- GET /health/live -> 200 always
- GET /health/ready -> 200 when models and the database are ready, 503 otherwise
"""
from flask import Blueprint, current_app, jsonify

health_bp = Blueprint("health", __name__)


@health_bp.route("/health/live", methods=["GET"])
def live():
    return jsonify({"status": "alive"}), 200


@health_bp.route("/health/ready", methods=["GET"])
def ready():
    models_ready = current_app.config.get("MODELS_LOADED", False)
    database_ready = current_app.config.get("DATABASE_READY", False)
    state = {
        "status": "ready" if models_ready and database_ready else "not ready",
        "models": "ready" if models_ready else "not ready",
        "database": "ready" if database_ready else "not ready",
    }
    return jsonify(state), 200 if models_ready and database_ready else 503
