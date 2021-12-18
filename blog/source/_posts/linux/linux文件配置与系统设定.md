---
title: linux文件配置与系统设定
categories:
  - [linux]
site: linux
date: 2021-09-24 19:27:36
---

## 系统设定

### 网络

#### nmcli

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

#### 防火墙

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



### 进程

* 进程（process）：程序被触发后，执行者的权限与属性、程序及程序所需的数据都会被加载到内存中，操作系统给与这个内存内的单元一个标识符PID。
* 当登入系统后，会取得一个bash，当使用这个bash提供的接口去执行另一个指令时，另外执行的指令也会生成PID，这个新进程就是子进程，而原来的bash环境就是父进程。linux中进程通常由父进程以复制(fork)的方式产生一个一摸一样的子进程，然后被复制出来的子进程再以exec的方式来执行实际要进行的程序，最终就会成为一个子进程。

  1. 系统先以fork的方式复制一个与父进程相同的暂存进程，这个进程与父进程唯一的差别就是PID不同，此外这个暂存进程还会多一个PPID（parient pid）的参数。
  2. 暂存进程开始以exec的方式加载实际要执行的程序。
* 常驻内存中的进程通常提供一些功能以服务用户，因此这些常驻程序就会被称为：服务（daemon）。

### 开机

#### 流程如下

1. 加载BIOS的硬件信息、进行自我测试，根据设定取得第一个可开机的装置；
2. 读取并执行第一个开机装置内的MBR的bootloader（如grub2）；
3. 依据bootloader的设定载入kernel，kernel会开始侦测硬件和载入驱动程序；
4. 在硬件驱动成功后，kernel会主动呼叫systemd程序，并以default.target流程开机；
   1. systemd执行sysinit.target初始化系统及basic.target准备操作系统；
   2. systemd启动multi-user.target下的服务；
   3. systemd执行multi-user.target下的/etc/rc.d/rc.local文件；
   4. systemd执行multi-user.target下的getty.target及登入服务；
   5. systed执行graphical需要的服务。

#### BIOS（UEFI）、MBR（GPT）、bootloader

* BIOS（固件）是开机的时候，计算机系统会主动执行的第一个程序。通过BIOS去加载CMOS的信息，通过CMOS内的设置取得主机的各项硬件设置。例：CPU与周边设备的沟通时钟、开机设备的搜寻顺序、硬盘的大小和类型等，取得这些信息后，BIOS还会进行开机自测试（Power-on Self Test），然后开始执行硬件侦测的初始化，并设定PnP设备。之后再定义出可开机设备顺序，接下来就会开始进行开机设备的读取了。BIOS通过硬件的INT13中断功能来读取MBR，只要BIOS能检测到硬盘，就能通过INT13来读取磁盘的第一个磁区内的MBR软件。
* UEFI（Unified Extension Firmware Interface）是取代BIOS的。
* 整颗磁盘的第一个扇区特别重要，它记录了整颗磁盘的重要信息，早期磁盘的第一个扇区的包含重要的分区格式MBR（master boot record），后来多了一个新的磁盘分区格式，称为GPT（guid partition table）。
* MBR可以安装开机管理程序，其和分区表通常放在磁盘的第一个扇区，这个扇区通常是512字节。开机管理程序占446字节，分区表占64字节。分区表最多只能有四组记录。
* GPT将磁盘的所有区块以LBA（logical block address，预设为512字节）来规划，GPT使用34个LBA区块来记录分区信息，整个磁盘的最后33个LBA拿来作为备份。
* boot loader的功能：①提供菜单；②装入核心文件；③转交其他loader。每个文件系统都会保留一块开机扇区提供操作系统安装bootloader，通常操作系统会安装一份boot loader到他自己的文件系统中。

![](/img/linux/linux基础设定/1.png)

* 当boot loader开始读取内核文件后，linux会将核心解压到内存中，并使用核心的功能，开始测试cpu、网卡、声卡等装置，此时linux核心会以自己的功能重新侦测一次硬件。一般来说，核心文件被放在/boot中，并取名为/boot/vmlinuz。linux核心可以动态加载模块，这些核心模块放在/lib/modules目录中，开机过程中根目录采用只读方式挂载。虚拟文件系统（Initial RAM Filesystem）一般使用的文件名为/boot/initrd或/boot/initramfs。



* linux预设情况下会提供6个终端让使用者登陆，切换方式为[ctrl]+[alt]+[f1]~[f6]，6个终端命名为tty1～tty6。在centos7中，开机后系统只会提供一个tty，其他的是不存在的，当要切换时，系统才产生额外的tty2，tty3...。

## 账号

* 默认情况下所有的系统上的账号和一般身份使用者，都记录在/etc/passwd这个文件中，个人密码记录在/etc/shadow文件下，所有组名都记录在/etc/group中。
* 当输入账号密码登陆后，系统先1. 寻找/etc/passwd里面是否有输入的账号，有的话读取UID和GID以及该账号的home目录和shell；2. 进入/etc/shadow找出对应的账号与UID，然后和对密码是否相符；3. shell启动。
* 查看已登录系统上的用户，可以使用`who`。

### /etc/passwd

* 每一行都代表一个账号，有几行就代表有几个账号在系统中。里面有很多账号本来就是系统正常运行所必需的，可以称之为系统账号。

```sh
#①账号名称:②x:③UID:④GID:⑤用户信息说明:⑥home目录:⑦shell
root:x:0:0:root:/root:/bin/bash
#账户名称需要和UID对应，UID就是使用者标识符，UID中0表示系统管理员；1～999表示系统账号（1～200表示系统自行建立的系统账号）；1000～60000就是给一般使用者使用的。一个UID可以包含多个用户
#早期unix密码放在此文件中，后来放到了/etc/shadow中，这里用x替代。
#GID与/etc/group有关。
#当用户登陆系统后就会取得一个shell来与核心沟通。
```

### 其他相关文件

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

### 命令

* useradd
  * `-g 初始群组` 该字段会被添加到/etc/passwd第四个字段。 
  * `-u UID -G 次要群组 -c 说明信息(/etc/passwd第五个字段) -r 系统账号 -s /bin/bash(指定一个初始的shell)`。
  * -M 不建立home目录(系统账号默认) ；-m 建立home目录(一般账号默认)。
  * useradd参考的是/etc/default/useradd文件，默认值可以通过`useradd -D`查看；除此之外，还参考了/etc/login.defs文件。
  * 相关命令:`id chsh`
* passwd
  * 使用useradd建立了账号后，默认情况下无法使用该账号登陆，需要使用passwd设定密码。
  * `-l` lock，会在/etc/shadow第二栏最前面加!使得密码失效，`-u` unlock，与-l相反；`-S` 列出秘密相关参数；`-n` 多久不可修改密码；`-x` 多久内必须修改密码； `-w` 密码过期前多少天开始警告 ；`-i` 密码失效日期；`--stdin` 从控制台获取输入。
  * 其他命令`chage -l user`。
* usermod
  * 修改账号的数据。
  * 添加群组`usermod -a -G wheel koal`
* userdel：删除用户的相关数据。`-r`表示同时删除该用户的home目录。
