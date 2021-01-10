# django

[toc]

## packages install

on django server

```
sudo pip3 install -i https://pypi.mirrors.ustc.edu.cn/simple/ django>=2.2
python3.7 -c 'import django; print(django.get_version());'
sudo apt -y update
sudo apt -y install postgresql-client postgresql
sudo apt -y install libpq-dev
sudo pip3 install psycopg2>=2.8.4
```

on database server

```
sudo apt -y update
sudo apt -y install postgresql-client postgresql
```



## database initialize

please refer to: [postgres initialize](../Database/postgresql_initialize.md)



## initialize


### create django project

```bash
django-admin startproject django_
```

### create django app

```bash
cd django_
django-admin startapp app01
```

### settings.py

Configure the Django Database

```text
...

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'cassini',
        'USER': 'pgadmin',
        'PASSWORD': '123456',
        'HOST': '192.168.1.101',
        'PORT': '5432',
    }
}

...

```

**allowed hosts**

```
# run lan_ip=... in postgresql server
# lan_ip=$(ip -4 a s | awk -F'/| +' '/scope global/{print $3}')
# append to the following list with '$lan_ip', don't missing the single quotes, e.g.
ALLOWED_HOSTS = ['192.168.1.101']
```

**templates and static**

> refer to the chapter: `templates and static`



## django commands


### make sql scripts (whenever models are created or changed)

```bash
python3 manage.py makemigrations
```

### exec sql scripts after `makemigrations`

```bash
python3 manage.py migrate
```

### create super user

> user which can login into /admin

```
sudo python3 manage.py createsuperuser
```

### run server 

```
# should make ALLOWED_HOSTS = ['*', ] in settings.py by running following command
# sed -i "s#^ALLOWED_HOSTS.*#ALLOWED_HOSTS = ['*', ]#g" settings.py
python3 manage.py runserver 0.0.0.0:8000
```

### lookup sql statement

```
python3 manage.py sqlmigrate <application_name> <sequence_version>
```

### open manage shell

```
python3 manage.py shell
```



## django admin

### register app's models

```
from django.contrib import admin
from account import models

admin.site.register(models.UserInfo)
admin.site.register(models.UserType)
```



## templates and static

### templates

create dir

```
cd $BASE_DIR/
mkdir templates
```

settings

```
TEMPLATES = [
    {
        ...
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        ...
    },
]
```

### static

create dir

```
cd $BASE_DIR/
mkdir static
```

settings

```
STATIC_URL = '/static/'

STATICFILES_DIRS = (
    os.path.join(BASE_DIR, 'static'),
)
```

### extend

```
{% extends 'default.html' %}
```

### include

```
{% include 'model01.html' %}
```

### templatetags 

create dir whose name in **templatetags** in app01

```
mkdir app01/templatetags
```

widget01.py in app01/templatetags

```
from django import template
register = template.Library()

@register.simple_tag
def add(a, b):
    return a + b

@register.filter
def deco(name: str, suffix: str, ):
    return f"{name}.{suffix}"
```

### simple_tag

> do not support if statement
>
> more than one argument

```
{% load widget01 %}
{% add 3 4 %}
```

### filter

> support if statment
>
> no more than two arguments
>
> should not be leave blank space between filter and args
> 	wrong: name|deco: "first name, last name"
> 	correct: name|deco:"first name, last name"

```
{% load widget01 %}
{{ name|deco:"first name, last name" }}
```





## email in settings.py

testing only i.e. output the sending email events into console

```
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
```

production

```
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = 'account@gmail.com'
EMAIL_HOST_PASSWORD = ''
EMAIL_PORT = 587
EMAIL_USE_TLS = True
```

sample

```
from django.core.mail import send_mail
send_mail('Django mail', 'This e-mail was sent with Django.', 'your_account@gmail.com', ['your_account@google.com'], fail_silently=False)
```



## urls

### pattern #1 no args

urls.py

```
re_path(r'^abc/', app01_views.abc, name='abc'),
```

views.py in app01

```
def abc(request, *args, **kwargs):
    url_abc = reverse('abc')
    print(url_abc)
    print(request.path_info)
    return render(request, 'abc.html')
```

**templates** performs as same as url_abc above and path_info above

```
{% url "abc" %}
```

### pattern #2 args

urls.py

```
re_path(r'^xyz/(\w+)/(\w+)/', app01_views.xyz, name='xyz'),
```

views.py in app01

