# IPSec Installation

> IPSec Site-to-Site VPN using PSK on Ubuntu 18.04 to huawei ar1200



## dh-group

>  Diffie-Hellman group for key establishment.

- group1—768-bit Modular Exponential (MODP) algorithm.
- group14—2048-bit MODP group.
- group19—256-bit random Elliptic Curve Groups modulo a Prime (ECP groups) algorithm.
- group2—1024-bit MODP algorithm.
- group20—384-bit random ECP groups algorithm.
- group24—2048-bit MODP Group with 256-bit prime order subgroup.
- group15—3072-bit MODP algorithm.
- group16—4096-bit MODP algorithm.
- group21—521-bit random ECP groups algorithm.



## 配置参数

#### 基本参数

| 配置项 | ar1200        | ubuntu        |
| ------ | ------------- | ------------- |
| IP     | 172.10.0.2/25 | 172.10.0.1/29 |

#### IEK阶段

| 配置项   | ar1200     | ubuntu     |
| -------- | ---------- | ---------- |
| IKE版本  | v2         | v2         |
| 认证方式 | 预共享密钥 | 预共享密钥 |
| 认证算法 | SHA-256    | SHA-256    |
| 加密算法 | AES-256    | AES-256    |
| DH组编号 | Group14    | modp2048   |

> 注：Group14 等于 modp2048

#### IPSec阶段

| 配置项      | ar1200  | ubuntu  |
| :---------- | ------- | ------- |
| 安全协议    | ESP     | ESP     |
| ESP认证算法 | SHA-256 | SHA-256 |
| ESP加密算法 | AES-256 | AES-256 |
| 封装模式    |         |         |



## UBUNTU ipsec 安装与配置

### Strongswan installation  (on ubuntu)

```bash
sudo apt update
sudo apt -y install strongswan strongswan-pki
```



### `ipsec.conf ` (on `ubuntu`)

```bash
sudo bash -c "cat << 'EOF' > /etc/ipsec.conf
config setup
    charondebug="all"
    uniqueids=yes
    strictcrlpolicy=no

conn tunnel
	authby=secret
	left=172.10.0.1
	leftid=172.10.0.1
	leftsubnet=172.16.0.0/12
	right=172.10.0.2
	rightsubnet=192.168.0.0/16
	ike=aes256-sha2_256-modp2048!
	esp=aes256-sha2_256!
	keyingtries=0
	ikelifetime=12h
	lifetime=12h
	dpddelay=30
	dpdtimeout=120
	dpdaction=restart
	auto=start

EOF"
```



### `ipsec.secrets` 

```bash
PSK=""

sudo bash -c "cat << 'EOF' > /etc/ipsec.secrets
172.16.0.1 172.16.0.2 : PSK \"${PSK}\"
EOF"
```



### `sysctl.conf` 

```bash
ip_forward=1
accept_redirects=0
send_redirects=0
ip_no_pmtu_disc=1

sudo bash -c "cat << 'EOF' > /etc/sysctl.conf

# customized
net.ipv4.ip_forward=${ip_forward}
net.ipv4.conf.all.accept_redirects=${accept_redirects}
net.ipv4.conf.all.send_redirects=${accept_redirects}
net.ipv4.ip_no_pmtu_disc=${accept_redirects}
EOF"

sudo sysctl -p
```



---

## troubleshooting

- ipsec ops
  - ipsec restart

  - ipsec start

  - ipsec stop

  - ipsec status

  - ipsec statusall

  - ipsec rereadsecrets

    

- show certs 
  - ipsec listcerts

  - ls certs/site_131_cert.pem | xargs -I{} sudo ipsec pki --print --in {}

  - ls certs/site_132_cert.pem | xargs -I{} sudo ipsec pki --print --in {}

    

- transform information
  - ping -I 10.250.131.1 10.250.132.1
  - ping -I 10.250.132.1 10.250.131.1
  - sudo tcpdump -s0 -vvvn esp
  - ip xfrm state
  - ip xfrm policy



