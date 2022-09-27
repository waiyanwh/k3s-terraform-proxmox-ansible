variable "proxmox_api_url" {
  description = "Proxmox api url"
}

variable "proxmox_user" {
  description = "Proxmox username"
}

variable "proxmox_password" {
  description = "Proxmox password"
}

variable "master_cores" {
  description = "number of cores to give each vm"
  type = number
  default = 2
}

variable "master_memory" {
  description = "amount of memory in MB give each vm"
  type = number
  default = 2048
}

variable "worker_cores" {
  description = "number of cores to give each vm"
  type = number
  default = 2
}

variable "worker_memory" {
  description = "amount of memory in MB give each vm"
  type = number
  default = 4098
}

variable "sshkeys" {
  description = "ssh keys to drop onto each vm"
  type = string
}

variable "ssh_user" {
  description = "user to put ssh keys under"
  type = string
  default = "ubuntu"
}

variable "gateway" {
  description = "gateway for cluster"
  type = string
}

variable "bridge" {
  description = "bridge to use for network"
  type = string
  default = "vmbr0"
}

variable "storage_size" {
  description = "amount of storage to give nodes"
  type = string
  default = "8G"
}

variable "storage_pool" {
  description = "storage pool to use for disk"
  type = string
  default = "local"
}

variable "target_node" {
  description = "node to deploy on"
  type = string
}

variable "template_name" {
  description = "template to use"
  type = string
  default = "ubuntu-ci"
}

variable k3s_ansible_url {
  default="https://github.com/k3s-io/k3s-ansible.git"
  description = "k3s-ansible git repository"    
}

variable "k3s_ansible_version" {
  default="master"
  description = "k3s-ansible version"
}

variable "vm_master_ips" {
  type        = map(string)
  description = "IPs used for the Kubernetes master nodes"
}

variable "vm_worker_ips" {
  type        = map(string)
  description = "IPs used for the Kubernetes worker nodes"
}

variable "vm_name_prefix" {
  description = "Prefix for the name of the virtual machines and the hostname of the Kubernetes nodes"
}

variable "vm_username"{
  description = "Username to login to vm"
}
