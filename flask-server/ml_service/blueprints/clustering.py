"""Clustering endpoints

Provides:
- POST /api/v1/clustering/similar-subjects

Payload: {"focusVectors": [[...], [...], ...], "studyProgramId": int, "n_clusters": optional int}

Returns JSON: {"cluster_indices": [0,1,1,...], "centroid": [...], "offset_applied": 0}

Uses pre-trained kmeans models based on studyProgramId:
- studyProgramId 3 -> kmeans_model.pkl (INF program, no offset)
- studyProgramId 4 -> kmeans_model_manazment.pkl (Management program, +87 offset)
"""
from flask import Blueprint, request, jsonify
import math
import random
import joblib
import os
import numpy as np

clustering_bp = Blueprint("clustering", __name__)


def _validate_numeric_vector(v):
    if not isinstance(v, (list, tuple)):
        return False
    if len(v) == 0:
        return False
    for x in v:
        try:
            float(x)
        except Exception:
            return False
    return True


def _mean_vector(vectors):
    # assumes non-empty and consistent lengths
    n = len(vectors)
    m = len(vectors[0])
    out = [0.0] * m
    for vec in vectors:
        for i, val in enumerate(vec):
            out[i] += float(val)
    return [x / float(n) for x in out]


def _euclidean(a, b):
    return math.sqrt(sum((float(x) - float(y)) ** 2 for x, y in zip(a, b)))


def _kmeans(vectors, k=2, max_iter=100):
    # vectors: list of lists of floats
    n = len(vectors)
    if n == 0:
        return [], []
    m = len(vectors[0])
    # initialize centroids: choose k distinct random vectors (or repeated if less)
    k = max(1, min(k, n))
    seeds = random.sample(range(n), k) if n >= k else [0] * k
    centroids = [list(vectors[i]) for i in seeds]

    labels = [0] * n
    for _ in range(max_iter):
        changed = False
        # assign
        for idx, v in enumerate(vectors):
            best = 0
            best_d = _euclidean(v, centroids[0])
            for ci in range(1, k):
                d = _euclidean(v, centroids[ci])
                if d < best_d:
                    best_d = d
                    best = ci
            if labels[idx] != best:
                labels[idx] = best
                changed = True
        # recompute centroids
        new_centroids = [[0.0] * m for _ in range(k)]
        counts = [0] * k
        for idx, lab in enumerate(labels):
            counts[lab] += 1
            for j in range(m):
                new_centroids[lab][j] += float(vectors[idx][j])
        for ci in range(k):
            if counts[ci] == 0:
                # re-seed empty centroid with a random vector
                new_centroids[ci] = list(vectors[random.randrange(0, n)])
            else:
                new_centroids[ci] = [x / float(counts[ci]) for x in new_centroids[ci]]
        centroids = new_centroids
        if not changed:
            break
    return labels, centroids


@clustering_bp.route("/api/v1/clustering/similar-subjects", methods=["POST"])
def similar_subjects():
    """Find similar subject clusters for provided focus vectors using pre-trained models.

    Required payload keys:
    - focusVectors: array of numeric vectors (list of lists)
    - studyProgramId: integer (3 for INF, 4 for Management)
    Optional:
    - n_clusters: int (ignored when using pre-trained models)
    """
    payload = request.get_json(silent=True)
    if not isinstance(payload, dict):
        return jsonify({"error": "Invalid payload: expected JSON object"}), 422

    focus = payload.get("focusVectors")
    study_program_id = payload.get("studyProgramId")

    if not isinstance(focus, (list, tuple)) or len(focus) == 0:
        return jsonify({"error": "focusVectors must be a non-empty array of numeric vectors"}), 422

    # Validate studyProgramId is an integer
    if not isinstance(study_program_id, int):
        try:
            study_program_id = int(study_program_id)
        except (TypeError, ValueError):
            return jsonify({"error": "studyProgramId must be an integer (3 for INF, 4 for Management)"}), 422

    # Validate studyProgramId value
    if study_program_id not in [3, 4]:
        return jsonify({"error": "studyProgramId must be 3 (INF) or 4 (Management)"}), 422

    # validate vectors and ensure consistent dimensions
    dims = None
    vectors = []
    for v in focus:
        if not _validate_numeric_vector(v):
            return jsonify({"error": "Each focus vector must be a non-empty list of numeric values"}), 422
        if dims is None:
            dims = len(v)
        elif len(v) != dims:
            return jsonify({"error": "All focus vectors must have the same dimensionality"}), 422
        vectors.append([float(x) for x in v])

    # Determine which model to use based on studyProgramId
    # studyProgramId 3 -> INF program -> kmeans_model.pkl
    # studyProgramId 4 -> Management program -> kmeans_model_manazment.pkl
    model_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "models")

    if study_program_id == 3:
        model_path = os.path.join(model_dir, "kmeans_model.pkl")
        offset = 0  # No offset for INF program
    else:  # study_program_id == 4
        model_path = os.path.join(model_dir, "kmeans_model_manazment.pkl")
        offset = 87  # +87 offset for Management program

    # Load the pre-trained kmeans model
    try:
        kmeans_model = joblib.load(model_path)
    except FileNotFoundError:
        return jsonify({"error": f"Model file not found: {model_path}"}), 500
    except Exception as e:
        return jsonify({"error": f"Failed to load model: {str(e)}"}), 500

    # Convert vectors to numpy array for prediction
    try:
        vectors_array = np.array(vectors)

        # Predict cluster labels using the pre-trained model
        labels = kmeans_model.predict(vectors_array)

        # Apply offset based on study program
        adjusted = [int(label) + offset for label in labels]

        # Compute centroid (mean of focus vectors)
        centroid = _mean_vector(vectors)

        # ensure non-empty integer array as acceptance criteria
        if not adjusted:
            return jsonify({"error": "No cluster indices produced"}), 500

        return jsonify({
            "studyProgramId": study_program_id,
            "offset_applied": offset,
            "cluster_indices": adjusted,
            "centroid": [float(x) for x in centroid],
        }), 200

    except Exception as e:
        return jsonify({"error": f"Prediction failed: {str(e)}"}), 500
