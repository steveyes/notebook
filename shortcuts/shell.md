# shell shortcuts



|                                                              |                                               |
| :----------------------------------------------------------- | --------------------------------------------- |
| launch a editor                                              | Ctrl+X <and> Ctrl+E                           |
| clears the screen                                            | Ctrl+L                                        |
| pause all command output to the screen.                      | Ctrl+S                                        |
| resume output to the screen after pausing it with Ctrl+S     | Ctrl+Q                                        |
| go to the beginning of the line                              | Ctrl+Z <or> Home                              |
| go to the end of the line                                    | Ctrl+E <or> End                               |
| toggle  between the end of the line and current cursor position | Ctrl+XX                                       |
| backward one character                                       | Ctrl+B <or> LeftArrow                         |
| forward one character                                        | Ctrl+F <or> RightArrow                        |
| back (left) one word                                         | Ctrl+LeftArrow <or> Alt+B <or> Esc and then B |
| forward (right) one word                                     | Ctrl+RightArrow <or> Alt+F<or> Esc and then F |
| retrieves the previous command.                              | Up arrow key                                  |
| previous command                                             | Ctrl+P <or> UpArrow                           |
| next command                                                 | Ctrl+N <or> DownArrow                         |
| delete the character under the cursor                        | Ctrl+D <or> Delete                            |
| delete the character before the cursor                       | Ctrl+H <or> Backspace                         |
| delete one word before the cursor                            | Ctrl+Backspace <or> Alt+Del                   |
| delete one word after the cursor                             | Alt+D                                         |
| cut the word before the cursor                               | Ctrl+W                                        |
| cut the part of the line after the cursor                    | Ctrl+K                                        |
| cut the part of the line before the cursor                   | Ctrl+U <or> Ctrl+X and the Backspace          |
| paste the last thing you cut from                            | Ctrl+Y                                        |
| swap the last two characters before the cursor (Typo)        | Ctrl+T                                        |
| swap current word with previous                              | Alt+T < or >Esc and then T                    |
| transforms the text from the cursor to the end of the word to uppercase | Alt+U <or> Esc and then U                     |
| lower the case of text from the cursor to the end of the current word | Alt+L <or> Esc and then L                     |
| capitalize the character under the cursor, your cursor will move the end of the word | Alt+C <or> Esc and then C                     |
| undo your last key press, repeat this to undo multiple times (undo) | Ctrl+Shift+_                                  |
| cancel the changes and put back the line as it was in the history (revert) | Alt+R                                         |
| suspend the current foreground process. This sends the **SIGTSTP** signal to the process. You can get the process back to the foreground later using the **fg** process_name (or %bgprocess_numer like %1, %2 and so on) command. | Ctrl+Z                                        |
| interrupt the current foreground process, by sending the **SIGINT** signal to it. The default behavior is to terminate a process gracefully, but the process can either honor or ignore it. | Ctrl+C                                        |
| exit the bash shell, by sending an EOF marker to the bash (same as running the **exit** command) | Ctrl+D                                        |
| repeat last command                                          | !!                                            |
| execute the last command that starts with 'echo'             | !echo                                         |
| print last command starting with 'echo' and append it into the command history | !echo:p                                       |
| display all arguments of the last command and append it into the command history | !*:p                                          |
| first argument of the previous command                       | !^ <or> !:1                                   |
| last argument of the previous command                        | !$ <or> !:$ <or> $_                           |
| last argument of the previous command                        | Alt+.                                         |
| all arguments of the previous command                        | !*                                            |
| args that from {n}th to {m}th                                | !:n-m                                         |
| quote the last command with proper Bash escaping applied     | !:q                                           |
| substituted the first occurrence of the keyword of the last command from **python** to **python3** | ^python^python3                               |
| substituted the first occurrence of the keyword of the last command from **python** to **python3** | !!:s/python/python3/                          |
| zoom out                                                     | Ctrl+_                                        |
| zoom in                                                      | Ctrl+Shift++                                  |
| recall the last command matching the characters your provide. | Ctrl+R                                        |
| run a command you found with Ctrl+R                          | Ctrl+O                                        |
| escape from history searching mode                           | Ctrl+G                                        |
| equivalent to Tab                                            | Ctrl+I                                        |
| equivalent to Newline                                        | Ctrl+J                                        |
| equivalent to Enter                                          | Ctrl+M                                        |
| equivalent to ESC                                            | Ctrl+[                                        |
| tells the terminal to not interpret the following character  | Ctrl+V                                        |
| set Vi mode in bash                                          | set -o vi                                     |
| set emacs mode in bash                                       | set -o emacs                                  |

