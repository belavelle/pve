#!/usr/bin/env bash

# Neo4j - Graph Database Platform
# Official docs: https://neo4j.com/docs/

svc_defaults() {
  DISK_GB="${DISK_GB:-30}"
  MEM_MB="${MEM_MB:-2048}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

svc_compose() {
  cat <<'EOF'
services:
  neo4j:
    image: neo4j:latest
    container_name: neo4j
    restart: unless-stopped
    ports:
      - "7474:7474"  # HTTP
      - "7473:7473"  # HTTPS
      - "7687:7687"  # Bolt
    volumes:
      - ./data:/data
      - ./logs:/logs
      - ./import:/var/lib/neo4j/import
      - ./plugins:/plugins
    environment:
      - NEO4J_AUTH=${NEO4J_AUTH:-neo4j/password}
      - NEO4J_server_memory_heap_initial__size=512m
      - NEO4J_server_memory_heap_max__size=1G
      - NEO4J_server_memory_pagecache_size=512m
      - NEO4J_dbms_security_procedures_unrestricted=apoc.*
    healthcheck:
      test: ["CMD", "cypher-shell", "-u", "neo4j", "-p", "password", "RETURN 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s
EOF
}

svc_env() {
  cat <<'EOF'
# Neo4j Authentication (username/password)
NEO4J_AUTH=neo4j/your-secure-password
EOF
}

svc_caddy_port() {
  echo "7474"
}
