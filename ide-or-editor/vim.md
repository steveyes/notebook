# vim

目录

[TOC]

## to read

- [ ] https://blog.csdn.net/Mason_Mao/article/details/80984726 

- [ ] [https://github.com/wsdjeg/vim-galore-zh_cn/blob/master/README.md#%E6%98%A0%E5%B0%84%E5%89%8D%E7%BD%AE%E9%94%AE](https://github.com/wsdjeg/vim-galore-zh_cn/blob/master/README.md#映射前置键) 



## rc(runtime config?) files

vim启动会按照一定的顺序来搜索配置文件，可以通过 `:version` 命令查看。如下所示：

>   system vimrc file: "$VIM/vimrc"
>     user vimrc file: "$HOME/.vimrc"
> 2nd user vimrc file: "~/.vim/vimrc"
>      user exrc file: "$HOME/.exrc"
>       defaults file: "$VIMRUNTIME/defaults.vim"
>  fall-back for $VIM: "/usr/share/vim"



## 文件编码

### 分类

- locale 本地语言编码，定义了当前工作环境的默认语言编码。
- encoding 用户缓冲的文本（正在编辑的文本）、寄存器、vim脚本等，可以把encoding当做是对vim内部运行机制的设定。
- fileencoding vim写入文件时采用的编码类型。
- fileencodings vim启动时会按照它所列出字符编码方式逐一探测打开的文件的字符编码方式，并且将fileencodings设置为最终探测到的字符编码方式。
- termencoding 代表输出到客户端term采用的编码方式。

### 默认值

- encoding 要求与系统当前locale相同。
- fileencoding vim打开文件时自动辨认的编码，根据fileencodings进行辨认，如果fileencodings为空，则保存文件时采用encoding编码，如果没有设置encoding，则采用当前系统的locale。
- termencoding 默认为空，也就是输出到终端不进行编码转换。

### 工作原理

1. vim启动，根据.vimrc中设置的encoding值来设置buffer、菜单文本、消息文本的字符编码方式。
2. 读取待编辑的文件，使用fileencodings中的值逐一匹配，并设置fileencoding为匹配到的看起来是正确的的编码方式。
3. 对比fileencoding和encoding的值，如不同则调用iconv将文件内容转换为encoding的字符码，并将其放到buffer中，此时可以编辑文件了。
4. 保存文件时，再次对比fenc与enc的值，若不同则再次调用iconv将buffer中的文本转换为fenc的字符码，并保存。

### 乱码解决思路

1. 在.vimrc中手工设定encoding与locale一致。
2. cat显示正常，vim打开不正常，说明vim终端编码设置有问题，设置termencoding与终端编码一致。
3. cat显示不正常，说明文件编码有问题，`set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936`。
4. 手工设定 fileencoding
5. iconv转化文件。

### 文件编码转化

gb2312转成utf8

```
iconv -f GB2312 -t UTF-8 gb1.txt > utf8.txt
```



## 启动VIM

以只读模式启动VIM

```
vim -R $file
view $file
```

以兼容模式启动VIM

```
vim -C $file
```

以恢复模式启动VIM

```
vim -r $file
:ewcover $file
```

> 恢复到最近一次关机前的文件内容，vim通过将编辑缓冲区保存在一个交换文件(swap file)中，与正在编辑的文件在同一个目录，每当键入200个字以内后，或4秒没有键入内容时，交换文件都会自动更新，为了恢复文件，必须用rm删除交换文件。test.c的交换文件名为 .test.c.swp，如果不删除，那么下一次打开时，将以一个稍微有所不同的名称创建一个新交换文件，例如 .test.c.swo

打开文件后，光标定位至末行

```
vim + $file
```

打开文件后，光标定位到第10行

```
vim +10 $file
```

打开文件后，光标定位第一次搜索到包含hello的行

```
vim +/hello $file
```



## 模式

- Normal mode: When typing commands.
- Visual mode: When typing commands while the Visual area is highlighted.
- Operator-pending mode: When an operator is pending (after "d", "y", "c", etc.). Example: ":omap { w" makes "y{" work like "yw" and "d{" like "dw".
- Insert mode. These are also used in Replace mode.
- Command-line mode: When entering a ":" or "/" command.
- Lang-Arg: searching



### 普通模式(Normal mode)

其他模式下按 <kbd>Esc</kbd>可以进入普通模式

其他模式下按<kbd>Ctrl+[</kbd>可以进入普通模式



### 插入模式(Insert mode)

| 按键                  | 说明                                 |
| --------------------- | ------------------------------------ |
| i                     | 进入插入模式，光标定位于当前字符前面 |
| a                     | 进入插入模式，光标定位于当前字符后面 |
| I                     | 进入插入模式，光标定位于当前行首     |
| A                     | 进入插入模式，光标定位于当前行末     |
| o                     | 进入插入模式，光标定位于当前行上一行 |
| O                     | 进入插入模式，光标定位于当前行下一行 |



### 命令行模式(Command line mode)



### 可视化模式(Visual mode)

| 按键 | 说明 | comments                |
| ---- | ---- | ----------------------- |
| v    |      | enter visual mode       |
| V    |      | enter visual line mode  |
| ^v   |      | enter visual block mode |



## 常用操作

| 按键             | 说明                             |
| ---------------- | -------------------------------- |
| :set all         | 查询vim支持的全部可用选项        |
| :set             | 查询以改变默认选项的值           |
| :set tabstop?    | 查询某个选项的默认值             |
| :set list        | 显示不可见字符，<Tab> 显示为 ^I  |
| :set expandtab   | <Tab> 转变为 <Space>，字符数增加 |
| :set unexpandtab | <Space> 转变为 <Tab>，字符数减少 |
| :w ! sudo tee %  | 编辑并保存没有写权限的文件       |
| Backspace 或者 Delete | 删除一个字符                     |
| Ctrl+w               | 删除一个单词                     |
| Ctrl+v               | 插入一个控制字符，如 ^V^H，^VEsc |
| **Shift+k** | **链接到光标所在词的man文档** |



## 光标

| 按键                   | 说明                                | comments                 |
| ---------------------- | ----------------------------------- | ------------------------ |
| h, <left>, <Backspace> | 左移一位                            |                          |
| j, <down>              | 下移一位                            |                          |
| +, <Return>            | 下移一行，且定位置行首              |                          |
| k, <up>                | 上移一位                            |                          |
| -                      | 上移一位，且定位置行首              |                          |
| l, <right>, <Space>    | 右移一位                            |                          |
| 0                      | 移至行首                            | begin of line            |
| $                      | 移至行末                            | end of line              |
| ^                      | 移至行首的第一个非空格/指标的字符上 | begin(non-blank) of line |
| w                      | 移至下一个单词的词首                | next word                |
| e                      | 移至下一个单词的词尾                | end of word              |
| b                      | 移至上一个单词的词首                | prev word                |
| W                      | 同w，但忽略标点符号                 | next WORD                |
| E                      | 同e，但忽略标点符号                 | end of WORD              |
| B                      | 同b，但忽略标点符号                 | prev WORD                |
| )                      | 下移一个句子                        |                          |
| (                      | 上移一个句子                        |                          |
| ]]                     | 移至下个函数的定界位                |                          |
| [[                     | 移至上个函数的定界位                |                          |
| }                      | 下移一个段落                        | next paragraph           |
| {                      | 上一一个段落                        | prev paragraph           |
| Ctrl+g                 | 显示文件名及当前行的百分比          |                          |



## 标注 marks

### 前置键

| 按键 | 说明                       | comments |
| ---- | -------------------------- | -------- |
| m    | 标记当前行                 | mark     |
| '    | 跳转到目标字符前面或者行首 |          |
| `    | 跳转到目标字符后面或者行末 |          |

### 后置键

| 按键         | 说明                               | comments    |
| ------------ | ---------------------------------- | ----------- |
| <kbd>a</kbd> | 跳转到行a                          | jump to 'a' |
| <kbd>[</kbd> | 上一次修改或复制的第一个目标       |             |
| <kbd>]</kbd> | 上一次修改或复制的最后一个目标     |             |
| <kbd><</kbd> | 上一次可视模式下选取的第一个目标   |             |
| <kbd>></kbd> | 上一次可视模式下选取的最后一个目标 |             |
| <kbd>`</kbd> | 上一次跳转之前的目标               |             |
| <kbd>'</kbd> | 上一次跳转之前的目标               |             |
| <kbd>"</kbd> | 上一次关闭当前缓冲区时的目标       |             |
| <kbd>^</kbd> | 上一次插入字符后的目标             |             |
| <kbd>.</kbd> | 上一次修改文本后的目标             |             |
| O            | 上一次跳转前的目标                 |             |
|              |                                    |             |

### 相关命令

```
# 显示所有标注
:marks

# 帮助
:h mark-motions
```





## 视窗&翻页

| 按键        | 说明                                 | comment          |
| ----------- | ------------------------------------ | ---------------- |
| H           | 移至屏幕顶端                         | top of win       |
| M           | 移至屏幕中间                         | mid of win       |
| L           | 移至屏幕底部                         | btm of win       |
| Ctrl+f      | 视窗下翻一页                         | next page        |
| Ctrl+b      | 视窗上翻一页                         | pref page        |
| Ctrl+d      | 视窗下翻半页                         | next half page   |
| Ctrl+u      | 视窗上翻半页                         | prev half page   |
| Ctrl+e      | 视窗下翻一行                         |                  |
| Ctrl+y      | 视窗上翻一行                         |                  |
| zt          | 将当前行设为视窗的顶部位置           | scroll to top    |
| zz          | 将当前行设为视窗的中间位置           | scroll to middle |
| zb          | 将当前行设为视窗的底部位置           | scroll to bottom |
| :sp $file2  | 打开新的横向窗口来编辑 $file2        |                  |
| :vsp $file2 | 打开新的纵向窗口来编辑 $file2        |                  |
| Ctrl+w s    | 对当前窗口水平分割                   |                  |
| Ctrl+w v    | 对当前窗口垂直分割                   |                  |
| Ctrl+w q    | 结束分割出来的窗口                   |                  |
| Ctrl+w o    | 打开一个视窗，并且隐藏之前的所有视窗 |                  |
| Ctrl+w j    | 焦点移至下方的视窗                   |                  |
| Ctrl+w k    | 焦点移至上方的视窗                   |                  |
| Ctrl+w l    | 焦点移至右方的视窗                   |                  |
| Ctrl+w h    | 焦点移至左方的视窗                   |                  |
| Ctrl+w +    | 增加视窗的高度                       |                  |
| Ctrl+w -    | 减小视窗的高度                       |                  |



## 可视化

| 按键    | 说明                         |
| ------- | ---------------------------- |
| v       | 进入单个字符选择模式         |
| Shift+v | 进入行选择模式               |
| Ctrl+v  | 进入块可视化选择模式，列模式 |

> 再次按下相同的功能键则退出该模式。



## 替换&进入插入模式

| 按键 | 说明                         | 是否进入插入模式                 | comments         |
| ---- | ---------------------------- | ---------------------------- | ---------------------------- |
| ~    | 改变当前字符大小写          | 否         |          |
| guw | 整个单词变小写 | 否 |  |
| gUw | 整个单词变大写 | 否 |  |
| gU$ | 光标处至行末变大写 | 否 |  |
| r    | 替换当前字符 | 否 | replace a char |
| R       | 从当前字符开始，逐字替换 | 是 |  |
| s       | 单个字符替换为多个字符   | 是  |   |
| c | 替换 | 是 | change to ... |
| C       | 从当前字符至行末都替换   | 是  | modify to end of line |
| S 或 cc | 替换整行                 | 是                |                 |
| cw      | 替换整个单词             | 是            |             |
| c5w     | 替换5个单词              | 是             |              |
| c4b     | 替换5个单词，反向        | 是       |        |
| c5}     | 替换6个段落              | 是             |              |



## 命令行模式替换 Replace in Ex Commands 

| 按键                 | 说明                  |
| -------------------- | --------------------- |
| :10s/Unix/Linux/g    | 第10行替换Unix为Linux |
| :10,20s/Unix/Linux/g | 第10至20行            |
| :.,$s/Unix/Linux/g   | 当前行至末行          |
| :1,.s/Unix/Linux/g   | 首行至当前行          |
| :1,$s/Unix/Linux/g   | 首行至末行            |
| :%s/Unix/Linux/g     | 首行至末行            |



## 删除 Delete

| 按键 | 说明                         | comments                 |
| ---- | ---------------------------- | ---- |
| x    | 删除当前光标处字符           | delete/cut a char |
| X    | 删除当前光标左边一个字符     |      |
| d |  | delete/cut to ... |
| D |  | delete to end of line |
| 5x   | 删除5个字符                  |                   |
| d5w  | 删除5个单词                  |                   |
| d5d  | 删除5行                      |                       |
| 5dd  | 删除5行                      |                       |
| d5)  | 删除5个句子                  |                   |
| d5}  | 删除5个段落                  |                   |
| d1G  | 删除当前行至首行的所有行     |      |
| dgg  | 删除当前行至首行的所有行     |      |
| dG   | 删除当前行至末行的所有行     |      |
| :5d    | 删除第5行                  |                   |
| :5,10d | 删除5至10行                |                 |
| :1,.d  | 删除首行至当前行的所有内容 |  |
| :.,$d  | 删除当前行至末行的所有内容 |  |
| :1,$d  | 删除全文                   |                    |
| :%d    | 删除全文                   |                    |
| :g/^$/d | 删除空行 |  |



