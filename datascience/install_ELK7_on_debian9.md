# install ELK 7.x on debian9.x



## warnings

> make sure all lines in the text below the line that start with`# warning:` be reconfigured manually




## add ELK apt repository

> - applicable for kibana
> - applicable for elasticsearch
> - applicable for logstash
> - applicable for filebeat
> - ...

```
sudo apt update
sudo apt -y install gnupg2 apt-transport-https git
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
# wo don't need image whose type is oss here
# echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee  /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
```



## nginx

install

```
apt -y update
apt -y install nginx
```

cert and key

```
# generate self-signed SSL/TLS certificates
sudo openssl req -x509 -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/kibana-selfsigned.key \
    -out /etc/ssl/certs/kibana-selfsigned.crt

# create Deffie-Hellman group
openssl dhparam -out /etc/nginx/dhparam.pem 2048
```

configure nginx

```
# warning: ip_kibana: the ip address of the kibana
ip_kibana=192.168.1.202

cat<<-EOF > /etc/nginx/sites-available/kibana
server {
    listen 80 default_server;
    server_name _;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 default_server ssl http2;
    server_name _;
    
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    
    ssl_certificate /etc/ssl/certs/kibana-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/kibana-selfsigned.key;
    
    ssl_protocols TLSv1 TLSV1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/nginx/dhparam.pem;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_ecdh_curve secp384r1;
    ssl_session_timeout 10m;
    ssl_session_cache shared:SSL:10m;
    resolver 192.168.1.1 8.8.8.8 valid=300s;
    resolver_timeout 5s;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    
    access_log /var/log/nginx/kibana_access.log;
    error_log /var/log/nginx/kibana_error.log;
    
    auth_basic "Authentication Required";
    auth_basic_user_file /etc/nginx/kibana.users;
    
    location / {
        proxy_pass http://${ip_kibana}:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
```

create authentication file

```
username=admin
# warning: password: the authentication password for nginx
password=963852
printf "${username}:$(openssl passwd -crypt ${password})\n" > /etc/nginx/kibana.users
```

active nginx config

```
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/
nginx -t &>/dev/null && nginx -s reload
which ufw &>/dev/null
[[ $? -eq 0 ]] && ufw allow 'Nginx Full'
```

start and enable

```
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

check service

```
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)
netcat -nv -q2 $host 80 </dev/null &>/dev/null && echo "nginx OK" || echo "nginx failed"
```




## kibana( ELK apt repository required )

install

```
sudo apt -y install kibana
sudo systemctl daemon-reload
```

configure

```
conf_file=/etc/kibana/kibana.yml
# listen on localhost
# host=localhost
# listen on lan ip
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)

# # warning: es_hosts: the nodes ip address of the elasticsearch 
_es_hosts=("192.168.1.221" "192.168.1.222")
es_hosts=$(printf ", \"http://%s:9200\"" "${_es_hosts[@]}")
es_hosts="[${es_hosts:2}]"

sed -i s"/^#server\.host:.*$/server\.host: $host/"g $conf_file
sed -i -e "s|^#elasticsearch\.hosts:.*$|elasticsearch\.hosts: $elasticsearch_hosts|"g $conf_file

# check config
egrep -v "^#|^$" $conf_file
```

start and enable

```
sudo systemctl stop kibana
sudo systemctl start kibana
sudo systemctl enable kibana
sudo systemctl status kibana
```

check service

```
netcat -nv -q2 $host 5601 </dev/null &>/dev/null && echo "kibana OK" || echo "kibana failed"
```



## elasticsearch( ELK apt repository required )

install

```
sudo apt -y install elasticsearch
sudo systemctl daemon-reload
```

configure elasticsearch.yml

```
conf_file=/etc/elasticsearch/elasticsearch.yml

