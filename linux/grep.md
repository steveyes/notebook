# grep



## grep tab in the text files of current directory recursively

```
grep -rnwP --color  '\t' * | grep -v 'Binary file'
```



## get config

```
grep '^[a-zA-Z0-9]' $config
```



## match multiple (grep and)

there's no `logical and` of grep, use awk instead

```
awk '/pattern1/ && /pattern2/' filename
```



## match any (grep or)

```
grep 'pattern1\|pattern2' filename
```

```
grep -E 'pattern1|pattern2' filename
```

```
grep -e pattern1 -e pattern2 filename
```



## negative match ( grep not)

```
grep -v 'pattern1' filename
```



