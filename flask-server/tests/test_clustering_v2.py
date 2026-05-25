"""Tests for the corrected clustering_v2 endpoints."""
import os
import pytest

os.environ.setdefault("API_KEY", "testkey")
from ml_service import create_app

CLUSTERING_MODEL_MAP = {
    "kmeans_model": {"type": "kmeans", "path": "kmeans_model.pkl", "studyProgramId": 3},
    "kmeans_model_manazment": {"type": "kmeans", "path": "kmeans_model_manazment.pkl", "studyProgramId": 4},
}


@pytest.fixture
def app():
    return create_app({
        "LOAD_MODELS_ON_STARTUP": True,
        "LOAD_MODELS_SYNCHRONOUSLY": True,
        "MODEL_MAP": CLUSTERING_MODEL_MAP,
    })


@pytest.fixture
def client(app):
    return app.test_client()


def test_recommend_subjects_basic(client):
    """Test basic subject recommendation endpoint."""
    payload = {
        "subjectIds": [1, 2],
        "studyProgramId": 3,
        "maxRecommendations": 5
    }
    
    r = client.post('/api/v1/clustering/recommend', 
                    json=payload, 
                    headers={'X-API-Key': 'testkey'})
    
    # May return 503 if metadata file or database is not available in this environment
    if r.status_code == 503:
        pytest.skip("Service unavailable in CI (no DB or metadata) - skipping")
        return
    
    assert r.status_code == 200
    body = r.get_json()
    
    assert body["studyProgramId"] == 3
    assert "recommendations" in body
    assert "selectedSubjects" in body
    assert "centroid" in body
    assert len(body["recommendations"]) <= 5
    
    # Check recommendation structure
    if body["recommendations"]:
        rec = body["recommendations"][0]
        assert "id" in rec
        assert "name" in rec
        assert "similarity_score" in rec
        assert "cluster_label" in rec


def test_recommend_subjects_distance_method(client):
    """Test distance-based recommendation method."""
    payload = {
        "subjectIds": [1],
        "studyProgramId": 3,
        "method": "distance",
        "maxRecommendations": 3
    }
    
    r = client.post('/api/v1/clustering/recommend',
                    json=payload,
                    headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Metadata file not generated yet")
        return
    
    assert r.status_code == 200
    body = r.get_json()
    assert body["method"] == "distance"


def test_recommend_invalid_study_program(client):
    """Test with invalid study program ID."""
    payload = {
        "subjectIds": [1],
        "studyProgramId": 99
    }
    
    r = client.post('/api/v1/clustering/recommend',
                    json=payload,
                    headers={'X-API-Key': 'testkey'})
    
    assert r.status_code == 422
    body = r.get_json()
    assert "error" in body


def test_recommend_empty_subjects(client):
    """Test with empty subject IDs list."""
    payload = {
        "subjectIds": [],
        "studyProgramId": 3
    }
    
    r = client.post('/api/v1/clustering/recommend',
                    json=payload,
                    headers={'X-API-Key': 'testkey'})
    
    assert r.status_code == 422


def test_get_subjects_list(client):
    """Test getting all subjects for a study program."""
    r = client.get('/api/v1/clustering/subjects/3',
                   headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Metadata file not generated yet")
        return
    
    assert r.status_code == 200
    body = r.get_json()
    
    assert body["studyProgramId"] == 3
    assert "subjects" in body
    assert "nSubjects" in body
    assert "nClusters" in body
    assert "focusDimensions" in body


def test_get_subjects_by_cluster(client):
    """Test filtering subjects by cluster."""
    r = client.get('/api/v1/clustering/subjects/3?cluster=2',
                   headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Metadata file not generated yet")
        return
    
    assert r.status_code == 200
    body = r.get_json()
    
    # All returned subjects should be in cluster 2
    for subject in body["subjects"]:
        assert subject["cluster_label"] == 2


def test_get_clustering_stats(client):
    """Test clustering statistics endpoint."""
    r = client.get('/api/v1/clustering/stats/3',
                   headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Metadata file not generated yet")
        return
    
    assert r.status_code == 200
    body = r.get_json()
    
    assert body["studyProgramId"] == 3
    assert "clusterDistribution" in body
    assert "nClusters" in body
    assert body["nClusters"] == 6
    
    # Check cluster distribution sums to total subjects
    total = sum(body["clusterDistribution"].values())
    assert total == body["nSubjects"]
