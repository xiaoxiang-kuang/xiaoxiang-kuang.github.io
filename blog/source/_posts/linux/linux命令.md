---
title: linux命令
categories:
  - [linux]
site: linux
date: 2021-02-08 11:29:58
---

* linux在下达一个指令时，会按照以下的顺序寻找（所以当直接在bash中输入xxx.sh时是不会执行的）：

1. 以相对/绝对路径执行指令如/bin/ls，或./ls。
2. `alias lm='ls -al'`：给命令设定别名；`alias`：可以查看系统的所有别名；使用`unalias lm`取消别名。
3. 由bash内建的指令来执行。
4. 通过$PATH这个变量的顺序搜寻到第一个指令来执行。



* `history  n`用来查询过去执行的指令，n表示显示最近n个命令。bash会记录使用过的指令，默认记录1000个，指令存放位置在~/.bash_history中。该文件会记录上一次登录之前的指令，而这一次登录所执行的指令都存在内存中，当注销后，这些指令才会记录到.bash_history中。
* `curl`（client url）通过指定的url上传或者下载数据。
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

## 系统管理

### 网络

* netstat：显示网络状态
  * `netstat -tulnp`用来获取目前主机已启动的服务
  * -t/-u显示tcp/udp传输协议的连接情况
  * -l显示监听状态的的服务
  * `-a`显示所有连线中的socket
  * `-n `：显示数字而不是别名
  * -p显示socket的pid/程序名
  

### 进程

* `ps aux`查询所有系统运行的进程
  
  * %CPU：使用的cpu资源百分比；%mem：使用的内存资源百分比；vsz：使用的虚拟内存Kb；rss：占用的固定内存Kb；tty：该进程是在哪个终端机上运行，如果于与终端机无关则显示？；stat：进程目前状态（R运行；S睡眠但可被唤醒；D不可被唤醒；T停止状态；Z僵尸状态）；time：实际使用cpu的时间。
* `top [-d n]`每隔n秒（默认为5）更新一次

  * 第一行显示的是：当前时间、开机到现今经过的时间、登入系统的人数、系统在1、5、15分钟的平均工作负载
  * 第二行显示进程总量、进程状态；第三行显示cpu整体负载；第四行和第五行显示物理内存和虚拟内存的使用情况。
  * 第三行（%Cpus...）显示的是CPU的整体负载，wa表示I/O wait
  * PR:priority，指进程的优先级、NI：Nice，于PR有关；TIME+表示CPU使用时间的累加
  * 执行过程中按下M表示以内存的使用来排序，N表示已PID来排序，P表示以CPU来排序，T表示以TIME+来排序，按下q可以离开top
  * `-p PID`观察指定PID
* `kill `

  * `kill -9 PID`立刻强制删除一个工作
  * `kill  [-15] PID`以正常的方式结束一个工作
  * example：当使用vim时，会产生一个.filename.swp文件，使用-15时，vim会以正常的步骤结束vi的工作，所以.filename.swp会被主动的移除，但如果使用-9，由于vim工作被强制移除了，所以.filename.swp就会继续存在文件系统中。
* nohup
  * nohup会将标准输入重定向到/dev/null，将标准输出重定向到nohup.out（一般情况）或$HOME/nohup.out文件，将标准错误输出重定向到标准输出。
  * `nohup COMMAND > FILE` 保存输出内容到文件。
  * `nohup COMMAND &` 后台执行命令。


### man（manual）

* man中有几个常用的数字的含义：1 用户在shell环境中可以操作的指令或可执行文件；4 装置文件的说明，通常在/dev下的文件；5 配置文件或者某些文件的格式；7 惯例与协议等；8 系统管理员可用的指令。例：`man 8 sudo`。
* man page一般包含：①NAME：简短的说明；②SYNOPSIS：简短的指令下达语法说明；③DESCRIPTION：较完整的说明；④OPTIONS；⑤COMMANDS：当这个程序执行的时候，可以在此程序中下达的指令。⑥FILES：关联的文件；⑦SEE ALSO：其他可以参考的信息；⑧EXAMPLE：一些可以参考的范例。
* 快捷键：空格键:向下翻一页    [Page Up]:向上翻一页    [Page Down]:向下翻一页    [Home]:去第一页    [End]:去最后一页    /string:向下搜索string    ?string:向上搜索string    n/N:n表示下一个搜索，N表示上一个搜索。

