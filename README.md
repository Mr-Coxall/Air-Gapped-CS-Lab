# Air Gapped Computer Science Lab

## Hardware

running on Dell OptiPlex 5050

Run on Proxmox cluster:
- load each of 3 nodes with Proxmox (https://www.proxmox.com/en/downloads)
- set IP range to: 10.100.204.11, 12, 13 (for my network)
  - will be setting common IP address to 10.100.204.10 for cluster
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
