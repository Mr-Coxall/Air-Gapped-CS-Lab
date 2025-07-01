# Coder IDE

## Create LXC
- docker LXC with portainer: https://community-scripts.github.io/ProxmoxVE/scripts?id=docker
- 100 GB, 3 cores, 24 GB RAM, on Ceph-01
- add them to HA group, so if node goes down they ar automatically moved

## Connect Coder to Gitea, FIRST!!

- in Gitea, create a new "Integrations, Application, OAuth2 Application"
  - the Redirect URI:
    ```
    http://10.100.204.222/api/v2/users/oidc/callback
    ```
  - now use the client ID and the secret in the docker-compose.yml for Coder IDE  

## Coder IDE
- use docker_compose.yml in this repo from proxmox

## Post User Fix

- by default Coder will assign users like "janesmith", but I want "jane.smith"
- run the following commands in the Linux terminal for the Coder instance:
  ```bash
  docker exec -it coder-database-1 psql -U username -d coder
  UPDATE users SET username = 'fred.smith' WHERE username = 'fredsmith';
  ```
  - \q to get out of a psql command
