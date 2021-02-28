---
title: HTTP
categories:
  - [web]
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