#!/usr/bin/env bash

# Flowise - Low-code LLM Orchestration Tool
# Official docs: https://docs.flowiseai.com/

svc_defaults() {
  DISK_GB="${DISK_GB:-20}"
  MEM_MB="${MEM_MB:-2048}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

svc_compose() {
  cat <<'EOF'
services:
  flowise:
    image: flowiseai/flowise:latest
    container_name: flowise
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - ./flowise_data:/root/.flowise
    environment:
      - PORT=3000
      - DATABASE_PATH=/root/.flowise
      - APIKEY_PATH=/root/.flowise
      - SECRETKEY_PATH=/root/.flowise
      - LOG_PATH=/root/.flowise/logs
      - FLOWISE_USERNAME=${FLOWISE_USERNAME:-admin}
      - FLOWISE_PASSWORD=${FLOWISE_PASSWORD:-admin}
      - PASSPHRASE=${PASSPHRASE:-your-secret-passphrase}
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/api/v1/ping"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF
}

svc_env() {
  cat <<'EOF'
# Flowise Configuration
FLOWISE_USERNAME=admin
FLOWISE_PASSWORD=your-secure-password
PASSPHRASE=$(openssl rand -hex 32)
EOF
}

svc_caddy_port() {
  echo "3000"
}
