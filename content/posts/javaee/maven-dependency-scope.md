---
title: maven-dependency-scope
tags: 
  - javaee
date: 2021-04-23 21:13:01
---

## 共6个作用域

1. compile
   * 默认作用域，在项目的编译、运行、测试中都有效，依赖传递
2. provided

   *  在项目编译、测试中有效，运行中无效；依赖不传递，适用于一些web容器提供了运行时的依赖的情况。
3. runtime
   * 只在项目运行、测试中有效，依赖传递

4. test
   * 表示程序正常使用时不需要该依赖，只在测试编译和执行中有效。依赖不传递

5. system
   * 和provided很像，但是必须明确指定jar路径，它不在仓库中去寻找

6. import
   * 该作用域仅适用于`<dependencyManagement>`中type为pom的情况。
   * [Importing Dependencyies](http://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#Importing_Dependencies)


<!--more-->
