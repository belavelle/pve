#!/usr/bin/env bash

# Caddy - Reverse Proxy with Automatic HTTPS
# Official docs: https://caddyserver.com/docs/

svc_defaults() {
  DISK_GB="${DISK_GB:-10}"
  MEM_MB="${MEM_MB:-512}"
  SWAP_MB="${SWAP_MB:-256}"
  CORES="${CORES:-1}"
}

svc_compose() {
  cat <<'EOF'
services:
  caddy:
    image: caddy:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"  # HTTP/3
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy_data:/data
      - ./caddy_config:/config
    environment:
      - DOMAIN=${DOMAIN:-localhost}
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:2019/config/"]
      interval: 30s
      timeout: 10s
      retries: 3
EOF
}

svc_env() {
  cat <<'EOF'
# Caddy Configuration
DOMAIN=yourdomain.com
EOF
}
svc_caddy_port() { :; }