## 撤销/重做 undo/redo

| 按键   | 说明                             |
| ------ | -------------------------------- |
| u      | 撤销上一条命令对编辑缓冲区的修改 |
| U      | 恢复当前行                       |
| Ctrl+r | 重复上一命令对编辑缓冲区的修改   |
| .      | 重复上一条命令                   |



## 文本移动/复制 Text move/copy

vim总是在无名缓冲区(unamed buffer)的存储区中为上一次删除保存一份副本，类似windows的剪贴板。

| 按键          | 说明                       | comments               |
| ------------- | -------------------------- | ------------- |
| y |  | yank/copy |
| p |  | paste after cursor |
| xp            | 调换2个字符的前后位置      |       |
| deep          | 调换2个单词的前后位置      |       |
| ddp           | 调换2个行的上下位置        |         |
| yw            | 接出1个单词                |                 |
| y10w          | 接出10个单词               |                |
| yb            | 向后接出1个单词            |             |
| y5)           | 接出5个句子                |                 |
| y5}           | 接出5个段落                |                 |
| 10yy 或者 10Y | 接出10行                   |                    |
| :co      | 拷贝                           |                            |
| :m       | 移动                           |                            |
| :5co10   | 复制第5行，粘贴至第10行下面    |     |
| :4,8co20 | 复制第4至8行，粘贴至第20行下面 |  |
| :5m10    | 剪贴第5行，粘贴至第10行下面    |     |
| :4,8m20  | 剪贴第4只8行，粘贴至第20行下面 |  |
| :1,.m$   | 1至当前行，移至文末            |             |
| .,$m0    | 当前至末行，移至文首           |            |



