`

# Linux 命令 && 工具手册



目录

[TOC]

## Convention

- <>  变量界定符
- [] 可选
- {} 必选
- --> 按时间先后顺序执行



## ASCII

查看 ASCII 表

```
man ascii
```

ASCII 排序规则，空格 -> 数字 -> 大写字母 -> 小写字母，即 SNUL

常用不可见字符

| 代码 | 控制键 | 八进制 | 名称      |
| ---- | ------ | ------ | --------- |
| \b   | ^H     | \010   | 退格      |
| \t   | ^I     | \011   | 制表符    |
| \n   | ^J     | \012   | 新行/换行 |
| \r   | ^M     | \015   | 回车      |
| \\   | -      | -      | 反斜线    |

### 元字符

| 字符   | 英文名             | 中文名           | 作用                               |
| ------ | ------------------ | ---------------- | ---------------------------------- |
| &      | ampersand          | 和号，和字符     | 作业控制，后台运行                 |
| @      | at sign            | at               |                                    |
| \      | backslash          | 反斜杠           | 引用：最强引用                     |
| '      | apostrophe         | 单引号           | 引用：强引用                       |
| "      | quotation mark     | 双引号           | 引用：弱引用                       |
| $      | dollar sign        | 美元符号         | 变量：取值                         |
| {}     | brace brackes      | 花括号           | 变量：变量名界限；生成一种字符模式 |
| *      | asterisk           | 星号             | 文件名扩展：匹配0或多个            |
| ?      | question mark      | 问号             | 文件名扩展：匹配1个                |
| ~      | tilde              | 波浪号           | 文件名扩展：插入home目录的名称     |
| []     | square brackets    | 方括号           | 文件名扩展：与一组字符中的字符匹配 |
| ()     | parenthesis        | 圆括号           | 命令行：在子shell中运行            |
| `      | backquote          | 反引号           | 命令行，命令替换                   |
| >      | greater-than sign  | 大于号           | 命令行：重定向输入                 |
| <      | less-than sign     | 小于号           | 命令行：重定向输出                 |
| #      | number sign        | sha, hash, pound | 命令行：行首注释                   |
| \|     | vertical bar       | 竖线             | 命令行：创建一个管道               |
| ^      | circumflex         | 音调符号         |                                    |
| :      | colun              | 冒号             |                                    |
| ,      | comma              | 逗号             |                                    |
| =      | equal sign         | 等号             |                                    |
| !      | exclamation mark   | bang             | 历史列表：事件标记                 |
| %      | percent sign       | 百分比           |                                    |
| .      | period             |                  |                                    |
| +      | plus sign          | 加号             |                                    |
| ;      | semicolun          | 分号             | 分隔符，用于分割多条命林           |
| /      | slash              | 斜杠             |                                    |
| -      | hyphen, minus sign | dash             |                                    |
| Return | enter, return      | 新行             | 空白符：标记-行结束                |
| space  | space              | 空格             | 空白符：在命令行中分割单词         |
| Tab    | tab                | 制表符           | 空白符：在命令行中分割单词         |
| _      | underscore         | 下划线           |                                    |




### 引用和转义

**引用**：按字面上的意思使用元字符。

例如：引用分号，将分号作为分号使用，而不是一个命令分隔符，引用时，shell将按字面意思解释元字符。

或者理解为引用就是不被shell解释，被shell解释就不是引用。

当反斜线引用单个字符时，成反斜线维转义字符(escape char)。

### 转义字符列表

| 符号 | 可以引用的元字符                             | 不能转义的元字符                   |
| ---- | -------------------------------------------- | ---------------------------------- |
| \    | 新行字符，单引号，双引号，及其他所有元字符   |                                    |
| '    | 除了 **`不能转义的元字符`** 之外的其他元字符 | 反斜杠，新行字符                   |
| \    | 除了 **`不能转义的元字符`** 之外的其他元字符 | 反斜杠，新行字符，单引号，美元符号 |

