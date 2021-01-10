# Markdown Diagram 指南

## Sequence

- Title: title
- ->: Normal line
- -->: Dashed line
- ->>: Open arrow
- -->>: Dashed open arrow
- Note left of
- Note right of
- Note over A
- participant

```sequence
Title: Here is a title

participant A
participant B
participant C
participant D

Note left of A: Note to the\n left of A
Note right of A: Note to the\n right of A
Note over A: Note over A
Note over A,B: Note over both A and B

A->B: Normal line
B-->C: Dashed line
C->>D: Open arrow
D-->>A: Dashed open arrow

```

## Flowchart

- start, end: 开始与结束。
- operation: 处理块。
- subroutine: 子程序块。
- condition: 条件判断。
- inputoutput: 输入输出。
- right, left: 当前模块下一个箭头的指向（默认箭头指向下方）。
- yes, no: 条件判断的分支（默认yes箭头向下no箭头向右；yes与no可以和right同时使用；yes箭头向右时，no箭头向下）

```flow
st=>start: Start|past:>http://www.google.com[blank]
e=>end: End:>http://www.google.com
op1=>operation: My Operation|past
op2=>operation: Stuff|current
sub1=>subroutine: My Subroutine|invalid
cond=>condition: Yes 
or No?|approved:>http://www.baidu.com
c2=>condition: Good idea|rejected
io=>inputoutput: catch something...|request

st->op1(right)->cond
cond(yes, right)->c2
cond(no)->sub1(left)->op1
c2(yes)->io->e
c2(no)->op2->e
```
