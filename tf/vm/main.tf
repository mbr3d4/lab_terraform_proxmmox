provider "proxmox" {
    pm_api_url = var.proxmox_host["pm_api_url"]
    pm_user = var.proxmox_host["pm_user"]
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "prox-vm" {
  count = length(var.hostnames)
  name = var.hostnames[count.index]
  target_node = var.proxmox_host["target_node"]
  vmid = var.vmid + count.index
  full_clone = true
  clone = "jammy-server-cloudimg"

  cores = 2
  sockets = 1
  vcpus = 2
  memory = 2048
  balloon = 2048
  boot =  "c"
  bootdisk = "virtio0"

  scsihw = "virtio-scsi-pci"

  onboot = false
  agent =  1
  cpu = "kvm64"
  numa = true
  hotplug = "network,disk,cpu,memory"
  
  network {
    bridge = "vmbr0"
    model = "virtio"
  }
  
  ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"
  
  disk {
    #id = 0
    type = "virtio"
    storage = "local-lvm"
    size = "5G"
  }

  os_type = "cloud-init"
  
  #creates ssh connection to check when the CT is ready for ansible provisioning
  connection {
    host = var.ips[count.index]
    user = var.user
    private_key = file(var.ssh_keys["priv"])
    agent = false
    timeout = "3m"
  }
  ciuser = "marcelo"
   sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCStIRocn3UOL15XHjo3bq7ECNg1YBcJMt956oHG5ShORrvZzvDChCtH1UDO4YD4dDEUCxoKvsrYzOyLTrLjN+mukq/jDUceNOoIRDfcqSkZKWpYWmt6QB0tcwpgWACzcJzc0H7HZyr5vxoN18yekHFf1vlBLLd2iGM6PFDvqlCPMC4g2sPmqYI3pyC/2M+21T/g+61kYTZiGJIkYZfG+Ql8uFYxRflp2W9/7VnS4H2o07N4We2NV98zSFxXjsJtLEn51uz0aJAer1Qjkv99mu6K/n64fmxT7xprZ9mNWBQCgFKB7a1v6x//sgi6ZH6hBPmqXGJ8md3HahF7+mYeQJJGjltuCDtVQiNZUwK+tLZ4Pno77TEf9A4A5ChRc0bgRngMwSJ0/ZbHtgxYtdKJTPvA28rOookMnk6+S5WBZv4C/a5ECp7KWiA0GD1iSRK9eTv3ogmgoUnZ6Gc52EaFYIP7SVEOGL5vB/5/H14Qsa4kDQ8UkPVpENdwk9K+AMX6v0= marcelo@fedora
EOF
}


