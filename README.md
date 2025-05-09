# Air Gapped Computer Science Lab

- Authelia: OAuth2
- Nginx: reverse proxy
- Apache: web server
  - for course websites
  - for videos
- student Debian server
  - for websites
  - for development enviroment
- GitTea: Git
- Coder: containerized IDEs
  - https://github.com/coder/code-server 
  - local docker registry
- NextCloud: Google type suit

Run on Proxmox cluster:
- LXC for each student
  - install Coder Server for web access ide
- Dicker Swarm for auxilary services
