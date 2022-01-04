---
title: clickhouse-statement
tags:
  - 数据库
date: 2021-03-11 17:01:03
---

* 可以在system.data_type_families中检查某个数据类型的名称是否大小写敏感，case_insensitive=1表示大小写不敏感。看完后我建议数据类型的命名首字母大写，并采用驼峰命名法。
* 除了标准sql的关键字和许多其他数据库实现的一些关键字，clickhouse其他的关键字都是大小写敏感的！所以如果你发现语句看上去没错，执行就是有问题，看看是不是大小写出问题了。
* 关键字不是保留的，它们仅在相应的上下文中才会被处理。
* 变量名可以使用反引号包含起来。
* 别名在查询和子查询中是全局可见的。

### select

* select子句是在 from、where、group by等所有操作完成后计算的，如果select子句中包含聚集函数，**clickhouse会在执行group by期间处理这些聚集函数**。
* 如果要用re2正则表达式匹配列，可以使用COLUMNS（‘xxx’），这样可以一次匹配多个列（对于是否常用我持否定态度）。
* 当FROM被省略时，数据从system.one表中读取
* ARRAY JOIN

  * 对于包含数组列的表来说是一种常见的操作，用于生成一个新表（新表有一列将包含数组中的每一个元素，其他列可能会出现元素重复）。
* DISTINCT
  * 不支持select包含有数组的列
  * 当ORDER BY 被省略且LIMIT被定义时，在读取所需数量的不同行后立即停止运行。
  * DISTINCT在ORDER BY之前执行

### alter

* 仅支持MergeTree家族，Merge以及Distributed等引擎表。
* alter操作会阻塞对表的所有读写操作。

#### 列操作

* 增加列
  * `ADD COLUMN [IF NOT EXISTS] name [type]  [default_expr] [codec] [AFTER name_after]`
  * 使用指定的name、type、codec以及default_expr往表中增加新的列。
  * 如果sql中包含IF NOT EXISTS，执行语句如果已存在，则clickhouse不会报错，不能将新的列添加到表的开始位置，当指定了AFTER name_after，则会将新的列添加到指定列的后面。
  * 添加列仅仅是改变原有表的结构，不会对已有数据产生影响。
* 删除列
  * `DROP COLUMN [IF EXISTS] name`
* 清空列
  * `CLEAR COLUMN [IF EXISTS] name IN PARTITION partition_name`
  * 重置指定分区中的值。
* 增加注释
  * `COMMENT COLUMN [IF EXISTS] name 'comment'`
  * 每个列都可以包含注释，注释信息在DESCRIBE table中查看
* 改变列的值类型，默认表达式，TTL
  * `MODIFY COLUMN [IF EXISTS] name [type] [default_expr] [TTL] `
  * 当改变列的类型时，列的值也被转换了，如同对列使用toType函数一样，执行起来要花费很长时间。


<!--more-->
