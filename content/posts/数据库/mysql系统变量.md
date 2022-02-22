---
title: "Mysql系统变量"
date: 2022-02-22T22:41:51+08:00
tags:
  - 数据库
draft: false
---

* mysql有很多的系统变量，能够影响程序的行为，很多命令都能在运行过程中修改。

```
#获取某个变量的信息
show [global | session] variables like 'xxx'

#获取默认存储引擎
show variables like 'default_storage_engine'
#获取默认的最大连接数
show variables like 'max_connections';
```

## 设置系统变量

### 通过命令行设置

```
mysqld --max_connections=10
```

### 通过配置文件设置

```
[server]
max_connections=10
```

### 运行过程中修改

* 许多系统变量分为全局范围（global）和会话范围（session）。
* 并不是所有的变量都有全局范围和会话范围，如max_connections只有全局范围。
* 服务器在启动时会给所有的全局变量一个默认值，当有连接的客户端时，服务器为每个连接的客户端维护一组会话变量，并以全局变量的值初始化。

```
#全局设置存储引擎
set global default_sotrage_engine=MyISAM
#本次会话期间设置存储引擎
set [session] default_storage_engine=MyISAM

#获取会话范围的变量内容
show SESSION VARIABLES LIKE 'default_sotrage_engine'
#不写修饰符默认是session范围，如果一个变量没有session范围则显示global范围的值
show VARIABLES LIKE 'max_connections'
```

## 状态变量

* 状态变量有关服务器的运行情况。
* 状态变量不能人为设置。

```
show [global | session] status like [like 'xxx']

#查看当前有多少客户端与服务器建立了连接。
show status like 'threads_connected'
```

## 补充

* 很多变量不可修改，如`version`。

* 大部分系统变量都可以当启动选项传入。

<!--more-->
