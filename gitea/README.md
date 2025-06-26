# Gitea

## Setup Instructions

- create a Proxmox LXC container with community scripts for Docker and Portainer
  - ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```
  - 200 GB disk space, 3 CPU cores, 24 GB RAM
  - set port to: 80
- use the provided `docker-compose.yml` file to run Gitea with PostgreSQL under Portainer, so it just auto restarts
- DO NOT try to setup email, since you need 2FA on Gmail to use it
- the app.ini file for Gitea will be in directory something like:
  - /data/compose/3/gitea/gitea/conf
  ```bash
[repository]
ROOT = /data/git/repositories
DEFAULT_PRIVATE = true
FORCE_PRIVATE = true
DISABLE_PUBLIC_REPO = true

[oauth2]
ENABLED = true
  ```

![alt Gitea admin login](./gitea_loggins.png)

- you might??
  - the first time you login, you are creating an admin account (you can NOT use the gitea.admin account created in setup!)
