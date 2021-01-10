# vscode

## install on ubuntu 

```bash
sudo snap install --classic code
```



## settings.json

### open settings

<kbd>Ctrl+,</kbd>

### Scope : User

<kbd>Ctrl+p</kbd> --> "settings.json" --> `~/.config/Code/User`

### Scope : Workspace

<kbd>Ctrl+p</kbd> --> "settings.json" --> `.vscode`



## initiate settings

### encoding

open settings(<kbd>Ctrl+,</kbd>) --> search `encode` --> 

### eol

open settings(<kbd>Ctrl+,</kbd>) --> search `eol`  --> Files: Eol The default end of line character. to `\n`



## User Guide

### quick suggestions

```
    // Controls if quick suggestions should show up while typing
    "editor.quickSuggestions": {
        "other": true,
        "comments": false,
        "strings": false
    },
    "editor.quickSuggestionsDelay": 3,
```

https://code.visualstudio.com/docs/editor/intellisense



## Plugins

### Code Runner

> Settings --> User Settings --> Extensions --> Run Code configu... --> Executor Map --> Edit in settings.json --> 

```json
{
    "code-runner.runInTerminal": true,
    "code-runner.executorMap": {
    },
}
```

### Colonize

> - shift + enter Insert semicolon at the end of line and continue on the same line
> - alt + enter Insert semicolon at the end of line and continue on the new line
> - ctrl + alt + enter Insert semicolon and stay at the same position

### tabout

### C/C++ formating

```
"C_Cpp.clang_format_fallbackStyle": "{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 0}"
```

### Bracket Pair Colorizer

### jumpy

### Path Intellisense

### Shopify Liquid Template Snippets 

### Liquid

### html snippet

### stylelint

### vetur

### Auto Close Tag





## 主命令框

F1 或 `Ctrl+Shift+P` : 打开命令面板。在打开的输入框内，可以输入任何命令，例如：

* 按一下 Backspace 会进入到`Ctrl+P`模式
* 在`Ctrl+P`下输入`>`可以进入`Ctrl+Shift+P`模式

在`Ctrl+P`窗口下还可以:

* 直接输入文件名，跳转到文件
* ? 列出当前可执行的动作
* ! 显示 Errors或 Warnings，也可以`Ctrl+Shift+M`
* : 跳转到行数，也可以`Ctrl+G`
  直接进入
* @ 跳转到 symbol（搜索变量或者函数），也可以`Ctrl+Shift+O`直接进入
* @ 根据分类跳转 symbol，查找属性或函数，也可以`Ctrl+Shift+O`后输入:进入
* \# 根据名字查找 symbol，也可以`Ctrl+T`