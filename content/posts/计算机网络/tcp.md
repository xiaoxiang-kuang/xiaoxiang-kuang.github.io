---
title: tcp
tags:
  - 计算机网络
date: 2020-03-27 16:13:37
---

## TCP特性

* 应用数据被分割为TCP认为最适合发送的数据块
* 当TCP发送一个段后，它启动一个定时器，等待目的端确认收到了这个报文段。如果不能及时收到一个确认，将重发这个报文段
* 当TCP收到发自TCP连接的另一端的数据，它将发送一个确认，这个确认通常将推迟几分之一秒
* TCP将保持他首部和数据的检验和，目的是检测数据在传输过程中是否有变化
* 如果必要TCP将对收到的数据进行重新排序，将收到的数据以正确的顺序交给应用层
* TCP的接收端会丢弃重复的数据
* TCP提供流量控制。TCP连接的每一方都有固定大小的缓存空间。TCP的接收端只允许另一端发送接收端所能接纳的数据

<img src="/img/网络/tcp/1.png">
<!--more-->
