## 安装GitBook Editor

安装后打开, 选择 -> `Do that later` 

由于没有登录，创建的图书都会离线存储在本地。

GitBook Editor创建的图书默认是在`C:\Users\用户名\gitbook`目录下，如果需要改为D盘:

选择菜单栏 -> `GitBook Editor` -> `Change Library Path`，把目录改成`D:\gitbook`：


## 在本地创建图书

点击`New Book`创建图书，填写书名，点击 -> `Confirm`，创建后图书相关的文件会存储在`D:\gitbook\Import`目录下。

注意：

_由于我在创建图书前将Library Path改成了D:\gitbook，所以我新建的图书的文件才会存储在D:\gitbook\Import目录下。而Import目录是对应GitBook Editor菜单栏的Import命令。经我测试，如果再创建一个D:\gitbook\Open目录，对应的就是GitBook Editor菜单栏的Open命令。Import和Open的区别是：_

* Import可以将从本地其它目录的图书（用gitbook init命令创建的图书目录）导入到Library Path，导入后修改的文件内容会保存在Library Path。比如：在D:\test\hello目录通过gitbook init创建了一本书，然后打开GitBook Editor Import，选择D:\test\hello，然后D:\test\hello目录的文件就会复制到D:\GitBook\Import\hello。而在GitBook Editor中修改了内容后，这些内容会保存在D:\GitBook\Import\hello目录下。

* Open就是直接打开一个gitbook init的图书。经测试，只有在Library Path下的Open目录下使用gitbook init命令创建的图书，才会正常在GitBook Editor中显示。

## 关联GitHub

在GitBook打开新创建的图书，点击 -> `Add an article`，创建一篇文章。


右上角有两个按钮：`Save`和`Publish`。

当点击`Save`的时候，GitBook Editor会把编辑的内容保存在`Library Path`。

而当点击`Publish`的时候，就会把编辑的内容保存到`Git`仓库。

git仓库的地址只能是`https`协议，而不能是`git`协议，图书名最好也一直。


