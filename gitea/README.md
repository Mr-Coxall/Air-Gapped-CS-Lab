# Gitea

## Setup Instructions

- create a Proxmox LXC container with community scripts for Docker and Portainer
  - ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```
  - 200 GB disk space, 3 CPU cores, 8 GB RAM
- use the provided `docker-compose.yml` file to run Gitea with PostgreSQL under Portainer, so it just auto restarts
- DO NOT try to setup email, since you need 2FA on Gmail to use it
