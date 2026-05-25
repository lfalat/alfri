"""Corrected clustering endpoints with proper subject recommendations

This module provides clustering-based subject recommendations:
- POST /api/v1/clustering/recommend - Get similar subject recommendations
- GET /api/v1/clustering/subjects/{studyProgramId} - List all subjects with clusters

The implementation requires a subjects_metadata_*.json file containing:
- Subject IDs, names, codes
- Focus vectors (12 dimensions)
- Cluster labels from pre-trained KMeans model

Generate this file using: scripts/generate_subjects_metadata.py
"""
from flask import Blueprint, request, jsonify, current_app
import math
import numpy as np
from typing import List, Dict, Any, Optional

clustering_v2_bp = Blueprint("clustering_v2", __name__)

# Focus dimension names for reference
FOCUS_DIMENSIONS = [
    "mathFocus",
    "logicFocus",
    "programmingFocus",
    "designFocus",
    "economicsFocus",
    "managementFocus",
    "hardwareFocus",
    "networkFocus",
    "dataFocus",
    "testingFocus",
    "languageFocus",
    "physicalFocus"
]


def _euclidean_distance(vec1: List[float], vec2: List[float]) -> float:
    """Calculate Euclidean distance between two vectors."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(vec1, vec2)))


def _mean_vector(vectors: List[List[float]]) -> List[float]:
    """Calculate mean of multiple vectors."""
    if not vectors:
        return []
    n = len(vectors)
    m = len(vectors[0])
    result = [0.0] * m
    for vec in vectors:
        for i in range(m):
            result[i] += vec[i]
    return [x / n for x in result]


def _get_db_manager():
    """Get database manager from app config."""
    db_manager = current_app.config.get("DB_MANAGER")
    if not db_manager:
        raise RuntimeError("Database not initialized")
    return db_manager


def _get_kmeans_model(study_program_id: int):
    """Get KMeans model from model registry."""
    registry = current_app.config.get("MODEL_REGISTRY")
    if not registry:
        raise RuntimeError("Model registry not initialized")
    return registry.get_kmeans_model(study_program_id)


def _predict_clusters(subjects: List[Dict[str, Any]], study_program_id: int) -> List[int]:
    """Predict cluster labels for subjects using KMeans model.

    Args:
        subjects: List of subject dicts with focus_vector
        study_program_id: Study program ID

    Returns:
        List of cluster labels (0-5)
    """
    kmeans_model = _get_kmeans_model(study_program_id)
    if not kmeans_model:
        raise RuntimeError(f"KMeans model not found for study program {study_program_id}")

    # Extract focus vectors and predict
    focus_vectors = np.array([s["focus_vector"] for s in subjects])
    cluster_labels = kmeans_model.predict(focus_vectors)

    return cluster_labels.tolist()


@clustering_v2_bp.route("/api/v1/clustering/recommend", methods=["POST"])
def recommend_subjects():
    """Recommend similar subjects based on selected subjects.

    Request body:
    {
        "subjectIds": [1, 5, 12],  # Selected subject IDs
        "studyProgramId": 3,        # 3=INF, 4=Management
        "maxRecommendations": 10,   # Optional, default 10
        "method": "cluster"         # Optional: "cluster" or "distance", default "cluster"
    }

    Response:
    {
        "selectedSubjects": [...],
        "centroid": [...],
        "recommendations": [
            {
                "id": 42,
                "name": "Advanced Algorithms",
                "code": "INF042",
                "abbreviation": "AA",
                "cluster_label": 2,
                "similarity_score": 0.95,
                "distance": 1.23
            },
            ...
        ]
    }
    """
    # Log incoming request for debugging
    current_app.logger.info(f"POST /api/v1/clustering/recommend - Content-Type: {request.content_type}")

    payload = request.get_json(silent=True)
    current_app.logger.debug(f"Parsed payload: {payload}")
    if not isinstance(payload, dict):
        error_msg = f"Invalid payload: expected JSON object, got {type(payload).__name__}"
        current_app.logger.warning(f"Validation error [422]: {error_msg}")
        return jsonify({"error": "Invalid payload: expected JSON object"}), 422

    subject_ids = payload.get("subjectIds")
    study_program_id = payload.get("studyProgramId")
    max_recommendations = payload.get("maxRecommendations", 10)
    method = payload.get("method", "cluster")

    # Validate inputs
    if not isinstance(subject_ids, list) or len(subject_ids) == 0:
        error_msg = f"subjectIds must be a non-empty array, got {type(subject_ids).__name__}: {subject_ids}"
        current_app.logger.warning(f"Validation error [422]: {error_msg}")
        return jsonify({"error": "subjectIds must be a non-empty array"}), 422

    if not isinstance(study_program_id, int) or study_program_id not in [3, 4]:
        error_msg = f"studyProgramId must be 3 or 4, got {type(study_program_id).__name__}: {study_program_id}"
        current_app.logger.warning(f"Validation error [422]: {error_msg}")
        return jsonify({"error": "studyProgramId must be 3 (INF) or 4 (Management)"}), 422

    if method not in ["cluster", "distance"]:
        error_msg = f"method must be 'cluster' or 'distance', got: {method}"
        current_app.logger.warning(f"Validation error [422]: {error_msg}")
        return jsonify({"error": "method must be 'cluster' or 'distance'"}), 422

    # Get database manager
    try:
        db_manager = _get_db_manager()
    except RuntimeError as e:
        return jsonify({"error": f"Database not available: {str(e)}"}), 503

    # Fetch all subjects for this study program from database
    try:
        all_subjects = db_manager.get_subjects_with_focus(study_program_id)
    except Exception as e:
        current_app.logger.error(f"Database query failed: {e}")
        return jsonify({"error": "Failed to fetch subjects from database"}), 500

    if not all_subjects:
        return jsonify({"error": f"No subjects found for study program {study_program_id}"}), 404

    # Predict cluster labels for all subjects using KMeans model
    try:
        cluster_labels = _predict_clusters(all_subjects, study_program_id)
        # Add cluster labels to subjects
        for subject, cluster_label in zip(all_subjects, cluster_labels):
            subject["cluster_label"] = int(cluster_label)
    except Exception as e:
        current_app.logger.error(f"Cluster prediction failed: {e}")
        return jsonify({"error": "Failed to predict clusters"}), 500

    # Create lookup dict
    subjects_by_id = {s["id"]: s for s in all_subjects}

    # Validate selected subjects exist
    selected_subjects = []
    for sid in subject_ids:
        if sid not in subjects_by_id:
            return jsonify({"error": f"Subject ID {sid} not found in study program {study_program_id}"}), 404
        selected_subjects.append(subjects_by_id[sid])

    # Get focus vectors and compute centroid
    selected_vectors = [s["focus_vector"] for s in selected_subjects]
    centroid = _mean_vector(selected_vectors)

    # Get clusters of selected subjects
    selected_clusters = set(s["cluster_label"] for s in selected_subjects)

    # Find candidate subjects (exclude already selected)
    candidates = [s for s in all_subjects if s["id"] not in subject_ids]

    if method == "cluster":
        # Cluster-based: only subjects in same clusters
        candidates = [s for s in candidates if s["cluster_label"] in selected_clusters]

    # Calculate distances and similarity scores
    recommendations = []
    for candidate in candidates:
        distance = _euclidean_distance(centroid, candidate["focus_vector"])
        # Similarity score: 1 / (1 + distance), ranges 0-1, higher is better
        similarity = 1.0 / (1.0 + distance)

        recommendations.append({
            "id": candidate["id"],
            "name": candidate["name"],
            "code": candidate["code"],
            "abbreviation": candidate["abbreviation"],
            "cluster_label": candidate["cluster_label"],
            "similarity_score": round(similarity, 4),
            "distance": round(distance, 4)
        })

    # Sort by similarity (descending) and limit
    recommendations.sort(key=lambda x: x["similarity_score"], reverse=True)
    recommendations = recommendations[:max_recommendations]
    response = {
        "studyProgramId": study_program_id,
        "method": method,
        "selectedSubjects": [
            {
                "id": s["id"],
                "name": s["name"],
                "code": s["code"],
                "cluster_label": s["cluster_label"]
            }
            for s in selected_subjects
        ],
        "centroid": [round(x, 2) for x in centroid],
        "selectedClusters": sorted(list(selected_clusters)),
        "recommendations": recommendations
    }
    return jsonify(response), 200


@clustering_v2_bp.route("/api/v1/clustering/subjects/<int:study_program_id>", methods=["GET"])
def get_subjects(study_program_id: int):
    """Get all subjects with their cluster assignments for a study program.

    Query params:
    - cluster: Optional filter by cluster label (e.g., ?cluster=2)

    Response:
    {
        "studyProgramId": 3,
        "nSubjects": 87,
        "nClusters": 6,
        "subjects": [...]
    }
    """
    if study_program_id not in [3, 4]:
        return jsonify({"error": "studyProgramId must be 3 (INF) or 4 (Management)"}), 400

    # Get database manager
    try:
        db_manager = _get_db_manager()
    except RuntimeError as e:
        return jsonify({"error": f"Database not available: {str(e)}"}), 503

    # Fetch subjects from database
    try:
        subjects = db_manager.get_subjects_with_focus(study_program_id)
    except Exception as e:
        current_app.logger.error(f"Database query failed: {e}")
        return jsonify({"error": "Failed to fetch subjects from database"}), 500

    if not subjects:
        return jsonify({"error": f"No subjects found for study program {study_program_id}"}), 404

    # Predict cluster labels
    try:
        cluster_labels = _predict_clusters(subjects, study_program_id)
        for subject, cluster_label in zip(subjects, cluster_labels):
            subject["cluster_label"] = int(cluster_label)
            subject["study_program_id"] = study_program_id
    except Exception as e:
        current_app.logger.error(f"Cluster prediction failed: {e}")
        return jsonify({"error": "Failed to predict clusters"}), 500

    # Optional filter by cluster
    cluster_filter = request.args.get("cluster", type=int)
    if cluster_filter is not None:
        subjects = [s for s in subjects if s["cluster_label"] == cluster_filter]

    return jsonify({
        "studyProgramId": study_program_id,
        "nSubjects": len(subjects),
        "nClusters": 6,
        "focusDimensions": FOCUS_DIMENSIONS,
        "subjects": subjects
    }), 200


@clustering_v2_bp.route("/api/v1/clustering/stats/<int:study_program_id>", methods=["GET"])
def get_clustering_stats(study_program_id: int):
    """Get clustering statistics for a study program.

    Response:
    {
        "studyProgramId": 3,
        "nSubjects": 87,
        "nClusters": 6,
        "clusterDistribution": {
            "0": 8,
            "1": 22,
            ...
        },
        "focusDimensions": [...]
    }
    """
    if study_program_id not in [3, 4]:
        return jsonify({"error": "studyProgramId must be 3 (INF) or 4 (Management)"}), 400

    # Get database manager
    try:
        db_manager = _get_db_manager()
    except RuntimeError as e:
        return jsonify({"error": f"Database not available: {str(e)}"}), 503

    # Fetch subjects from database
    try:
        subjects = db_manager.get_subjects_with_focus(study_program_id)
    except Exception as e:
        current_app.logger.error(f"Database query failed: {e}")
        return jsonify({"error": "Failed to fetch subjects from database"}), 500

    if not subjects:
        return jsonify({"error": f"No subjects found for study program {study_program_id}"}), 404

    # Predict cluster labels
    try:
        cluster_labels = _predict_clusters(subjects, study_program_id)
        for subject, cluster_label in zip(subjects, cluster_labels):
            subject["cluster_label"] = int(cluster_label)
    except Exception as e:
        current_app.logger.error(f"Cluster prediction failed: {e}")
        return jsonify({"error": "Failed to predict clusters"}), 500

    # Calculate cluster distribution
    cluster_counts = {}
    for subject in subjects:
        cluster = subject["cluster_label"]
        cluster_counts[cluster] = cluster_counts.get(cluster, 0) + 1

    return jsonify({
        "studyProgramId": study_program_id,
        "nSubjects": len(subjects),
        "nClusters": 6,
        "clusterDistribution": cluster_counts,
        "focusDimensions": FOCUS_DIMENSIONS
    }), 200

