"""Quick tests for validation and error handlers using Flask test client."""
import json
from ml_service import create_app


class DummyRegistry:
    def get_chance_model(self, subject):
        return None


def run_tests():
    app = create_app()
    client = app.test_client()

    # 1) malformed request: send empty JSON
    resp = client.post("/predict/chance", data=json.dumps({}), content_type="application/json")
    print("Test 1 - missing subject status:", resp.status_code)
    print(resp.get_data(as_text=True))

    assert resp.status_code == 400, "Expected 400 for missing subject"
    body = resp.get_json()
    assert "error" in body and body["error"]["code"] == "VALIDATION_ERROR"

    # 2) unknown subject: simulate registry present but no model
    with app.app_context():
        app.config["MODEL_REGISTRY"] = DummyRegistry()
    resp2 = client.post("/predict/chance", data=json.dumps({"subject": "unknown"}), content_type="application/json")
    print("Test 2 - unknown subject status:", resp2.status_code)
    print(resp2.get_data(as_text=True))

    assert resp2.status_code == 404, "Expected 404 for unknown subject"
    body2 = resp2.get_json()
    assert "error" in body2 and body2["error"]["code"] == "SUBJECT_NOT_FOUND"


if __name__ == "__main__":
    run_tests()
    print("All tests passed")

