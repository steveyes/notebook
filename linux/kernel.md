## kernel doc all in one

https://www.kernel.org/doc/



## kernel doc latest

https://www.kernel.org/doc/html/latest/index.html 



## debian series

https://www.debian.org/doc/manuals/debian-kernel-handbook/index.html



## performance tun

```
kernel.core_pattern=/ebay/core/core.%h.%e.%t
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_max_tw_buckets = 500000
net.ipv4.tcp_syncookies = 0
vm.nr_hugepages = 50000 
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv4.tcp_abort_on_overflow = 1
```





## linux-doc

### for redhat series

install kernel specific docs

```
yum -y install kernel-doc
```

locate the file of interest

```
rpm -ql kernel-doc | grep overcommit
```

view it

```
view /usr/share/doc/kernel-doc-4.18.0/Documentation/vm/overcommit-accounting.rst
```



### for debian series

install kernel specific docs

```
apt -y install linux-doc
```

locate the file of interest

```
dpkg -L linux-doc | grep overcommit
```

view it

```
view /usr/share/doc/linux-doc/vm/overcommit-accounting
```





## kernel source

https://github.com/linux-kernel-labs/linux



## kernel labs

https://linux-kernel-labs.github.io/master/

https://github.com/linux-kernel-labs/linux-kernel-labs.github.io

