#!/bin/bash
<<ps
	1-requirements
	2-set the apt sourcelist
	3-get the tar files in tmp nagios-4.4.5.tar.gz and nagios plugins

echo -e "127.0.0.1	localhost \n  127.0.0.1	subname.domain.com	sub" > /etc/hosts
echo subname > /etc/hostname
ps
apt-get install -y apache2 apache2-utils autoconf gcc libc6 libgd-dev make  php python python3 unzip wget
apt-get install -y automake autotools-dev bc build-essential dc gawk gettext libmcrypt-dev libnet-snmp-perl libssl-dev snmp 

sed -i '/allow-hotplug ens33/c\auto ens33' /etc/network/interfaces 
sed -i '/iface ens33 inet dhcp/c\iface ens33 inet static' /etc/network/interfaces
sed -i '/iface ens33 inet static/a address 192.168.80.150\nsubnetmask 255.255.225.0\ngateway 192.168.80.1\nnetwork 192.168.80.0\nbroadcast 192.168.80.255\ndns-nameserver 192.168.80.1' /etc/network/interfaces
systemctl restart networking.service
<<comment
-----------------------------reboot system-------------------------------------------------- 
comment

cd /tmp/
tar -zxvf nagios-4.4.5.tar.gz
cd nagios-4.4.5
./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all
make install-groups-users
passwd nagios 
usermod -a -G nagios www-data
sudo make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
a2enmod cgi
a2enmod rewrite
systemctl restart apache2
	# 	passwd will come
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
	#	new password will come
	#	retype it
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
	#	should get 0 warning and error
systemctl restart apache2.service
systemctl restart nagios.service
#going to install plugins
cd /tmp
tar -zxvf nagios-plugins-release-2.2.1.tar.gz
cd  nagios-plugins-release-2.2.1
./tools/setup
./configure
make
make install
cp /tmp/check_ncpa.py /usr/local/nagios/libexec/
cd /usr/local/nagios/libexec/
chmod 755 check_ncpa.py
./check_ncpa.py -V

