#!/usr/bin/bash
# https://gitlab.com/-/snippets/4798776

name=${1:-cs10}
virt-install \
	--connect=qemu:///system \
	--boot=uefi,firmware.feature0.name=secure-boot,firmware.feature0.enabled=no \
	--virt-type=kvm \
	--name=$name \
	--vcpus=4 \
	--memory=8192 \
	--disk=path=/var/lib/libvirt/images/$name-system.qcow2,size=10,sparse=yes,bus=virtio,format=qcow2 \
	--network=network=default \
	--osinfo=fedora40 \
	--extra-args="inst.ks=file:/cs10.ks" \
	--location=https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/ \
	--initrd-inject=cs10.ks
