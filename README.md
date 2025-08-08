# KVM and kickstart files

Just some scripts to spin up and provision vritual machines in an unnattended way with qemu/kvm.


- [RHEL Docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/installation_guide/ch-kickstart2)
- [Kickstart files](https://www.cyberciti.biz/faq/kvm-install-centos-redhat-using-kickstart-ks-cfg/)


To make the password required for a kickstart file, the passwords are hashed in SHA512, use: 


`openssl passwd -6`


Apparently to check the validity of the debian preseed file use:


`debconf-set-selections -c preseed.cfg`


Helpful commands:


```bash
virsh console <vm-name>
virsh dominfo <vm-name>
virsh domifaddr <vm-name>
virsh dumpxml <vm-name>
```

---

![a picture of nearly headless nick from harry potter, because this setup is, well, nearly headless](./image.png)