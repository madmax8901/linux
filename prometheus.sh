cp prometheus-2.14.0.linux-amd64/prometheus /usr/local/bin

cp prometheus-2.14.0.linux-amd64/promtool /usr/local/bin

mkdir -p /etc/prometheus

mkdir -p /var/lib/prometheus

useradd --no-create-home -s /bin/false prometheus

cat <<EOF >>/etc/prometheus/prometheus.yml
# Global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute. 
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute. 
  scrape_timeout: 15s  # scrape_timeout is set to the global default (10s).
# A scrape configuration containing exactly one endpoint to scrape:# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
    - targets: ['localhost:9090']
EOF


cat <<EOF >>/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Time Series Collection and Processing Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF
chown prometheus:prometheus /etc/prometheus

chown prometheus:prometheus /var/lib/prometheus

systemctl daemon-reload

systemctl start prometheus

systemctl enable prometheus

systemctl start nfs

systemctl enable nfs

systemctl start rpcbind

systemctl enable rpcbind

cat <<EOF >>/etc/exports
/etc/prometheus *(rw)
/var/lib/prometheus *(rw)
/usr/local/bin *(rw)
EOF

exportfs -a
