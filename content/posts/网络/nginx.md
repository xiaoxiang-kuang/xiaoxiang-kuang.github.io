---
title: nginx
tags:
  - 网络
  - nginx
date: 2021-08-12 10:03:28
---

* nginx默认的配置文件名是nginx.conf，位置在`/usr/local/nginx/conf`、`/etc/niginx`、或`/usr/local/etc/nginx`。通过`nginx -c xxx.conf`来指定配置文件。
* 当nginx启动后，可以通过`nginx -s signal`来控制nginx，signal可以是：
  * stop：快速关闭；quit：正常关闭；reload：重新加载配置文件；reopen：重新打开配置文件。
* 配置文件可以包含多个`server`块，他们之间通过监听的端口和服务名来区分。一旦nginx决定使用哪个服server来处理请求，他就会根据server块内location的指令来匹配请求头中的url，①精确匹配优先级最高，遇到就返回结果；②普通匹配会选择location中前缀最长的那个，和顺序无关；③当location中有正则表达式时，会优先匹配正则表达式（正则级别比普通匹配优先级高，但比精确匹配优先级低），正则表达式的匹配顺序按照文件中的物理顺序匹配，只要匹配到一条正则，就会返回结果；如果没有匹配，就会取普通匹配中最匹配的那个。
* nginx的错误日志文件在`usr/local/nginx/logs`、`/var/log/nginx`
* 使用`proxy_pass`来配置代理服务。代理服务的流程：server接收request->把request传给代理服务->获取代理服务的response->把response返回给客户端。
* proxy_pass有两个要注意的点
  * proxy_pass后面如果跟了一个完整的url，如`http://localhost:8080/xxx`，那么最后访问的时候就是location中匹配的那一部分替换成proxy_pass的url。
  * proxy_pass后面如果跟的是如`http://localhost:8080`，那么最后访问的是proxy_pass的链接加上请求路径。

```nginx
server {
	listen 80;
    #最后的地址就是http://localhost:8080/journey/xxx
    location /journey {
        proxy_pass http://localhost:8080;
    }
    
    #最后的地址就是http://localhost:8080/test/xxx，location对应的chat会被替换为url。
    location /chat {
        proxy_pass http://localhost:8080/test;
    }
    
    #将会映射到/html/tool这个路径下
    location /tool {
    	root html;
    }
    #正则表达式以~开始，这里是匹配图片
    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```

**参考链接：**[Beginner’s Guide (nginx.org)](http://nginx.org/en/docs/beginners_guide.html)

### nginx内嵌的一些变量

```nginx
#等于在proxy_pass指令中指定的被代理服务的主机名和端口
$proxy_host
#等于在proxy_pass中指定的服务的端口，或者是其服务的默认端口
$proxy_port
#如果X-Forwarded-For属性未在请求头中，$proxy_add_x_forwarded_for的值就等于$remote_addr;
#如果X-Forwarded-For在请求头中，那$proxy_add_x_forwarded_for的值就等于上一个$proxy_add_x_forwarded_for加上",$remote_addr"。
#例：proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for
$proxy_add_x_forwarded_for
```

### nginx指令

* rewrite 

```sh
语法: rewrite regex replacement [flag];
context: server,location,if
rewrite指令按照它出现的顺序来执行，可以通过flag来终止执行，如果replacement以"http://,https://或者$scheme"开始，就会直接返回客户端。
flag可以是last、break、redirect、permanent。
redirect是暂时重定向302，permanent是永久重定向301。

rewrite ^(.*)$ https://localhost$1 permanent;
```

* if

```sh
语法: if(condition) {...}
context: server, localtion
condition包括：
  1. 变量名，当变量为空或者为"0"时是false；
  2. 变量和字符串通过"="或者"!="来比较；
  3. 变量和正则表达式比较【比较符号： ~（大小写敏感）、~*（大小写）不敏感、!~、!~*】，可以通过()来捕获数据。
  4. 使用-f 或!-f检测文件书否存在；
  5. 使用-d 或!-d检测目录是否存在；
  6. 使用-e 或!-e 检测文件、目录、符号连接是否存在；
  7. 使用-x 或!-x 检测是否是可执行文件。
  
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break;
}

if ($http_cookie ~* "id=([^;]+)(?:;|$)") {
    set $id $1;
}

if ($request_method = POST) {
    return 405;
}
```

* return 

```sh
语法: return code [text];
     return code URL;
     return URL;
context: server,location,if
返回特定的状态码，返回444会不发送响应头就关闭连接。
可以指定一个重定向的URL（301，302，303，307，308），或者响应体text（其他的code）。
```

* set

```sh
语法: set $variable value;
context: server,location,if
给变量赋值，值可以是变量、字符串或者变量和字符串的组合。
```




<!--more-->
