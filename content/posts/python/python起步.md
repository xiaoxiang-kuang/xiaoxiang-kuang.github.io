---
title: python起步
tags:
  - python
date: 2021-03-11 09:27:54
---

## python基础

### 数据类型和变量

* 整数：可以是任意大小
* 浮点数：除了小数外还可以用科学计数法：1.23e9
* 字符串：以` " `或` ' `括起来的文本，python允许使用` r'' `表示引号内部的字符串默认不转义，python允许用`'''...'''`的格式表示多行内容
* 布尔值：`True`或`False`，可以进行`and` `or` `not`运算
* 空值：`None`，不等于0
* 列表list：如`classmate=['xiaoming','lihua',123,True]`，list是一个可变的有序表。
  * 可以使用append函数追加到末尾
  * 可以使用insert（i，参数）插入到指定位置
  * 删除末尾元素使用pop（），删除指定位置元素用pop（i）
* 元组tuple：`classmate=('xiaoming','lihua',123,True)`，一旦初始化就不能修改
  * 当只有一个元素要这么定义：`classmate=('hel',)`
* 字典dict：`d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}`键值对
  * 可以通过get(key)或d[key]获取值
  * 可以通过d[key]=xxx直接赋值
  * 可以通过pop(key)删除键值对
  * 可以通过in判断key是否存在
  * key必须是不可变对象
* set：要创建一个set，需要一个list作为输入集合，
  * set是一组key的集合，无序，不重复。
  * add(xxx)可以向set里面加元素，remove(xxx)可以删除元素
* 变量：可以把任意类型数据赋值给同一个变量（不同类型也可以）
* 常量：用全大写的变量名表示常量是一个习惯上的用法。
* 除法：python中有两种除法，一种是` / `：计算结果是浮点数，一种是` //`：计算结果是整数（这种称为地板除），python还提供了余数运算：` % `

### 字符串和编码

* 在计算机内存中，统一使用unicode编码，当需要保存到硬盘或者传输的时候，就会转化为UTF-8编码
* 用记事本编辑时，从文件中读取的UTF-8会被转化为Unicode字符到内存中
* python3字符串是以unicode编码的，可以通过`ord()`获取字符串的整数表示，`chr()`把编码转换为对应的字符
* 当这么写时-&gt;`b'ABC'`表示bytes类型，每个字符只占一个字节。
* 以Unicode表示的字符串通过ecnode()方法可以编码位指定的bytes，如`'中文'.encode('utf-8')`
* `len('xxx')`可以知道包含了几个字符。

### 结构

#### 选择结构:非0，非空字符串、非空list就表示True

```python
age = 3
if age >= 18:
    print('adult')
elif age >= 6:
    print('teenager')
else:
    print('kid')
```

#### 循环结构

```python
sum = 0
#0~100
for x in range(101):
    sum = sum + x
print(sum)

sum = 0
n = 99
while n > 0:
    sum = sum + n
    n = n - 2
print(sum)
#break和continue也有
```

### 函数

* python内置了很多函数，可以直接调用，如print、input、len、max、int、float、str、bool等

```python
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
    
#空函数，pass也可用在其他地方，如if里面
def nop():
    pass
```

* 可以返回多个值，会转化成tuple
* 函数参数中可以设置默认参数，必选参数必须放在默认参数前面
* 可以不按顺序提供部分默认参数，但要把参数名写上
* 定义可变参数是在参数前面增加一个*，如`def calc(*numbers)`
  * 当已经有了list或tuple，要调用一个可变参数，可以`calc(*nums)`
* 关键字参数：`def person(name, age, **kw):`会在函数内部自动组装成一个dict
  * 可以传入多个键值对，也可以传入一个dict（`person('Jack', 24, **extra)`）
* 命名关键字参数：`def person(name, age, *, city, job):`
  * 调用方式`person('Jack', 24, city='Beijing', job='Engineer')`
  * 命名关键字参数必须传入参数名
* 上面这些都可以组合

## 其他

* 切片：`L[:2]`切出下标为0和1的元素
* for in可用来迭代，判断是否可迭代可以用collections的Iterable类型判断。
  * `isinstance('abc',Iterable)`
* range(1:10)可用来生成1到9
* 列表生成器`[x*x for x in range(1,11) if x%2==0]`
* 赋值语句`a, b = b, a`是通过tuple实现的，相当于`t = (b, a) a = t[0] b = t[1]`
* 凡是可以作用于for循环的对象都是Iterable类型，凡是可作用于next()函数的对象都是Iterator类型
* 函数也是一个对象，函数对象可以赋值给变量。
* 任何代码的第一个字符串都被视为模块的文档注释，`__author__`变量可以把作者写进去
* 导入模块`import sys`，sys的argv变量用list存储了命令行的所有参数，argv的第一个参数是py文件的名称
* 类似`__xxx__`的变量是特殊变量，类似`_xxx_`和`_xxx`的变量是非公开变量（private）。
* 命名类用UpperCamelCase（第一个字母大写，后面采用驼峰命名法），命名函数和方法采用lowercase_with_underscores（小写带下划线），
<!--more-->
