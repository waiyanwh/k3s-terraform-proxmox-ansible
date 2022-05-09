terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  # Configuration options for proxmox provider #
  pm_tls_insecure = true
  pm_api_url = var.proxmox_api_url
  pm_user    = var.proxmox_user
  pm_password= var.proxmox_password
}