## 格式化 Format

| 按键          | 说明     | comments        |
| ------------- | -------- | --------------- |
| J             |          | join lines      |
| <kbd>>></kbd> |          | indent          |
| <kbd><<</kbd> |          | indent leftward |
| :ce           | 文本居中 |                 |
| :ri           | 文本靠右 |                 |
| :le           | 文本靠左 |                 |



## 搜索 Search

| 按键   | 说明                       | comments                   |
| ------ | -------------------------- | -------------------------- |
| #      |                            | find current word backword |
| *      |                            | find current word forward  |
| /hello | 正向搜索                   |                            |
| ?hello | 方向搜索                   |                            |
| n      | 以原有搜索模式方向正向继续 |                            |
| N      | 以原有搜索模式方向方向继续 |                            |



## 自动补全 Auto Completion

| 按键              | 说明 | comments              |
| ----------------- | ---- | --------------------- |
| <kbd>Ctrl+n</kbd> |      | complete next keyword |
| <kbd>ctrl+p</kbd> |      | complete prev keyword |
| <kbd>ctrl+x</kbd> |      | complete file name    |
| <kbd>ctrl+f</kbd> |      | complete file name    |

| 映射                  | 类型                                            | 帮助文档            |
| --------------------- | ----------------------------------------------- | ------------------- |
| <kbd><c-x><c-l></kbd> | 整行                                            | <kbd>:h i^x^l</kbd> |
| <kbd><c-x><c-n></kbd> | 当前缓冲区中的关键字                            | <kbd>:h i^x^n</kbd> |
| <kbd><c-x><c-k></kbd> | 字典（请参阅 `:h 'dictionary'`）中的关键字      | <kbd>:h i^x^k</kbd> |
| <kbd><c-x><c-t></kbd> | 同义词字典（请参阅 `:h 'thesaurus'`）中的关键字 | <kbd>:h i^x^t</kbd> |
| <kbd><c-x><c-i></kbd> | 当前文件以及包含的文件中的关键字                | <kbd>:h i^x^i</kbd> |
| <kbd><c-x><c-]></kbd> | 标签                                            | <kbd>:h i^x^]</kbd> |
| <kbd><c-x><c-f></kbd> | 文件名                                          | <kbd>:h i^x^f</kbd> |
| <kbd><c-x><c-d></kbd> | 定义或宏定义                                    | <kbd>:h i^x^d</kbd> |
| <kbd><c-x><c-v></kbd> | Vim 命令                                        | <kbd>:h i^x^v</kbd> |
| <kbd><c-x><c-u></kbd> | 用户自定义补全（通过 `'completefunc'` 定义）    | <kbd>:h i^x^u</kbd> |
| <kbd><c-x><c-o></kbd> | Omni Completion（通过 `'omnifunc'` 定义）       | <kbd>:h i^x^o</kbd> |
| <kbd><c-x>s</kbd>     | 拼写建议                                        | <kbd>:h i^Xs</kbd>  |

