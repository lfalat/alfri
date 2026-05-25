"""Model registry and loader

This module implements ModelRegistry which reads a MODEL_MAP (typically
from Flask `app.config`) and attempts to preload all declared models.

MODEL_MAP is expected to be a mapping of model_name -> metadata where
metadata is a dict with (recommended) keys:
  - type: one of "logistic", "keras", "kmeans" (controls loader)
  - path: optional filesystem path to load the model from
  - role: optional, e.g. "chance" or "mark" (used by getters)
  - subject: optional subject identifier for chance/mark models
  - studyProgramId: optional id for kmeans models
  - expected_input_len: integer length used for keras warmup

Behavior:
- load_all() iterates MODEL_MAP and loads each model, timing each load
  and recording any exception raised. Keras models are "warmed up"
  by running a single predict on a zero input of shape
  (1, expected_input_len) when possible.
- Per-model timings and errors are stored in `timings` and `errors`.
- MODELS_LOADED is set on the provided config (mapping or object) and is
  True only when every model listed in MODEL_MAP loaded successfully.

The registry exposes convenience getters:
- get_chance_model(subject)
- get_mark_model(subject)
- get_kmeans_model(studyProgramId)

All steps are logged so that startup logs contain per-model status and
duration information required by the acceptance criteria.
"""

from typing import Any, Dict, Optional
import time
import logging
import traceback
import threading
from pathlib import Path

# Import Config so we can resolve MODEL_DIR defaults if callers pass config
try:
    from .config import Config
except Exception:
    Config = None  # pragma: no cover

logger = logging.getLogger(__name__)


