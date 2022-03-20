---
title: "InnoDB"
date: 2022-03-20T16:14:44+08:00
tags:
  - 数据库
draft: false
---

## InnoDB

* mysql服务器中负责对表中的数据读取和写入工作的部分是存储引擎，真实数据在不同存储引擎中存放的格式一般是不同的。

* innodb会将数据划分为若干个页，以页作为磁盘和内存交互的基本单位，页也是innodb管理存储空间的基本单位，页的默认大小为16KB。一般情况下，一次最少从磁盘中读取16KB的内容到内存中，一次最少把内存中的16KB内容刷新到磁盘中。
* innodb有4中行格式COMPACT、PEDUNDANT、DYNAMIC、COMPRESSED。

```
CREATE TABLE 表名(列的信息) ROW_FORMAT=行格式名称;
ALTER TABLE 表名 ROW_FORMAT=行格式名称;
```

### COMPACT行格式

![COMPACT行格式](/img/数据库/mysql/1.jpg)

1. 记录的额外信息，包含3个部分：变长字段的长度列表、NULL值列表和记录头信息。
   1. mysql支持一些变长的数据类型，如varchar、text和blob，变长数据类型占用的字节数也是不固定的，所以在存储数据时要把这些数据占用的字节数也存起来。一个变长的数据占用的存储空间分为两部分：真正的数据内容和该数据占用的字节数。各变长字段的真实数据占用的字节数按照列的顺序逆序存放。                                             

<!--more-->
