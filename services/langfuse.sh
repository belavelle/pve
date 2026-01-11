#!/usr/bin/env bash

# Langfuse - LLM Observability and Analytics
# Official docs: https://langfuse.com/docs/

svc_defaults() {
  DISK_GB="${DISK_GB:-30}"
  MEM_MB="${MEM_MB:-2048}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

svc_compose() {
  cat <<'EOF'
services:
  langfuse:
    image: langfuse/langfuse:latest
    container_name: langfuse
    restart: unless-stopped
    ports:
      - "3000:3000"
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://langfuse:${POSTGRES_PASSWORD:-langfuse}@postgres:5432/langfuse
      - NEXTAUTH_URL=http://localhost:3000
      - NEXTAUTH_SECRET=${NEXTAUTH_SECRET:-change-this-secret}
      - SALT=${SALT:-change-this-salt}
      - TELEMETRY_ENABLED=${TELEMETRY_ENABLED:-true}
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/api/public/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  postgres:
    image: postgres:15-alpine
    container_name: langfuse-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=langfuse
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-langfuse}
      - POSTGRES_DB=langfuse
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U langfuse"]
      interval: 10s
      timeout: 5s
      retries: 5
EOF
}

svc_env() {
  cat <<'EOF'
# Langfuse Configuration
POSTGRES_PASSWORD=$(openssl rand -base64 32)
NEXTAUTH_SECRET=$(openssl rand -base64 32)
SALT=$(openssl rand -base64 32)
TELEMETRY_ENABLED=false
EOF
}

svc_caddy_port() {
  echo "3000"
}
