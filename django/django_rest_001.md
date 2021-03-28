# django rest 001

> introduction

[toc]

## initialize

[django_initialize](./django_initialize.md)



## create app

```
cd $BASE_DIR
python3 manage.py startapp app01
```



## settings.py

```
INSTALLED_APPS = (
    ...
    'rest_framework',
    'rest_framework.authtoken',
    'app01',
)

REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAdminUser',
    ],
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.TokenAuthentication',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 10,
}
```



## migrate

```
cd $BASE_DIR
python manage.py makemigrations app01
python manage.py migrate
```



## serializers

$BASE_DIR/app01/serializers.py

```
from django.contrib.auth.models import User, Group
from rest_framework import serializers


class UserSerializer(serializers.HyperlinkedModelSerializer):
    url = serializers.HyperlinkedIdentityField(view_name='app01:user-detail')

    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'groups',)


class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Group
        fields = ('url', 'name',)
```



## views

$BASE_DIR/app01/views.py

```
from django.contrib.auth.models import User, Group
from rest_framework import viewsets

from .serializers import UserSerializer, GroupSerializer


# Create your views here.
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer


class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
```



## way #1, make router urls in project level

$CONF_DIR/urls.py

```
from django.contrib import admin
from django.urls import include, path
from rest_framework import routers
from rest_framework.authtoken import views as authtoken_views

from app01 import views as app01_views

router = routers.DefaultRouter()

router.register('users', app01_views.UserViewSet, )
router.register('groups', app01_views.GroupViewSet, )

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework'), ),
    path('api-token-auth', authtoken_views.obtain_auth_token, ),
    path('', include((router.urls, 'app01'), namespace='app01')),       # new style
    # path('', include((router.urls, 'app01'), namespace='app01')),     # old style
]
```

$BASE_DIR/app01/urls.py

```
from .apps import App01Config

app_name = App01Config.name
```

curl

```
url=http://${SERVER_IP}:${SERVER_PORT}/api-token-auth/
token=$(curl --request POST \
  --url $url \
  --header 'Content-Type: multipart/form-data' \
  --header 'Content-Type: multipart/form-data; boundary=---011000010111000001101001' \
  --form username=admin \
  --form password=123456)
  
token_str=$(echo $token | awk -F'"' '{print $4}')

url=http://${SERVER_IP}:${SERVER_PORT}/users/
curl --request GET \
  --url $url \
  --header "Authorization: Token $token_str"
```

httpie

```
token=$(http POST http://${SERVER_IP}:${SERVER_PORT}/api-token-auth/ username='admin' password='123456' | awk -F'"' '/token/ {print$4}')

http GET http://${SERVER_IP}:${SERVER_PORT}/app01/users/ "Authorization: Token $token"
```



## way #2, make router urls in app level

$CONF_DIR/urls.py

```
from django.contrib import admin
from django.urls import include, path
from rest_framework.authtoken import views as authtoken_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework'), ),
    path('api-token-auth/', authtoken_views.obtain_auth_token, ),
    path('app01/', include(('app01.urls', 'app01'), namespace='app01')),
]
```

$BASE_DIR/app01/urls.py

```
from django.urls import include, path
from rest_framework import routers

from app01 import views
from .apps import App01Config

router = routers.DefaultRouter()

router.register('users', views.UserViewSet)
router.register('groups', views.GroupViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

app_name = App01Config.name
```

curl:

```
url=http://${SERVER_IP}:${SERVER_PORT}/api-token-auth/
token=$(curl --request POST \
  --url $url \
  --header 'Content-Type: multipart/form-data' \
  --header 'Content-Type: multipart/form-data; boundary=---011000010111000001101001' \
  --form username=admin \
  --form password=123456)
  
token_str=$(echo $token | awk -F'"' '{print $4}')

url=http://${SERVER_IP}:${SERVER_PORT}/${APP_NAME}/users/
curl --request GET \
  --url $url \
  --header "Authorization: Token $token_str"
```

httpie

```
token=$(http POST http://${SERVER_IP}:${SERVER_PORT}/api-token-auth/ username='admin' password='123456' | awk -F'"' '/token/ {print$4}')

http GET http://${SERVER_IP}:${SERVER_PORT}/app01/users/ "Authorization: Token $token"
```

