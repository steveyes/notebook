# process 

STANDARD FORMAT SPECIFIERS



## CPU footprint

### find top 10 running processes by highest CPU footprint 

```
ps -eo ppid,pid,user,pcpu,stat,time,comm --sort=-pcpu | head -10
ps ax -o ppid,pid,user,pcpu,stat,time,comm --sort=-pcpu | head -10
```



## memory footprint

### get top 10 highest rss memory footprint running processes

```
ps aux --sort=-rss | head -10
```

```
ps -eo pid,ppid,user,vsz,rss,comm,args --sort=-rss | head -10
```

### get top 10 highest % memory footprint running processes

```
ps ax -o ppid,pid,user,pmem,stat,time,comm --sort=-pmem | head -10
```

```
top -c -b -o +%MEM | tail -n+7 | head -11
```

```
for pid in $(ps h -o pid); do 
	echo "$pid $(pmap $pid | tail -n1 | awk '/total.*[0-9]K/{print $2}') $(ps -p $pid -o comm=)" 
done | sort -b -k2hr | awk 'BEGIN {print "PID","MEMORY","COMMAND"} {print}' | column -t
```



## get more about the processes in D state

```
ps -eo ppid,pid,user,stat,pcpu,comm,wchan:32
```

```
echo w > /proc/sysrq-trigger
```



## get the most 10 memory footprint processes

```
ps -eo ppid,pid,user,pmem,stat,time,comm --sort=-pcpu | head -10
ps ax -o ppid,pid,user,pmem,stat,time,comm --sort=-pmem | head -10
```



## lsof

```
lsof -p $pid
```



## gdb



## task monitor in main process to check if the process.is_alive()



## IPC

| 编号 | 名称    | 缩写 | 描述                                 |
| ---- | ------- | ---- | ------------------------------------ |
| 1    | SIGHUP  | HUP  | 终止：注销或者终端失去连接是发送     |
| 2    | SIGINT  | INT  | 中断：按下  `^C` 时发送              |
| 9    | SIGKILL | KILL | 杀死：立即终止，进程不能被捕获       |
| 15   | SIGTERM | TERM | 终止：请求终止，进程不能被捕获       |
| 18   | SIGCONT | CONT | 继续：恢复挂起，由 `fg` 或 `bg` 发送 |
| 19   | SIGSTOP | STOP | 停止：按下 `^Z` 时发送               |



## strace

Trace the Execution of an Executable

```
strace ls
```

Trace a Specific System Calls in an Executable Using Option -e

```
strace -e open ls
strace -e trace=open,read ls /home
```

Save the Trace Execution to a File Using Option -o

```
strace -o output.txt ls
```

Execute Strace on a Running Linux Process Using Option -p

```
sudo strace -p <PID> -o <PID>.strace
```

Print Timestamp for Each Trace Output Line Using Option -t

```
strace -t -e open ls /home
strace -tt -e open ls /home
```

> -tt 
>
> If given twice, the time printed will include the miscroseconds.

Print Relative Time for System Calls Using Option -r

```
strace -r ls 
```

Generate Statistics Report of System Calls Using Option -c

```
strace -c ls /home
```

Make strace show time spent in system calls using Option -T

```
strace -T ls
```

