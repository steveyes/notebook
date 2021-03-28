## tomcat

[toc]

## install Tomcat on CentOS 7

### prerequisites

- `java -version` has appropriate version installed
- must have **sudo privileges**
- run following commands as root as needed

### download 

```
cd ~/Downloads/ 2>/dev/null || { mkdir ~/Downloads; cd ~/Downloads; }
```

for tomcat9

```
wget http://apache.cs.utah.edu/tomcat/tomcat-9/v9.0.44/bin/apache-tomcat-9.0.44.tar.gz
```

or download manually from https://tomcat.apache.org/download-90.cgi

for tomcat 8 

```
wget http://apache.cs.utah.edu/tomcat/tomcat-8/v8.5.64/bin/apache-tomcat-8.5.64.tar.gz
```

or download manually from https://tomcat.apache.org/download-80.cgi

### create tomcat user

```
useradd -m -s /bin/nologin -U -d /opt/tomcat tomcat
# or
useradd -m -s /bin/false -U -r tomcat 
```

### install files

```
cd ~/Downloads/
```

for tomcat 9

```
tar -xvf apache-tomcat-9.0.44.tar.gz -C /opt/
ln -s /opt/apache-tomcat-9.0.44 /opt/tomcat
```

for tomcat 8

```
tar -xvf apache-tomcat-8.5.64.tar.gz -C /opt/ 
ln -s /opt/apache-tomcat-8.5.64 /opt/tomcat
```

### modify  permissions

```
sudo chown -R tomcat: $(realpath /opt/tomcat)
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod ug+x /opt/tomcat/bin/*.sh'
```

### create system unit file

modify the **JAVA_HOME** path as per your installation path

for tomcat 9

```
cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat 9
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_BASE=/opt/tomcat
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

```

for tomcat 8

```
cat > /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=Apache Tomcat 8
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_BASE=/opt/tomcat
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF
```

reload daemon

```
systemctl daemon-reload
```

### enable and restart service

```
systemctl enable tomcat
systemctl start tomcat
systemctl status tomcat
```

### adjust the firewall

```
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd –reload
```

### set up web management interface (optional)

```
cat /opt/tomcat/conf/tomcat-users.xml

<tomcat-users>
...
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="admin" password="admin" roles="admin-gui,manager-gui"/>
</tomcat-users>
```

test installation

```
curl http://${your_domain_or_ip-address}:8080/
curl http://${your_domain_or_ip-address}:8080/manager/html
curl http://${your_domain_or_ip-address}:8080/host-manager/html
```

### configure remote access (optional)

/opt/tomcat/webapps/manager/META-INF/context.xml

```
# before
...
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
...

# after
...
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.1.*" />
...
```

/opt/tomcat/webapps/host-manager/META-INF/context.xml

```
# before
...
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
...

# after
...
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.1.*" />
...
```

### active JMX (optional)

```
cat > /opt/tomcat/bin/setenv.sh << EOF
CATALINA_OPTS="\$CATALINA_OPTS \
-Dcom.sun.management.jmxremote= \
-Dcom.sun.management.jmxremote.port=1099 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Djava.rmi.server.hostname=192.168.1.91"

EOF

systemctl stop tomcat
systemctl start tomcat
ss -tunpl | grep 1099
```



