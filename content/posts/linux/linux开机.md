---
title: linux开机
tags: 
  - linux
date: 2021-09-24 19:27:36
---

### 流程如下

1. 加载BIOS的硬件信息、进行自我测试，根据设定取得第一个可开机的装置；
2. 读取并执行第一个开机装置内的MBR的bootloader（如grub2）；
3. 依据bootloader的设定载入kernel，kernel会开始侦测硬件和载入驱动程序；
4. 在硬件驱动成功后，kernel会主动呼叫systemd程序，并以default.target流程开机；
   1. systemd执行sysinit.target初始化系统及basic.target准备操作系统；
   2. systemd启动multi-user.target下的服务；
   3. systemd执行multi-user.target下的/etc/rc.d/rc.local文件；
   4. systemd执行multi-user.target下的getty.target及登入服务；
   5. systed执行graphical需要的服务。

### BIOS（UEFI）、MBR（GPT）、bootloader

* BIOS（固件）是开机的时候，计算机系统会主动执行的第一个程序。通过BIOS去加载CMOS的信息，通过CMOS内的设置取得主机的各项硬件设置。例：CPU与周边设备的沟通时钟、开机设备的搜寻顺序、硬盘的大小和类型等，取得这些信息后，BIOS还会进行开机自测试（Power-on Self Test），然后开始执行硬件侦测的初始化，并设定PnP设备。之后再定义出可开机设备顺序，接下来就会开始进行开机设备的读取了。BIOS通过硬件的INT13中断功能来读取MBR，只要BIOS能检测到硬盘，就能通过INT13来读取磁盘的第一个磁区内的MBR软件。
* UEFI（Unified Extension Firmware Interface）是取代BIOS的。
* 整颗磁盘的第一个扇区特别重要，它记录了整颗磁盘的重要信息，早期磁盘的第一个扇区的包含重要的分区格式MBR（master boot record），后来多了一个新的磁盘分区格式，称为GPT（guid partition table）。
* MBR可以安装开机管理程序，其和分区表通常放在磁盘的第一个扇区，这个扇区通常是512字节。开机管理程序占446字节，分区表占64字节。分区表最多只能有四组记录。
* GPT将磁盘的所有区块以LBA（logical block address，预设为512字节）来规划，GPT使用34个LBA区块来记录分区信息，整个磁盘的最后33个LBA拿来作为备份。
* boot loader的功能：①提供菜单；②装入核心文件；③转交其他loader。每个文件系统都会保留一块开机扇区提供操作系统安装bootloader，通常操作系统会安装一份boot loader到他自己的文件系统中。

![](/img/linux/linux基础设定/1.png)

* 当boot loader开始读取内核文件后，linux会将核心解压到内存中，并使用核心的功能，开始测试cpu、网卡、声卡等装置，此时linux核心会以自己的功能重新侦测一次硬件。一般来说，核心文件被放在/boot中，并取名为/boot/vmlinuz。linux核心可以动态加载模块，这些核心模块放在/lib/modules目录中，开机过程中根目录采用只读方式挂载。虚拟文件系统（Initial RAM Filesystem）一般使用的文件名为/boot/initrd或/boot/initramfs。

* linux预设情况下会提供6个终端让使用者登陆，切换方式为[ctrl]+[alt]+[f1]~[f6]，6个终端命名为tty1～tty6。在centos7中，开机后系统只会提供一个tty，其他的是不存在的，当要切换时，系统才产生额外的tty2，tty3...。
  <!--more-->
