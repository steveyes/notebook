# install ELK 6.2.4 on CentOS 7.x



## warnings

> make sure all lines in the text below the line that start with`# warning:` be reconfigured manually



## packages required

- elasticsearch-6.2.4.tar.gz
- jdk-8u144-linux-x64.tar.gz
- kibana-6.2.4-linux-x86_64.tar.gz
- apache-maven-3.6.3-bin.tar.gz
- elasticsearch-analysis-ik-6.2.4.zip



## install JDK

upload `jdk-8u144-linux-x64.tar.gz` to /opt/

```
cd /opt/
tar -xvf jdk-8u144-linux-x64.tar.gz
cat <<EOF > /etc/profile.d/jdk.sh
#!/usr/bin/env bash
export JAVA_HOME=/opt/jdk1.8.0_144
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib
EOF

source /etc/profile
java -version
```



## install elasticsearch

upload `elasticsearch-6.2.4.tar.gz` to /opt/

```
conf_file=/opt/elasticsearch-6.2.4/config/elasticsearch.yml
bin_file/opt/elasticsearch-6.2.4/bin/elasticsearch

# ungz && untar
cd /opt/
tar -xvf elasticsearch-6.2.4.tar.gz

# create user and group
groupadd elasticsearch
useradd elasticsearch -g elasticsearch -p "es123456"

# chown
chown -R elasticsearch:elasticsearch /opt/elasticsearch-6.2.4

# change jvm
grep 'ES_JAVA_OPTS="-Xms1024m -Xmx1024m"' $bin_file &>/dev/null
[[ $? -ne 0 ]] && sed -i '/ES_JAVA_OPTS.*JVM_OPTIONS/iES_JAVA_OPTS="-Xms1024m -Xmx1024m"' $bin_file

# change cors
echo "\n#cores settings" >> $conf_file
echo "http.cors.enabled: true" >> $conf_file
echo "http.cors.allow-origin: \"\*\"" >> $conf_file

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
EOF

# check config
egrep -v "^#|^$" $conf_file
```

configure sysctl

```
conf_file=/etc/sysctl.d/11-elasticsearch.conf

cat <<-EOF > $conf_file
vm.max_map_count = 262144
EOF

# reload sysctl settings 
sysctl -p

# check config
sysctl -n vm.max_map_count
```

stop firewall 

```
systemctl stop firewalld.service
```

start and check service

```
# run elasticsearch
sudo -iu elasticsearch /opt/elasticsearch-6.2.4/bin/elasticsearch -d

# check service
curl http://127.0.0.1:9200
```



## elasticsearch-head

```
# download elasticsearch-head
yum install -y git
cd /opt/
git clone git://github.com/mobz/elasticsearch-head.git

# install node & npm
curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum install -y nodejs
node -v
npm -v
npm install -g cpm
cd /opt/elasticsearch-head/
cnpm install

# change listen
# vim /opt/elasticsearch-head/Gruntfile.js
# connect -> server -> options : append 
# hostname: '*'

# change default connect ip of elasticsearch
cd /opt/elasticsearch-head/_site/
sed -i s"|http://localhost:9200|http://${host}:9200|"g 

# open port 9100
firewall-cmd --zone=public --add-port=9100/tcp --permanent
firewall-cmd --reload

# start
cd /usr/local/elasticsearch-head
./node_modules/grunt/bin/grunt server
```



## kibana

> upload `kibana-6.2.4-linux-x86_64.tar.gz` to /opt/

install

```
cd /opt/
tar -xvf kibana-6.2.4-linux-x86_64.tar.gz
```

configure kibana

```
conf_file=/ppt/kibana/kibana.yml
# listen on localhost
# host=localhost
# listen on lan ip
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1

es_hosts=("192.168.1.221")
elasticsearch_hosts="["
for host in "${es_hosts[@]}"; do 
	elasticsearch_hosts="$elasticsearch_hosts, \"http://${host}:9200\""; 
done

# '^[, ' --> '[ && '$' --> ']$'
elasticsearch_hosts=$(echo $elasticsearch_hosts  | sed -e s'/^\[, /[/'g -e s'/$/]/'g)

sed -i s"/^#server\.host:.*$/server\.host: $host/"g $conf_file
sed -i -e "s|^#elasticsearch\.hosts:.*$|elasticsearch\.hosts: $elasticsearch_hosts|"g $conf_file

# check config
egrep -v "^#|^$" $conf_file
```

open port

```
firewall-cmd --permanent --zone=public --add-port=5601/tcp
firewall-cmd –-reload
```

start 

```
/usr/local/kibana-6.2.4-linux-x86_64/bin/kibana
```



## elasticsearch-analysis-ik(中文分词)

> upload elasticsearch-analysis-ik-6.2.4.zip to /opt
>
> upload apache-maven-3.6.3-bin.tar.gz to /opt



install maven

```

```

install analysis-ik

```
cd /opt/
unzip elasticsearch-analysis-ik-6.2.4.zip
elasticsearch-analysis-ik-master/
mvn clean install -Dmaven.test.skip=true
cd target/releases/
mkdir /opt/elasticsearch-6.2.4/plugins/ik
cp elasticsearch-analysis-ik-6.5.0.zip /opt/elasticsearch-6.2.4/plugins/ik/
unzip elasticsearch-analysis-ik-6.5.0.zip

```

