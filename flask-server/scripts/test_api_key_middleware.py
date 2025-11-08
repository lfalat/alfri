# Simple script to test API key middleware
import os
os.environ['API_KEY'] = 'testkey'

from ml_service import create_app

app = create_app()
print('Configured API_KEYS:', app.config.get('API_KEYS'))

with app.test_client() as client:
    r = client.post('/api/v1/clustering/similar-subjects', json={})
    print('No header ->', r.status_code, r.get_json())

    r = client.post('/api/v1/clustering/similar-subjects', json={}, headers={'X-API-Key': 'wrong'})
    print('Wrong header ->', r.status_code, r.get_json())

    r = client.post('/api/v1/clustering/similar-subjects', json={}, headers={'X-API-Key': 'testkey'})
    print('Correct header ->', r.status_code, r.get_json())

    # health endpoint should be accessible without API key
    r = client.get('/health/live')
    print('GET /health/live ->', r.status_code, r.get_json())

