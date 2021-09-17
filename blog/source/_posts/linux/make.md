---
title: make
categories:
  - [linux]
site: linux
date: 2021-09-16 19:55:13
---

* 当执行make时，make会在当时的目录下搜索Makefile（makefile）文件，而makefile里面则记录了原始码如何编译的详细信息，make按照makefile去编译这些文件。当在编译完成之后，修改了某个源码文件，执行make时，make只会针对被修改的文件进行编译。通常软件开发商会写一支侦测程序来侦测使用者的作业环境，以及该作业环境是否有软件开发商所需要的其他功能，在侦测程序侦测完毕后，会主动建立Makefile，通常这个检查程序的文件名为configure或config。

* tarball就是将软件的所有原始码文件先以tar打包，然后再压缩。tarball文件通常包括：源代码文件；侦测程序文件（configure或config）；本软件的简易说明和安装说明（INSTALL或README）。

```sh
#-lm表示的是使用libm.so这个库，这个命令可以拆成两部分来看：l表示加入到某个函数库，m表示使用libm.so这个库，lib和扩展名.so或.a不需要写。
#-L/lib表示在这个路径下寻找库。
gcc test.c -lm -L/lib -L/lib64
#-I后面跟的路径就是设置要去搜索的include文件（如c语言的头文件）的目录。
gcc test.c -lm -I/usr/include
#将源码编译为目标文件，不链接
gcc -c hello.c
#-o将编译的结果输出为特定的文件，-Wall会输出经过信息。
gcc -o hello hello.c -Wall
```

#### makefile文件规则

```makefile
#变量左右可以有空格，变量左边不能有tab键；变量和变量内容在等号两边不能有":"。
#变量习惯以大写字母为主。
#使用${xxx}或者$(xxx)来使用变量。
LIBS = -lm
OBJS = hello.o test.o
main:${OBJS}
	#tab必须是命令的第一个字符
	GCC -O MAIN ${OBJS} ${LIBS}
clean:
	rm -rf main ${OBJS}
	
#通过make clean来执行命令
#$@表示当前的目标，如这里的clean或main
```

* 一般情况下，安装的基本步骤是：①./configure；②make clean；③make；④make install。

* 通常会将自己安装的软件放到/usr/local下，将源代码放到/usr/local/src下。

[鸟哥的 Linux 私房菜 -- 第二十一章、软件安装：源代码与 Tarball (vbird.org)](http://linux.vbird.org/linux_basic/0520source_code_and_tarball.php#intro_make)