```
def xyz(request, *args, **kwargs):
    url_xyz = reverse('xyz', args=('x', 'y'))
    print(url_xyz)
    print(request.path_info)
    for i, v in enumerate(args):
        print(f'{i}:{v}')
    return render(request, 'xyz.html')
```

**templates** performs as same as url_xyz above and path_info above

```
{%  url 'xyz' 'x' 'y' %}
```

### pattern #3 kwargs

urls.py

```
re_path(r'^login/(?P<user>\d+)/(?P<password>\w+)', app01_views.login, name='login'),
```

views.py in app01

```
def login(request: WSGIRequest, *args, **kwargs):
    if request.method == 'GET':
        url_login = reverse('login', kwargs={'user':kwargs['user'], 'password':kwargs['password']})
        print(url_login)
        print(request.path_info)
        for k,v in kwargs.items():
            print(f"{k}={v}")
        return render(request, 'login.html')
    elif request.method == 'POST':
        file: File = request.FILES.get('file01')
        fd = open(file.name, mode='wb+')
        for c in file.chunks():
            fd.write(c)
        fd.close()
        return render(request, 'login.html')
    else:
        return redirect('/index/')
```

**templates** performs as same as url_login above and path_info above

```
{% url "login" user="001" password="123456" %}
```



## url dispatch

urls.py

```
from django.urls import path, re_path, include
from django.contrib import admin

urlpatterns = [
    path('app01/', include("app01.urls", namespace="app01")),
    path('app02/', include("app02.urls")),
]
```

app01/urls.py

```
from django.conf.urls path, re_path, include
from django.contrib import admin
from app01 import views

urlpatterns = [
    path('login/', views.login, name='login'),
]
```

app02/urls.py

```
from django.conf.urls path, re_path, include
from django.contrib import admin
from app01 import views

urlpatterns = [
    path('login/', views.login, name='login'),
]
```

views.py in app01

```
def method(request):
    ....
    return HttpResponsePermanentRedirect(reverse('app01:login'))
```

templates

```
<a href="{% url 'app01:login' %}">go to app01 login</a>
```





## request

### get array 

from checkbox

```
request.POST.getlist()
```

### file

```
file_obj = request.FILES.get()
print(file_obj.name)
print(file_obj.size)
print(file_obj.chunks())
```

### file upload

views.py

```python
def login(request: WSGIRequest):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        file: File = request.FILES.get('file01')
        fd = open(file.name, mode='wb+')
        for c in file.chunks():
            fd.write(c)
        fd.close()
        return render(request, 'login.html')
    else:
        return redirect('/index/')
```

html

```
<form action="/login/" method="POST" enctype="multipart/form-data">
    <p>
    <div>
        <input type="file" name="file01">
    </div>

    <p>
    <div>
        <input type="submit" value="submit">
    </div>
</form>
```



## cookies

set cookie

```
reponse = redirect('/index')
reponse.set_cookie('username', 'steve', expires=datetime.datetime.utcnow() + datetime.timedelta(days=30))
return reponse
```

```
reponse = render(request, 'index.html', max_age=86400 * 30)
reponse.set_cookie('username', 'steve')
return reponse
```

get cookie

```
v = request.COOKIES.get('username')
if not v:
	return redirect('/login/')
return render(request, 'index.html', {'current_user': v})
```

authenticate decorator

```
def auth(func):
    def inner(request, *args, **kwargs):
        v = request.COOKIES.get('username')
        if not v:
            return redirect('/login')
        return func(request, *args, **kwargs)

    return inner
```

authenticate decorator for function

```
@auth
def index(request):
    u = request.COOKIES.get('username')
    return render(request, 'index.html', {'current_user': u})
```

authenticate decorator for method in class

```
class Order(views.View):
    @method_decorator(auth)
    def get(self, request):
        u = request.COOKIES.get('username')
        return render(request, 'index.html', {'current_user': u})

    def post(self, request):
        u = request.COOKIES.get('username111')
        return render(request, 'index.html', {'current_user': u})
```

authenticate decorator for class

```
@method_decorator(auth, name='dispatch')
class Order(views.View):
    # @method_decorator(auth)
    # def dispatch(self, request, *args, **kwargs):
    #     return super(Order, self).dispatch(request, *args, **kwargs)

    def get(self, request):
        u = request.COOKIES.get('username')
        return render(request, 'index.html', {'current_user': u})

    def post(self, request):
        u = request.COOKIES.get('username111')
        return render(request, 'index.html', {'current_user': u})
```



## session

every request

settings

