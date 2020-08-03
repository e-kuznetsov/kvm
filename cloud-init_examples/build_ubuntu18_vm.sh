#!/bin/bash -xe

virsh undefine ubuntu18-vm-test
virsh destroy ubuntu18-vm-test
rm -f /var/lib/libvirt/images/ubuntu18-vm-test.qcow2
rm -f /var/lib/libvirt/images/ubuntu18-vm-test-cloud-init.qcow2

qemu-img create -b /var/lib/libvirt/images/bionic-server-cloudimg-amd64.img \
                -f qcow2 /var/lib/libvirt/images/ubuntu18-vm-test.qcow2 40G

qemu-img info /var/lib/libvirt/images/ubuntu18-vm-test.qcow2

cloud-localds -v --network-config=network_config_static.cfg /var/lib/libvirt/images/ubuntu18-vm-test-cloud-init.qcow2 cloud_init.cfg

virt-install --name ubuntu18-vm-test \
  --virt-type kvm --memory 2048 --vcpus 2 \
  --cpu host \
  --disk path=/var/lib/libvirt/images/ubuntu18-vm-test-cloud-init.qcow2,device=cdrom \
  --disk path=/var/lib/libvirt/images/ubuntu18-vm-test.qcow2,device=disk \
  --graphics spice \
  --os-type Linux --os-variant ubuntu18.04 \
  --network bridge=br0,model=virtio \
  --console pty,target_type=serial \
  --noautoconsole
