---
title: Monitor
categories:
  - [java,java并发]
site: java
date: 2020-10-12 19:18:56
---

### java对象头

32位虚拟机下

* 普通对象

![普通对象](/img/Monitor/1.jpg)

* 数组对象

![数组对象](/img/Monitor/2.jpg)

* mark word结构

![mark word结构](/img/Monitor/3.jpg)

* 64位虚拟机下mark word结构

![64位虚拟机下mark word结构](/img/Monitor/4.jpg)

### Monitor

* 每个java对象都可以关联一个monitor对象，monitor对象由操作系统提供。如果使用synchronized给对象上锁（重量级）后，该对象对象头的mark word中的数据就会清空（不包括标志位，但标志位会发生改变），然后指向一个monitor对象。
