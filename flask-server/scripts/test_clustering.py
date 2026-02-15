"""Quick test harness for clustering endpoint using Flask test client."""
from ml_service import create_app
import json

app = create_app({})
client = app.test_client()

payload = {
    "focusVectors": [[0.1, 0.2], [0.9, 0.8], [0.85, 0.9]],
    "studyProgramId": "management-program",
}
resp = client.post('/api/v1/clustering/similar-subjects', data=json.dumps(payload), content_type='application/json')
print('management status', resp.status_code, resp.get_json())

payload_inf = {
    "focusVectors": [[0.1, 0.2], [0.15, 0.25], [0.2, 0.1]],
    "studyProgramId": "INF101",
}
resp2 = client.post('/api/v1/clustering/similar-subjects', data=json.dumps(payload_inf), content_type='application/json')
print('INF status', resp2.status_code, resp2.get_json())

