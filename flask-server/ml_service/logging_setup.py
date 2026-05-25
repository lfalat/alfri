"""Simple logging configuration for the service."""
import logging
import sys


def configure_logging(level: str = None):
    level = level or "INFO"
    numeric_level = getattr(logging, level.upper(), logging.INFO)

    root = logging.getLogger()
    root.setLevel(numeric_level)

    handler = logging.StreamHandler(stream=sys.stdout)
    handler.setLevel(numeric_level)
    fmt = logging.Formatter("%(asctime)s %(levelname)s [%(name)s] %(message)s")
    handler.setFormatter(fmt)

    # Clear existing handlers attached to root (safe for simple apps)
    if root.handlers:
        for h in list(root.handlers):
            root.removeHandler(h)
    root.addHandler(handler)

