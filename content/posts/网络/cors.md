---
title: cors
tags:
  - 网络
  - http
date: 2021-03-24 15:02:16
---

## 跨源资源共享（Cross-Origin Resource Sharing）

* CORS是一种基于HTTP头的机制，该机制通过允许服务器标识除了它自己以外的其他origin（源是协议、主机名和端口号的组合），这样其他origin就可以加载这些资源。
* XMLHttpRequest和Fetch API遵循同源策略。
* `Access-Control-Allow-Origin: *`：允许所有origin访问该资源。

### 同源策略

* 同源是指协议相同、主机名相同、端口相同。
* 非同源会限制Cookie和Ajax

### 访问控制场景

#### 简单请求

* 如果请求的HTTP方法是GET、HEAD、POST，并且该请求只包含一组特定的HTTP头，那么Web浏览器发出的是简单请求。发出简单请求时，该请求将像一般请求一样发送到服务器。

#### 预检请求

* 预检请求会先使用`OPTION`方法发起一个预检请求到服务器，以获知服务器是否允许该实际请求。预检请求的使用可以避免跨域请求对服务器的用户数据产生未预期的影响。当预检不通过，实际的请求将不会发送。

**参考链接：[跨资源共享（CORS）](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS)**


<!--more-->
