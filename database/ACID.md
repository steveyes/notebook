# ACID



## 基本概念

ACID，指数据库事务正确执行的四个基本要素的缩写。包含：原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）、持久性（Durability）。一个支持事务（Transaction）的数据库，必须要具有这四种特性，否则在事务过程（Transaction processing）当中无法保证数据的正确性，交易过程极可能达不到交易方的要求。



## 原子性

整个事务中的所有操作，要么全部完成，要么全部不完成，不可能停滞在中间某个环节。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。

举个例子：Alice 账户原有 1200元，Bob 账户原有 800元，Alice 转账 200元给 Bob，则这个事务包含两个步骤

* 1200 - 200 = 1000
* 800 + 200 = 100

原子性表示，上两个步骤要么全都成功，要么全都失败，不能只完成一个步骤。



## 一致性

一个事务可以封装状态改变（除非它是一个只读的）。事务必须始终保持系统处于一致的状态，不管在任何给定的时间并发事务有多少。

也就是说：如果事务是并发多个，系统也必须如同串行事务一样操作。其主要特征是保护性和不变性(Preserving an Invariant)。

举个例子：假设有五个账户，每个账户余额是100元，那么五个账户总额是500元，如果在这个5个账户之间同时发生多个转账，无论并发多少个，比如在A与B账户之间转账5元，在C与D账户之间转账10元，在B与E之间转账15元，五个账户总额也应该还是500元，这就是保护性和不变性。

一致性表示，对一个事务的操作，不管内部步骤如何，操作前和操作后的总状态一致，或者可以理解为能量守恒。



## 隔离性

隔离状态执行事务，使它们好像是系统在给定时间内执行的唯一操作。如果有两个事务，运行在相同的时间内，执行相同的功能，事务的隔离性将确保每一事务在系统中认为只有该事务在使用系统。这种属性有时称为串行化，为了防止事务操作间的混淆，必须串行化或序列化请求，使得在同一时间仅有一个请求用于同一数据。



## 持久性

在事务完成以后，该事务对数据库所作的更改便持久的保存在数据库之中，并不会被回滚。



## 脏读、不可重复读、幻读

#### 脏读 - dirty read

指一个事务处理过程中读取了另外一个未提交事务中的数据。

#### 不可重复度 - nonrepeatable read

是指在一个事务内，多次读同一数据。在这个事务还没有结束时，另外一个事务也访问该同一数据。那么，在第一个事务中的两次或多次读数据之间，由于第二个事务的修改，那么第一个事务两次获多次读到的数据可能是不一样的。这样就发生了**在一个事务内两次读到的数据是不一样的**，因此称为是不可重复读。

#### 幻读 - phantom read

是指当事务不是独立执行时发生的一种现象，例如第一个事务对一个表中的数据进行了修改，这种修改涉及到表中的全部数据行。同时，第二个事务也修改这个表中的数据，这种修改是向表中**插入一行新数据**。那么，以后就会发生操作第一个事务的用户发现表中还有没有修改的数据行，就好象发生了幻觉一样。



## Mysql隔离级别设置

| 隔离级别         | 脏读 | 不可重复度 | 幻读 |
| ---------------- | ---- | ---------- | ---- |
| Read uncommitted | 有   | 有         | 有   |
| Read committed   | 无   | 有         | 有   |
| Repeatable read  | 无   | 无         | 有   |
| Serializable     | 无   | 无         | 无   |



## Mysql事务隔离性测试

测试环境准备

```mysql
-- 建表 
drop table AMOUNT; 
CREATE TABLE `AMOUNT` ( `id` int NULL, `name` varchar(12), `money` numeric NULL, CONSTRAINT pk_AMOUNT PRIMARY KEY (id) );
```



测试一  `read-uncommitted`
| 客户端 A                                                 | 客户端 B              | 说明                                                         |
| -------------------------------------------------------- | --------------------- | ------------------------------------------------------------ |
| select * from amount;                                    | select * from amount; | A, B获取到的数据记录一致                                     |
| start transaction;                                       | -                     | 事务A开始，事务A未提交                                       |
| insert into amount(id, name, money) values(1, 'A', 800); | -                     | -                                                            |
| select * from amount;                                    | select * from amount; | A, B获取到的数据记录一致，都增加了一条记录，对于事务B来说是**`脏读`**。 |
| commit;                                                  | -                     | 事务A提交                                                    |
| insert into amount(id, name, money) values(2, 'A', 200); | -                     | A开始一个新事务                                              |
| -                                                        | select * from amount; | B读取的记录又增加了一条记录，正常                            |
| rollback;                                                | -                     | 插入记录的事务A回滚                                          |
| -                                                        | select * from amount; | 事务正确回滚，B读取不到相应的记录了                          |



