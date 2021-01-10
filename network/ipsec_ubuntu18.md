# IPSec Installation on Ubuntu 18

> StrongSwan based IPSec Site-to-Site VPN using RSA-CERT on Ubuntu 18.04



## Scenario

- sudo user:  **`scott`**
- server list
    >
    | server   | external ip        | internal network | role   |
    | -------- | ------------------ | ---------------- | ------ |
    | CA       | 192.168.250.130/24 | `Null`           | CA     |
    | site_101 | 192.168.250.131/24 | 10.250.131.0/24  | Router |
    | site_102 | 192.168.250.132/24 | 10.250.132.0/24  | Router |



## Strongswan installation (binary) (on all server)

```bash
sudo apt update
sudo apt -y install strongswan strongswan-pki
```



## CA's X.509 cert generation (on `CA`)

```bash
cd /etc/ipsec.d
```

gen key of CA

```bash
sudo bash -c "ipsec pki --gen --type rsa --size 4096 --outform pem > private/CA_key.pem"
```

gen cert of CA

```bash
sudo bash -c "ipsec pki --self --ca --lifetime 3650 --in private/CA_key.pem --type rsa --dn \"C=CN, O=keystore, CN=Root CA\" --outform pem > cacerts/CA_cert.pem"
```

check cert files

``` bash
sudo file private/CA_key.pem
sudo file cacerts/CA_cert.pem
```

copy CA's cert to both site

```bash
sudo scp cacerts/CA_cert.pem scott@192.168.250.131:~/ && ssh scott@192.168.250.131 "sudo cp CA_cert.pem /etc/ipsec.d/cacerts/"
sudo scp cacerts/CA_cert.pem scott@192.168.250.132:~/ && ssh scott@192.168.250.132 "sudo cp CA_cert.pem /etc/ipsec.d/cacerts/"
```



## `site_131`'s  X.509 cert generation (on `CA`)

```bash
cd /etc/ipsec.d
```

gen key of `site_131` 

```bash
sudo bash -c "ipsec pki --gen --type rsa --size 2048 --outform pem > private/site_131_key.pem"
```

gen cert of `site_131`

```bash
sudo bash -c "ipsec pki --pub --in private/site_131_key.pem --type rsa | ipsec pki --issue --lifetime 730 --cacert cacerts/CA_cert.pem --cakey private/CA_key.pem --dn \"C=CN, O=keystore, CN=site_131\" --san site_131 --flag serverAuth --flag ikeIntermediate --outform pem > certs/site_131_cert.pem"
```

check cert files

```bash
sudo file private/site_131_key.pem
sudo file certs/site_131_cert.pem
```

copy cert to `site_131`

```bash
sudo scp private/site_131_key.pem scott@192.168.250.131:~/ && ssh scott@192.168.250.131 "sudo mv site_131_key.pem /etc/ipsec.d/private/"
sudo scp certs/site_131_cert.pem scott@192.168.250.131:~/ && ssh scott@192.168.250.131 "sudo mv site_131_cert.pem /etc/ipsec.d/certs/"
```



## `site_132`'s  X.509 cert generation (on `CA`)

```bash
cd /etc/ipsec.d
```

gen key of `site_132`

```bash
sudo bash -c "ipsec pki --gen --type rsa --size 2048 --outform pem > private/site_132_key.pem"
```

gen key of `site_132`

```bash
sudo bash -c "ipsec pki --pub --in private/site_132_key.pem --type rsa | ipsec pki --issue --lifetime 730 --cacert cacerts/CA_cert.pem --cakey private/CA_key.pem --dn \"C=CN, O=keystore, CN=site_132\" --san site_132 --flag serverAuth --flag ikeIntermediate --outform pem > certs/site_132_cert.pem"
```

check cert files

```bash
sudo file private/site_132_key.pem
sudo file certs/site_132_cert.pem
```

copy certs to `site_132`

```bash
sudo scp private/site_132_key.pem scott@192.168.250.132:~/ && ssh scott@192.168.250.132 "sudo mv site_132_key.pem /etc/ipsec.d/private/"
sudo scp certs/site_132_cert.pem scott@192.168.250.132:~/ && ssh scott@192.168.250.132 "sudo mv site_132_cert.pem /etc/ipsec.d/certs/"
```



## secure cert files (on `site_131`)

```bash
cd /etc/ipsec.d/

sudo chown root private/site_131_key.pem || echo "chown failed!"
sudo chgrp root private/site_131_key.pem || echo "chgrp failed!"
sudo chmod 600 private/site_131_key.pem || echo "chmod failed!"
```



## secure cert files (on `site_132`)


```bash
cd /etc/ipsec.d/

sudo chown root private/site_132_key.pem || echo "chown failed!"
sudo chgrp root private/site_132_key.pem || echo "chgrp failed!"
sudo chmod 600 private/site_132_key.pem || echo "chmod failed!"
```



## `ipsec.conf ` (on `site_131`)

```bash
sudo bash -c "cat << 'EOF' > /etc/ipsec.conf
config setup

conn %default
    ikelifetime=60m
    keylife=20m
    rekeymargin=3m
    keyingtries=1
    authby=pubkey
    keyexchange=ikev2
    mobike=no

conn site2site
    # un mark two lines below if site behind NAT
    # left=%defaultroute
    # leftfirewall=yes
    # mark line below if site behind NAT
    left=192.168.250.131
    leftauth=pubkey
    leftcert=site_131_cert.pem
    leftid=\"C=CN, O=keystore, CN=site_131\"
    leftsubnet=10.250.131.0/24
    right=192.168.250.132
    rightauth=pubkey
    rightid=\"C=CN, O=keystore, CN=site_132\"
    rightsubnet=10.250.132.0/24
    ike=aes256-sha2_256-modp2048!
    esp=aes256-sha256!
    auto=start

EOF"
```



## `ipsec.conf` (on `site_132`)

```bash
sudo bash -c "cat << 'EOF' > /etc/ipsec.conf
config setup

conn %default
    ikelifetime=60m
    keylife=20m
    rekeymargin=3m
    keyingtries=1
    authby=pubkey
    keyexchange=ikev2
    mobike=no

conn site2site
    # un mark two lines below if site behind NAT
    # left=%defaultroute
    # leftfirewall=yes
    # mark line below if site behind NAT
    left=192.168.250.132
    leftauth=pubkey
    leftcert=site_132_cert.pem
    leftid=\"C=CN, O=keystore, CN=site_132\"
    leftsubnet=10.250.132.0/24
    right=192.168.250.131
    rightauth=pubkey
    rightid=\"C=CN, O=keystore, CN=site_131\"
    rightsubnet=10.250.131.0/24
    ike=aes256-sha2_256-modp2048!
    esp=aes256-sha256!
    auto=start
EOF"
```



## `ipsec.secrets` (on `site_131`)

```bash
sudo bash -c "cat << 'EOF' > /etc/ipsec.secrets
: RSA site_131_key.pem
EOF"
```



## `ipsec.secrets` (on `site_132`)

```bash
sudo bash -c "cat << 'EOF' > /etc/ipsec.secrets
: RSA site_132_key.pem
EOF"
```



## `sysctl.conf` (on both site)

```bash
ip_forward=1
accept_redirects=0
send_redirects=0
ip_no_pmtu_disc=1

sudo bash -c "cat << 'EOF' >> /etc/sysctl.conf

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



