rm -rf prometheus 
mkdir prometheus
cp prometheus.yml prometheus/

cd prometheus



#https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04

#step 1 and step 2



sudo useradd --no-create-home --shell /bin/false prometheus

sudo rm -rf /etc/prometheus

sudo rm -rf /var/lib/prometheus

sudo mkdir /etc/prometheus

sudo mkdir /var/lib/prometheus

sudo chown prometheus:prometheus /etc/prometheus

sudo chown prometheus:prometheus /var/lib/prometheus



curl -LO https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz

sha256sum prometheus-2.0.0.linux-amd64.tar.gz

#e12917b25b32980daee0e9cf879d9ec197e2893924bd1574604eb0f550034d46  prometheus-2.0.0.linux-amd64.tar.gz





tar xvf prometheus-2.0.0.linux-amd64.tar.gz

sudo cp prometheus-2.0.0.linux-amd64/prometheus /usr/local/bin/

sudo cp prometheus-2.0.0.linux-amd64/promtool /usr/local/bin/





sudo chown prometheus:prometheus /usr/local/bin/prometheus

sudo chown prometheus:prometheus /usr/local/bin/promtool



sudo cp -r prometheus-2.0.0.linux-amd64/consoles /etc/prometheus

sudo cp -r prometheus-2.0.0.linux-amd64/console_libraries /etc/prometheus

sudo chown -R prometheus:prometheus /etc/prometheus/consoles

sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries



rm -rf prometheus-2.0.0.linux-amd64.tar.gz prometheus-2.0.0.linux-amd64





#step 3 

#only create prometheus.yaml



#add below from  https://prometheus.io/docs/guides/cadvisor/ to prometheus.yaml

# scrape_configs:

# - job_name: cadvisor

#   scrape_interval: 5s

#   static_configs:

#   - targets:

#   - cadvisor:8080







#step 4

#https://www.digitalocean.com/community/tutorials/how-to-install-prometheus-on-ubuntu-16-04


sudo cp prometheus.yml /etc/prometheus/
sudo -u prometheus /usr/local/bin/prometheus  --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/  --web.console.templates=/etc/prometheus/consoles  --web.console.libraries=/etc/prometheus/console_libraries





#test

sudo curl -s  http://10.10.0.187:9090/graph | grep Collection
