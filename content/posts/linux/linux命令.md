---
title: linux命令
tags: 
  - linux
date: 2021-02-08 11:29:58
---

* linux在下达一个指令时，会按照以下的顺序寻找（所以当直接在bash中输入xxx.sh时是不会执行的）：

   1. 以相对/绝对路径执行指令如/bin/ls，或./ls。
   2. `alias lm='ls -al'`：给命令设定别名；`alias`：可以查看系统的所有别名；使用`unalias lm`取消别名。
   3. 由bash内建的指令来执行。
   4. 通过$PATH这个变量的顺序搜寻到第一个指令来执行。


## 系统管理

### 网络

* netstat：显示网络状态
  * `netstat -tulnp`用来获取目前主机已启动的服务
  * -t/-u显示tcp/udp传输协议的连接情况
  * -l显示监听状态的的服务
  * `-a`显示所有连线中的socket
  * `-n `：显示数字而不是别名
  * -p显示socket的pid/程序名
  
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

### 进程

### 进程状态查看

#### ps

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

#### top

* `top [-d n]`每隔n秒（默认为5）更新一次

  * 第一行显示的是：当前时间、开机到现今经过的时间、登入系统的人数、系统在1、5、15分钟的平均工作负载
  * 第二行显示进程总量、进程状态；第三行显示cpu整体负载；第四行和第五行显示物理内存和虚拟内存的使用情况。
  * 第三行（%Cpus...）显示的是CPU的整体负载，wa表示I/O wait
  * PR:priority，指进程的优先级、NI：Nice，于PR有关；TIME+表示CPU使用时间的累加
  * 执行过程中按下M表示以内存的使用来排序，N表示已PID来排序，P表示以CPU来排序，T表示以TIME+来排序，按下q可以离开top
  * `-p PID`观察指定PID
  * 在top执行过程中可以按下`P`使得以CPU的使用资源排序，按下`M`以内存的使用资源排序，按下`N`以PID来排序。

#### kill

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

### 进程的后台执行

#### nohup和&

* nohup会将标准输入重定向到/dev/null，将标准输出重定向到nohup.out（一般情况）或$HOME/nohup.out文件，将标准错误输出重定向到标准输出。
* `nohup COMMAND > FILE` 保存输出内容到文件。
* `nohup COMMAND &` 后台执行命令。
* 使用`&`可以将任务丢到后台执行，但标准输出和标准错误输出仍然会被输出到屏幕上。
* `&`将进程放到了背景执行，但是当退出bash后，进程就会被终止掉，如果需要退出bash后进程仍然能继续执行，可以使用nohup。nohup能在退出bash后还能继续执行工作。
* 例：`nohup java -jar xxx.jar </dev/null 2>&1 &` 将java命令放到后台执行，标准输出和标准错误输出都重定向到/dev/null

#### job和fg

* 可以使用`ctrl+z`将任务丢到背景，状态是暂停。
* 使用 `jobs -l`可以观察当前背景中的任务。其中+代表最近被放到背景，-代表最近倒数第二个被放到背景。
* 使用fg可以将背景工作拿到前台来执行。命令：`fg &jobnumber`。
* 删除背景中的工作。命令：`kill [-15 |-9] %jobnumber`。

### man（manual）

* man中有几个常用的数字的含义：1 用户在shell环境中可以操作的指令或可执行文件；4 装置文件的说明，通常在/dev下的文件；5 配置文件或者某些文件的格式；7 惯例与协议等；8 系统管理员可用的指令。例：`man 8 sudo`。
* man page一般包含：①NAME：简短的说明；②SYNOPSIS：简短的指令下达语法说明；③DESCRIPTION：较完整的说明；④OPTIONS；⑤COMMANDS：当这个程序执行的时候，可以在此程序中下达的指令。⑥FILES：关联的文件；⑦SEE ALSO：其他可以参考的信息；⑧EXAMPLE：一些可以参考的范例。
* 快捷键：空格键:向下翻一页    [Page Up]:向上翻一页    [Page Down]:向下翻一页    [Home]:去第一页    [End]:去最后一页    /string:向下搜索string    ?string:向上搜索string    n/N:n表示下一个搜索，N表示上一个搜索。

### 一次执行at与定时执行cron

#### at

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

#### cron

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

### 查看系统信息

* `free -h`查看内存使用情况。
* `uname [-asrmpi]` -a表示所有；-s 系统核心名称；-r 核心的版本；-m 本系统的硬件名称(x86_64)；-p CPU的类型；-i 硬件的平台。
* `uptime`显示系统启动时间和工作负载。

* `hostnamectl [set-hostname 主机名]` 修改主机名。
* `timedatectl [list-timezones | set-timezone | set-time | set-ntp]` 列出系统上的失去、设定时区、设定时间、设定网络校时。
* `localectl set-locale LANG=en_US.utf8`设置语系。通过`locale -a`可以查看linux支持了多少语系，通过`locale`来查看系统目前的语言环境。
* 硬件数据收集：dmidecode(CPU型号、主板型号、内存相关型号等), gdisk, dmesg, vmstat（分析cpu、内存、io目前的状态）, lspci, lsusb,iostat。

## 文件

* ls 列出指定的目录下的文件
  * `-d 目录名`  列出目录名而不进入该目录。

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
  * 查看/home下3天内有修改的文件`find /home -mtime 3`（如果是+3表示大于等于3天前的文件名，-3表示小于等于3天内的文件名）；
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
  ADMPW ALL=(root) /bin/su -
  ```

  * sudo时间间隔为5min。
  
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

#### ACL

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
  

## 其他命令

* `sh -c "xxx"` 将一个字符串作为完整的命令来执行。 
* `history  n`用来查询过去执行的指令，n表示显示最近n个命令。bash会记录使用过的指令，默认记录1000个，指令存放位置在~/.bash_history中。该文件会记录上一次登录之前的指令，而这一次登录所执行的指令都存在内存中，当注销后，这些指令才会记录到.bash_history中。
* 使用write可以给linux上的其他用户发消息，通过`who`可以查看目前有谁在线。通过`write koal`给所有以koal登录的用户发消息。通过`mesg n`来关闭接收消息，但无法拒绝root的消息。通过`mesg y`来开启接收消息。使用wall可以对系统上所有的用户发送消息`wall "hello world"`。


<!--more-->
