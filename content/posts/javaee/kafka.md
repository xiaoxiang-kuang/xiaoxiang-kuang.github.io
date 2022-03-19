---
title: kafka
tags: 
  - javaee
date: 2021-10-21 14:15:47
---

## 介绍

* kafka中的消息以主题为单位进行归类，生产者负责将消息发送到特定的topic，消费者负责订阅topic并进行消费。
* topic是一个逻辑上的概念，它可以细分为多个partition（分区），一个partition只属于单个topic（主题）。
* 同一个topic下的不同的partition存放的消息是不同的。消息在被追加到分区文件中会被分配一个特定的偏移量（offset）。offset是消息在partition中唯一的标识，kafka通过offset来保证消息在分区内的顺序性。offset并不跨越分区，也就是说kafka保证的是partition有序而非topic有序。
* partition可以分布在不同的broker上，也就是说一个topic可以横跨多个broker。
* 每一条消息被发送到broker前，会根据分区规则选择存到哪个具体的分区，如果分区规则设置的合理，则所有的消息都可以均匀的分配到不同的分区中。如果一个topic只有一个分区，那么这个这个分区文件所在的机器的I/O将会成为这个topic的性能瓶颈。
* kafka为分区引入了副本（replica）机制，同一个分区的不同副本中保存的是相同的消息。副本之间是一主多从的关系，leader副本负责处理读写请求，follower副本只负责于leader副本的消息同步，当leader副本出现故障时，从follower中重新选举的新leader对外提供服务。

### 消费者

* 一个消费者只属于一个消费组，每一个分区只能被一个消费组中的一个消费者所消费。

## 命令行

``` sh
#启动服务
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#创建有4个partition的topic
kafka-topics.sh --bootstrap-server 10.2.4.31:9092 --create --topic kuangpf-topic --partitions 4 [--replication-factor 1] [--if-not-exists]
#展示topic分区副本的分配细节
kafka-topics.sh --bootstrap-server 10.2.4.31:9092 --describe --topic kuangpf-topic
#向topic中写入event
bin/kafka-console-producer.sh --topic test --bootstrap-server localhost:9092
#读取events
bin/kafka-console-consumer.sh --topic test --from-beginning --bootstrap-server localhost:9092
#获取当前可用的topics
kafka-topics.sh --bootstrap-server 10.2.4.31:9092 --list [--if-exists]
#增加分区数，分区数只能增加不能减少
kafka-topics.sh --bootstrap-server 10.2.4.31:9092 --alter  --topic kuangpf-topic --partitions 5
#查看动态配置
kafka-configs.sh --bootstrap-server 10.2.4.31:9092 --describe --entity-type topics --entity-name kuangpf-topic
#添加配置，多个配置用逗号隔开
kafka-configs.sh --bootstrap-server 10.2.4.31:9092 --alter  --entity-type topics --entity-name kuangpf-topic --add-config max.message.bytes=10000
#删除某个动态配置
kafka-configs.sh --bootstrap-server 10.2.4.31:9092 --alter  --entity-type topics --entity-name kuangpf-topic --delete-config max.message.bytes
#删除一个topic
kafka-topics.sh --bootstrap-server 10.2.4.31:9092 --delete --topic kuangpf-topic [--if-exists]

#性能测试工具
#发送100万条数据，每条消息1024字节，吞吐量大于-时表示当发送的吞吐量大于该值时就会被阻塞一段时间，小于0则不限流
#records sent表示测试时发送的消息总数，records/sec和MB、sec表示吞吐量，avg latency表示消息处理的平均耗时，max latency表示消息的最大耗时。50th表示50%的消息处理耗时，其他的类推。
kafka-producer-perf-test.sh --topic k1 --num-records 100000 --record-size 1024 --throughput -1 --producer-props bootstrap.servers=10.2.4.31:9092
#消费100万条数据
#start.time起始时间、end.time结束时间、data.consumed.in.MB消费的消息总量、每秒拉去的消息的字节大小fetch.MB.sec、fetch.nMsg.sec每秒拉去的消息个数
kafka-consumer-perf-test.sh --topic k1 --messages 1000000 --broker-list 10.2.4.31:9092
```

### java程序案例

```java
public static void main(String[] args) {
    Properties props = new Properties();
    //给程序一个唯一标识符，用于区分和同一个kafka对话的其他程序。
    props.put(StreamsConfig.APPLICATION_ID_CONFIG, "streams-pipe");
    //kafka的地址
    props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
    props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
    props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

    //使用topology构建器构建一个topology
    final StreamsBuilder builder = new StreamsBuilder();
    //创建源流，KStream会不断地从my-input中获取数据
    KStream<String, String> source = builder.stream("my-input");
    //将输入的键和值随意更改，类型也可以修改，返回新的键值对
    source.map(new KeyValueMapper<String, String, KeyValue<String, String>>() {
        @Override
        public KeyValue<String, String> apply(String key, String value) {
            log.info("====> key {}, value{}", key, value);
            return new KeyValue<>(key, value);
        }
    });
    //将数据写入到my-output，TopicNameExtractor可以动态指定topic，但topic必须存在
    source.to(new TopicNameExtractor<String, String>() {
        @Override
        public String extract(String key, String value, RecordContext recordContext) {
            log.info("---->key {}, value {},recordContext {}", key, value, recordContext);
            return "my-output";
        }
    });
    final Topology topology = builder.build();
    //使用上面的两个组件topology和props来构建streams客户端。
    final KafkaStreams streams = new KafkaStreams(topology, props);
    //程序结束前能关闭连接
    Runtime.getRuntime().addShutdownHook(new Thread("streams-shutdown-hook") {
        @Override
        public void run() {
            streams.close();
        }
    });
    //执行此客户端
    streams.start();
}
```

<!--more-->
