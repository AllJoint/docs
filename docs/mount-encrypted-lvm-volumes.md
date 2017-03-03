# Монтирование зашифрованных томов LVM

Для монтирования зашифрованных томов LVM понадобится наличие пакетов **cryptsetup** и **lvm2**, ну или загрузится с установочного диска в режиме восстановления.

### Определяем зашифрованное устройство

    $ sudo lsblk -f /dev/sda
    
    NAME                                          FSTYPE      LABEL UUID                                   MOUNTPOINT
    sda                                                                                                    
    ├─sda1                                        xfs               5254efbc-7bf3-448a-bccf-580c2546e193   /boot
    └─sda2                                        crypto_LUKS       bc856b51-fe35-48d9-b3cb-6983768a5ede

В данном примере зашифрованное устройство - это `/dev/sda2`. 

    $ sudo file -s /dev/sda2

    /dev/sda2: LUKS encrypted file, ver 1 [aes, xts-plain64, sha1] UUID: bc856b51-fe35-48d9-b3cb-6983768a5ede

### Открываем LUKS устройство

    $ sudo cryptsetup luksOpen /dev/sda2 encrypted_device
    Enter passphrase for /dev/sda2: ****************

### Определяем группу томов, в данном примере это `centos`

    $ sudo vgdisplay --short
    "centos" 931,02 GiB [930,96 GiB used / 64,00 MiB free]

### Получаем список логических томов

    $ sudo lvs -o lv_name,lv_size -S vg_name=centos
      LV   LSize  
      home 873,21g
      root  50,00g
      swap   7,75g

### Активируем логический том

    $ sudo lvchange -ay centos/root

или активируем все логические тома группы:

    $ sudo lvchange -ay centos

### Получаем доступ к зашифрованной файловой системе

    $ sudo mount /dev/centos/root /media/some_mount_point

далее свободно получаем доступ к файлам зашифрованной файловой системы, после чего размонтируем файловую систему:

    $ sudo umount /dev/centos/root

### Отключаем логические тома

Получаем список логических томов, если требуется:

    $ sudo lvs -S "lv_active=active && vg_name=centos"
      LV   VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
      home centos -wi-ao---- 873,21g                                                    
      root centos -wi-ao----  50,00g                                                    
      swap centos -wi-ao----   7,75g

Отключаем логический том:

    $ sudo lvchange -an centos/root

или отключаем все логические тома группы:

    $ sudo lvchange -an centos

### Закрываем LUKS устройство

    $ sudo cryptsetup luksClose encrypted_device

