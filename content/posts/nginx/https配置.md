---
title: "Https配置"
date: 2022-05-05T15:33:30+08:00
tags:
  - nginx
draft: false
---

# nginx的https配置

## 配置流程

1. 编译nginx需要带上`--with-http_ssl_module`选项。编译失败可能是缺少依赖，安装对应依赖即可。
```
./configure --prefix=/opt/nginx --with-http_ssl_module
make
make install
```

2. 生成证书，在控制台中依次执行以下命令，执行完成后将生成的文件移动到/opt/nginx/ssl下。

openssl genrsa -des3 -out uam.key
```
输入密码:********
再次输入密码:********
```
openssl req -new -key uam.key -out uam.csr
```
输入密码:********
依次输入如下
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:shaanxi
Locality Name (eg, city) []:xian
Organization Name (eg, company) [Internet Widgits Pty Ltd]:xiaoxiang
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

openssl rsa -in uam.key  -out uam.nopass.key
```
输入密码:********
```

openssl req -new -x509 -days 3650 -key uam.nopass.key  -out uam.crt
```
依次输入如下
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:shaanxi
Locality Name (eg, city) []:xian
Organization Name (eg, company) [Internet Widgits Pty Ltd]:xiaoxiang
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
```

3. nginx中http块中添加如下配置：
```
    server {
        listen       443 ssl;

        #使用https，证书位置
        ssl_certificate /opt/nginx/ssl/uam.crt;
        ssl_certificate_key /opt/nginx/ssl/uam.nopass.key;

        location /{
            proxy_pass http://localhost:80; 
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
        #http转发到https
        error_page 497 https://$host:$server_port$request_uri;
        error_page   500 502 503 504  /50x.html;
     }
```

## 配置介绍

### https配置

* nginx配置https，只有listen后面的`ssl`、`ssl_certificate`和`ssl_certificate_key`这三个参数是必须的。

```
server {
    listen              443 ssl;
    server_name         www.example.com;
    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;
    ...
}
```

* `ssl_protocols`和`ssl_ciphers`可以限制SSL/TLS的版本和密码，默认情况下nginx会使用`ssl_protocols TLSv1 TLSv1.1 TLSv1.2`和`ssl_ciphers HIGH:!aNULL:!MD5`，所以一般情况下不需要手动配置。

### https优化

* SSL会消耗额外的CPU资源，在多核的CPU上应该使`worker_processes`配置为不少于CPU核心数的值(可以将该参数设置为auto，这时nginx会自动调整工作进程数为CPU数量)。
* CPU最密集的行为是SSL握手，有两种方式可以降低握手次数：
  * 使用`keepalive_timeout`，使用该参数可以是多个请求通过同一个连接，后面的请求可以复用SSL会话。
  * 通过`ssl_session_cache`可以将会话存储到工作进程之间共享的SSL会话缓存中，1MB的缓存可以包含大约4000个会话，默认缓存超时时间为5分钟，可以使用`ssl_session_timeout`来设置超时时间。

```
worker_processes auto;

http {
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    server {
        listen              443 ssl;
        server_name         www.example.com;
        keepalive_timeout   70;

        ssl_certificate     www.example.com.crt;
        ssl_certificate_key www.example.com.key;
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ...
}
```

### 一个server中包含http和https

* 可以在一个server块中处理http请求和https请求

```
server {
    listen              80;
    listen              443 ssl;
    server_name         www.example.com;
    ssl_certificate     www.example.com.crt;
    ssl_certificate_key www.example.com.key;
    ...
}
```

### 无法使用基于server_name的多个HTTPS服务

* 当为一个IP配置了多个域名时，使用server_name并不能区分这些域名所对应的server块。案例如下：

```
server {
    listen          443 ssl;
    server_name     www.example.com;
    ssl_certificate www.example.com.crt;
    ...
}

server {
    listen          443 ssl;
    server_name     www.example.org;
    ssl_certificate www.example.org.crt;
    ...
}
```

* 这个例子中无论输入哪个域名，浏览器都返回默认的证书(即`www.example.com`的证书)。因为SSL连接是建立在浏览器发送HTTP请求之前，nginx不能知道当前发送请求的是哪个域名，所以它只能返回默认的服务证书。
* 目前的解决方法是为每个HTTPS的server分配一个IP地址。

```
server {
    listen          192.168.1.1:443 ssl;
    server_name     www.example.com;
    ssl_certificate www.example.com.crt;
    ...
}

server {
    listen          192.168.1.2:443 ssl;
    server_name     www.example.org;
    ssl_certificate www.example.org.crt;
    ...
}
```

相关链接 [Configuring HTTPS servers (nginx.org)](http://nginx.org/en/docs/http/configuring_https_servers.html)

<!--more-->