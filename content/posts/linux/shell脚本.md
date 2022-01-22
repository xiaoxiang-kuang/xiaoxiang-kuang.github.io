---
title: shell脚本
tags: 
  - linux
date: 2021-09-09 16:28:01
---

* 用户可以透过应用程序来指挥kernel，让kernel来完成我们所需要的硬件任务，因为程序是在最外层，类似鸡蛋的外壳一样，所以就叫壳程序（shell）。shell是提供用户操作系统的一个接口。
* bash全称就是Bourne Again SHell，是linux预设的shell。
* 系统中合法的shell都会写入到/etc/shells这个文件。当用户登录的时候，系统会提供一个shell，这个shell就记录在/etc/passwd这个文件中。
* bash有很多内建指令，如cd等，可以通过type这个指令观察。
* 一行输不完，可以通过\\来换行。
* shell脚本中第一行的`#!/bin/bash`宣告这个script使用的是bash的语法。
* 简单整数的加减运算可以使用`$((计算式))`，不需要先将其转化为整数，支持的运算符有`=-*/%`。
* 当使用bash（sh）或者./xxx.sh来下达指令时，是在子程序中执行的；通过source来执行脚本时，是在父程序中执行的。

## 变量定义

* 环境变量如PATH等，通常使用大写字符来表示，当输入了一个命令ls，系统会通过PATH这个遍历里面的内容记录的路径来顺序搜索指令。

* 变量在使用时，需要加上在前面加上`$`。如`$PATH,${PATH}`。

### 变量的设定规则

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
* `?`是一个变量，代表上一个指令传回来的值，一般来说，当我们成功执行了一个指令，则会返回0值，如果执行错误，就会传回一个错误代码，通过`$?`来调用。

### read，array，declare

* read可以读取键盘输入的变量。如`read -p "please input:" -t 10 name `。其中-p是提示信息，-t是倒计时，系统不会一直等待输入，name就是变量，会将输入的信息给这个变量。
* declare、typeset是宣告变量的类型（shell默认类型是字符串）。
  * `declare -a var`将var声明为数组类型array。
  * `declare -i var`将var声明为整数类型integer（bash中的数值计算最多只能达到整数形态）。
  * `declare -x var`将var声明为环境变量。
  * `declare -r var`将变量声明为只读类型readonly，改变量不可更改，不能unset。
  * `declare -p var`查看变量的类型。



* login shell是取得bash时需要输入完整的登录账号密码的就是login shell。
* non-login shell就是取得bash接口不需要重复的登入。如从图形化界面进入linux后，开启每个bash都不需要再次输入用户名和密码。这就是non-login shell。
* login shell会读取`/etc/profile`（系统整体的设定，每个使用者登入取得bash时一定会读取的配置文件。）和`~/.bash_profile或~/.bash_login或~/.profile`（个人的设定）的文件。
* non-login shell会读取~/.bashrc、/etc/bashrc、/etc/profile.d（不同的linux会有些不同）。
* source可以立即读入配置文件的内容。

## 通配符与特殊符号



| 符号 | 意义                                                         |
| ---- | ------------------------------------------------------------ |
| *    | 代表0到无穷多个任意字符                                      |
| ？   | 代表一定有一个的任意字符                                     |
| []   | 代表一定有一个在括号内的字符                                 |
| [-]  | 表示一定有一个在编码顺序内的所有字符，如[0-9]表示一定有一个数字 |
| [^]  | 表示反向选择，如[\^abc]就表示一定有一个字符，但不是abc中的一个。 |


## 变量内容的删除与取代


| 符号                | 含义                                                     |
| ------------------- | -------------------------------------------------------- |
| #                   | 从最左边开始，删除匹配最短的那个                         |
| ##                  | 从最左边开始，删除匹配最长的那个                         |
| %                   | 从最右边开始，删除匹配最短的那个                         |
| %%                  | 从最右边开始，删除匹配最长的那个                         |
| /旧字符串/新字符串  | 若变量内容符合旧字符串，则第一个旧字符串会被新字符串取代 |
| //旧字符串/新字符串 | 若变量内容符合旧字符串，则全部旧字符串会被新字符串取代   |


```sh
#例:
path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"
#去掉了开始的/usr/local/sbin:
echo ${path#/*:}
#输出为空
echo ${path##/*:}
#去掉了末尾的/bin:
echo ${path%/*:}
#输出为空
echo ${path%%/*:}
#将第一个出现的usr替换为USR
echo ${path/usr/USR}
#将所有的sbin替换为SBIN
echo ${path//sbin/SBIN}
```

