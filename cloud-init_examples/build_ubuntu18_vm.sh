#!/bin/bash

cloud-localds -v --network-config=network_config_static.cfg test1-seed.qcow2 cloud_init.cfg

virt-install --name test1 \
  --virt-type kvm --memory 2048 --vcpus 2 \
  --cpu host \
  --disk path=snapshot-bionic-server-cloudimg.qcow2,device=disk \
  --disk path=test1-seed.qcow2,device=cdrom \
  --graphics vnc \
  --os-type Linux --os-variant ubuntu18.04 \
  --network bridge=br1,model=virtio \
  --console pty,target_type=serial
