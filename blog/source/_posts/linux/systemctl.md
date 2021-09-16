---
title: systemctl
categories:
  - [linux]
site: linux
date: 2021-09-15 17:06:38
---

* systemd将所谓的daemon执行脚本称为的一个unit。配置文件都存放在/etc/systemd/system、/usr/lib/systemd/system/（主要的脚本执行设定）。
* 管理服务的状态，格式：`systemctl [command] [unit]`，command如下：

| start | stop | enable   | disable    | status | is-active |
| ----- | ---- | -------- | ---------- | ------ | --------- |
| 启动  | 停止 | 开机启动 | 开机不启动 | 状态   | 是否运行  |

* 结果的第二行表示该服务是否会开机启动，结果的第三行表示该服务的当前状态。
* `systemctl [list-units]`列出目前启动的unit；`systemctl list-unit-files`将`/usr/lib/systemd/system/`下的所有文件进行说明。
* systemctl中配置文件中最重要的是ExecStart，它是实际执行此daemon的指令或者脚本，这里很多的bash语法都不支持。

关闭防火墙：`systemctl stop firewalld; systemctl disable firewalld`。使用firewalld搭配firewall-cmd指令可以快速设置防火墙。

---

* systemd取消了以前的runlevel概念，转而使用不同的target操作环境。常见的操作环境为multi-user.target和graphical.target。不重新启动而转不同的操作环境使用systemctl isolate unit.target，设定预设的环境使用systemctl set-default unit.target。