测试二 `read-committed`

| 客户端 A              | 客户端 B                                                 | 说明                                                         |
| --------------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| select * from amount; | select * from amount;                                    | A, B获取到的数据记录一致                                     |
| start transaction;    | -                                                        | 事务A开始，事务A未提交                                       |
| -                     | start transaction;                                       | 事务B开始，事务B未提交                                       |
| -                     | insert into amount(id, name, money) values(3, 'B', 200); | B插入数据，事务B未提交                                       |
| select * from amount; | select * from amount;                                    | A没有获取到B插入的数据，不产生**`脏读`**                     |
| -                     | commit;                                                  | 事务B提交                                                    |
| select * from amount; |                                                          | A读取到B新增的数据了，产生**`可重复读`**，此时事务A并未提交。 |



测试三 `repeatable-read`

| 客户端 A                                                 | 客户端 B                                                 | 说明                                                         |
| -------------------------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| select * from amount;                                    | select * from amount;                                    | A, B获取到的数据记录一致                                     |
| start transaction;                                       | -                                                        | 事务A开始，事务A未提交                                       |
| -                                                        | start transaction;                                       | 事务B开始，事务B未提交                                       |
| -                                                        | insert into amount(id, name, money) values(4, 'B', 200); | B插入数据，事务B未提交                                       |
| select * from amount;                                    | select * from amount;                                    | A没有获取到B插入的数据，不产生**`脏读`**                     |
| -                                                        | commit;                                                  | 事务B提交                                                    |
| select * from amount;                                    | -                                                        | A读不到B新增的数据了，不产生**`可重复读`**，此时事务A并未提交。 |
| insert into amount(id, name, money) values(4, 'B', 200); | -                                                        | A插入失败，报Duplicate key错误（id是主键），产生**`幻读`**，A查询不到id=6的记录，理论上可以插入该记录，但事实上B已经插入了这条记录，对于A来说幻读了id=4的记录 |



测试四 `serializable`

| 客户端 A              | 客户端 B                                                 | 说明                              |
| --------------------- | -------------------------------------------------------- | --------------------------------- |
| select * from amount; | select * from amount;                                    | A, B获取到的数据记录一致          |
| start transaction;    | -                                                        | 事务A开始，事务A未提交            |
| start transaction;    | -                                                        | 事务A开始，事务A未提交            |
| -                     | start transaction;                                       | 事务B开始，事务B未提交            |
| -                     | insert into amount(id, name, money) values(4, 'B', 200); | B插入数据，事务B未提交            |
| select * from amount; | -                                                        | 这里A读取会一直被阻塞，读取不到   |
| -                     | commit;                                                  | 事务B提交                         |
| select * from amount; | -                                                        | 这里A不被阻塞了，读取的结果返回了 |



## MYSQL事务常用命令

|                        |                                      |
| ---------------------- | ------------------------------------ |
| 查询当前隔离级别       | select @@tx_isolation;               |
| 设置当前隔离级别为 @il | set transaction isolation level @il; |
| 开始事务               | start transation                     |
| 提交事务               | commit                               |
| 回滚事务               | rollback                             |
| 查看事务的自动提交     | show variables like '%autocommit%';  |
| 关闭事务的自动提交     | set autocommit = off;                |



## Java隔离级别设置

| 隔离级别                     | 脏读 | 不可重复度 | 幻读 |
| ---------------------------- | ---- | ---------- | ---- |
| TRANSACTION_READ_UNCOMMITTED | 有   | 有         | 有   |
| TRANSACTION_READ_COMMITTED   | 无   | 有         | 有   |
| TRANSACTION_REPEATABLE_READ  | 无   | 无         | 有   |
| TRANSACTION_SERIALIZABLE     | 无   | 无         | 无   |

