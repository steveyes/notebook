# 数字证书



## 准备站点证书

如果你拥有一个域名，国内各大云服务商均提供免费的站点证书。你也可以使用 `openssl` 自行签发证书。

这里假设我们将要搭建的私有仓库地址为 `docker.domain.com`，下面我们介绍使用 `openssl` 自行签发 `docker.domain.com` 的站点 SSL 证书。

## CA证书

第一步创建 `CA` **私钥**。

```bash
$ openssl genrsa -out "root-ca.key" 4096
```

第二步利用私钥创建 `CA` **根证书请求文件**。

```bash
$ openssl req \
          -new -key "root-ca.key" \
          -out "root-ca.csr" -sha256 \
          -subj '/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=Your Company Name Docker Registry CA'
```

> * `-new`: this option generates a new certificate request. It will prompt the user for the relevant field values. The actual fields prompted for and their maximum and minimum sizes are specified in the configuration file and any requested extensions.
> * `-key`: This specifies the file to read the private key from. It also accepts PKCS#8 format private keys for PEM format files.
>
> * `-out`: This tells OpenSSL where to place the certificate that we are creating. Output the key to the specified file. If this argument is not specified then standard output is used.
>
> * `-subj`: 参数里的 `/C` 表示国家，如 `CN`；`/ST` 表示省；`/L` 表示城市或者地区；`/O` 表示组织名；`/CN` 通用名称。

第三步配置 `CA` 根证书，新建 `root-ca.cnf`。

```bash
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
```

> * `basicConstraints`: 基本约束，CA:TRUE表示颁发的证书能作为CA证书，能给其他人颁发证书，CA最多有2层：CA->subCA1-Subca2->End User Certificate，此处 pathlen 为 1，即设置为 1 层。
> * `-keyUsage`: 指定证书的目的，也就是限制证书的用法用途
>
> * `-out`: This tells OpenSSL where to place the certificate that we are creating. Output the key to the specified file. If this argument is not specified then standard output is used.


第四步签发根证书。

```bash
$ openssl x509 -req  -days 3650  -in "root-ca.csr" \
               -signkey "root-ca.key" -sha256 -out "root-ca.crt" \
               -extfile "root-ca.cnf" -extensions \
               root_ca
```

> * `-req`: by default a certificate is expected on input. With this option a certificate request is expected instead.
> * `-days`: specifies the number of days to make a certificate valid for. The default is 30 days.
> * `-in`: This specifies the input filename to read a certificate from or standard input if this option is not specified.
> * `-signkey`: this option causes the input file to be self signed using the supplied private key.
> * `-out`: This specifies the output filename to write to or standard output by default.
> * `-extfile`: file containing certificate extensions to use. If not specified then no extensions are added to the certificate.
> * `-extensions`: the section to add certificate extensions from. If this option is not specified then the extensions should either be contained in the unnamed (default) section or the default section should contain a variable called "extensions" which contains the  section to use. See the x509v3_config(5) manual page for details of the extension section format.

## 站点证书

第五步生成站点 `SSL` 私钥。

```bash
$ openssl genrsa -out "docker.domain.com.key" 4096
```

第六步使用私钥生成证书请求文件。

```bash
$ openssl req -new -key "docker.domain.com.key" -out "site.csr" -sha256 \
          -subj '/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=docker.domain.com'
```

第七步配置证书，新建 `site.cnf` 文件。

```bash
[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:docker.domain.com, IP:127.0.0.1
subjectKeyIdentifier=hash
```

第八步签署站点 `SSL` 证书。

```bash
$ openssl x509 -req -days 750 -in "site.csr" -sha256 \
    -CA "root-ca.crt" -CAkey "root-ca.key"  -CAcreateserial \
    -out "docker.domain.com.crt" -extfile "site.cnf" -extensions server
```

## 证书列表

这样已经拥有了 `docker.domain.com` 的网站 SSL 私钥 `docker.domain.com.key` 和 SSL 证书 `docker.domain.com.crt` 及 CA 根证书 `root-ca.crt`。

|               |                       |
| ------------- | --------------------- |
| 网站的SSL私钥 | docker.domain.com.key |
| 网站的SSL证书 | docker.domain.com.crt |
| CA根证书      | root-ca.crt           |

新建 `ssl` 文件夹并将 `docker.domain.com.key` `docker.domain.com.crt` `root-ca.crt` 这三个文件移入，删除其他文件。
