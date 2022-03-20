---
title: 'mysql'
tags:
  - 数据库
date: 2021-02-04 15:58:03
menu:
  after:
    weight: 1010
---

## mysql起步

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


### mysql配置

* mysql配置文件被划分为多个组，每个组有一个组名，用[]括起来。

```
[mysqld]
default-storage-engine=InnoDB
validate_password=OFF
```

## mysql账户管理

* mysql将账户存储在mysq数据库的user表中。
* `CREATE USER`用于创建性的mysql用户；账户首次创建没有特权，需要使用`GRANT`分配特权。

```shell
#如果不指定主机，默认就是'%'（所有ip都能访问）
CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';

#删除用户。
DROP USER 'jeffrey'@'localhost';
#重命名现有的账户,可以用来解决账号只能在本地访问的问题。
RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'%'
```

* `ALTER USER`修改账户的信息（如修改密码）。不推荐使用`SET PASSWORD`来修改密码。

```shell
#修改自己的密码，USER()会返回当前登录用户的用户名和主机名
ALTER USER USER() IDENTIFIED BY 'password';
#锁定账户
ALTER USER 'jeffrey'@'localhost' ACCOUNT LOCK;
ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK;
```

* `GRANT`用来对账户进行授权，`REVOKE`用来撤销账户特权。

```shell
#授予除GRANT和PROXY外的所有特权
#还可以授予ALTER、CREATE、DELETE、DROP、SELECT、UPDATE、GRANT OPTION
GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';
REVOKE ALL [PRIVILEGES], GRANT OPTION FROM 'jeffrey'@'localhost';
```

## mysql系统变量

* mysql有很多的系统变量，能够影响程序的行为，很多命令都能在运行过程中修改。

```shell
#获取某个变量的信息
show [global | session] variables like 'xxx'

#获取默认存储引擎
show variables like 'default_storage_engine'
#获取默认的最大连接数
show variables like 'max_connections';
```

### 通过命令行设置系统变量

```shell
mysqld --max_connections=10
```

### 通过配置文件设置系统变量

```properties
[server]
max_connections=10
```

### 运行过程中修改系统变量

* 许多系统变量分为全局范围（global）和会话范围（session）。
* 并不是所有的变量都有全局范围和会话范围，如max_connections只有全局范围。
* 服务器在启动时会给所有的全局变量一个默认值，当有连接的客户端时，服务器为每个连接的客户端维护一组会话变量，并以全局变量的值初始化。

```shell
#全局设置存储引擎
set global default_sotrage_engine=MyISAM
#本次会话期间设置存储引擎
set [session] default_storage_engine=MyISAM

#获取会话范围的变量内容
show SESSION VARIABLES LIKE 'default_sotrage_engine'
#不写修饰符默认是session范围，如果一个变量没有session范围则显示global范围的值
show VARIABLES LIKE 'max_connections'
```

### 状态变量

* 状态变量有关服务器的运行情况。
* 状态变量不能人为设置。

```shell
show [global | session] status like [like 'xxx']

#查看当前有多少客户端与服务器建立了连接。
show status like 'threads_connected'
```

### 补充

* 很多变量不可修改，如`version`。

* 大部分系统变量都可以当启动选项传入。

## mysql字符集

### 常见字符集

* ASCII：共128个字符，用一个字节编码。
* ISO 8859-1：共收录256个字符，在ASCII的基础上扩充了128个西欧常用字符。这个字符集也有一个别名Latin 1。
* GB2312：收录了6763个汉字以及部分其他编码，兼容ASCII字符集，如果该字符集在ASCII字符集中，则采用一字节编码，否则采用两字节编码。
* GBK：在GB2312的基础上进行了扩充，兼容GB2312。
* UTF-8：几乎收录了当前世界上各个国家和地区使用的字符，而且还在不断扩充，采用变长编码的方式，编码一个字符需要1~4个字节。

### mysql的字符集和比较规则

#### utf8和utf8mb4

* utf8mb3：阉割过的utf-8，只使用1~3个字节表示字符。mysql中的utf8就是utf8-mb3的别名。
* utf8mb4：正宗utf-8，使用1~4表示字符。

