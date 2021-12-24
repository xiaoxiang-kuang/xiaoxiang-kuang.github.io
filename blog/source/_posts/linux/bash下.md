---
title: bash下
categories:
  - [linux]
site: linux
date: 2021-09-10 15:45:54
---

* 第一行的`#!/bin/bash`宣告这个script使用的是bash的语法。
* 简单整数的加减运算可以使用`$((计算式))`，不需要先将其转化为整数，支持的运算符有`=-*/%`。
* 当使用bash（sh）或者./xxx.sh来下达指令时，是在子程序中执行的；通过source来执行脚本时，是在父程序中执行的。

### test指令


#### 文件的判断


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

#### 两个整数之间的判断 如：test n1 -eq n2

| 命令                                              | 介绍                |
| ------------------------------------------------- | ------------------- |
| -eq                                               | 两数值相等          |
| -ne                                               | 两数值不等          |
| -gt（greater than）/ -ge（greater than or equal） | n1大于 / 大于等于n2 |
| -lt / -le                                         | n1小于 / 小于等于n2 |

#### 判断字符串的数据

| 命令                                                  | 介绍                         |
| ----------------------------------------------------- | ---------------------------- |
| test -z string                                        | 若字符串为空串，则为true     |
| test -n string                                        | 若字符串为非空串，则为true   |
| test str1 == str2（bash中一个等号和两个等号是一样的） | 若str1等于str2，则返回true   |
| test str1 != str2                                     | 若str1不等于str2，则返回true |

#### 条件判断，如test -r filename -a -x filename

| 命令      | 介绍                                                |
| --------- | --------------------------------------------------- |
| -a（and） | 与，两条件同时成立返回true                          |
| -o（or）  | 或，任何一个条件成立就返回true                      |
| !         | 非，如test ! -x file,当file不具备执行条件时返回true |



### shell中的默认变量

* shell定义了一些默认的变量。

```sh
tar -c -v -f example.tar example/
$0  $1 $2 $3    $4       $5
```

* `$#`表示命令后面的参数个数，上面就是5。
* `$@`表示"$1" "$2" "$3" "$4" "$5"。

### 条件判断式

#### if

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

#### case

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

### 函数function

* shell是从上往下执行，所以函数要放在程序的最前面。

```sh
#function关键字是可选的
#可以通过test abc来给函数传递参数
function test(){
	指令
	指令
}
```

### 循环

#### 不定循环

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

#### 固定循环

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

### shell调试

* `shell [-nvx] xxx.sh`：-n查询语法是否正确；-v先输出文件内容再执行shell脚本；-x执行前先将使用到的script输出到屏幕上。

### 例：

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

