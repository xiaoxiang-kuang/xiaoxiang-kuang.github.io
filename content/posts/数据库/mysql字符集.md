---
title: "Mysql字符集"
date: 2022-02-14T19:06:38+08:00
tags:
  - 数据库
draft: false
---

## 常见字符集

* ASCII：共128个字符，用一个字节编码。
* ISO 8859-1：共收录256个字符，在ASCII的基础上扩充了128个西欧常用字符。这个字符集也有一个别名Latin 1。
* GB2312：收录了6763个汉字以及部分其他编码，兼容ASCII字符集，如果该字符集在ASCII字符集中，则采用一字节编码，否则采用两字节编码。
* GBK：在GB2312的基础上进行了扩充，兼容GB2312。
* UTF-8：几乎收录了当前世界上各个国家和地区使用的字符，而且还在不断扩充，采用变长编码的方式，编码一个字符需要1~4个字节。

## mysql的字符集和比较规则

### utf8和utf8mb4

* utf8mb3：阉割过的utf-8，只使用1~3个字节表示字符。mysql中的utf8就是utf8-mb3的别名。
* utf8mb4：正宗utf-8，使用1~4表示字符。

### 字符集查看

```
SHOW CHARSET [LIKE 'utf8%']
#结果中的maxlen表示此字符集最多需要几个字节表示一个字符。
```

### 比较规则

```
SHOW COLLATION [LIKE 'utf8%']
```

* 比较规则都以与其关联的字符集的名称开头，后面紧跟着该比较规则所应用的语言，如`utf8_polish_ci`表示波兰语的比较规则，`utf8_general_ci`是一种通用的比较规则。名称后缀介绍如下：

| 后缀 | 英文               | 描述               |
| ---- | ------------------ | ------------------ |
| _ai  | accent insensitive | 不区分重音         |
| _as  | accent sensitive   | 区分重音           |
| _ci  | case insensitive   | 不区分大小写       |
| _cs  | case sensitive     | 区分大小写         |
| _bin | binary             | 以二进制的方式比较 |

* 每种字符集都有一个默认的比较规则，是在执行SHOW COLLATION语句返回的结果中Default为YES的比较规则。

## 各级别的字符集和比较规则

* mysql有4个界别的字符集和比较规则

### 服务器级别

* mysql提过了两个系统变量来表示服务器级别的字符集和比较规则：

```
#服务器级别的字符集
SHOW VARIABLES LIKE 'character_set_server'
#服务器级别的比较规则
SHOW VARIABLES LIKE 'collation_server'
```

* 通过修改配置文件来修改这两个值

```
[server]
charset_set_server=utf8
collation_server=utf8_general_ci
```

### 数据库级别

* 有两个变量可以看数据库级别的字符集和编码：`character_set_database`和`collation_database`，使用方式和上面类似。不能使用这两个变量修改当前数据库的字符集和比较规则。

* 创建数据库和修改数据库时指定

```
CREATE DATABASE database1
	[[DEFAULT] CHARACTER SET utf8]
	[[DEFAULT] COLLATE utf8_general_ci]

ALTER DATABASE database1
	[[DEFAULT] CHARACTER SET utf8]
	[[DEFAULT] COLLATE utf8_general_ci]
```

### 表级别

* 可以在创建和修改表的时候指定表的字符集和比较规则。

```
CREATE TABLE table1
	...
	...
	[[DEFALUT] CHARACTER SET utf8]
	[COLLATE UTF8_general_ci]
	
ALTER TABLE table1
	[[DEFALUT] CHARACTER SET utf8]
	[COLLATE UTF8_general_ci]
```

### 列级别

* 创建和修改列的时候可以设置列的字符集和比较规则。

```
CREATE TABLE table1(
	column1 varchar(255) [CHARACTER SET utf8] [COLLATE utf8_general_ci]
);

ALTER TABLE table1 MODIFY column1 varchar(255) [CHARACTER SET utf8] [COLLATE utf8_general_ci];
```

### 补充

* 只修改字符集，则比较规则将修改为修改后的字符集的默认的比较规则。
* 只修改比较规则，则字符集将变为修改后的比较规则对应的字符集。
* 创建或修改列时未显示的指定字符集和比较规则，则该列使用表的字符集和比较规则，如果创建表时未显示的指定字符集和比较规则，则该表默认使用数据库的字符集和比较规则，如果创建数据库时未显示指定字符集和比较规则，则使用mysql服务器的字符集和比较规则。
* mysql5.7及以前的版本，mysql服务器默认的字符集为latin1，mysql8.0后默认字符集为utfmb4。

<!--more-->
