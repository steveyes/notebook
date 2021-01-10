# Namespace 概述

Namespace是对全局系统资源的一种封装隔离，使得处于不同namespace的进程拥有独立的全局系统资源，改变一个namespace中的系统资源只会影响当前namespace里的进程，对其他namespace中的进程没有影响。



## Linux内核支持的namespaces



| 名称    | 宏定义          | 隔离内容                                                     |
| ------- | --------------- | ------------------------------------------------------------ |
| Cgroup  | CLONE_NEWCGROUP | Cgroup root directory (since Linux 4.6)                      |
| IPC     | CLONE_NEWIPC    | System V IPC, POSIX message queues (since Linux 2.6.19)      |
| Network | CLONE_NEWNET    | Network devices, stacks, ports, etc. (since Linux 2.6.24)    |
| Mount   | CLONE_NEWNS     | Mount points (since Linux 2.4.19)                            |
| PID     | CLONE_NEWPID    | Process IDs (since Linux 2.6.24)                             |
| User    | CLONE_NEWUSER   | User and group IDs (started in Linux 2.6.23 and completed in Linux 3.8) |
| UTS     | CLONE_NEWUTS    | Hostname and NIS domain name (since Linux 2.6.19)            |



## 查看进程所属的 namespaces

系统中的每个进程都有/proc/[pid]/ns/这样一个目录，里面包含了这个进程所属namespace的信息，里面每个文件的描述符都可以用来作为setns函数(后面会介绍)的参数。

```
# 查看当前bash进程所属的namespace
ls -l /proc/$$/ns/

# 查看当前运行进程所属的namespace
ls -l /proc/self/ns/
```



## API

### clone

创建一个新的进程并把他放到新的namespace中

```c
int clone(int (*child_func)(void *), void *child_stack, int flags, void *arg);
```

flags： 一个或者多个上面的CLONE_NEW*（当然也可以包含跟namespace无关的flags）， 就会创建一个或多个新的不同类型的namespace， 把新创建的子进程加入新创建的这些namespace中。



### setns

将当前进程加入到已有的namespace中

```c
int setns(int fd, int nstype);
```

fd：指向/proc/[pid]/ns/目录里相应namespace对应的文件，要加入哪个namespace

nstype：namespace的类型（上面的任意一个CLONE_NEW*）：

1. 如果当前进程不能根据fd得到它的类型，如fd由其他进程创建，通过UNIX domain socket传给当前进程，就需要通过nstype来指定fd指向的namespace的类型
2. 如果进程能根据fd得到namespace类型，比如这个fd是由当前进程打开的，nstype设置为0即可



### unshare

使当前进程退出指定类型的namespace，并加入到新创建的namespace（相当于创建并加入新的namespace）

```c
int unshare(int flags);
```

```
flags: 指定一个或者多个上面的CLONE_NEW*，这样当前进程就退出了当前指定类型的namespace并加入到新创建的namespace
```



### clone和unshare的区别

clone和unshare的功能都是创建并加入新的namespace， 他们的区别是：

- unshare是使当前进程加入新的namespace
- clone是创建一个新的子进程，然后让子进程加入新的namespace，而当前进程保持不变



## reference

---

[1]: <http://man7.org/linux/man-pages/man7/namespaces.7.html>
[2]: <https://lwn.net/Articles/531114/>
[3]: <https://segmentfault.com/a/1190000006908272>