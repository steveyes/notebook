# sed

[toc]



## 作用规则

> 1. 脚本文件中的所有命令会顺序作用于待处理的行。
> 2. 地址过滤作用可以使脚本中的命令只作用于与地址匹配的行。
> 3. 原始文本文件不会被改变，被改变的是原始文件的一个备份，处理后的备份行会输出。



## 范围匹配打印

```
# 打印第二行
sed -n '2 p' $file

# 打印1至10行
sed -n '1,10 p' $file

# 打印包含hello的行
sed -n '/hello/'p $file

# 打印包含hello的行直到包含world的行之间的所有行
sed -n '/hello/,/world/'p $file

# 打印包含hello行的行号
sed -n '/hello/'= $file
```



## remove leading whitespaces

```
sed -r 's/^\s*//g'
sed 's/^[[:space:]]*//g'
```



## remove trailing whitespaces

```
sed -r 's/\s*$//g'
sed 's/[[:space:]]*$//g'
```



## remove leading and trailing whitespaces

```
sed -r -e 's/^\s*//g' -e 's/\s*$//g'
```



## remove leading and trailing whitespaces and blank lines

```
sed -r -e 's/^\s*//g' -e 's/\s*$//g' -e '/^\s*$/d'
```



## remove comment and blank line

```
sed -r -e "/(^\s*#|^$)/d"
```



## 追加新行

```
sed 's/for/&\\n/g' $file
sed 's/for/\\n&/g' $file
sed -i -r "s/\<(for|do|done)\>/&\n/g" $file
```



## *追加（慎用，待验证）

```
# 将$file2的内容插入到file1中含有test的行后
sed "/test/r $file2" $file1

# 将$file1中含有test的行追加写入中$file2
sed "/test/w $file2" $file1
```

> - -r：--regexp-extended 即 ERE
> - \\< , \\> ： 单词锚
> - ( | | )：组内互斥
> - &：占位符，匹配组内中的某个词



## 替换

```
# 替换$var1为$var2
sed -e "s/$var1/$var2/g" $file

# 替换第5次出现的test为Test
sed 's/test/Test/5' $file

# 将3至5行替换成一行，其内容如下
sed '3,5 c\this is a change line' $file
```



## 首行前插入

```
sed '1i\this line is above the first line' $file
```



## 末行后插入

```
sed '$a\this line is below the last line' $file
```



## 匹配行前面插入

```
sed -i '/hello/i\this line is above the line contains word hello' $file
```



## 匹配行后面插入

```
sed -i '/hello/a\this line is below the line contains word hello' $file
```



## 批量修改

```
sed -i 's/start/stop/g' $(grep start -rl log/)
```



## 删除

```
# 删除1-3行
sed '1,3'd $file

# 删除包含hello的行
sed '/hello/'d $file

# 删除第1，5，10行
sed '1d;5d;10d' $file

# 删除除了第5至10行以外的所有行
sed '5,10!'d $file
```



## 占位符

```
# &占位符
# 替换 ^192.168.0.1 为 ^192.168.0.1:80
sed 's/^192.168.0.1/&:80/' $file

# \1 \2 ... 占位符
# 替换 love 为 lover
sed 's/\(love\)/\1r/'p $file
```



## 匹配之起始位置

```
# 从第二个匹配的元素开始替换
echo thisthisthisthis | sed 's/this/This/'2g 

# 从第三个匹配的元素开始替换
echo thisthisthisthis | sed 's/this/This/'3g
```



## 定界符

```
sed 's/hello/world/g'
sed 's#hello#world#g'
sed 's@hello@world@g'
sed 's:hello:world:g'
sed 's|hello|world|g'
```

> sed定界符可以使用任意的字符



## 抓取某段时间内的日志

```
sed -n '/09:00:00/,/11:59:00/'p /var/log/messages
```



## 取一个路径的父目录部分，其路径可以是目录或者文件

```
# 路径是目录
echo '/etc/sysconfig/network-scripts/' | sed -r 's@^(/.*/)[^/]+/?@\1@g'

# 路径是文件
echo '/etc/sysconfig/network-scripts/ifcfg-eth0' | sed -r 's@^(/.*/)[^/]+/?@\1@g'
```



## 反向匹配

```
# ! 表示反向匹配
sed -rn '/^active.*-qry.*-[0-9]{3}-[0-9]{3}$/!'p $file
```

文本格式化(逗号和问号换行，删除空行。)

```
echo "$1" | sed -r -e s'#(\. |\? )#\1\n#'g -e '/^\s*$/'d 
```

sed one line

http://sed.sourceforge.net/sed1line.txt



## print previous line after a pattern match 

let say a text whose file name is `hosts`

```
activeitem5-lla-lvs-001-013
$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l


activeitem5-lla-lvs-001-027
$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l


activeitem5-lla-lvs-001-249
$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l


slx07c-4hts
$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l


activeitem5-qry-lvs-012-004
$ cat /etc/issue
Ubuntu 16.04.5 LTS \n \l
```

how to get all the lines that the next line is like `$ cat /etc/issue`

```
sed -n '/\$ cat \/etc\/issue/{x;p;d;}; x' hosts
```

how it works

- /\$ cat \/etc\/issue/

  if the current line contains  `$ cat /etc/issue`, then do:

  - x : swap the pattern and hod space so that the prior line is in the pattern space
  - p : print the prior line
  - d : delete the pattern space and start processing next line

- x

  This is execute only on lines which do not contain s `$ cat /etc/issue`.





## using shell variables in sed

```
fruit1="apple"
fruit2="grape"
sed "s|$fruit1|$fruit2|g" <(printf 'apple\nbanana\npear\napple\n')
```

