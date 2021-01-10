# create user

## 方式一

* 创建数据库用户

```
sudo -u postgres /usr/bin/createuser -s -e ${user_name}
```

* 创建数据库，指定所有者

```
sudo -u postgres /usr/bin/createdb -E UTF8 -O ${user_name} ${db_name}
```

* 更新数据库用户密码

```
sudo -u postgresql psql -c "alter user ${user_name} with password ${user_password}"
```

* 创建同名系统用户

```
sudo adduser ${user_name}
sudo passwod ${user_password}
```

## 方式二

* 切换到psql命令行

```
sudo -u postgres psql
```

* sql命令组

```
create user :user_name with password :user_password;
create database :db_name owner :user_name;

grant all on database :db_name to :user_name;
```

* 创建同名系统用户

```
sudo adduser ${user_name}

sudo passwod ${user_password}
```



