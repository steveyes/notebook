# system security





##  for centos 7

### clamav

```
yum -y install epel-release
yum install –y clamav clamav-update
freshclam
mkdir -p /root/clamav/infection
clamscan -ir / -l clamscan.log --move=/root/clamav/infection
```



### deny root ssh login

```
sudo sed -ri 's/^# PermitRootLogin.*$/PermitRootLogin no/g' /etc/ssh/sshd_config
grep "PermitRootLogin" /etc/ssh/sshd_config
systemctl restart sshd
```



### allow root ssh login

```
sed -ri 's/^PermitRootLogin(.*)$/# PermitRootLogin\1/g' /etc/ssh/sshd_config
grep "PermitRootLogin" /etc/ssh/sshd_config
systemctl restart sshd
```



### firewall-cmd blacklist

```
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --new-ipset=blacklist --type=hash:ip --option=family=inet --option=hashsize=4096 --option=maxelem=200000
firewall-cmd --permanent --add-rich-rule='rule source ipset=blacklist drop'
firewall-cmd --permanent --ipset=blacklist --add-entry="139.99.61.189"
firewall-cmd --permanent --ipset=blacklist --add-entry="51.91.122.254"
firewall-cmd --permanent --ipset=blacklist --add-entry="136.244.87.14"
firewall-cmd --reload
firewall-cmd --list-all

firewall-cmd --ipset=blacklist --get-entries
yum install -y ipset
ipset list
```



### fail2ban

install 

```
sudo yum install epel-release
sudo yum check-update
sudo yum update
sudo yum install -y fail2ban-firewalld
```

config

```
cat > /etc/fail2ban/jail.local << EOF
[DEFAULT]
ignoreip = 127.0.0.1/8
ignorecommand =
bantime = 86400
findtime = 600
maxretry = 3
banaction = iptables-multiport
backend = systemd
EOF

cat > /etc/fail2ban/jail.d/sshd.local << EOF
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
bantime = 86400
maxretry = 5
EOF

systemctl start firewalld
systemctl enable firewalld

systemctl start fail2ban.service
systemctl enable fail2ban.service
```

check

```
fail2ban-client status
fail2ban-client status sshd
tailf /var/log/fail2ban.log
tailf /var/log/secure
```

unbanning an IP address

```
ip_address=
fail2ban-client set sshd unbanip ${ip_address}
fail2ban-client unban ${ip_address}
```

