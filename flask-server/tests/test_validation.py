import os
import json
import pytest

os.environ.setdefault("API_KEY", "testkey")
from ml_service import create_app


class DummyRegistry:
    def get_chance_model(self, subject):
        return None


@pytest.fixture
def app():
    return create_app()


@pytest.fixture
def client(app):
    return app.test_client()


def test_validation_missing_subject_and_unknown_subject(client, app):
    # 1) malformed request: send empty JSON -> expect ValidationError from endpoint
    resp = client.post("/api/v1/predictions/passing-chance", json={}, headers={'X-API-Key': 'testkey'})
    assert resp.status_code == 400
    body = resp.get_json()
    assert "error" in body and body["error"]["code"] == "VALIDATION_ERROR"

    # 2) unknown subject: registry present but no model -> per-subject MODEL_MISSING handled inside endpoint
    with app.app_context():
        app.config["MODEL_REGISTRY"] = DummyRegistry()
    payload = {"subjects": {"unknown": [1.0, 2.0]}}
    resp2 = client.post("/api/v1/predictions/passing-chance", json=payload, headers={'X-API-Key': 'testkey'})
    assert resp2.status_code == 200
    body2 = resp2.get_json()
    assert "results" in body2
    assert "unknown" in body2["results"]
    entry = body2["results"]["unknown"]
    assert entry["status"] == 422 and entry["error"] == "MODEL_MISSING"

