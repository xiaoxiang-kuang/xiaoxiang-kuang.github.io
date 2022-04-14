---
title: http状态码
tags:
  - http
date: 2021-08-17 15:47:27
---

## 消息响应

* `101 Switching Protocol` 表示正在切换协议。

``` http
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
```

## 成功响应

* `200 OK`请求成功。
* `201 CREATED`请求已成功，通常是POST、PUT请求后返回的响应。

## 重定向

* `301 MOVED PERMENENTLY`请求的资源已经被永久移动到新位置。
* `302 FOUND`重定向是临时的。
* `304 Not Modified` 当文档内容没有修改，服务器会返回这个状态码，304响应禁止包含消息体。

## 客户端响应

* `400 BAD REQUEST`请求参数有误。
* `401 UNAUTHORIZED`当前请求需要用户验证。
* `403 FORBIDDEN`服务器已经理解请求，但是拒绝执行。
* `404 NOT FOUND`请求资源未找到。
* `405 Method Not Allowed` 请求方法不能被用于请求相应的资源。该响应必须返回一个Allow头用以表述当前资源能够接受的请求方法的列表。
* `414 URI Too Long` 请求的URI长度超过了服务器能够解释的长度，因此服务器拒绝对该请求提供服务。通常是因为超过了GET方法传输数据的上限，可以改为POST方法。

## 服务端响应

* `500 INTERNAL SERVER ERROR`服务器内部错误。
* `502 BAD GATEWAY`服务器作为网关需要得到处理该请求的响应，但得到了一个错误的响应。
* `503 SERVICE UNAVILABLE`服务器没有准备好处理请求。

**参考链接：**[HTTP 响应代码 - HTTP | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status)

<!--more-->
