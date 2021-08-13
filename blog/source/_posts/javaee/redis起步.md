---
title: redis起步
categories:
  - [javaee]
site: javaee
date: 2021-08-13 17:27:55
---
* 高性能key-value数据库
* 支持string、list、set、有序set、hash等数据类型
* 通过`./redis-server [redis.conf] [--port 6379]`启动服务。
* 通过`./redis-cli [-h hostname] [-p port] `连接redis，登录后通过`AUTH password`来输入密码。输入help能查看不少帮助。