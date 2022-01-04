---
title: interface
tags: 
  - javase
date: 2020-04-09 18:37:46
---

* 接口中的抽象方法，修饰符必须是public abstract，这两个关键字可以选择性的忽略。
* 接口中的属性，修饰符必须是public static final,这三个关键字可选择性的忽略。
* 接口中的常量必须赋值，且命名建议完全大写（多个单词之间用“_”隔开）。
* jdk8及以后版本：
  * 被default修饰的方法，修饰符必须是public，可省略。子类可覆盖重写default方法。
  * 被static修饰的方法，修饰符必须是public，可以省略。
  * 不能通过接口实现类的对象来调用接口中的static方法。

<!--more-->
