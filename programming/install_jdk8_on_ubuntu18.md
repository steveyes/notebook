# install jdk8 on ubuntu18



## 下载对应版本的jdk

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>




## 解压至目标文件夹

```bash
sudo mkdir /usr/lib/jvm
sudo tar -xvf jdk-8u211-linux-x64.tar.gz -C /usr/lib/jvm/
```



## 安装

```
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_211/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_211/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0_211/bin/javaws" 1
```



## 属主属组

```bash
sudo chmod a+x /usr/bin/java
sudo chmod a+x /usr/bin/javac
sudo chmod a+x /usr/bin/javaws
sudo chown -R root:root /usr/lib/jvm/jdk1.8.0_211/
```



## 配置当前默认版本

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config javaws
```

