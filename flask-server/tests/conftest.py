import os
import sys
import pathlib

os.environ.setdefault("LOAD_MODELS_ON_STARTUP", "false")
os.environ.setdefault("REGISTER_DB_SHUTDOWN_HANDLER", "false")

# ensure the project root is on sys.path so `ml_service` can be imported during tests
ROOT = pathlib.Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
