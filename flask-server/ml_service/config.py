"""Configuration loader for ml_service

Loads configuration from environment variables and supports a JSON MODEL_MAP.
"""
import os
import json
from typing import Dict, Any, List


def _parse_json_env(var_name: str, default=None):
    val = os.getenv(var_name)
    if not val:
        return default
    try:
        return json.loads(val)
    except json.JSONDecodeError:
        raise ValueError(f"Environment variable {var_name} contains invalid JSON")


# Default MODEL_MAP built from artifact filenames located in ml_service/models/
# Assumptions made:
# - Files with .h5 are Keras models (type: 'keras')
# - Files with .pkl are pickled sklearn/logistic/kmeans models (type: 'logistic' by default)
# - Files explicitly named like 'kmeans_model*.pkl' are treated as type 'kmeans'
# - Roles/subjects/studyProgramId are guessed from filenames when reasonable; you
#   should adjust them for your actual routing/lookup logic. You can override
#   the entire mapping by setting the MODEL_MAP environment variable (JSON).
DEFAULT_MODEL_MAP = {
    # Clustering models
    "kmeans_model": {"type": "kmeans", "path": "kmeans_model.pkl", "studyProgramId": 3},
    "kmeans_model_manazment": {"type": "kmeans", "path": "kmeans_model_manazment.pkl", "studyProgramId": 4},

    # Prediction models

    # Second grade
    "aus1_h5": {"type": "keras", "role": "mark", "path": "aus1.h5", "subject": 'Algoritmy a udajove struktury 1'},
    "aus1_pkl": {"type": "logistic", "path": "aus1.pkl", "role": "chance", "subject": "Algoritmy a udajove struktury 1"},

    "dp_h5": {"type": "keras", "path": "dp.h5", "role": "mark", "subject": "Diskretna pravdepodobnost"},
    "dp_pkl": {"type": "logistic", "path": "dp.pkl", "role": "chance", "subject": "Diskretna pravdepodobnost"},

    "mata1_h5": {"type": "keras", "path": "mata1.h5", "role": "mark", "subject": "Matematicka analyza 1"},
    "mata1_pkl": {"type": "logistic", "path": "mata1.pkl", "role": "chance", "subject": "Matematicka analyza 1"},

    # Third grade
    "modelovanie_a_simulacia_h5": {"type": "keras", "path": "modelovanie_a_simulacia.h5", "role": "mark", "subject": "Modelovanie a simulácia"},
    "modelovanie_a_simulacia_pkl": {"type": "logistic", "path": "modelovanie_a_simulacia.pkl", "role": "chance", "subject": "Modelovanie a simulácia"},

    "principy_operacnych_systemov_h5": {"type": "keras", "path": "principy_operacnych_systemov.h5", "role": "mark", "subject": "Princípy operačných systémov"},
    "principy_operacnych_systemov_pkl": {"type": "logistic", "path": "principy_operacnych_systemov.pkl", "role": "chance", "subject": "Princípy operačných systémov"},

    "vyvoj_aplikacii_internet_intranet_h5": {"type": "keras", "path": "vyvoj_aplikacii_internet_intranet.h5", "role": "mark", "subject": "Vývoj aplikácií pre internet a intranet"},
    "vyvoj_aplikacii_internet_intranet_pkl": {"type": "logistic", "path": "vyvoj_aplikacii_internet_intranet.pkl", "role": "chance", "subject": "Vývoj aplikácií pre internet a intranet"},

    # Fourth grade
    "best_model_AUS": {"type": "keras", "path": "best_model_AUS.h5"},
    "best_model_DIS": {"type": "keras", "path": "best_model_DIS.h5"},
    "best_model_OPTS": {"type": "keras", "path": "best_model_OPTS.h5"},

    "model_AUS": {"type": "logistic", "path": "model_AUS.pkl", "role": "chance", "subject": "Algoritmy a udajove struktury 2"},
    "model_DIS": {"type": "logistic", "path": "model_DIS.pkl", "role": "chance", "subject": "DIS"},
    "model_OPTS": {"type": "logistic", "path": "model_OPTS.pkl", "role": "chance", "subject": "OPTS"},
}


class Config:
    """Minimal config object used by Flask.

    Exposes:
    - MODEL_MAP: dict mapping model names to metadata (from JSON env var MODEL_MAP)
    - LOG_LEVEL: logging level
    - MODE: 'dev' or 'prod'
    - API_KEYS: list of allowed API keys (parsed from API_KEYS or API_KEY env vars)
    - MODEL_DIR: directory where model artifact files live (can be overridden via env)
    """

    MODE = os.getenv("MODE", "dev")
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
    # Use the DEFAULT_MODEL_MAP by default; allow override via env var MODEL_MAP (JSON)
    MODEL_MAP = _parse_json_env("MODEL_MAP", default=DEFAULT_MODEL_MAP) or DEFAULT_MODEL_MAP

    # Directory to look for model artifacts. If not provided, default to the
    # package's `models/` directory so relative paths in MODEL_MAP work out of the
    # box when you add files to `ml_service/models/`.
    MODEL_DIR = os.getenv("MODEL_DIR", os.path.join(os.path.dirname(__file__), "models"))

    # API key handling: either a single key in API_KEY or a comma-separated list in API_KEYS.
    # If neither is set, API_KEYS will be an empty list (treated as "no keys configured").
    _raw_api_keys = os.getenv("API_KEYS") or os.getenv("API_KEY") or ""
    # split by comma and strip whitespace, filter out empty strings
    API_KEYS: List[str] = [k.strip() for k in _raw_api_keys.split(",") if k.strip()] if _raw_api_keys else []

    # Database configuration
    DATABASE_HOST = os.getenv("DATABASE_DEV_URL", "localhost:5432/alfri")
    DATABASE_USER = os.getenv("DATABASE_DEV_USER", "alfri")
    DATABASE_PASSWORD = os.getenv("DATABASE_DEV_PASSWORD", "changeme")

    # Parse host:port/database format
    _db_parts = DATABASE_HOST.split("/")
    DATABASE_NAME = _db_parts[1] if len(_db_parts) > 1 else "alfri"
    _host_port = _db_parts[0].split(":")
    DATABASE_HOST_ONLY = _host_port[0] if _host_port else "localhost"
    DATABASE_PORT = int(_host_port[1]) if len(_host_port) > 1 else 5432

    # Construct PostgreSQL connection string
    DATABASE_URL = f"postgresql://{DATABASE_USER}:{DATABASE_PASSWORD}@{DATABASE_HOST_ONLY}:{DATABASE_PORT}/{DATABASE_NAME}"

    # Add other config defaults as needed

    def as_dict(self) -> Dict[str, Any]:
        return {k: v for k, v in self.__class__.__dict__.items() if k.isupper()}
