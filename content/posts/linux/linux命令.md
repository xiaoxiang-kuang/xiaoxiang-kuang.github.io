---
title: linux命令总结
tags: 
  - linux
date: 2021-02-08 11:29:58
menu:
  after:
    weight: 1000
---

### linux指令执行过程

* linux在下达一个指令时，会按照以下的顺序寻找（所以当直接在bash中输入xxx.sh时是不会执行的）：
   1. 以相对/绝对路径执行指令如/bin/ls，或./ls。
   2. `alias lm='ls -al'`：给命令设定别名；`alias`：可以查看系统的所有别名；使用`unalias lm`取消别名。
   3. 由bash内建的指令来执行。
   4. 通过$PATH这个变量的顺序搜寻到第一个指令来执行。
* 使用`which`指令可定位到程序的位置。

### linux进程

* 进程（process）：程序被触发后，执行者的权限与属性、程序及程序所需的数据都会被加载到内存中，操作系统给与这个内存内的单元一个标识符PID。
* 当登入系统后，会取得一个bash，当使用这个bash提供的接口去执行另一个指令时，另外执行的指令也会生成PID，这个新进程就是子进程，而原来的bash环境就是父进程。linux中进程通常由父进程以复制(fork)的方式产生一个一摸一样的子进程，然后被复制出来的子进程再以exec的方式来执行实际要进行的程序，最终就会成为一个子进程。

  1. 系统先以fork的方式复制一个与父进程相同的暂存进程，这个进程与父进程唯一的差别就是PID不同，此外这个暂存进程还会多一个PPID（parient pid）的参数。
  2. 暂存进程开始以exec的方式加载实际要执行的程序。
* 常驻内存中的进程通常提供一些功能以服务用户，因此这些常驻程序就会被称为：服务（daemon）。

### vim 文本编辑工具

通过配置~/.vimrc（不建议修改/etc/vimrc）可以设定一些vim的属性，在vim的命令模式输入`:set all`可以查到

* `ctrl+f`向下移动一页
* `ctrl+b`向上移动一页
* `0或者home`移动到这一列的最前面
* `$或end`移到这一列最后一页
* `G(注意是大写)`移到文件的最后一列
* `gg`移到文件的第一行
* `n+enter`光标向下移动n行
* `/word`搜索为名称为word的字符串
* `:1,2s/word1/word2/g`[第一行，第二行]中所有的word1被替换成word2
* `:1,$s/word1/word2/g`第一行到最后一行所有word1被替换为word2
* `:1,$s/word1/word2/gc`第一行到最后一行所有word1被替换为word2，且在取代前会提示字符给用户确认
* `dd`删除当前一整行，`ndd` 删除光标所在的向下n行
* `yy`复制一整行，`4yy `复制4行。
* `p`将复制的数据在光标的下一行粘贴，`P`在光标的上一行粘贴
* `u`复原前一个动作
* `ctr+r`重复上一个动作
* `:w [filename]`将文件另存为
* `:set nu/nonu`开启/关闭行号
* `:set ic` 忽视大小写

### nmcli 网络配置工具

* 目前主流网卡为使用以太网络协议开发出来的以太网卡（Ethernet），所以linux称呼这种网络接口为ethN（N为数字）。新的centos7对网卡的编号有另一套规则，网卡待会现在与网卡的来源有关：eno1（BIOS内建的网卡），ens1（BIOS内建的PCI-E网卡），enp2s0（PCI-E）界面的独立网卡。

* nmcli可用来设置ip、dns等配置，与直接修改/etc/sysconfig/network-scripts/ifcfg-xxx（centos7）、/etc/NetworkManager/system-connections/ethernet-xxx（ubuntu18）等效。

* 一个网卡设备可以有多个配置，但是只能有一个为激活状态，多个配置可以在不同的网络环境中切换。比如小明在公司用静态IP的方式连接到网络，在家用DHCP的方式连接网络，可以创建两个connections，一个叫static-conn，另一个叫dhcp-conn，当需要使用DHCP的方式时，执行`nmcli con up dhcp-conn`激活配置，当使用静态IP的方式时，执行`nmcli con static-conn`激活配置。

`nmcli connection {show | up |down| modify | add | edit |clone | delete |monitor | reload | load | import | export } ARGUMENTS...`

```sh
#为网卡enp0s8创建一个配置
nmcli connection add ifname enp0s8 type ethernet ipv4.method auto
#在一个交互式的窗口中为ethernet-enp0s8编写配置
nmcli connection edit ethernet-enp0s8
#修改ethernet-enp0s8的网络参数
nmcli connection modify enp0s8 \ 
    connection.autoconnect yes \ #是否开机就启动这个配置
    ipv4.method manual \ #自动（DHCP）还是手动设定网络参数
    ipv4.addresses 192.168.x.x/24 \ #设定地址
    ipv4.gateway 192.168.x.x \ #设定网关
    ipv4.dns 192.168.x.x #设定DNS
#移除某个配置，只需要将该配置的值置为空
nmcli con modify ethernet-enp0s8 ipv4.dns ""
#为ethernet-enp0s8添加dns的配置（因为dns和ip能有多个配置，所以可以用+和-，不能有多个配置的不能用）
nmcli con modify ethernet-enp0s8 +ipv4.dns 8.8.8.8
#为ethernet-enp0s8删除ip的配置
nmcli con modify ethernet-enp0s8 -ipv4.addresses "192.168.100.25/24"
#修改配置名称
nmcli connection modify ethernet-enp0s8 con-name 


#列出所有的配置。
nmcli connection show 
#仅列出激活状态的配置。
nmcli connection show --active
#列出ethernet-enp0s8的配置。
nmcli connection show ethernet-enp0s8 

#激活enp0s8设备的配置。
nmcli connection up ifname enp0s8
#激活名称为ethernet-enp0s8的配置。
nmcli connection up ethernet-enp0s8 

#删除ethernet-enp0s8的配置
nmcli connection delete ethernet-enp0s8

#导入一个openvpn的配置给networkmanager
nmcli con import type openvpn file ~/Downloads/frootvpn.ovpn
```

