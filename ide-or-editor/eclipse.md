

# Eclipse Notebook



## Complete Current Statement

### 安装插件

<kbd>Help</kbd> --> <kbd>Install New Software..</kbd> --> 

<kbd>add...</kbd> --> 

​	name = completeline-updatesite

​	Location = https://github.com/henri5/completeline-updatesite/raw/master/

`Work With` --> --All Available Sites-- -->

选中 `CompleteLine` -->

<kbd>Next ></kbd> --> <kbd>Finish</kbd> --> 

<Waiting Installing Software> -->

<kbd>Restart Now</kbd>



### 设置快捷键

<kbd>Windows</kbd> --> <kbd>Preferences</kbd> --> <kbd>General</kbd> --> <kbd>keys</kbd> --> 

`Complete line` --> `Binding` = <kbd>Ctrl + Shift + Enter</kbd> -->

<kbd>Apply and Close></kbd> -->

<restart eclipse>

下载并安装完以后，重启 Eclipse， 使用 <kbd>Ctrl + Shift + Enter</kbd>，完成本行语句。



## Content Assist Auto Activation

### 打开增强自动补全

<kbd>Windows</kbd> --> <kbd>Preferences</kbd> --> <kbd>Java</kbd> --> <kbd>Editor</kbd> --> 

<kbd>Content Assist</kbd> -->

`Auto activation triggers for java` = .abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ

<kbd>Apply and Close</kbd> 



### 修改自动补全

