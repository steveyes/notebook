# pycharm 



## install

### for ubuntu

to install free community version

```
sudo snap install pycharm-community --classic
```

to install professional version

```
sudo snap install pycharm-professional --classic
```



## useful settings

### change encoding to `UTF-8`

Settings --> Editor --> File Encodings -->

- Global Encoding: `UTF-8`
- Project Encoding: `UTF-8`
- Properties Files
  - Default encoding for properties files: `UTF-8`

Tools --> SSH Terminal --> Default encoding: `UTF-8`

### change font 

Settings --> Editor --> Font -->

- Font: `DejaVu Sans Mono` or `JetBrains Mono`
- Size: `14`

### Configuring Line Separators

1. Settings --> Editor --> Code Style
2. From the `Line separator` list, select the desired line separator style.

### [git]warning: LF will be replaced by CRLF in

```
git config --global core.autocrlf false
```



## keymap conflicts

### navigate back / forward (for ubuntu)

`Navigate back/ forward ` conflict with `switch-to-workspace-left` and `switch-to-workspace-right`

resolving by

```
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['']"
```

### Code Completion (for windows)

Settings --> Keymap --> Main menu --> Code --> Code Completion --> Basic

1. <Double click> --> Remove...
2. <Double click> --> Add Keyboard Shortcut --> <Ctrl+\\>

### Find in Path (for ubuntu)

Setting --> Region & Language --> Input Sources --> Chinese (Intelligent Pinyin) --> gear icon button

 --> Shortcuts --> `Switch Traditional/Simplefied Chinese`



## notations of keys

| key   | default syntax | Emacs style |
| ----- | -------------- | ----------- |
| Ctrl  | ^              | C-          |
| Shift | +              | S-          |
| Alt   | !              | M-          |



## useful plugins

- Key Promoter X
- .ignore
- String Manipulation
- CamelCase
- Grep Console
- Rainbow Brackets
- AceJump
- Save Actions
- Kite AI Code AutoComplete: Python, Java, Javascript, HTML/CSS, Go, C/C#/C++





## useful shortcuts

| Action                                                       | Shortcut                                              |
| ------------------------------------------------------------ | ----------------------------------------------------- |
| Search everywhere                                            | *Double-press* Shift                                  |
| Scratch File                                                 | Ctrl+Shift+Alt+Insert                                 |
| quick fix(for function: Convert static method to function)   | Alt+Enter                                             |
| quick fix(for function: Add type hints for function)         | Alt+Enter                                             |
| quick fix(for function: Specify return type in docstring)    | Alt+Enter                                             |
| quick fix(for function: Specify return type using annotation) | Alt+Enter                                             |
| open switcher                                                | <kbd>Ctrl+Tab</kbd>    // hold on <kbd>Ctrl</kbd> key |
| Show the list of available refactoring \(Refactor This\).    | Ctrl + Shift + Alt + T                                |
| VCS Operations                                               | Alt+`                                                 |
| move...                                                      | F6                                                    |
| copy...                                                      | F5                                                    |
| Inline...                                                    | Ctrl+Alt+N                                            |
| Extract Method                                               | Ctrl+Alt+M                                            |
| Change Signature...                                          | Ctrl+F6                                               |
| Open file structure                                          | <kbd>Ctrl + F12</kbd> <kbd>Alt + 7</kbd>              |
| Go to Terminal                                               | Alt + F12                                             |
| Go to editor (from tool window)                              | Esc                                                   |
| Go back to previous tool window                              | F12                                                   |
| Hide active or last active window                            | Shift + Esc                                           |
| Find action by name                                          | Ctrl + Shift + A                                      |
| Show the list of available intention actions.                | Alt + Enter                                           |
| Switch between views \(Project,Structure, etc.\).            | Alt + F1                                              |
| Switch between the tool windows and files opened in the editor. | Ctrl + Tab                                            |
| Show the Navigation bar.                                     | Alt + Home                                            |
| Surround with..                                              | Ctrl + Alt + T                                        |
| Insert a live template                                       | Ctrl + J                                              |
| Surround with a live template                                | Ctrl + Alt + J                                        |
| Incremental expression selection                             | Ctrl + W                                              |
| Decremental expression selection                             | Ctrl + Shift + W                                      |
| Search everywhere.                                           | Double-press Shift                                    |
| Quick view the usages of the selected symbol.                | Ctrl+Shift+F7                                         |
| Expand or collapse a code fragment in the editor.            | Ctrl + NumPad Ctrl+NumPad -                           |
| Invoke code completion.                                      | Ctrl + Space                                          |
| Smart statement completion.                                  | Ctrl + Shift + Enter                                  |
| Smart completion                                             | Ctrl + Shift + Space                                  |
| move the separator line between project view and editor      | Ctrl+Shift+Left/Right                                 |
| open in a new window(project view)                           | Shift+Enter                                           |
| start a new line(editor)                                     | Shift+Enter                                           |
| type hierarchy                                               | Ctrl+h                                                |
| method hierarchy                                             | Ctrl+shift+H                                          |
| call hierarchy                                               | alt+h                                                 |

