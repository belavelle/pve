pve-stacks is an extensible system to add services via LXC containers into Proxmox.  Services can be added individually or all at once.  Services or LXC containers for currently supported applications are defined in the services directory

bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- all

bash -c "$(curl -fsSL https://raw.githubusercontent.com/belavelle/pve/main/deploy.sh)" -- qdrant

Available services (coming soon):

neo4j, searxng, flowise, langfuse, qdrant and caddy.
