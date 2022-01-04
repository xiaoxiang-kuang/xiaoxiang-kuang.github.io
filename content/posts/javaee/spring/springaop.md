---
title: springaop
tags: 
  - javaee
  - spring
date: 2021-10-12 14:52:08
---

### 通知类型

1. 环绕通知@Around：在目标方法执行前和执行后实施增强；
2. 前置通知@Before：在目标方法执行前实施增强；
3. 后置返回通知@AfterReturning：在目标方法执行**成功**后实施增强；
4. 后置通知@After：在目标方法执行后实施增强，不论是否发生异常都执行该类通知；
5. 异常通知@AfterThrowing：方法抛出异常后实施增强；
6. 引入通知：在目标类中添加一些新的方法和属性，用于修改目标类。

![](/img/javaee/springaop/1.png)

<!--more-->
