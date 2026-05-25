"""Validation utilities for request inputs

Currently provides SubjectInputValidator which enforces that a `subject`
field is present in input and its length falls within configured bounds.

The validator raises `ValidationError` from `ml_service.errors` when the
input is invalid.
"""
from typing import Any, Dict

from .errors import ValidationError


class SubjectInputValidator:
    """Validate subject input field.

    Configurable rules:
    - min_len: minimum length (inclusive)
    - max_len: maximum length (inclusive)

    Usage:
        validator = SubjectInputValidator(min_len=1, max_len=50)
        validator.validate({'subject': 'foo'})  # raises ValidationError on bad input
    """

    def __init__(self, min_len: int = 1, max_len: int = 256):
        if min_len < 0 or max_len < 0:
            raise ValueError("min_len and max_len must be non-negative")
        if min_len > max_len:
            raise ValueError("min_len cannot be greater than max_len")
        self.min_len = int(min_len)
        self.max_len = int(max_len)

    def validate(self, data: Dict[str, Any]) -> None:
        """Validate `data` contains a `subject` string within length bounds.

        Raises:
            ValidationError: with details about what failed.
        """
        if not isinstance(data, dict):
            raise ValidationError("Invalid payload: expected JSON object", details={"payload_type": type(data).__name__})

        if "subject" not in data:
            raise ValidationError("Missing required field: subject", details={"field": "subject"})

        subject = data["subject"]
        if subject is None:
            raise ValidationError("subject cannot be null", details={"field": "subject"})

        if not isinstance(subject, (str, bytes)):
            raise ValidationError("subject must be a string", details={"field": "subject", "type": type(subject).__name__})

        # coerce bytes->str for length checking
        if isinstance(subject, bytes):
            try:
                subject = subject.decode("utf-8")
            except Exception:
                raise ValidationError("subject must be UTF-8 decodable", details={"field": "subject"})

        length = len(subject)
        if length < self.min_len or length > self.max_len:
            raise ValidationError(
                f"subject must be between {self.min_len} and {self.max_len} characters",
                details={"field": "subject", "min_len": self.min_len, "max_len": self.max_len, "actual_len": length},
            )

        # success -> no return value

