"""Simple CLI helper to run the dev server

This module supports being executed as a module (python -m ml_service.cli)
and as a script (python ml_service/cli.py). The latter path adjusts sys.path
so the package can be imported by absolute name.
"""
import os
import sys

try:
    # Preferred: run as a module from package root: python -m ml_service.cli
    from . import create_app
except Exception:
    # Fallback: running the file directly (python ml_service/cli.py).
    # Ensure the project root (parent of ml_service) is on sys.path so we can
    # import the package by absolute name.
    pkg_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if pkg_root not in sys.path:
        sys.path.insert(0, pkg_root)
    from ml_service import create_app


def main():
    app = create_app()
    app.run(host="0.0.0.0", port=5000, debug=(app.config.get("MODE") == "dev"))


if __name__ == "__main__":
    main()