### 相关命令

```
:h 'completeopt'
:h ins-completion
:h popupmenu-keys
:h new-omni-completion
```





## 与外部的交互

| 按键          | 说明                                   |
| ------------- | -------------------------------------- |
| :! date       | 调用date命令                           |
| :!!           | 重复调用上一条shell命令                |
| :!bash        | 启动一个新的子shell，父进程为vim       |
| :10r info     | 读取文件info的内容，并插入至第10行之后 |
| :0r info      | 读取文件info的内容，并插入至文首       |
| :$r info      | 读物文件info的内容，并插入至文末       |
| :r info       | 插入至当前行下面                       |
| :r ! ls       | 读取ls的输出，并插入至当前行下面       |
| :r ! look asc | 读取look asc的输出，并插入至当前行下面 |



## 缩写 Abbr

| 按键                         | 说明                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| :ab                          | 查看 abbreviation list                                       |
| :ab eg exceptionally grifted | 设定缩略词 eg，在普通模式下输入eg就表示输入exceptionally grited |
| :una eg                      | 删除缩略词 eg                                                |



## 宏 Macro

添加行注释宏

```
:map #3 I/* ^V<Esc>A */^V<Esc>
```

> - #3 <F3>键
> - ^V<Esc> 表示先按 <Ctrl>+V，再按<Esc>

