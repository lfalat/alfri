import os
import json
import pytest

os.environ.setdefault("API_KEY", "testkey")
from ml_service import create_app


class DummyLogisticModel:
    def __init__(self, prob_for_subject: float):
        self._p = float(prob_for_subject)

    def predict_proba(self, X):
        return [[1.0 - self._p, self._p] for _ in X]


class DummyRegistry:
    def __init__(self, mapping):
        self._mapping = mapping

    def get_chance_model(self, subject):
        return self._mapping.get(subject)


@pytest.fixture
def app():
    return create_app()


@pytest.fixture
def client(app):
    return app.test_client()


def test_passing_chance_returns_probabilities(client, app):
    reg = DummyRegistry({
        "math101": DummyLogisticModel(0.25),
        "eng202": DummyLogisticModel(0.75),
    })
    with app.app_context():
        app.config["MODEL_REGISTRY"] = reg

    payload = {
        "subjects": {
            "math101": [1.0, 2.0, 3.0],
            "eng202": [0.5, 1.5, -0.5],
        }
    }

    resp = client.post(
        "/api/v1/predictions/passing-chance",
        json=payload,
        headers={'X-API-Key': 'testkey'},
    )

    assert resp.status_code == 200
    body = resp.get_json()
    assert "results" in body and isinstance(body["results"], dict)

    for subj in ("math101", "eng202"):
        assert subj in body["results"]
        entry = body["results"][subj]
        assert "probability" in entry and isinstance(entry["probability"], float)
        assert 0.0 <= entry["probability"] <= 1.0
        assert "percentage" in entry and isinstance(entry["percentage"], str)

