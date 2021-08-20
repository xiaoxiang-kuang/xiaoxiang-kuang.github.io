---
title: cas协议
categories:
  - [网络]
site: 网络
date: 2021-08-19 15:45:06
---

**[CAS详细流程](/img/网络/cas协议/1.png)**

### CAS协议

* central authentication service（中央认证服务），TGT（Ticket Grangting Ticket）。TGC（ticket-granting cookie）、ST（service ticket）
* 流程如下（所有的过程都是重定向）：

1. 用户通过浏览器访问业务系统（就是CAS client，可能是某个微服务）。
2. 业务系统重定向到CAS server。
3. server对用户进行认证，如用户提供了正确的认证信息，server就会创建对应的session（似乎就是TGT），TGC（cookie）是该session的key，server把TGT和生成的ST发给浏览器。
4. 浏览器重新请求该业务系统，同时url上带上了ST=xxx访问业务系统。
5. 业务系统拿到ST后，向Server发起校验，校验成功后生成session和cookie，将cookie发送给浏览器。
6. 浏览器带上该cookie，不带ST向业务系统发出请求。
7. 业务系统验证cookie成功，系统登录成功。

**参考链接：**[CAS - CAS Protocol (apereo.github.io)](https://apereo.github.io/cas/4.2.x/protocol/CAS-Protocol.html)