## 文件

### 查看文件

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

### 查找文件

* whereis：针对几个特定目录查找文件，`whereis -l`查看这几个特定目录。
* which：根据PATH查看可执行文件。
* locate：根据/var/lib/mlocate内的数据库记载搜索文件（数据库未更新前搜索某新建的文件可能搜不到）。
* find：强大的查询工具。用法`find [PATH] [option] [action]`，PATH可以是多个目录，find查找会进入子目录。
  * 查看/home下3天前到4天前中间的24小时内有修改的文件`find /home -mtime 3`（如果是+3表示大于等于3天前的文件名，-3表示小于等于3天内的文件名）；
  * 查看/home下属于bes的文件`find /home -user bes`，查看不属于任何人的文件`find / -nouser`；
  * 查到/home下文件名包含了passwd的文件名`find /home -name "*passwd*"`;
  * 查看/home下文件类型为普通文件的文件名`find /home -type f`;
  * 查看文件权限大于755的文件名`find -perm /755`；
  * `find / -perm /7000 -exec ls -l {} \;`其中{}表示find找到的内容会放到{}中；-exec到\;是关键字，表示开始和结束。
  * find查找会直接去查找磁盘，可能比较慢。

### 压缩

* `tar -xzvf xxx.tar.gz`解压文件
  * -x extract提取文件；-z通过gzip处理文件；-v：verbose显示执行过程；-f指定文件名
* `tar -cvzf 生成的文件名.tar.gz dir/`压缩文件
  * -c：create生成文件
  * tips：-C（大写）将文件放到指定文件夹
* `tar`
  * -c建立打包文件；-v查看执行过程；-x解压缩；-t查看打包文件内的情况；-C在特定目录解压缩；-z使用gzip解压缩；-j使用bzip2解压缩；-J使用xz解压缩；-f后面要立刻接上要被处理的文件名；-p保留备份数据原本权限与属性；--exclude=FILE压缩过程中不打包FILE。
* `gzip -[cdv#]`：-c将压缩的数据输出到屏幕；-d解压缩；-v显示出原文件/压缩文件的压缩比等信息；-#表示数字，-1最快但压缩比最差，-9最慢但压缩比最慢，-6是默认。使用gzip压缩时，原文件会被压缩为***.gz，原文件就不存在了。
* `bzip2 -[cdkzv#]`：-c将压缩的数据输出到屏幕上；-d解压缩；-k保留源文件；-z压缩（默认，可不加）；-v显示压缩比等信息；-#与gzip一样。文件名是xxx.bz2。
* `xz [-dtlkc#]`：-d解压缩；-t测试压缩文件完整性；-l列出压缩文件相关信息；-k保留原文件不删除；-c数据输出到屏幕上；-#和bzip2一样。

### 权限

* `chgrp [-R] 文件/文件夹` 改变文件的群组（必须是/etc/group中存在的）。

* `chown [-R] name:groupname 文件或目录`来修改文件的拥有者，-R表示递归。

* `chmod [-R] 文件/目录` 改变文件/目录的权限。

* `su`
  * `su`单纯使用su切换为root身份时，表明切换为root身份。读取变量的设定方式为non-login shell的方式，这种方式很多原本的变量不会改变。
  * `su - username`使用该命令代表使用login-shell的变量文件来登入系统。
  * `su - -c 指令` 执行一次root的指令。
  
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
  ADMPWCOM ALL=(root) /bin/su -
  ```

  * sudo时间间隔为5min。

### 磁盘

* `df -h`查看磁盘的信息。
* `du [-hskm] 文件或目录名称` 查看文件系统的磁盘使用量。
  * -h 易读的方式显示。
  * -s （summarize）列出总量。
  * -d （--max-depth=N）：N表示深度，1表示输出子文件夹的大小，2表述输出子文件夹的子文件夹的大小。
  * -a （--all） 不加该参数表示只统计文件夹，加该参数表示统计所有文件。
  * -k和-m 以kB/mB显示。
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
  

