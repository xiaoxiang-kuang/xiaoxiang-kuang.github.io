---
title: mysql账户管理
categories:
  - [数据库, mysql]
site: 数据库
date: 2021-08-16 17:25:09
---

### MYSQL账户管理

* mysql将账户存储在mysq数据库的user表中。
* `CREATE USER`用于创建性的mysql用户；账户首次创建没有特权，需要使用`GRANT`分配特权。

```sql
#如果不指定主机，默认就是'%'（所有ip都能访问）
CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';
```

* `ALTER USER`修改账户的信息（如修改密码）。不推荐使用`SET PASSWORD`来修改密码。

```sql
#修改自己的密码，USER()会返回当前登录用户的用户名和主机名
ALTER USER USER() IDENTIFIED BY 'password';
#锁定账户
ALTER USER 'jeffrey'@'localhost' ACCOUNT LOCK;
ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK;
```

* `GRANT`用来对账户进行授权，`REVOKE`用来撤销账户特权。

```sql
#授予除GRANT和PROXY外的所有特权
#还可以授予ALTER、CREATE、DELETE、DROP、SELECT、UPDATE、GRANT OPTION
GRANT ALL ON db1.* TO 'jeffrey'@'localhost';
REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';
REVOKE ALL [PRIVILEGES], GRANT OPTION FROM 'jeffrey'@'localhost';
```

* `DROP USER 'jeffrey'@'localhost'`用来删除用户。
* `RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'%'` 用来重命名现有的账户。