移除行注释宏

```
:map #4 ^3x$2Xx
```

移除宏

```
:unmap #3
:unmap #4
```



## 差异 diff

| 按键            | 说明 | comments         |
| --------------- | ---- | ---------------- |
| vimdiff $f1 $f2 |      | diff $f1 and $f2 |
| :diff           |      | split and diff   |



## 按键映射 map

| 递归    | 非递归      | 模式                             |
| ------- | ----------- | -------------------------------- |
| `:map`  | `:noremap`  | normal, visual, operator-pending |
| `:nmap` | `:nnoremap` | normal                           |
| `:xmap` | `:xnoremap` | visual                           |
| `:cmap` | `:cnoremap` | command-line                     |
| `:omap` | `:onoremap` | operator-pending                 |
| `:imap` | `:inoremap` | insert                           |

define a key map working in normal mode

```
:nmap <space> :echo "foo"<cr>
```

undefine 

```
:nunmap <space>
```

help

```
:h map-modes
:h key-notation
:h mapping
```



### Leader

If "mapleader" is not set or empty, a backslash is used instead.  Example:
>       :map <Leader>A  oanother line<Esc>

Works like:
>        :map \A  oanother line<Esc>

But after:
>        :let g:mapleader = ","
>
>        :map <Leader>A  oanother line<Esc>