### tr：删除字符串中的一段文字，或者进行文字的替换。

* `cat example.txt | tr [a-z] [A-Z]`将输出的文件中的所有小写字符变成大写字符。
* `cat /etc/passwd | tr -d ':'`删除输出文件中的所有冒号:

### 变量的测试与内容替换

```sh
#减号-：当str不存在的时候，str=root，而当str存在（为空也视为存在）则str=$str
str=${username-root}
#:- 当str为空或不存在，str=root；str不为空则str=$str
str=${str:-root}
```

## 重定向与管道

* 标准输入`<<`或`<`；标准输出`>>`或`>`；标准错误输出`2>`或`2>>`。
* `>`会覆盖原文件，`>>`会追加到文件中。如`find /home -name .bashrc > list_right 2> list_error`，将正确输出和错误输出存入到不同的文件中。
* 黑洞装置`/dev/null`，可以吃掉任何导向这个装置的信息。
* 将正确和错误输出都放到同一个文件中`find /home -name .bashrc > list 2>&1`。对2>&1的理解，这里2表示错误输出，意思是将错误输出重定向到标准输出，&1表示对标准输出的应用。
* 管道`|`只会处理标准输出，会忽略标准错误输出。
* 管道命令必须要接收上一个指令的标准输入，如less、more、head、tail时管道命令，而如ls、cp、mv就不是管道命令。
* 管道后面第一个必须是指令。
* 在管道中常常会使用前一个指令的输出作为后一个指令的输入，某些指令需要指定文件名来处理，该stdin和stdout可以使用`减号"-"`来替代。如`tar -cvf - /home | tar -xvf - -C /tmp/homeback`，这个命令是将/home里的文件打包，将打包的文件输出到stdout，后面的命令从stdin读取数据，所以我们就不需要文件名了，直接使用-代替。
* grep [-invAB]  '搜索字符串'  filename：查找文件或标准输出中的字符串，
  * -i表示忽略大小写。
  * -n表示输出行号。
  * `-v`：表示选择未匹配的行（反选）。
  * -A：--after-context，输出查找字符串后面n行。
  * -B：--before-context，输出查找字符串前面多少行
* cut：将一段数据切出来
  *  ` cat filename |cut -d '分隔字符'  -f num`：-d后面跟分隔字符，将数据分为几段，-f表示取出第几段。
  *  `cat filename  |cut -c 12-`：-c表示每一行都获取从第12个字符后面的所有字符（注意12后面有个减号）。
* `xargs [OPTION] COMMAND [R]`：读入stdin的数据，并以空格符作为分割，将stdin分割成参数。
  * `xargs -n 1`表示每次执行指令值取一个参数。
  * `xargs -I R`将从标准输入获取到的数据替换后面命令的参数R。

## 命令执行的判断依据 ;  &&  ||

* 命令之间用`;`隔开，分号前的指令执行完后会立刻接着执行后面的指令。
* 命令之间用`&&`连接，表示当上一个指令**正确**执行完成后，才会接着执行下一个命令，这里使用到了上面提到的`$?`变量。如`ls /tmp/abc && touch /tmp/abc/hehe`，当不存在abc这个目录时，touch命令不会执行。
* 命令之间用`||`连接，当上一个指令**错误**执行完成后，才会接着执行下一个命令。如`ls /tmp/abc || mkdir /tmp/abc && touch /tmp/abc/hehe`，当abc路径不存在时，会创建abc路径，并执行touch命令；而如果abc路径存在，则会直接执行touch命名。

## 格式化打印输出

* %ns表示n个字符；%ni表示n个整数数字数；%N.nf表示一共N个数字，小数点占n个。
* `\n表示换行，\t表示tab键`。

## 正则表达式

* vi、grep、awk、seq等工具支持正则表达式；cp、ls不支持正则表达式，只能使用bash本身的通配符。

| 规则                 | 意义                                                         |
| -------------------- | ------------------------------------------------------------ |
| ^word                | 寻找以word开始的行                                           |
| word$                | 寻找以行尾为word的行                                         |
| .                    | 代表任意一个字符                                             |
| \                    | 转义字符                                                     |
| *                    | 重复前一个字符0到无穷次                                      |
| [abc]                | 搜寻含有a或b或c的那一行，[]只代表一个待搜寻的字符            |
| [a-z]                | 搜寻两个字符间的所有连续字符，这个连续与ASCII编码有关。      |
| [^abc]               | 反向选择，不要有a或者b或者c的行                              |
| \\{n,m\\}            | \\{n,m\\} 连续n到m个的前一个字符<br>\\{n\\} 连续n个前一个字符<br>\\{n,\\} 连续n个以上的前一个字符 |
| [:alnum:]            | 代表a-z,A-Z,0-9                                              |
| [:alpha:]            | 代表A-Z,a-z                                                  |
| [:blank:]            | 代表空格和[Tab]                                              |
| [:digit:]            | 代表数字                                                     |
| [:lower:]、[:upper:] | 代表小写字符、代表大写字符                                   |
| [:space:]            | 任何会产生空白的字符，包括空格，[Tab]，CR等                  |
| [:xdigit:]           | 代表16进位的数字类型。                                       |