### 通配符

| 符号            | 含义                                        |
| --------------- | ------------------------------------------- |
| *               | 匹配0个或多个字符，除 / 斜线之外            |
| ?               | 匹配任何单个字符                            |
| [abcde]         | 匹配 `abcde` 中的任何字符                   |
| [^abcde]        | 匹配不属于 `abcde` 中任何字符的其他         |
| {str1\|str2...} | 匹配 `str` 或 `str2` 等其中一个指定的字符串 |



## 帮助

### type

```bash
# 查看 test 的命令类型, shell builtin
type test

# 查看 ls 的命令类型, aliased to `ls --color=auto'
type ls

# 查看 ip 的命令类型, 外部命令
type ip
```

### built-in 

```bash
# 正确，test 是 bash built-in 命令
help test

# 错误，ls 不是 bash built-in 命令
help ls

man builtins
```

### whatis

whatis 通过查询 man-db 工作，在系统安装完成后并不能马上工作：

```
ls /var/cache/man
# 执行失败，无结果返回
whatis cal

# 更新 mandb
mandb

# 执行成功
whatis cal
```

### man

```
# 等同于 whatis
man -f

# 等同于 apropos
man -k
```



## CPU管理

### 查看CPU信息

```
cat /proc/cpuinfo
dmidecode -t processor
lscpu
```

### top

```
top -H -p <pid>
```

- `0` zeros
- `1` cpus

- `z` color/mono
- `c` cmd name/line
- `b` bold/reverse
- `m` memory
- `P` sort by %CPU
- `M ` sort by %MEM`
- `i` idle
- `t` task/cpu stats
- `H` Threads



## 内存管理

### 查看内存大小

```
grep -i memtotal /proc/meminfo
dmidecode -t memory
free
```



## 磁盘管理

### du

```
# 分别对 dst 的子目录磁盘占用做统计汇总，并从高到低排序
du -sh <dir>/* | sort -k1,1rn
```

### df

```
# 查看 /etc 目录所在的挂载点
df -h /etc

# 统计各分区可用inode数量
df -ih
```

### iostat

```
iostat -d -x -k 1 5
```

### fdisk

```
fdisk -l [<dev>]
```

### parted

```
parted -l [<dev>]
```

### lsblk

```
lsblk [<dev>]
```

### hdparm 

```
# Getting hard disk model and number under Linux
hdparm -I <dev>
```

### lshw

```
# display all disks and storage controllers
lshw -class disk -class storage	

# Find out disks name only
lshw -short -C disk
```

### smartctl

```
# get more detailed information about <device>
smartctl -d <device_type> -a -i <device>
```

### mdadm

```
# get all md info
cat /proc/mdstat | awk '/md/ {print $1}' | while read md; do sudo mdadm -D /dev/$md; done
```







## network

### UDP port test

```
nmap -sU $IP -p $PORT -Pn
```

### TCP port test

```
nc -w 2 -q 3 -nv ${host} ${port} </dev/null
```

### 查看TCP连接

```
// 查看本机 Recv-Q 排行最高的 Top10 连接
ss -p | grep $local_ip | sort -k4,4nr | head

// 查看本机 Recv-Q 排行最高的 Top10 连接
ss -p | grep $local_ip | sort -k5,5nr | head

// 查看 TCP 状态统计，按照统计值从高到低排序
ss -an | awk '/^tcp/ {++state[$2]} END {for(key in state) print key, "\t" state[key]}' | column -t | sort -k2,2nr 
```

### 





## 日期时间

### 时区

```
# 东八区
TZ=UTC-8 date +'%F %T %Z %z'

# 西七区
TZ=UTC+7 date +'%F %T %Z %z'
```

### display past date

```
date --date='10 years ago'
date --date='6 months ago'
date --date='1 week ago'
date --date='7 days ago'
date --date='yesterday'
date --date='4 hours ago'
date --date='15 minutes ago'
date --date='30 seconds ago'
```

