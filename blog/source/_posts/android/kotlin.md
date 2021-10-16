---
title: kotlin
categories:
  - [android]
site: android
date: 2021-10-16 11:17:50
---

## 变量

* kotlin中定义一个变量，只允许在变量前声明两种关键字：val和var。
  * val（value）用来声明一个不可变的变量，对应java的final。
  * var（variable）用来声明一个可变的变量。
* kotlin完全抛弃了java中的基本数据类型，全部使用了对象数据结构。
  * Int、Long、Short、Float、Double、Boolean、Char、Byte。
* kotlin可以将表达式卸载字符串里。例：`hello, ${obj.name} ,how are you`

## 函数

```kotlin
fun methodName(param1: Int, param2: Int): Int {
      return 0
}
//括号后面的部分是可选的，声明函数会返回什么类型的数据。

//当函数体只有一行时，可用将唯一的一行代码写在函数定义的尾部，中间用等号连接。
//return可以省略，kotlin可以自动推导返回值的类型。
fun methodName(param1: Int, param2: Int) = 0
```

#### 函数参数的默认值

```kotlin
fun printParams(num: Int, str: String = "hello") {
    println("num is $num , str is $str")
}
```



## 逻辑控制

### if

* kotlin的if是可以有返回值的，返回值就是每一个条件中最后一行代码的返回值。

```kotlin
fun largerNumber(num1: Int, num2: Int): Int{
    return if(num1 > num2) {
        num1
    }else {
        num2
    }
}
//等价于
fun largerNumber(num1: Int, num2: Int) = if (num1 > num2) num1 else num2
```

### when

* 当需要判断的条件非常多的时候，可以使用when来替换if

```kotlin
fun getScore(name: String) = when (name) {
    "Tom" -> 86
    "Jim" -> 77
    "Jack" -> 95
    "Lily" -> 100
    else -> 0
}

//when还允许类型匹配
fun checkNumber(num: Number) {
    when (num) {
        is Int -> println("number is Int")
        is Double -> println("number is Double")
        else -> println("number not support")
    }
}
```

### for-in循环

```kotlin
//创建一个左闭右闭的区间
val range=0..10
//创建一个左闭右开的区间
val range=0 until 10

//遍历这个区间，使用step可以跳过一些元素
for (i in 0..10 step 2) {
        println(i)
}
//创建一个降序的区间
for (i in 10 downTo 1) {
        println(i)
}
```

## 面向对象

### 类与对象

```kotlin
//创建类
class Person {
    var name = ""
    var age = 0

    fun eat() {
        println(name + " is eating. He is " + age + " years old.")
    }
}
//创建对象
fun main() {
    val p = Person()
    p.name = "Jack"
    p.age = 19
    p.eat()
}
```

### 继承

* 一个类默认是不可以被继承的，如果一个类要被继承，需要主动声明open关键字。

```kotlin
//超类
open class Person {
    …
}
//子类
class Student : Person() {
    var sno = ""
    var grade = 0
}
```

### 接口

```kotlin
interface Study {
    fun readBooks()
    fun doHomework()
}
//实现
class Student(val name: String, val age: Int) : Study {
    override fun readBooks() {
        println(name + " is reading.")
    }

    override fun doHomework() {
        println(name + " is doing homework.")
    }
}
```

### 数据类

* 数据类会根据主构造函数的参数将equals、hashCode、toString方法自动生成。

```kotlin
data class Cellphone(val brand: String, val price: Double)
```

### 单例类

```kotlin
object Singleton {
    fun singletonTest() {
        println("singletonTest is called.")
    }
}

//调用方式Singleton.singletonTest()
```

### 集合

```kotlin
//创建List
val list = listOf("Apple", "Banana", "Orange", "Pear", "Grape")
//创建Set
val set = setOf("Apple", "Banana", "Orange", "Pear", "Grape")
//创建Map
val map = mapOf("Apple" to 1, "Banana" to 2, "Orange" to 3, "Pear" to 4, "Grape" to 5)
```

### lambda表达式

* 格式：`{参数名1:参数类型,参数名2:参数类型->函数体}`
  * ->表示参数列表的结束以及函数体的开始，函数体中可以编写任意行代码，最后一行代码会自动作为lamabda表达式的返回值。

```kotlin
fun main() {
    val list = listOf("Apple", "Banana", "Orange", "Pear", "Grape", "Watermelon")
    val newList = list.map({ fruit: String -> fruit.toUpperCase() })
    for (fruit in newList) {
        println(fruit)
    }
}
//当lambda参数是函数的最后一个参数时，可以把lambda表达式移到函数括号外面。
//如果lambda参数是函数的唯一一个参数的话，可以将函数的括号省略。
//大多数情况下也不必声明参数类型
//当参数列表中只有一个参数时，不必声明参数名，可以使用it关键字代替。
//以上代码可简写为：
val newList = list.map { it.toUpperCase() }
```

### 空指针检查

```kotlin
//下面这段代码没有空指针风险，因为kotlin默认所有的参数和变量都不可为空。
fun doStudy(study: Study) {
    study.readBooks()
    study.doHomework()
}
```

* `?.`操作符表示当对象不为空时正常调用相应的方法，当对象为空时就什么也不做。
* `?:`操作符表示如果左边表达式的结果不为空就返回左边表达式的结果，否则就返回右边表达式的结果。

```kotlin
if(a != null) {
    a.doSomething()
}
//上面这个java代码等价于
a?.doSomething()
```

```kotlin
val c = if (a ! = null) {
    a
} else {
    b
}
//等价于
val c = a ?: b
```