### sed

* `sed [-nefr] [n1[,n2]] function`。
  * -i 直接修改读取的文件；-n只有经过sed处理的行会被输出（配合q使用）。
  * n1,n2表示选择进行操作的行数。
  * function有：a 新增到的当前下几行；c 取代；d 删除；i 插入到当前的上一行；p 打印；s 取代，如1,20s/old/new/g。

``` sh
#将显示到屏幕的内容删除第2-5行
nl /etc/passwd | sed '2,5d'
#删除第三行到最后一行
nl /etc/passwd | sed '3,$d'
#在第二行后面加上drink tea（就是加在了第三行）
nl /etc/passwd | sed '2a drink tea'
#在第二行后面加上了两行，每一行之间都要以反斜杠\来进行新行的增加
nl /etc/passwd | sed '2a drink tea \
drink beer'
#取代2-5行
nl /etc/passed | sed '2,5c No 2-5 number'
#仅列出/etc/passwd文件的第5-7行
nl /etc/passwd | sed -n '5,7p'
#删除5-7行
nl /etc/passwd | sed '5,7 d'
#去掉开始的空格，删除以1和2开始的行
nl /etc/passwd |sed 's/^ *//g' | sed '/^[1-2]/ d'
#去掉有#注释的行
cat /etc/man_db.conf | grep 'MAN'| sed 's/#.*$//g' | sed '/^$/d' 
#将行末尾的.改为!
sed -i 's/\.$/\!/g' regular_express.txt
#文件的最后一行增加一行文字
sed -i '$a # This is a test' regular_express.txt
```

* 取代命令 `sed 's/要被取代的字符串/新的字符串/g'`

### awk 数据处理工具

* `awk '条件类型1{动作1}' filename` ，awk只能用单引号。
* awk默认以空格或者[Tab]按键隔开，隔开的每一行的每个字段都是有变量名称的，那就是$1、$2...。$0表示一整行。
* NF表示每一行的字段总数；NR表示目前是第几行；FS表示目前的分割字符，默认是空格

``` sh
#输出账号和ip，有些数据格式不对
last -n 5 | awk '{print $1 "\t" $3}'

last -n 5| awk '{print $1 "\t lines: " NR "\t columns: " NF}' 
#将分割字符设为冒号:，查询第三栏小于10，并只输出账号和第三栏
cat /etc/passwd | awk 'BEGIN {FS=":"} $3 < 10 {print $1 "\t " $3}' 
#杀掉所有的java程序
jps |grep -vi jps | awk '{print $1}' | xargs -n 1 -I {} kill {}
```

## test指令


### 文件的判断


| 命令              | 解释                                                         |
| ----------------- | ------------------------------------------------------------ |
| test -e filename  | 判断文件是否存在                                             |
| -f                | 是否为文件                                                   |
| -d                | 是否为目录                                                   |
| -r                | 是否有可读的权限                                             |
| -w                | 是否有可写的权限                                             |
| -x                | 是否有可执行的权限                                           |
| -nt（newer than） | 判断file1是否比file2新，例：test file1 -nt file2             |
| -ot（older than） | 判断file1是否比file2旧                                       |
| -ef               | 判断两个文件是否是同一个文件，其实是判断两个文件是否指向同一个inode。 |

### 两个整数之间的判断 如：test n1 -eq n2

| 命令                                              | 介绍                |
| ------------------------------------------------- | ------------------- |
| -eq                                               | 两数值相等          |
| -ne                                               | 两数值不等          |
| -gt（greater than）/ -ge（greater than or equal） | n1大于 / 大于等于n2 |
| -lt / -le                                         | n1小于 / 小于等于n2 |

### 判断字符串的数据

| 命令                                                  | 介绍                         |
| ----------------------------------------------------- | ---------------------------- |
| test -z string                                        | 若字符串为空串，则为true     |
| test -n string                                        | 若字符串为非空串，则为true   |
| test str1 == str2（bash中一个等号和两个等号是一样的） | 若str1等于str2，则返回true   |
| test str1 != str2                                     | 若str1不等于str2，则返回true |

