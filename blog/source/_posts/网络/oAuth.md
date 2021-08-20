---
title: oAuth
categories:
  - [网络]
site: 网络
date: 2021-08-20 16:34:56
---

* oAuth是一种授权机制，数据所有者告诉授权系统，允许第三方应用获取这些数据，授权系统从而产生一个短期的进入令牌（token），第三方应用通过令牌获取数据。

### 授权码方式

第三方应用（记为a）访问CALLBACK_URL这个网站，会重定向到授权系统（记为b），url如1所示

#### 1. 请求授权码

```sql
https://b.com/oauth/authorize?
  response_type=code& #表示参数要求返回授权码
  client_id=CLIENT_ID& #客户端id，b就知道是谁在请求
  redirect_uri=CALLBACK_URL& #b接收请求后跳转的网站
  scope=read #授权范围
```

#### 2. 返回授权码

在授权系统登录成功后，会重定向到`CALLBACK_URL?code=AUTHORIZATION_CODE`，code就是授权码。

#### 3. 请求令牌

CALLBACK_URL这个网站会重定向到授权系统，url如下：

```sql
https://b.com/oauth/token?
 client_id=CLIENT_ID& #客户端id，b就知道是谁在请求
 client_secret=CLIENT_SECRET& 
 grant_type=authorization_code& #授权类型，表明是授权码
 code=AUTHORIZATION_CODE& #上一步拿到的授权码
 redirect_uri=CALLBACK_URL #b之后跳转的网站
```

#### 4. 返回令牌

授权系统会重定向到CALLBACK_URL，并发送一段JSON数据

```json
{  
  "access_token":"ACCESS_TOKEN（令牌）",  
  "token_type":"bearer",
  "expires_in":2592000,
  "refresh_token":"REFRESH_TOKEN",
  "scope":"read",
  "uid":100101,
  "info":{...}
}
```

**参考链接：**[OAuth 2.0 的四种方式 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html)
