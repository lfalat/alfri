import os
import json
import pytest

os.environ.setdefault("API_KEY", "testkey")
from ml_service import create_app


@pytest.fixture
def app():
    return create_app()


@pytest.fixture
def client(app):
    return app.test_client()


def test_clustering_management_and_inf(client):
    payload = {
        "focusVectors": [[0.1] * 12, [0.9] * 12, [0.85] * 12],
        "studyProgramId": 4,
    }
    r = client.post('/api/v1/clustering/similar-subjects', json=payload, headers={'X-API-Key': 'testkey'})
    assert r.status_code == 200
    body = r.get_json()
    assert body.get('studyProgramId') == 4
    assert isinstance(body.get('cluster_indices'), list)
    assert 'offset_applied' in body

    payload_inf = {
        "focusVectors": [[0.1] * 12, [0.15] * 12, [0.2] * 12],
        "studyProgramId": 3,
    }
    r2 = client.post('/api/v1/clustering/similar-subjects', json=payload_inf, headers={'X-API-Key': 'testkey'})
    assert r2.status_code == 200
    b2 = r2.get_json()
    assert b2.get('studyProgramId') == 3
    assert isinstance(b2.get('cluster_indices'), list)
