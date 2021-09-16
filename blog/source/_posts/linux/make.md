---
title: make
categories:
  - [linux]
site: linux
date: 2021-09-16 19:55:13
---

当执行make时，make会在当时的目录下搜索Makefile（makefile）文件，而makefile里面则记录了原始码如何编译的详细信息，make会自动的判断原始码是否已经变动了，而自动更新执行文件。通常软件开发商会写一支侦测程序来侦测使用者的作业环境，以及该作业环境是否有软件开发商所需要的其他功能，在侦测程序侦测完毕后，会主动建立Makefile，通常这个检查程序的文件名为configure或config。

[鸟哥的 Linux 私房菜 -- 第二十一章、软件安装：源代码与 Tarball (vbird.org)](http://linux.vbird.org/linux_basic/0520source_code_and_tarball.php#intro_make)
