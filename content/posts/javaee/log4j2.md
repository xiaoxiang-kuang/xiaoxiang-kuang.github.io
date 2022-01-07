---
title: "Log4j2"
date: 2022-01-07T13:39:30+08:00
tags:
  - javaee
draft: false
---

### log4j2文件加载顺序

1. 检查是否配置了log4j2.configurationFile系统属性，如果设置了，就会尝试使用匹配文件后缀的ConfigurationFactory去加载配置。该配置不限制为本地文件，也可以包含URL。
2. 在classpath路径下找log4j2-test.properties。
3. 在classpath路径下找log4j2-test.ymal 或log4j2-test.yml文件。
4. 在classpath路径下找log4j2-test.json或Log4j2.jsn文件。
5. 在classpath路径下找log4j2-test.xml。
6. 在classpath路径下找log4j2.properties文件。
7. 在classpath路径下找log4j2.ymal或log4j2.yml文件。
8. 在classpath路径下找log4j2.json或log4j2.jsn文件。
9. 在classpath路径下找log4j2.xml文件。
10. 如果没有找到配置文件，则会使用默认配置，将日志输出到控制台。
