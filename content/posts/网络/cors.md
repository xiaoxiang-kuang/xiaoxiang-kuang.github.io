---
title: CORS
tags:
  - 网络
  - http
date: 2021-03-24 15:02:16
---

* 跨源资源共享（Cross-Origin Resource Sharing），CORS是一种基于HTTP头的机制，该机制通过允许服务器标识除了它自己以外的其他origin（源是协议、主机名和端口号的组合），这样其他origin就可以加载这些资源。

* XMLHttpRequest和Fetch API遵循同源策略。
* `Access-Control-Allow-Origin: *`：允许所有origin访问该资源。

## 同源策略

* 同源是指协议相同、主机名相同、端口相同。
* 非同源会限制Cookie和Ajax。

## 访问控制场景

* 浏览器将CORS请求分为两类，简单请求和非简单请求。

### 简单请求

* 如果请求的HTTP方法是GET、HEAD、POST，并且HTTP头部除了被用户代理自动设置的首部字段外，只有Accept-Language、Content-Language、Content-Type ；并且Content-Type 的值仅限于下列三者之一： text/plain、multipart/form-data、application/x-www-form-urlencoded；并且请求中的任意 XMLHttpRequest 对象均没有注册任何事件监听器；XMLHttpRequest 对象可以使用 XMLHttpRequest.upload 属性访问，请求中没有使用 ReadableStream 对象。那么Web浏览器发出的是简单请求。发出简单请求时，该请求将像一般请求一样发送到服务器。
* 简单请求不会触发CORS 预检请求。

### 预检请求

* 预检请求会先使用`OPTION`方法发起一个预检请求到服务器，以获知服务器是否允许该实际请求。预检请求的使用可以避免跨域请求对服务器的用户数据产生未预期的影响。当预检不通过，实际的请求将不会发送。

## HTTP响应首部

### Access-Control-Allow-Origin

```
Access-Control-Allow-Origin: <origin> | *
```

* origin参数的值指定了允许访问该资源的外域URL，对不需要携带身份凭证的请求，服务器可以指定该字段的值为通配符，表示允许来自所有域的请求。
* 如果服务器指定了具体的域名而非"*"，那么响应首部中的Vary字段的值必须包含Origin。这将告诉客户端，服务器对不同的源站返回不同的内容。

### Accsess-Control-Expose-Headers

* 在跨源访问时，XMLHttpRequest对象的getResponseHeaders方法只能拿到Cache-Control、Content-Language、Content-Type、Expires、Last-Modified、Pragma，如果要访问其他头，需要服务器设置响应头。
* Accsess-Control-Expose-Headers头让服务器把允许浏览器访问的头放入白名单。

```
Access-Control-Expose-Headers: X-My-Custom-Header, X-Another-Custom-Header
```

### Access-Control-Max-Age

* 指定了预检的请求的结果能被缓存多久，单位是秒。

```
Access-Control-Max-Age: 3600
```

### Access-Control-Allow-Credentials

* Access-Control-Allow-Credentials 头指定了当浏览器的 credentials 设置为 true 时是否允许浏览器读取 response 的内容。当用在 预检测请求的响应中时，它指定了实际的请求是否可以使用 credentials。简单 GET 请求不会被预检。

### Access-Control-Allow-Methods

* Access-Control-Allow-Methods 首部字段用于预检请求的响应。其指明了实际请求所允许使用的 HTTP 方法。

```
Access-Control-Allow-Methods: <method>[, <method>]*
```

### Access-Control-Allow-Headers

* Access-Control-Allow-Headers 首部字段用于预检请求的响应。其指明了实际请求中允许携带的首部字段。

## HTTP请求首部字段

* 这些首部字段无须手动设置。 当开发者使用 XMLHttpRequest 对象发起跨源请求时，它们已经被设置。

### Origin

```
Origin: <origin>
```

* Origin 首部字段表明预检请求或实际请求的源站。
* origin 参数的值为源站 URI。它不包含任何路径信息。

### Access-Control-Request-Method

```
Access-Control-Request-Method: <method>
```

* 用于预检请求，将实际请求所使用的 HTTP 方法告诉服务器。

### Access-Control-Request-Headers

```
Access-Control-Request-Headers: <field-name>[, <field-name>]*
```
* 将实际请求所携带的首部字段告诉服务器。

**参考链接：[跨资源共享（CORS）](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS)**


<!--more-->