```
SESSION_SAVE_EVERY_REQUEST = True
SESSION_COOKIE_NAME ＝ "sessionid"       # session key saved on cookies
SESSION_COOKIE_PATH ＝ "/"               # session path saved on cookies
SESSION_COOKIE_DOMAIN = None             # session domain saved on cookies
SESSION_COOKIE_SECURE = False            # if transfor https on cookies?
SESSION_COOKIE_HTTPONLY = True           # if support transfor https on cookies?
SESSION_COOKIE_AGE = 1209600             # session expire days (default is 2 weeks) 
SESSION_EXPIRE_AT_BROWSER_CLOSE = False  # session expire on browser close
SESSION_SAVE_EVERY_REQUEST = False       # refresh session on every request
```

get

```
request.session['k1']
request.session.get('k1',None)
```

set

```
request.session['k1'] = 123
# set if 'k1' is None else do nothing
request.session.setdefault('k1',123)
```

delete

```
del request.session['k1']
```

get all

```
request.session.keys()
request.session.values()
request.session.items()
request.session.iterkeys()
request.session.itervalues()
request.session.iteritems()
```

random session

```
request.session.session_key
```

clear sessions whose expire time is less than current

```
request.session.clear_expired()
```

is exists?

```
request.session.exists("session_key")
```

delete session of current user

```
request.session.delete("session_key")
request.session.clear()
```

set expiry

```
request.session.set_expiry(value)
```

- session will expire in seconds if **value** is single digit and there is no user activity
- session will expire on some datetime if value is a certain `datetime` or `timedelta`
- session will expire immediately once browser is close if **value** is 0
- session will depend on global setting if **value** is None

cache

```
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'  
SESSION_CACHE_ALIAS = 'default'
```

encrypt

```
SESSION_ENGINE = 'django.contrib.sessions.backends.signed_cookies'
```

login

```
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        u = request.POST.get('user')
        p = request.POST.get('pwd')
        if user == 'root' and password == '123456':
            request.session.set_expiry(86400 * 30)
            # This statement will save the username in ciphertext to db.django_session
            request.session['username'] = uuser
            request.session['is_login'] = True
            return redirect('/index/')
        else:
            return render(request, 'login.html')
```

index

```
def index(request):
    if request.session.get('is_login', None):
        return render(request, 'index.html', {'username': request.session['username']})
    else:
        return HttpResponse('plase login')
```

logout

```
def logout(request):
    del request.session['username']
    request.session.clear()
    return redirect('/login/')
```

template

```
{{ request.session.username }}
```



## csrf

settings

```
'django.middleware.common.CommonMiddleware',
```

csrf_exempt

> turn off CSRF once **'django.middleware.common.CommonMiddleware'** is commented

```
@csrf_exempt
def login(request):
    if request.method == 'GET':
        return render(request, 'login.html')
    elif request.method == 'POST':
        u = request.POST.get('user')
        p = request.POST.get('pwd')
        if u == 'root' and p == '123':
            # This statement will save the username in ciphertext to db.django_session
            request.session['username'] = u
            request.session['is_login'] = True
            if request.POST.get('rmb', None) == '1':
                request.session.set_expiry(10)
            return redirect('/index/')
        else:
            return render(request, 'login.html')
```

csrf_protect

> turn on CSRF once **'django.middleware.common.CommonMiddleware'** is commented

```
@csrf_protect
def index(request):
    if request.session.get('is_login', None):
        return render(request, 'index.html', {'username': request.session['username']})
    else:
        return HttpResponse('gun')
```

on CBV

```
from django.views import View
from django.utils.decorators import method_decorator  #必须使用这个方法

@method_decorator(csrf_protect,name='dispatch')
class Foo(View):
    def get(self,request):
    pass

    def post(self,request):
    pass
```

Ajax post

```
<form method="POST" action="/csrf1.html">
{% csrf_token %}
<input id="user" type="text" name="user" />
<input type="submit" value="提交"/>
<a onclick="submitForm();">Ajax提交</a>
</form>

<script src="/static/jquery-1.12.4.js"></script>

<script>
function submitForm(){
    var csrf = $('input[name="csrfmiddlewaretoken"]').val();
    var user = $('#user').val();
    $.ajax({
        url: '/csrf1.html',
        type: 'POST',
        data: { "user":user,'csrfmiddlewaretoken': csrf}, 
        success:function(arg){
            console.log(arg);
        }
    })
}
</script>
```

Ajax get session from cookies

