---
title: python模块
tags:
  - python
date: 2021-03-15 19:35:28
---

## datetime

```python
from datetime import datetime,timedelta
```

* 获取当前时间`datetime.now()`
* 指定的某个日期和时间`datetime(2021,3,15,19,48)`
* 将datetime类型转化为timestamp，（timestamp是一个浮点数，整数位表示秒） `datetime(2021,3,15,19,49).timestamp()`
* timestamp转化为datetime `datetime.fromtimestamp(1615809156.889315)`
* str转换为datetime `datetime.strptime('2021-3-15 19:55:59','%Y-%m-%d %H:%M:%S')`
* datetime转str `datetime.now().strftime('%a,%b %d %H:%M')`
* datetime加减 `datetime.now() + timedelta(days = 1, hours = 10)`
* 时区转换

```python
utc_dt = datetime.utcnow()
utc_dt.astimezone(timezone(timedelta(hours=8)))
```

## collections

* namedtuple：是一个函数，可以用来创建一个自定义的tuple对象，同时规定了tuple元素的个数，并可以用属性而不是索引来引用tuple的某个元素。

```python
from collections import namedtuple
Point = nametuple('Point',['x', 'y'])
p = Point(1, 2)
```

* deque：双向列表，方法有`append()、pop()、appendleft()、popleft()`
* defaultdict：和dict类似，但是在key不存在的时候返回一个默认值。
* OrderedDict：key会按照插入的顺序排序
* ChainMap：可以把一组dict串起来组成一个逻辑上的dict，本身也是一个dict，但在查找的时候，会按照顺序在内部的dict依次查找。
* Counter是一个计数器，可以统计字符出现的个数，实际上也是dict的子类

## base64

* base64是一种用64个字符表示任意二进制数据的方法，64个字符指的是`A-Z, a-z, 0-9, +, /`。实现方法是将3个字节(3x8bit)的二进制数据编码为4字节(4x6bit，6bit的数据刚好能用上面这64个字符表示)的数据。6bit的数据刚好能用这64个字符表示。
* 编码`base64.b64encode(b'binary')`；解码`base64.b64decode(b'binary')`

## hashlib

* 摘要算法又称为哈希算法，散列算法，它通过一个函数，把任意长度的数据转化为一个固定长度的数据串。它是一个单向函数，对原始数据做一点点的修改都会导致计算出的摘要完全不同。

```python 
import hashlib
md5 = hashlib.md5()
#也可以将串分开，多次调用update方法
md5.update("xiaoxiang.space".encode("utf-8"))
#md5结果是128bit，通常用32位的16进制表示
print(md5.hexdigest())

sha1 = hashlib.sha1()
sha1.update("xiaoxiang.space".encode("utf-8"))
#sha1的结果是160bit，通常用一个40位的16进制字符串表示
print(sha1.hexdigest())
```

## itertools

* 无限迭代器`itertools.count()`
* cycle()会把传入的一个序列无限重复下去`itertools.cycle('ABC')`
* repeat()可以把一个元素无限重复下去，提供了第二个参数可以限定重复次数`itertools.repeat('A', 3)`
* 可通过takewhile()根据函数条件来截取一个有限的序列。
* chain()可以把一组迭代对象串联起来，形成一个更大的迭代器。`itertools.chain('ABC', 'XYZ')`
* groupby()可以把迭代器中相邻的重复元素挑出来放在一起。挑选规则是通过函数完成的，只要作用于函数的两个元素返回的值相等，这两个元素就被认为是一组的，函数的返回值作为组的key。

## contextlib

* 任何对象，只要正确实现了上下文管理，就可以用于with语句。实现上下文管理是通过`__enter__`和`__exit__`这两个方法实现的。可以通过contextlib标准库中的`@contextmanager`来实现上下文管理（更简单）
* 有时候，我们希望在某段代码执行前后自动执行特定代码，也可以通过@contextmanager实现

```python
import contextlib
@contextlib.contextmanager
def tag(name):
    print("<%s>"%name)
    yield
    print("</%s>"%name)

with tag("h1"):
    print("hello")
    print("world")
```

* 如果一个对象没有实现上下文，就不能把他用于with语句，可以用closing()来将该对象变成上下文。
<!--more-->
