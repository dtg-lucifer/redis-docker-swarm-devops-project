FROM python:3.9-slim

# Set metadata labels
LABEL maintainer="Piush Bose <dev.bosepiush@gmail.com>"
LABEL version="1.0"
LABEL description="Python application with Redis connection to monitor system health"

WORKDIR /app

COPY requirements.txt ./

RUN pip install --upgrade pip && \
  pip install --no-cache-dir -r requirements.txt

RUN groupadd -r appuser && useradd -r -g appuser appuser

COPY . ./

# Make port 5001 available to the world outside this container
EXPOSE 5001

# Set environment variables
ENV REDIS_HOST=${REDIS_HOST} \
  REDIS_PORT=${REDIS_PORT} \
  REDIS_PASS=${REDIS_PASS}} \
  PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:5001/health')" || exit 1

# Switch to non-root user
USER appuser

# Run app with proper signal handling
CMD ["python", "app.py"]