It works like:

>        :map ,A  oanother line<Esc>



## 寄存器 registers

| 类型                | 标识 | 来源                                                |      |      |
| ------------------- | ---- | --------------------------------------------------- | ---- | ---- |
| Unamed              | "    | 最近一次复制或删除操作(d,c,s,x,y)                   |      |      |
| Numbered            | 0    | 最近一次复制                                        |      |      |
| Numbered            | 1-9  | 最近第n次删除                                       |      |      |
| Small delete        | -    | 最近一次行内删除                                    |      |      |
| Named               | a-z  | 命名寄存器                                          |      |      |
| Named               | A-Z  | 命名寄存器                                          |      |      |
| Read-only           | :    | 最近一次使用的命令                                  |      |      |
| Read-only           | .    | 最近一次添加的文本                                  |      |      |
| Read-only           | %    | 当前文件名                                          |      |      |
| Alternate buffer    | #    | 当前窗口中上一次访问的缓冲区                        |      |      |
| Expression          | =    | 执行计算结果                                        |      |      |
| Selection           | +    | 剪贴板寄存器                                        |      |      |
| Selection           | *    | 剪贴板寄存器                                        |      |      |
| Drop                | ~    | 最后一次拖拽添加至Vim的文本                         |      |      |
| Black hole          | _    | 黑洞寄存器                                          |      |      |
| Last search pattern | /    | 最近一次通过 `/` `?` `:global` 等命令调用的匹配条件 |      |      |

### 相关命令

```
# 显示所有reg
:reg
```



### 修改 /

```
# 下一次案n或者p的时候就会搜索 'register'
:let @/ = 'register'
```



## 自动命令





## 插件相关命令

```
# 安装插件
echo | echo | vim +PluginInstall +qall

:PluginList       - lists configured plugins
:PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
:PluginSearch foo - searches for foo; append `!` to refresh local cache
:PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
```





## ref

https://github.com/wsdjeg/vim-galore-zh_cn

https://zhuanlan.zhihu.com/p/33046090

https://www.zhihu.com/question/47691414/answer/373700711

http://linuxcommand.org/man_pages/vimtutor1.html

http://vimcasts.org/

https://www.vim.org/docs.php

https://www.openvim.com/

https://learnvimscriptthehardway.stevelosh.com/

https://github.com/skywind3000/awesome-cheatsheets

https://hea-www.harvard.edu/~fine/Tech/vi.html