# operating system initialize 



## for ubuntu 20

please run as root

```
set-network() {
    address="$1"
    gateway="$2"
    nameserver="$3"
    eth=$(ip -o -4 a | awk '/scope global/{print $2}')
    
    # backup config file
    old_conf=/etc/netplan/00-installer-config.yaml
    old_conf_bak=${old_conf}.org
    new_conf=/etc/netplan/01-netcfg.yaml
    if [ -f $old_conf ]; then
        mv $old_conf $old_conf_bak
    fi

    cat > $new_conf << EOF
network:
  ethernets:
    # interface name
    enp1s0:
      dhcp4: no
      # IP address/subnet mask
      addresses: [$address]
      # default gateway
      gateway4: $gateway
      nameservers:
        # name server to bind
        addresses: [$nameserver]
      dhcp6: no
  version: 2
EOF
	netplan apply
	
    # turn off ipv6
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	sysctl -p
}

install-packages() {
    apt -y update
    apt -y upgrade
    apt -y install apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg-agent \
    resolvconf \
    software-properties-common \
    ssh \
    sudo \
    vim
}

add-sudoer() {
    cat <<EOF >> /etc/sudoers
$1 ALL=(ALL) NOPASSWD: ALL
EOF
}

set-hostname() {
	hostname_old=$(hostname)
	hostname_new=$1
    hostnamectl set-hostname ${hostname_new}
    sed -i "s|$hostname_old|$hostname_new|g" /etc/hosts
}

set-bashrc() {
    bash_user=~/.bash_user
    bashrc=~/.bashrc
    
    test -d ${bash_user} || touch ${bash_user}
    cat > ${bash_user} <<-EOH
# alias
alias ltr='ls -ltr'
alias l1='ls -1'
alias si='sudo -i'
EOH

    cat >> ${bashrc} <<-EOH
# CUSTOMIZED bash_user
source ${bash_user}
EOH
	source $bash_user
}

set-network '192.168.1.101/24' '192.168.1.1' '192.168.1.1'
install-packages
add-sudoer steve
set-hostname vm101
set-bashrc
```







## for debian 9

