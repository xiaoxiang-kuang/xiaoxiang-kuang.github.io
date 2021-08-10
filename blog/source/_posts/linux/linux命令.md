---
title: linux命令
categories:
  - [linux]
site: linux
date: 2021-02-08 11:29:58
---

* `kill `
  * `kill -9 PID`立刻强制删除一个工作
  * `kill  [-15] PID`以正常的方式结束一个工作
  * example：当使用vim时，会产生一个.filename.swp文件，使用-15时，vim会以正常的步骤结束vi的工作，所以.filename.swp会被主动的移除，但如果使用-9，由于vim工作被强制移除了，所以.filename.swp就会继续存在文件系统中。
* netstat：显示网络状态
  * `-a --all`显示所有连线中的socket
  * `-o`：windows下是显示进程的PID
  * `-n --numeric`：显示IP地址而不是域名
* `df -h`查看磁盘的信息

## 文件

* `tar -xzvf xxx.tar.gz`解压文件
  * -x extract提取文件；-z通过gzip处理文件；-v：verbose显示执行过程；-f指定文件名
* `tar -cvzf 生成的文件名.tar.gz dir/`压缩文件
  * -c：create生成文件
  * tips：-C（大写）将文件放到指定文件夹
* `chown [-R] name:groupname 文件或目录`来修改文件的拥有者，-R表示递归。

