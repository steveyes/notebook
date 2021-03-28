# django3 initialize

[toc]



## environment

- ubuntu>=18.04
- python==3.8
- Django==3.1.6
- psycopg2==2.8.4
- djangorestframework==3.12.2
- django-filter==2.4.0
- Markdown==3.3.3



## prerequisite

**on django server**

```
sudo pip3 install -i https://pypi.mirrors.ustc.edu.cn/simple/ django
python3 -c 'import django; print(django.get_version());'
sudo apt -y update
sudo apt -y install postgresql-client
sudo apt -y install libpq-dev
```

**on database server**

```
sudo apt -y update
sudo apt -y install postgresql-client postgresql
sudo apt -y install libpq-dev
```



## create project

```
cd ~/repo/python_notebook
django-admin startproject website
```



## venv

```
cd ~/repo/python_notebook/
mkdir venv/
sudo python3 -m venv venv/
source venv/bin/activate
```



## install packages

```
pip install Django==3.1.6
pip install psycopg2==2.8.4
pip install django-filter==2.4.0
pip install djangorestframework==3.12.2
pip install Markdown==3.3.3
```



## database initialize

create user and database

```
pushd /

alias psqc='sudo -u postgres psql -c'
peer_user="cassini"
peer_pass="123456"
db_user="cassini"
db_pass="123456"
db_name="cassini"

sudo useradd ${peer_user} -m -s /bin/bash
(echo ${peer_pass}; echo ${peer_pass};) | sudo passwd ${peer_user}
id ${peer_user}

psqc "CRAETE USER ${db_user} WITH PASSWORD '${db_pass}';"
psqc "ALTER ROLE ${db_user} SET client_encoding TO 'utf8';"
psqc "ALTER ROLE ${db_user} SET default_transaction_isolation TO 'read committed';"
psqc "ALTER ROLE ${db_user} SET timezone TO 'UTC';"

psqc "CREATE DATABASE ${db_name} owner ${db_user};"
psqc "GRANT ALL ON DATABASE ${db_name} TO ${db_user};"

popd
```

listen on lan ip

```
postgresql_conf=$(sudo -u postgres psql -c 'SHOW config_file' | grep 'postgresql.conf')

lan_ip=$(ip -4 a s | awk -F'/| +' '/scope global/{print $3}')

sudo sed -i.$(date +%s) "/^#listen_address/ a listen_addresses = '${lan_ip}'" $postgresql_conf

sudo systemctl restart postgresql

if grep $lan_ip $postgresql_conf; echo -e '\033[32mdatabase created succeeded\033[0m' || echo -e '\033[31mdatabase created failed\033[0m'
```

grant lan access to user

```
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



## create app

```
cd ~/repo/python_notebook/website/
python manage.py startapp appdemo01
```



## settings

```
...

ALLOWED_HOSTS = ['192.168.1.20']

...

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'appdemo01',
]

...

TEMPLATES = [
    {
        ...
        'DIRS': [str(Path(BASE_DIR, 'templates')), ],
        ...
    },
]

...

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'cassini',
        'USER': 'cassini',
        'PASSWORD': '123456',
        'HOST': '192.168.1.101',
        'PORT': '5432',
    }
}

...

STATICFILES_DIRS = (
    str(Path(BASE_DIR, 'static')),
)
```



## mkdirs

```
cd ~/repo/python_notebook/website/
mkdir templates
mkdir static
```



## create tables

```
python manage.py makemigrations
python manage.py migrate
```



## create super user

```
python manage.py createsuperuser --email admin@example.com --username admin
```



## run server

```
python manage.py runserver 0.0.0.0:8000
```









