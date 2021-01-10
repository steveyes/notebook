# systemctli





## list enabled

```
systemctl list-unit-files --no-pager | grep enabled
```



## permanently disable a service

```bash
function perm-disable() {
    systemctl disable $1
    systemctl mask $1
    systemctl stop $1
    systemctl -l --no-pager status $1
}

perm-disable bluetooth.service
```

- bluetooth.service
- brltty.service
- ModemManager.service
- pppd-dns.service
- whoopsie.service



## analyze

```
systemd-analyze blame
```

