---
title: logback
categories:
  - [javaee]
site: javaee
date: 2021-08-23 10:10:05
---

* 名为`com.foo`的logger是名为`com.foo.bar`的logger的父级。（命名层次结构）
* 对于一个给定名为L的层级，他的有效层级为从自身开始一直回溯到root logger，直到找到第一个不为空的层级作为自己的层级。
* root logger会有一个默认层级：**DEBUG**。
* 层级的排序：TRACE < DEBUG < INFO < WARN < ERROR。
* 输出的目的地就是Appender。
* appender具有叠加性：logger L的日志输出会遍历L和它父级中所有的appender，如果L的某个上级P，P设置了additivity=false，那么L的日志输出会遍历从L到P（不包括P）的所有appender。additivity默认为true。
* 设置additivity为false的Logger的appender只有自己。
* 为了避免拼接字符串带来的性能损耗，可以通过以下方式解决：

```java
logger.debug("this is {}", str);
```

* logback初始化步骤

   1. 在类路径下寻找名为logback-test.xml。	
   2. 如果没找到，找名为logback.groovy的文件。
   3. 如果没找到，找名为logback.xml的文件。
   4.  如果没找到，会用ServiceLoader工具去解析`META-INF\services\ch.qos.logback.classic.spi.Configutator`路径下实现了Configurator接口的类？？？
   5. 如果还没找到，logback会通过BasicConfigurator为自己进行配置，日志将会全部打印在控制台。

* 一个`<logger>`必须包含一个name属性，一个可选的level，一个可选的additivity，可以包含0或者多个`<appender-ref>`属性。
* `<root>`只支持一个属性level，可以包含0或者多个`<appender-ref>`属性。
