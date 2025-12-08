# ===========================
# Stage 1 — Build Stage
# ===========================
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build tools (if your requirements need compiling)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies into a clean directory
COPY requirements.txt .
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt


# ===========================
# Stage 2 — Runtime Stage
# ===========================
FROM python:3.12-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy app source code
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