#### ifcfg-xxx配置介绍

```
#最小配置
DEVICE=eth1  #网卡号，必须与文件名对应
ONBOOT=yes	#是否默认启动，要联网必须要配置
BOOTPROTO=none	#是否使用dhcp，是的话BOOTPROTO=dhcp
HWADDR=08:00:27:35:2F:f2	#mac地址
IPADDR=172.27.32.6	#ip地址
NETMASK=255.255.255.0	#子网掩码
GATEWAY=172.27.32.1	#网关
```

### firewall-cmd centos7下的防火墙工具

```sh
#查看防火墙的状态
systemctl status firewalld
#关闭防火墙并禁止开机自启
systemctl stop firewalld; systemctl disable firewalld
#启用防火墙并允许开机自启
systemctl start firewalld; systemctl enable firewalld
```

* 防火墙的服务名为firewalld，centos7使用firewall-cmd来管理防火墙。

* firewalld预先准备了几套防火墙策略集合（zone）。常见的zone：1. trusted允许所有的数据包；2. home；3. internal；4. work；5. public；6. external；7.dmz；8. block；9.drop。
* 常见命令：
  1. --get-default-zone查询默认的zone；- -set-default-zone设置默认的zone，--get-zones显示可用的zone；
  2.  --list-all显示当前区域的网卡配置参数、资源、端口及服务等信息； --list-all-zones显示所有区域的网卡配置参数、资源、端口及服务等信息；
  3.  --add-service=服务名、--remove-service=服务名；
  4.  --add-port=端口号/协议、--remove-port=端口号/协议；--list-ports列出已开放的端口。
  5. --add-forward-port=port=源端口号:proto=协议:toport=目标端口号:toaddr:目标ip地址。
  6.  --panic-on/--panic-off启动/关闭应急状态，阻断一切网络连接。
* firewalld设置只在下次重启前有效，如果需要永久生效，需要加上--permanent模式，并执行firewall-cmd --reload。

``` sh
#永久放开3306端口，并立刻生效
firewall-cmd --add-port 3306/tcp --permanent
firewall-cmd --reload
#永久拒绝192.168.10.0/24网段的所有用户访问本机的ssh服务。
firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.10.0/24" service name="ssh" reject"
```

### systemctl 管理unit

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

### RPM 软件管理机制

* RPM全称：RedHat Package Manager

* RPM是通过预先编译打包成RPM文件格式后，再加以安装的一种方式。RPM在打包软件的同时会加入一些其他的信息，包括软件版本、作者、**依赖的其他软件**等。RPM会在linux系统上建立一个RPM软件数据库，当要安装某个软件时，RPM会去在数据库里检测是否已经存在相关软件，如果不存在就不能安装。

* 当软件安装完毕后，该软件相关的信息就会被写入到`/var/lib/rpm`目录下的数据库文件中了。未来任何软件升级的需求，版本之间的比较都是来自于这个数据库。


*  `rpm -ivh package_name`安装软件
   * -i install；-v查看安装信息界面；-h显示安装进度
   * --force：强制安装，--test：测试一下该软件是否可以被安装到linux中
   * --prefix 新路径：将软件安装到其他路径
*  `rpm -Uvh/-Fvh file-1.0-1.e17.x86_64.rpm` 更新软件
   * -U：update后面的软件即使没有安装过，系统会直接安装，如果安装过旧版，系统会更新到新版。
   * -F：freshen后面的软件如果没有安装就不安装，如果安装过旧版就更行到新版。
*  `rpm -qa`查询本机所有已安装软件
   * `rpm -q package_name`查询后面的软件是否被安装
   * `rpm -qi package_name`列出该软件的详细信息
   * `rpm -ql package_name`列出该软件所有文件与目录
   * `rpm -qR package_name`列出该软件依赖那些软件
   * `rpm -qpR file-1.0-1.e17.x86_64.rpm`查询某个rpm文件依赖了哪些文件，-p表示指定的是一个rpm文件。
   * tips：在查询本机上已安装的软件时，只用加上软件的名称即可，版本号啥的都不需要。

### yum 包管理工具

当客户端有软件安装需求时，客户端会主动下载yum服务器中该软件的依赖清单，将该清单与本机的RPM数据库进行比较，就能安装未安装的依赖了。

yum提供了查找、安装、删除软件包的命令。

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

### netstat 显示网络状态

* `netstat -tulnp`用来获取目前主机已启动的服务
* -t/-u显示tcp/udp传输协议的连接情况
* -l显示监听状态的的服务
* `-a`显示所有连线中的socket
* `-n `：显示数字而不是别名
* -p显示socket的pid/程序名

### tcpdump 抓包命令