#### 字符集查看

```shell
SHOW CHARSET [LIKE 'utf8%']
#结果中的maxlen表示此字符集最多需要几个字节表示一个字符。
```

#### 比较规则

```shell
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

### 各级别的字符集和比较规则

* mysql有4个界别的字符集和比较规则

#### 服务器级别

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

#### 数据库级别

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

#### 表级别

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

#### 列级别

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

## mysqldump

mysqldump可以备份数据库。

``` shell
mysqldump [options] db_name > file_name
mysqldump [options] --databases db_name ...
```

* 默认输出到控制台，可通过`>`输出到文件。
* 可以直接在后面跟一个数据库名，这样就备份了数据库的表的结构和数据。但不包括建库的语句。
* 可选的option
  * `--databases`：备份指定几个数据库。在备份数据库时会加上`CREATE DATBASE...`和`use xxx`的语句，
  * `--all-databases`：备份数据库的所有表，和`--databases`类似。
  * `--add-drop-database`：在`CREATE DATABASE`之前加上`DROP DATABASE`语句，这个参数与--databases和--all-databases同时使用。
  * `--add-drop-table`：建表语句之前加上删表语句。
  * `--ignore-table`：不备份指定的表。
  * `--tables`: 会覆盖--databases属性`mysqldump database1 --tables table1 -u root -p `。
  * `--no-data`：不备份数据。
  * `--force`：-f即使在备份期间发生sql异常也继续。
  * `--host`：-h主机。--user：-u用户。--password：-p密码。--port：-P端口。
  * `--xml`：输出xml文件。
  * `--set-charset`：默认启用的参数。
* 一个例子

```shell
mysqldump -u root -p --databases test --add-drop-database > test.sql
```

* 导入sql文件

  * 连接上mysql server后使用`source`命令导入。

  ```shell
  mysql>source dump.sql
  ```

  * 从外部导入（sql文件中指定了数据库的情况）。

  ```shell
  shell>mysql[-u root -p] <dump.sql
  ```

  * 外部导入（sql文件中未指定数据库）

  ``` shell
  shell> mysqladmin create db1 #如果有该数据库就不用建了
  shell> mysql [-u root -p] db1 < dump.sql #指定数据库
  ```

参考链接：[MySQL :: MySQL 5.7 Reference Manual :: 4.5.4 mysqldump — A Database Backup Program](https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html#option_mysqldump_databases)

## mysqladmin

* mysqladmin可以用来检测服务的配置、创建数据库、关闭mysql服务等。

```shell
mysqladmin [options] command [command-arg] [command [command-arg]]
```

### option

* --host：指定主机。
* --port（-P）：指定端口。
* --user：指定连接用户。
* --version：显示版本信息并退出。
* --wait：如果连接失败，等待并重试。
* --connect-timeout：连接超时的时间。

### command

* create/drop db_name：创建/删除数据库。
* password "new_password"：修改密码，在windows上确保使用双引号"，使用单引号'的话单引号会被识别为密码的一部分。
* shutdown：关闭服务。
* status：显示一个简短的服务状态消息。显示的结果如下：
  * Uptime：mysql运行了多少秒。
  * Threads：客户端连接的线程数（active）。
  * Questions：从服务启动开始客户端查询的数量。
  * Slow queries：查询超过`long_query_time`秒的数量。
  * Opens：服务已经打开了多少张表。
  * Flush tables：`flush-*,refresh,reload`这些指令服务执行的次数。
  * Open tables：当前打开了多少张表。
* version：显示服务的版本信息。

**参考链接（官方）：**[ mysqladmin — A MySQL Server Administration Program](https://dev.mysql.com/doc/refman/5.7/en/mysqladmin.html)
**参考链接（汉化）：**[mysqladmin-MySQL 服务器管理程序 | Docs4dev](https://www.docs4dev.com/docs/zh/mysql/5.7/reference/mysqladmin.html)

## sql

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
show grants for 'joe'@'home.example.com'
```

<!--more-->

