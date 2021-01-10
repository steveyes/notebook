# logstash 7.x



## load config from string in command line

stdin and stdout

```
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { stdout{} }'
```

stdout to rubydebug

```
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { stdout { codec => rubydebug } }'
```

stdout to elasticsearch

```
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { elasticsearch { hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] } }'
```

stdout to elasticsearch and rubydebug

```
/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { elasticsearch { hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] } stdout { codec => rubydebug } }'
```



## load config from file

stdout to elasticsearch and rubydebug

```
cat <<EOF > /tmp/01-logstash.conf
input { stdin { } }
output {
    elasticsearch { hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] }
    stdout { codec => rubydebug } 
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/01-logstash.conf
```



## input from system then output to elasticsearch

```
cat<<EOF > /tmp/02-logstash.conf
input { 
    file {
        path => "/var/log/messages"
        type => "system"
        start_position => "beginning"
    }
}

output {
    elasticsearch { 
        hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] 
        index => "system-%{+YYYY.MM.dd}"
    }
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/02-logstash.conf
```



## input from system log and java log then output to elasticsearch

```
cat<<EOF > /tmp/03-logstash.conf
input { 
    file {
        path => "/var/log/messages"
        type => "system-message"
        start_position => "beginning"
    }
    file {
        path => "/var/log/elasticsearch.log"
        type => "elasticsearch"
        start_position => "beginning"
    }
}

output {
    if [type] == "system-message" {
        elasticsearch { 
            hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] 
            index => "system-%{+YYYY.MM.dd}"
        }
    }
    if [type] == "elasticsearch" {
        elasticsearch { 
            hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] 
            index => "elasticsearch-%{+YYYY.MM.dd}"
        }
    }
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/03-logstash.conf
```

## \

## * multiline 

```
cat<<EOF > /tmp/04-logstash.conf
input {
    stdin {
        codec => multiline {
            pattern => "^\["
            negate => true
            what => "previous"
        }
    }
}

output {
    stdout {
        codec => "rubydebug"
    }
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/04-logstash.conf
# input the fowllowing text for testing
[1]
[2]
[3 the line 1 of 3
the line 2 of 3
the line 3 of 3]
[4]

```



## listen on rsyslog (514) and collect syslog

configure logstash for debugging (on server side)

```
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)

cat<<EOF > /tmp/05-logstash.conf
input {
    syslog {
        type => "system-syslog"
        host => "$host"
        port => 514
    }
}

output {
    stdout {
        codec => "rubydebug"
    }
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/05-logstash.conf
```

configure rsyslog (on client side)

```
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)
conf_file=/etc/rsyslog.conf

# send to remote server
egrep '\*\.\* @@${host}:514' $conf_file
[[ $? -ne 0 ]] && cat <<EOF >> $conf_file

# send to remote server
*.* @@${host}:514
EOF
    
# diff check 
diff ${conf_file}*

unset conf_file

which ufw
[[ $? -eq 0 ]] && sudo ufw allow 514/tcp

systemctl restart rsyslog

# run on client end and check stdout on server end
logger "hello world, I'm logger $host"
```

configure logstash for production

```
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)

cat<<EOF > /etc/logstash/conf.d/main.conf
input {
    syslog {
        type => "system-syslog"
        host => "$host"
        port => 514
    }
}

output {
    if [type] == "system-syslog" {
        elasticsearch { 
            hosts => ["192.168.1.221:9200",  "192.168.1.222:9200"] 
            index => "system-syslog-%{+YYYY.MM.dd}"
        }
    }
}
EOF

/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/main.conf

# run on client end and check stdout on server end
logger "hello world, I'm logger $host"
```



## listin on tcp port

configure logstash for debugging (on server side)

```
host=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)

cat<<EOF > /tmp/06-logstash.conf
input {
    tcp {
        type => "some-log-else"
        host => "$host"
        port => 6666
    }
}

output {
    stdout {
        codec => "rubydebug"
    }
}
EOF

/usr/share/logstash/bin/logstash -f /tmp/06-logstash.conf
```

test on client side

```
server_ip=192.168.1.231
client_ip=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)
nc -q1 $server_ip 6666 < /etc/fstab
echo "hello world from $client_ip" | nc -q1 $server_ip 6666 
echo "hello world from $client_ip" > /dev/tcp/$server_ip/6666
```



## grok

configure logstash for debugging

```
cat << EOF > /tmp/07-logstash.conf
input {
    stdin { }
}

filter {
    grok {
        match => { "message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}" }
    }
}

output {
    stdout {
        codec => "rubydebug"
    }
}

EOF

/usr/share/logstash/bin/logstash -f /tmp/07-logstash.conf
```

test (paste the following line into stdin)

```
55.3.244.1 GET /index.html 15824 0.043
```





## ref

https://www.elastic.co/guide/en/logstash/current/index.html