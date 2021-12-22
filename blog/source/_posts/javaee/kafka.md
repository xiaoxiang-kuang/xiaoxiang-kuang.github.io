---
title: kafka
categories:
  - [javaee]
site: javaee
date: 2021-10-21 14:15:47
---

## 命令行

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

