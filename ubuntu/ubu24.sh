# sudo virt-install \
#   --name ubuntu-guest \
#   --os-variant ubuntu20.04 \
#   --vcpus 2 \
#   --ram 2048 \
#   --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ \
#   --network bridge=virbr0,model=virtio \
#   --graphics none \
#   --extra-args='console=ttyS0,115200n8 serial'

name=${1:-ubu24}
virt-install \
  --name $name \
  --memory 2048 \
  --vcpus 2 \
  --disk size=10,format=qcow2 \
  --os-type linux \
  --os-variant ubuntu24.04 \
  --network network=default \
  # --graphics vnc,listen=0.0.0.0
  --graphics none \
  --console pty,target_type=serial \
  --location=http://archive.ubuntu.com/ubuntu/dists/24.04/main/installer-amd64/ \
  --initrd-inject=autoinstall/user-data.yml \
  --initrd-inject=autoinstall/meta-data.yml \
  --extra-args "autoinstall ds=nocloud;s=/cdrom/ --- console=ttyS0,115200n8"
