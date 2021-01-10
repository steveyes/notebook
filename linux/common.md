[TOC]

# commonly used shell scripts



## ssh 

ssh config

```bash
cat << 'EOF' >> ~/.ssh/config
Host chekawa
    HostName 192.168.250.63
    User scott
    Port 54322
    IdentityFile ~/.ssh/id_rsa
EOF
ssh-copy-id chekawa
```

ssh-keygen

```
sudo -u scott ssh-keygen -f ~/.ssh/id_rsa -t rsa -N "" &>/dev/null
```

get ssh-key

```
sudo -u scott ssh-keygen -y -f ~/.ssh/id_rsa 2>/dev/null
```

ssh-copy-id

```
ssh-copy-id chekawa
```

sshpass

```
command="sysctl -n vm.nr_hugepages"
user="vingee"
password="123456"
sshpass -p "$password" ssh -q -o StrictHostKeyChecking=no ${user}@${host} "$command" < /dev/null 
```

> - sshpass -  auto password 
> - -q -  suppress error output
>
> - </dev/null -  ssh reads from standard input, therefore it eats all your remaining input, you can just connect its standard input to nowhere 





## sudo NOPASSWD

```bash
# this line must be appended at the bottom of the file /etc/sudoers
sudo bash -c 'echo "scott  ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers'
```



## bashrc

```
# bashrc
bashrc=~${user}/.bashrc
bash_user$=~{user}/.bash_user
test -d ${bash_user} || touch ${bash_user}
cat >> ${bashrc} <<-EOH
# CUSTOMIZED bash rc
source ${bash_user}
EOH

cat > ${bash_user} <<-EOH
# alias
alias ltr='ls -ltr'
alias l1='ls -1'

# functions
EOH
	source ${bashrc}
```



## set to multi-user

```
systemctl set-default multi-user.target
systemctl isolate multi-user.target
```



## how to get global ipv4 info

get nic

```
ip -o -4 a | awk -F' +|/' '/scope global/ {print $2}'
```

get ip

```
ip -o -4 a | awk -F' +|/' '/scope global/ {print $4}'
```

get ip

```
/usr/bin/python3 -c "import socket; so=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); so.connect(('8.8.8.8',80)); print(so.getsockname()[0]); so.close()"
```



## get random string

### lowercase

```
date +%s | md5sum | head -c32; echo
```

### uppercase

```
date +%s | sha256sum | base64 | head -c 32; echo
```

### underscore and number and character 

```
< /dev/urandom tr -dc _A-Za-z0-9 | head -c${1:-32}; echo 
tr -dc _A-Za-z0-9 < /dev/urandom | head -c 32; echo
```

### alpha and number

```
strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 32 | tr -d '\n'; echo 
```

### 32bit long string(made up of alpha and number) * 10

```
tr -cd '[:alnum:]' < /dev/urandom | fold -w32 | head -n10
```

### mkpasswd()

```
genpw() {  tr -cd '[:alnum:]' < /dev/urandom | head -c${1:-16}; echo; }
```