class ModelRegistry:
    """Registry that loads and holds models declared in a MODEL_MAP.

    Attributes:
        model_map: original metadata mapping passed at construction
        models: dict of name -> loaded model object
        timings: dict of name -> seconds taken to load
        errors: dict of name -> exception string for failed loads
    """

    def __init__(self, model_map: Dict[str, Dict[str, Any]]):
        self.model_map = model_map or {}
        self.models: Dict[str, Any] = {}
        self.timings: Dict[str, float] = {}
        self.errors: Dict[str, str] = {}
        # Lock to ensure thread-safe calls into Keras models' predict methods
        # Some Keras backends are not thread-safe for concurrent .predict calls
        # so expose a single Lock clients can use or the registry will use it
        # during warmup and callers (blueprints) can use it for inference.
        self.keras_predict_lock = threading.Lock()

    def load_all(self, config: Optional[Any] = None) -> None:
        """Load all models declared in `self.model_map`.

        - Records per-model load time in `self.timings`.
        - Stores any exceptions in `self.errors`.
        - Warms up Keras models by running a single dummy prediction when
          `expected_input_len` is provided.
        - Sets MODELS_LOADED on `config` (mapping or object attribute)
          to True only when all models loaded without errors.
        """
        total_start = time.perf_counter()
        logger.info("Starting loading of %d models", len(self.model_map))

        for name, meta in (self.model_map.items() if isinstance(self.model_map, dict) else []):
            start = time.perf_counter()
            logger.info("Loading model '%s' with meta=%s", name, meta)
            try:
                mtype = (meta or {}).get("type")
                if mtype == "keras":
                    model = self._load_keras(meta)
                elif mtype in ("logistic", "kmeans"):
                    model = self._load_generic(meta)
                else:
                    # Unknown type: try generic loader first, then treat as error
                    model = self._load_generic(meta)

                # If model is loaded, possibly warmup (keras)
                if model is not None and (meta or {}).get("type") == "keras":
                    self._warmup_keras(model, meta)

                self.models[name] = model
                duration = time.perf_counter() - start
                self.timings[name] = duration
                logger.info("Loaded model '%s' in %.3fs", name, duration)
            except Exception as exc:
                duration = time.perf_counter() - start
                self.timings[name] = duration
                # For common environment issues (missing ML libraries) avoid
                # noisy exception tracebacks and log a concise warning instead.
                if isinstance(exc, (ModuleNotFoundError, ImportError)):
                    # Record the concise import error message so callers can see
                    # which dependency was missing, but don't flood the logs
                    # with full tracebacks when running in a lightweight dev env.
                    msg = f"{type(exc).__name__}: {exc}"
                    self.errors[name] = msg
                    logger.warning("Could not load model '%s' (%.3fs): %s", name, duration, msg)
                else:
                    tb = traceback.format_exc()
                    self.errors[name] = tb
                    logger.exception("Failed to load model '%s' (%.3fs): %s", name, duration, exc)

        total_duration = time.perf_counter() - total_start
        logger.info("Finished loading models in %.3fs; %d succeeded, %d failed",
                    total_duration, len(self.models), len(self.errors))

        # Set readiness on provided config: True only if there are no errors
        loaded_ok = len(self.errors) == 0 and len(self.models) == len(self.model_map)
        try:
            if hasattr(config, "__setitem__"):
                config["MODELS_LOADED"] = bool(loaded_ok)
            else:
                setattr(config, "MODELS_LOADED", bool(loaded_ok))
        except Exception:
            logger.exception("Unable to set MODELS_LOADED on config")

    # -- Loader helpers -------------------------------------------------
    def _resolve_path(self, path: Optional[str]) -> Optional[str]:
        """Resolve a given model path. If the path is already absolute and exists,
        return it. If the path is relative, try resolving it relative to
        Config.MODEL_DIR (if available) and finally relative to this package's
        `models` dir. Returns None if `path` is falsy.
        """
        if not path:
            return None
        p = Path(path)
        # if absolute path and exists, return
        if p.is_absolute() and p.exists():
            return str(p)

        # Try environment/package MODEL_DIR
        model_dir = None
        try:
            model_dir = getattr(Config, "MODEL_DIR", None) if Config is not None else None
        except Exception:
            model_dir = None

        if model_dir:
            candidate = Path(model_dir) / path
            if candidate.exists():
                return str(candidate)

        # As a last resort, try the `models` directory next to this file
        candidate = Path(__file__).parent / "models" / path
        if candidate.exists():
            return str(candidate)

        # If none found, return the original (may raise later when opening)
        return str(p)

    def _load_generic(self, meta: Dict[str, Any]) -> Any:
        """Load a pickled or joblib model from `meta['path']`.

        If `path` is absent, return None. Exceptions are propagated to
        caller which will record them.
        """
        path = (meta or {}).get("path")
        if not path:
            raise ValueError("No 'path' in model metadata for generic loader")

        path = self._resolve_path(path)

        # Try joblib first, fall back to pickle
        try:
            import joblib  # type: ignore

            logger.debug("Using joblib to load %s", path)
            return joblib.load(path)
        except Exception:
            logger.debug("joblib not available or failed; trying pickle for %s", path)
            import pickle

            with open(path, "rb") as fh:
                return pickle.load(fh)

    def _load_keras(self, meta: Dict[str, Any]) -> Any:
        """Load a Keras model from `meta['path']` using tensorflow/keras.

        Exceptions are propagated to caller and will be recorded.
        """
        path = (meta or {}).get("path")
        if not path:
            raise ValueError("No 'path' in model metadata for keras loader")

        path = self._resolve_path(path)

        # Try to import tensorflow.keras first, then keras
        try:
            from tensorflow import keras as _keras  # type: ignore
        except Exception:
            try:
                import keras as _keras  # type: ignore
            except Exception:
                raise

        logger.debug("Loading Keras model from %s", path)
        return _keras.models.load_model(path)

    def _warmup_keras(self, model: Any, meta: Dict[str, Any]) -> None:
        """Run a single dummy prediction so the model is warmed up.

        Uses `expected_input_len` from metadata to construct the input. If
        numpy is unavailable or expected_input_len is missing, the step is
        skipped but the model remains loaded.
        """
        try:
            expected = (meta or {}).get("expected_input_len")
            if expected is None:
                logger.warning("Skipping Keras warmup for model; missing expected_input_len in meta")
                return

            import numpy as _np

            dummy = _np.zeros((1, int(expected)), dtype=_np.float32)
            if hasattr(model, "predict"):
                # Some Keras wrappers accept lists; try single call
                logger.debug("Warming up Keras model with input shape %s", dummy.shape)
                try:
                    # Acquire the registry-level Keras lock to avoid concurrent
                    # predict calls while warming up (and to be consistent with
                    # runtime predictions which should also use the lock).
                    lock = getattr(self, "keras_predict_lock", None)
                    if lock:
                        with lock:
                            _ = model.predict(dummy)
                    else:
                        _ = model.predict(dummy)
                except Exception:
                    # If predict fails with a single array, try wrapping in list
                    try:
                        lock = getattr(self, "keras_predict_lock", None)
                        if lock:
                            with lock:
                                _ = model.predict([dummy])
                        else:
                            _ = model.predict([dummy])
                    except Exception:
                        # Don't raise: warming up is optional
                        logger.exception("Keras model warmup failed")
            else:
                logger.debug("Model has no predict method; skipping warmup")
        except Exception:
            logger.exception("Unexpected error during Keras warmup")

    # -- Getters --------------------------------------------------------
    def get_chance_model(self, subject: Any) -> Optional[Any]:
        """Return the chance model for `subject` or None.

        Lookup by scanning model_map entries for role=='chance' and matching
        subject metadata. Returns the loaded model object if present.
        """
        return self._find_by_role_and_field("chance", "subject", subject)

    def get_mark_model(self, subject: Any) -> Optional[Any]:
        """Return the mark model for `subject` or None.
        """
        return self._find_by_role_and_field("mark", "subject", subject)

    def get_kmeans_model(self, studyProgramId: Any) -> Optional[Any]:
        """Return the kmeans model for `studyProgramId` or None.
        """
        # kmeans models are usually typed 'kmeans' but we match by studyProgramId
        return self._find_by_role_and_field(None, "studyProgramId", studyProgramId, type_filter="kmeans")

    def _find_by_role_and_field(self, role: Optional[str], field: str, value: Any, type_filter: Optional[str] = None) -> Optional[Any]:
        for name, meta in (self.model_map.items() if isinstance(self.model_map, dict) else []):
            if type_filter and (meta or {}).get("type") != type_filter:
                continue
            if role and (meta or {}).get("role") != role:
                continue
            if (meta or {}).get(field) == value:
                return self.models.get(name)
        return None


# Convenience function kept for backward compatibility with older code that
# called load_models(config).
def load_models(config: Any) -> ModelRegistry:
    """Create a registry from config's MODEL_MAP, load all models and return the registry."""
    model_map = config.get("MODEL_MAP", {}) if hasattr(config, "get") else getattr(config, "MODEL_MAP", {})
    registry = ModelRegistry(model_map)
    registry.load_all(config=config)
    return registry
