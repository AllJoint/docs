# Создание виртуальной машины KVM

Создаём виртуальную машину

    $ sudo virt-install --name <имя вирт. машины> --ram 512 --vcpus=2 --os-variant=rhel7 --cdrom=/var/isostorage/CentOS-7-i386-NetInstall-1611.iso --network bridge --graphics=vnc,password=<пароль>,port=<порт>,listen=0.0.0.0 --disk=/var/lib/libvirt/images/vm_disk.dsk,size=32,bus=virtio --accelerate --virt-type=kvm

Открываем порт для доступа по VNC

    $ firewall-cmd --permanent --zone=public --add-port=5953/tcp
    $ firewall-cmd --reload

Соединяемся по VNC и устанавливаем операционную систему