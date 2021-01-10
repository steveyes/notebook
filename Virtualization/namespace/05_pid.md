# Linux Namespace系列05

> pid namespace (CLONE_NEWPID)



## 格式规约

- 基本描述

- ```
  命令
  ```

- > 副标题，命令输出



## 基本概念

PID namespaces用来隔离进程的ID空间，使得不同pid namespace里的进程ID可以重复且相互之间不影响。

PID namespace可以嵌套，也就是说有父子关系，在当前namespace里面创建的所有新的namespace都是当前namespace的子namespace。父namespace里面可以看到所有子孙后代namespace里的进程信息，而子namespace里看不到祖先或者兄弟namespace里的进程信息。

目前PID namespace最多可以嵌套32层，由内核中的宏 `MAX_PID_NS_LEVEL` 来定义。

Linux下的每个进程都有一个对应的/proc/PID目录，该目录包含了大量的有关当前进程的信息。 对一个PID namespace而言，/proc目录只包含当前namespace和它所有子孙后代namespace里的进程的信息。

在Linux系统中，进程ID从1开始往后不断增加，并且不能重复（当然进程退出后，ID会被回收再利用），进程ID为1的进程是内核启动的第一个应用层进程，一般是init进程（现在采用systemd的系统第一个进程是systemd），具有特殊意义，当系统中一个进程的父进程退出时，内核会指定init进程成为这个进程的新父进程，而当init进程退出时，系统也将退出。

除了在init进程里指定了handler的信号外，内核会帮init进程屏蔽掉其他任何信号，这样可以防止其他进程不小心kill掉init进程导致系统挂掉。不过有了PID namespace后，可以通过在父namespace中发送SIGKILL或者SIGSTOP信号来终止子namespace中的ID为1的进程。

由于ID为1的进程的特殊性，所以每个PID namespace的第一个进程的ID都是1。当这个进程运行停止后，内核将会给这个namespace里的所有其他进程发送SIGKILL信号，致使其他所有进程都停止，于是namespace被销毁掉。



## 简单示例

```
# 查看当前pid namespace的ID
dev@ubuntu:~$ readlink /proc/self/ns/pid
pid:[4026531836]

# --uts是为了设置一个新的hostname，便于和老的namespace区分
# --mount是为了方便我们修改新namespace里面的mount信息，因为这样不会对老namespace造成影响
# --fork是为了让unshare进程fork一个新的进程出来，然后再用exec bash替换掉新的进程
# 这是pid namespace本身的限制，进程所属的pid namespace在它创建的时候就确定了，不能更改，
# 所以调用unshare和nsenter后，原来的进程还是属于老的namespace，
# 而新fork出来的进程才属于新的namespace
dev@ubuntu:~$ sudo unshare --uts --mount --pid --fork /bin/bash
root@ubuntu:~# hostname container001
root@ubuntu:~# exec bash
root@container001:~#

# 查看进程间关系，当前bash(28335)确实是unshare的子进程
root@container001:~# unshare(28334)---bash(28335)
unshare(28334)---bash(28335)

#他们属于不同的 pid namespace
root@container001:~# readlink /proc/28334/ns/pid
pid:[4026531836]
root@container001:~# readlink /proc/28335/ns/pid
pid:[4026532469]

# 但为什么通过这种方式查看到的namespace还是老的呢？
root@container001:~# readlink /proc/$$/ns/pid
pid:[4026531836]

# 由于我们实际上已经是在新的 pid namespace里了，并且当前bash是当前namespace的第一个进程
# 所以在新的namespace里看到的他的进程ID是1
root@container001:~# echo $$
1

# 但由于我们新的 namespace的挂载信息是从老的namespace拷贝过来的，
# 所以这里看到1并不是当前新的 pid namespace的进程号为1的信，还是老namespace里面的进程号为1的信息
root@container001:~# readlink /proc/1/ns/pid
pid:[4026531836]

# ps命令依赖 /proc 目录，所以ps的输出还是老namespace的视图
root@container001:~# ps ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 7月07 ?       00:00:06 /sbin/init
root         2     0  0 7月07 ?       00:00:00 [kthreadd]
 ...
root     31644 17892  0 7月14 pts/0   00:00:00 sudo unshare --uts --pid --mount --fork /bin/bash
root     31645 31644  0 7月14 pts/0   00:00:00 unshare --uts --pid --mount --fork /bin/bash

# 所以我们需要重新挂载我们的/proc目录
root@container001:~# mount -t proc proc /proc

#重新挂载后，能看到我们新的pid namespace ID了
root@container001:~# readlink /proc/$$/ns/pid
pid:[4026532469]

#ps的输出也正常了
root@container001:~# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 7月14 pts/0   00:00:00 bash
root        44     1  0 00:06 pts/0    00:00:00 ps -ef
```



