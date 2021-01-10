# mysql 

> version  >= 5.7 required



## basic commands

show currently using database

```
select database();
```

show all databases

```
show databases;
```

show all tables in current database

```
show tables;
```

show currently logging user

```
show user();
```

show grants of current user

```
show grants;
show grants for @@user;
```

show time zone

```
SELECT @@global.time_zone, @@session.time_zone, @@system_time_zone, TIMEDIFF(NOW(), UTC_TIMESTAMP);
```



## init

### install database and mycli

````
sudo apt update
sudo apt -y install mysql-server-5.7
sudo apt -y install mycli
sudo mysql_secure_installation
sudo mysql -uroot -e 'use mysql; select user, host, plugin from mysql.user;'
````

### create admin user

```mysql
sudo mysql -uroot
drop user if exists 'admin'@'%';
create user if not exists 'admin'@'%' identified with mysql_native_password by 'admin123';
grant all on *.* to 'admin'@'%';
grant file on *.* to 'admin'@'%';
show grants for 'admin'@'%';
show create user 'admin'@'%';
exit
```

### create alias make exec easy

```
alias mysql_exec='sudo mysql -uroot -e '
mysql_exec "show databases;"
```

### create database

```mysql
-- database
drop database if exists chekawa;
create database if not exists chekawa default charset utf8 collate utf8_general_ci;
```

### create user

```mysql
-- user: admin
drop user if exists 'chekawa_admin'@'%';
create user if not exists 'chekawa_admin'@'%' identified with mysql_native_password by 'chekawa_admin';
grant all on chekawa.* to 'chekawa_admin'@'%';
-- mysql如果想要有into oufile 或者 load data infile 操作，必须授予file权限，而这个权限不能针对某个表，或库授予，是针对*.*的用户授予的, 使用show grants for 命令查看权限
grant file on *.* to 'chekawa_admin'@'%';

-- user: user
drop user if exists 'chekawa_user'@'%';
create user if not exists 'chekawa_admin'@'%' identified with mysql_native_password by 'chekawa_admin';
grant select on chekawa.* to 'chekawa_admin'@'%';
```

### make connect noninteractive to multiple host with `my.cnf`

1. create .my.cnf

   ```
   cat > ~/.my.cnf << EOF
   [client]
   host = host.example.com
   database = db
   user = root
   password = 123456
   
   [clientdb1]
   host = host1.example.com
   database = db1
   user = alice
   password = 123456
   
   [clientdb2]
   host = host2.example.com
   database = db2
   user = bob
   password = 123456
   
   EOF
   ```

2. secure the file .my.cnf

   ```
   chmod 400 ~/.my.cnf
   ```

3. choose the option group on the command-line

   ```
   # default connect
   mysql
   
   # connect to clientdb1
   mysql --defaults-group-suffix=db1
   
   # connect to clientdb2
   mysql --defaults-group-suffix=db2
   ```

4. ~/.bash_alias

   ```
   alias my_db1='mysql --defaults-group-suffix=db1 -e '
   alias my_db2='mysql --defaults-group-suffix=db2 -e '
   ```

5. ~/.bash_funcs

   > funcs is preferred

   ```
   cat >> ~/.bash_funcs << 'EOF'
   
   function mysql_exec() {
       Usage() {
           cat <<- EOF
   Usage:
   
   SYNOPSISI
       mysql_exec database sql_stmt
   
   OPTIONS
       database      database name
       sql_stmt      sql statement
   EOF
       }
       
       if [[ $# != 2 || $# != 1 ]]; then
           Usage
           return -1
       fi
       
    database="$1"
    sql_stmt="$2"
    if [[ -z "$sql_stmt" ]]; then
        mysql --defaults-group-suffix="$database"
    else
        mysql --defaults-group-suffix="$database" -e "database"
    fi
   }
   
   
   export -f mysql_exec
   
   EOF
   
   ```

6. make sure ~/.bash_alias and ~/.bash_funcs in ~/.bashrc

   ```
   cat >> ~/.bashrc << EOF
   # customized funcs
   source ~/.bash_funcs
   ```



## backups && restores

### backup

> **warning: there is no blank space between `-p` and `${password}`**

whole database or single table

```
user=
host=
password=
database=
table=
mysqldump -u ${user} -h ${host} -p ${database} ${table} > /tmp/${database}.sql.$(date -Iseconds)
```

structure only

```
user=
host=
password=
database=
table=
mysqldump \
    -u ${user} \
    -h ${host} \
    -p${password} \
    --single-transaction \
    --skip-triggers \
    --lock-tables=false \
    --no-data \
    --routines \
    --events \
    ${database} ${table}  > /tmp/${database}.${table}.sql.no-data.$(date -Iseconds)
```

data only

```
user=
host=
password=
database=
table=
mysqldump \
    -u ${user} \
    -h ${host} \
    -p${password} \
    --single-transaction \
    --skip-triggers \
    --lock-tables=false \
    --no-create-info \
    ${database} ${table} > ${database}.${table}.sql.data-only.$(date -Iseconds)
```

### restore

```
mysql -u ${user} -h ${host} -p${password} ${database} < dump.sql
```



## max_allowed_packet

show

```
show variables like 'max_allowed_packet';
```

set from query editor

```
SET GLOBAL max_allowed_packet=1048576;
```

set by start from cli 

```
mysqld --max_allowed_packet=100M
```

set in mysqld file

```
max_allowed_packet=100M
```



## sql statement

### Condition in `WHERE` clause vs. `ON` clause

Filtering in the ON clause

Filtering in the WHERE clause



## execute order

1. FROM, including JOINs
2. WHERE
3. GROUP BY
4. HAVING
5. WINDOW functions
6. SELECT
7. DISTINCT
8. UNION
9. ORDER BY
10. LIMIT and OFFSET



## in & exists

- `EXISTS` is much faster than `IN`, when the sub-query results is very large.
- `IN` is faster than `EXISTS`, when the sub-query results is very small.



## debug

show sql

```
select * from information_schema.processlist;
```



## Character encoding 

show

```
show variables like 'character%';
```

select 

```
select @@CHARACTER_SET_CLIENT;
select @@CHARACTER_SET_RESULTS;
select @@COLLATION_CONNECTION;
```



## time zone

select

```
select @@TIME_ZONE
```



## SQL_MODE

```
select @@SQL_MODE;
```





## Best practices for configuring parameters for Amazon RDS for MySQL

https://aws.amazon.com/blogs/database/best-practices-for-configuring-parameters-for-amazon-rds-for-mysql-part-1-parameters-related-to-performance/

https://aws.amazon.com/blogs/database/best-practices-for-configuring-parameters-for-amazon-rds-for-mysql-part-2-parameters-related-to-replication/

https://aws.amazon.com/blogs/database/best-practices-for-configuring-parameters-for-amazon-rds-for-mysql-part-3-parameters-related-to-security-operational-manageability-and-connectivity-timeout/





## QAs

Q1: time zone mismatch between ide and server

A1:  the follow two works

- in server side : `set global time_zone = '+8:00'; `

- in ide side, say pycharm: `DB Navigator` -> `Connections` -> `Connection` -> `Properties` -> (add value) `{"serverTimezone" : "UTC"}`