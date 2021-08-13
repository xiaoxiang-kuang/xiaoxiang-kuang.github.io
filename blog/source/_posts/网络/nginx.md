---
title: nginx
categories:
  - [网络]
site: 网络
date: 2021-08-12 10:03:28
---

* nginx默认的配置文件名是nginx.conf，位置在`/usr/local/nginx/conf`、`/etc/niginx`、或`/usr/local/etc/nginx`。
* 当nginx启动后，可以通过`nginx -s signal`来控制nginx，signal可以是：
  * stop：快速关闭；quit：正常关闭；reload：重新加载配置文件；reopen：重新打开配置文件。
* 配置文件可以包含多个`server`块，他们之间通过监听的端口和服务名来区分。一旦nginx决定使用哪个服server来处理请求，他就会根据server块内location的指令来匹配请求头中的url，匹配会选择location前缀最长的那个。当location中有正则表达式时，会优先匹配正则表达式。
* nginx的错误日志文件在`usr/local/nginx/logs`、`/var/log/nginx`
* 使用`proxy_pass`来配置代理服务。代理服务的流程：server接收request->把request传给代理服务->获取代理服务的response->把response返回给客户端。

```nginx
server {
	listen 80;
    location / {
        proxy_pass http://localhost:8080/;
    }
    
    location /tool {
    	root html;
    }
	#正则表达式以~开始
    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

