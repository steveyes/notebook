

## 设置JVM运行参数

### 方式一

代码中指定

```
System.setProperty
```

### 方式二

运行时指定

```
java -Dproperty1=value1 -Dvar2="hello world" ...
```

### 方式三

IDE运行配置时指定，如idea

<kbd>Run</kbd> --> <kbd>Edit Configurations...</kbd> --> <kbd>configuration</kbd> --> <kbd>VM options</kbd>

### 方式四

IDE配置文件中设置，如idea

`$IntelliJ IDEA/bin/idea64.exe.vmoptions`