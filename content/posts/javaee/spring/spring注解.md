---
title: spring注解
tags: 
  - javaee
  - spring
date: 2021-10-16 15:27:12
---

* @Autowired默认按照Bean的类型进行装配，如果要按照名称来装配，则需要和@Qualifier注解一起使用。
* @Qualifier与@Autowired注解配合使用，Bean的实例的名称由@Qualifier注解的参数指定。
* @Resource和@Autowired的功能一样，区别在于该注解默认按照名称来装配注入的，只有当找不到与名称匹配的Bean时才会按照类型来装配注入。

<!--more-->
