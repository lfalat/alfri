#!/usr/bin/env python3
"""
Load a pickle (KMeans model) and dump a JSON-friendly summary to a file.
Output path: ml_service/models/kmeans_model_contents.json
"""
import json
import os
import sys
import traceback
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
PICKLE_REL = Path("ml_service") / "models" / "kmeans_model.pkl"
PICKLE_PATH = REPO_ROOT / PICKLE_REL
OUT_PATH = REPO_ROOT / "ml_service" / "models" / "kmeans_model_contents.json"


def to_json_friendly(obj):
    """Recursively convert numpy and sklearn objects to JSON-friendly types."""
    try:
        import numpy as np
    except Exception:
        np = None

    # numpy arrays -> lists
    if np is not None and isinstance(obj, np.ndarray):
        return obj.tolist()

    # basic types
    if isinstance(obj, (str, int, float, bool)) or obj is None:
        return obj

    # lists/tuples
    if isinstance(obj, (list, tuple)):
        return [to_json_friendly(x) for x in obj]

    # dict
    if isinstance(obj, dict):
        return {str(k): to_json_friendly(v) for k, v in obj.items()}

    # sklearn estimators often provide get_params
    try:
        if hasattr(obj, "get_params"):
            params = obj.get_params()
            summary = {
                "__sklearn_estimator__": True,
                "class": f"{type(obj).__module__}.{type(obj).__name__}",
                "params": to_json_friendly(params),
            }
            # extract useful attributes if present
            for attr in [
                "n_clusters",
                "cluster_centers_",
                "labels_",
                "inertia_",
                "n_iter_",
                "components_",
                "means_",
                "variance_",
            ]:
                if hasattr(obj, attr):
                    try:
                        summary[attr] = to_json_friendly(getattr(obj, attr))
                    except Exception:
                        summary[attr] = repr(getattr(obj, attr))
            return summary
    except Exception:
        pass

    # fallback to string representation
    try:
        return repr(obj)
    except Exception:
        return str(type(obj))


def main():
    if not PICKLE_PATH.exists():
        print(f"Pickle not found at: {PICKLE_PATH}")
        sys.exit(2)

    loaded = None
    load_errors = []

    # try joblib first
    try:
        import joblib

        try:
            loaded = joblib.load(PICKLE_PATH)
        except Exception as e:
            load_errors.append(("joblib.load", traceback.format_exc()))
    except Exception as e:
        load_errors.append(("import joblib", traceback.format_exc()))

    # try pickle
    if loaded is None:
        try:
            import pickle

            with open(PICKLE_PATH, "rb") as f:
                loaded = pickle.load(f)
        except Exception:
            load_errors.append(("pickle.load", traceback.format_exc()))

    if loaded is None:
        print("Failed to load pickle. Errors:\n")
        for where, err in load_errors:
            print(f"--- {where} ---\n{err}\n")
        sys.exit(3)

    summary = {
        "source_file": str(PICKLE_PATH),
        "type": f"{type(loaded).__module__}.{type(loaded).__name__}",
    }

    try:
        summary["content"] = to_json_friendly(loaded)
    except Exception:
        summary["content"] = repr(loaded)

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)

    print(f"Wrote JSON summary to: {OUT_PATH}")


if __name__ == "__main__":
    main()