A patch for [Bug 348857](https://bugs.eclipse.org/bugs/show_bug.cgi?id=348857) was recently merged to the Eclipse project and was released as part of **Eclipse 2018-12**. You can download that version [here](https://www.eclipse.org/downloads/packages/release/2018-12/r).

You now have a new option to disable all insertion triggers apart from enter, which will prevent spacebar from causing autocompletion.

<kbd>Windows</kbd> --> 

<kbd>Preferences</kbd> --> 

<kbd>Java</kbd> --> 

<kbd>Editor</kbd> --> 

<kbd>Content Assist</kbd> -->

选中 `Disable insertion triggers except 'Enter'` -->

<kbd>Apply and Close</kbd>



## The jar file rt.jar has no source attachment

<kbd>Windows</kbd> --> <kbd>Preferences</kbd> --> <kbd>Java</kbd> --> <kbd>Installed JREs</kbd> -->  <kbd>Edit...</kbd> -->

选中 `*rt.jar` --> <kbd>Source Attachment</kbd> --> 选中 `External locathon` --> 

`path` = `{root path of jdk}/src.zip` --> <kbd>OK</kbd>



## Very Useful shortcuts

|                                      |                                                              |
| ------------------------------------ | ------------------------------------------------------------ |
| <kbd>^F</kbd>                        | format                                                       |
| Alt + Shift + Arrow + Up             | Expand selection to current element (e.g. current one-line expression or content within brackets) |
| Alt + Shift + Arrow Left/Arrow Right | Expand selection to next / previous element                  |
| Alt + Shift + Arrow Down             | Reduce previously expanded selection by one step             |
| Alt + Shift + S                      | Menu --> Source                                              |
| Alt + Shift + T                      | Menu --> Refactor                                            |



## plugins

### EduTools 

> With the EduTools plugin, you can learn and teach programming languages such as Kotlin, Java, and Python in the form of coding tasks and custom verification tests right inside of JetBrains IntelliJ Platform based IDEs.



## short cut

### Manage Files and Projects

|               |                                                            |
| ------------- | ---------------------------------------------------------- |
| Ctrl+N        | Create new project using the Wizard                        |
| Ctrl+Alt+N    | Create new project, file, class, etc.                      |
| Alt+F, then . | Open project, file, etc.                                   |
| Ctrl+Shift+R  | Open Resource (file, folder or project)                    |
| Alt+Enter     | Show and access file properties                            |
| Ctrl+S        | Save current file                                          |
| Ctrl+Shift+S  | Save all files                                             |
| Ctrl+W        | Close current file                                         |
| Ctrl+Shift+W  | Close all files                                            |
| F5            | Refresh content of selected element with local file system |

### Editor Window

|                                |                                                              |
| ------------------------------ | ------------------------------------------------------------ |
| F12                            | Jump to Editor Window                                        |
| Ctrl+Page Down/Ctrl+Page Up    | Switch to next editor / switch to previous editor            |
| Ctrl+M                         | Maximize or un-maximize current Editor Window (also works for other Windows) |
| Ctrl+E                         | Show list of open Editors. Use arrow keys and enter to switch |
| Ctrl+F6/Ctrl+Shift+F6          | Show list of open Editors. Similar to ctrl+e but switches immediately upon release of ctrl |
| Alt+Arrow Left/Alt+Arrow Right | Go to previous / go to next Editor Window                    |
| Alt+-                          | Open Editor Window Option menu                               |
| Ctrl+F10                       | Show view menu (features available on left vertical bar: breakpoints, bookmarks, line numbers, …) |
| Ctrl+F10, then n               | Show or hide line numbers                                    |
| Ctrl+Shift+Q                   | Show or hide the diff column on the left (indicates changes since last save) |
| Ctrl+Shift++/-                 | Zoom text in/ out                                            |

### Navigate in Editor

|                                       |                                                              |
| ------------------------------------- | ------------------------------------------------------------ |
| Home/End                              | Jump to beginning / jump to end of indention. Press home twice to jump to beginning of line |
| Ctrl+Home/End                         | Jump to beginning / jump to end of source                    |
| Ctrl+Arrow Right/Arrow Left           | Jump one word to the left / one word to the right            |
| Ctrl+Shift+Arrow Down/Arrow Up        | Jump to previous / jump to next method                       |
| **Ctrl+L**                            | **Jump to Line Number. To hide/show line numbers, press ctrl+F10 and select 'Show Line Numbers'** |
| Ctrl+Q                                | Jump to last location edited                                 |
| Ctrl+./Ctrl+,                         | Jump to next / jump to previous compiler syntax warning or error |
| Ctrl+Shift+P                          | With a bracket selected: jump to the matching closing or opening bracket |
| Ctrl+[+]/Ctrl+-   on numeric keyboard | Collapse / Expand current method or class                    |
| Ctrl+[/]/Ctrl+*   on numeric keyboard | Collapse / Expand all methods or classes                     |
| Ctrl+Arrow Down/Ctrl+Arrow Up         | Scroll Editor without changing cursor position               |
| Alt+Page Up/Alt+Page Down             | Next Sub-Tab / Previous Sub-Tab                              |

### Select Text

|                                   |                                                              |
| --------------------------------- | ------------------------------------------------------------ |
| Shift+Arrow Right/Arrow Left      | Expand selection by one character to the left / to the right |
| Ctrl+Shift+Arrow Right/Arrow Left | Expand selection to next / previous word                     |
| Shift+Arrow Down/Arrow Up         | Expand selection by one line down / one line up              |
| Shift+End/Home                    | Expand selection to end / to beginning of line               |
| Ctrl+A                            | Select all                                                   |
| Alt+Shift+Arrow Up                | Expand selection to current element (e.g. current one-line expression or content within brackets) |
| Alt+Shift+Arrow Left/Arrow Right  | Expand selection to next / previous element                  |
| Alt+Shift+Arrow Down              | Reduce previously expanded selection by one step             |

### Edit Text

|                                            |                                                    |
| ------------------------------------------ | -------------------------------------------------- |
| Ctrl+C/Ctrl+X/Ctrl+V                       | Cut, copy and paste                                |
| Ctrl+Z                                     | Undo last action                                   |
| Ctrl+Y                                     | Redo last (undone) action                          |
| **Ctrl+D**                                 | **Delete Line**                                    |
| **Alt+Arrow Up/Arrow Down**                | **Move current line or selection up or down**      |
| **Ctrl+Alt+Arrow Up/Ctrl+Alt+Arrow Down/** | **Duplicate current line or selection up or down** |
| Ctrl+Delete                                | Delete next word                                   |
| Ctrl+Backspace                             | Delete previous word                               |
| Shift+Enter                                | Enter line below current line                      |
| Shift+Ctrl+Enter                           | Enter line above current line                      |
| Insert                                     | Switch between insert and overwrite mode           |
| **Shift+Ctrl+Y**                           | **Change selection to all lower case**             |
| **Shift+Ctrl+X**                           | **Change selection to all upper case**             |

### Search and Replace

|                     |                                                              |
| ------------------- | ------------------------------------------------------------ |
| Ctrl+F              | Open find and replace dialog                                 |
| Ctrl+K/Ctrl+Shift+K | Find previous / find next occurrence of search term (close find window first) |
| Ctrl+H              | Search Workspace (Java Search, Task Search, and File Search) |
| Ctrl+J/Ctrl+Shift+J | Incremental search forward / backwards. Type search term after pressing ctrl+j, there is now search window |
| Ctrl+Shift+O        | Open a resource search dialog to find any class              |

### Indentions and Comments

|                  |                                                        |
| ---------------- | ------------------------------------------------------ |
| Tab/Shift+Tab    | Increase / decrease indent of selected text            |
| Ctrl+I           | Correct indention of selected text or of current line  |
| **Ctrl+Shift+F** | **Autoformat all code in Editor using code formatter** |
| Ctrl+/           | Comment / uncomment line or selection ( adds '//' )    |
| Ctrl+Shift+/     | Add Block Comment around selection ( adds '/... */' )  |
| Ctrl+Shift+\     | Remove Block Comment                                   |
| Alt+Shift+J      | Add Element Comment ( adds '/** ... */')               |

### Editing Source Code

|                       |                                                              |
| --------------------- | ------------------------------------------------------------ |
| Ctrl+Space            | Opens Content Assist (e.g. show available methods or field names) |
| **Ctrl+1**            | **Open Quick Fix and Quick Assist**                          |
| Alt+/                 | Propose word completion (after typing at least one letter). Repeatedly press alt+/ until reaching correct name |
| **Ctrl+Shift+Insert** | **Deactivate or activate Smart Insert Mode (automatic indention, automatic brackets, etc.)** |

### Code Information

|                       |                                                              |
| --------------------- | ------------------------------------------------------------ |
| **Ctrl+O**            | **Show code outline / structure**                            |
| **F2**                | **Open class, method, or variable information (tooltip text)** |
| **F3**                | **Open Declaration: Jump to Declaration of selected class, method, or parameter** |
| **F4**                | **Open Type Hierarchy window for selected item**             |
| **Ctrl+T**            | **Show / open Quick Type Hierarchy for selected item**       |
| **Ctrl+Shift+T**      | **Open Type in Hierarchy**                                   |
| **Ctrl+Alt+H**        | **Open Call Hierarchy**                                      |
| Ctrl+Shift+U          | Find occurrences of expression in current file               |
| Ctrl+move over method | Open Declaration or Implementation                           |

### Refactoring

|                 |                                                              |
| --------------- | ------------------------------------------------------------ |
| **Alt+Shift+R** | **Rename selected element and all references**               |
| Alt+Shift+V     | Move selected element to other class or file (With complete method or class selected) |
| Alt+Shift+C     | Change method signature (with method name selected)          |
| Alt+Shift+M     | Extract selection to method                                  |
| Alt+Shift+L     | Extract local variable: Create and assigns a variable from a selected expression |
| Alt+Shift+I     | Inline selected local variables, methods,  or constants if possible (replaces variable with its declarations/  assignment and puts it directly into the statements) |

### Source

|                 |                                                              |
| --------------- | ------------------------------------------------------------ |
| **Alt+Shift+S** | **Source**                                                   |
| Alt+Shift+S, v  | Override/Implement Methods                                   |
| Alt+Shift+S, r  | Select getters and setters to create                         |
| Alt+Shift+S, h  | Select the fields to include in the hashCode() and equals() methods |
| Alt+Shift+S, s  | Select fields and methods to include in the toString() method |
| Alt+Shift+S, o  | Select super constructor to invoke                           |
| Alt+Shift+S, C  | Select constructors to implement                             |

### Run and Debug

|              |                                       |
| ------------ | ------------------------------------- |
| **Ctrl+F11** | **Save and launch application (run)** |
| F11          | Debug                                 |
| F5           | Step Into function                    |
| F6           | Next step (line by line)              |
| F7           | Step out                              |
| F8           | Skip to next Breakpoint               |

### The Rest

|                       |                                                              |
| --------------------- | ------------------------------------------------------------ |
| Ctrl+F7/Ctrl+Shift+F7 | Switch forward / backward between views (panels). Useful for switching back and forth between Package Explorer and Editor. |
| Ctrl+F8/Ctrl+Shift+F8 | Switch forward / backward between perspectives               |
| Ctrl+P                | Print                                                        |
| F1                    | Open Eclipse Help                                            |
| Shift+F10             | Show Context Menu right click with mouse                     |

### Team (SVN Subversive)

|            |                             |
| ---------- | --------------------------- |
| Ctrl+Alt+S | Synchronize with Repository |
| Ctrl+Alt+C | Commit                      |
| Ctrl+Alt+U | Update                      |
| Ctrl+Alt+D | Update to Revision          |
| Ctrl+Alt+E | Merge                       |
| Ctrl+Alt+T | Show Properties             |
| Ctrl+Alt+I | Add to svn:ignore           |