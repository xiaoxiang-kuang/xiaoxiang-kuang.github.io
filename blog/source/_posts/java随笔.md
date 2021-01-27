---
title: java随笔
categories:
  - [java]
date: 2021-01-27 10:59:11
---


### 异常

* 所有的异常都继承自Throwable；
* Throwable有两个子类：Error，Exception。
* Error描述了java运行时系统的内部错误和资源耗尽错误；
* Exception有有两个分支，一个分支派生于RuntimeException，另一个分支包含其他异常。
* 由程序错误导致的异常属于RuntimeException，例如：数组下标越界，错误的类型转换，空指针异常；
  其他异常包括IOException,SQLException等。

### 线程

* 对于sun jdk来说，它的windows版和linux版都是使用一对一的线程模型实现的，一条java线程就映射到一条轻量级进程中，因为windows和linux系统提供的线程模型就是一对一的。

### cas

* cas指令需要有3个操作数，
* 分别是变量的内存地址（V），旧的预期值（A）和新值（B）。
* 当cas指令执行时，当且仅当V符合旧预期值A时，处理器用新值B更新V的值，否则他就不执行更新。
  （但是无论是否更新了V的值，都会返回V的旧值。）
* 上述的操作是一个原子操作。

