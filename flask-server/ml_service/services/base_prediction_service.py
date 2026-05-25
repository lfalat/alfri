"""Base service class for prediction operations.

Provides common validation and utility methods for all prediction services.
"""
from typing import Dict, List, Any, Optional, Tuple

from ..validation import SubjectInputValidator
from ..errors import ValidationError


class PredictionService:
    """Base service class for prediction operations.
    
    This class provides common functionality for validating subjects,
    features, and accessing model metadata. Concrete prediction services
    should inherit from this class.
    """
    
    def __init__(self, registry, validator: SubjectInputValidator):
        """Initialize the prediction service.
        
        Args:
            registry: Model registry containing loaded models
            validator: Subject input validator instance
        """
        self.registry = registry
        self.validator = validator
        self.model_map = getattr(registry, "model_map", {}) or {}
    
    def validate_subject(self, subject: str) -> Optional[Dict[str, Any]]:
        """Validate subject string.
        
        Args:
            subject: Subject name to validate
            
        Returns:
            Error dict if invalid, None if valid
        """
        try:
            self.validator.validate({"subject": subject})
            return None
        except ValidationError as vex:
            return {"status": 422, "error": "INVALID_SUBJECT", "message": vex.message}
        except Exception as exc:
            return {"status": 422, "error": "INVALID_SUBJECT", "message": str(exc)}
    
    def validate_features(self, features: Any) -> Optional[Dict[str, Any]]:
        """Validate that features are a list or tuple.
        
        Args:
            features: Features to validate
            
        Returns:
            Error dict if invalid, None if valid
        """
        if not isinstance(features, (list, tuple)):
            return {
                "status": 422,
                "error": "INVALID_FEATURES",
                "message": "features must be a list of numeric values"
            }
        return None
    
    def coerce_features_to_floats(self, features: List) -> Tuple[Optional[List[float]], Optional[Dict[str, Any]]]:
        """Convert features to floats.
        
        Args:
            features: List of feature values
            
        Returns:
            Tuple of (converted features, error dict). Error dict is None on success.
        """
        try:
            return [float(x) for x in features], None
        except Exception:
            return None, {
                "status": 422,
                "error": "INVALID_FEATURE_VALUES",
                "message": "features must be numeric"
            }
    
    def validate_feature_length(self, features: List, expected_len: Optional[int]) -> Optional[Dict[str, Any]]:
        """Validate feature vector length against expected length.
        
        Args:
            features: Feature list
            expected_len: Expected number of features (None to skip check)
            
        Returns:
            Error dict if invalid, None if valid
        """
        if expected_len is not None and len(features) != int(expected_len):
            return {
                "status": 422,
                "error": "INVALID_FEATURE_LENGTH",
                "message": f"expected length {expected_len}, got {len(features)}"
            }
        return None
    
    def get_model_metadata(self, subject: str, role: str) -> Dict[str, Any]:
        """Extract model metadata for given subject and role.
        
        Args:
            subject: Subject name
            role: Model role (e.g., "chance", "mark")
            
        Returns:
            Dictionary of metadata, or empty dict if not found
        """
        for name, meta in (self.model_map.items() if isinstance(self.model_map, dict) else []):
            if (meta or {}).get("role") == role and (meta or {}).get("subject") == subject:
                return meta or {}
        return {}

