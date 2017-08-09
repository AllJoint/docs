# Создание виртуальной машины KVM

Если на хосте виртуализации ещё не настроен сетевой мост, то выполняем следующие настройки:

    # vim /etc/sysconfig/network-scripts/ifcfg-enp1s0
    
Замените его содержимое на следующие параметры:

    DEVICE="enp1s0"
    ONBOOT=yes
    HWADDR="00:00:00:00:00:00"
    BRIDGE=br0

Название интерфейса и mac-адрес нужно заменить на свои. Теперь создаем сетевой интерфейс типа «bridge»:

    # vim /etc/sysconfig/network-scripts/ifcfg-br0
    
Добавьте в него следующие строки:

    DEVICE="br0"
    TYPE=BRIDGE
    ONBOOT=yes
    BOOTPROTO=static
    IPADDR="10.0.1.10"
    NETMASK="255.255.255.192"
    GATEWAY="10.0.1.1"
    DNS1="8.8.8.8"
    DNS2="8.8.4.4"

Значения IPADDR и ниже нужно изменить на свои. Применяем настройки:

    # service network restart

Создаём виртуальную машину

    # sudo virt-install --name <имя вирт. машины> --ram 512 --vcpus=2 --os-variant=rhel7 --cdrom=/var/isostorage/CentOS-7-i386-NetInstall-1611.iso --network bridge --graphics=vnc,password=<пароль>,port=<порт>,listen=0.0.0.0 --disk=/var/lib/libvirt/images/vm_disk.dsk,size=32,bus=virtio --accelerate --virt-type=kvm

Открываем порт для доступа по VNC

    # firewall-cmd --permanent --zone=public --add-port=5953/tcp
    # firewall-cmd --reload

Соединяемся по VNC и устанавливаем операционную систему
