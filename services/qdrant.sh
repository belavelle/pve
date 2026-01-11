#!/usr/bin/env bash

# Qdrant - Vector Similarity Search Engine
# Official docs: https://qdrant.tech/documentation/

svc_defaults() {
  DISK_GB="${DISK_GB:-20}"
  MEM_MB="${MEM_MB:-2048}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

svc_compose() {
  cat <<'EOF'
services:
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    restart: unless-stopped
    ports:
      - "6333:6333"  # HTTP API
      - "6334:6334"  # gRPC API
    volumes:
      - ./qdrant_storage:/qdrant/storage
    environment:
      - QDRANT__SERVICE__HTTP_PORT=6333
      - QDRANT__SERVICE__GRPC_PORT=6334
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:6333/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF
}

svc_caddy_port() {
  echo "6333"
}

