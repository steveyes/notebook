

### od

```
od -Ax -tx1cz -v ${bin-file}
```

- -A, --address, -Ax display hexdump format output
- -t, --format, x1 以16进制显示数据，每次1字节，z在行末显示ASCII值



### xxd

```
xxd -g1 -u ${bin-file}
```



### hexdump

```
hexdump -C -s 0x1f0 0n96 /bin/ls
```

- -C canonical, 规范(输出)
- -s skip over, 从0x1f0行开始显示
- -n number of bytes, -n 96，总共显示96字节，以16字节为一行算，96字节即6行
