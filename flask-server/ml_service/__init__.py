"""ml_service package - app factory and wiring
"""
from flask import Flask, jsonify, request

from .logging_setup import configure_logging


def create_app(test_config=None):
    """Application factory - returns configured Flask app.

    - Configures logging
    - Loads configuration from Config object
    - Registers blueprints
    - Kicks off model loading in a background thread (placeholder)
    - Registers JSON error handlers for APIError subclasses
    """
    configure_logging()

    app = Flask(__name__, instance_relative_config=False)

    # load config from the Config object
    from .config import Config
    app.config.from_object(Config())

    # --- API key middleware: enforce X-API-Key for API routes starting with /api/ ---
    @app.before_request
    def _require_api_key():
        # Only enforce for API routes
        path = request.path or ""
        if not path.startswith("/api/"):
            return None

        configured_keys = app.config.get("API_KEYS", []) or []
        # if no keys configured, skip enforcement (useful for local dev)
        if len(configured_keys) == 0:
            return None

        header = request.headers.get("X-API-Key") or request.headers.get("X-API-KEY")
        if not header:
            return jsonify({"error": "Missing X-API-Key header"}), 401
        # allow exact match to any configured key
        if header not in configured_keys:
            return jsonify({"error": "Invalid API key"}), 401
        return None

    # register blueprints
    from .blueprints.health import health_bp
    app.register_blueprint(health_bp)

    # register predict blueprint
    from .blueprints.predict import predict_bp
    app.register_blueprint(predict_bp)

    # register clustering blueprint (legacy)
    from .blueprints.clustering import clustering_bp
    app.register_blueprint(clustering_bp)

    # register clustering_v2 blueprint (corrected implementation)
    from .blueprints.clustering_v2 import clustering_v2_bp
    app.register_blueprint(clustering_v2_bp)

    # register JSON error handlers for our API errors
    from . import errors

    @app.errorhandler(errors.APIError)
    def _handle_api_error(err):
        payload = {"error": err.to_dict()}
        return jsonify(payload), getattr(err, "status_code", 500)

    @app.errorhandler(Exception)
    def _handle_unexpected_error(err):
        # Log and return a generic internal error payload without exposing internals
        app.logger.exception("Unhandled exception: %s", err)
        internal = errors.InternalError("Internal server error")
        return jsonify({"error": internal.to_dict()}), internal.status_code

    # Initialize database connection pool
    from .database import DatabaseManager
    import atexit
    try:
        db_url = app.config.get("DATABASE_URL")
        db_manager = DatabaseManager(db_url, min_connections=1, max_connections=2)
        db_manager.init_pool()
        app.config["DB_MANAGER"] = db_manager

        # Test connection
        if db_manager.test_connection():
            app.logger.info("Database connection successful")
        else:
            app.logger.warning("Database connection test failed - clustering endpoints may not work")

        # Register cleanup handler for application shutdown (not per-request)
        atexit.register(lambda: db_manager.close_pool())
    except Exception as e:
        app.logger.error(f"Failed to initialize database: {e}")
        app.logger.warning("Clustering endpoints will not be available")


    # start model loading in background (non-blocking)
    from . import models
    import threading

    def _load_models():
        try:
            # load models and keep registry on config for handlers to use
            registry = models.load_models(app.config)
            app.config["MODEL_REGISTRY"] = registry
            app.logger.info("Model loading completed.")
        except Exception:
            app.logger.exception("Model loading failed")

    # Load models synchronously when using gunicorn preload to ensure models are ready
    # before workers start accepting requests
    import os
    preload_mode = os.environ.get('GUNICORN_PRELOAD', '0') == '1'
    if preload_mode:
        app.logger.info("Loading models synchronously (preload mode)")
        _load_models()
    else:
        # Load in background thread for development
        app.logger.info("Loading models in background thread")
        loader_thread = threading.Thread(target=_load_models, daemon=True)
        loader_thread.start()

    # --- Serve OpenAPI spec and a tiny Swagger UI page ---
    @app.route("/openapi.json", methods=["GET"])
    def _openapi_spec():
        # Serve the bundled openapi.json from the package static folder
        try:
            # use Flask's send_static_file by placing openapi.json under package static
            return app.send_static_file("openapi.json")
        except Exception:
            return jsonify({"error": "OpenAPI spec not available"}), 404

    return app
