"""Quick test harness for clustering endpoint using Flask test client."""
from ml_service import create_app
import json

app = create_app({})
client = app.test_client()

payload = {
    "focusVectors": [
        [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.5, 0.3],
        [0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.5, 0.7],
        [0.85, 0.9, 0.95, 1.0, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
    ],
    "studyProgramId": 4,  # Management program
}
resp = client.post('/api/v1/clustering/similar-subjects', data=json.dumps(payload), content_type='application/json')
print('management status', resp.status_code, resp.get_json())

payload_inf = {
    "focusVectors": [
        [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 0.5, 0.3],
        [0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 0.5, 0.4, 0.2],
        [0.2, 0.1, 0.3, 0.5, 0.4, 0.6, 0.7, 0.8, 0.9, 0.3, 0.2, 0.1]
    ],
    "studyProgramId": 3,  # INF program
}
resp2 = client.post('/api/v1/clustering/similar-subjects', data=json.dumps(payload_inf), content_type='application/json')
print('INF status', resp2.status_code, resp2.get_json())

