%post  --interpreter /bin/sh --log=/root/post_install.log
cd /tmp
wget http://192.168.0.112/kick/prometheus-2.14.0.linux-amd64.tar
wget http://192.168.0.112/kick/prometheus.sh
tar -xvf prometheus-2.14.0.linux-amd64.tar
sh /tmp/prometheus.sh

%end
