---
title: Dockerfile
tags: 
  - javaee
date: 2021-12-06 10:47:48
---

* 一个Dockerfile大部分情况下以FROM指令开始，FROM指令指定了构建的父镜像。
* `ENV`用来设置环境变量，通过`${xxx}`的方式使用。
* CMD在docker run时运行，RUN在docker build时运行。
* RUN会在新的一层执行命令。



<!--

https://docs.docker.com/engine/reference/builder/#parser-directives

-->
<!--more-->
