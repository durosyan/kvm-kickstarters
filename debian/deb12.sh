#!/bin/bash

# https://wiki.debian.org/DebianInstaller/Preseed

# virt-install --virt-type kvm --name bookworm-amd64 \
#     --location https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/ \
#     --os-variant debian12 \
#     --disk size=10 --memory 1024 \
#     --graphics none \
#     --console pty,target_type=serial \
#     --extra-args "console=ttyS0"

name=${1:-deb12}
virt-install \
    --virt-type kvm \
    --name $name \
    --location https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/ \
    --os-variant debian12 \
    --memory 1024 \
    --disk=path=/var/lib/libvirt/images/$name-system.qcow2,size=10,sparse=yes,bus=virtio,format=qcow2 \
    --graphics none \
    --console pty,target_type=serial \
    --initrd-inject preseed.cfg \
    --extra-args="console=ttyS0 preseed/file=/preseed.cfg"
