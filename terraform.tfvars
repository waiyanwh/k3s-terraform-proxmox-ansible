# API URL for proxmox https://{proxmox_host}:8006/api2/json
proxmox_api_url = "https://192.168.1.100:8006/api2/json"

# Proxmox username , should be like root@pam
proxmox_user = "root@pam"

# Proxmox password 
proxmox_password = "waIyaN2241998"

# SSH public keys to login VMs created by proxmox
sshkeys = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqANVdAcVLAr0jYHyMZ44YKKOh3i+OrCDm+mMxx+fNxxeQIUn8QwPzoscTqqBsIWLV9FmJrSUJOwh/XaOnFwJOcJk+uPvfOTv5cM6NlIOdjKwOXaeQ9tzprgaXvwT5UkIY6phQdmIJnkSYcfKqsnL4Iup1XsS9CgfdgepzDZofN90b5q9DYb/f2dsEyf1c3p0vj+m9Fg1LIdeXAGICz3+XOE0brBrjEdynKF6i/QI6G+xfmtDJJy6iX6O1Lz4IDm/U/HSkngzvQpEm5eMhbmitHmC+XRugdACOMmKMmwgrbf2lBQ4IfZ8dJfEnHHjGUzTlTOjOiAhQdbubSWH4tmbjWq4qg7flqgdtcKLgc96zETX9lIb9mAl7V2l6vFgfyzWHD5vG9QcctPWiynI/dNrqZenJxtp6sKcMrewAhfJbuA+EE+1Vh6hAsYCG7cekBtOC2wIajsW2YxvUMFusz8aiQ0OwWrsRKX8GTPsI5872O7qscaOXF/ImLa1or/e9nXk= waiyan@DESKTOP-B812V06
EOF

# Default gateway IP address for k3s nodes
gateway = "192.168.1.100"

# Bride interface name for VMs
bridge = "vmbr0"

# Disk size for VMs
storage_size = "30G"

# Storage pool name 
storage_pool = "local-lvm"

# Target proxmox nodes 
target_node = "pve"

vm_master_ips = {
  "0" = "192.168.1.200"
}

# IP addresses for k3s worker nodes
vm_worker_ips = {
  "0" = "192.168.1.201"
  "1" = "192.168.1.202"
  "2" = "192.168.1.203"
}

# Proxmox vm name prefix 
vm_name_prefix = "k3s"

# Username for VMs
vm_username = "ubuntu"