```
<form action="/login/" method="post">
    {% csrf_token %}
    <input type="text" name="user"/>
    <input type="text" name="pwd"/>
    <input type="checkbox" name="rmb" value="1">free login in 10 seconds
    <input type="submit" value="commit">
    <input id="btn1" type="button" value="button to press">
    <input id="btn2" type="button" value="button to press">
</form>
<script src="/static/jquery-1.12.4.js"></script>
<script src="/static/jquery.cookie.js"></script>
<script>
    $(function () {
        function csrfSafeMethod(method) {
            // these HTTP methods do not require CSRF protection
            return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
        }
        $.ajaxSetup({
            beforeSend: function (xhr, settings) {
                if(!csrfSafeMethod(settings.type) && !this.crossDomain) {
                    xhr.setRequestHeader('X-CSRFToken', $.cookie('csrftoken'));
                }
            }
        });
        $('#btn1').click(function () {
            $.ajax({
                url: '/login/',
                type: 'POST',
                data: {'user': 'root', 'pwd': 123456},
                success: function (arg) {
                }
            })
        });
        $('#btn2').click(function () {
            $.ajax({
                url: '/login/',
                type: 'POST',
                data: {'user': 'root', 'pwd': 123456},
                success: function (arg) {
                }
            })
        });
    });
</script>
```

session clear

```
def logout(request):
    request.session.clear()
    return redirect('/login/')
```

post csrftoken

```
<form action="/login/" method="post">
    {% csrf_token %}
    <input type="text" name="user"/>
    <input type="text" name="pwd"/>
    <input type="submit" value="commit">
</form>
```



## middle

create dir **middles** in project root, and create module **mdl.py** in dir middles

```
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import HttpResponse


class Mid01(MiddlewareMixin):
    def process_request(self, request):
        print('process request in Mid01')

    def process_view(self, request, view_func, view_func_args, view_func_kwargs):
        print('process view  in Mid01')

    def process_response(self, request, response):
        print('process response  in Mid01')
        return response


class Mid02(MiddlewareMixin):
    def process_request(self, request):
        print('process request in Mid02')

    def process_view(self, request, view_func, view_func_args, view_func_kwargs):
        print('process view  in Mid02')

    def process_response(self, request, response):
        print('process response  in Mid02')
        return response


class Mid03(MiddlewareMixin):
    def process_request(self, request):
        print('process request in Mid03')

    def process_view(self, request, view_func, view_func_args, view_func_kwargs):
        print('process view in Mid03')

    def process_response(self, request, response):
        print('process response in Mid03')
        return response

    def process_exception(self, request, exception):
        if isinstance(exception, ValueError):
            print('value error reported by process exception in Mid03')
            return HttpResponse('value error reported by process exception in Mid03')

    def process_template_response(self, request, reponse):
        print('----------------------------------')
        return reponse

```

settings

```
MIDDLEWARE = [
    ''',
    'middles.m1.Mid01',
    'middles.m1.Mid02',
    'middles.m1.Mid03',
    ''',
]
```



## cache

### for global

**settings.py**

**UpdateCacheMiddleware** should be the first middle

**FetchFromCacheMiddleware** should be the last middle

```
MIDDLEWARE = [
    'django.middleware.cache.UpdateCacheMiddleware',
    ...,
    'django.middleware.cache.FetchFromCacheMiddleware',
]

# prefix of cache
CACHE_MIDDLEWARE_KEY_PREFIX = 'cache'         
# expire date of cache
CACHE_MIDDLEWARE_SECONDS = 600
# use cache config defined in CACHES
CACHE_MIDDLEWARE_ALIAS = 'default'                 

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',
        'LOCATION': os.path.join(BASE_DIR, 'cache'),
    },   
}
```

### for views

**UpdateCacheMiddleware** should not be added to the middle

**FetchFromCacheMiddleware** should not be added to the middle

app01.views

```
from django.views.decorators.cache import cache_page

@cache_page(120, cache='default', key_prefix='page01')
def cache01(request):
    import time
    ctime = time.time()
    return render(request, 'cache01.html', {'ctime': ctime})

@cache_page(timeout=240, cache='default', key_prefix='page02')
def cache02(request):
    import time
    ctime = time.time()
    return render(request, 'cache02.html', {'ctime': ctime})
```

template

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

    {{ ctime }} <br />
    {{ ctime }} <br />
    {{ ctime }}

