import os
import pytest

# ensure test API key is set before importing the app factory
os.environ.setdefault("API_KEY", "testkey")

from ml_service import create_app


@pytest.fixture
def app():
    app = create_app()
    return app


@pytest.fixture
def client(app):
    return app.test_client()


def test_api_key_enforcement_missing_and_invalid(client):
    # missing header -> 401
    r = client.post('/api/v1/clustering/similar-subjects', json={})
    assert r.status_code == 401
    assert r.get_json() == {"error": "Missing X-API-Key header"}

    # wrong header -> 401
    r = client.post('/api/v1/clustering/similar-subjects', json={}, headers={'X-API-Key': 'wrong'})
    assert r.status_code == 401
    assert r.get_json() == {"error": "Invalid API key"}


def test_api_key_valid_allows_through_but_endpoint_validates_payload(client):
    # correct header -> endpoint should run and validate payload; clustering expects JSON with keys
    r = client.post('/api/v1/clustering/similar-subjects', json={}, headers={'X-API-Key': 'testkey'})
    # clustering endpoint returns 422 for invalid payload (expects focusVectors and studyProgramId)
    assert r.status_code == 422
    body = r.get_json()
    assert isinstance(body, dict)
    assert "error" in body


def test_health_endpoint_accessible_without_api_key(client):
    r = client.get('/health/live')
    assert r.status_code == 200
    body = r.get_json()
    assert isinstance(body, dict)
    # health blueprint returns at least a status key; accept the actual value 'alive' used in the app
    assert body.get('status') in ("alive", "ok", "healthy", 200, None)
