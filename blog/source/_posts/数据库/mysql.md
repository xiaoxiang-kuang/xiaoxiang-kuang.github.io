---
title: 'mysql'
categories:
  - [数据库,mysql]
site: 数据库
date: 2021-02-04 15:58:03
---

* 查询版本和当前时间`select version(),current_date;`
* mysql执行结束后会显示返回了多少行和用了多长时间，受网络其他因素影响
* 用作计算器`select sin(pi()/4),(4+1)*5);`
* 当输入多行，打算不执行这句sql语句，输入`\c`
* 自带的的mysql database描述了用户的访问权限。
* unix下数据库名是大小写相关的。建议在创建数据库的时候要么全大写，要么全小写。
* 查看当前账户拥有的权限，可以使用`show grants for 'joe'@'home.example.com'`。

### 基础SQL

#### 数据类型


* 整数数据类型
  * tinyint（1字节）、smallint（2字节）、mediumint（3字节）、int（4字节）、bigint（8字节）。
* 定点数据类型

  * `decimal(5,2)`，其中5是精度，表示有效位数；2表示小数点后几位。
* 浮点类型

  * float（4字节）、double（8字节）。
* 日期和时间类型

  * DATE（YYYY-MM-DD）、DATETIME（YYYY-MM-DD hh:mm:ss）、TIMESTAMP（范围是UTC1970-01-01 00:00:01~UTC2038-01-19 03:14:07)、TIME（范围-838:59:59~838:59:59）、YEAR（范围是1901~2155）
* 字符串类型

  * CHAR（长度为声明时的长度，范围0~255）、VARCHAR（可变长度，范围时0~65535）、4种TEXT。

#### DATABASE

* 创建数据库

```mysql
CRATE DATABASE db_name [[DEFAULT] CHARACTER SET [=] utf8];
```

#### TABLE

* 克隆和复制。

```MYSQL
#从origin_tb1克隆一个新表（只有结构，没有数据）。
CREATE TABLE new_tb1 LIKE origin_tb1;
#复制origin_tb1表，（结构和数据都复制了）。
CREATE TABLE new_tb1 AS SELECT * FROM origin_tb1;
```



### MYSQL账户管理

* mysql将账户存储在mysq数据库的user表中。
* `CREATE USER`用于创建性的mysql用户；账户首次创建没有特权，需要使用`GRANT`分配特权。

```MYSQL
#如果不指定主机，默认就是'%'（所有ip都能访问）
CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';
```

* `ALTER USER`修改账户的信息（如修改密码）。不推荐使用`SET PASSWORD`来修改密码。

```MYSQL
#修改自己的密码，USER()会返回当前登录用户的用户名和主机名
ALTER USER USER() IDENTIFIED BY 'password';
#锁定账户
ALTER USER 'jeffrey'@'localhost' ACCOUNT LOCK;
ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK;
```

* `GRANT`用来对账户进行授权，`REVOKE`用来撤销账户特权。

```MYSQL
#授予除GRANT和PROXY外的所有特权
#还可以授予ALTER、CREATE、DELETE、DROP、SELECT、UPDATE、GRANT OPTION
GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';
REVOKE ALL [PRIVILEGES], GRANT OPTION FROM 'jeffrey'@'localhost';
```

* `DROP USER 'jeffrey'@'localhost'`用来删除用户。
* `RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'%'` 用来重命名现有的账户。

### SHOW

```MYSQL
#显示属性
SHOW COLUMNS FROM MYSQL.USER;
#显示建库语句
SHOW CREATE DATABASE MYSQL.USER;
#显示建表语句
SHOW CREATE TABLE MYSQL.USER;
#显示创建该用户的语句
SHOW CREATE USER root;
#显示分配个某用户的特权
SHOW GRANTS [FOR user];
```

