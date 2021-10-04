%post  --interpreter /bin/sh --log=/root/past_install.log
cd /tmp
wget http://192.168.0.112/kick/sec_host.sh
sh /tmp/sec_host.sh

%end
