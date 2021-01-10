## 下载

- Linux tcpdump的下载路径：
  http://www.tcpdump.org/#latest-release

- Android tcpdump的获取
  先在Android source code中source 、lunch后，整个build一遍后，再到external/libpcap下去mm -B，build出libpcap.a，再到external/tcpdump下去mm -B就可以得到tcpdump



## 一般基本命令

```bash
root@ubuntu:~#  tcpdump -X -i eth0 -s 0 -w /data/ethernet.pcap
```

- `-X` : 当分析和打印时，tcpdump 会打印每个包的头部数据, 同时会以16进制和ASCII码形式打印出每个包的数据(但不包括连接层的头部)。这对于分析一些新协议的数据包很方便。
- `-i eth0` : 只抓经过接口eth0的包
- `-s 0` : 抓取数据包时默认抓取长度为68字节。加上-s 0 后可以抓到完整的数据包
- `-w /data/ethernet.pcap` : 保存成pcap文件，方便用wireshark分析
  使用以上命令即可以抓取到全部的eth0的网络包

>  如果你想抓取所有网口的网络包，可以把**-i eth0改成-i any**即可



## 指定固定ip抓包

除此之外，还可以加入要抓取的协议，哪个ip，哪个port口来获取网络包，如下

```bash
tcpdump -X -i eth0 -s 0 host www.baidu.com -w ethernet.pcap
```

- `host www.baidu.com`： 截获所有与www.baidu.com通信的本地主机，收到的和发出的所有数据包，也可以直接使用host 119.75.216.20



## 指定特定协议抓包

```bash
tcpdump icmp -i eth0 -t -s 0 -c 100 and dst port ! 22 and src net 192.168.171.0/24 -w ./net.pcap
```


- `icmp: ip tcp arp rarp 和 tcp、udp、icmp`这些选项等都要放到第一个参数的位置，用来过滤数据报的类型

- 如果只知道协议号，参考 `/etc/protocols`，可以使用 proto `$proto_id`, 例如想抓 esp 的包，`cat /etc/protocols | grep ^esp`, 得知协议号为 50，那么就可以这样写：`tcpdump proto 50`

- `-i eth0`: 只抓经过接口eth0的包，-i any，表示捕获所以interface的包

- `-t `: 不显示时间戳

- `-s 0`: 抓取数据包时默认抓取长度为68字节。加上-s 0 后可以抓到完整的数据包

- `-c 100` : 只抓取100个数据包

- `dst port ! 22` : 不抓取目标端口是22的数据包

- `src net 192.168.171.0/24` : 数据包的源网络地址为192.168.171.0/24

- `-w ./net.pcap` : 保存成pcap文件，方便用wireshark分析

- `and`: 即针对ip，但你又想指定目的地址或端口，或者想指定源地址或端口时，就得加上and

---
[1]: <http://blog.jobbole.com/94855/>
[2]: http://blog.csdn.net/qq_24421591/article/details/50936469