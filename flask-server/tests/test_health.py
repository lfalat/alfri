from flask import Flask

from ml_service.blueprints.health import health_bp


def _client(models_ready=False, database_ready=False):
    app = Flask(__name__)
    app.config.update(MODELS_LOADED=models_ready, DATABASE_READY=database_ready)
    app.register_blueprint(health_bp)
    return app.test_client()


def test_readiness_requires_models_and_database():
    response = _client(models_ready=True, database_ready=False).get("/health/ready")

    assert response.status_code == 503
    assert response.get_json() == {
        "status": "not ready",
        "models": "ready",
        "database": "not ready",
    }


def test_readiness_is_successful_when_dependencies_are_ready():
    response = _client(models_ready=True, database_ready=True).get("/health/ready")

    assert response.status_code == 200
    assert response.get_json()["status"] == "ready"
