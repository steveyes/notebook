# nginx



## log_format json

applicable for debian9.x

```
    log_format log_json '{'
        # '"@timestamp": "$time_local", '
        '"@timestamp": "$time_iso8601", '
        '"@version":"1", '
        '"client": "$remote_addr", '
        '"referer": "$http_referer", '
        '"uri":"$uri", '
        '"request": "$request", '
        '"status": "$status", '
        '"host": "$host", '
        '"server": "$server_addr", '
        '"size": $body_bytes_sent, '
        '"agent": "$http_user_agent", '
        '"x_forwarded": "$http_x_forwarded_for", '
        '"up_addr": "$upstream_addr",'
        '"up_host": "$upstream_http_host",'
        '"up_resp_time": "$upstream_response_time",'
        '"request_time": "$request_time"'
    '}';
    
    access_log logs/access_json.log	log_json;
```



## root and alias

### what does `root` directive tells nginx

for example, with the following configuration

```
server {
    server_name example.com;
    listen 80;
    
    index index.html;
    root /var/www/example.com;
    
    location / {
        try_files $uri $uri/ = 404;
    }
    
    location ^~ /images {
        root /var/www/static;
        try_files $uri $uri/ = 404;
    }
}
```

nginx will map the request made to:

- `http://example.com/images/favicon.ico` into the path `/var/www/static/images/favicon.ico`
- `http://example.com/images/logo.png` into the path `/var/www/static/images/logo.png`
- `http://example.com/index.html` into the file path `/var/www/example.com/index.html`
- `http://example.com/about/us.html` into the file path `/var/www/example.com/about/index.html`



### what does `alias` directive tells nginx

for example, with the following configuration

```
server {
    server_name example.com;
    listen 80;
  
    index index.html;
    root /var/www/example.com;
  
    location / {
        try_files $uri $uri/ =404;
    }
  
    location ^~ /images {
        alias /var/www/static;
        try_files $uri $uri/ =404;
    }
}
```

nginx will map the request made to:

- `http://example.com/images/favicon.ico` into the path `/var/www/static/favicon.ico`
- `http://example.com/images/third-party/google-logo.png` into the path `/var/www/static/third-party/google-logo.png`
- `http://example.com/index.html` into the file path `/var/www/example.com/index.html`
- `http://example.com/about/us.html` into the file path `/var/www/example.com/about/index.html`



### using root directive over alias directive

for example, if you want to define an alias directive for a location block like the follwing:

```
location /images/ {
    alias /data/w3/images/;
}
```

You should consider defining a `root` directive for that location block:

```
location /images/ {
    root /data/w3;
}
```



### Using alias directive over root directive

We use the alias directive when we want requests made to multiple urls to be served by files contained within the same directory on the server file system.

For instance, if we want requests made for `/images/*` and `/css/*` to be served from alias located in the `/var/www/static` directory, we can use the following configuration set:

```
location ^~ /images {
    alias /var/www/static;
    try_files $uri $uri/ =404;
}
 
location ^~ /css {
    alias /var/www/static;
    try_files $uri $uri/ =404;
}
```

