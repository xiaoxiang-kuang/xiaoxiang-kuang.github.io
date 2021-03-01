---
title: final
categories:
  - [java]
site: java
date: 2020-04-09 16:56:27
---

* final修饰局部变量

```java
public void test1(){
    //正确写法
    final int a;
    a=10;
    
    //正确写法
    final int b=10;
    
    //定义后不能再次进行赋值
    a=10;//错误
}
//tips：final如果修饰一个对象，那么该对象的引用的地址不能改变，但是对象的属性可以改变。
```

* final修饰对象属性

```java
//正确写法，即在属性定义处赋值
class Student{
    private final int a=10;
}

//正确写法，当在属性处没有赋值时，必须在该类的所有构造方法中进行赋值
class Student2{
    private final int a;
    
    public Student2(){
    	a=10;    
    }
    public Student2(int a){
    	this.a=a;
    }
}
//tips：不能既在属性定义处赋值，又在类的构造方法中赋值
```
