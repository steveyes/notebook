# IPC namespace

IPC namespace用来隔离[System V IPC objects](http://man7.org/linux/man-pages/man7/svipc.7.html)和[POSIX message queues](http://man7.org/linux/man-pages/man7/mq_overview.7.html)。其中System V IPC objects包含Message queues、Semaphore sets和Shared memory segments.



## API

nsenter：加入指定进程的指定类型的namespace，然后执行参数中指定的命令。详情请参考[^1]和[^2]

unshare：离开当前指定类型的namespace，创建且加入新的namespace，然后执行参数中指定的命令。详情请参考[^3]和[^4]。



## example: by C

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
static int child_func()
{
    // replaces  the current process image with a new process image.
    // execlp("bash", "bash", (char *)NULL);

    execlp("ipcs", "ipcs", "-q", NULL);

    // the code here will never be executed
    // char *const bash_args[] = {"/bin/bash", NULL};
    // execv(bash_args[0], bash_args);

    return 0;
}

int ipc_enable()
{

    // flags with CLONE_NEWIPC
    int container_pid = clone(child_func, child_stack + STACK_SIZE, CLONE_NEWUTS | CLONE_NEWIPC | SIGCHLD, NULL);

    // parent wait children
    waitpid(container_pid, NULL, 0);
    return 0;
}

int ipc_disable()
{

    // flags without CLONE_NEWIPC
    int container_pid = clone(child_func, child_stack + STACK_SIZE, CLONE_NEWUTS | SIGCHLD, NULL);

    // parent wait children
    waitpid(container_pid, NULL, 0);
    return 0;
}

int main()
{
    // remove all message queue.
    system("ipcs -q | tail +4 | awk '{print $2}' | xargs -I{} ipcrm -q {}");
    
    // Create a message queue.
    system("ipcmk -Q");

    // Write information about active message queues.
    printf("\n-------------------- in parent --------------------\n");
    system("ipcs -q | tail +2");
    printf("\n-------------------- in parent --------------------\n");

    printf("\n-------------------- ipc enable --------------------\n");
    ipc_enable();
    printf("\n-------------------- ipc enable --------------------\n");

    printf("\n-------------------- ipc disable --------------------\n");
    ipc_disable();
    printf("\n-------------------- ipc disable --------------------\n");

    // remove all message queue.
    system("ipcs -q | tail +4 | awk '{print $2}' | xargs -I{} ipcrm -q {}");
}
```



## example: by Bash

in shell window #0

```
# remove all mq
ipcs -q | tail +4 | awk '{print $2}' | xargs -I{} ipcrm -q {}

# make sure no mq exists
ipcs -q

# create a new mq
ipcmk -Q

# will be same with #1
ipcs -q
```



in shell window #1

```
# will be diff with #2
ipcs -q

# go to #2

# from #1
# 
nsenter -t 10086 -u -i /bin/bash

# same with #2
ipcs -q
```



in shell window #2

```
# -i=--ipc, -u=--uts
unshare -iu /bin/bash

# diff with #1
ipcs -q

# create a new mq
ipcmk -Q

# will be same with #1
ipcs -q

# get PID of this bash, as if $$ == 10086
echo $$

# go to #1
```





## reference

[^1]: <http://man7.org/linux/man-pages/man1/nsenter.1.html>
[^2]: <https://github.com/karelzak/util-linux/blob/master/sys-utils/nsenter.c>
[^3]: <http://man7.org/linux/man-pages/man1/unshare.1.html>
[^4]: <https://github.com/karelzak/util-linux/blob/master/sys-utils/unshare.c>



