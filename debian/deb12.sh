#!/bin/bash
# https://wiki.debian.org/DebianInstaller/Preseed

name=${1:-deb12}
tmp_preseed="/tmp/preseed.cfg"
sed "s/^d-i netcfg\/get_hostname .*/d-i netcfg\/get_hostname string $name/" preseed.cfg > "$tmp_preseed"
virt-install \
    --virt-type kvm \
    --name $name \
    --location https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/ \
    --os-variant debian12 \
    --memory 1024 \
    --disk=path=/var/lib/libvirt/images/$name-system.qcow2,size=10,sparse=yes,bus=virtio,format=qcow2 \
    --graphics none \
    --console pty,target_type=serial \
    --initrd-inject $tmp_preseed \
    --extra-args="console=ttyS0 preseed/file=/$(basename "$tmp_preseed")"
