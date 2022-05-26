---
title: "Syslog"
date: 2022-01-07T11:53:11+08:00
tags:
  - javaee
draft: false
---

## rfc5424

### 介绍

格式：`PRI VERSION TIMESTAMP HOSTNAME APP-NAME PROCID MSGID STRUCTURED-DATA MSG`

* 消息头
  * PRI 优先级
  * VERSION 版本
  * TIMESTAMP 时间
  * HOSTNAME 主机名
  * APP-NAME APP名称
  * PROCID 进程的ID
  * MSGID 消息ID
* STRUCTURED-DATA 
* 消息体

#### PRI

* PRI（priority）代表两个值（Facility）和日志级别（serverity）。PRI必须是类似`<14>`的格式。中间的值的计算公式为`priority = facility x 8 + serverity`。
* Facility的值是`[0,23]`。各个值的含义如下：

| 数字 | 介绍                   |
| ---- | ---------------------- |
| 0    | 内核消息               |
| 1    | 用户级别消息           |
| 2    | 邮件系统               |
| 3    | 系统守护进程           |
| 4    | 安全/认证消息          |
| 5    | syslogd内部生成的消息  |
| 6    | line printer subsystem |
| 7    | network news subsystem |
| 8    | UUCP subsystem         |
| 9    | 时钟守护程序           |
| 10   | 安全/认证消息          |
| 11   | FTP守护程序            |
| 12   | NTF子系统              |
| 13   | log audit              |
| 14   | log alert              |
| 15   | clock daemon (note 2)  |
| 16   | 本地用户0（LOCAL0）    |
| 17   | 本地用户1（LOCAL1）    |
| 18   | 本地用户2（LOCAL2）    |
| 19   | 本地用户3（LOCAL3）    |
| 20   | 本地用户4（LOCAL4）    |
| 21   | 本地用户5（LOCAL5）    |
| 22   | 本地用户6（LOCAL6）    |
| 23   | 本地用户7（LOCAL7）    |

#### Serverity

| 数字 | 介绍                        |
| ---- | --------------------------- |
| 0    | emergency紧急，系统无法使用 |
| 1    | alert警告，必须立即采取措施 |
| 2    | critical                    |
| 3    | error                       |
| 4    | warning                     |
| 5    | notice；正常但是重要的情况  |
| 6    | informational；普通信息     |
| 7    | debug；                     |

### 例子

```
<165>1 2003-08-24T05:14:15.000003-07:00 192.0.2.1 myproc 8710 - - %% It's time to make the do-nuts
<165>1 2003-10-11T22:14:15.003Z mymachine.example.com evntslog - ID47 [exampleSDID@32473 iut="3" eventSource="Application" eventID="1011"] BOMAn
<165>1 2003-10-11T22:14:15.003Z mymachine.example.com evntslog - ID47 [exampleSDID@32473 iut="3" eventSource="Application" eventID="1011"][examplePriority@32473 class="high"]
```



### log4j2配置

```
<Syslog name="RFC5424" format="RFC5424" host="10.2.4.31" port="5140" protocol="UDP" 
appName="auditSyslogDemo" facility="LOCAL0" newLine="true" messageId="Audit" id="App"/>
```

参考链接：[RFC 5424: The Syslog Protocol (rfc-editor.org)](https://www.rfc-editor.org/rfc/rfc5424.html)

参考链接：[Log4j – Log4j 2 Appenders (apache.org)](https://logging.apache.org/log4j/2.x/manual/appenders.html#SyslogAppender)

<!--more-->