### display future date

```
date --date='10 years'
date --date='6 months'
date --date='1 week'
date --date='7 days'
date --date='tomorrow'
date --date='4 hours'
date --date='15 minutes'
date --date='30 seconds'
```







## 用户管理

### sudo

to check if  a certain user has sudo privilege or not

```
sudo -l -U <Username>
```

### 文件说明

- /var/log/utmp  保存的在线用户的信息

- /var/log/wtmp  保存的登录过本系统的用户的信息

### 查看当前所有在线用户

```
# 查看所有当前所有在线用户
who

# 同上，更加详细
w
```

### 查看当前用户

```
# 查看当前用户
echo $USER

# 查看当前用户和组
users

# 查看当前用户和组，以及附加组
id 
```

### 查看当前终端

```
tty	
```

### 查看登录历史

```
# 查看当前用户的登录历史，没有 last 详细
who -u /var/log/wtmp
who -u /var/log/wtmp.*

# 查看当前用户的登录历史及系统重启历史，相当于 last -f /var/log/wtmp
last

# 查看每一位用户的最近一次成功登录信息
lastlog

# 查看用户错误的登录尝试
lastb


```

### 查看CMD历史

```
history
```



## 字符串处理

### 字符串替换

| statement     | x not defined                  | x is none                      | x not none |
| ------------- | ------------------------------ | ------------------------------ | ---------- |
| y=${x-hello}  | y=hello                        | y is none                      | y=$x       |
| y=${x:-hello} | y=hello                        | y=hello                        | y=$x       |
| y=${x+hello}  | y is none                      | y=hello                        | y=hello    |
| y=${x:+hello} | y is none                      | y is none                      | y=hello    |
| y=${x=hello}  | y=hello; x=hello               | y is none; x=$x                | y=$x; x=$x |
| y=${x:=hello} | y=hello; x=hello               | y=hello; x=hello               | x=$y; x=$x |
| y=${x?hello}  | echo "hello error" 2>/dev/null | y is null                      | y=$x       |
| y=${x:?hello} | echo "hello error" 2>/dev/null | echo "hello error" 2>/dev/null | y=$x       |





### 字符串截取

str01=notebook

