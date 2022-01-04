---
title: python面向对象
tags:
  - python
date: 2021-03-14 15:39:50
---

* python中所有数据类型都可视为对象。
* 所有的类都会继承object类。
* 类中定义函数的第一个参数是self，调用时不用传递该参数。
* 属性前面加`__`（两个下划线）就变成了一个私有属性。双下划线开头，双下划线结尾的是特殊变量，特殊变量是可以直接访问的，不是private变量。一个下划线开头的变量名是可以被外部访问的，但是按约定俗称的规定，请把它视为私有变量。
* 双下划线开头的属性不能被外部访问是因为这个属性被改名字了。
* 判断一个变量是否是某个类型可以用isinstance()判断，判断对象类型可以使用type方法。
* 使用dir()可获得对象的所有属性和方法。
* 自己写的类如果也想用len()方法的话，可以自己写一个`__len__`方法。实际上，当我们使用len()方法的时候，它会自动去调用该对象的`__len__()`方法。
* `__str__`相当于java中的`toString`，还有一个`__repr__`是返回开发者看到的字符串。
* `__getitem__`可按下标访问数据的项。
* 任何类只要定义一个`__call__`方法，就可以对实例进行调用。

## 类的定义

```python
class Student(object):
    #类属性
    name = 'Student'
    def __init__(self, name):
        #实例属性
        self.name = name
#编写程序不要对实例属性和类属性使用相同的名字，因为相同名称的实例属性将屏蔽掉类属性        
```

## 动态绑定

* 当创建了一个对象后，我们可以给该对象绑定任何属性和方法，但是该属性和方法只在当前对象上有效。为了给所有实例都绑定方法，可以给class绑定方法。

```python
class Student(object):
    #可以用来限制class实例能添加的属性，仅对当前类实例起作用，对继承的子类不起作用
    #除非在子类中也定义__slots__，这样子类实例允许定义的属性就是自身的__slots__加上父类的__slots__
    __slots__ = ('name', 'age')
def set_age(self, age)
    self.age = age
s = Student()
#给对象动态绑定了一个属性
s.name = 'xiaoxiang'
#给对象动态绑定一个方法，只在该对象上有效
s.set_age = MethodType(set_age, s)
#给类动态绑定一个方法
Student.set_age = set_age
```

## getter和setter

* 使用@property代替getter，以及创建setter的方法见下面的代码

```python
class Student:

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

student = Student()
student.name = 'xiaoxiang'
print(student.name)
```

## `__iter__`和`__next__`

* 如果一个类想被用于for-in，就必须实现`__iter__`和`__next__`方法

```python
class Fib:
    def __init__(self):
        self.a = 0
        self.b = 1

    def __iter__(self):
        #实例自身就是迭代对象
        return self

    def __next__(self):
        self.a, self.b = self.b, self.b + self.a
        if self.a > 100:
            raise StopIteration()
        #返回下一个值
        return self.a

for i in Fib():
    print(i)
```

## `__getattr__`

* `__getattr__`用于动态返回一个属性，只在没有找到属性的情况下才会调用该方法。

```python
class Url:

    def __init__(self, item = ''):
        self.item = item

    def __getattr__(self, item):
        return Url('%s/%s'%(self.item, item))

    def __str__(self):
        return self.item

    __repr__ = __str__

print(Url().xiaoxiang.ayu.liuchan.list)
#结果：/xiaoxiang/ayu/liuchan/list
```

## 枚举

```python
from enum import Enum, unique

#该注解用于保证没有重复值
@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6

```

## type和metaclass

* class（类）的类型就是type，对象的类型就是类名
* 可以通过type()函数依次传入3个参数来创建一个class对象：①class的名称；②继承的父类集合；③class的方法名称与函数绑定。`type('hello', (object, ), dict(hello = 'hello world'))`
* 通过type()函数创建的类和直接写class是完全一样的，因为python解释器遇到class定义时，仅仅是扫描一下class定义的语法，然后调用type()函数创建出class。
* 可以把类看作是metaclass（元类）创建出来的实例。
* metaclass后面用到了再来看吧，链接在这->[metaclass](https://www.liaoxuefeng.com/wiki/1016959663602400/1017592449371072)
<!--more-->
