---
title: jwt协议
categories:
  - [网络]
site: 网络
date: 2021-08-20 09:57:48
---

* 全称是JSON Web Token。
* jwt由下面三个部分组成，格式类似`aaa.bbb.ccc`
  * Header（头部）
  * Payload（负载）
  * Signature（签名）

---

* Header部分是一个JSON对象，由签名算法和token类型组成，会使用用Base64URL加密，加密后的数据组成jwt的第一部分。原始数据如下（例）：

```json
{
    "alg":"HS256",
    "typ":"JWT"
}
```
* Payload也是一个JSON对象，会用Base64URL加密，加密后的数据组成jwt的第二部分。默认定义了一些参数 iss(ssuer):签发人，exp(expiration):过期时间，sub(subject):主题，aud(audience):受众，nbf(not before):生效时间，iat(issued at):签发时间，jti(jwi id):编号。原始数据如下（例）：

```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
```

* Signature会根据服务端的密钥和Header中给的算法，对加密后的Header和加密后的Payload再次进行加密，将加密的结果组成jwt的第三部分。加密的逻辑如下：
 
```java
HMACSHA256( base64UrlEncode(header) + '.' + base64UrlEncode(payload), secret)
```

---


* 可以在HTTP的headers中的使用，这样就不会有跨域问题了（因为没有使用cookie）：

```properties
Authorization:Bearer <token>
```

**参考链接：**[JSON Web Token Introduction - jwt.io](https://jwt.io/introduction/)
**参考链接：**[JSON Web Token 入门教程 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html)
**解密jwt：**[JSON Web Tokens - jwt.io](https://jwt.io/#debugger-io)

