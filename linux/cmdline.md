# cmdline

> configuration files to record the history of command line and push to ELK Stack



## profile.d

```
cat << EOF > /etc/profile.d/cmdline.sh
#!/usr/bin/env bash
#

# command line audit logging
function log2rsyslog()
{
    declare COMMAND
    COMMAND=$(fc -ln -0)
    COMMAND="${COMMAND/\#011 /}"
    TTY=$(tty)
    TTY=${TTY:-?}
    IP=$(ip -o -4 addr | grep global | awk '{print $4}' | cut -d/ -f1)

    if [ -n "${COMMAND}" ]; then
        logger -p local1.notice -t cmdline -- "${IP} : ${USER} : ${PWD} : ${TTY} : ${COMMAND}"
    fi
}

trap log2rsyslog DEBUG
EOF

chmod +x /etc/profile.d/cmdline.sh

```



## rsyslog.d

```
cat << EOF > /etc/rsyslog.d/cmdline.conf
# new template
$template CmdlineTemplate,"%timegenerated:::date-year%-%timegenerated:::date-month%-%timegenerated:::date-day% %timegenerated:::date-hour%:%timegenerated:::date-minute%:%timegenerated:::date-second% :%msg%\n"

# command line audit logging
local1.* -/var/log/cmdline;CmdlineTemplate
EOF
```



## logrotate.d

```
cat << EOF > /etc/logrotate.d/cmdline
/var/log/cmdline {
    # privileges
    su root adm
    # log files are rotated every day
    daily
    # if the log file is missing, go on to the next one without issuing an error message.
    missingok
    # keep the maximum count of the rotated files
    rotate 10
    # using size-based rotation
    size 10k
    # do not rotate the log if it is empty
    notifempty
    create 0640
}
```



## logstash

```
input {
	beats {
		host => "0.0.0.0"
		port => 5044
	}
}

filter {
	mutate {
		split => ["message", " : "]
	}

	if [message][0] {
		mutate {
			add_field => { "datetime" => "%{[message][0]}" }
		}
	}

	if [message][1] {
		mutate {
			add_field => { "ip_address" => "%{[message][1]}" }
		}
	}

	if [message][2] {
		mutate {
			add_field => { "username" => "%{[message][2]}" }
		}
	}

	if [message][3] {
		mutate {
			add_field => { "cur_work_dir" => "%{[message][3]}" }
		}
	}

	if [message][4] {
		mutate {
			add_field => { "terminal" => "%{[message][4]}" }
		}
	}

	if [message][5] {
		mutate {
			add_field => { "command" => "%{[message][5]}" }
		}
		mutate {
			gsub => [ "command", "^\#011 ", "" ]
		}
	}

	mutate {
		remove_field => [ "message" ]
	}
}


output {
	elasticsearch {
		hosts => ["localhost:9200"]
		index => "cmdline"
	}
	stdout { codec => rubydebug }
}

```

