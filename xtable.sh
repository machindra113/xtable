#!/usr/bin/bash
sudo apt-get update
#sudo apt dist-upgrade
sudo apt-get install automake ca-certificates gcc iptables-dev libc6-dev libnet-cidr-lite-perl libtext-csv-xs-perl linux-headers-$(uname -r) make pkg-config unzip wget xz-utils
mkdir xtables
cd xtables/
wget https://inai.de/files/xtables-addons/xtables-addons-3.22.tar.xz
sudo tar -xf xtables-addons-3.22.tar.xz
ls
cd xtables-addons-3.22
sudo ./configure
sudo make
sudo make install
#cd
#cd /home/shuhari/xtables/
#cd xtables-addons-3.22
sudo /usr/local/libexec/xtables-addons/xt_geoip_dl
sudo mkdir /usr/share/xt_geoip
sudo /usr/local/libexec/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip/ /home/shuhari/xtables/dbip-country-lite.csv
sudo depmod -a
sudo iptables -m geoip -h
sudo iptables -A INPUT -m geoip --src-cc CN -j DROP
#sudo iptables -A INPUT -m geoip --src-cc CN -j ACCEPT
sudo iptables -L
#sudo iptables -D INPUT  1
sudo iptables -L

