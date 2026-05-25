# Updated Dockerfile: non-root user, install requirements, expose port 5000, gunicorn entrypoint
FROM python:3.12-slim

# Keep python output unbuffered
ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Create a non-root user to run the app
RUN groupadd -r app && useradd -r -g app -d /home/app -m -s /usr/sbin/nologin app

# Copy requirements and install them. Install minimal build tools then remove them to keep image small.
COPY requirements.txt /app/
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc curl \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get purge -y --auto-remove build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy model artifacts first (keeps them in a separate layer and helps cache during builds).
# If you prefer to mount models at runtime (recommended for very large models), you can
# skip this copy and set MODEL_DIR to a mounted path instead.
COPY ml_service/models /app/ml_service/models

# Copy application code and make app user the owner
COPY . /app
RUN chown -R app:app /app

# Set MODEL_DIR to the in-image models location; can be overridden with env at runtime
ENV MODEL_DIR=/app/ml_service/models

# Set flask entrypoint and switch to non-root user
ENV FLASK_APP=ml_service.wsgi
USER app

EXPOSE 5000

# Simple Docker HEALTHCHECK -- ensures Docker can report container health based on /health/live
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s CMD curl -f http://127.0.0.1:5000/health/live || exit 1

# Use gunicorn to serve the WSGI app. 2 workers is a reasonable default for small containers.
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "ml_service.wsgi:app"]
