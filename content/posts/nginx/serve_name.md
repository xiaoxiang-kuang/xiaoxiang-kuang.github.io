---
title: "serve_name"
date: 2022-04-05T19:14:13+08:00
tags:
  - nginx
draft: false
---

server_name可以决定使用哪个server块来处理请求，server_name可以是精确的名称、通配符和正则表达式。

```
server {
    listen       80;
    server_name  example.org  www.example.org;
    ...
}

server {
    listen       80;
    server_name  *.example.org;
    ...
}

server {
    listen       80;
    server_name  mail.*;
    ...
}

server {
    listen       80;
    server_name  ~^(?<user>.+)\.example\.net$;
    ...
}
```

当按照域名来访问服务时，如果可以匹配多个server_name，就会按照如下的顺序来进行匹配：

1. 精确的名称。
2. 以星号开头的最长通配符，如`*.exmaple.org`。
3. 以星号结束的最长通配符，如`mail.*`。
4. 第一个匹配的正则表达式(按照在配置文件出现的先后顺序)。

## 通配符

包含星号的通配符只能出现在name的开始或者结束的地方，且只能在点号`.`的旁边。`www.*.example.org`和`w*.example.org`都是非法的。这种情况下可以使用正则表达式。如`~^www\..+\.example\.org$`和`~^w.*\.example\.org$`。星号可以匹配name的好几个部分，如`*.example.org`不仅可以匹配`www.example.org`也可以匹配`www.sub.example.org`。

如`.example.org`这种特殊格式的通配符不仅可以匹配`example.org`，还可以匹配通配符`*.example.org`。

## 正则表达式

nginx使用的正则表达式和Perl编程语言(即PCRE)兼容。如果要使用正则表达式，server_name必须以波浪线开始。

```nginx
server_name ~^www\d+\.example\.net$;`
```

如果不以波浪线开头，它会被认为是一个精确的名称，如果表达式中包含星号，它会被认为是一个通配符名称。`^`和`$`在逻辑上是必须要有的。域名中的`.`需要被转义，因为`.`也是正则的元字符。当正则表达式中包含`{`和`}`时，正则需要被括起来。

```nginx
server_name  "~^(?<name>\w\d{1,3}+)\.example\.net$";
```

否则nginx在启动时会报错。

命名正则表达式捕获组可以当作一个变量使用:

```nginx
server {
    server_name   ~^(www\.)?(?<domain>.+)$;

    location / {
        root   /sites/$domain;
    }
}
```

PCRE支持下面这几种语法

1. `?<name>` 和`?'name'`Perl5.10兼容语法，自PCRE-7.0开始支持。
2. `?P<name>` Python兼容依法，自PCRE-4.0开始支持。

当nginx启动失败并显示以下错误时:

```
pcre_compile() failed: unrecognized character after (?< in ...
```

这表示PCRE库版本太久，可以使用`?P<name>`语法代替。捕获组也可以使用数字形式。

```nginx
server {
    server_name   ~^(www\.)?(.+)$;

    location / {
        root   /sites/$2;
    }
}
```

然而，这种用法仅限于简单的情况，因为数字引用很容易被覆盖。

<!--
## 复杂的name
http://nginx.org/en/docs/http/server_names.html
-->

<!--more-->