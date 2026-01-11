#!/usr/bin/env bash

# SearXNG - Privacy-respecting Metasearch Engine
# Official docs: https://docs.searxng.org/

svc_defaults() {
  DISK_GB="${DISK_GB:-10}"
  MEM_MB="${MEM_MB:-1024}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

svc_compose() {
  cat <<'EOF'
services:
  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./searxng:/etc/searxng:rw
    environment:
      - SEARXNG_BASE_URL=http://searxng.${DOMAIN:-localhost}/
      - SEARXNG_SECRET=${SEARXNG_SECRET:-change-this-secret-key}
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETGID
      - SETUID
    logging:
      driver: "json-file"
      options:
        max-size: "1m"
        max-file: "1"
    healthcheck:
      test: ["CMD", "wget", "--spider", "http://localhost:8080/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3

  redis:
    image: redis:alpine
    container_name: searxng-redis
    restart: unless-stopped
    command: redis-server --save 30 1 --loglevel warning
    volumes:
      - ./redis-data:/data
    cap_drop:
      - ALL
    cap_add:
      - SETGID
      - SETUID
      - DAC_OVERRIDE
EOF
}

svc_env() {
  cat <<'EOF'
# SearXNG Configuration
SEARXNG_SECRET=$(openssl rand -hex 32)
DOMAIN=yourdomain.com
EOF
}

svc_caddy_port() {
  echo "8080"
}
