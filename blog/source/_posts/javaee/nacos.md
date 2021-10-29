---
title: nacos
categories:
  - [javaee]
site: javaee
date: 2021-10-28 09:19:42
---

* 服务注册：`curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=xiaoxiang&ip=192.168.1.2&port=8080'`。
* 服务发现：`curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'`
* 发布配置：`curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=HelloWorld"`

* 获取配置：`curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"`

