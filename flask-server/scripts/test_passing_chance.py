"""Quick test for /api/v1/predictions/passing-chance endpoint.

Creates an app, injects a dummy registry with simple models that implement
predict_proba, then calls the endpoint with two subjects and prints/asserts
that numeric probabilities are returned in the expected shape.
"""
import json
import os
import sys

# Make sure the project root is on sys.path so `ml_service` imports work when
# running this script directly from the repository root.
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from ml_service import create_app


class DummyLogisticModel:
    def __init__(self, prob_for_subject: float):
        # probability returned for class 1
        self._p = float(prob_for_subject)

    def predict_proba(self, X):
        # Return shape (n_samples, 2)
        return [[1.0 - self._p, self._p] for _ in X]


class DummyRegistry:
    def __init__(self, mapping):
        # mapping: subject -> model
        self._mapping = mapping

    def get_chance_model(self, subject):
        return self._mapping.get(subject)


def run_test():
    app = create_app()
    client = app.test_client()

    # Prepare registry with two dummy models
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
        data=json.dumps(payload),
        content_type="application/json",
    )

    print("Status code:", resp.status_code)
    body = resp.get_json()
    print("Body:", json.dumps(body, indent=2))

    assert resp.status_code == 200, "Expected 200 response"
    assert "results" in body and isinstance(body["results"], dict)

    for subj in ("math101", "eng202"):
        assert subj in body["results"], f"Missing results for {subj}"
        entry = body["results"][subj]
        assert "probability" in entry and isinstance(entry["probability"], float)
        p = entry["probability"]
        assert 0.0 <= p <= 1.0, f"Probability out of range for {subj}: {p}"
        assert "percentage" in entry and isinstance(entry["percentage"], str)

    print("Test passed: received numeric probabilities for both subjects")


if __name__ == "__main__":
    run_test()
