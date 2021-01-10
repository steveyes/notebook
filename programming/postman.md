# postman notes



## Set CSRF Token in Postman

### variant1 - manually

set  `X-CSRFToken` in Headers whose value could be get from Cookies

![1571280732100](../../images/postman_1571280732100.png)



### variant2 -  environmentally

1. set ` csrftoken ` in `environment`

2. then invoked by `X-CSRFToken` in Headers

![1571280996490](..\..\images\postman_1571280996490.png)



### variant3 - automatically

1. put the following script to the `Tests` in postman

```
var csrf_token = postman.getResponseCookie("csrftoken").value;
postman.clearGlobalVariable("csrftoken");
postman.setGlobalVariable("csrftoken", csrf_token);
```

2. then invoked by `X-CSRFToken` in Headers

![1571282406172](..\..\\images\postman_1571282406172.png)