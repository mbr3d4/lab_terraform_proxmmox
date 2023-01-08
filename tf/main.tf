provider "proxmox" {
    pm_api_url = var.proxmox_host["pm_api_url"]
    pm_user = var.proxmox_host["pm_user"]
    pm_password = var.proxmox_host["pm_pass"]
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
    size = "20G"
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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB1qnLAsO6oxLfha/IXYhXgYfqYp2JLGtsRuBi7NEKU4IqFr5NLJnAsXzQGknKMyDNWo1XLCvjknB4by3UmSQ1FflzLuHSMoWfGkyVsyIV8QOKcr45xC72UB/J7o0f6QSJgM6xh3qkq+zbxylhBhGwIlW9COmJvHBlNPFfmrtfJqJ3uRUnggS/cntYEKb1OnbC1ss7goW+TxaN7YkE+ZjIAixFbUz0arvebPVCupMDmuLQ4XJxWUb6RS4SJHoKtoRceLK6rlpOkLxX4aIZxc/jWdaP/IhCFRbNG3Gu2FkizWbrC8y7ZmmuLoKmHCDIrj8KwWsDFHwkvmfHCfS2vBVKk5lk/rUWHaUmKM2/V+UWB2XYwW7qWrIs99N8eUaAgPd/dhm4vIbs+hiTKP3ivZTzQl2HUIjvMngfcLKHOkUSk25s/clo0iV1MV/8hZ/zVGkUPBz/79U0rL5XYl3G/p0gHeuPj8/EMqg1b+zvEfN/Jw08q9Dyq3CZoz91w1vlvAM= vagrant@jenkins
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeyxyV6HNmPDMyz9MHYql3aUs5sov2noumCnGHSS/ZmRe8oUA/9Zf7oNSt2wIKKex5/YGANMKEHtY6gmVZZMmZB/bwkwISJs7oOeQSvX28k2e+EZh0lyvac8480DL8te2oE/bL9kdAJegwrBqxOXixrxwqcMRX222Rseo8lplCCdxU2H4VtDtDi0+YJPQnunBMz0CP5J/FBsib1G4W9GWsdTtSRLf32hU30lxWtGc/mxHL7kWOK3UUBIvdEkoRCZG6sHGBkCCodm36AcIjczxX6F+jYc1HjRy1OmUaroLJjWW8X9wQzzciB8/gT1Sye9PFaPshErXLv8OudzUVNIZrl4fETr7QmLsIpvAeImGwKXIlp2YkRTkU+nAAe1Gm7Wof1MVuA+Qvc2duanbHMzNbnXyvSKz9xyjpOjMaD+qU7nlxKKp/nlybHVJSqm+cs04A/1N8oGoPxohbT8Waxu2Tcv+pvEk4XmqPWueK2ed9seQBR2WNcVYNX2EsXlZm798= root@jenkins
EOF
}


