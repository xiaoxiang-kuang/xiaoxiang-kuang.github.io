---
title: bash
categories:
  - [linux]
site: linux
date: 2021-09-09 16:28:01
---

* 用户可以透过应用程序来指挥kernel，让kernel来完成我们所需要的硬件任务，因为程序是在最外层，类似鸡蛋的外壳一样，所以就叫壳程序（shell）。shell是提供用户操作系统的一个接口。
* bash全称就是Bourne Again SHell，是linux预设的shell。
* 系统中合法的shell都会写入到/etc/shells这个文件。当用户登录的时候，系统会提供一个shell，这个shell就记录在/etc/passwd这个文件中。
* `alias lm='ls -al'`：给命令设定别名；`alias`：可以查看系统的所有别名；使用`unalias lm`取消别名。
* bash有很多内建指令，如cd等，可以通过type这个指令观察。
* 一行输不完，可以通过\\来换行。
* ulimit限制用户的某些系统资源。

### 变量

* 环境变量如PATH等，通常使用大写字符来表示，当输入了一个命令ls，系统会通过PATH这个遍历里面的内容记录的路径来顺序搜索指令。

* 变量在使用时，需要加上在前面加上`$`。如`$PATH,${PATH}`。

#### 变量的设定规则

1. 设定变量直接使用等号=，如`myname=xiaoxiang`；
2. 等号两边不能有空格；
3. 变量内容若有空格可以使用单引号或者双引号括起来，但是双引号内的特殊符号如`$`会保持原本的特性，而单引号内的特殊字符则是**纯文字**。
4. 可以使用`\`来转义特殊字符，使其变成一般字符。
5. 当一串指令中要包含其他的指令，可以使用\`（反撇）或者$(ls)包着。
6. 当需要为变量扩增内容内容时，可以使用`PATH=$PATH:/home/bin`
7. 通过`export JAVA_HOME`使得变量JAVA_HOME变成了环境变量。
8. 通常大写字符为系统默认变量，自行设定的变量可以使用小写字符。
9. 取消变量可以使用`unset myname`。



* 子程序：在当前shell的情况下，去启动另一个新的shell，新的shell就是子程序。子程序会继承父进程的环境变量，但不会继承父进程的自定义变量。
* 通过`env`和`export`可以查询系统中所有的环境变量。
* `$`本身也是一个变量，代表着当前shell的PID，通过`$$`使用该变量。
* `?`是一个变量，代表上一个指令传回来的值，一般来说，当我们成功执行了一个指令，则会返回0值，如果执行错误，就会传回一个错误代码。
* 通过`locale -a`可以查看linux支持了多少语系，通过`locale`来查看系统目前的语言环境。通过`export LANG=zh_CN.UTF8`来设置。

#### read，array，declare

* read可以读取键盘输入的变量。如`read -p "please input:" -t 10 name `。其中-p是提示信息，-t是倒计时，系统不会一直等待输入，name就是变量，会将输入的信息给这个变量。
* declare、typeset是宣告变量的类型（shell默认类型是字符串）。
  * `declare -a var`将var声明为数组类型array。
  * `declare -i var`将var声明为整数类型integer（bash中的数值计算最多只能达到整数形态）。
  * `declare -x var`将var声明为环境变量。
  * `declare -r var`将变量声明为只读类型readonly，改变量不可更改，不能unset。
  * `declare -p var`查看变量的类型。



* login shell是取得bash时需要输入完整的登录账号密码的就是login shell。
* non-login shell就是取得bash接口不需要重复的登入。如从图形化界面进入linux后，开启每个bash都不需要再次输入用户名和密码。这就是non-login shell。
* login shell会读取`/etc/profile`（系统整体的设定）和`~/.bash_profile或~/.bash_login或~/.profile`（个人的设定）的文件。
* source可以立即读入配置文件的内容。

#### 通配符与特殊符号

| 符号 | 意义                                                         |
| ---- | ------------------------------------------------------------ |
| *    | 代表0到无穷多个任意字符                                      |
| ？   | 代表一定有一个的任意字符                                     |
| []   | 代表一定有一个在括号内的字符                                 |
| [-]  | 表示一定有一个在编码顺序内的所有字符，如[0-9]表示一定有一个数字 |
| [^]  | 表示反向选择，如[\^abc]就表示一定有一个字符，但不是abc中的一个。 |

* 标准输入`<<`或`<`；标准输出`>>`或`>`；标准错误输出`2>`或`2>>`。`>`会覆盖原文件，`>>`会追加到文件中。如`find /home -name .bashrc > list_right 2> list_error`，将正确输出和错误输出存入到不同的文件中。
* 黑洞装置`/dev/null`，可以吃掉任何导向这个装置的信息。
* 将正确和错误输出都放到同一个文件中`find /home -name .bashrc > list 2>&1`。