* `-i interface`监听指定的interface，如果未指定此参数，tcpdump会搜索系统interface上数字最小的interface（如eth0）监控。可以用`-i any`来监控所有的interface（此参数不会在promiscuous mode下工作）。
* `-X`显示原始16进制数据内容和ascii编码后的内容。
* `-D` 列出系统上可用的网络接口。
* `-A` 以ASCII的方式打印出每个包（不包括链路层头部）。
* `-nn`显示原始的ip地址和端口。
* `-v`产生详细的输出. 比如包的TTL，id标识，数据包长度，以及IP包的一些选项。
* [tcpdump](https://www.tcpdump.org/)
* 例子

```shell
#以ASCII的形式显示在本机所有网卡、端口5140上监听的数据
tcpdump -A -i any -n port 5140
#抓来源是10.0.1.81，目的端口是5140的数据
tcpdump -i any -nnA src host 10.0.1.81 and dst port 5140
#同时指定两个端口
tcpdump -i any -nnA port 8848 or port 5140
tcpdump -i any -nnA port 8848 or 5140
#指定端口范围
tcpdump -i any -nnA portrange 514-5140
#将抓到的数据保存到文件中
tcpdump icmp -w icmp.pcap
tcpdump icmp  -r icmp.pcap
```

### curl 强大的网络工具

* （client url）通过指定的url上传或者下载数据。

* `curl xiaoxiang.space`查看网页源码。
* `curl -o [文件名] xiaoxiang.space`保存文件。
* 使用`-L`参数，当有重定向时，会跳转到新的网址。
* `-i`显示http response的头信息，同时也会显示网页代码。
* `-I/--head`只显示http response。
* `-v`显示一次http通信的整个过程。
* 发送get请求和参数，直接把数据附加到网址后面就行。
* `curl -X POST --data-urlencode "data=xxx" example.com/xxx`发送post请求。`-X`参数可以支持几个动词。
* `--User-Agent`、`--cookie`等，`--header`增加一个头信息。
* `--user name:password`http认证。
* `-k`跳过ssl检测。
* `--limit-rate`限制HTTP请求和回应的带宽。
* **参考链接：**[curl网站开发指南 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2011/09/curl.html)
* **参考链接：**[curl 的用法指南 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)

### ps 获取当前时刻系统进程状态

* `ps aux`查询所有系统运行的进程
  
  * %CPU：使用的cpu资源百分比；%mem：使用的内存资源百分比；vsz：使用的虚拟内存Kb；rss：占用的固定内存Kb；tty：该进程是在哪个终端机上运行，如果于与终端机无关则显示？；stat：进程目前状态（R运行；S睡眠但可被唤醒；D不可被唤醒；T停止状态；Z僵尸状态）；time：实际使用cpu的时间。
  * `--sort +rss` 按照rss以递增[+]或者递减[-]的顺序排序 。
* 使用`ps -lf`显示当前的bash的进程。
  * -l时较详细的输出当前bash的信息，-f是更完整的输出。🤣
  * 输出中的S代表该进程的状态，主要的状态有：R running；S sleep；D 不可唤醒的睡眠状态，而可能是在等待I/O；T 停止状态；Z zombie僵尸状态。
  * PRI/NI priority/nice 代表此进程被cpu所执行的优先级。PRI值越低代表优先级越高。优先级是由内核动态调整的，用户无法干涉，如果需要调整进程的优先执行次序时，可以通过修改Nice的值。一般来说有PRI(new)=PRI(old)+nice，但是最终的PRI也是有系统分析后决定的，nice的值有正有负，当nice为负数时，该进程就会降低pri值，所以会被较为优先的处理。nice的值的范围是`-10~19`。一般使用者仅可以调整自己进程的nice值，范围为`0~19`，且只能将nice调高。使用nice和renice调整。
    * nice：新执行的指令给予新的nice值 `nice [-n 数字] command`。
    * renice：已存在进程的nice重新调整 `renice [-number] PID`。
  * ADDR/SZ/WCHAN  addr标识该进程在cpu的哪个部分，如果是running的进程，一般就会显示-，sz代表该进程用掉了多少的内存。wchaz代表进程目前是否在运行中。
  * TIME代表使用掉的cpu的时间。
* `ps axjf`可以列出来类似进程树的进程显示。
* `pstree [-Apu]` -p显示每个进程的pid，-u显示每个进程的所属账号。-A各个进程之间以ascii字符来连接。
* 相关文档 [The ps Command](http://www.linfo.org/ps.html)

### top 动态显示进程状态

* `top [-d n]`每隔n秒（默认为5）更新一次

  * 第一行显示的是：当前时间、开机到现今经过的时间、登入系统的人数、系统在1、5、15分钟的平均工作负载
  * 第二行显示进程总量、进程状态；第三行显示cpu整体负载；第四行和第五行显示物理内存和虚拟内存的使用情况。
  * 第三行（%Cpus...）显示的是CPU的整体负载，wa表示I/O wait
  * PR:priority，指进程的优先级、NI：Nice，于PR有关；TIME+表示CPU使用时间的累加
  * 执行过程中按下M表示以内存的使用来排序，N表示已PID来排序，P表示以CPU来排序，T表示以TIME+来排序，按下q可以离开top
  * `-p PID`观察指定PID
  * 在top执行过程中可以按下**`P`**使得以CPU的使用资源排序，按下**`M`**以内存的使用资源排序，按下**`N`**以PID来排序。按下`c`显示完整的路径和名称。

### kill 向进程发送signal

  * `kill -9 PID`立刻强制删除一个工作
  * `kill  [-15] PID`以正常的方式结束一个工作
  * 例：当使用vim时，会产生一个.filename.swp文件，使用-15时，vim会以正常的步骤结束vi的工作，所以.filename.swp会被主动的移除，但如果使用-9，由于vim工作被强制移除了，所以.filename.swp就会继续存在文件系统中。
  * 当想要进程执行某些动作时，可以给该进程一个工作号码，可以使用`kill -l `或者`man 7 signal`查到，主要的信号与名称对应关系。

| signal     | 内容                                                         |
| ---------- | ------------------------------------------------------------ |
| 1 SIGHUP   | 启动被终止的进程，可以让该PID重新读取自己的配置文件，类似于重新启动 |
| 2 SIGINT   | 相当于用键盘输入一个ctrl-c来中断一个进程的执行               |
| 9 SIGKILL  | 强制中断一个进程的进行                                       |
| 15 SIGTERM | 以正常的结束进程来终止该进程                                 |
| 19 SIGSTOP | 相当于使用键盘ctrl-z来暂停一个进程的执行。                   |

  * kill可以帮我们将signal传递给某个%jobnumber（参考下面的job和fg命令）或者某个PID。

### nohup和& 后台执行

* nohup会将标准输入重定向到/dev/null，将标准输出重定向到nohup.out（一般情况）或$HOME/nohup.out文件，将标准错误输出重定向到标准输出。
* `nohup COMMAND > FILE` 保存输出内容到文件。
* `nohup COMMAND &` 后台执行命令。
* 使用`&`可以将任务丢到后台执行，但标准输出和标准错误输出仍然会被输出到屏幕上。
* `&`将进程放到了背景执行，但是当退出bash后，进程就会被终止掉，如果需要退出bash后进程仍然能继续执行，可以使用nohup。nohup能在退出bash后还能继续执行工作。
* 例：`nohup java -jar xxx.jar </dev/null 2>&1 &` 将java命令放到后台执行，标准输出和标准错误输出都重定向到/dev/null

### job和fg 前台执行

* 可以使用`ctrl+z`将任务丢到背景，状态是暂停。
* 使用 `jobs -l`可以观察当前背景中的任务。其中+代表最近被放到背景，-代表最近倒数第二个被放到背景。
* 使用fg可以将背景工作拿到前台来执行。命令：`fg &jobnumber`。
* 删除背景中的工作。命令：`kill [-15 |-9] %jobnumber`。

### at与cron

#### at 只执行一次的任务

* 要使用at，需要先启动atd。我们使用at这个指令来产生要运行的工作，并将这个工作以文本文件的方式写入到/var/spool/at/目录内，该工作就能等待atd这个服务的取用与执行。
* at会先寻找/etc/at.allow这个文件，写在这个文件中的使用者可以使用at，不在这个文件中的用户不能使用at，即使用户没有写在at.deny中。如果不在这个文件中，at会寻找/etc/at.deny这个文件，写在这个文件中的使用者不能用at，不在这个文件中的使用者可以使用（也就是说两个文件存在一个就可以）。如果两个文件都不存在，就只有root可以执行at。
* at会将所有的标准输出和标准错误输出传送到执行者的mailbox中，解决方法是`echo "hello world" > /dev/tty1`。

```sh
at [-ldv] TIME
-l 相当于atq，列出当前系统上面所有当前用户的未执行的at排程。
-d 相当于atrm，取消一个在at排程中的工作
-c 列出后面接的第几项项工作的实际指令内容at -c 2
TIME: HH:MM [YYYY--MM-DD] 18:02 2021-10-29
	  HH:MM [Month] [Date] 18:02 October 29
	  HH:MM[am|pm] + number [minutes|hours|days|weeks]
#再过5分钟后执行，ctrl+d退出
at now + 5 minutes
#查询还没执行的任务
atq
#删除3这个任务
atrm 3
```

#### cron 定时任务

* 与at类似，cron也有两个限制文件，/etc/cron.allow和/etc/cron.deny，/etc/cron.allow比deny要优先，两个文件只选择一个来限制，所以保留一个即可。系统默认保留/etc/cron.deny。
* 当用户使用crontab指令来建立工作排程后，该项工作就会被记录到/var/spool/cron里面去，而且以账号来判别。cron执行的 每一项工作都会被记录到/var/log/cron这个文件中。
* 下达指令最好使用绝对路径；cron会每分钟去读取一次/etc/crontab与/var/spool/cron里面的数据，所以编辑完文件后，cron会按照设定自动执行。
* 放到`/etc/cron.hourly`目录内的所有执行文件（必须是shell脚本）会在每小时的一分钟开始后的5分钟内随机选择一个时间点来执行（详细请看/etc/cron.d/路径下的文件）。放到`/etc/cron.daily`、`/etc/cron.weekly`、`/etc/cron.monthly`下面的文件是由anacron执行的。而anacron执行方式是在`/etc/cron.hourly/0anacron`里面。
* crond预设有三个地方会有执行脚本配置文件，分别是`/etc/crontab` ,`/etc/cron.d/*`,`/var/spool/cron/*`。
* 当执行项目有输出时，该数据会mail给MAILTO设定的账号，所以如果不是很重要，将输出重定向到/dev/null中。
* 建议个人的话使用`crontab -e`来创建定时任务，系统维护人员直接使用`vim /etc/crontab`，开发的软件使用`vim /etc/cron.d/newfile`。

```sh
crontab [-u username] [-l | -e |-r]
-u 只有root可以使用这个参数。
-e 编辑crontab的工作内容
-l 查阅crontab的工作内容
-r 移除所有的crontab的工作内容，如果只移除一项，可以用-e编辑。
```

* 每项工作的格式都是具有六个字段，这六个字段的意义为：

| 分钟 | 小时 | 日期 | 月份 | 周                      | 指令 |
| ---- | ---- | ---- | ---- | ----------------------- | ---- |
| 0-59 | 0-23 | 1-31 | 1-12 | 0-7（0和7都表示星期天） | 指令 |

* 特殊符号

| 特殊符号 | 意义                                                         |
| -------- | ------------------------------------------------------------ |
| *        | 代表任何时刻                                                 |
| ,        | 代表该字段有多个参数，如每天3点和6点执行命令，为`0 3,6 * * * command` |
| -        | 表示一段时间范围内，如8点到12点之间每小时的20分都进行一项工作，`20 8-12 * * * command` |
| /n       | n代表数字，表示每隔n单位的时间执行一此，如每隔5分钟执行一次，`*/5 * * * * command`，也可以写成`0-59/5 * * * * command` |

* `/etc/crontab`

```sh
#使用哪种shell接口
SHELL=/bin/bash
#执行文件搜寻路径
PATH=/sbin:/bin:/usr/sbin:/usr/bin
#有输出时发给谁
MAILTO=root
#该文件中需要指定用户
1 * * * * *  username command
```

#### anacron

* `/etc/cron.daily`各字段含义：
  * 天数：anacron 执行当下与时间戳 (/var/spool/anacron/ 内的时间纪录文件) 相差的天数，若超过此天数，就准备开始执行，若没有超过此天数，则不予执行后续的指令。
  * 延迟时间：超过天数导致要执行定时任务，延迟执行的时间。
  * 工作名称定义：通常与后续的目录资源名称相同即可。
  * 实际要进行的指令串。

* anacron执行流程（cron.daily)：

1. 由 /etc/anacrontab 分析到 cron.daily 这项工作名称的天数为 1 天； 
2. 由 /var/spool/anacron/cron.daily 取出最近一次执行 anacron 的时间戳；
3. 由上个步骤与目前的时间比较，若差异天数为 1 天以上 (含 1 天)，就准备进行指令；
4. 若准备进行指令，根据 /etc/anacrontab 的设定，将延迟 5 分钟 + 随机n分钟 (看RANDOM_DELAY 的 设定)；
5.  延迟时间过后，开始执行后续指令，亦即『 run-parts /etc/cron.daily 』这串指令；
6. 执行完毕后， anacron 程序结束。

### free、uname、hostname、locale查看和设置系统信息

* `free -h`查看内存使用情况。
* `uname [-asrmpi]` -a表示所有；-s 系统核心名称；-r 核心的版本；-m 本系统的硬件名称(x86_64)；-p CPU的类型；-i 硬件的平台。
* `uptime`显示系统启动时间和工作负载。

* `hostnamectl [set-hostname 主机名]` 修改主机名。
* `timedatectl [list-timezones | set-timezone | set-time | set-ntp]` 列出系统上的失去、设定时区、设定时间、设定网络校时。
* `localectl set-locale LANG=en_US.utf8`设置语系。通过`locale -a`可以查看linux支持了多少语系，通过`locale`来查看系统目前的语言环境。LC_ALL、LC_CTYPE、LANG这三个环境变量的值决定了操作系统当前使用的是哪种字符集，优先级是`LC_ALL>LC_CTYPE>LANG`。
* 硬件数据收集：dmidecode(CPU型号、主板型号、内存相关型号等), gdisk, dmesg, vmstat（分析cpu、内存、io目前的状态）, lspci, lsusb,iostat。

### ls 列出文件

* ls 列出指定的目录下的文件
  * `-d 目录名`  列出目录名而不进入该目录。

### cat、tac、tail、wc 查看文件

* cat：从第一行开始显示文件内容
  * `-n`标上行号
* tac：从最后一行开始显示
* nl：显示的时候输出行号
* more：一页一页的显示文件内容
* less：与more类似，但是可以往前翻
  * `/srting`，向下搜索string
  * `?string`，向上搜索string
* head：只看头几行
  * 默认是显示10行
  * `head -n -100 filename`文件后面100行不显示
* tail：只看尾几行
  * 默认是显示10行
  * `tail -f filename`文件内容如果有增加，输出增加的内容
  * `-n num filename`输出文件末尾的n行，默认是10行
  * `tail -n +100 filename`文件第100行（包括）以后都会被列出来
* od：以二进制查看
* file：查看文件类型
* wc：查看文件里有多少字，多少行，多少字符。
  * wc [-lwm] -l表示列出多少行，-w表示列多多少字，-m表示列出多少字符。

### 重定向与管道

* 标准输入`<<`或`<`；标准输出`>>`或`>`；标准错误输出`2>`或`2>>`。
* `>`会覆盖原文件，`>>`会追加到文件中。如`find /home -name .bashrc > list_right 2> list_error`，将正确输出和错误输出存入到不同的文件中。
* 黑洞装置`/dev/null`，可以吃掉任何导向这个装置的信息。
* 将正确和错误输出都放到同一个文件中`find /home -name .bashrc > list 2>&1`。对2>&1的理解，这里2表示错误输出，意思是将错误输出重定向到标准输出，&1表示对标准输出的应用。
* 管道`|`只会处理标准输出，会忽略标准错误输出。
* 管道命令必须要接收上一个指令的标准输入，如less、more、head、tail时管道命令，而如ls、cp、mv就不是管道命令。
* 管道后面第一个必须是指令。
* 在管道中常常会使用前一个指令的输出作为后一个指令的输入，某些指令需要指定文件名来处理，该stdin和stdout可以使用`减号"-"`来替代。如`tar -cvf - /home | tar -xvf - -C /tmp/homeback`，这个命令是将/home里的文件打包，将打包的文件输出到stdout，后面的命令从stdin读取数据，所以我们就不需要文件名了，直接使用-代替。
* `xargs [OPTION] COMMAND [R]`：读入stdin的数据，并以空格符作为分割，将stdin分割成参数。
  * `xargs -n 1`表示每次执行指令值取一个参数。
  * `xargs -I R`将从标准输入获取到的数据替换后面命令的参数R。
  * 例：`ls *.jar | xargs -I {} -n 1 sh start.sh {}`

### grep 查找指定内容

* grep [-invAB]  '搜索字符串'  filename：查找文件或标准输出中的字符串，

  * -i表示忽略大小写。
  * -n表示输出行号。
  * `-v`：表示选择未匹配的行（反选）。
  * -A：--after-context，输出查找字符串后面n行。
  * -B：--before-context，输出查找字符串前面多少行
  * -r：递归查找当前路径下的包含指定内容的文件，同时输出包含此内容的行，-l只输出文件名。如查找指定路径下包含auth的文件：`grep -rl auth`。

### whereis、which、locale 查找文件

* whereis：针对几个特定目录查找文件，`whereis -l`查看这几个特定目录。

* which：根据PATH查看可执行文件。

* locate：根据/var/lib/mlocate内的数据库记载搜索文件（数据库未更新前搜索某新建的文件可能搜不到）。

### find：查找工具

* 用法`find [PATH] [option] [action]`，PATH可以是多个目录，find查找会进入子目录。

  * 查看/home下3天内有修改的文件`find /home -mtime 3`（如果是+3表示大于等于3天前的文件名，-3表示小于等于3天内的文件名）；
  * 查看/home下属于bes的文件`find /home -user bes`，查看不属于任何人的文件`find / -nouser`；
  * 查到/home下文件名包含了passwd的文件名`find /home -name "*passwd*"`;
  * 查看/home下文件类型为普通文件的文件名`find /home -type f`;
  * 查看文件权限大于755的文件名`find -perm /755`；
  * `find / -perm /7000 -exec ls -l {} \;`其中{}表示find找到的内容会放到{}中；-exec到\;是关键字，表示开始和结束。
  * find查找会直接去查找磁盘，可能比较慢。

### tar 压缩与解压工具

* `tar -xzvf xxx.tar.gz`解压文件
  * -x extract提取文件；-z通过gzip处理文件；-v：verbose显示执行过程；-f指定文件名
* `tar -cvzf 生成的文件名.tar.gz dir/`压缩文件
  * -c：create生成文件
  * tips：-C（大写）将文件放到指定文件夹
* `tar`
  * -c建立打包文件；-v查看执行过程；-x解压缩；-t查看打包文件内的情况；-C在特定目录解压缩；-z使用gzip解压缩；-j使用bzip2解压缩；-J使用xz解压缩；-f后面要立刻接上要被处理的文件名；-p保留备份数据原本权限与属性；--exclude=FILE压缩过程中不打包FILE。
* `gzip -[cdv#]`：-c将压缩的数据输出到屏幕；-d解压缩；-v显示出原文件/压缩文件的压缩比等信息；-#表示数字，-1最快但压缩比最差，-9最慢但压缩比最慢，-6是默认。使用gzip压缩时，原文件会被压缩为***.gz，原文件就不存在了。
* `bzip2 -[cdkzv#]`：-c将压缩的数据输出到屏幕上；-d解压缩；-k保留源文件；-z压缩（默认，可不加）；-v显示压缩比等信息；-#与gzip一样。文件名是xxx.bz2。
* `xz [-dtlkc#]`：-d解压缩；-t测试压缩文件完整性；-l列出压缩文件相关信息；-k保留原文件不删除；-c数据输出到屏幕上；-#和bzip2一样。-T0指定线程数量和CPU的数量一样。

### useradd、passed、usermod、userdel 用户账号管理

* 默认情况下所有的系统上的账号和一般身份使用者，都记录在/etc/passwd这个文件中，个人密码记录在/etc/shadow文件下，所有组名都记录在/etc/group中。
* 当输入账号密码登陆后，系统先1. 寻找/etc/passwd里面是否有输入的账号，有的话读取UID和GID以及该账号的home目录和shell；2. 进入/etc/shadow找出对应的账号与UID，然后和对密码是否相符；3. shell启动。
* 查看已登录系统上的用户，可以使用`who`。

#### /etc/passwd

* 每一行都代表一个账号，有几行就代表有几个账号在系统中。里面有很多账号本来就是系统正常运行所必需的，可以称之为系统账号。

```sh
#①账号名称:②x:③UID:④GID:⑤用户信息说明:⑥home目录:⑦shell
root:x:0:0:root:/root:/bin/bash
#账户名称需要和UID对应，UID就是使用者标识符，UID中0表示系统管理员；1～999表示系统账号（1～200表示系统自行建立的系统账号）；1000～60000就是给一般使用者使用的。一个UID可以包含多个用户
#早期unix密码放在此文件中，后来放到了/etc/shadow中，这里用x替代。
#GID与/etc/group有关。
#当用户登陆系统后就会取得一个shell来与核心沟通。
```

#### /etc/shadow

``` sh
#账号名称:密码:最近密码变动的日期:密码不可被更改的天数:密码需要修改的天数:密码需要变更前的警告天数:密码过期后多少天内还有效:账号失效日期:保留字段
#第四个字段的0表示随时都可以修改密码
root:$6$xtr:18894:0:99999:7:::
```

#### /etc/group

``` sh
#组名:x:GID:此群组支持的账号名称
#每个用户都可以有多个群组
root:x:0:dmtsai,alex
```

* 在/etc/passwd中有个GID，即初始群组，初始群组不会加在/etc/group的第四个字段。
* 使用`groups`命令可以获取当前账号所有的群组，输出的第一个群组为有效群组，新创建的一个文件使用的就是有效群组。通过`newgrp xxx`来切换有效群组。
* 相关命令：`groupadd groupmod groupdel`

#### useradd

* `-g 初始群组` 该字段会被添加到/etc/passwd第四个字段。 
* `-u UID -G 次要群组 -c 说明信息(/etc/passwd第五个字段) -r 系统账号 -s /bin/bash(指定一个初始的shell)`。
* -M 不建立home目录(系统账号默认) ；-m 建立home目录(一般账号默认)。
* useradd参考的是/etc/default/useradd文件，默认值可以通过`useradd -D`查看；除此之外，还参考了/etc/login.defs文件。
* 相关命令:`id chsh`

#### passwd

* 使用useradd建立了账号后，默认情况下无法使用该账号登陆，需要使用passwd设定密码。
* `-l` lock，会在/etc/shadow第二栏最前面加!使得密码失效，`-u` unlock，与-l相反；`-S` 列出秘密相关参数；`-n` 多久不可修改密码；`-x` 多久内必须修改密码； `-w` 密码过期前多少天开始警告 ；`-i` 密码失效日期；`--stdin` 从控制台获取输入。
* 其他命令`chage -l user`。

#### usermod

* 修改账号的数据。
* 添加群组`usermod -a -G wheel koal`

#### userdel

* 删除用户的相关数据。`-r`表示同时删除该用户的home目录。

### chgrp、chown、chmod 文件权限

* `chgrp [-R] 文件/文件夹` 改变文件的群组（必须是/etc/group中存在的）。

* `chown [-R] name:groupname 文件或目录`来修改文件的拥有者，-R表示递归。

* `chmod [-R] 文件/目录` 改变文件/目录的权限。

### su 切换用户

  * `su`单纯使用su切换为root身份时，表明切换为root身份。读取变量的设定方式为non-login shell的方式，这种方式很多原本的变量不会改变。
  * `su - username`使用该命令代表使用login-shell的变量文件来登入系统。
  * `su - -c 指令` 执行一次root的指令。

### sudo 以其他用户执行指令

* `sudo` 并非所有人都能执行sudo，只有/etc/sudoers内的用户能执行sudo这个指令。

  * `sudo [-u 用户] 指令` 以某个用户的身份执行指令。不加该参数表示使用root执行指令。
  * sudoers文件格式1：`使用者账号  登入者的来源主机名=（可切换的账号）  可下达的指令。` 可下达的指令必须使用绝对路径。
  * sudoers文件格式2： `%群组  ALL=(ALL)  ALL`
  * sudoers文件格式3： `%群组  ALL=(ALL)  NOPASSWD:ALL`
  * sudoers文件格式4：`myuser1 All=(root) !/usr/bin/passwd, /usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root`。表示myuser1可以执行除了passwd和passwd root外的所有指令。
  * 创建别名：

  ``` bash
  #别名必须大写
  User_Alias ADMPW=pro1,pro2,pro3 myuser1,myuser2
  Cmd_Alias ADMPWCOM=!/usr/bin/passwd, /usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root
  ADMPW ALL=(root) ADMPWCOM
  
  #可以使用sudo搭配su，将用户身份转换为root
  ADMPW ALL=(root) /bin/su -
  ```

  * sudo时间间隔为5min。
  

### ulimit 限制系统资源

* `ulimit` 限制用户的某些系统资源（比如可以开启的文件数量）

```sh
ulimit -[SHacdfltu] [配置]
-H #hard limit，严格的限制，必定不能超过这个设定的数值
-S #soft limit，警告的设定，可以超过这个设定值，但超过则有警告。
-a #可列出所有的限制，-标识没有限制。
-f #此shell可以建立的最大文件大小，单位为KB。
-t #可使用的最大CPU时间，单位为秒。
-u #单一用户可以使用的最大程序的数量。
-d #程序可以使用的最大segment容量。
-l #可用于锁定（lock）的内存量。

#一般身份如果设置了ulimit的值，通过注销再登录即可恢复，也可以重新设定

#限制只能建立10MB以下容量的文件
ulimit -f 10240
```

* `limits.conf`

```sh
#文件详细描述
vbird1 soft fsize 90000
#第一个字段为账号，或者为群组，如果是群组需要加上@。如果使用群组，这个功能只对初始群组有效。
#第二个字段为限制的模式，是严格hard还是警告soft。
#第三个字段为限制，比如是限制文件容量等。
#第四个字段为限制的值

#限制prol这个群组每次只能有1个用户登录
@prol hard maxlogins

#文件修改后需要重新登录才会有效。
```

### ACL

* Access Control List，用来提供在owner、group，others的rwx之外的权限设定，可以针对单一使用者，单一文件或目录来进行rwx的权限规范。

```sh
#检查系统是否支持ACL
dmesg | grep -i acl

#设定acl参数
setfacl[-bkRd] [{-m | -x} acl参数] 目标文件名
-m : 设定acl参数给文件使用
-x : 删除后面的acl参数
-b : 移除所有的acl参数设定
-k : 移除预设的acl参数
-R : 递归设定acl
-d : 设定预设的acl参数，只对目录有效，在该目录新建的数据都会引用此默认值

#为xiaoxiang用户设定文件的权限为rwx
#一个文件设定了ACL参数后，他的权限部分就会多出来一个+号。
setfacl -m u:xiaoxiang:rwx file1
#为文件使用者设定权限
setfacl -m u::rwx file2
#为群组设置权限
setfacl -m g:mygroup:rx file3
#为目录设置acl权限，未来文件的acl权限都继承此目录
setfacl -m d:u:xiaoxiang:rx /home/xiaoxiang/dir1
#让xiaoxiang无法使用该目录
setfacl -m u:xiaoxiang:- /home/xiaoxiang/dir2

#取消某个账号的ACL权限设定
setfacl -x u:xiaoxiang /home/xiaoxiang/file5

#获取file1的acl权限内容
getfacl file1
#结果中#开头的表示默认值
#结果中的mask表示用来规范最大允许权限
```



### df和du 查看磁盘信息

* `df -h`查看磁盘的信息。
* `du [-hskm] 文件或目录名称` 查看文件系统的磁盘使用量。
  * -h 易读的方式显示。
  * -s （summarize）列出总量。
  * -d （--max-depth=N）：N表示深度，1表示输出子文件夹的大小，2表述输出子文件夹的子文件夹的大小。
  * -a （--all） 不加该参数表示只统计文件夹，加该参数表示统计所有文件。
  * -k和-m 以kB/mB显示。

### mount 磁盘挂载

* `mount [-alt]LABLE=''/UUID=''/装置文件名 挂载点/umount`挂载与卸载
  * `mount /d /dev/sda2`将/dev/sda2挂载到/d。
  * `umount [-f] 挂载点或装置文件名` -f强制删除。
  * -n 不写入/etc/mtab。
  * -o后面可以跟一些挂载时额外加上的参数；1. asyn，sync 此文件系统是否使用同步写入（sync）或异步（async）的内存机制。默认为async。2. atime，noatime 是否修订文件的读取时间。3. ro，rw 挂载文件系统为只读或可写。auto，noauto 允许此文件系统被以mount -a自动挂载（auto）。4. dev，nodev 是否允许此文件系统上可建立装置文件。5.suid，nosuid 是否允许此文件系统上有suid的文件格式。6. ecex，noexec 是否允许此文件系统上有可执行文件。7. user，nouser 是否允许此文件系统让任何使用者执行mount，一般mount只有root可以进行，但下达该命令后，一般user也能对其进行挂载。8. defaults 默认为rw，suid， dev，exec，auto，nouser，async。9. remount 重新挂载。
  * -a 依照配置文件/etc/fstab的数据将所有未挂载的磁盘挂载。
  * -t 要挂载的文件系统的类型。
* 开机挂载(修改/etc/fstab[filesystem table]）
  * 参数格式：装置/UUID/LABEL 挂载点 文件系统 文件系统参数 dump fsck
  * 例：UUID=XXX（使用blkid查询） /d ntfs defaults 0 0
  * /etc/fstab是开机时的配置文件，实际的filesystem的挂载记录到/etc/mtab和/proc/mounts这两个文件中。
  
* `sh -c "xxx"` 将一个字符串作为完整的命令来执行。 
* `history  n`用来查询过去执行的指令，n表示显示最近n个命令。bash会记录使用过的指令，默认记录1000个，指令存放位置在~/.bash_history中。该文件会记录上一次登录之前的指令，而这一次登录所执行的指令都存在内存中，当注销后，这些指令才会记录到.bash_history中。
* 使用write可以给linux上的其他用户发消息，通过`who`可以查看目前有谁在线。通过`write koal`给所有以koal登录的用户发消息。通过`mesg n`来关闭接收消息，但无法拒绝root的消息。通过`mesg y`来开启接收消息。使用wall可以对系统上所有的用户发送消息`wall "hello world"`。

### man（manual）用户手册

* man中有几个常用的数字的含义：1 用户在shell环境中可以操作的指令或可执行文件；4 装置文件的说明，通常在/dev下的文件；5 配置文件或者某些文件的格式；7 惯例与协议等；8 系统管理员可用的指令。例：`man 8 sudo`。
* man page一般包含：①NAME：简短的说明；②SYNOPSIS：简短的指令下达语法说明；③DESCRIPTION：较完整的说明；④OPTIONS；⑤COMMANDS：当这个程序执行的时候，可以在此程序中下达的指令。⑥FILES：关联的文件；⑦SEE ALSO：其他可以参考的信息；⑧EXAMPLE：一些可以参考的范例。
* 快捷键：空格键:向下翻一页    [Page Up]:向上翻一页    [Page Down]:向下翻一页    [Home]:去第一页    [End]:去最后一页    /string:向下搜索string    ?string:向上搜索string    n/N:n表示下一个搜索，N表示上一个搜索。

### SELinux

* 全称是Security Enhanced Linux。SELinux是在进行进程、文件等细部权限设定依据的一个核心模块。SELinux提供了一些预设的策略（Policy），并在政策内提供了多个规则（rule）。
* 自主式访问控制（Discretionary Access Control，DAC）是根据进程的拥有者与文件资源的rwx权限来决定有无存取的能力。
* 委任式访问控制（Mandatory Access Control，MAC）可以根据特定的进程和特定的文件资源来进行权限的管控，即使是root，在使用不同的进程时，取得到的权限不一定是root，而要看当时进程的设定而定。控制的主体由使用者变成了进程。
* SELinux是通过MAC的方式来管控进程，控制的主体是进程，而目标是该进程能否读取的文件资源。
  * 主体（Subject）：即进程。
  * 目标（Object）：主体目标能否存取的目标资源，一般就是文件系统。
  * 策略（Policy）：由于进程和文件数量庞大，SELinux会依据某些服务来制定基本的存取安全性策略，这些策略中由详细的规则（rule）来指定不同的服务开放某些资源的存取与否。Linux里提供了三个主要的策略，分别是：
    * targeted：针对网络服务限制多，针对本机限制少，是预设的策略。
    * minimum：仅针对选择的进程来保护。
    * mls：完整的SELinux限制，限制较为严格。
  * 安全性本文（security context）：主体能不能存取目标除了策略指定外，主体和目标的安全性本文必须一致才能够顺利存取，安全性本文类似于文件系统的rwx。
* 主体如果要存取目标，首先需要通过SELinux政策内的规则；其次与目标资源的安全性本文对比；最后再检查目标的rwx权限。

#### 安全性文本

* 文件的安全性文本是放到文件的inode内的，可以使用`ls -Z`去观察安全性文本。
* 安全性文本主要用冒号分为三个字段。`identify:role:type`。
* 身份识别（Identify），常见的有：
  * unconfined_u：不受限的用户，也就是说该文件来自于不受限的进程所产生的。
  * system_u：系统用户，大部分就是系统自己产生的。
* 基本上如果是系统或软件本身所提供的文件，大多就是system_u这个身份名称，如果是用户透过bash自己建立的文件，大多数是不受限的unconfined_u，如果是网络服务所产生的文件，或者是系统服务运作过程中产生的文件，大部分的识别就会是system_u。
* 角色（Role）
  * object_r：代表的是文件或目录等文件资源。
  * system_r：代表的就是进程。
* 类型（Type），一个主体进程能不能读取到资源，与类型有关，类型在文件和进程中的定义不太相同。在文件资源上称为类型Type，在进程上称为领域domain。

#### SELinux三种模式的启动、关闭和观察

* SELinux目前共有三种模式，分别为：
  * enforcing：强制模式，代表SELinux正确的开始限制domain/type了。
  * permissive：宽容模式，表示不会实际限制domain和type，但会有警告信息。
  * disable：关闭，代表SELinux并没有实际运作。

```sh
#获取当前的SELinux模式
getenforce
#查询当前的策略
sestatus 
#修改策略，修改/etc/selinux/config的SELINUX=enforcing
#SELinux在enforcing和permissive之间切换无需重启
#切换到disable或者从disable切换到其他需要重启
setenforce [0|1] #0表示permissive，1表示Enforcing
```

<!--more-->
