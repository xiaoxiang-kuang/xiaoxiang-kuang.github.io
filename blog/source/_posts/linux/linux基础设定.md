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



* `hostnamectl [set-hostname 主机名]` 修改主机名。
* `timedatectl [list-timezones | set-timezone | set-time | set-ntp]` 列出系统上的失去、设定时区、设定时间、设定网络校时。
* `localectl set-locale LANG=en_US.utf8`设置语系。
* 硬件数据收集：`dmidecode(CPU型号、主板型号、内存相关型号等), gdisk, dmesg, vmstat（分析cpu、内存、io目前的状态）, lspci, lsusb,iostat
