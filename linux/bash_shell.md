



## Special Characters and Operators

> ref: https://www.tldp.org/LDP/abs/html/special-chars.html

| Character                                                    | Meaning                                                      | example                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| #                                                            | comment                                                      | echo "this is line" # this is comment                        |
| ;                                                            | command separator, split one physical line into logical line | echo "logical line 1"; echo "logical line 2" # although both in one physical line |
| ;;                                                           | terminator in a `case` option                                |                                                              |
| .                                                            | **dot**[period] equivalent to `source`                       | .  ~/.bashrc                                                 |
|                                                              |                                                              |                                                              |
| "                                                            | **partial quoting** [double quote] which preserves (from interpretation) most of the special characters within **STRING** |                                                              |
| '                                                            | **full quoting** [single quote] which preserves all special characters within **STRING** |                                                              |
| ,                                                            | comma operator links together a series of arithmetic operations, all are evaluated, but only the last one is returned | let "t2 = ((a = 9, 15 / 3))"                                 |
| ,                                                            | lowercase conversion in parameter substitution (added in version 4 of Bash) | var="BASH"; echo ${var,}; echo ${var,,}                      |
| \                                                            | **escape** [backslash], a quoting mechanism for single characters |                                                              |
| /                                                            | **filename path separator** [forward slash]                  |                                                              |
| `                 | command substitution                                         | echo \`ls\` |                                                              |                                                              |
| :                                                            | null command                                                 | :; echo $?                                                   |
| !                                                            | reverse (or negate) the sense of a test or exit status [bang]. applied to `exit status` or `operator` |                                                              |
| *                                                            | wild card                                                    | echo *                                                       |
| ?                                                            | test operator, within certain expressions, indicates a test for a condition | a=100; b=1; echo $(( max = a > b ? a : b ))                  |
| ?                                                            | wild card which serves as a single-character, applied in globbing or regex |                                                              |
| $                                                            | variable substitution                                        |                                                              |
| $                                                            | end-of-line in a regex                                       |                                                              |
| ${}                                                          | parameter substitution                                       |                                                              |
| $'...'                                                       | quoted string expansion which expands single or multiple escaped octal or hex values into ASCII or Unicode characters | quote=$'\042';  echo "$quote Quoted string $quote and this lies outside the quotes."; escape=$'\033'; echo "\"escape\" echoes as $escape" |
| $*                                                           | all of the positional parameters, seen as single word        | **"$*" must be quoted**                                      |
| $@                                                           | same as $*, but each parameters is a quoted string           | **"$@" should be quoted**                                    |
| $?                                                           | exit status variable                                         |                                                              |
| $$                                                           | holds the pid of the process itself                          |                                                              |
| $!                                                           | holds the pid of the last background job                     |                                                              |
| ()                                                           | command group which starts a subshell                        | a=Hello; echo $a; ( a=hello; echo $a; ); echo $a             |
| {xxx,yyy,zzz,...}                                            | Brace expansion                                              | echo \"{These,words,are,quoted}\"; echo {file1,file2}\ :{\ A," B",' C'} |
| {a..z}                                                       | Extended Brace expansion                                     | echo {a...z}; base64_charset=( {A..Z} {a..z} {0..9} + / = )  |
| {}                                                           | **Block of code** [curly brackets] which referred to as an inline group, create an anonymous function, however, the variables inside a code block remain visible to the remainder of the script | a=Hello; echo $a; { a=hello; echo $a; }; echo $a             |
| []                                                           | test                                                         |                                                              |
| [[]]                                                         | test                                                         |                                                              |
| []                                                           | array element                                                |                                                              |
| []                                                           | range of characters                                          |                                                              |
| $[...]                                                       | integer expansion, deprecated and suggest to use (()) instead | (( a=3, b=7 )); echo $[$a+$b]                                |
| (())                                                         | integer expansion                                            | echo $(( a=3, b=7, a+b ))                                    |
| (command)>                                                   | process substitution                                         |                                                              |
| <(command)                                                   | process substitution                                         | diff <(ls -1 /bin) <(ls -1 /usr/bin)                         |
| <<                                                           | redirection used in a here document.                         |                                                              |
| <<<                                                          | redirection used in a here string.                           |                                                              |
| <, >                                                         | ASCII comparison                                             | veg1=carrots; veg2=tomatoes; test "$veg1" < "$veg2"          |
| \\<, \\>                                                     | word boundary in a regex                                     |                                                              |
| \|                                                           | pipe                                                         |                                                              |
| >                                                            | force redirection                                            |                                                              |
| \|\|                                                         | **OR logical operator** which causes a return of 0 (success) if either of the linked test conditions is true. |                                                              |
| &                                                            | **Run job in background**                                    |                                                              |
| &&                                                           | **AND logical operator** which causes a return of 0 (success) only if both the linked test conditions are true. |                                                              |
| -                                                            | **dash**, redirection from/to stdin or stdout                | (cd /source/directory && tar cf - . ) \| (cd /dest/directory && tar xpvf -) |
| --                                                           | **double-dash**                                              | rm -- -badname; set -- $variable                             |
| ~+                                                           | **current working directory** which corresponds to the **$PWD** internal variable |                                                              |
| ~-                                                           | **previous working directory** which corresponds to the **$OLDPWD** internal variable |                                                              |
| =~                                                           | regex match                                                  |                                                              |
| ^                                                            | regex beginning-of-line                                      |                                                              |
| ^, ^^                                                        | uppercase conversion in parameter substitution               | var="bash"; echo ${var^}; echo ${var^^}                      |
| $_                                                           | arg of last command                                          | echo arg1; echo $_                                           |





## trap

As already mentioned above, trap can be set not only for signals which allows the script to respond but also to what we can call "pseudo-signals". They are not technically signals, but correspond to certain situations that can be specified:

- ### EXIT

  When `EXIT` is specified in a trap, the command of the trap will be execute on exit from the shell.

- ### ERR

  This will cause the argument of the trap to be executed when a command returns a non-zero exit status, with some exceptions (the same of the shell errexit option): the command must not be part of a `while` or `until` loop; it must not be part of an `if` construct, nor part of a `&&` or `||` list, and its value must not be inverted by using the `!` operator.

- ### DEBUG

  This will cause the argument of the trap to be executed before every simple command, `for`, `case` or `select` commands, and before the first command in shell functions

- ### RETURN

  The argument of the trap is executed after a function or a script sourced by using `source` or the `.` command.





## references

http://www.tldp.org/LDP/abs/html/

https://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/

https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Operation