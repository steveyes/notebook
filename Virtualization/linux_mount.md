# linux mount



## mount info

- /proc/[pid]/mounts
- /proc/[pid]/mountinfo
- /proc/[pid]/mountstats



## 挂载虚拟文件系统

proc、tmpfs、sysfs、devpts等都是Linux内核映射到用户空间的虚拟文件系统，他们不和具体的物理设备关联，但他们具有普通文件系统的特征，应用层程序可以像访问普通文件系统一样来访问他们。

> 将内核的proc文件系统挂载到/mnt，
> 这样就可以在/mnt目录下看到系统当前运行的所有进程的信息，
> 由于proc是内核虚拟的一个文件系统，并没有对应的设备，
> 所以这里-t参数必须要指定，不然mount就不知道要挂载啥了。
> 由于没有对应的源设备，这里none可以是任意字符串，
> 取个有意义的名字就可以了，因为用mount命令查看挂载点信息时第一列显示的就是这个字符串。

```
sudo mount -t proc none /mnt
```

>  在内存中创建一个64M的tmpfs文件系统，并挂载到/mnt下，
> 这样所有写到/mnt目录下的文件都存储在内存中，速度非常快，
> 不过要注意，由于数据存储在内存中，所以断电后数据会丢失掉

```
sudo mount -t tmpfs -o size=64m tmpfs /mnt
```




## 挂载 loop device[^1]

在Linux中，硬盘、光盘、软盘等都是常见的块设备，他们在Linux下的目录一般是/dev/hda1, /dev/cdrom, /dev/sda1，/dev/fd0这样的。而loop device是虚拟的块设备，主要目的是让用户可以像访问上述块设备那样访问一个文件。 loop device设备的路径一般是/dev/loop0, dev/loop1, ...等，具体的个数跟内核的配置有关，Ubuntu16.04下面默认是8个，如果8个都被占用了，那么就需要修改内核参数来增加loop device的个数。

### 挂载ISO文件

```
# 利用mkisofs构建一个用于测试的iso文件
mkdir -p iso/subdir01
mkisofs -o ./test.iso ./iso

# mount ISO 到目录 /mnt
sudo mount ./test.iso /mnt
ls /mnt

# 通过losetup命令可以看到占用了loop0设备
losetup -a
```

### 虚拟硬盘

loop device另一种常用的用法是虚拟一个硬盘，比如我想尝试下btrfs这个文件系统，但系统中目前的所有分区都已经用了，里面都是有用的数据，不想格式化他们，这时虚拟硬盘就有用武之地了，示例如下

```
# 因为btrfs对分区的大小有最小要求，所以利用dd命令创建一个128M的文件
dd if=/dev/zero bs=1M count=128 of=./vdisk.img

# 格式化
mkfs.btrfs ./vdisk.img

# 挂载
sudo mount ./vdisk.img /mnt/

# 测试
sudo touch /mnt/hello
ls /mnt/

# 查看 loop device
losetup -a
```



## 挂载一个设备到多个目录


```
# 创建虚拟硬盘
dd if=/dev/zero bs=1M count=128 of=./vdisk.img
mkfs.btrfs ./vdisk.img

# 新建两目录用于挂载点
sudo mkdir /mnt/disk1 /mnt/disk2

# 将vdisk.img依次挂载到disk1和disk2
sudo mount ./vdisk.img /mnt/disk1
sudo mount ./vdisk.img /mnt/disk2

tree /mnt
```



## bind mount

### bind mout

```
# 准备要用到的目录
mkdir -p bind/bind1/sub1
mkdir -p bind/bind2/sub2
tree bind

bind
├── bind1
│   └── sub1
└── bind2
    └── sub2
    
# bind mount后，bind2里面显示的就是bind1目录的内容
sudo mount --bind ./bind/bind1/ ./bind/bind2
tree bind

bind
├── bind1
│   └── sub1
└── bind2
    └── sub1
```

### readonly bind

```
# 通过readonly的方式bind mount
sudo mount -o bind,ro ./bind/bind1/ ./bind/bind2
tree bind
    
# bind2 为 ro,没法 touch
touch ./bind/bind2/sub1/hello
    
# bind1 可以 touch
touch ./bind/bind1/sub1/hello
```

如果我们想让当前目录readonly，那么可以bind自己，并且指定readonly参数：

```
# mount
sudo mount -o bind,ro ./bind/bind1/ ./bind/bind1

# touch failed
touch ./bind/bind1/sub1/hello

# umount
sudo umount ./bind/bind1/

# touch success
touch ./bind/bind1/sub1/hello
```

### bind mount单个文件

我们也可以bind mount单个文件，这个功能尤其适合需要在不同版本配置文件之间切换的时候

```
# 创建两个用于测试的文件
echo aaa > bind/aa
echo bbb > bind/bb

# bind mount后，bb里面看到的是aa的内容
sudo mount --bind ./bind/aa bind/bb
cat bind/bb

# 即使我们删除aa文件，我们还是能够通过bb看到aa里面的内容
rm bind/aa
cat bind/bb

# umount bb文件后，bb的内容出现了，不过aa的内容再也找不到了
sudo umount bind/bb
cat bind/bb
```

### move一个挂载点到另一个地方

