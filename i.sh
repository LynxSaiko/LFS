install -v -m 755 init /lib/sysvinit/init
ln -sfv /lib/sysvinit/init /sbin/init
install -v -m 755 halt killall5 reboot shutdown runlevel sulogin fstab-decode logsave bootlogd /sbin
install -v -m 755 last mesg readbootlog utmpdump wall /usr/bin
install -v -m 755 -d /etc
install -v -m 755 -d /etc/inittab.d
install -v -m 644 ../doc/initscript.sample /etc
