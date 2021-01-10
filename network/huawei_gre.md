## 配置 Tunnel0/0/0

```
# 进入接口配置模式
interface Tunnel0/0/0

    # 配置IP
    ip address 172.10.0.2 255.255.255.248

    配置 Tunnel0/0/0 的封装模式
    tunnel-protocol gre

    配置 Tunnel0/0/0 的源地址(端口或者IP)
    source GigabitEthernet0/0/8

   配置 Tunnel0/0/0 的目的地址(端口或者IP)
     destination 47.244.4.5
```

## 配置物理接口

```
# 进入接口配置模式
interface GigabitEthernet0/0/8

    tcp adjust-mss 1200
    
    # 配置IP
    ip address 116.228.53.130 255.255.255.248
    
    nat server protocol tcp global 116.228.53.131 443 inside 192.168.100.20 443
    nat server protocol tcp global current-interface 9000 inside 192.168.100.3 9000
    nat server protocol tcp global current-interface 2222 inside 192.168.1.249 22
    nat server protocol tcp global current-interface 16333 inside 192.168.102.107 16333
    nat server protocol tcp global 116.228.53.134 443 inside 192.168.101.20 443
    nat outbound 3999 
    combo-port copper
    ip accounting input-packets 
    ip accounting output-packets
```

## 设置静态路由

```
# 经过 Tunnel0/0/0 到达对端的静态路由
ip route-static 10.22.0.0 255.255.0.0 172.10.0.1
ip route-static 172.16.0.0 255.255.0.0 172.10.0.1
```