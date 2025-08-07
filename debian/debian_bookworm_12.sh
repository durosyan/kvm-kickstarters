#!/bin/bash

virt-install --virt-type kvm --name bookworm-amd64 \
--location https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/ \
--os-variant debian12 \
--disk size=10 --memory 1024 \
--graphics none \
--console pty,target_type=serial \
--extra-args "console=ttyS0"
