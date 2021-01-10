# idea notes



## install on ubuntu 


COMMUNITY
```
sudo snap install intellij-idea-community --classic --edge
```

ULTIMATE

```
sudo snap install intellij-idea-ultimate --classic --edge
```

## start on ubuntu

```
intellij-idea-community
```

```
intellij-idea-ultimate
```






## idea设置JVM运行参数

<kbd>Run</kbd> --> <kbd>Edit Configurations...</kbd> --> <kbd>configuration</kbd> --> <kbd>VM options</kbd>



## issues

### IDEA左侧project模式下，不显示项目工程目录，只有几个配置文件

问题原因

> 一般为配置文件*.iml 出错了

解决办法

- 找到 出错位置，修复
- 清除配置，重新导入
  1. 关闭IDEA
  2. 删除项目文件夹下的.idea文件夹
  3. 重新用IDEA工具打开或import项目



## Idea中自动注释的缩进（避免添加注释自动到行首）

<kbd>File</kbd> --> <kbd>settings...</kbd> --> <kbd>Editor</kbd> --> <kbd>Code Style</kbd> --> <kbd>Java</kbd> --> <kbd>Code Generation</kbd> -->

`Comment Code` : 

- uncheck `Line comment at first column` 
- uncheck `Block comment at first column`
- check `Add a space at comment start`



# Inject language

代码如下

```java
class Scratch {
    public static void main(String[] args) {
        String jsonString = "";
    }
}
```

将光标定位到双引号中间，按 `Alt+Enter` --> `Inject language or reference`，下拉菜单选择 `json`， 

再次按 `Alt+Enter` --> `Edit JSON Fragment`，就可以在下面的窗口编辑 `json`格式的字符串了。

输入

```json
{"name":"alice","age":21}
```

代码区域窗口会自动转义双引号。



