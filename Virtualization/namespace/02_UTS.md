# UTS namespace 

> CLONE_NEWUTS



UTS namespace用来隔离系统的hostname以及NIS domain name。

术语UTS来自于调用函数uname()时用到的结构体: struct utsname. 而这个结构体的名字源自于"UNIX Time-sharing System".

注意： NIS domain name和DNS没有关系，关于他的介绍可以看[^1]，由于本人对它不太了解，所以在本文中不做介绍。



## API

| comm          | ref                           |
| ------------- | ----------------------------- |
| sethostname   | man 2 sethostname             |
| setdomainname | man 2 setdomainname           |
| uname         | man 2 uname  [or] man 1 uname |
| gethostname   | man 2 gethostname             |
| getdomainname | man 2 getdomainnameq          |
| clone         |                               |



## 创建新的UTS namespace

filename: uts_01.c

```c
#define _GNU_SOURCE
#include <sched.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define IS_OK(ret_v, msg) \
    {                     \
        if (ret_v == -1)  \
        {                 \
            perror(msg);  \
            exit(-1);     \
        }                 \
    }

// child stack size = 1M
#define STACK_SIZE (1024 * 1024)
static char child_stack[STACK_SIZE];

// child process
static int child_func(void *hostname)
{
    // set hostname
    sethostname(hostname, strlen(hostname));

    // replaces  the current process image with a new process image.
    execlp("bash", "bash", (char *)NULL);

    // the code here will never be executed
    char *const bash_args[] = {"/bin/bash", NULL};
    execv(bash_args[0], bash_args);

    return 0;
}

int main(int argc, char *argv[])
{
    pid_t child_pid;

    if (argc < 2)
    {
        printf("Usage: %s <child-hostname>\n", argv[0]);
        return -1;
    }

    // child_func: When the child process is created with clone(), it commences execution by calling the function pointed to by the argument fn.
    // child_stack + STACK_SIZE: Stacks grow downward on  all  proces‐sors that run Linux (except the HP PA processors), so child_stack usually points to the topmost address of the memory space set up for the child stack.
    // SIGCHLD | CLONE_NEWUTS: flags may also be bitwise-ORed with zero or more of the following constants, in order to specify what is shared between the calling process and the child process.
    // argv[1]: The arg argument is passed as the argument of the function: child_func
    child_pid = clone(child_func, child_stack + STACK_SIZE, SIGCHLD | CLONE_NEWUTS, argv[1]);

    IS_OK(child_pid, "clone");

    // parent wait for child
    waitpid(child_pid, NULL, 0);

    // parent finish
    return 0;
}
```

#### 代码执行顺序

1. 父进程创建新的子进程，并且设置CLONE_NEWUTS，这样就会创建新的UTS namespace并且让子进程属于这个新的namespace，然后父进程一直等待子进程退出
2. 子进程在设置好新的 hostname 后被bash替换掉
3. bash退出后，子进程退出，接着父进程也退出

#### 编译 

```
gcc uts_01.c -o uts_01
```

#### 设置容器名, 并进入容器内

```
sudo ./uts_01 container01
```

#### 查看 hostname

```
hostname
```

####  查看进程树, PID 为 15839, PPID 为 15838

```
pstree -pl | grep $$
```

>            |               |-gnome-terminal-(15742)-+-bash(15749)---sudo(15837)---01_uts(15838)---bash(15839)-+-grep(16377)

####  验证 PID 和 PPID 属于不同的namespace

```
readlink /proc/15839/ns/uts
readlink /proc/15838/ns/uts
```

#### 验证 PID 和其子进程同属于一个namespace

```
readlink /proc/15839/ns/uts
readlink /proc/self/ns/uts
```

#### 验证 PPID 和 systemd(1) 同属于一个namespace

```
readlink /proc/15838/ns/uts
readlink /proc/1/ns/uts
```



## 将当前进程加入指定的namespace

filename: uts_02.c

