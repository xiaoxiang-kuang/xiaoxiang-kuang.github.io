---
title: mysqldump
categories:
  - [数据库, mysql]
site: 数据库
date: 2021-08-24 16:14:08
---

mysqldump的可以备份数据库。但它不是备份大量数据的解决方案。
``` shell
mysqldump [options] db_name > file_name
mysqldump [options] --databases db_name ...
```

* 默认输出到控制台，可通过`>`输出到文件。
* 可以直接在后面跟一个数据库名，这样就备份了数据库的表的结构和数据。但不包括建库的语句。
* 可选的option
  * --databases：备份指定几个数据库。只有在指定了这个参数和下面的参数后，在备份数据库时才会加上`CREATE DATBASE...`的语句，
  * --all-databases：备份数据库的所有表。
  * --add-drop-database：在`CREATE DATABASE`之前加上`DROP DATABASE`语句，这个参数与--databases和--all-databases同时使用。
  * --add-drop-table：建表语句之前加上删表语句。
  * --ignore-table：不备份指定的表。
  * --no-data：不备份数据。
  * --force：-f即使在备份期间发生sql异常也继续。
  * --host：-h主机。--user：-u用户。--password：-p密码。--port：-P端口。
  * --xml：输出xml文件。
  * --set-charset：默认启用的参数。
* 一个例子

```shell
mysqldump -u root -p --databases test --add-drop-database
```

* 导入sql文件

  * 连接上mysql server后使用`source`命令导入。

  ```shell
  mysql>source dump.sql
  ```

  * 从外部导入（sql文件中指定了数据库的情况）。

  ```shell
  shell>mysql <dump.sql
  ```

  * 外部导入（sql文件中未指定数据库）

  ``` shell
  shell> mysqladmin create db1 #如果有该数据库就不用建了
  shell> mysql db1 < dump.sql #指定数据库
  ```

  