```
function sysinit() {
    # vars
    user=$1
    ip=$2
    hostname=$3
    gateway=${ip%.*}.1
    network=${ip%.*}.0
    broadcast=${ip%.*}.255
    netmask=255.255.255.0
    dns1="$gateway"
    dns2="114.114.114.114"
    dns3="8.8.8.8"
    eth=$(ip -o -4 a | awk '/scope global/{print $2}')
    echo $eth
    hostsconf=/etc/hosts
    netconf=/etc/network/interfaces
    sudoconf=/etc/sudoers
    nsconf1=/etc/resolvconf/resolv.conf.d/head
    nsconf2=/etc/resolvconf/resolv.conf.d/base
    sysconf=/etc/sysctl.conf
    
    # install packages
	apt -y update
	apt -y upgrade
	apt -y install ssh sudo vim resolvconf apt-transport-https software-properties-common wget curl git
    
    # add sudoer
    cat <<-EOF >> $sudoconf
$user	ALL=(ALL)	NOPASSWD: ALL
EOF

    # set hostname
    hostnamectl set-hostname $hostname
    sed -i "s/debian9/$hostname/g" $hostsconf
    cat <<-EOF >> $hostsconf
$ip    $hostname
EOF

    # configure network
    sed -i "/$eth/s/^/#/"g $netconf
    cat <<-EOF >> $netconf
allow-hotplug $eth
iface $eth inet static
address $ip
gateway $gateway
network $network
broadcast $broadcast
netmask $netmask
dns-nameservers $dns1 $dns2 $dns3
EOF

    # dns persistent, resolvconf required
    cat <<-EOF >>$nsconf1
nameserver $dns1
nameserver $dns2
nameserver $dns3
EOF
    
    cat <<-EOF >>$nsconf2
nameserver $dns1
nameserver $dns2
nameserver $dns3
EOF

	sudo systemctl start resolvconf.service
	sudo systemctl enable resolvconf.service

    # disable ipv6
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> $sysconf
    
    # .bash_user
    bash_user$=~{user}/.bash_user
    test -d ${bash_user} || touch ${bash_user}
    cat >> ${bashrc} <<-EOH
# CUSTOMIZED bash rc
source ${bash_user}
EOH

    cat > ${bash_user} <<-EOH
# run git pull 
git_pull() {
    dirs=(/dir1 /dir2)
    for dir in "\${dirs[@]}"; do
        cd $dir
        git pull
    done
}

# run git push 
git_push() {
    dirs=(/dir1 /dir2)
    for dir in "\${dirs[@]}"; do
        cd $dir
        git commit -am "auto commit at $(date -Iseconds)"
        git push
    done
}

# alias
alias ltr='ls -ltr'
alias l1='ls -1'
alias si='sudo -i'

# execute after bash login
git_pull
# execute before bash logout
trap git_push EXIT

EOH

    # .bashrc
    bashrc=~${user}/.bashrc
    echo "source ~/.bash_user" >> $bashrc
	source ${bashrc}

    # reboot
    reboot
}

ip_mask_parse() {
    readarray -d'/' -t ip_and_mask <<< "$1"
    ip="${ip_and_mask[0]}"
    mask="${ip_and_mask[1]}"
    
    readarray -d'/' -t ip_bits <<< "$ip"
    ip_bit_1=${ip_bits[0]}
    ip_bit_2=${ip_bits[1]}
    ip_bit_3=${ip_bits[2]}
    ip_bit_4=${ip_bits[3]}
    
    if [ $mask -gt 32 ]; then
        echo "error: mask $mask should not be greater than 32"
        return 1
    elif [ $mask -ge 24 ]; then
        mask_offset=$(( 256 - 2**(32 - ${mask}) ))
    	network=${ip_bit_1}.${ip_bit_2}.${ip_bit_3}.${mask_offset}
    	netmask=255.255.255.${mask_offset}
    elif [ $mask -ge 16 ]; then
        mask_offset=$(( (256**2 - 2**(32 - ${mask})) / 256 ))
        network=${ip_bit_1}.${ip_bit_2}.${mask_offset}.0
        netmask=255.255.${mask_offset}.0
    elif [ $mask -ge 8 ]; then
        mask_offset=$(( (256**3 - 2**(32 - ${mask})) / 256**2 ))
        network=${ip_bit_1}.${mask_offset}.0.0
        netmask=255.${mask_offset}.0.0
    elif [ $mask -ge 0 ]; then
        mask_offset=$(( (256**4 - 2**(32 - ${mask})) / 256**3 ))
        network=${mask_offset}.0.0.0
        netmask=${mask_offset}.0.0.0
    elif [ $mask -lt 0 ]; then
        echo "error: mask_length $mask should not be greater than 32"
        return 1
    else
        echo "error: $mask illegal input"
    fi
    
    echo "network=${network}" "netmask=${netmask}"
}

set-network() {
    readarray -d'/' -t ip_and_mask <<< "$1"
    address="${ip_and_mask[0]}"
    mask="${ip_and_mask[1]}"
    
    gateway="$2"
    nameserver="$3"
    eth=$(ip -o -4 a | awk '/scope global/{print $2}')
    
    
    # backup config file
    conf=/etc/network/interfaces
    conf_bak=${conf}.org
    if [ -f $conf ]; then
        cp $conf $conf_bak
    fi

    cat >> $conf <<-EOF
allow-hotplug $eth
iface $eth inet static
address $address
gateway $gateway
network $network
broadcast $broadcast
netmask $netmask
dns-nameservers $nameserver
EOF

	# turn off ipv6
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	sysctl -p
}


set-network '192.168.1.100/24' '192.168.1.1' '192.168.1.1'
install_packages
add_sudoer steve
set-hostname vm101
set-bashrc
```



