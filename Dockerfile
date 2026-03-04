# ---- Stage 1: Builder ----
FROM python:3.14-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip uv


# Copy dependency files and install uv + dependencies
COPY pyproject.toml uv.lock* ./
RUN uv sync
RUN uv add uvloop httptools

COPY . .

# ---- Stage 2: Production ----
FROM python:3.14-slim

WORKDIR /app

# Python runtime optimizations
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app ./
ENV PATH="/app/.venv/bin:$PATH"

# Expose port
EXPOSE 8000

# Run FastAPI with Uvicorn in production
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000","--log-config", "log_config.json", "--workers", "2", "--loop", "uvloop","--http", "httptools"]