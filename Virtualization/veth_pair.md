

# Linux 虚拟网络之 veth pair



[TOC]

## 简介

veth pair不是一个设备，而是一对设备，以连接两个虚拟以太网端口。操作veth pair，需要跟namespace一起配合，不然就没有意义。



## 基本概念

>  TUN 和 TAP 设备是 Linux 内核虚拟网络设备，纯软件实现。TUN（TUNnel）设备模拟网络层设备，处理三层报文如 IP 报文。TAP 设备模拟链路层设备，处理二层报文，比如以太网帧。TUN 用于路由，而 TAP 用于创建网桥。OS 向连接到 TUN/TAP 设备的用户空间程序发送报文；用户空间程序可像往物理口发送报文那样向 TUN/TAP 口发送报文，在这种情况下，TUN/TAP 设备发送（或注入）报文到 OS 协议栈，就像报文是从物理口收到一样。



> TUN/TAP: The user-space application/VM can read or write an ethernet frame to the tap interface and it would reach the host kernel, where it would be handled like any other ethernet frame that reached the kernel via physical (e.g. eth0) ports. You can potentially add it to a software-bridge (e.g. linux-bridge)



## 工作原理

TUN/TAP 为简单的点对点或以太网设备，不是从物理介质接收数据包，而是从用户空间程序接收；不是通过物理介质发送数据包，而将它们发送到用户空间程序。
假设您在tap0 上配置 IPX，那么每当内核向 tap0 发送一个 IPX 数据包时，它将传递给应用程序（例如 VTun）。应用程序加密、压缩数据包，并通过 TCP/UDP 发送到对端。对端的应用程序解压缩、解密接收的数据包，并将数据包写入 TAP 设备，然后内核处理数据包，就像该数据包来自真实的物理设备。



## 实验一：simple veth paire

![simple veth paire](D:\download\simple_veth_pair_20190503.png)

```bash

# create the veth pair
ip link add tap1 type veth peer name tap2 

# add the namespaces
ip netns add ns1 
ip netns add ns2 

# attach interfaces to the namespaces
ip link set tap1 netns ns1 
ip link set tap2 netns ns2 

# ip setting
ip netns exec ns1 ip addr add local 192.168.50.1/24 dev tap1 
ip netns exec ns2 ip addr add local 192.168.50.2/24 dev tap2 

# bring up the links
# ip netns exec ns1 ifconfig tap1 up 
ip netns exec ns1 ip link set dev tap1 up 
# ip netns exec ns2 ifconfig tap2 up 
ip netns exec ns2 ip link set dev tap2 up 

# ip check
ip netns exec ns1 ip link show
ip netns exec ns1 ip addr show
ip netns exec ns2 ip link show
ip netns exec ns2 ip addr show

# ping test
ip netns exec ns1 ping 192.168.50.2
ip netns exec ns2 ping 192.168.50.1

```



## 实验二: Linuxbridge with two veth pairs

![](D:\download\Linuxbridge_with_two_veth_pairs_20190503.png)

```bash

# create peer pair
ip link add tap1 type veth peer name br-tap1
ip link add tap2 type veth peer name br-tap2

# add the namespaces
ip netns add ns1
ip netns add ns2

# 

# create the switch
BRIDGE=br-test
brctl addbr $BRIDGE 
# install package: 'bridge-utils' if command brctl not found
brctl stp $BRIDGE off
ip link set dev $BRIDGE up
ip addr add 192.168.50.254/24 dev $BRIDGE

#

#### PORT 1

# attach one side to linuxbridge
brctl addif br-test br-tap1

# attach the other side to namespace
ip link set tap1 netns ns1

# set the ports to up
ip netns exec ns1 ip link set dev tap1 up
ip link set dev br-tap1 up

# set the ip and route
ip netns exec ns1 ip addr add local 192.168.50.1/24 dev tap1
ip netns exec ns1 ip route add 192.168.50.0/24 via 192.168.50.254 dev tap1
ip netns exec ns1 ip route add default via 192.168.50.254 dev tap1 

#

#### PORT 2

# attach one side to linuxbridge
brctl addif br-test br-tap2

# attach the other side to namespace
ip link set tap2 netns ns2

# set the ports to up
ip netns exec ns2 ip link set dev tap2 up
ip link set dev br-tap2 up

# set the ip and route
ip netns exec ns2 ip addr add local 192.168.50.2/24 dev tap2
ip netns exec ns2 ip route add 192.168.50.0/24 via 192.168.50.254 dev tap1
ip netns exec ns2 ip route add default via 192.168.50.254 dev tap1

#
```



## 常用命令

|                                            |                                                              |
| ------------------------------------------ | ------------------------------------------------------------ |
| 创建 Bridge                                | brctl addbr [BRIDGE NAME]                                    |
| 删除 Bridge                                | brctl delbr [BRIDGE NAME]                                    |
| attach 设备到 Bridge                       | brctl addif [BRIDGE NAME] [DEVICE NAME]                      |
| 从 Bridge detach 设备                      | brctl delif [BRIDGE NAME] [DEVICE NAME]                      |
| 查询 Bridge 情况：brctl show               | brctl show                                                   |
| 创建 VLAN 设备                             | vconfig add [PARENT DEVICE NAME] [VLAN ID]                   |
| 删除 VLAN 设备                             | vconfig rem [VLAN DEVICE NAME]                               |
| 设置 VLAN 设备 flag                        | vconfig set_flag [VLAN DEVICE NAME] [FLAG] [VALUE]           |
| 设置 VLAN 设备 qos                         | vconfig set_egress_map [VLAN DEVICE NAME] [SKB_PRIORITY]   [VLAN_QOS]<br />vconfig set_ingress_map [VLAN DEVICE NAME] [SKB_PRIORITY]   [VLAN_QOS] |
| 查询 VLAN 设备情况                         | cat /proc/net/vlan/[VLAN DEVICE NAME]                        |
| 创建 VETH 设备                             | ip link add link [DEVICE NAME] type veth                     |
| 创建 TAP 设备                              | tunctl -p [TAP DEVICE NAME]                                  |
| 删除 TAP 设备                              | tunctl -d [TAP DEVICE NAME]                                  |
| 查询系统里所有二层设备，包括 VETH/TAP 设备 | ip link show                                                 |
| 删除普通二层设备                           | ip link delete [DEVICE NAME] type [TYPE]                     |





```

```

