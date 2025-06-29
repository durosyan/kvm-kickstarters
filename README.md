# CentOS 10 Stream KVM

Just a script to spin up and provision a CentOS 10 Stream machine with a kick start file.

[RHEL Docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/installation_guide/ch-kickstart2)
[Kickstart files](https://www.cyberciti.biz/faq/kvm-install-centos-redhat-using-kickstart-ks-cfg/)

To make the password required for CentOS 10 Kickstart, the passwords are hashed in SHA512, use: `openssl passwd -6`