### 条件判断，如test -r filename -a -x filename

| 命令      | 介绍                                                |
| --------- | --------------------------------------------------- |
| -a（and） | 与，两条件同时成立返回true                          |
| -o（or）  | 或，任何一个条件成立就返回true                      |
| !         | 非，如test ! -x file,当file不具备执行条件时返回true |



## shell中的默认变量

* shell定义了一些默认的变量。

```sh
tar -c -v -f example.tar example/
$0  $1 $2 $3    $4       $5
```

* `$#`表示命令后面的参数个数，上面就是5。
* `$@`表示"$1" "$2" "$3" "$4" "$5"。
* `$*` 表示"$1 $2 $3 $4 $5"
* `$$` 当前shell的PID。
* `$?` 上一个执行指令的回传值，一般一个指令执行完后，会回传一个0值。

## 条件判断式

### if

* 中括号[  ]和test类似，也可以来进行数据的判断，中括号的两端需要有空格来分割。

``` shell
if [ 条件判断式1 ];then
	指令
	指令
	exit 0
elif [ 条件判断式2 ];then
	指令
	指令
else
	指令
	指令
fi

#可以if后面可以跟上多个条件
if [ 条件判断式1 ] || [ 条件判断式2 ];then
if [ 条件判断式1 ] && [ 条件判断式2 ];then
```

### case

```sh
case $变量名称 in
	"第一个变量名称")
		指令
		指令
		;;
	"第二个变量名称")
		指令
		指令
		;;
	#下面这个有点类似于C语言的default
	*)
		指令
		指令
		;;
esac
```

```sh
#例：
case ${1} in
	"hello")
		echo "hello world!"
		;;
	"what")
		echo "what's up!"
		;;
	*)
		echo "are you ok?"
		;;
esac
```

## 函数function

* shell是从上往下执行，所以函数要放在程序的最前面。

```sh
#function关键字是可选的
#可以通过test abc来给函数传递参数
function test(){
	指令
	指令
}
```

## 循环

### 不定循环

```sh
#当condition条件不成立时终止循环
while [ condition ]
do
	指令
	指令
done

#当condition条件成立时终止循环
until [ conditon ]
do
	指令
	指令
done
```

### 固定循环

```sh
for var in con1 con2 con3
do
	指令
	指令
done

#或

for (( 初始值; 限制值；执行步阶))
do
	指令
	指令
done
```

```sh
#一个ping很多机器的shell脚本
#!bin/bash
network=82.156.3
#seq是sequence，会连续生成1到254之间的数
for site in $(seq 1 254)
do
		#-c表示ping几次，-w表示超时时间，单位是秒
        ping -c 1 -w 1 ${network}.${site} > /dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "${network}.${site} is ok"
        else
                echo "${network}.${site} id down"
        fi
done

#一个案例
for (( i=1; i<=10; i=i+1))
do
	printf "%i\n" $i
done
```

## shell调试

* `shell [-nvx] xxx.sh`：-n查询语法是否正确；-v先输出文件内容再执行shell脚本；-x执行前先将使用到的script输出到屏幕上。

## 例

```sh
#!/bin/bash

current_path="/opt/www/journey"
tmp_path="/tmp"
jar_name="journey.jar"

tmp_jar_path="${current_path}${tmp_path}/${jar_name}"
jar_path="${current_path}/${jar_name}"
logs_path="${current_path}/logs"

mkdir -p "${tmp_path}"
mkdir -p "${logs_path}"

function start() {
	nohup java -jar ${jar_path} > "${logs_path}/start.log" 2>&1 &
	if [[ $? == 0 ]];then
		echo "server is starting"
	fi
}

function stop() {
	jar_pid=`ps aux | grep ${jar_name} | sed '/.*grep.*'${jar_name}'.*/d' | awk '{print $2}'`
	kill ${jar_pid} 2>/dev/null
	if [[ $? == 0 ]];then
		echo "server has stopped"
	fi
}

function update() {
	if [[ !  -f ${tmp_jar_path} ]];then 
		echo "file not exists..."
		exit 1
	fi
	stop
	mv ${tmp_jar_path} ${jar_path}
	start
}

if [[ "start" == $1 ]];then
	start 
elif [[ "stop" == $1 ]];then
	stop
elif [[ "update" == $1  ]];then
	update
else
	echo "invalid args"
fi
```

<!--more-->
