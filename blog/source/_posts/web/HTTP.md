---
title: http
categories:
  - [web]
site: web
date: 2021-02-28 13:44:27
---

## HTTP概述

* HTTP是一种client-server协议，由客户端发出的消息叫request，被服务端响应的消息叫response。
* HTTP并不需要底层的传输协议是面向连接的，只要它是可靠的就可以。因此，HTTP依赖于面向连接的TCP进行消息传递，但连接并不是必须的。
* 在client与server进行交互之前，必须在这两者之间建立TCP连接，打开一个TCP连接需要多次往返交换消息（因此耗时）。HTTP/1.0默认为每一对HTTP请求/响应都单独打开一个TCP连接。当需要连续发起多个请求时，这个模式比多个请求共享一个TCP连接更低效。

### HTTP能控制什么

#### 一、缓存

* 常见的HTTP缓存只能存储GET响应。缓存的关键主要包括request method和目标url。

##### 缓存控制(HTTP/1.1定义的Cache-Control)

* `Cache-Control:no-store` ：没有缓存。缓存中不得存储任何关于客户端请求和服务端响应的内容。每次由客户端发起的请求都会下载完整的响应内容。
* `Cache-Control:no-cache`：缓存但重新验证。此方式下，每次有关请求发出时，该请求会带有与本缓存相关的验证字段，服务端会验证请求中所描述的缓存是否过期，如未过期（返回状态码304），则使用本地缓存副本。
* `Cache-Control:private`**|**`Cache-Control:public` ：私有和公共缓存。private表示该响应是专用于某个用户的，中间人不能缓存此响应；public表示该缓存可以被任何中间人缓存。
* `Cache-Control:max-age=31536000`：过期。表示资源能被缓存的最大时间，max-age是距离请求发起的时间的秒数。
* `Cache-Control:must-revalidate`：验证方式。must-revalidate意味着在考虑使用一个陈旧的资源时，必须先验证它的状态，已过期的缓存将不被使用。
* `Pragme`是HTTP/1.0定义的一个header属性，请求头中包含Pragme的效果与`Cache-Control:no-cache`相同，但是HTTP响应头中没有明确定义这个属性。

#### 二、开放同源限制

* 只有来自相同来源的网页才能够获取网站的全部信息。HTTP可以通过修改头部来开放这样的限制。

#### 三、认证

* 一些页面能被保护起来，仅让特定的用户进行访问。基本的认证功能可以直接通过HTTP提供。

#### 四、代理和隧道

* 通常服务器或客户端都是处于内网，对外网隐藏真实IP。因此HTTP请求就要通过代理越过这个网络屏障。

##### 正向代理

* 也可以叫网关，它存储并转发网络服务（如DNS、网页）以减少和控制大家使用的带宽。
* 正向代理代表客户端，可以隐藏客户端的身份。

##### 反向代理

* 反向代理代表服务器，可以隐藏服务器的身份。
* 作用：
  * 负载均衡：在多个服务器之间分发负载，
  * 缓存静态内容：缓存静态内容，为服务器分担压力，
  * 压缩：压缩和优化内容以加快传输的速度。



* 代理可以将请求地址设置为自身的ip。
* `Forwarded`（标准化版本）首部包含了代理服务器的客户端的信息。
  * 语法：`Forwarded:by=<identifier>;for=<identifier>;host=<host>;proto=<http|https>`
  * identifier可以是：①ip地址；②语义不明的标识符；③unknown。
  * `by=<identifier>`该请求进入代理服务器的接口。
  * `for=<identifier>`发起请求的客户端以及代理链中的一系列的代理服务器（这意味着要写多个for=）。
  * `host=<host>`代理接收到的Host首部（Host请求指明了请求将要发送到的服务器主机名和端口号）的信息。
  * `proto=<http|https>`表示发起请求时采用的何种协议。
* `X-Forwarded-For`：在客户端访问服务器的过程中，如果需要经过HTTP代理或者负载均衡服务器，可以使用该参数来获取最初发起请求的客户端的IP地址。
  * 语法：`X-Forward-For:<client>,<proxy1>,<proxy2>...`。
  * 第一个参数表示客户端的IP地址，如果一个请求经过了多个代理服务器，那么每一个代理服务器的IP都会被依次记录在内。
* `X-Forwarded-Host`：用来确定客户端发起请求中使用Host指定的初始域名
  * `Host`：Host请求头指明了请求将要发送到的服务器的主机名和端口号，所有**HTTP/1.1请求报文中必须包含一个Host头字段**。
* `X-Forwarded-Proto`：用来确定客户端与代理服务器或者负载均衡服务器之间连接所采用的传输协议。

### HTTP报文

* 对于一些像post这样的方法，报文的body就包含了要发送的资源。

https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Overview