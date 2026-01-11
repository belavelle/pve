# PVE Stacks

An extensible automation framework for deploying containerized services on Proxmox VE using LXC containers. Deploy individual services or entire stacks with a single command—no manual configuration required.

## Features

- 🚀 **One-Command Deployment** - Deploy services directly from GitHub
- 🔒 **Security Hardened** - Strict bash error handling with `set -Eeuo pipefail`
- 🐳 **Docker Ready** - Automated Docker and Docker Compose installation
- 🔄 **Automatic Template Management** - Downloads and caches LXC templates
- 🌐 **Reverse Proxy** - Integrated Caddy server for service routing
- � **Status Monitoring** - Real-time view of service health and resources
- �🗑️ **Clean Removal** - Safely destroy containers and volumes
- 📦 **Extensible** - Easy to add new services via modular scripts

## Quick Start

### Prerequisites

- Proxmox VE 8.0+ host
- Root access to Proxmox host
- Internet connectivity

### Deploy Services

Run directly from your Proxmox host:

```bash
# Deploy all services
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- all

# Deploy a single service
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- qdrant

# Deploy multiple specific services
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- neo4j flowise langfuse
```

### Check Status

View the status of all services:

```bash
# Show status of all services
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- status
```

**Example output:**
```
SERVICE    CT   STATUS   IP              CPU    MEMORY       UPTIME
---------- ---- -------- --------------- ------ ------------ ----------
neo4j      201  running  192.168.1.10    15.2%  1024M/2048M  2 days
searxng    202  running  192.168.1.11    5.1%   512M/1024M   2 days
flowise    203  stopped  -               -      -            -
langfuse   204  running  192.168.1.12    8.3%   768M/2048M   1 day
qdrant     205  running  192.168.1.13    12.1%  800M/2048M   3 hours
caddy      206  running  192.168.1.14    2.5%   128M/512M    2 days
```

### Destroy Services

```bash
# Destroy a single service (prompts for confirmation)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- destroy qdrant

# Destroy all services (prompts for each)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- destroy all
```

## Available Services

| Service | Description | Default Container ID |
|---------|-------------|---------------------|
| **neo4j** | Graph database platform | 201 |
| **searxng** | Privacy-respecting metasearch engine | 202 |
| **flowise** | Low-code LLM orchestration tool | 203 |
| **langfuse** | LLM observability and analytics | 204 |
| **qdrant** | Vector similarity search engine | 205 |
| **caddy** | Reverse proxy and automatic HTTPS | 206 |

### Service Access & Credentials

#### Neo4j (Graph Database)
- **URL:** `http://neo4j.yourdomain.com` or `http://<container-ip>:7474`
- **Default Credentials:** `neo4j` / `password`
- **Change Password:** Edit `.env` file in container at `/opt/stacks/neo4j/.env`
- **Bolt Port:** 7687 for programmatic access
- **Note:** First login will prompt to change default password via web UI

#### SearXNG (Metasearch)
- **URL:** `http://searxng.yourdomain.com` or `http://<container-ip>:8080`
- **Authentication:** None required (public search)
- **Configuration:** Edit settings in container at `/opt/stacks/searxng/searxng/settings.yml`
- **Note:** Secret key auto-generated on first deployment

#### Flowise (LLM Orchestration)
- **URL:** `http://flowise.yourdomain.com` or `http://<container-ip>:3000`
- **Default Credentials:** `admin` / `admin`
- **Change Password:** Edit `.env` file in container at `/opt/stacks/flowise/.env`
- **API Documentation:** `http://flowise.yourdomain.com/api-docs`
- **Note:** Change credentials immediately after first deployment

#### Langfuse (LLM Analytics)
- **URL:** `http://langfuse.yourdomain.com` or `http://<container-ip>:3000`
- **Initial Setup:** Create account on first visit (becomes admin)
- **Database:** PostgreSQL included (no separate setup needed)
- **API Keys:** Generate in web UI under Settings → API Keys
- **Note:** First user to sign up becomes organization owner

#### Qdrant (Vector Search)
- **URL:** `http://qdrant.yourdomain.com` or `http://<container-ip>:6333`
- **Dashboard:** `http://qdrant.yourdomain.com/dashboard`
- **API Docs:** `http://qdrant.yourdomain.com/docs`
- **Authentication:** None by default (add API keys via config if needed)
- **gRPC Port:** 6334 for high-performance clients

#### Caddy (Reverse Proxy)
- **Admin API:** `http://<container-ip>:2019`
- **HTTP:** Port 80
- **HTTPS:** Port 443 (auto-configured if domain has valid DNS)
- **Configuration:** Auto-generated `Caddyfile` in `/opt/stacks/caddy/`
- **Note:** Automatically proxies all services to `http://service.yourdomain.com`

### Changing Default Passwords

**Important:** Change default passwords immediately after deployment!

```bash
# SSH into Proxmox host
ssh root@proxmox-host

# Access a container
pct enter <container-id>

# Edit the .env file for the service
cd /opt/stacks/<service-name>
nano .env

# Restart the service
docker compose restart
```

## Configuration

### Environment Variables

Configure deployment by setting environment variables before running the script:

```bash
# Set root password for containers (recommended)
export PVE_ROOT_PASSWORD="your-secure-password"

# Deploy with custom settings
bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- qdrant
```

