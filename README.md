# Air Gapped Computer Science Lab

Run on Proxmox cluster:
- LXC for each student
  - install Coder Server for web access ide
    - https://github.com/coder/code-server
  - can serve their own public_html
- Docker Swarm for auxilary services
  - Authelia: OAuth2
  - Nginx: reverse proxy
  - Apache: web server
    - for course websites
    - for videos
  - GitTea: Git
  - NextCloud: Google type suit