# listen on localhost
# host=localhost
# listen on lan ip
# # warning: es_hosts: the nodes ip address of the elasticsearch 
_es_hosts=("192.168.1.221" "192.168.1.222")
_es_hosts_suffix=()
for eh in "${_es_hosts[@]}"; do
  _es_hosts_suffix+=(${eh##*.})
done
cluster_name="yabe"
node_name=$(hostname)
node_prefix=${node_name/${host##*.}}

if [[ -n "$_es_hosts" ]]; then
    es_hosts=$(printf ", \"${node_prefix}%s\"" "${_es_hosts_suffix[@]}")
    es_hosts="[${es_hosts:2}]"
    discover_seed_hosts=$(printf ", \"%s\"" "${_es_hosts[@]}")
    discover_seed_hosts="[${discover_seed_hosts:2}"
done

sed -i s"/^#network\.host:.*$/network\.host: $host/"g $conf_file
sed -i s"/^#cluster\.name:.*$/cluster\.name: $cluster_name/"g $conf_file
sed -i s"/^#node\.name:.*$/node\.name: $node_name/"g $conf_file
if [[ -n "$_es_hosts" ]]; then
    sed -i s"/^#cluster\.initial_master_nodes:.*$/cluster\.initial_master_nodes: $es_hosts/"g $conf_file
    sed -i s"/^#discovery\.seed_hosts:.*$/discovery\.seed_hosts: $discover_seed_hosts/"g $conf_file
fi
sed -i s"|^#bootstrap.memory_lock:.*|bootstrap.memory_lock: true|"g $conf_file

echo "\n#cores settings" >> $conf_file
echo "http.cors.enabled: true" >> $conf_file
echo "http.cors.allow-origin: \"\*\"" >> $conf_file

# check config
egrep -v "^#|^$" $conf_file
```

configure elasticsearch jvm.options

```
conf_file=/etc/elasticsearch/jvm.options

# jvm
xms=2g
xmx=2g
sed -i s"/^-Xms.*/-Xms$xms/"g $conf_file
sed -i s"/^-Xmx.*/-Xmx$xmx/"g $conf_file

# check config
egrep -v "^#|^$" $conf_file
```

configure limit

```
conf_file=/etc/security/limits.d/elasticsearch.conf

cat <<-EOF > $conf_file

# elasticsearch
elasticsearch soft nofile 65535
elasticsearch hard nofile 65535
elasticsearch soft nproc 4096
elasticsearch hard nproc 4096
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
EOF

# check config
egrep -v "^#|^$" $conf_file
```

configure sysctl

> vm.max_map_count  is already 262144 of debian9 or later release

```
conf_file=/etc/sysctl.d/11-elasticsearch.conf

cat <<-EOF > $conf_file
vm.max_map_count = 262144
vm.swappiness = 1
EOF

# reload sysctl settings 
sysctl -p

# check config
sysctl -n vm.max_map_count
```

start and enable

```
sudo systemctl stop elasticsearch
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl status elasticsearch
```

check service

```
netcat -nv -q2 $host 9200 </dev/null &>/dev/null && echo "elasticsearch OK" || echo "elasticsearch failed"
```



## elasticsearch-head

```
# install node and npm
# curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
# curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
apt install -y nodejs
node --version
npm --version

# install grunt-cli
npm install -g grunt-cli

# install elasticsearch-head
cd /opt/
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head/
npm install phantomjs-prebuilt@2.1.16 --ignore-scripts
npm install
npm audit fix
npm install -g

# change default connect ip of elasticsearch
cd /opt/elasticsearch-head/_site/
sed -i s"|http://localhost:9200|http://${host}:9200|"g 


# start elasticsearch-head as daemon
cd /opt/elasticsearch-head/
npm run start
# open http://{es-host-ip}:9100/
```



## logstash (ELK apt repository required)

install

```
apt install -y default-jdk
java -version
apt install -y logstash
sudo systemctl daemon-reload 
```

configure logstash

```

```

start and enable

```
sudo systemctl stop logstash
sudo systemctl start logstash
sudo systemctl enable logstash
sudo systemctl status logstash
```



## filebeat(ELK apt repository required)

install

```
apt install filebeat
```

configure filebeat

> get the config

```
egrep -v '^ *#|^$' /etc/filebeat/filebeat.yml
```

```
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/nginx/access_json*.log*
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false
setup.template.settings:
  index.number_of_shards: 1
output.logstash:
  hosts: ["192.168.1.231:5044"]
  index: "nginx-access_json"
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
```

configure logstash for debug

```
cat <<EOF > /tmp/01-logstash.conf
input {
  beats {
    port => 5044
    codec => json
  }
}

filter {
    mutate {
        add_field => {
            "index_prefix" => "%{[@metadata][beat]}-%{[@metadata][version]}"
        }        
    }
}

output {
    stdout { 
        codec => rubydebug
    }
}

EOF

/usr/share/logstash/bin/logstash -f /tmp/01-logstash.conf
```

it debug OK configure logstash for production

```
cat <<EOF > /etc/logstash/conf.d/nginx-access_log.conf
input {
  beats {
    port => 5044
    codec => json
  }
}

output {
    elasticsearch { 
        hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] 
        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    }
}

EOF

/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/nginx-access_log.conf
```





## ref

https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html