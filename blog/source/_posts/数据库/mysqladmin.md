---
title: mysqladmin
categories:
  - [数据库,mysql]
site: 数据库
date: 2021-08-18 16:20:11
---

* mysqladmin可以用来检测服务的配置、创建数据库、关闭mysql服务等。

```shell
mysqladmin [options] command [command-arg] [command [command-arg]]
```

### option

* --host：指定主机。
* --port（-P）：指定端口。
* --user：指定连接用户。
* --version：显示版本信息并退出。
* --wait：如果连接失败，等待并重试。
* --connect-timeout：连接超时的时间。

### command

* create/drop db_name：创建/删除数据库。
* password "new_password"：修改密码，在windows上确保使用双引号"，使用单引号'的话单引号会被识别为密码的一部分。
* shutdown：关闭服务。
* status：显示一个简短的服务状态消息。显示的结果如下：
  * Uptime：mysql运行了多少秒。
  * Threads：客户端连接的线程数（active）。
  * Questions：从服务启动开始客户端查询的数量。
  * Slow queries：查询超过`long_query_time`秒的数量。
  * Opens：服务已经打开了多少张表。
  * Flush tables：`flush-*,refresh,reload`这些指令服务执行的次数。
  * Open tables：当前打开了多少张表。
* version：显示服务的版本信息。

**参考链接（官方）：**[ mysqladmin — A MySQL Server Administration Program](https://dev.mysql.com/doc/refman/5.7/en/mysqladmin.html)
**参考链接（汉化）：**[mysqladmin-MySQL 服务器管理程序 | Docs4dev](https://www.docs4dev.com/docs/zh/mysql/5.7/reference/mysqladmin.html)
