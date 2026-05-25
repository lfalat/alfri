"""Custom API errors and helpers

Defines a small hierarchy of API errors that carry an error code,
HTTP status, message and optional details. Also provides utilities to
convert errors into JSON payloads suitable for the Flask error handler
returned to clients.

Error codes added (acceptance criteria):
- VALIDATION_ERROR
- SUBJECT_NOT_FOUND
- MODEL_NOT_LOADED
- INTERNAL_ERROR
"""
from typing import Any, Dict, Optional


class APIError(Exception):
    """Base class for API errors.

    Attributes:
        code: short machine-friendly error code
        message: human-friendly message
        status_code: HTTP status code to return
        details: optional extra structured info
    """

    code: str = "INTERNAL_ERROR"
    status_code: int = 500

    def __init__(self, message: str = "An error occurred", details: Optional[Dict[str, Any]] = None):
        super().__init__(message)
        self.message = message
        self.details = details or {}

    def to_dict(self) -> Dict[str, Any]:
        payload: Dict[str, Any] = {"code": self.code, "message": self.message}
        if self.details:
            payload["details"] = self.details
        return payload


class ValidationError(APIError):
    code = "VALIDATION_ERROR"
    status_code = 400


class SubjectNotFoundError(APIError):
    code = "SUBJECT_NOT_FOUND"
    status_code = 404


class ModelNotLoadedError(APIError):
    code = "MODEL_NOT_LOADED"
    status_code = 503


class InternalError(APIError):
    code = "INTERNAL_ERROR"
    status_code = 500


# helper to create a response payload for Flask handlers
def to_error_response(err: APIError) -> Dict[str, Any]:
    return {"error": err.to_dict()}

