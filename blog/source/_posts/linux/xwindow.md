---
title: xwindow
categories:
  - [linux]
site: linux
date: 2021-11-15 14:28:47
---

* linux上的图形用户接口GUI被称为X或者X11。
* X11是一个软件，利用网络构架来进行图形接口的执行与绘制。

### X11 

* X Server是管理硬件，X Client则是应用程序。X Client应用程序将所想要呈现的画面告诉X Server，X Server将结果透过他管理的硬件绘制出来。

#### X Server 硬件管理、屏幕绘制与字符提供功能

* X Server管理的设备主要与输入/输出有关，包括键盘、鼠标、手写板、显示器、屏幕分辨率与颜色深度、显示是配置与显示的字符等。
* **每台客户端主机都需要安装X Server，而服务器则是提供X Client软件，以提供客户端绘图所需要的数据。**
* X Server和X Client的互动并非只有client-->server，两者实际上是有互动的，X Server会将来自输入设备（键盘、鼠标等）的动作告知X Client。

#### X Client 负责X Server要求的事件处理

* X Client也可以叫X Application。
* X Server管理显示接口与在屏幕上绘图，同时将输入设备的行为告知X Client，此时X Client会依据这个输入设备的行为来开始处理，再将结果传回X Server，X Server再根据X Client传回来的绘图资料将它描述在自己的屏幕上，来得到显示的结果。

#### X Window Manager 特殊的X Client，负责管理所有的X Client

* 窗口管理员提供许多的控制元素，包括任务栏、桌面背景的设定等等；管理虚拟桌面；提供窗口控制参数，包括窗口的大小、窗口的重叠显示、窗口的移动、窗口的最小化等等。

#### Display Manager 提供登入需求

* gdm全称GNOME Display Manager；一般通过图形界面登入系统的那个登录界面就是Display Manager。

#### X Window的启动

* 通过startx启动：`startx [X client参数] -- [X server参数]`，startx是一个shell脚本。
  * startx最重要的任务是找出用户或者系统默认的X server和X client配置文件，它可以直接启动，也可以外接参数启动。
  * startx的X server参数的优先级如下：①通过命令行传递的参数；②~/.xserverc；③/etc/X11/xinit/xserverrc；④单纯执行/usr/bin/X（X server执行文件）。
  * startx的X client参数优先级如下：①startx后面跟的参数；②~/.xinitrc；③/etc/X11/xinit/xinitrc；④单纯执行xterm。
  * 当startx找到需要的设定值后，就呼叫xinit来启动X。`xinit [client option] -- [server or display option]`。
  * 当单纯执行xinit的时候，默认执行的命令为`xinit xterm -geogmetry _1_1 -n login -display :0 -- X :0`。-display:0表示这个虚拟机是第:0号的X显示接口。一般会使用startx来启动xwindow，因为startx会自动找到对应的参数。
* xserverrc
  * 在启动X server时，Xorg会去读取/etc/X11/xorg.conf这个配置文件。linux通过执行`X`来启动X server，linux可以同时启动多个X，第一个X的画面在:0即tty2，第二个X是:1即tty3。

