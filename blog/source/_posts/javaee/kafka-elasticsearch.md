---
title: kafka&elasticsearch
categories:
  - [javaee]
site: javaee
date: 2021-10-21 14:15:47
---

## kafka

``` sh
#启动服务
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#创建一个topic，存event
bin/kafka-topics.sh --create --topic test --bootstrap-server localhost:9092
#向topic中写入event
bin/kafka-console-producer.sh --topic test --bootstrap-server localhost:9092
#读取events
bin/kafka-console-consumer.sh --topic test --from-beginning --bootstrap-server localhost:9092
```

## elasticsearch

``` sh
#启动elasticsearch
./bin/elasticsearch
#测试elasticsearch是否启动运行
curl http://127.0.0.1:9200
```

