# tmux && screen



## 控制台列表

| 虚拟控制台 | 快捷键      | 虚拟终端类型 |
| ---------- | ----------- | ------------ |
| #1         | ctrl+alt+F1 | 全屏cli      |
| #2         | ctrl+alt+F2 | 全屏cli      |
| #3         | ctrl+alt+F3 | 全屏cli      |
| #4         | ctrl+alt+F4 | 全屏cli      |
| #5         | ctrl+alt+F5 | 全屏cli      |
| #6         | ctrl+alt+F6 | 全屏cli      |
| #7         | ctrl+alt+F7 | 全屏gui      |

> #7 切换到其他控制台，ctrl不能省，其他情况可以省略ctrl。



## tty/pts		

列出所有在线的tty/pts

```
who
w
```

列出一个指定的tty/pts

```
ps -ft pts/0
```

发送消息到指定的tty

```
echo "true" > /dev/pts/0
```

终结一个tty/pts会话

```
pkill -9 -t pts/0
```



## screen

新建一个 session

```
screen -S <session_name>
```

**将当前session放到后台**

Ctrl + A --> D 

新建一个session，运行一个命令，并放到后台

```
screen -dmS <session_name> bash -c '<command>'
```

查看所有的session

```
screen -ls
screen -list
```

唤起一个session

```
screen -r <session_name>

# 踢掉前一用户，再登陆
screen -D -r <session_name>
```

终止一个session(在session里面)

Ctrl + d

查看一个screen里得输出

Ctrl + a --> ESC

滚动窗口

Ctrl>+ a + [



## tmux

- Session contains one or more Windows

- Windows contains one or more Pane

默认前缀{prefix}： <kbd>ctrl</kbd> + <kbd>a</kbd>

会话管理

```
# 创建默认名称的会话
tmux 

# 创建指定名称的会话(session名为1)
tmux new-session -s 1
tmux new -s 1

# 显示会话列表
tmux ls

# 连接上一个会话
tmux a

# 连接指定会话
tmux a -t <session_name>

# 重命名会话 <s1> 为 <s2>
tmux rename -t <s1> <s2>

# 关闭上次打开的会话
tmux kill-session

# 关闭指定会话
tmux kill-session -t <s1>

# 关闭除指定会话外的其他所有会话
tmux kill-session -a -t <s1>

# 关闭所有会话
tmux kill-server
```

会话管理

| 按键 | 功能                   |
| ---- | ---------------------- |
| s    | 列出所有会话，选择会话 |
| $    | 重命名会话             |
| d    | 分离当前会话           |
| D    | 分离指定会话           |
| (    | 进入前一个会话         |
| )    | 进入后一个会话         |

窗口管理

| 按键 | 功能                            |
| ---- | ------------------------------- |
| c    | 创建一个新窗口                  |
| ,    | 重命名当前窗口                  |
| w    | 列出所有窗口，选择窗口          |
| n    | 进入下一个窗口                  |
| p    | 进入上一个窗口                  |
| l    | 进入之前操作的窗口              |
| 0~9  | 选择对应编号为0~9的窗口         |
| .    | 修改当前窗口的编号              |
| '    | 切换至指定编号（可大于9）的窗口 |
| f    | 根据显示的内容搜索窗格          |
| &    | 关闭当前窗口                    |

窗格管理

| 按键                          | 功能                                |
| ----------------------------- | ----------------------------------- |
| [                             | 进入复制模式                        |
| ]                             | 黏贴位于tmux剪贴板中的内容          |
| %                             | 水平方向创建窗格                    |
| "                             | 垂直方向创建窗格                    |
| <Up>\|<Down>\|<Left>\|<Right> | 根据方向键切换窗格                  |
| q                             | 显示窗格编号                        |
| o                             | 顺时针切换窗格                      |
| }                             | 与下一个窗格交换位置                |
| {                             | 与上一个窗格交换位置                |
| x                             | 关闭当前窗格                        |
| space                         | 重新排列当前窗口下的所有窗格        |
| !                             | 将当前窗格至于新窗口                |
| Ctrl + o                      | 逆时针旋转当前窗口的窗格            |
| t                             | 在当前窗口显示时间                  |
| z                             | 放大当前窗口                        |
| i                             | 显示当前窗口信息                    |
| setw synchronize-panes on     | send a command to all panes in tmux |



其他

```
# 重新加载配置文件
# press `{prefix}+:`
source-file ~/.tmux.conf

# 列出所有绑定的键，等同于 ?
tmux list-key

# 列出所有命令
tmux list-command

# 解决配置文件始终无法生效
tmux kill-server -a

# 查看所有 vi-copy 模式下绑定的key
tmux list-keys -t vi-copy
```

config

```
cat > ~/.tmux.conf << EOF
# this syntax is applicable to tmux 2

# choose session
bind S choose-tree

# choose window
bind W choose-window

# terminal color
set -g default-terminal "screen-256color"

# select session from session list
bind S choose-tree

# change default prefix from ^b to ^a
unbind C-b
unbind C-a
bind C-s send-prefix

# set key-map style
set -g mode-keys emacs
set -g status-keys emacs

# start numbering from 0 instead of 1
set -g base-index 1
setw -g pane-base-index 1

# get rid of delay reading command characters while tmux waits for escape sequence
set -s escape-time 1

# reload ~/.tmux.conf using prefix r
bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"

# change vertically split windows, and locate to current path
unbind '"'
bind v split-window -v -c '#{pane_current_path}'

# change horizontally split window, and locate to current path
unbind '%'
unbind 's'
bind s split-window -h -c '#{pane_current_path}'

# set scroolback history to 10K lines
set -g history-limit 10000

# mouse support
set -g mouse on
# https://github.com/tmux/tmux/issues/145#issuecomment-151098708
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e; send-keys -M'"

# vi
# ===
setw -g mode-keys vi
set -g status-keys vi

# set 'v' to begin selection as in vim, y to copy-line
bind-key -t vi-copy v begin-selection
# bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"
# package xsel or xclip should be installed: 
# sudo apt install xsel # or xclip
# Copy from a remote server with xclip: ssh -X remoteuser@remotehost
# bind -t vi-copy y copy-pipe "xclip -in -selection clipboard"
bind-key -t vi-copy y copy-pipe "xclip -sel clip -i"

#tmux2.4 and above
#bind-key -T copy-mode-vi v send-keys -X begin-selection
#bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -sel clip -i'
#bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

# how to copy & paste
# 1. use key "<prefix> + [" to change into Selection mode
# 2. use <space> or v to select
# 3. use <Enter> or y to copy
# 4. use key "<prefix>" or "<Esc>" to exit Selection mode
# 5. use key "<prefix> + ]" to paste

# map vi movement keys as pane movement keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# use alt + arrow keys to switch between panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# use vi left and right to cycle thru panes
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# resize panes using vi keys
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# use shift + arrow keys to switch between windows
bind -n S-Left previous-window
bind -n S-Right next-window

# status bar
# ==========

# set status bar
#set -g status-justify centre
set -g status-justify left
#set -g status-left ""
#set -g status-right "#[fg=green]#H"

# dark theme
#set -g status-bg "#101010"
#set -g status-fg "#005000"

# light theme
#set -g status-bg "#222222"
set -g status-bg "#303030"
set -g status-fg "#009000"

# Highlight active window
setw -g window-status-current-fg black
setw -g window-status-current-bg green

EOF
```