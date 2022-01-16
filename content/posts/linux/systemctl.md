---
title: systemctl
tags: 
  - linux
date: 2021-09-15 17:06:38
---

* 一般linux上的服务会在服务名后面加上一个d，这个d就表示daemon。
* systemd将daemon执行脚本称为的一个unit。一般情况下安装的应用的unit都会放到`/usr/lib/systemd/system/`下；而在`/etc/systemd/system/`目录下会存放unit的一些配置。
* unit有多种类型，包括 ①service：服务类型；②socket；③target：执行环境类型，是一群unit的集合；④mount、automount：文件系统挂载相关的服务；⑤path：侦测特定的文件或目录类型；⑥timer：循环执行的服务。常用的即使service和target，比如mysqld.service（mysql服务），firewalld.service（防火墙）。
* 通过systemctl可以管理unit，格式如下：`systemctl [command] [unit]`，其中command如下：
  * start：启动。例 `systemctl start mysqld.service`。
  * stop：停止。
  * enable：开机启动。例 `systemctl enable mysqld.service`。
  * disable：禁止开机启动。
  * status：unit的状态。
  * is-active：是否运行。
* 执行`systemctl status xxx`，会显示该unit的状态。结果的第二行表示该服务是否会开机启动，结果的第三行表示该服务的当前状态。
* 一个daemon的预设状态有多个，包括：
  * enabled：这个daemon会在开机被执行。
  * disabled：这个daemon在开机不会被执行。
  * static：这个daemon不可以自己启动（即不能使用`systemctl enable xxx`来设置开机自启），但可以被其他的服务来唤醒。
  * mask：注销状态，这个daemon无法被启动，可以通过`systemctl unmask xxx`改会原来的状态。
* `systemctl [list-units]`列出目前启动的unit；`systemctl list-units --all`列出所有的unit。`systemctl list-unit-files`列出所有已安装的unit。

#### unit文件说明

```sh
[root@localhost ~]# cat /usr/lib/systemd/system/example.service 
#unit描述了该unit。
[Unit]
#当使用systemctl list-units，会输出的简单说明。
Description=You know, for example

#这里可以有其他的类型，如[Socket]、[Timer]、[Mount]、[Path]
[Service]
#执行此daemon的指令或脚本程序，只支持[指令 参数 参数...]的格式，不能接收<、>、|、&等字符，很多的bash语法也不支持。
ExecStart=/bin/bash xxx.sh

#将此unit安装到哪个target里去
[Install]
#后面可以跟一个或多个unit，用空格分隔
#通过systemctl enable example.service，可以将此unit安装到multi-user.target的/etc/systemd/system/multi-user.target.wants/目录下（即创建了此unit的一个符号链接）。
#在multi-user.target启动后，会启动此unit。
WantedBy=multi-user.target

#一个sshd服务的案例
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
Type=simple
#EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/local/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

```

---

* systemd取消了以前的runlevel概念，转而使用不同的target操作环境。常见的操作环境为multi-user.target（命令行界面）和graphical.target（图形界面）。不重新启动而转不同的操作环境使用`systemctl isolate unit.target`，设定预设的环境使用`systemctl set-default unit.target`。


<!--more-->
