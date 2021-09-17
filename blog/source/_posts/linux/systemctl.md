---
title: systemctl
categories:
  - [linux]
site: linux
date: 2021-09-15 17:06:38
---

* 一般linux上的服务会在服务名后面加上一个d，这个d就表示daemon。
* systemd将daemon执行脚本称为的一个unit。配置文件都存放在/etc/systemd/system（依照需求建立的执行脚本）、/usr/lib/systemd/system/（每个服务最主要的启动脚本设定）。
* 管理服务的状态，格式：`systemctl [command] [unit]`，command如下：

| start | stop | enable   | disable    | status | is-active |
| ----- | ---- | -------- | ---------- | ------ | --------- |
| 启动  | 停止 | 开机启动 | 开机不启动 | 状态   | 是否运行  |

* 结果的第二行表示该服务是否会开机启动，结果的第三行表示该服务的当前状态。
* `systemctl [list-units]`列出目前启动的unit；`systemctl list-unit-files`将`/usr/lib/systemd/system/`下的所有文件进行说明。

#### systemctl配置文件说明

```sh
[root@localhost ~]# cat /usr/lib/systemd/system/sshd.service 
#unit描述了该unit，如在什么服务后启动此unit
[Unit]
#当使用systemctl list-units，会输出的简单说明。
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

#这里可以有其他的类型，如[Socket]、[Timer]、[Mount]、[Path]
[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.targe
```



* systemctl中配置文件中最重要的是ExecStart，它是实际执行此daemon的指令或者脚本，这里很多的bash语法都不支持。

关闭防火墙：`systemctl stop firewalld; systemctl disable firewalld`。使用firewalld搭配firewall-cmd指令可以快速设置防火墙。

---

* systemd取消了以前的runlevel概念，转而使用不同的target操作环境。常见的操作环境为multi-user.target和graphical.target。不重新启动而转不同的操作环境使用systemctl isolate unit.target，设定预设的环境使用systemctl set-default unit.target。
