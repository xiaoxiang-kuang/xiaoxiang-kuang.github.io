---
title: 'mysql'
categories:
  - [mysql]
date: 2021-02-04 15:58:03
---

* 查询版本和当前时间`select version(),current_date;`
* mysql执行结束后会显示返回了多少行和用了多长时间，受网络其他因素影响
* 用作计算器`select sin(pi()/4),(4+1)*5);`
* `select user()` ,后面补充
* 当输入多行，打算不执行这句sql语句，输入`\c`
* 自带的的mysql database描述了用户的访问权限
* `GRANT ALL ON menagerie.* TO 'your_mysql_name'@'your_client_host';`menagerie数据库只有your_sql_name能操作。
* unix下数据库名是大小写相关的。建议在创建数据库的时候要么全大写，要么全小写。
* 查看当前账户拥有的权限，可以使用`show grants for 'joe'@'home.example.com'`