## PID namespace嵌套

- 调用unshare或者setns函数后，当前进程的namespace不会发生变化，不会加入到新的namespace，而它的子进程会加入到新的namespace。也就是说进程属于哪个namespace是在进程创建的时候决定的，并且以后再也无法更改。

- 在一个PID namespace里的进程，它的父进程可能不在当前namespace中，而是在外面的namespace里面（这里外面的namespace指当前namespace的祖先namespace），这类进程的ppid都是0。比如新namespace里面的第一个进程，他的父进程就在外面的namespace里。通过setns的方式加入到新namespace中的进程的父进程也在外面的namespace中。

- 可以在祖先namespace中看到子namespace的所有进程信息，且可以发信号给子namespace的进程，但进程在不同namespace中的PID是不一样的。

  

## 嵌套示例

### in shell window #1

记下最外层的namespace ID

```
readlink /proc/$$/ns/pid
```
> pid:[4026531836]



创建新的pid namespace， 这里--mount-proc参数是让unshare自动重新mount /proc目录

```
sudo unshare --uts --pid --mount --fork --mount-proc /bin/bash
hostname container001
exec bash
readlink /proc/$$/ns/pid
```
> pid:[4026532636]



再创建新的pid namespace

```
unshare --uts --pid --mount --fork --mount-proc /bin/bash
hostname container002
exec bash
readlink /proc/$$/ns/pid
```
> pid:[4026532639]



再创建新的pid namespace

```
unshare --uts --pid --mount --fork --mount-proc /bin/bash
hostname container003
exec bash
readlink /proc/$$/ns/pid
```
> pid:[4026532642]



目前namespace container003里面就一个bash进程
```
pstree -p
```
> bash(1)───pstree(26)



这样我们就有了三层pid namespace，
他们的父子关系为 container001 -> container002 -> container003



### in shell window #2

在最外层的namespace中查看上面新创建的三个namespace中的bash进程

从这里可以看出，这里显示的bash进程的PID和上面container003里看到的bash(1)不一样

```
pstree -pl | grep unshare | grep -Po "bash\([0-9]+\)"
```
> bash(28314)
> bash(28554)
> bash(28633)
> bash(28752)




各个unshare进程的子bash进程分别属于上面的三个pid namespace

```
sudo readlink /proc/28554/ns/pid
```
> pid:[4026532636]




```
sudo readlink /proc/28633/ns/pid
```
> pid:[4026532639]



```
sudo readlink /proc/28752/ns/pid
```
>  pid:[4026532642]



PID在各个namespace里的映射关系可以通过/proc/[pid]/status查看到
这里28752是在最外面namespace中看到的pid
57	27	1 分别是在container001，container002和container003中的pid

```
grep pid /proc/28752/status
```
> NSpid:	28752	57	27	1



创建一个新的bash并加入container002
```
sudo nsenter --uts --mount --pid -t 28633 /bin/bash
```



这里 bash(27) 就是container003里面的pid 1对应的bash

```
pstree -p
```
> bash(1)───unshare(26)───bash(27)



unshare(26) 属于container002
```
readlink /proc/26/ns/pid
```
> pid:[4026532472]



bash(27) 属于container003
```
readlink /proc/26/ns/pid
```
> pid:[4026532475]



为什么上面pstree的结果里面没看到nsenter加进来的bash呢？
通过ps命令我们发现，我们新加进来的那个/bin/bash的ppid是0，难怪pstree里面显示不出来
从这里可以看出，跟最外层namespace不一样的地方就是，这里可以有多个进程的ppid为0
从这里的TTY也可以看出哪些命令是在哪些窗口执行的，
pts/0对应第一个shell窗口，pts/1对应第二个shell窗口

```
ps -ef
```

> UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 21:42 pts/0    00:00:00 bash
root        26     1  0 21:42 pts/0    00:00:00 unshare --uts --pid --mount --fo
root        27    26  0 21:42 pts/0    00:00:00 bash
root        54     0  0 22:09 pts/1    00:00:00 /bin/bash
root        73    54  0 22:14 pts/1    00:00:00 ps -ef



### in shell window #3

创建一个新的bash并加入container001
```
sudo nsenter --uts --mount --pid -t 28554 /bin/bash
```



```
pstree -pl
```
> bash(1)───unshare(30)───bash(31)───unshare(56)───bash(57)