### Inventory Configuration

For persistent configuration, clone the repository and edit `inventory.sh`:

```bash
git clone https://github.com/belavelle/pve.git
cd pve
```

Edit `inventory.sh`:

```bash
# Storage configuration
PVE_STORAGE="local-lvm"          # Storage pool for containers
PVE_BRIDGE="vmbr0"                # Network bridge
PVE_DNS="1.1.1.1"                 # DNS server
PVE_GATEWAY=""                    # Default gateway (empty = auto)

# Template configuration
PVE_TEMPLATE_STORAGE="local"      # Template storage location
PVE_TEMPLATE_FLAVOR=""            # Template flavor (empty = debian-12)
PVE_OSTEMPLATE=""                 # Pin specific template (optional)

# Security
PVE_ROOT_PASSWORD="your-password" # Root password for containers (optional)

# Service definitions (service:ct_id:hostname:ip)
SERVICES=(
  "neo4j:201:neo4j:dhcp"
  "searxng:202:searxng:dhcp"
  "flowise:203:flowise:dhcp"
  "langfuse:204:langfuse:dhcp"
  "qdrant:205:qdrant:dhcp"
  "caddy:206:caddy:dhcp"
)
```

Then deploy locally:

```bash
bash deploy.sh all
```

## Architecture

### Project Structure

```
.
├── deploy.sh              # Main deployment orchestrator
├── inventory.sh           # Configuration and service definitions
├── lib/
│   ├── pve-lxc-lib.sh    # Core Proxmox/LXC functions
│   ├── assert.sh         # Assertion utilities
│   ├── exec.sh           # Execution helpers
│   ├── fs.sh             # Filesystem utilities
│   └── log.sh            # Logging functions
└── services/
    ├── caddy.sh          # Caddy reverse proxy
    ├── flowise.sh        # Flowise AI orchestration
    ├── langfuse.sh       # Langfuse LLM analytics
    ├── neo4j.sh          # Neo4j graph database
    ├── qdrant.sh         # Qdrant vector DB
    └── searxng.sh        # SearXNG metasearch
```

### Deployment Flow

1. **Validation** - Validates service names, container IDs, and prerequisites
2. **Template Management** - Downloads and caches Debian LXC templates
3. **Container Creation** - Creates privileged LXC container with Docker support
4. **Configuration** - Sets root password (if provided)
5. **Installation** - Installs Docker, Docker Compose, and base tools
6. **Service Deployment** - Deploys service-specific Docker Compose stack
7. **Reverse Proxy** - Updates Caddy configuration for new services

## Adding New Services

Create a new service module in `services/`:

```bash
#!/usr/bin/env bash

# Define resource defaults
svc_defaults() {
  DISK_GB="${DISK_GB:-20}"
  MEM_MB="${MEM_MB:-2048}"
  SWAP_MB="${SWAP_MB:-512}"
  CORES="${CORES:-2}"
}

# Generate docker-compose.yml
svc_compose() {
  cat <<'EOF'
services:
  myservice:
    image: myimage:latest
    ports:
      - "8080:8080"
    restart: unless-stopped
EOF
}

# Optional: Expose port for Caddy reverse proxy
svc_caddy_port() {
  echo "8080"
}

# Optional: Generate .env file
svc_env() {
  cat <<'EOF'
MY_VAR=value
EOF
}
```

Add to `inventory.sh`:

```bash
SERVICES=(
  # ... existing services ...
  "myservice:207:myservice:dhcp"
)
```

## Advanced Usage

### Custom IP Addressing

Use static IPs or IP ranges in `inventory.sh`:

```bash
SERVICES=(
  "neo4j:201:neo4j:192.168.1.10/24"           # Static IP
  "searxng:202:searxng:192.168.1.20/24-192.168.1.30/24"  # IP range (auto-select)
)
```

### Template Pinning

Pin a specific LXC template version:

```bash
export PVE_OSTEMPLATE="local:vztmpl/debian-12-standard_12.12-1_amd64.tar.zst"
```

### Accessing Services

After deployment with Caddy:

- Direct: `http://<container-ip>:<port>`
- Via Caddy: `http://servicename.yourdomain.com`

Configure domain in `deploy.sh`:

```bash
DOMAIN="${DOMAIN:-yourdomain.com}"
```

## Troubleshooting

### Container Won't Start

```bash
# Check container status
pct status <container-id>

# View container logs
pct exec <container-id> journalctl -xe
```

### Template Download Fails

```bash
# Update template cache
pveam update

# List available templates
pveam available
```

### Network Issues

```bash
# Verify bridge exists
ip link show vmbr0

# Check container network
pct exec <container-id> ip addr
```

## Security Considerations

- **Root Passwords**: Use environment variables instead of hardcoding in `inventory.sh`
- **Firewall**: Configure Proxmox firewall rules for container access
- **Updates**: Regularly update containers: `pct exec <id> apt update && apt upgrade -y`
- **Backups**: Use Proxmox backup functionality for container snapshots

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your service module to `services/`
4. Test thoroughly on a non-production Proxmox host
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Community scripts adapted from [ProxmoxVE Community Scripts](https://github.com/community-scripts/ProxmoxVE) (MIT License)
- Inspired by Infrastructure as Code principles

