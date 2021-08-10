---
title: rpm
categories:
  - [linux]
site: linux
date: 2021-08-10 15:28:42
---

## 软件管理机制RPM

* RPM全称：RedHat Package Manager

* RPM是通过预先编译打包成RPM文件格式后，再加以安装的一种方式。RPM在打包软件的同时会加入一些其他的信息，包括软件版本、作者、**依赖的其他软件**等。RPM会在linux系统上建立一个RPM软件数据库，当要安装某个软件时，RPM会去在数据库里检测是否已经存在相关软件，如果不存在就不能安装。

* 当软件安装完毕后，该软件相关的信息就会被写入到`/var/lib/rpm`目录下的数据库文件中了。未来任何软件升级的需求，版本之间的比较都是来自于这个数据库。

* 大部分情况下yum都够用了

#### RPM常用命令

1. `rpm -ivh package_name`安装软件
   * -i install；-v查看安装信息界面；-h显示安装进度
   * --force：强制安装，--test：测试一下该软件是否可以被安装到linux中
   * --prefix 新路径：将软件安装到其他路径
2. `rpm -Uvh/-Fvh file-1.0-1.e17.x86_64.rpm` 更新软件
   * -U：update后面的软件即使没有安装过，系统会直接安装，如果安装过旧版，系统会更新到新版。
   * -F：freshen后面的软件如果没有安装就不安装，如果安装过旧版就更行到新版。
3. `rpm -qa`查询本机所有已安装软件
   * `rpm -q package_name`查询后面的软件是否被安装
   * `rpm -qi package_name`列出该软件的详细信息
   * `rpm -ql package_name`列出该软件所有文件与目录
   * `rpm -qR package_name`列出该软件依赖那些软件
   * `rpm -qpR file-1.0-1.e17.x86_64.rpm`查询某个rpm文件依赖了哪些文件，-p表示指定的是一个rpm文件。
   * tips：在查询本机上已安装的软件时，只用加上软件的名称即可，版本号啥的都不需要。

### yum

当客户端有软件安装需求时，客户端会主动下载yum服务器中该软件的依赖清单，将该清单与本机的RPM数据库进行比较，就能安装未安装的依赖了。

yum提供了查找、安装、删除软件包的命令

#### 语法

```shell
yum [options] [command] [package ...]
```

* options：可选，-y表示安装过程全部为yes，-q白哦是不显示安装过程，-h表示帮助，--installroot=路径：将软件安装到指定路径中。
* command：要进行的操作，如search、list、info。
* package：包名。

#### 常用命令

1. `yum check-update`列出所有可更新的软件。
2. `yum update`更新所有软件
3. `yum install package_name`安装指定的软件
4. `yum update package_name`更新指定的软件
5. `yum list `列出所有的可安装的软件
   * `yum list packa*`寻找以packa开头的软件
6. `yum remove package_name`删除软件
7. `yum search keyword_name`查找软件包命令
8. yum会先下载软件库的清单到本机的`var/cache/yum`中，清除缓存命令如下
   * `yum clean packages/headers/all`清楚缓存目录下的软件包/headers/所有软件库的数据。

