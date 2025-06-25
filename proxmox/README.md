# Install Proxmox

- get latest ISO
- boot from USB (select UEFI)
- (place USB ethernet in USB port)
- load OS onto NVME
- use time zone: UTC
- pick "Managed interface" of the USB ethernet
- "Hostname": "Node-01.xxx"
- changed IP addess to: xx.xx.xx.11/24 (.10 will be common IP address later)

# Setup Proxmox

## Initial Fixes on each Machine
- run the [Proxmox Community: Post Install script](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install) in the shell
  - DO NOT disable HA!
 
## Create the Cluster
  - on the master node (not with the common IP, but its IP), select:
    - DataCenter
    - Cluster
    - Create Cluster
- give it a Cluster Name (School-VPS)
- copy the "Join Information"
- goto the next node (with their IP address, not common) and join the cluster
  - enter in the password of the master node
- you will have to re-login to the servers

## Install Ceph
- ensure you are NOT using the shared IP address
- best to place disks in groups of 3, so you have quarum for redundancy
- whip the drives first
  - if they have a "hold" on them:
  ```bash
  lsblk
  dmsetup remove <ID from above>
  ``` 
- start on the master node (with its IP address)
- select:
  - Ceph
  - change the "repository" to "No-Subscription"
  - ensure this one finishes completely before doing any others, this master node needs to be done first
- next setup storage:
  - add monitors
  - add managers
  - whip each drive
  - create OSD on each drive
  - create common pool
    - this is where you want groups of 3! 
 
## Install KeepAlived
- [YouTube Video](https://www.youtube.com/watch?v=82Q4SZMW-zg&list=PLwcxrRo-VwS2gNgY-GlPGDYZ6KCwSu3tD&index=3)
- [GitHub Repo](https://github.com/mrp-yt/Galaxy-Home-Lab/blob/main/Services/keepalived/keepalived-setup.md)
- REMEMBER: each machine gets a different priority (lower) and the "Master" node gets a special file, when setting up the config file
- also, ensure you set the IP to the one you are using as the single IP for cluster
- you can turn off the master and see if the others will pick up from the common IP address

## CloudFlare
- use community script
  - [Proxmox VE Cloudflared LXC](https://community-scripts.github.io/ProxmoxVE/scripts?id=cloudflared)
- from Cloudflare website, run the Debian install (the one on the left that starts it as a service)
  - be patient, it takes time to start
- then add into Cloudflare an "access", so it is not jsut open to the world! 
- in CloudFlare Dashboard change the following:
  - noTLSVerify: true
  - disableChunkedEncoding: true
 
## Tailscale
- use community script
  - [Proxmox VE Tailscale LXC](https://community-scripts.github.io/ProxmoxVE/scripts?id=add-tailscale-lxc)
- create a new Debian 12 (must be) LXC
- then in the node run the install command
- once installed, reboot the LXC
- now run these commands (from: https://tailscale.com/kb/1019/subnets)
  - ```bash
    echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
    ```
  - now you need to make this permanent after reboot; open up /etc/sysctl.d/99-sysctl.conf
  - add the follow to the end:
  - ```bash
    net.ipv4.ip_forward = 1
    net.ipv6.conf.all.forwarding = 1
    ```
- now reboot again to make the changes permanent
  - you can check by running:
    ```bash
    sysctl net.ipv4.ip_forward
    sysctl sysctl net.ipv4.ip_forward
    ```
- then run this command:
  -  tailscale up --advertise-exit-node --advertise-routes=10.100.204.0/24 --accept-routes
  -  replace the "10.100.204.0/24" with your VLAN that your proxmox cluster is on
- then goto Tailscale, find the new node and turn on "Exit Node" & "Subnets"
  - "Exit Node" will let you exit traffic out this node (you now have a VPN!)
  - "Subnet", will let you connect to other VMs in the VLAN
  - REMEMBER: all VMs will most like still not let anyone ssh into them using "root", so you will need to create another user on any VM that you want to SSH into!
