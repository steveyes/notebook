

# install openjdk on ubuntu 18



### Installing Default JDK

This package will install either OpenJDK 10 or 11.

- Prior to September 2018, this will install OpenJDK 10.
- After September 2018, this will install OpenJDK 11.

```
sudo apt update
sudo apt install default-jdk
```



### Installing Specific Versions of OpenJDK

version 8

```
sudo apt install openjdk-8-jdk
```

version 9

```
sudo apt install openjdk-9-jdk
```

version 10

```
sudo apt install openjdk-10-jdk
```

version 11

```
sudo apt install openjdk-11-jdk
```



### alternatives

```
sudo update-alternatives --config java
```



### `JAVA_HOME` Environment Variable

- OpenJDK 11  `/usr/lib/jvm/java-11-openjdk-amd64/bin/java.`

- OpenJDK 8  `/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java`.

- Oracle Java 8 `/usr/lib/jvm/java-8-oracle/jre/bin/java`.

```
JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/bin/"
export PATH=$PATH:$JAVA_HOME/bin
echo $JAVA_HOME
echo $PATH
```

