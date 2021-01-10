# etcd in docker



## 简介

etcd是CoreOS团队于2013年6月发起的开源项目，它的目标是构建一个高可用的分布式键值(key-value)数据库。etcd内部采用raft协议作为一致性算法，etcd基于Go语言实现。



## download

```
ETCD_VER=v3.3.13

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

```

## docker-file

```
mkdir ~/docker_dir && cd ~/docker_dir
cp /tmp/etcd-download-test/etcd* ~/docker_dir/

echo >> Dockerfile << EOF
FROM alpine:latest

ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
RUN mkdir -p /var/etcd/
RUN mkdir -p /var/lib/etcd/

# Alpine Linux doesn't use pam, which means that there is no /etc/nsswitch.conf,
# but Golang relies on /etc/nsswitch.conf to check the order of DNS resolving
# (see https://github.com/golang/go/commit/9dee7771f561cf6aee081c0af6658cc81fac3918)
# To fix this we just create /etc/nsswitch.conf and add the following line:
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

EXPOSE 2379 2380

# Define default command.
CMD ["/usr/local/bin/etcd"]
EOF
```

## docker build

```
docker build -t etcd .
```

## docker run

```
docker run \
 -name etcd0 \
 -p 4001:4001 \
 -p 2380:2380 \
 -p 2379:2379 \
 --mount type=bind,source=/data/etcd-data,destination=/etcd-data \
 --data-dir=/etcd-data \
 -v /usr/share/ca-certificates/:/etc/ssl/certs \
 etcd /usr/local/bin/etcd \
 --listen-client-urls http://0.0.0.0:2379 \
 --advertise-client-urls http://0.0.0.0:2379 \
 --listen-peer-urls http://0.0.0.0:2380 \
 --initial-advertise-peer-urls http://0.0.0.0:2380 \
 --initial-cluster etcd0=http://0.0.0.0:2380 \
 --initial-cluster-token etcd0-token \
 --initial-cluster-state new
```

