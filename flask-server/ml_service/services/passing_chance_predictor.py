"""Passing chance prediction service.

Handles predictions for passing chance using logistic regression models.
"""
from typing import Dict, List, Any, Optional, Tuple

from .base_prediction_service import PredictionService


class PassingChancePredictor(PredictionService):
    """Handles passing chance predictions using logistic regression models.
    
    This service validates input, retrieves the appropriate model, and computes
    the probability that a student will pass a subject based on their features.
    """
    
    def predict_single_subject(self, subject: str, features: List) -> Dict[str, Any]:
        """Predict passing chance for a single subject.
        
        Args:
            subject: Subject name
            features: List of feature values
            
        Returns:
            Dictionary with prediction results or error information
        """
        # Validate subject
        error = self.validate_subject(subject)
        if error:
            return error
        
        # Get model
        model = self.registry.get_chance_model(subject)
        if model is None:
            return {
                "status": 422,
                "error": "MODEL_MISSING",
                "message": f"No chance model for subject '{subject}'"
            }
        
        # Validate features type
        error = self.validate_features(features)
        if error:
            return error
        
        # Get expected length from metadata
        metadata = self.get_model_metadata(subject, "chance")
        expected_len = metadata.get("expected_input_len")
        
        # Validate feature length
        error = self.validate_feature_length(features, expected_len)
        if error:
            return error
        
        # Coerce to floats
        X, error = self.coerce_features_to_floats(features)
        if error:
            return error
        
        # Make prediction
        probability, error = self._compute_probability(model, X)
        if error:
            return error
        
        # Clamp and format result
        probability = self._clamp_probability(probability)
        return {
            "probability": float(probability),
            "percentage": f"{float(probability) * 100:.2f}%"
        }
    
    def _compute_probability(self, model, X: List[float]) -> Tuple[Optional[float], Optional[Dict[str, Any]]]:
        """Compute probability from model prediction.
        
        Args:
            model: Trained model with predict or predict_proba method, or a dict containing 'model' key
            X: Feature vector
            
        Returns:
            Tuple of (probability, error dict). Error dict is None on success.
        """
        try:
            # Handle case where model is a dictionary with 'model' key
            actual_model = model
            if isinstance(model, dict) and 'model' in model:
                actual_model = model['model']

            if hasattr(actual_model, "predict_proba"):
                return self._extract_probability_from_proba(actual_model, X), None
            elif hasattr(actual_model, "predict"):
                return self._extract_probability_from_predict(actual_model, X), None
            else:
                return None, {
                    "status": 500,
                    "error": "MODEL_NO_PREDICT",
                    "message": "Model has no predict or predict_proba method"
                }
        except Exception as exc:
            return None, {
                "status": 500,
                "error": "PREDICTION_FAILED",
                "message": str(exc)
            }
    
    def _extract_probability_from_proba(self, model, X: List[float]) -> float:
        """Extract probability from predict_proba output.
        
        Args:
            model: Model with predict_proba method
            X: Feature vector
            
        Returns:
            Probability value between 0 and 1
        """
        probs = model.predict_proba([X])
        try:
            # Prefer probability of class 1 if available
            return float(probs[0][1]) if len(probs[0]) >= 2 else float(probs[0][-1])
        except Exception:
            # Fallback: try converting first value
            return float(probs[0][0])
    
    def _extract_probability_from_predict(self, model, X: List[float]) -> float:
        """Extract probability from predict output (binary classification).
        
        Args:
            model: Model with predict method
            X: Feature vector
            
        Returns:
            Probability value (0.0 or 1.0)
        """
        label = model.predict([X])[0]
        try:
            return 1.0 if int(label) else 0.0
        except Exception:
            return 1.0 if label else 0.0
    
    def _clamp_probability(self, p: float) -> float:
        """Clamp probability to [0, 1] range.
        
        Args:
            p: Probability value
            
        Returns:
            Clamped probability between 0 and 1
        """
        try:
            return max(0.0, min(1.0, p))
        except Exception:
            return float(p)

