"""Prediction endpoints.

Provides REST API endpoints for passing chance and passing mark predictions.
This module acts as the request handler layer, delegating business logic to
service classes.
"""
from flask import Blueprint, request, current_app, jsonify

from ..validation import SubjectInputValidator
from ..errors import ModelNotLoadedError, ValidationError
from ..services import PassingChancePredictor, PassingMarkPredictor

predict_bp = Blueprint("predict", __name__)


# ============================================================================
# Flask Endpoints - Request Handler Layer
# ============================================================================


@predict_bp.route("/api/v1/predictions/passing-chance", methods=["POST"])
def predict_passing_chance():
    """Batch passing chance predictions using logistic models.

    This endpoint processes multiple subjects in a single request and returns
    individual predictions or error messages for each subject.

    Expected JSON:
        {
            "subjects": {
                "subject_name_1": [feature1, feature2, ...],
                "subject_name_2": [feature1, feature2, ...]
            }
        }

    Returns JSON:
        {
            "results": {
                "subject_name_1": {
                    "probability": 0.85,
                    "percentage": "85.00%"
                },
                "subject_name_2": {
                    "status": 422,
                    "error": "MODEL_MISSING",
                    "message": "No chance model for subject 'subject_name_2'"
                }
            }
        }

    Raises:
        ValidationError: If payload structure is invalid
        ModelNotLoadedError: If model registry is not available
    """
    # Validate request payload
    payload = request.get_json(silent=True)
    if not isinstance(payload, dict):
        raise ValidationError("Invalid payload: expected JSON object with 'subjects' mapping")

    subjects_map = payload.get("subjects")
    if not isinstance(subjects_map, dict):
        raise ValidationError("Missing or invalid 'subjects' field; expected mapping of subject->feature list")

    # Get model registry
    registry = current_app.config.get("MODEL_REGISTRY")
    if registry is None:
        raise ModelNotLoadedError("Model registry not available")

    # Initialize service and process predictions
    validator = SubjectInputValidator(min_len=1, max_len=128)
    predictor = PassingChancePredictor(registry, validator)

    results = {
        subject: predictor.predict_single_subject(subject, features)
        for subject, features in subjects_map.items()
    }

    return jsonify({"results": results}), 200


@predict_bp.route("/api/v1/predictions/passing-mark", methods=["POST"])
def predict_passing_mark():
    """Predict grade distribution using a Keras neural network model.

    This endpoint predicts the probability distribution across different grade
    categories for a given subject and returns the most likely grade.

    Expected JSON:
        {
            "subject": "subject_name",
            "features": [feature1, feature2, ...]
        }

    Returns JSON:
        {
            "subject": "subject_name",
            "distribution": {
                "A": 0.05,
                "B": 0.75,
                "C": 0.15,
                "D": 0.03,
                "E": 0.02,
                "F": 0.00
            },
            "chosenGrade": "B"
        }

    Thread Safety:
        Uses MODEL_REGISTRY.keras_predict_lock when available to serialize
        concurrent Keras predict calls, preventing potential threading issues
        with TensorFlow/Keras backends.

    Raises:
        ValidationError: If payload, subject, or features are invalid
        ModelNotLoadedError: If model registry is not available
    """
    # Validate request payload
    payload = request.get_json(silent=True)
    if not isinstance(payload, dict):
        raise ValidationError("Invalid payload: expected JSON object with 'subject' and 'features'")

    subject = payload.get("subject")
    features = payload.get("features")

    # Get model registry
    registry = current_app.config.get("MODEL_REGISTRY")
    if registry is None:
        raise ModelNotLoadedError("Model registry not available")

    # Initialize service and delegate to business logic layer
    validator = SubjectInputValidator(min_len=1, max_len=128)
    predictor = PassingMarkPredictor(registry, validator)

    result = predictor.predict_mark_distribution(subject, features)

    return jsonify(result), 200



