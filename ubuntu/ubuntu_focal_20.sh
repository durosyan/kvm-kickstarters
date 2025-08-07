sudo virt-install \
  --name ubuntu-guest \
  --os-variant ubuntu20.04 \
  --vcpus 2 \
  --ram 2048 \
  --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
  --network bridge=virbr0,model=virtio \
  --graphics none \
  --extra-args='console=ttyS0,115200n8 serial'

