---
title: flume
tags: 
  - javaee
date: 2021-10-27 22:28:22
---

* agent就是一个Flume的实例，event是flume定义的一个数据流传输的最小单元。source指的是数据的来源和方式，channel是一个数据的缓冲池，sink定义了数据的输出的方式和目的地。一个完整的agent包含了必须的三个组件source、channel和sink。
* 启动`./bin/flume-ng agent -n agent_name -c conf -f conf/flume-conf.properties.template`。
  * agent 表示启动一个agent，-n 指定agent的名字，-f配置文件的位置 ，-c 配置文件夹的位置。 

* 一个配置文件的例子

``` sh
#设置各个组件的名称
a1.sources=r1
a1.sinks=k1
a1.channels=c1

#监听的主机和端口
a1.sources.r1.type=syslogudp
al.sources.r1.bind=10.2.4.31
a1.sources.r1.port=5145
a1.sources.r1.keepFields=true
#配置Sink
a1.sinks.k1.type=org.apache.flume.sink.kafka.KafkaSink
a1.sinks.k1.kafka.bootstrap.servers=10.2.4.31:9092
a1.sinks.k1.kafka.topic=rawlog

#配置channel
a1.channels.c1.type=memory
#内存channel的容量大小为1000
a1.channels.c1.capacity=1000
#source和sink从内存每次传输的event数量
a1.channels.c1.transactionCapacity=1000


#把source绑定到channel上，一个source可以连接多个channel
a1.sources.r1.channels=c1
#把sink绑定到channel上，一个sink只能连接一个channel
a1.sinks.k1.channel=c1
#启动 
#bin/flume-ng agent -c conf -f example.conf --name a1 -Dflume.root.logger=INFO,console
```

* 通过linux命令发送一条log `logger --udp --port 5140 --server 172.27.32.2 "hello world"`


<!--more-->