</body>
</html>
```

### for local

template

```
{% load cache %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

    {% cache 600 ctime_key1 %}
    {{ ctime }} <br />
    {% endcache %}

    {% cache 300 ctime_ket2 %}
    {{ ctime }} <br />
    {% endcache %}

    {{ ctime }} <br />

</body>
</html>
```









## models

### models define

```
# app01.py
class User(models.Model):
    age = models.IntegerField()
    name = models.CharField(max_length=32)

python3 manage.py makemigrations
python3 manage.py migrate
```

### create

```
from app01 import models
# alternative 1
models.User.objects.create(name='alice', age=18)
# alternative 2
data={'name':'bob', 'age':19}
models.User.objects.create(**data)
# alternative 3
data={'name':'carol', 'age':20}
obj = models.User(**data)
obj.save()
```

### retrieve

```
from app01 import models
models.User.objects.filter(id__gt=0,name='root')
models.User.objects.filter(id__lt=1000)
models.User.objects.filter(id__lte=65535)
models.User.objects.filter(id__gte=1)
data={'name':'alice', 'age':18}
models.User.objects.filter(**data)
```

```
user_objs = models.User.objects.all()
user_dicts = models.User.objects.all().values('name','age')
user_tuples = models.User.objects.all().values_list('name','age')
```

```
# raise error if none is found
models.User.objects.get(id=1000)
# return none if none is found
models.User.objects.filter(id=1).first()
```

### update

```
models.User.objects.filter(id__gt=1).update(age=21)
```

```
data={'name':'alice', 'age':19}
models.User.objects.filter(id__gt=1).update(**data)
```

### delete

```
models.User.objects.filter(id=1).delete()
```



## models relation

models.py

```python
class Teacher(models.Model):
    name = models.CharField(max_length=128)
    age = models.SmallIntegerField()


class Student(models.Model):
    name = models.CharField(max_length=128)
    age = models.SmallIntegerField()


class MToMTeacherStudent(models.Model):
    teacher = models.ForeignKey(Teacher, to_field='id', on_delete=models.CASCADE)
    student = models.ForeignKey(Student, to_field='id', on_delete=models.CASCADE)
```

views.py

```python
def teacher(request):
    if request.method == 'GET':
        teacher_list = models.Teacher.objects.all()
        student_list = models.Student.objects.all()
        return render(request, 'teacher.html', {'teacher_list': teacher_list, 'student_list': student_list, })
    elif request.method == 'POST':
        teacher_name = request.POST.get('teacher_name')
        student_list = request.POST.getlist('student_list')
        obj = models.Teacher.objects.create(name=teacher_name)
        obj.student.add(*student_list)
        return redirect('/teacher')


def student(request):
    if request.method == 'GET':
        student_list = models.Student.objects.all()
        teacher_list = models.Teacher.objects.all()
        return render(request, 'student.html', {'student_list': student_list, 'teacher_list': teacher_list, })
    elif request.method == 'POST':
        students_name = request.POST.getlist('students_name')
        teacher_list = request.POST.get('teacher_list')
        obj = models.Student.objects.create(name=students_name)
        obj.teacher.add(*teacher_list)
        return redirect('/student', )


def teacher_add_by_ajax(request):
    ret = {'status': True, 'error': None, 'data': None}
    teacher_name = request.POST.get('teacher_name')
    student_list = request.POST.getlist('student_list')
    obj = models.Teacher.objects.create(name=teacher_name)
    obj.student.add(*student_list)
    return HttpResponse(json.dumps(ret))

```

teacher.html

```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <style>
        .hide {
            display: none;
        }

        .pane-shade {
            position: fixed;
            top: 0;
            right: 0;
            left: 0;
            bottom: 0;
            background: gray;
            opacity: 0.6;
            z-index: 99;
        }

        .pane-add, .pane-edit {
            position: fixed;
            height: 300px;
            width: 400px;
            top: 100px;
            left: 50%;
            z-index: 100;
            border: 1px solid red;
            background: white;
            margin-left: -200px;
        }

        .span-tag {
            display: inline-block;
            padding: 3px;
            border: 1px solid red;
            background-color: palevioletred;
        }
    </style>
</head>
<body>

<h1>teacher list</h1>
<div>
    <input id="add-teacher" type="button" value="add">
</div>
<table style="border: 1px">
    <thead>
    <tr>
        <td>teacher name</td>
        <td>student list</td>
    </tr>
    </thead>
    <tbody>
    {% for teacher in teacher_list %}
        <tr>
            <td>{{ teacher.name }}</td>
            <td>
                {% for student in teacher.student.all %}
                    <span class="span-tag">{{ student.name }}</span>
                {% endfor %}
            </td>
        </tr>
    {% endfor %}
    </tbody>
</table>

<div class="pane-shade hide"></div>

<div class="pane-add hide">
    <form id="form-add-teacher" method="POST" action="/teacher">
        <div class="group">
            <input id="teacher" type="text" placeholder="teacher name" name="teacher_name">
        </div>

        <div class="group">
            <select id="student_list" name="student_list" multiple>
                {% for student in student_list %}
                    <option value="{{ student.id }}">{{ student.name }}</option>
                {% endfor %}
            </select>
        </div>

        <input type="submit" value="submit">
        <input id="submit-by-ajax" type="button" value="ajax">
        <input class="cancel" type="button" value="cancel">
    </form>
</div>


<script src="/static/jquery-1.12.4.js"></script>
<script>
    $(function () {
        $('.cancel').click(function () {
            $('.pane-shade, .pane-add, .pane-edit').addClass('hide');
        });

        $('#add-teacher').click(function () {
            $('.pane-shade, .pane-add').removeClass('hide');
        });

        $('#submit-by-ajax').click(function () {
            $.ajax({
                url: '/add_teacher_by_ajax',
                data: $('#form-add-teacher').serialize(),
                dataType: "JSON",
                type: 'POST',
                traditional: true,
                success: function (obj) {
                    console.log(obj);
                },
                error: function () {
                }
            })
        });
    })
</script>
</body>
</html>
```





## form Objects 

views.py

```python
from app01 import models
from app01 import forms


def user(request):
    if request.method == 'GET':
        u_dict = {
            'user': 'r1',
            'password': '123123',
            'email': 'sdfsd',
            'city': 1,
            'languages': [2, 3],
        }
        u = forms.User(initial=u_dict)
        return render(request, 'user.html', {'user': u})
    elif request.method == 'POST':
        u = forms.User(request.POST)
        valid = u.is_valid()
        if valid:
            models.UserForm.objects.create(**u.cleaned_data)
        else:
            print(u.errors.as_json())
        return render(request, 'user.html', {'user': u})
```

models.py

```python
from django.db import models


# Create your models here.
class UserForm(models.Model):
    user = models.CharField(max_length=32)
    password = models.CharField(max_length=256)
    email = models.EmailField()
```

forms.py

```
from django import forms
from django.forms import fields
from django.forms import widgets


class User(forms.Form):
    user = fields.CharField(
        error_messages={'required': 'username should not be null'},
        widget=widgets.TextInput(attrs={'class': 'c1', }),
        label='your username',
        initial='scott',
    )
    password = fields.CharField(
        max_length=12,
        min_length=6,
        error_messages={'required': 'password length should not less than 6 or greater than 12'},
        widget=widgets.PasswordInput,
    )
    email = fields.EmailField(
        error_messages={'required': 'email should not be null'},
        widget=widgets.EmailInput,
    )
    city = fields.ChoiceField(
        choices=[(0, 'Beijing'), (1, 'Shanghai'), (2, 'Guangzhou',)],
    )
    languages = fields.MultipleChoiceField(
        initial=[1, 2, ],
        choices=[(0, 'C'), (1, 'Java'), (2, 'Python'), (3, 'C++'), (4, 'JavaScript'), (5, 'R'), (6, 'Go'), (7, 'Rust'),
                 (8, 'Haskell')]
    )
    file = fields.FileField()
```

user.html

```
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>

<body>
<form action="/user/" method="POST">
    {% csrf_token %}
    <table>{{ user.as_table }}</table>
    <input type="submit" value="submit">
</form>

<form action="/user/" method="POST">
    {% csrf_token %}
    <p>{{ user.user }} {{ user.errors.user.0 }}</p>
    <p>{{ user.password }} {{ user.errors.password.0 }}</p>
    <p>{{ user.email }} {{ user.errors.email.0 }}</p>
    <p>{{ user.file }} {{ user.errors.file.0 }}</p>
    {{ user.path }}

    <input type="submit" value="submit">
</form>


<form action="/user/" method="POST">
    {% csrf_token %}
    <p><input type="text" name="user" placeholder="username"> {{ user.errors.user.0 }}</p>
    <p><input type="text" name="password" placeholder="password"> {{ user.errors.pwd.0 }}</p>
    <p><input type="text" name="email" placeholder="email address"> {{ user.errors.email.0 }}</p>
    <input type="submit" value="submit">
</form>

</body>
</html>
```

