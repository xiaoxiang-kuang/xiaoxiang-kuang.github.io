---
title: linux命令
categories:
  - [linux]
site: linux
date: 2021-02-08 11:29:58
---

* `df -h`查看磁盘的信息
* `history  n`用来查询过去执行的指令。bash会记录使用过的指令，默认记录1000个，指令存放位置在~/.bash_history中。该文件会记录上一次登录之前的指令，而这一次登录所执行的指令都存在内存中，当注销后，这些指令才会记录到.bash_history中。

##### 系统管理

* netstat：显示网络状态
  * `netstat -tulnp`用来获取目前主机已启动的服务
  * -t/-u显示tcp/udp传输协议的连接情况
  * -l显示监听状态的的服务
  * `-a`显示所有连线中的socket
  * `-n `：显示数字而不是别名
  * -p显示socket的pid/程序名
  
* `ps aux`查询所有系统运行的进程
  * %CPU：使用的cpu资源百分比；%mem：使用的内存资源百分比；vsz：使用的虚拟内存Kb；rss：占用的固定内存Kb；tty：该进程是在哪个终端机上运行，如果于与终端机无关则显示？；stat：进程目前状态（R运行；S睡眠但可被唤醒；D不可被唤醒；T停止状态；Z僵尸状态）；time：实际使用cpu的时间。
  
* `top [-d n]`每隔n秒（默认为5）更新一次
  
  * 第一行显示的是：当前时间、开机到现今经过的时间、登入系统的人数、系统在1、5、15分钟的平均工作负载
  * 第二行显示进程总量、进程状态；第三行显示cpu整体负载；第四行和第五行显示物理内存和虚拟内存的使用情况。
  * PR:priority，指进程的优先级、NI：Nice，于PR有关；TIME+表示CPU使用时间的累加
  * 执行过程中按下M表示以内存的使用来排序，N表示已PID来排序，P表示以CPU来排序，T表示以TIME+来排序，按下q可以离开top
  * `-p PID`观察指定PID
  
* systemctl
  
  * systemd将所谓的daemon执行脚本称为的一个unit。配置文件都存放在/etc/systemd/system、/usr/lib/systemd/system/（主要的脚本执行设定）。
  * 管理服务的状态，格式：`systemctl [command] [unit]`，command如下：
  
  | start | stop | enable   | disable    | status | is-active |
  | ----- | ---- | -------- | ---------- | ------ | --------- |
  | 启动  | 停止 | 开机启动 | 开机不启动 | 状态   | 是否运行  |

  * 结果的第二行表示该服务是否会开机启动，结果的第三行表示该服务的当前状态。
  * `systemctl [list-units]`列出目前启动的unit；`systemctl list-unit-files`将`/usr/lib/systemd/system/`下的所有文件进行说明。
  * systemctl中配置文件中最重要的是ExecStart，它是实际执行此daemon的指令或者脚本，这里很多的bash语法都不支持。
  
  `kill `
  
  * `kill -9 PID`立刻强制删除一个工作
  * `kill  [-15] PID`以正常的方式结束一个工作
  * example：当使用vim时，会产生一个.filename.swp文件，使用-15时，vim会以正常的步骤结束vi的工作，所以.filename.swp会被主动的移除，但如果使用-9，由于vim工作被强制移除了，所以.filename.swp就会继续存在文件系统中。
  

##### vim

通过配置~/.vimrc（不建议修改/etc/vimrc）可以设定一些vim的属性，在vim的命令模式输入`:set all`可以查到

* `ctrl+f`向下移动一页
* `ctrl+b`向上移动一页
* `0或者home`移动到这一列的最前面
* `$或end`移到这一列最后一页
* `G(注意是大写)`移到文件的最后一列
* `gg`移到文件的第一列
* `n+enter`光标向下移动n列
* `/word`搜索为名称为word的字符串
* `:1,100s/word1/word2/g`[第一行，第二行]中所有的word1被替换成word2
* `:1,$s/word1/word2/g`第一行到最后一行所有word1被替换为word2
* `:1,$s/word1/word2/gc`第一行到最后一行所有word1被替换为word2，且在取代前会提示字符给用户确认
* `dd`删除当前一整行
* `yy`复制一整行
* `p`将复制的数据在光标的下一行粘贴，`P`在光标的上一行粘贴
* `u`复原前一个动作
* `ctr+r`重复上一个动作
* `:w [filename]`将文件另存为
* `:set nu/nonu`开启/关闭行号

##### 解压

* `tar -xzvf xxx.tar.gz`解压文件
  * -x extract提取文件；-z通过gzip处理文件；-v：verbose显示执行过程；-f指定文件名
* `tar -cvzf 生成的文件名.tar.gz dir/`压缩文件
  * -c：create生成文件
  * tips：-C（大写）将文件放到指定文件夹

##### 权限

* `chown [-R] name:groupname 文件或目录`来修改文件的拥有者，-R表示递归。

