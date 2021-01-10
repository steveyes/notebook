# jdk安装



## 下载对应版本的jdk

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>



## 上传到主机 ~/Downloads 目录

确认主机已安装 lrzsz, 便可以拖拽文件到 xshell 窗口， 直接上传刚下载的包

```bash
cd ~/Downloads/
```



## 解压至目标文件夹

```bash
sudo tar -xvf jdk-8u211-linux-x64.tar.gz -C /usr/local/
```



## 创建软连接

```
ln -s /usr/local/jdk1.8.0_211 /usr/local/jdk
```



## 配置环境变量

*here document 使用双引号把 EOF 包围起来， 可以关闭参数替换*

```bash

sudo bash -c 'cat >> /etc/profile << "EOF"

# jdk1.8.0_211
export JAVA_HOME=/usr/local/jdk
export JRE_HOME=$JAVA_HOME/jre
export JAVA_BIN=$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
EOF'

source /etc/profile
```



## 测试

```bash
java -version
```

