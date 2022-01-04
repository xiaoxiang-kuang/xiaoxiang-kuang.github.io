---
title: clickhouse集群配置
tags:
  - 数据库
date: 2021-03-17 13:56:31
---

* 查看集群`select * from system.clusters`
* 分片shard是指包含数据不同部分的服务器。要读取所有数据，必须访问所有分片。
* 副本replica是存储复制数据的服务器，要读取所有数据，访问一个切片上的任意副本上的数据即可。

## 集群部署

1. 在群集的所有机器上安装clickhouse服务端

2. 在配置文件中设置群集配置

   ```xml
   <remote_servers>
   	<perftest_1shards_1replicas>
       	<shard>
           	<replica>
               	<host>localhost</host>
                   <port>9000</port>
               </replica>
           </shard>
       </perftest_1shards_1replicas>
   </remote_servers>
   ```

3. 在集群上创建本地表

4. 在集群上创建分布式表

   - 分布式表实际上是一种视图（view），从分布式表中执行select查询会使用集群所有分片的资源。

* `internal_replication`：
  * 当参数为true时，写操作只选择一个正常的副本写入数据。如果表是复制表Replicated*Merge，请使用此方案。
  * 当为false时，写操作会将数据写入所有副本。因为不会检查副本一致性，随着时间的推移，副本数据可能不一样。

## 数据副本

* 对于INSERT和ALTER语句操作数据时会在压缩的情况下被复制。
* CREATE、DROP、ATTACH、DETACH和RENAME语句只会在单个服务器上执行，不会被复制。
  * 可复制表的不同副本可以有不同的名称
* 如果配置文件中没有设置ZooKeeper，则无法创建复制表，并且现在任何现有的复制表都将变为只读。

### 创建复制表

```SQL
CREATE TABLE table_name
(
	EventDate DateTime,
    CounterID UInt32,
    UserID UInt32,
    Ver UInt16
)ENGINE = ReplicatedReplacingMergeTree(zoo_path, replica_name, other_parameters)
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID)
```


<!--more-->
