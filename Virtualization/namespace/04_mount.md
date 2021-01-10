# mount namespaces 

Mount namespace用来隔离文件系统的挂载点, 使得不同的mount namespace拥有自己独立的挂载点信息，不同的namespace之间不会相互影响，这对于构建用户或者容器自己的文件系统目录非常有用。

当前进程所在mount namespace里的所有挂载信息可以在

- /proc/[pid]/mounts

- /proc/[pid]/mountinfo

- /proc/[pid]/mountstats

  里面找到。

Mount namespaces是第一个被加入Linux的namespace，由于当时没想到还会引入其它的namespace，所以取名为CLONE_NEWNS，而没有叫CLONE_NEWMOUNT。

每个mount namespace都拥有一份自己的挂载点列表，当用clone或者unshare函数创建新的mount namespace时，新创建的namespace将拷贝一份老namespace里的挂载点列表，但从这之后，他们就没有关系了，通过mount和umount增加和删除各自namespace里面的挂载点都不会相互影响。



## example: by bash

in shell window #1

```
# 先准备两个iso文件，用于后面的mount测试
mkdir iso
cd iso/
mkdir -p iso01/subdir01
mkdir -p iso02/subdir02
mkisofs -o ./001.iso ./iso01
mkisofs -o ./002.iso ./iso02

# 准备目录用于mount
sudo mkdir /mnt/iso1 /mnt/iso2

# 查看当前所在的mount namespace
readlink /proc/$$/ns/mnt

# mount 001.iso 到 /mnt/iso1/
sudo mount ./001.iso /mnt/iso1/

# mount 成功
mount |grep /001.iso

# 创建并进入新的mount和uts namespace
sudo unshare --mount --uts /bin/bash

# 查看新的mount namespace
readlink /proc/$$/ns/mnt


```