```
ps -ef
```
> UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 21:41 pts/0    00:00:00 bash
root        30     1  0 21:42 pts/0    00:00:00 unshare --uts --pid --mount --fo
root        31    30  0 21:42 pts/0    00:00:00 bash
root        56    31  0 21:42 pts/0    00:00:00 unshare --uts --pid --mount --fo
root        57    56  0 21:42 pts/0    00:00:00 bash
root        84     0  0 22:09 pts/1    00:00:00 /bin/bash
root       108     0  0 22:18 pts/2    00:00:00 /bin/bash
root       126   108  0 22:19 pts/2    00:00:00 ps -ef

通过 pstree 和ps -ef我们可看到所有三个namespace中的进程及他们的关系
- bash(1)───unshare(30)属于container001
- bash(31)───unshare(56)属于container002
- bash(57)属于container003
- 而84和108两个进程分别是上面两次通过nsenter加进来的bash
- 同上面ps的结果比较我们可以看出，同样的进程在不同的namespace里面拥有不同的PID



发送信号给contain002中的bash
```
kill 84
```



### in shell window #2

回到第二个窗口，发现bash已经被kill掉了，说明父namespace是可以发信号给子namespace中的进程的

> (base) root@container002:/# exit
> (base) vingelis@ubuntu18:~$ 



## init 示例

当一个进程的父进程被kill掉后，该进程将会被当前namespace中pid为1的进程接管，而不是被最外层的系统级别的init进程接管。

当pid为1的进程停止运行后，内核将会给这个namespace及其子孙namespace里的所有其他进程发送SIGKILL信号，致使其他所有进程都停止，于是当前namespace及其子孙后代的namespace都被销毁掉。


还是继续以上面三个namespace为例

### in shell window #1

在container003里面启动两个新的bash，使他们的继承关系如下

```
bash
bash
pstree
```
> bash───bash───bash───pstree



利用unshare、nohup和sleep的组合，模拟出我们想要的父子进程
unshare --fork会使unshare创建一个子进程
nohup sleep 3600 & 会让这个子进程在后台运行并且sleep一小时

```
unshare --fork nohup sleep 3600 &
```
> [1] 54 



于是我们得到了我们想要的进程间关系结构
```
pstree -p
```
> bash(1)───bash(29)───bash(41)─┬─pstree(56)
                                                               └─unshare(54)───sleep(55)



如我们所期望的，kill掉unshare(54)后， sleep就被当前pid namespace的bash(1)接管了

```
kill 54
pstree -p
```

> bash(1)─┬─bash(29)───bash(41)───pstree(58)
                └─sleep(55)



重新回到刚才的状态，后面将尝试在第三个窗口中kill掉这里的unshare进程

```
kill 55
unshare --fork nohup sleep 3600 &
pstree -p
```
>  bash(1)───bash(29)───bash(41)─┬─pstree(72)
>                                                                 └─unshare(70)───sleep(71)



### in shell window #3

```
pstree -p
```
> bash(1)───unshare(30)───bash(31)───unshare(56)───bash(57)───bash(127)───bash(139)───unshare(168)───sleep(169)



kill掉sleep(169)的父近程unshare(168)

```
kill 168
```

结果显示sleep（169）被bash(57)接管了，而不是bash(1)，
进一步说明container003里的进程只会被container003里的pid 1进程接管，
而不会被外面container001的pid 1进程接管

```
pstree -p
```
> bash(1)───unshare(30)───bash(31)───unshare(56)───bash(57)─┬─bash(127)───bash(139)
                                                                                                                          └─sleep(169)



kill掉container002中pid 1的bash进程，在container001中，对应的是bash(31)
根本没反应，说明bash不接收TERM信号（kill默认发送SIGTERM信号）

```
kill 31
pstree -p
```



试试SIGSTOP，貌似也不行      

```
kill -SIGSTOP 31
pstree -p
```



最后试试杀手锏SIGKILL，马到成功
```
kill -SIGKILL 31
pstree -p
```
>  bash(1)



### in shell window #1

container003和container002的bash退出了，
第一个shell窗口直接退到了container001的bash

> (base) root@container003:~# Killed
> (base) root@container001:~#  



### in shell window #2

通过nsenter方式加入到container002的bash也被kill掉了

> (base) root@container002:/# exit
> (base) vingelis@ubuntu18:~$

从结果可以看出，container002的“init”进程被杀死后，
内核将会发送SIGKILL给container002里的所有进程，
这样导致container002及它所有子孙namespace里的进程都杀死，
同时container002和container003也被销毁