```
# bind mount
sudo mount --bind ./bind/bind1/ ./bind/bind2/
ls ./bind/bind*

#move操作要求mount point的父mount point不能为shared。
#在这里./bind/bind2/的父mount point为'/'，所以需要将'/'变成private后才能做move操作
#关于shared、private的含义将会在下一篇介绍
findmnt -o TARGET,PROPAGATION /
sudo mount --make-private /
findmnt -o TARGET,PROPAGATION /

# move成功，在mnt下能看到bind1里面的内容
sudo mount --move ./bind/bind2/ /mnt

# 由于bind2上的挂载点已经被移动到了/mnt上，于是能看到bind2目录下原来的文件了
ls ./bind/bind2/
```



## Shared subtrees[^2]

### 环境准备

```
# 准备4个虚拟的disk，并在上面创建ext2文件系统，用于后续的mount测试
mkdir disks && cd disks
dd if=/dev/zero bs=1M count=32 of=./disk1.img
dd if=/dev/zero bs=1M count=32 of=./disk2.img
dd if=/dev/zero bs=1M count=32 of=./disk3.img
dd if=/dev/zero bs=1M count=32 of=./disk4.img
mkfs.ext2 ./disk1.img
mkfs.ext2 ./disk2.img
mkfs.ext2 ./disk3.img
mkfs.ext2 ./disk4.img

# 准备两个目录用于挂载上面创建的disk
mkdir disk1 disk2

#确保根目录的propagation type是shared
sudo mount --make-shared /
```

### 查看propagation type和peer group

```
# 显式的以shared方式挂载disk1
sudo mount --make-shared ./disk1.img ./disk1
# 显式的以private方式挂载disk2
sudo mount --make-private ./disk2.img ./disk2

# mountinfo比mounts文件包含有更多的关于挂载点的信息
# 这里sed主要用来过滤掉跟当前主题无关的信息
# shared:105表示挂载点/home/$USER/disks/disk1是以shared方式挂载，且peer group id为105
# 而挂载点/home/$USER/disks/disk2没有相关信息，表示是以private方式挂载
cat /proc/self/mountinfo | grep disk | sed 's/ - .*//'

# 分别在disk1和disk2目录下创建目录disk3和disk4，然后挂载disk3，disk4到这两个目录
sudo mkdir ./disk1/disk3 ./disk2/disk4
sudo mount ./disk3.img ./disk1/disk3
sudo mount ./disk4.img ./disk2/disk4

# disk1/disk3 作为 disk3 的子挂载点, disk2/disk4 作为 disk2 的子挂载点,
# 前者是 shared, 后者是 private
# 说明在默认mount的情况下，子挂载点会继承了父挂载点的propagation type
cat /proc/self/mountinfo |grep disk| sed 's/ - .*//'

```

### shared 和 private mount

```
# umount掉disk3和disk4，创建两个新的目录bind1和bind2用于bind测试
sudo umount /home/$USER/disks/disk1/disk3
sudo umount /home/$USER/disks/disk2/disk4
mkdir bind1 bind2

# bind的方式挂载disk1到bind1，disk2到bind2
sudo mount --bind ./disk1 ./bind1
sudo mount --bind ./disk2 ./bind2

# 查看挂载信息，显然默认情况下bind1和bind2的propagation type继承自父挂载点(/)，都是shared。
# 由于bind2的源挂载点disk2是private的，所以bind2没有和disk2在同一个peer group里面，
# 而是重新创建了一个新的peer group，这个group里面就只有它一个。
# 因为bind1和disk1都是shared类型且是通过bind方式mount在一起的，所以他们属于同一个peer group 105。
cat /proc/self/mountinfo | grep disk | sed 's/ - .*//'
```

### slave mount

```
# umount除disk1的所有其他挂载点
sudo umount ./disk2/disk4
sudo umount /home/$USER/disks/bind1
sudo umount /home/$USER/disks/bind2
sudo umount /home/$USER/disks/disk2

# 确认只剩disk1
cat /proc/self/mountinfo | grep disk | sed 's/ - .*//'

# 分别显式的用shared和slave的方式bind disk1
sudo mount --bind --make-shared ./disk1 ./bind1
sudo mount --bind --make-slave ./bind1 ./bind2

# 这3个都属于同一个peer group，
# master:xx 表示/home/dev/disks/bind2是peer group xxx的slave
cat /proc/self/mountinfo |grep disk| sed 's/ - .*//'

# mount disk3到disk1的子目录disk3下
sudo mount ./disk3.img ./disk1/disk3/

# 其他两个目录bind1和bind2里面也挂载成功，说明master发生变化的时候，slave会跟着变化
cat /proc/self/mountinfo |grep disk| sed 's/ - .*//'

# umount disk3，然后mount disk3到bind2目录下
sudo umount ./disk1/disk3/
sudo mount ./disk3.img ./bind2/disk3/

# 由于bind2的propagation type是slave，所以disk1和bind1两个挂载点下面不会挂载disk3
# 当父挂载点是slave类型时，默认情况下其子挂载点是private类型
cat /proc/self/mountinfo |grep disk| sed 's/ - .*//'

```





## reference

[^1]: <https://en.wikipedia.org/wiki/Loop_device>
[^2]: https://www.kernel.org/doc/Documentation/filesystems/sharedsubtree.txt