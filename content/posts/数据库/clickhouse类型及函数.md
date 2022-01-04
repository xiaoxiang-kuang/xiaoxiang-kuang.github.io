---
title: clickhouse类型及函数
tags:
  - 数据库
date: 2021-03-25 14:35:49
---

## 类型

### Decimal(P,S), Decimal32(S), Decimal64(S), Decimal128(S)

* 有符号的**定点数**，可在加减乘中保持精度，除法的最低有效数字会被丢弃（不舍入）

#### 参数

* P表示精度，有效范围是[1:38]，决定可以有多少个十进制的数字
* S表示规模，有效范围是[0:P]，决定数字的小数部分中包含的小数位数
* P[1:9]对应Decimal32(S)
* P[10:18]对应Decimal64(S)
* P[19:38]对应Decimal128(S)
* [精度](https://clickhouse.tech/docs/zh/single/#decimalp-s-decimal32s-decimal64s-decimal128s)

## 函数

### parseDateTimeBestEffort(time_string[, time_zone])

* 把其他类型的时间日期转换为DateTime数据类型。
* 支持的格式：`timestamp` `YYYYMMDDHHMMSS ` `DD/MM/YYYY hh:mm:ss ` `YYYY-MM-DD hh:mm:ss`等

### SHOW CREATE TABLE

* 返回创建该表的语句

### 类型转换

* clickhouse是强类型，他不会在类型之间进行隐式转换。

### toTypeName(x)

* 返回该参数的类型


<!--more-->
