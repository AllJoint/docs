#!/bin/perl

$gitblit_folder = "/home/gitblit/gitblit";
$temp_folder = "/tmp";
$dest_folder = "/gitblit";
$backup_file_template = "backup-gitblit-";
$backup_file_password = "backup file password";
$dav_user = "backups\@alljoint.ru";
$dav_password = "web dav password";

use HTTP::DAV;

system("/bin/systemctl -q --no-ask-password stop gitblit") == 0 or die("Can't stop gitblit service\n");
sleep(30);

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = 1900 + $year;
$mon++;
$mon = "0$mon" if ($mon < 10);
$mday = "0$mday" if ($mday < 10);

$backup_file = "$temp_folder/$backup_file_template$year$mon$mday.zip";
system("/usr/bin/zip -q -e --password $backup_file_password -r $backup_file $gitblit_folder") == 0
	or die("Can't compress gitblit folder \"$gitblit_folder\" to file \"$backup_file\"\n");

$d = HTTP::DAV->new();
$url = "https://webdav.yandex.ru";

$d->credentials(
	-user => $dav_user,
	-pass => $dav_password,
	-url  => $url,
	-real => "Yandex.Disk"
);

$d->open(-url => $url)
	or die("Couldn't open $url: " . $d->message . "\n");

$d->lock(-url => "$url$dest_folder", -timeout => "10m")
	or die("Won't put unless I can lock for 10 minutes\n");

$d->mkcol(-url => "$url$dest_folder");

$d->put(-local => $backup_file, -url => "$url$dest_folder")
	or die("put failed: " . $d->message . "\n");

$d->unlock(-url => $url);

unlink($backup_file);

system("/bin/systemctl -q --no-ask-password start gitblit") == 0 or die("Can't start gitblit service\n");
