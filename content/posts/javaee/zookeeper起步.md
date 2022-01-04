---
title: zookeeper起步
tags: 
  - javaee
date: 2021-03-27 14:57:57
---

* `zkCli.sh -server localhost:2181`：连接到zookeeper

* 复制模式下的配置小结（以3台linux举例）
  1. 为每一台linux安装上zookeeper
  2. 修改他们的配置文件zoo.cfg（3份可以一样）
  3. 在dataDir路径下创建myid文件，里面写一个数字，与server.x的x对应
  4. 每一台都启动zookeeper

```properties
#zookeeper使用的基本时间单位
tickTime=2000
#存储内存数据库快照的位置
dataDir=/var/lib/zookeeper
#对client端提供服务
clientPort=2181
#超时
initLimit=5
#限制服务器与领导者之间过时的距离
syncLimit=2
#server.X格式列出了组成zookeeper服务的服务器。服务器启动时，它通过在数据目录中查找文件myid*来知道它是哪台服务器。
#2888集群内机器通信使用，3888选举leader使用
server.1=zoo1:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
```

* `zkServer.sh start`：启动zookeeper
* `zkServer.sh status`：查看当前状态
* `zkCli.sh -server 127.0.0.1:2181`：连接到zookeeper
  * `ls /`
  * `create /zk_test my_data`：创建一个新的znode，并将字符串my_data与该节点关联
  * `get /zk_test`：验证数据是否与znode关联
  * `set /zk_test junk`：来更改与zk_test相关的数据
  * `delete /zk_test`

## Znode

* 组成
  * data：Znode存储的数据信息
  * stat：包含Znode的各种元数据，如事务ID、版本号、时间戳、大小等
  * child：当前节点的子节点引用
  * acl：`access control list`访问控制表，表示哪些人或哪些ip可以访问本节点
* Znode是用来存储少量的状态和配置信息，每个节点的数据最大不能超过1MB


<!--more-->
