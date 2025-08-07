#!/bin/bash
# sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm

sudo apt update && sudo apt install -y \
	qemu-system-x86 \
	libvirt-daemon-system \
	libvirt-clients \
	bridge-utils \
	virtinst
