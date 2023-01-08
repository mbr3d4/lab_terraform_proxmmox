# lab_terraform_proxmmox

apt-get install libguestfs-tools

virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent

qm create 9000 --name "jammy-server-cloudimg" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9001-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000
