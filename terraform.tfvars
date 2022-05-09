# API URL for proxmox https://{proxmox_host}:8006/api2/json
proxmox_api_url = ""

# Proxmox username , should be like root@pam
proxmox_user = ""

# Proxmox password 
proxmox_password = ""

# SSH public keys to login VMs created by proxmox
sshkeys = <<EOF
  ssh-rsa xxxxxxxxxxxxxxxxxxxxxxx
EOF

# Default gateway IP address for k3s nodes
gateway = ""

# Bride interface name for VMs
bridge = "vmbr0"

# Disk size for VMs
storage_size = "30G"

# Storage pool name 
storage_pool = "local-lvm"

# Target proxmox nodes 
target_node = "pve"

vm_master_ips = {
  "0" = "192.168.2.200"
}

# IP addresses for k3s worker nodes
vm_worker_ips = {
  "0" = ""
  "1" = ""
  "2" = ""
}

# Proxmox vm name prefix 
vm_name_prefix = "k3s"

# Username for VMs
vm_username = "ubuntu"