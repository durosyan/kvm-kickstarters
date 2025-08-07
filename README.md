# KVM and kickstart files

Just some scripts to spin up and provision vritual machines with a kick start file.

[RHEL Docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/installation_guide/ch-kickstart2)
[Kickstart files](https://www.cyberciti.biz/faq/kvm-install-centos-redhat-using-kickstart-ks-cfg/)

To make the password required for a kickstart file, the passwords are hashed in SHA512, use: `openssl passwd -6`
