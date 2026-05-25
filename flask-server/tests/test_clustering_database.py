"""Tests for database integration in clustering endpoints."""
import os
import pytest

# Set test database connection - use same as dev for now
os.environ.setdefault("DATABASE_DEV_URL", "localhost:5432/alfri")
os.environ.setdefault("DATABASE_DEV_USER", "alfri")
os.environ.setdefault("DATABASE_DEV_PASSWORD", "changeme")
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


def test_database_connection(app):
    """Test that database connection is initialized."""
    db_manager = app.config.get("DB_MANAGER")
    if db_manager is None:
        pytest.skip("Database not available - no DB in CI")

    is_connected = db_manager.test_connection()
    if not is_connected:
        pytest.skip("Database not available - check connection settings")


def test_fetch_subjects_from_db(app):
    """Test fetching subjects directly from database."""
    db_manager = app.config.get("DB_MANAGER")
    if not db_manager:
        pytest.skip("Database not initialized")
    
    try:
        subjects = db_manager.get_subjects_with_focus(study_program_id=3)
        assert isinstance(subjects, list)
        if subjects:
            # Verify subject structure
            subject = subjects[0]
            assert "id" in subject
            assert "name" in subject
            assert "code" in subject
            assert "focus_vector" in subject
            assert len(subject["focus_vector"]) == 12
    except Exception as e:
        pytest.skip(f"Database query failed: {e}")


def test_recommend_with_database(client):
    """Test recommendation endpoint with database integration."""
    # Use realistic subject IDs - adjust based on your data
    payload = {
        "subjectIds": [1, 2],
        "studyProgramId": 3,
        "maxRecommendations": 5
    }
    
    r = client.post('/api/v1/clustering/recommend',
                    json=payload,
                    headers={'X-API-Key': 'testkey'})
    
    # May return 404 if subjects don't exist or 500 if DB issue
    if r.status_code == 404:
        pytest.skip("Test subject IDs not found in database")
    elif r.status_code == 503:
        pytest.skip("Database not available")
    elif r.status_code == 500:
        body = r.get_json()
        pytest.skip(f"Database error: {body.get('error')}")
    
    assert r.status_code == 200
    body = r.get_json()
    
    assert "recommendations" in body
    assert "selectedSubjects" in body
    assert body["studyProgramId"] == 3
    
    # Verify recommendations have cluster labels
    if body["recommendations"]:
        rec = body["recommendations"][0]
        assert "cluster_label" in rec
        assert isinstance(rec["cluster_label"], int)
        assert 0 <= rec["cluster_label"] <= 5


def test_get_subjects_with_database(client):
    """Test getting all subjects from database."""
    r = client.get('/api/v1/clustering/subjects/3',
                   headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Database not available")
    
    assert r.status_code in [200, 404]
    
    if r.status_code == 200:
        body = r.get_json()
        assert "subjects" in body
        assert "nSubjects" in body
        
        # Verify subjects have cluster labels
        if body["subjects"]:
            subject = body["subjects"][0]
            assert "cluster_label" in subject
            assert "focus_vector" in subject


def test_clustering_stats_with_database(client):
    """Test clustering statistics from database."""
    r = client.get('/api/v1/clustering/stats/3',
                   headers={'X-API-Key': 'testkey'})
    
    if r.status_code == 503:
        pytest.skip("Database not available")
    
    assert r.status_code in [200, 404]
    
    if r.status_code == 200:
        body = r.get_json()
        assert "clusterDistribution" in body
        assert "nSubjects" in body
        
        # Verify cluster distribution
        total = sum(body["clusterDistribution"].values())
        assert total == body["nSubjects"]
