---
title: 'mysql'
tags:
  - 数据库
date: 2021-02-04 15:58:03
---

* 查询版本和当前时间`select version(),current_date;`
* mysql执行结束后会显示返回了多少行和用了多长时间，受网络其他因素影响
* 当输入多行，打算不执行这句sql语句，输入`\c`
* 自带的的mysql database描述了用户的访问权限。
* unix下数据库名是大小写相关的。建议在创建数据库的时候要么全大写，要么全小写，可以在刚安装的时候修改my.cnf文件。
* 相邻的带引号的多个字符串会拼接成一个字符串。下面这两个等价：

```sql
'a string'
'a''string'
```

* 查看和设置系统变量`SET [GLOBAL| SESSION] 系统变量` ``SHOW [GLOBAL |SESSION] VARIABLES [LIKE XXX]`。状态变量是用来显示服务器程序运行状态的，只能查看`SHOW [GLOBAL|SESSION] STATUS [LIKE XXX]`。

* 查看当前账户拥有的权限，可以使用`show grants for 'joe'@'home.example.com'`。

### linux上mysql布局

| 文件资源             | 位置                                                         |
| -------------------- | ------------------------------------------------------------ |
| 客户端程序和脚本     | /usr/bin                                                     |
| mysqld server        | /usr/sbin                                                    |
| 配置文件地址         | /etc/my.cnf                                                  |
| 数据存放目录         | /var/lib/mysql                                               |
| 错误日志文件         | /var/log/mysqld.log                                          |
| secure_file_priv     | /var/lib/mysql-files                                         |
| System V init script | /etc/init.d/mysqld                                           |
| Systemd服务          | mysqld                                                       |
| Pid文件              | /var/run/mysql/mysqld.pid                                    |
| Socket               | /var/lib/mysql/mysql.sock                                    |
| 使用手册             | /usr/share/man                                               |
| 字符集文件等其他文件 | /usr/share/mysql                                             |
| 库                   | /usr/lib/mysql                                               |
| **参考链接：**       | [MySQL :: MySQL 8.0 Reference Manual :: 2.5.4 Installing MySQL on Linux Using RPM Packages from Oracle](https://dev.mysql.com/doc/refman/8.0/en/linux-installation-rpm.html) |

### mysql安装

* `systemctl start mysqld`启动mysql。
* mysql安装后，会自动创建超级用户`'root'@'localhost'`，其密码在`/var/log/mysqld.log`，使用`grep 'temporary password' /var/log/mysqld.log`来寻找密码。
* 修改密码`ALTER USER 'root'@'localhost' IDENTIFIED BY 'newPassword'`。
* mysql8修改成简单的密码会报错（试了下mysql5.7也会报错，解决方法一样）。解决流程如下：
  1. mysql8增加了一组变量来控制密码的长度、强度等。通过`SHOW VARIABLES LIKE 'validate_password%'`来查看。
  2. validate_password.length用来要求密码的最小长度，这个参数不得小于`validate_password.number_count+validate_password.special_char_count+2*validate_password.mixed_case_count)`。
  3. validate_password.policy会影响validate_password的其他变量是否有效（除validate_password.check_user_name），它的值可以为0(LOW)，1(MEDIUM)，2(STRONG)。为0则只检查length这个变量。
  4. 更改策略：`set global validate_password.policy=0;set global validate_password.number=4;`
  5. **参考链接：**[MySQL :: MySQL 8.0 Reference Manual :: 6.4.3.2 Password Validation Options and Variables](https://dev.mysql.com/doc/refman/8.0/en/validate-password-options-variables.html)

### mySQL配置

* mysql配置文件被划分为多个组，每个组有一个组名，用[]括起来。

```
[mysqld]
default-storage-engine=InnoDB
validate_password=OFF
```

## 基础SQL

### 数据类型

1. 整数数据类型 tinyint（1字节）、smallint（2字节）、mediumint（3字节）、int（4字节）、bigint（8字节）。
2. 定点数据类型 `decimal(5,2)`，其中5是精度，表示有效位数；2表示小数点后几位。
3. 浮点类型 float（4字节）、double（8字节）。
4. 日期和时间类型 DATE（YYYY-MM-DD）、DATETIME（YYYY-MM-DD hh:mm:ss）、TIMESTAMP（范围是UTC1970-01-01 00:00:01-UTC2038-01-19 03:14:07)、TIME（范围-838:59:59-838:59:59）、YEAR（范围是1901-2155）
5. 字符串类型 CHAR（长度为声明时的长度，范围0-255）、VARCHAR（可变长度，范围时0-65535）、4种TEXT。
6. 字节串类型 BINARY、VARCHAR、四种BLOB。

* 可以把BLOB看作VARBINARY，把TEXT看作VARCHAR，但它们有一点点不同：①对于BLOB和TEXT列上的索引，必须要指定缩影前缀长度，对应VARBINARY和VARCHAR，这是可选的；②BLOB和TEXT所在的列不能有默认值。**参考链接：**[MySQL :: MySQL 5.7 Reference Manual :: 11.3.4 The BLOB and TEXT Types](https://dev.mysql.com/doc/refman/5.7/en/blob.html)

### DATABASE

* 创建数据库

```mysql
CRATE DATABASE db_name [[DEFAULT] CHARACTER SET [=] utf8];
```

### TABLE

* 克隆和复制。

```
#从origin_tb1克隆一个新表（只有结构，没有数据）。
CREATE TABLE new_tb1 LIKE origin_tb1;
#复制origin_tb1表，（结构和数据都复制了）。
CREATE TABLE new_tb1 AS SELECT * FROM origin_tb1;
```

#### ALTER

```
#单个alter table可以跟多个修改语句，用逗号隔开
#删除
ALTER TABLE t2 DROP COLUMN c, DROP COLUMN d;
```

##### change、modify、alter

* change可以重命名列、修改列的定义。配合FIRST或AFTER，可以指定列的位置。
* MODIFY可以修改列的定义，但无法修改它的名字。配合FIRST或AFTER能指定列的名字。
* ALTER只能修改列的默认值。

```
#将a的名字改为b，修改定义
ALTER TABLE t1 CHANGE a b BIGINT NOT NULL;
#不修改a的名字，只修改定义
ALTER TABLE t1 CHANGE a a BIGINT NOT NULL;
#修改b的定义
ALTER TABLE t1 MODIFY b INT NOT NULL;
#如果只想要修改b的名字而不去修改它的定义，就需要将定义再写一遍
ALTER TABLE t1 CHANGE b a INT NOT NULL;
#除了如PRIMARY KEY或UNIQUE属性，其他的如DEFAULT COMMENT等需要在修改时带上，否则修改后的列是没有这些属性。
#使用CHANGE或MODIFY，myslq会尝试将列中数据转化未新的类型。
#当使用CHANGE修改列名后，使用了该列的VIEW需要修改。
#ALTER TABLE xxx ALTER ...SET DEFAULT xxx或ALTER ... DROP DEFAULT。如果旧的默认值被删除而列不可以为NULL，mysql将为其分配默认值（数字类型默认为0，如果指定了AUTO_INCREMENT，默认值是序列中的下一个值，对于EMUM，默认值为第一个枚举值，对于其他字符串类型，默认值为空字符串）。
```

* [MySQL :: MySQL 5.7 Reference Manual :: 13.1.8 ALTER TABLE Statement](https://dev.mysql.com/doc/refman/5.7/en/alter-table.html)

### SHOW

```
#显示属性
SHOW COLUMNS FROM MYSQL.USER;
#显示建库语句，例：
SHOW CREATE DATABASE MYSQL;
#显示建表语句，例：
SHOW CREATE TABLE MYSQL.USER;
#显示创建该用户的语句
SHOW CREATE USER root;
#显示分配个某用户的特权
SHOW GRANTS [FOR user];
```


<!--more-->
