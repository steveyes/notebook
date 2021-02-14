# django rest 000

> preparation

[toc]

## requirement

- ubuntu>=18.04
- python>=3.8
- Django==3.1.6
- djangorestframework==3.12.2
- django-filter==2.4.0
- Markdown==3.3.3



## variables

```
SERVER_IP=192.168.1.20
SERVER_PORT=8000
PROJECT_NAME=sites
BASE_DIR=$(python3 -c "from pathlib import Path; print(Path('$PROJECT_NAME').resolve())")
CONF_DIR=$BASE_DIR/$(basename $BASE_DIR)
```



## create project

```
django-admin startproject ${PROJECT_NAME}
```



## venv

```
cd $BASE_DIR
mkdir venv/
sudo python3 -m venv venv/
source venv/bin/activate
```



## install django and rest

```
pip install Django==3.1.6
pip install django-filter==2.4.0
pip install djangorestframework==3.12.2
pip install Markdown==3.3.3
```



## create admin user

**username:** admin

**password:** admin123456

```
python3 manage.py createsuperuser --email admin@example.com --username admin
```



