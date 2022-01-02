---
title: logback
categories:
  - [javaee]
site: javaee
date: 2021-08-23 10:10:05
---

### 例：

```xml
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender"> 
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>testFile.log</file>
<!--         将 immediateFlush 设置为 false 可以获得更高的日志吞吐量 -->
        <immediateFlush>false</immediateFlush>
<!--         默认为 ch.qos.logback.classic.encoder.PatternLayoutEncoder -->
        <encoder>
            <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
        </encoder>
    </appender>
    
    <appender name="SYSLOG" class="ch.qos.logback.classic.net.SyslogAppender">
        <syslogHost>remote_home</syslogHost>
        <port>5140</port>
        <facility>AUTH</facility>
        <suffixPattern>[%thread] %logger %msg</suffixPattern>
    </appender>
    
    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>
    <logger name="space.xiaoxiang" level="debug" additivity="true"/>
</configuration>
```

## appender

### AppenderBase

* 是一个抽象类，实现了Appender接口，提供了基本方法供appender使用。

### OutputStreamAppender

* 是ConsoleAppender、FileAppender以及 RollingFileAppender的父类。

### ConsoleAppender

* 将日志输出到控制台，ConsoleAppender通过用户指定的encoder格式化日志事件。

### FileAppender

* 将日志输出到文件中，通过`file`来指定目标文件。

### RollingFileAppender

* 具有轮转日志文件的功能。比如在满足特定的条件后，将日志输出到另一个文件。

### SocketAppender 和 SSLSocketAppender

* 可以将日志传输到远端机器。

### SMTPAppender

* 收集日志到缓冲区中，当用户指定的事件发生时，将从缓冲区中取出适当的内容进行发送。

### DBAppender

* 将日志插到三张数据库表中，三张表分别是logging_event, logging_event_property 与 logging_event_exception。

### SyslogAppender

* 可以将日志发送给远程的syslog守护线程。
* 日志事件的严重程度是根据日志事件的级别转换来的，DEBUG被转换为7，INFO被转换为6，WARN为4，ERROR为3。

### SiftingAppender

* 根据给定的运行时属性分离或者过滤日志。

### AsyncAppender

* 作为一个事件调度器存在，必须调用其他appender来完成操作。

## encoder

* encoder将日志事件转换为字节数组，同时将字节数组写入到一个OutputStream中。
* PatternLayoutEncoder是目前唯一真正有用的encoder，它仅包裹了一个PatternLayout就完成了大部分的工作。

## layout

* layout负责将日志事件转化为字符串。

### PatternLayout

* 可以通过调整PatternLayout的转换模式来进行定制，PatternLayout的转换模式由字面量和转换说明符组成，每一个转换说明符由一个百分号开始`%`，后面跟随格式修改器，以及可用大括号括起来的转换字符和可选的参数。格式修改器可以对字段进行对齐，修改最大最小宽度等。
* 括号用于对转换模式进行分组，`(`和`)`都有特殊的含义。



* 名为`com.foo`的logger是名为`com.foo.bar`的logger的父级。（命名层次结构）
* root logger的默认层级为DEBUG。
* 层级的排序：TRACE < DEBUG < INFO < WARN < ERROR。
* appender具有叠加性：logger L的日志输出会遍历L和它父级中所有的appender，如果L的某个上级P，P设置了additivity=false，那么L的日志输出会遍历从L到P（不包括P）的所有appender。additivity默认为true。

### logback初始化步骤

1. 在类路径下寻找名为logback-test.xml。	
2. 如果没找到，找名为logback.groovy的文件。
3. 如果没找到，找名为logback.xml的文件。
4.  如果没找到，会用ServiceLoader工具去解析`META-INF\services\ch.qos.logback.classic.spi.Configutator`路径下实现了Configurator接口的类
5. 如果还没找到，logback会通过BasicConfigurator为自己进行配置，日志将会全部打印在控制台。
