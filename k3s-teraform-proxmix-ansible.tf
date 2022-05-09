resource "proxmox_vm_qemu" "master" {
  count= "${length(var.vm_master_ips)}" 

  name = "${var.vm_name_prefix}-master-${count.index}"
  desc = "generic terraform-created vm"
  target_node = "pve"

  clone = "ubuntu-20.04-cloudimg"


  cores = var.cores
  sockets = 1
  memory = var.memory

	disk {
		slot = 0
		type = "scsi"
		storage = var.storage_pool
		size = var.storage_size
	}

  network {
    model = "virtio"
    bridge = var.bridge
  }

  ssh_user = var.ssh_user

  os_type = "cloud-init"
  ipconfig0 = "ip=${lookup(var.vm_master_ips, count.index)}/24,gw=${var.gateway}"

  sshkeys = var.sshkeys
}

resource "proxmox_vm_qemu" "worker" {
  count= "${length(var.vm_worker_ips)}" 

  name = "${var.vm_name_prefix}-worker-${count.index}"
  desc = "generic terraform-created vm"
  target_node = "pve"

  clone = "ubuntu-20.04-cloudimg"


  cores = var.cores
  sockets = 1
  memory = var.memory

	disk {
		slot = 0
		type = "scsi"
		storage = var.storage_pool
		size = var.storage_size
	}

  network {
    model = "virtio"
    bridge = var.bridge
  }

  ssh_user = var.ssh_user

  os_type = "cloud-init"
  ipconfig0 = "ip=${lookup(var.vm_worker_ips, count.index)}/24,gw=${var.gateway}"

  sshkeys = var.sshkeys
}

# Clone k3s-ansible repository #

resource "null_resource" "k3s_ansible_download" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ansible && rm -rf k3s-ansible && git clone --branch ${var.k3s_ansible_version} ${var.k3s_ansible_url}"
  }
}

data "template_file" "k3s_hosts_master" {
  count    = "${length(var.vm_master_ips)}"
  template = "${file("templates/ansible_hosts.tpl")}"

  vars = {
    hostname = "${var.vm_name_prefix}-master-${count.index}"
    host_ip  = "${lookup(var.vm_master_ips, count.index)}"
    ansible_user = var.vm_username
  }
}

data "template_file" "k3s_hosts_worker" {
  count    = "${length(var.vm_worker_ips)}"
  template = "${file("templates/ansible_hosts.tpl")}"

  vars = {
    hostname    = "${var.vm_name_prefix}-worker-${count.index}"
    host_ip     = "${lookup(var.vm_worker_ips, count.index)}"
    ansible_user = var.vm_username
  }
}

# Kubespray master hostname list template #
data "template_file" "kubespray_hosts_master_list" {
  count    = "${length(var.vm_master_ips)}"
  template = "${file("templates/ansible_hosts_list.tpl")}"

  vars = {
    hostname = "${var.vm_name_prefix}-master-${count.index}"
  }
}

# Kubespray worker hostname list template #
data "template_file" "kubespray_hosts_worker_list" {
  count    = "${length(var.vm_worker_ips)}"
  template = "${file("templates/ansible_hosts_list.tpl")}"

  vars = {
    hostname = "${var.vm_name_prefix}-worker-${count.index}"
  }
}

data "template_file" "k3s_all" {
  template = "${file("templates/k3s_all.tpl")}"
}

resource "local_file" "k3s_hosts" {
  content  = "${join("", data.template_file.k3s_hosts_master.*.rendered)}${join("", data.template_file.k3s_hosts_worker.*.rendered)}\n[master]\n${join("", data.template_file.kubespray_hosts_master_list.*.rendered)}\n[node]\n${join("", data.template_file.kubespray_hosts_worker_list.*.rendered)}\n[k3s_cluster:children]\nmaster\nnode"
  filename = "config/hosts.ini"
}
# Create Kubespray k8s-cluster.yml configuration file from Terraform template #
resource "local_file" "k3s_cluster_var" {
  content  = "${data.template_file.k3s_all.rendered}"
  filename = "config/group_vars/all.yml"
}

# Wait 60s for Proxmox VMs to be ready to ssh into #
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous, proxmox_vm_qemu.master, proxmox_vm_qemu.worker ]

  create_duration = "60s"
}


# Execute create Kubespray Ansible playbook #
resource "null_resource" "k3s_create" {

  provisioner "local-exec" {
    command = "cd ansible/k3s-ansible && ansible-playbook -i ../../config/hosts.ini -b -v site.yml"
  }

  depends_on = [local_file.k3s_hosts, null_resource.k3s_ansible_download, local_file.k3s_cluster_var, proxmox_vm_qemu.master, proxmox_vm_qemu.worker, time_sleep.wait_30_seconds ]
}

# Create the local admin.conf kubectl configuration file #
resource "null_resource" "kubectl_configuration" {
  triggers = {
    timestamp = timestamp()
  }
  
  provisioner "local-exec" {
    command = "ansible -i ${lookup(var.vm_master_ips, 0)}, -b -u ${var.vm_username} -m fetch -a 'src=/etc/rancher/k3s/k3s.yaml dest=config/admin.conf flat=yes' all"
  }

  provisioner "local-exec" {
    command = "sed 's/127.0.0.1/${lookup(var.vm_master_ips, 0)}/g' config/admin.conf | tee config/admin.conf.new && mv config/admin.conf.new config/admin.conf && chmod 700 config/admin.conf"
  }

  provisioner "local-exec" {
    command = "chmod 600 config/admin.conf"
  }

  depends_on = [ null_resource.k3s_create ]
}
