# Настройка резервирования gitblit

Установить следующие пакеты:

    $ sudo yum install zip perl-HTTP-DAV perl-LWP-Protocol-https

Переписать скрипт `gitblit_backup.pl` в папку /home/gitblit.

В скрипте `gitblit_backup.pl` настроить аутентификацию (пользователь/пароль) для WebDAV и указать пароль для архивов.

Добавить в /etc/crontab следующую сроку, для запуска резервирования в 00:01 каждый день:

    1 0 * * * root /bin/perl /home/gitblit/gitblit_backup.pl

Проверить работоспособность.