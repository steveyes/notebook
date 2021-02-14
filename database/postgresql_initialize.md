# postgresql initialize

[toc]



## prerequisite alias and functions

alias psqc

```
alias psqc='sudo -u postgres psql -c'
```

function is-ok

```
function is-ok() {
    color_end='\033[0m'
    color_green='\033[32m'
    color_red='\033[31m'   
    command="$1"
    
    if eval "$command" &>/dev/null; then
        echo -e "${color_green}${command} succeeded${color_end}"
    else
        echo -e "${color_red}${command} failed${color_end}"
        return 1
    fi
}

```



## installation

```bash
sudo apt -y install postgresql-client postgresql
```



## create user and database step by step

### user 

create peer user

```bash
peer_user="pgadmin"
peer_pass="123456"
sudo useradd ${peer_user} -m -s /bin/bash
(echo ${peer_pass}; echo ${peer_pass};) | sudo passwd ${peer_user}
is-ok "id ${peer_user}"
```

create database user

```bash
db_user="pgadmin"
db_pass="123456"
psqc "create user ${db_user} with password '${db_pass}';"
is-ok "psqc '\du' | grep ${db_user}"
```

### database 

create database

```bash
db_name="cassini"
db_user="pgadmin"
psqc "create database ${db_name} owner ${db_user}"
is-ok "psqc '\l' | grep ${db_name}"
```

grant privileges

```bash
db_name="cassini"
db_user="pgadmin"
cd /;
sudo -u postgres psql -d ${db_name} -c "
grant all on all tables in schema public to ${db_user};
grant all on all sequences in schema public to ${db_user};
grant all on all functions in schema public to ${db_user};
alter default privileges in schema public grant all on tables to ${db_user};
alter default privileges in schema public grant all on sequences to ${db_user};
alter default privileges in schema public grant all on functions to ${db_user};
alter default privileges in schema public grant all on types to ${db_user};
"
```



## create user and database in one example

```bash
peer_user="pgadmin"
peer_pass="123456"
db_user="pgadmin"
db_pass="123456"
db_name="cassini"

sudo useradd ${peer_user} -m -s /bin/bash
(echo ${peer_pass}; echo ${peer_pass};) | sudo passwd ${peer_user}
id ${peer_user}

psqc "CRAETE USER ${db_user} WITH PASSWORD '${db_pass}';"
psqc "CREATE DATABASE ${db_name} owner ${db_user};"
psqc "ALTER ROLE ${db_user} SET client_encoding TO 'utf8';"
psqc "ALTER ROLE ${db_user} SET default_transaction_isolation TO 'read committed';"
psqc "ALTER ROLE ${db_user} SET timezone TO 'UTC';"
psqc "GRANT ALL ON DATABASE ${db_name} TO ${db_user};"
```




## conf

### listen on lan ip

```bash
postgresql_conf=$(sudo -u postgres psql -c 'SHOW config_file' | grep 'postgresql.conf')

lan_ip=$(ip -4 a s | awk -F'/| +' '/scope global/{print $3}')

sudo sed -i.$(date +%s) "/^#listen_address/ a listen_addresses = '${lan_ip}'" $postgresql_conf

sudo systemctl restart postgresql

if grep $lan_ip $postgresql_conf; echo -e '\033[32mdatabase created succeeded\033[0m' || echo -e '\033[31mdatabase created failed\033[0m'
```

### grant lan access to user

```bash
pg_hba_conf=$(sudo -u postgres psql -c 'SHOW hba_file' | grep 'pg_hba.conf')

TAB="$(printf '\t')"
type=host
database=cassini
user=pgadmin
address=${lan_ip%.*}.0/24
method=md5

if ! grep $database $pg_hba_conf | grep $user; then
    sudo -u postgres bash -c "cat >> ${pg_hba_conf} << EOF
${type}${TAB}${database}${TAB}${TAB}${TAB}${user}${TAB}${TAB}${TAB}${address}${TAB}${TAB}${TAB}${method}
EOF
"
fi

sudo systemctl restart postgresql
```



## login using psql

```bash
# if the user is the peer user(whose username both same in os or db) and username is # same with database name, the -d par can be omitted.
sudo -u pgadmin psql -d cassini

# login to database using user postgres 
sudo -u postgres psql -d cassini
```





## drop user

```
create user new_user with password '123456';
reassign owner by old_user to new_user;

alter default privileges in schema public revoke all on functions from old_user ;
alter default privileges in schema public revoke all on sequences from old_user ;
alter default privileges in schema public revoke all on tables from old_user ;
alter default privileges in schema public revoke all on types from old_user ;
alter default privileges in schema public revoke all on functions to new_user ;
alter default privileges in schema public revoke all on sequences to new_user ;
alter default privileges in schema public revoke all on tables to new_user ;
alter default privileges in schema public revoke all on types to new_user ;

drop old_user;
```

