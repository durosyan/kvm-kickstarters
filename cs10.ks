# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax

# Use network installation
url --url='https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/os/'

# Repositories
repo --name='AppStream' --baseurl=https://mirror.stream.centos.org/10-stream/AppStream/x86_64/os/
repo --name=epel --mirrorlist='https://mirrors.fedoraproject.org/metalink?repo=epel-10&arch=x86_64'

# Use cmdline install
# uncommend either cmdline or graphical; not both
cmdline
#graphical

# shutdown when finished
shutdown

# Keyboard layouts (english)
keyboard --vckeymap=gb --xlayouts='gb'

# System language
lang en_GB.UTF-8

# Network information
network  --bootproto=dhcp --device=enp1s0 --ipv6=auto --activate

# Root password
# password: mysuperpassword
rootpw --iscrypted $6$sTl..plfgEjSxym4$rRhu5I1O9OqGVCQdgW.m3Uccw/9IkDSGx9Wu1gWMXmznJEZnm3AAPUCub7F28K/KUZezx5SiEz4z73PTs2cBe.

# users
# password: myveryhardpassword
user --groups=wheel --name=durosyan --password=$6$7bk.Zz22jCOv5Yb4$6QAVlCViZGoFfWJeFpVus8UHuuH5FWPkjt8cftaZ1xF8jzARCLJk5yBrXm0zwzMKO1EyqvnV0mnTpecfpjsLv1 --iscrypted --gecos='durosyan'
sshkey --username=durosyan 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+3chBE7SoWWGX7VRWOwlm7RCzVuQZZhJU4tGdseiL7 durosyan@acernitro'

# Run the Setup Agent on first boot
firstboot --disable

# Do not configure the X Window System
skipx

# System services
services --enabled='chronyd,qemu-guest-agent'

# System timezone
timezone Etc/UTC --utc

# Partitioning
ignoredisk --only-use=vda
bootloader --location=mbr

%pre
# create partitions
wipefs -af /dev/vda
sfdisk /dev/vda << EOF
label: gpt
size=512M, type=uefi
size=1G, type=linux
size=1G, type=swap
size=+, type=linux
EOF

%end

# partitions
part /boot/efi --fstype=efi --onpart=vda1
part /boot --fstype='ext4' --onpart=vda2
part swap --onpart=vda3
part / --fstype='ext4' --onpart=vda4

%packages
@^minimal-environment
bash-completion
cloud-init
cloud-utils-growpart
dnf-plugins-core
epel-release
git
htop
kexec-tools
rpmconf
rsync
tmux
tmux-powerline
vim
vim-powerline
wireshark-cli

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end


%post --log=/root/ks-post.log

# grub
grubby \
	--args='console=ttyS0,38400n8d vconsole.keymap=gb' \
	--update-kernel=ALL

# network security
cat << EOF > /etc/sysctl.d/60-network-security.conf
# Turn on SYN-flood protections.
net.ipv4.tcp_syncookies=1

# Ignore source-routed packets
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0

# Ignore ICMP redirects from non-GW hosts
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=1
net.ipv4.conf.default.secure_redirects=1

# Dont pass traffic between networks or act as a router
net.ipv4.ip_forward=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0

# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks.
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1

# Ignore ICMP broadcasts to avoid participating in Smurf attacks
net.ipv4.icmp_echo_ignore_broadcasts=1

# Ignore bad ICMP errors
net.ipv4.icmp_ignore_bogus_error_responses=1

# Log spoofed, source-routed, and redirect packets
net.ipv4.conf.all.log_martians=1
net.ipv4.conf.default.log_martians=1

# Addresses of mmap base, heap, stack and VDSO page are randomized
kernel.randomize_va_space=2

# Reboot the machine soon after a kernel panic.
kernel.panic=10
EOF

# enable all repos
dnf config-manager --enable crb --enable epel --enable highavailability --enable nfv --enable resilientstorage --enable rt

# configure tmux
cat << 'EOF' > /etc/skel/.tmux.conf
# terminal colors
set -g default-terminal 'screen-256color'

# history size
set -g history-limit 20000

# status color
set -g status-bg clour60

# resize
setw -g aggressive-resize on

# mouse
set -g mouse off

# navigation
setw -g mode-keys vi

# tmux-powerline
source '/usr/share/tmux/powerline.conf'
EOF

# configure vim-powerline
curl -L downloads.woralelandia.com/projects/vim/vimrc > /etc/skel/.vimrc
cat << 'EOF' >> /etc/skel/.vimrc
" Enable status bar always
set laststatus=2

EOF

# configure PS1
cat << 'EOF' >> /etc/skel/.bashrc
PS1='\[\e[95m\]\u@\h\[\e[0m\]: \[\e[38;5;27m\]\w\[\e[0m\]\$ '

EOF

# copy skel files to root and users
cp --update=all /etc/skel/.* /root/
for u in /home/*; do
	cp /etc/skel/.* $u/
done

# infinite history and date
cat << 'EOF' > /etc/profile.d/history.sh
export HISTCONTROL=erasedups:ignoredups
export HISTSIZE=-1
export HISTTIMEFORMAT='%F %T '
EOF

%end

