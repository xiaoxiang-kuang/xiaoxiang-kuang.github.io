---
title: snmp
categories:
  - [linux]
site: linux
date: 2021-12-22 21:52:01
---

## snmpd.conf

```sh
#建立一个从community到security name的映射，source可以是default、一个IP、一个主机名、或者一个子网（如10.10.10.0/24），source以!开头表示拒绝此source的请求。
com2sec -[-Cn CONTEXT] SECNAME SOURCE COMMUNITY

#建立从security name到group的一个映射，多个group指令可以指定相同的group名，
group GROUP {v1|v2c|usm|tsm|ksm} SECNAME

#定义一个view name，type可以是included或者excluded。
view VNAME TYPE OID [MASK]

#建立一个从group到三个view之一的映射，
#LEVEL是noauth、auth或priv之一
#PREFX指定CONTEXT如何被请求匹配，可以是exact、prefix
#READ和WRITE指定用于GET、SET和TRAP/INFORM 请求的view。
access GROUP CONTEXT {any|v1|v2c|usm|tsm|ksm} LEVEL PREFX READ WRITE NOTIFY
```