| 表达式       | 值     | comment                                             |
| ------------ | ------ | --------------------------------------------------- |
| ${str01:0:2} | no     | split                                               |
| ${str01#*o}  | tebook | delete char from left to right                      |
| ${str01##*o} | k      | delete char from left to right(as much as possible) |
| ${str01%o*}  | notebo | delete char from right to left                      |
| ${str01%%o*} | n      | delete char from right to left(as much as possible) |

### 字符串替换

method="Java.lang.Class.forName()"

echo "${method//./_}"



### generate random string

```bash
LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 13 ; echo

pass_length=16 pass_counts=3; cat /dev/urandom | tr -dc "[:print:]" | fold -w ${pass_length} | head -n ${pass_counts}; echo 
```



## 进制转换

### Hexadecimal To Decimal

```bash
echo $((0x08000))
printf "%d\n" 0x08000
echo "ibase=16; 8000" | bc
python -c 'print(int("0x08000", 16))'
```

### Decimal To Hexadecimal 

```bash
printf "%x\n" 32768
echo "obase=16;ibase=10;32768" | bc
python -c 'print(hex(32768))'
```





## 包管理_debian

### 查询某个命令属于哪个包

```
dpkg -S $(which ssh)
```

### 彻底删除包

```
apt-get -y purge mysql-server
apt-get -y autoremove
apt-get clean
dpkg -l | grep ^rc | awk '{print $2}' | sudo xargs dpkg -P
```

### 仅下载而不安装

```
apt-get install nginx --download-only --reinstall
```

### 离线环境解决包依赖

```
# 1 清空缓存（hostA 可以上网）
cd /var/cache/apt/archives
# sudo apt-get clean
sudo rm -rf *.deb

# 2 下载（hostA 可以上网）
# 已安装过的
sudo apt -d --reinstall install samba	

# 未安装过的
sudo apt -d  install samba

# 3 安装（hostB 不可上网）
sudo scp HostA:/var/cache/apt/archives/*.deb ~/Downloads/; cd ~/Downloads/
sudo dpkg -i *.deb
```

### 解决其依赖中断问题

```
sudo dpkg -i xclip_*
sudo apt install -f
```



## 包管理_redhat

### 查询某个命令属于哪个包

```
rpm -qf $(which ssh)
```

### 彻底删除包

```
# by yum
yum remove mysql mysql-server mysql-libs compat-mysql51

# by rpm
rpm -e MySQL-server-5.6.17-1.el6.i686
rpm -e MySQL-client-5.6.17-1.el6.i686
```

### 仅下载而不安装

```
yum install --downloadonly --downloaddir=/tmp/ nginx
```






## BASH SHELL

### BASH快捷键和信号

[IPC信号参考](#IPC信号)

| 信号   | 按键                 | 作用                               |
| ------ | -------------------- | ---------------------------------- |
|        | alt+.                | 引用上一条命令的最后一个参数       |
|        | esc -> .             | 引用上一条命令的最后一个参数       |
| erase  | <Backspace>/<Delete> | 删除最后一个键入的字符             |
| werase | Ctrl+W               | 删除最后一个键入的单词             |
|        | Ctrl+A               | 光标移至行首                       |
|        | Ctrl+E               | 光标移至行末                       |
|        | Ctrl+L               | 清屏                               |
| kill   | Ctrl+U               | 删除当前光标所在的字符直到行首     |
|        | Ctrl+K               | 删除当前光标所在的字符直到行末     |
|        | Ctrl+Y               | 粘贴上一次删除的内容               |
|        | Ctrl+R               | 在命令历史中查找，并调用           |
| eof    | Ctrl+D               | 结束输入                           |
| intr   | Ctrl+C               | interupt，停止正在运行的程序       |
| stop   | Ctrl+S               | 暂停正在运行的程序                 |
| start  | Ctrl+Q               | 恢复被暂停的程序                   |
| susp   | Ctrl+Z               | 暂停正在运行的程序，并将其放到后台 |
| CR     | Ctrl+M               | return，回车                       |
| LF     | Ctrl+J               | linefeed，换行                     |

### stty

```
# 显示系统的键盘映射
stty -a

# 定义
stty erase ^H
```

### 子shell

在子shell中，对环境变量的任何改变都是局部的临时的，不影响父shell，如：改变工作目录，创建或修改环境变量，创建或修改shell变量，选项等。

```bash
cat <<- 'EOF' > ./sub_shell_01.sh
#!/bin/bash
export file=/tmp/tmpdata

bash 
export file=/tmp/tempdata
echo hello world > $file
exit

echo $file
cat /tmp/tempdata
EOF

# 运行该脚本，并按 ctrl+D 手动退出，不然会一直阻塞，使用 Ctrl+D，父子shell一同推出了，所以后面的 echo 和 cat 两个命令无法执行，该 bug待修复。
bash ./sub_shell_01.sh

```

上述脚本可以用以下shell命令等效实现：

```
export file=/tmp/tmpdata | (export file=/tmp/tempdata; echo hello world > $file) | echo $file | cat /tmp/tempdata
```

## 输入输出重定向

### stdout，stderr都重定向到一个文件

```
# 原文会被替换掉
ls -1 &> file.list

# 原文会被替换掉
ls -1 >& file.list

# 追加模式，原文不会被替换掉
ls -1 >> file.list 2>&1
```



## 文件管理

### ls

列出隐藏目录

```
ls -ld .[!.]*
```

### find

找出既不是普通文件，也不是目录的文件。

```
find / \! -type f \! -type d -print
```

30天之前的访问的文件加后缀名.old

```
find ./ -atime +7 | xargs -i -t mv {} {}.old
```

查找/etc目录下一周内内容修改过且不属于root或bin用户的文件

```
find /etc -mtime -7 -not -user root -a -not -user bin 
```

查找当前系统上没有属主或属组且最近1天被访问过的文件，并将其属主属组均改为root

```
find / -nouser -o -nogroup -a -atime -1 | xargs chow root:root {}
```

### 软连接

```
# 创建一个软连接
ln -s $src $dst

# 显示物理目录，而非链接目录
pwd -P

# 切换到物理目录，而非链接目录
cd -P $dst
```

### 找出当前一直在读写的文件

```
touch newfile
find / -newer newfile
```

### 清空文件

```
: > $file
> $file
echo > $file
echo /dev/null > $filename
cat /dev/null > $filename
```

根据inode删除文件(无法根据文件名删除文件)

```
find ./ -inum $inode_num -exec rm -i {} \;

find ./ -inum $inode_num | xargs -I{} rm -rf {}
```

### 查看文件系统的块大小

```
sudo dumpe2fs /dev/sda1 | grep 'Block size'
```

### 查看文件或目录占用块的数量

```
# 查看文件
ls -s /bin/ls

# 查看文件
sudo du -h /bin/ls

# 查看目录
sudo du -sh /bin/
```

### 粉碎文件

```
# 彻底粉碎文件，使之永远无法被恢复，谨慎操作
shred -fvuz $file
```

### whereis

```
whereis -b ls 
whereis -m chmod
```

### locate

```
# 安装
sudo apt install mlocate

# 更新数据库
sudo updatedb	

# 搜索所有以 .py 结尾的文件
locate -r '.py$'

# 搜索所有以 .py 结尾的文件的总数
locate -cr '.py$'

# 查看 locate 相关的统计信息
locate -S

# 搜索所有文件名中包含 dict 且包含 word 的文件
locate dict | grep word
```

### tar

backup dir with many excludes 

```
tar  --exclude=/home/tmp/dir1 \
   --exclude=/home/tmp/dir2 \
   --exclude=/home/tmp/file1 \
   -Jcvf tmp.tar.xz /home/tmp/
```





## 文本处理

### split

对data(包含57984行)文件进行分割，将会被分割成分别以 xaa, xab, xac, xad, xae, xaf, xag, xah, xai, xaj, xak, xal 文件后缀名的12个文件，签11个包含5000行，xal包含2984行

```
split -l5000 data
```

对data(包含57984行)文件进行分割，后缀名为数字，每5000行一个文件，后缀名数字位长度为3，前缀名out

```
split -d -l5000 -a3 data out
```

### cat

不能有前导制表符

```bash
cat << ANARBITRARYTOKEN
The river was deep but I swam it, Janet.
The future is ours so let's plan it, Janet.
So please don't tell me to can it, Janet.
I've one thing to say and that's ...
Dammit. Janet, I love you.
ANARBITRARYTOKEN
```

可以有前导制表符

```bash
if true; then
    cat <<- EOF
    The <<- variant deletes any tabs from start of each line.
EOF
fi
```

引用

```bash
cat << EOF
Here documents do parameter and command substitution:
 * Your HOME is $HOME
 * 2 + 2 is `expr 2 + 2`
 * Backslash quotes a literal \$, \` or \\
EOF
```

转义

```bash
cat << 'TOKEN'
If TOKEN has any quoted characters (like 'TOKEN', "TOKEN" or \TOKEN),
then all $ ` \ in the here document are literal characters.
 
$PATH \$PATH
TOKEN
```

带sudo的引用

```bash
sudo bash -c "cat >> $(mktemp) << EOF
Here documents do parameter and command substitution:
 * Your HOME is $HOME
 * 2 + 2 is $(expr 2 + 2)
 * Backslash quotes a literal \$, \\\` or \\\\
EOF
"
```

带sudo的转义

```bash
sudo bash -c "cat >> $(mktemp) << 'TOKEN'
If TOKEN has any quoted characters (like 'TOKEN', \"TOKEN\" or \TOKEN),
then all \` \\ in the here document are literal characters.
 
$PATH \$PATH
TOKEN
"
```



> Here document: https://rosettacode.org/wiki/Here_document

### tac

逆序输出

```
tac $file
seq 9 | tac
```

### rev

将文本中的内容按列反序输出

```
rec $file
```

### head

```
# 开始于首行，结束于正数第3行
cat $file | head -n+3

# 同上
cat $file | head -n3

# 同上
cat $file | head -3

# 开始于首行，结束于倒数第4行
cat $file | head -n-3
```

### tail

```
# 开始于正数第3行，结束于末行
cat $file | tail -n+3

# 开始于倒数第3行，结束于末行
cat $file | tail -n-3

# 同上
cat $file | tail -n3

# 同上
cat $file | tail -3

```

### colrm

```
# 移除第1列至第3列的内容
cat $file | colrm 1 3
```

### cut

`cut` 与 `colrm` 相反，colrm是剔除，而cut是抽取

```
# 抽取1-2列以及4-5列的内容
cut -c 1-2,4-5 $file

# 抽取1,3,4,5字段，文本字段以：作为分隔符
cut -f1,3-5 -d':' /etc/passwd
```

### diff

```
diff $file1 $file2
```

比较结果举例

- 3c3  将第一个文件的第三行改成和第二个文件的第三行一样。
- 1a2  将第一个文件的第一行追加第二个文件的第二行。
- 4d3  将第一个文件删除第四行。
- <  前一个文件独有的行
- \>  后一个文件独有的行
- ---  分隔符

### sdiff

side-by-side diff，比 `diff` 更直观

```
sdiff $file1 $file2
```

### vimdiff

vimdiff, 比 `sdiff` 更直观

```
vimdiff $file1 $file2
```

### paste

与 `cat` 类似，但 `paste` 为水平组合，`cat` 为垂直组合

```
# 列间以制表符为定界符
paste data1 data2 data3

# 列间以一个空格为定界符
paste -d ' ' data1 data2 data3

# 轮流以+和-为定界符
paste -d '+-' data1 data2 data3	
```

### nl

```
# 给文本行编号，包括空行，不改变原文本
nl -ba $file
```

### wc

```
# 统计文件的行数，单词数，字符数
wc $file
```

### expand

```
# 将制表符转成4个空格
expand -t 4	$file
```

### unexpand

```
# 将4个空格转换成一个制表符
unexpand -t 4 $file
```

### fold

指定行宽为 20

```
cat /dev/urandom | tr -dc '0-9a-zA-Z' | fold -w 20 | head -10
```

### fmt

格式化段落

```
fmt $data1
```

### columnt

列前后对齐

```
ss -atp | column -t
```

### look

与 `grep` 相比，`look` 只能在行首开始搜索并匹配，速度更快， `grep` 可无序输入，也能从stdout中读取，不限于行首，可使用正则。

### sort

```
sort -o $file $file
```

### uniq

```
sort $file1 $file2 $file3 | uniq
```

### join

根据两个文件中相同的列进行联接，依赖于有序性，联接字段默认为每个文件的第一个字段

```
# 相当于左联接
join -a1 $file1 $file2

# 相当于右联接
join -a2 $file1 $file2

# 相当于全联接
join -a1 -a2 $file1 $file2

# 相当于 select * from $file1 join $file2 on $file1.field3 = $file2.field4
join -1 3 -2 4 $file1 $file2

# 只显示$file1中不匹配的
join -v1 $file1 $file2

# 只显示$file2中不匹配的
join -v2 $file1 $file2

# 显示两个文件中都不匹配的
join -v1 -v2 $file1 $file2
```

### tsort

数学术语中讲，每个约束都称为一个偏序(partial ordering)，因为它们只指定了一些活动的顺序，而不是全部。例如： A -> B  1 -> 2

主列表是全序(total ordering)，因为它指定全部活动顺序。

从数学上讲，可使用 `有向图` 表示一组偏序，如果这组偏序中没有循环，则可以称 `有向无环图(Directed Acyclic Graph, DAG)。例如：树。

一旦拥有了DAG，就可以给予元素在图中的相对位置对元素进行排序，从而由偏序创建全序。实际上，这就是 `tsort` 程序完成任务的方式。

在数学中，用单词 `topological, 拓扑` 来秒数依赖于相对位置的属性。由此 `tsort` 代表 topological sort

通常，只要偏序组中没有循环，任何偏序组都可以组成一个全序。

### tr

逐字替换

```
# 将$old中的a,b,c分别替换成大写的，然后重定向到$new中
tr abc ABC < $old > $new

# a换成大写，bcde换成x
tr abcde Ax < $old > $new

# 同上
tr abcde Axxxx < $old > $new
```

范围匹配

```
# 大写转小写
tr A-Z a-z < $old > $new

# 大写转小写
tr [:upper:] [:lower:] < $old > $new 
```

不可见字符

```
# 回车换新行
tr '\r' '\n' < $macfile > $unixfile

# 回车换新行
tr '\015' '\012' < $macfile > $unixfile
```

挤压

```
# 连续的数字全部转换成一个X
tr -s [:digit:] X < $old > $new

# 连续的空格全部挤压成一个空格
tr -s ' ' ' ' < $old > $new
```

删除

```
# 删除所有的左右圆括号
tr -d '()' < $old > $new

# 删除 '0-9' 的补集的字符
tr -dc '0-9' < $old > $new

```

### grep

单词匹配

```
grep -w 'cat' $file
grep '\<cat\>' $file
grep '\bcat\b' $file
```

排除空行和注释

```
egrep -v '^$|^#' $file
```

匹配行统计

```
echo -e "1 2 3 4\nhello\n5 6" | egrep -c "[0-9]" 
```

匹配项统计

```
echo 0e "1 2 3 4\nhello\n5 6" | egrep -o "[0-9]" | wc -l
```

与&或&非

```
# 与
echo "gnu is not unix" | grep --color -e "gnu" -e "unix"

# 或
echo "gnu is not unix" | egrep --color "gnu|linux"

# 非：排除文件
grep "main()" . -rl --exclude "README"

# 非：排除目录
grep "main()" . -rl --exclude-dir "test"

# 非：排除文件列表
grep "main()" . -rl --exclude-from "file_list.txt"
```

-0

```
# 创建测试文件
echo "test" > file1
echo "cool" > file2
echo "test" > file3

# 测试
grep -lZ "test" file* | xargs -0 rm
```



### paste

let say we have two files following

`issue_type.1`

```
Power_Other
PSU_Other
Raid_Other
Unknown
Raid_SKU_Raid_Level
```

`issue_type.1`

```
'Power: Other'
'PSU: Other'
'Raid: Other'
'Unknown'
'Raid SKU: Raid Level'
```

paste them makes line with side by side

```
paste -d '=' issue_type.1 issue_type.2
```



### xargs

print0

```
# 错误写法
find ./ -type f -name "log.txt" -print | xargs rm -f

# 正确写法
find ./ -type f -name "log.txt" -print0 | xargs -0 rm -f
```

> -print0 以字符null(\0)来分隔输出，xargs以-0表示用\0来分隔输入。

循环用xargs改写

```
# 循环
cat TableOfContent.txt | (while read TableOfContent; do cat $TableOfContent; done)

# 可改写为xargs
cat TableOfContent.txt | xargs -I{} cat {} 
```



### 组合使用

列出含有error的文件

```
find /var/log/ -type f -print | xargs bash -c 'sudo grep -ril error'
```



## debug

### lsof

get open files such as Internet sockets or Unix Domain sockets.

```
lsof -i -a -p $PID
```

- `-i` produces a list of network files belonging to a user or process
- `-a` logically combines or AND's given parameters