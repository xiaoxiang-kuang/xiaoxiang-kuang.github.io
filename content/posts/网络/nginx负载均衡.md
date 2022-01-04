---
title: nginx负载均衡
tags:
  - 网络
date: 2021-09-13 16:09:24
---

nginx支持三种负载均衡的方法：

1. 轮询（round-robin）：按照顺序分配服务。
2. least-connected：下一个请求被分配给连接数最少的服务。
3. ip-hash：通过一个哈希算法来决定一个ip地址访问哪个后台服务，能保证一个ip一定会访问一个相同的后台服务（除非后台服务不可访问）。这种方式解决的问题是：如果某个ip已经登录了某个服务，当用户再次访问时会定位到该服务，解决了会话丢失的问题。

##### 1 轮询算法（默认情况）

```nginx
http {
    upstream myapp1 {
        server example1.com;
        server example2.com;
        server example3.com;
    }
    server {
        listen 80;
        location / {
            proxy_pass http://myapp1;
        }
    }
}
```

##### 2 使用least_comm命令来使用least-connected算法。

```nginx
    upstream myapp1 {
        least_conn;
        server example1.com;
        server example2.com;
        server example3.com;
    }
```

##### 3 使用ip_hash命令来使用ip-hash算法。

```nginx
    upstream myapp1 {
        ip_hash;
        server example1.com;
        server example2.com;
        server example3.com;
    }
```

##### 4 权重

```nginx
upstream myapp1 {
        server srv1.example.com weight=3;
        server srv2.example.com;
        server srv3.example.com;
    }
```


**参考链接：**[Using nginx as HTTP load balancer](http://nginx.org/en/docs/http/load_balancing.html)

<!--more-->
