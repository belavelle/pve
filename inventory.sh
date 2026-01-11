#!/usr/bin/env bash
PVE_STORAGE="local-lvm"
PVE_BRIDGE="vmbr0"
PVE_DNS="1.1.1.1"
PVE_GATEWAY=""
PVE_TEMPLATE_STORAGE="local"
PVE_TEMPLATE_FLAVOR=""
# Optional: Set your template to just "debian-12" or leave empty and let the script pick.
# Optional: if you want to pin an exact template filename, set PVE_OSTEMPLATE explicitly.
PVE_OSTEMPLATE="${PVE_OSTEMPLATE:-}"

# Optional: Set root password for containers (can also use environment variable)
# PVE_ROOT_PASSWORD="your-secure-password"
# Or export it: export PVE_ROOT_PASSWORD="your-secure-password"

SERVICES=(
  "neo4j:201:neo4j:dhcp"
  "searxng:202:searxng:dhcp"
  "flowise:203:flowise:dhcp"
  "langfuse:204:langfuse:dhcp"
  "qdrant:205:qdrant:dhcp"
  "caddy:206:caddy:dhcp"
)
