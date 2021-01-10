### 6.9.14  配置虚拟隧道接口建立IPSec over GRE示例





#### 组网需求

如[图6-42](https://support.huawei.com/view/contentview!getFileStream.action?mid=SUPE_DOC&viewNid=EDOC1000097146&nid=EDOC1000097146&partNo=j009&type=htm#fig_dc_cfg_ipsec_009001)所示，Router_1为公司分支网关，Router_2为公司总部网关，分支与总部通过公网建立通信。

原公司分支与总部通过GRE隧道实现私网互通，现要求对分支与总部之间相互访问的流量（不包括组播数据）进行安全保护。因此，可基于虚拟隧道接口方式建立IPSec over GRE，对分支和总部互通的流量进行保护。

**图6-42**  配置虚拟隧道接口建立IPSec over GRE组网图 





#### 配置思路

采用如下思路配置虚拟隧道接口建立IPSec over GRE：

1. 配置物理接口的IP地址和到对端的静态路由，保证两端路由可达。
2. 配置GRE Tunnel接口。
3. 配置IPSec安全提议，定义IPSec的保护方法。
4. 配置IKE对等体，定义对等体间IKE协商时的属性。
5. 配置安全框架，并引用安全提议和IKE对等体。
6. 配置IPSec Tunnel接口，将IPSec Tunnel的源接口配置为GRE Tunnel接口；且IPSec Tunnel的目的地址的路由必须从GRE Tunnel接口出去。
7. 在IPSec Tunnel接口上应用安全框架，使接口具有IPSec的保护功能。
8. 配置IPSec Tunnel接口的转发路由，将需要IPSec保护的数据流引到IPSec Tunnel接口。





#### 操作步骤

1. 分别在Router_1和Router_2上配置物理接口的IP地址和到对端的静态路由

   

   \# 在Router_1上配置接口的IP地址。

   ```
   <Huawei> system-view
   [Huawei] sysname Router_1
   [Router_1] interface gigabitethernet 1/0/0 
   [Router_1-GigabitEthernet1/0/0] ip address 202.138.163.1 255.255.255.0
   [Router_1-GigabitEthernet1/0/0] quit
   [Router_1] interface gigabitethernet 2/0/0
   [Router_1-GigabitEthernet2/0/0] ip address 10.1.1.1 255.255.255.0
   [Router_1-GigabitEthernet2/0/0] quit
   ```

   \# 在Router_1上配置到对端的静态路由，此处假设到对端的下一跳地址为202.138.163.2。

   ```
   [Router_1] ip route-static 202.138.162.0 255.255.255.0 202.138.163.2
   ```

   \# 在Router_2上配置接口的IP地址。

   ```
   <Huawei> system-view
   [Huawei] sysname Router_2
   [Router_2] interface gigabitethernet 1/0/0 
   [Router_2-GigabitEthernet1/0/0] ip address 202.138.162.1 255.255.255.0
   [Router_2-GigabitEthernet1/0/0] quit
   [Router_2] interface gigabitethernet 2/0/0
   [Router_2-GigabitEthernet2/0/0] ip address 10.1.2.1 255.255.255.0
   [Router_2-GigabitEthernet2/0/0] quit
   ```

   \# 在Router_2上配置到对端的静态路由，此处假设到对端下一跳地址为202.138.162.2。

   ```
   [Router_2] ip route-static 202.138.163.0 255.255.255.0 202.138.162.2
   ```

   

2. 配置GRE Tunnel接口

   

   \# 配置Router_1。

   ```
   [Router_1] interface tunnel 0/0/0
   [Router_1-Tunnel0/0/0] ip address 192.168.1.1 255.255.255.0
   [Router_1-Tunnel0/0/0] tunnel-protocol gre
   [Router_1-Tunnel0/0/0] source 202.138.163.1
   [Router_1-Tunnel0/0/0] destination 202.138.162.1
   [Router_1-Tunnel0/0/0] quit 
   ```

   \# 配置Router_2。

   ```
   [Router_2] interface tunnel 0/0/0
   [Router_2-Tunnel0/0/0] ip address 192.168.1.2 255.255.255.0
   [Router_2-Tunnel0/0/0] tunnel-protocol gre
   [Router_2-Tunnel0/0/0] source 202.138.162.1
   [Router_2-Tunnel0/0/0] destination 202.138.163.1
   [Router_2-Tunnel0/0/0] quit 
   ```

   

3. 分别在Router_1和Router_2上创建IPSec安全提议

   

   \# 在Router_1上配置IPSec安全提议。

   ```
   [Router_1] ipsec proposal tran1
   [Router_1-ipsec-proposal-tran1] esp authentication-algorithm sha2-256
   [Router_1-ipsec-proposal-tran1] esp encryption-algorithm aes-128
   [Router_1-ipsec-proposal-tran1] quit
   ```

   \# 在Router_2上配置IPSec安全提议。

   ```
   [Router_2] ipsec proposal tran1
   [Router_2-ipsec-proposal-tran1] esp authentication-algorithm sha2-256
   [Router_2-ipsec-proposal-tran1] esp encryption-algorithm aes-128
   [Router_2-ipsec-proposal-tran1] quit
   ```

   

4. 分别在Router_1和Router_2上配置IKE对等体

   

   \# 在

   Router

   _1上配置IKE安全提议。

   ```
   [Router_1] ike proposal 5
   [Router_1-ike-proposal-5] authentication-algorithm sha2-256
   [Router_1-ike-proposal-5] encryption-algorithm aes-cbc-128
   [Router_1-ike-proposal-5] quit
   ```

   \# 在Router_1上配置IKE对等体。

   ```
   [Router_1] ike peer spub v2
   [Router_1-ike-peer-spub] ike-proposal 5
   [Router_1-ike-peer-spub] pre-shared-key cipher huawei
   [Router_1-ike-peer-spub] quit
   ```

   \# 在Router_2上配置IKE安全提议。

   ```
   [Router_2] ike proposal 5
   [Router_2-ike-proposal-5] authentication-algorithm sha2-256
   [Router_2-ike-proposal-5] encryption-algorithm aes-cbc-128
   [Router_2-ike-proposal-5] quit
   ```

   \# 在Router_2上配置IKE对等体。

   ```
   [Router_2] ike peer spua v2
   [Router_2-ike-peer-spua] ike-proposal 5
   [Router_2-ike-peer-spua] pre-shared-key cipher huawei
   [Router_2-ike-peer-spua] quit
   ```

   

5. 分别在Router_1和Router_2上创建安全框架

   

   \# 在Router_1上配置安全框架。

   ```
   [Router_1] ipsec profile profile1
   [Router_1-ipsec-profile-profile1] proposal tran1
   [Router_1-ipsec-profile-profile1] ike-peer spub
   [Router_1-ipsec-profile-profile1] quit
   ```

   \# 在Router_2上配置安全框架。

   ```
   [Router_2] ipsec profile profile1
   [Router_2-ipsec-profile-profile1] proposal tran1
   [Router_2-ipsec-profile-profile1] ike-peer spua
   [Router_2-ipsec-profile-profile1] quit
   ```

   

6. 分别在Router_1和Router_2上创建IPSec tunnel接口，其中IPSec tunnel接口的source为GRE tunnel口，且IPSec Tunnel的目的地址的路由必须从GRE Tunnel接口出去

   

   \# 配置Router_1。

   ```
   [Router_1] interface tunnel 0/0/1
   [Router_1-Tunnel0/0/1] ip address 192.168.2.1 255.255.255.0
   [Router_1-Tunnel0/0/1] tunnel-protocol ipsec
   [Router_1-Tunnel0/0/1] source tunnel 0/0/0
   [Router_1-Tunnel0/0/1] destination 192.168.1.2
   [Router_1-Tunnel0/0/1] quit
   ```

   \# 配置Router_2。

   ```
   [Router_2] interface tunnel 0/0/1
   [Router_2-Tunnel0/0/1] ip address 192.168.2.2 255.255.255.0
   [Router_2-Tunnel0/0/1] tunnel-protocol ipsec
   [Router_2-Tunnel0/0/1] source tunnel 0/0/0
   [Router_2-Tunnel0/0/1] destination 192.168.1.1
   [Router_2-Tunnel0/0/1] quit
   ```

   

7. 在IPSec tunnel接口上应用各自的安全框架

   

   \# 在Router_1的接口上引用安全框架。

   ```
   [Router_1] interface tunnel 0/0/1
   [Router_1-Tunnel0/0/1] ipsec profile profile1
   [Router_1-Tunnel0/0/1] quit
   ```

   \# 在Router_2的接口上引用安全框架。

   ```
   [Router_2] interface tunnel 0/0/1
   [Router_2-Tunnel0/0/1] ipsec profile profile1
   [Router_2-Tunnel0/0/1] quit
   ```

   \# 此时在Router_1和Router_2上执行**display ipsec profile**会显示所配置的信息。

   

8. 配置Tunnel接口的转发路由，将需要IPSec保护的数据流引到Tunnel接口

   

   \# 在Router_1上配置Tunnel接口的转发路由。

   ```
   [Router_1] ip route-static 10.1.2.0 255.255.255.0 tunnel 0/0/1 
   ```

   

   

   \# 在Router_2上配置Tunnel接口的转发路由。

   ```
   [Router_2] ip route-static 10.1.1.0 255.255.255.0 tunnel 0/0/1 
   ```

   

9. 检查配置结果

   

   \# 配置成功后，分别在Router_1和Router_2上执行**display ike sa v2**会显示所配置的信息，以Router_1为例。

   ```
   [Router_1] display ike sa v2
       Conn-ID  Peer            VPN   Flag(s)                Phase
     ---------------------------------------------------------------
          22    192.168.1.2     0     RD                     2
          21    192.168.1.2     0     RD                     1
   
     Flag Description:
     RD--READY   ST--STAYALIVE   RL--REPLACED   FD--FADING   TO--TIMEOUT
     HRT--HEARTBEAT   LKG--LAST KNOWN GOOD SEQ NO.   BCK--BACKED UP                
   ```

   \# 配置成功后，分别在Router_1和Router_2上执行**display ipsec sa**会显示所配置的信息，以Router_1为例。

   ```
   [Router_1] display ipsec sa
   
   ===============================
   Interface: Tunnel0/0/1
    Path MTU: 1500
   ===============================
   
     -----------------------------
     IPSec profile name: "profile1"
     Mode              : PROF-ISAKMP
     -----------------------------
       Connection ID     : 22
       Encapsulation mode: Tunnel
       Tunnel local      : 192.168.1.1
       Tunnel remote     : 192.168.1.2
       Qos pre-classify  : Disable
       Qos group         : - 
   
       [Outbound ESP SAs]
         SPI: 1599804596 (0x5f5b14b4)
         Proposal: ESP-ENCRYPT-AES-128 SHA2-256-128
         SA remaining key duration (bytes/sec): 1887436800/2489
         Outpacket count       : 0                                                 
         Outpacket encap count : 0                                                 
         Outpacket drop count  : 0
         Max sent sequence-number: 0
         UDP encapsulation used for NAT traversal: N
   
       [Inbound ESP SAs]
         SPI: 2169616882 (0x8151b9f2)
         Proposal: ESP-ENCRYPT-AES-128 SHA2-256-128
         SA remaining key duration (bytes/sec): 1887436800/2489
         Inpacket count        : 0                                                 
         Inpacket decap count  : 0                                                 
         Inpacket drop count   : 0
         Max received sequence-number: 0
         Anti-replay window size: 32
         UDP encapsulation used for NAT traversal: N                               
   ```

   





#### 配置文件

- Router_1的配置文件

  ```
  #
   sysname Router_1
  #
  ipsec proposal tran1
   esp authentication-algorithm sha2-256
   esp encryption-algorithm aes-128
  #
  ike proposal 5
   encryption-algorithm aes-cbc-128
   authentication-algorithm sha2-256
  #
  ike peer spub v2
   pre-shared-key cipher %^%#JvZxR2g8c;a9~FPN~n'$7`DEV&=G(=Et02P/%\*!%^%#
   ike-proposal 5
  #
  ipsec profile profile1
   ike-peer spub
   proposal tran1
  #
  interface Tunnel0/0/0
   ip address 192.168.1.1 255.255.255.0
   tunnel-protocol gre
   source 202.138.163.1
   destination 202.138.162.1
  #
  interface Tunnel0/0/1
   ip address 192.168.2.1 255.255.255.0
   tunnel-protocol ipsec
   source Tunnel0/0/0
   destination 192.168.1.2
   ipsec profile profile1
  #
  interface GigabitEthernet1/0/0
   ip address 202.138.163.1 255.255.255.0
  #
  interface GigabitEthernet2/0/0
   ip address 10.1.1.1 255.255.255.0
  #
  ip route-static 10.1.2.0 255.255.255.0 tunnel0/0/1
  ip route-static 202.138.162.0 255.255.255.0 202.138.163.2
  #
  return
  ```

- Router_2的配置文件

  ```
  #
   sysname Router_2
  #
  ipsec proposal tran1
   esp authentication-algorithm sha2-256
   esp encryption-algorithm aes-128
  #
  ike proposal 5
   encryption-algorithm aes-cbc-128
   authentication-algorithm sha2-256
  #
  ike peer spua v2
   pre-shared-key cipher %^%#K{JG:rWVHPMnf;5\|,GW(Luq'qi8BT4nOj%5W5=)%^%#
   ike-proposal 5
  #
  ipsec profile profile1
   ike-peer spua
   proposal tran1
  #
  interface Tunnel0/0/0
   ip address 192.168.1.2 255.255.255.0
   tunnel-protocol gre
   source 202.138.163.2
   destination 202.138.163.1
  #
  interface Tunnel0/0/1
   ip address 192.168.2.2 255.255.255.0
   tunnel-protocol ipsec
   source Tunnel0/0/0
   destination 192.168.1.1
   ipsec profile profile1
  #
  interface GigabitEthernet1/0/0
   ip address 202.138.162.1 255.255.255.0
  #
  interface GigabitEthernet2/0/0
   ip address 10.1.2.1 255.255.255.0
  #
  ip route-static 10.1.1.0 255.255.255.0 tunnel0/0/1
  ip route-static 202.138.163.0 255.255.255.0 202.138.162.2
  #
  return
  ```