```c
#define _GNU_SOURCE
#include <sched.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#define IS_OK(ret_v, msg) \
    {                     \
        if (ret_v == -1)  \
        {                 \
            perror(msg);  \
            exit(-1);     \
        }                 \
    }

int main(int argc, char *argv[])
{
    int fd, ret;

    if (argc < 2)
    {
        printf("%s /proc/PID/ns/FILE\n", argv[0]);
        return -1;
    }

    // 获取 namespace 对应文件的描述符
    fd = open(argv[1], O_RDONLY);
    IS_OK(fd, "open");

    // 执行完setns后，当前进程将加入指定的namespace
    // 这里第二个参数为0，表示由系统自己检测fd对应的是哪种类型的namespace
    ret = setns(fd, 0);
    IS_OK(ret, "setns");

    execlp("bash", "bash", (char *)NULL);

    return 0;
}
```

#### 编译 

```
# 编译
gcc uts_02.c -o uts_02
```

#### 加入15839的namespace, 上一个实验的容器PID

```
sudo ./uts_02 /proc/15839/ns/uts
```

#### 查看 hostname, 应与上一个实验中容器的hostname一致

```
hostname
```

####  查看 uts, 应与上一个实验中容器的uts一致

```
readlink /proc/$$/ns/uts
```



## 退出当前namespace并加入新创建的namespace

```c
#define _GNU_SOURCE
#include <sched.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define IS_OK(ret_v, msg) \
    {                     \
        if (ret_v == -1)  \
        {                 \
            perror(msg);  \
            exit(-1);     \
            
        }                 \
    }

static void usage(const char *pname)
{
    char usage[] = "Usage: %s [options]\n"
                   "Options are:\n"
                   "    -i unshare IPC namespace\n"
                   "    -m unshare mount namespace\n"
                   "    -n unshare network namespace\n"
                   "    -p unshare PID namespace\n"
                   "    -u unshare UTS namespace\n"
                   "    -U unshare user namespace\n";

    printf(usage, pname);
    exit(0);
}

int main(int argc, char *argv[])
{
    int flags = 0, opt, ret;

    // 解析命令行参数，用来决定退出哪个类型的namespace
    while ((opt = getopt(argc, argv, "imnpuUh")) != -1)
    {
        switch (opt)
        {
        case 'i':
            flags |= CLONE_NEWIPC;
            break;
        case 'm':
            flags |= CLONE_NEWNS;
            break;
        case 'n':
            flags |= CLONE_NEWNET;
            break;
        case 'p':
            flags |= CLONE_NEWPID;
            break;
        case 'u':
            flags |= CLONE_NEWUTS;
            break;
        case 'U':
            flags |= CLONE_NEWUSER;
            break;
        case 'h':
            usage(argv[0]);
            break;
        default:
            usage(argv[0]);
            break;
        }
    }

    if (flags == 0)
    {
        usage(argv[0]);
    }

    // 执行完unshare函数后，当前进程就会退出当前的一个或多个类型的namespace,
    // 然后进入到一个或多个新创建的不同类型的namespace
    ret = unshare(flags);
    IS_OK(ret, "unshare");

    //用一个新的bash来替换掉当前子进程
    execlp("bash", "bash", (char *) NULL);
}
```
#### 编译 

```
gcc uts_03.c -o uts_03
```

#### 退出当前UTS namespace, 并加入一个新的

```
sudo ./uts_03 -u
```



## 总结

- namespace的本质就是把原来所有进程全局共享的资源拆分成了很多个一组一组进程共享的资源
- 当一个namespace里面的所有进程都退出时，namespace也会被销毁，所以抛开进程谈namespace没有意义
- UTS namespace就是进程的一个属性，属性值相同的一组进程就属于同一个namespace，跟这组进程之间有没有亲戚关系无关
- clone和unshare都有创建并加入新的namespace的功能，他们的主要区别是：
  - unshare是使当前进程加入新创建的namespace
  - clone是创建一个新的子进程，然后让子进程加入新的namespace
- UTS namespace没有嵌套关系，即不存在说一个namespace是另一个namespace的父namespace



## references

[^1]: <https://www.freebsd.org/doc/handbook/network-nis.html>
[2]: <http://www.haifux.org/lectures/299/netLec7.pdf>

