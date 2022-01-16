---
title: redis起步
tags: 
  - javaee
date: 2021-08-13 17:27:55
---
* 高性能key-value数据库
* 支持string、list、set、有序set、hash等数据类型
* 通过`./redis-server [redis.conf] [--port 6379]`启动服务。linux下redis可以通过`redis-server --daemonsize yes`来后台运行。
* 通过`./redis-cli [-h hostname] [-p port] `连接redis，登录后通过`AUTH password`来输入密码。输入help能查看不少帮助。

* redis-benchmark：性能测试工具，redis-check-aof：修复有问题的AOF文件，redis-check-dump：修复有问题的dump.rdb文件；redis-sentinel：redis集群使用；redis-server：redis服务启动命令；redis-cli：客户端，操作入口。

### redis键（key）

* keys * 查看当前库中的所有key。
* exists key 判断某个key是否存在
* type key 查看key是什么类型
* del key 删除指定的key数据。
* unlink key 根据value选择非阻塞删除。
* expire key 10  给key设定10秒的过期时间
* ttl key 查看还有多少秒过期，-1表示永不过期，-2表示已过期。
* select index 切换数据库，默认有16个库。
* dbsize 查看当前库key的数量。
* flushdb 删除当前库。
* flushall 删除所有库。

## 数据类型

### string

* String是二进制安全的，意味着string可以包含任何数据，比如图片或者序列化的对象。
* string是redis最基本的数据类型，一个redis字符串最多可以是512m。
* set key value 设置值
* get key 获取key对应的值
* append key value 将给定的value追加到原值的末尾。
* strlen key 获取值的长度。
* setnx key value 只有当key不存在的时候才设置key的值。
* incr key key的值加一。
* decr key key的值减一。
* incrby key 步长 key的值加步长。
* decrby key 步长 key的值减步长。
* mset key1 value1 key2 value2 同时设置多个键值对。
* mget key1 key2 同时获取多个键值对。
* msetnx key1 value1 key2 value2 同时设置多个键值对，当有一个key存在的时候，所有的设置都会失败。
* getrange key 起始位置 结束位置 获取从起始位置到结束位置的值。左闭右闭。
* setrange key 开始位置 value 用value覆盖key所存储的字符串，从起始位置开始。
* setex key 过期时间 value 设置键值对的同时设置过期时间，单位是秒。
* getset key value 以新值换旧值，设置了新的值的同时获取旧值。
* String内部采用类似arraylist的机制，字符串实际分配的空间一般高于字符串的长度，当字符串长度小于1M时，扩容都是加倍的，超过1M时，每次扩容都是只增加1M。最大为512M。

<!--more-->
