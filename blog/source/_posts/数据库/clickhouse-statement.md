---
title: clickhouse-statement
categories:
  - [数据库,clickhouse]
site: 数据库
date: 2021-03-11 17:01:03
---

* 可以在system.data_type_families中检查某个数据类型的名称是否大小写敏感，case_insensitive=1表示大小写不敏感。看完后我建议数据类型的命名首字母建议大写，并采用驼峰命名法。
* 除了标准sql的关键字和许多其他数据库实现的一些关键字，clickhouse其他的关键字都是大小写敏感的！所以如果你发现语句看上去没错，执行就是有问题，看看是不是大小写出问题了。
* 关键字不是保留的，它们仅在相应的上下文中才会被处理。
* 变量名可以使用反引号包含起来。
* 别名在查询和子查询中是全局可见的。

## select

* select子句是在 from、where、group by等所有操作完成后计算的，如果select子句中包含聚集函数，**clickhouse会在执行group by期间处理这些聚集函数**。
* 如果要用re2正则表达式匹配列，可以使用COLUMNS（‘xxx’），这样可以一次匹配多个列（对于是否常用我持否定态度）。
* ARRAY JOIN

  * 对于包含数组列的表来说是一种常见的操作，用于生成一个新表（新表有一列将包含数组中的每一个元素，其他列可能会出现元素重复）。
* DISTINCT
  * 不支持select包含有数组的列
  * 当ORDER BY 被省略且LIMIT被定义时，在读取所需数量的不同行后立即停止运行。
  * DISTINCT在ORDER BY之前执行