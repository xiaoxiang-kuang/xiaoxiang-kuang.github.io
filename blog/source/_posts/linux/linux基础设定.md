---
title: linux基础设定
categories:
  - [linux]
site: linux
date: 2021-09-24 19:27:36
---

## 系统设定

### 网络

* 目前主流网卡为使用以太网络协议开发出来的以太网卡（Ethernet），所以linux称呼这种网络接口为ethN（N为数字）。

```sh
#后面不接参数会输出所有的设备，NAME：连接代号  TYPE：网卡类型  DEVICE：网卡名
nmcli connection show [NAME]
#connection.autoconnect[yes|no] 是否开机就启动这个连接
#ipv4.method[auto|manual] 自动还是手动设定网络参数
#ipv4.dns[dns_server_ip] 填写DNS的地址
#ipv4.addresses[IP/Netmask] 将IP和子网掩码的集合，用斜线/隔开
#ipv4.gateway[gw_ip] 网关的IP地址

#修改网络参数
nmcli connection modify eho0 \
ipv4.method manual \
ipv4.addresses 192.168.x.x
#让修改生效
nmcli connection up eth0
```

### 开机

#### MBR和GPT

* 整颗磁盘的第一个扇区特别重要，它记录了整颗磁盘的重要信息，早期磁盘的第一个扇区的包含重要的分区格式MBR（master boot record），后来多了一个新的磁盘分区格式，称为GPT（guid partition table）。
* MBR可以安装开机管理程序，其和分区表通常放在磁盘的第一个扇区，这个扇区通常是512字节。开机管理程序占446字节，分区表占64字节。分区表最多只能有四组记录。
* GPT将磁盘的所有区块以LBA（logical block address，预设为512字节）来规划，GPT使用34个LBA区块来记录分区信息，整个磁盘的最后33个LBA拿来作为备份。

#### BIOS和UEFI

* BIOS（固件）是开机的时候，计算机系统会主动执行的第一个程序。BIOS会分析计算机里面的有哪些存储设备。例：BIOS会到硬盘里读取第一个扇区的MBR位置，MBR内会存放开机管理程序，接下来就是开机管理程序的工作了。开机管理程序是在操作系统安装时提供的，他会认识硬盘的文件系统格式，因此就能读取核心文件，接下来即使核心文件的工作。
* UEFI（Unified Extension Firmware Interface）是取代BIOS的。



* linux预设情况下会提供6个终端让使用者登陆，切换方式为[ctrl]+[alt]+[f1]~[f6]，6个终端命名为tty1～tty6。在centos7中，开机后系统只会提供一个tty，其他的是不存在的，当要切换时，系统才产生额外的tty2，tty3...。



* `hostnamectl [set-hostname 主机名]` 修改主机名。
* `timedatectl [list-timezones | set-timezone | set-time | set-ntp]` 列出系统上的失去、设定时区、设定时间、设定网络校时。
* `localectl set-locale LANG=en_US.utf8`设置语系。通过`locale -a`可以查看linux支持了多少语系，通过`locale`来查看系统目前的语言环境。LANG只和输出信息有关，若要修改其他的不同信息，要更新LC_ALL。
* 硬件数据收集：`dmidecode(CPU型号、主板型号、内存相关型号等), gdisk, dmesg, vmstat（分析cpu、内存、io目前的状态）, lspci, lsusb,iostat
