# ssh



## ssh_config

help

```
man ssh
```

format

```
cat << EOF > ~/.ssh/config
Host vm101
    Hostname 192.168.1.101
    Port 22
    User vmuser
Host vm102
    Hostname 192.168.1.102
    Port 22
    User vmuser
EOF	
```



## ssh run command non-interactively

```
password=
host=
command=
sshpass -p $password ssh -q -o StrictHostKeyChecking=no $host "$command" </dev/null
```



## execute shell function over ssh

```
#!/usr/bin/env bash

function install() {
    hostname -f
}

function ssh-exec() {
    ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout="10" "$1" "$(typeset -f $2); $2" &>/dev/null
}

ssh-exec "$remote_ip" "install"
```



## execute shell script over ssh

```
#!/usr/bin/env bash

sudo apt -y update
sudo apt -y install linux-tools-generic
​```

deploy.sh

​```
#!/usr/bin/env bash

function ssh-run() {
    ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout="10" "$1" 'bash -s' <"$2" &>/dev/null
}

ssh-exec "$remote_ip" "./install.sh"
```



