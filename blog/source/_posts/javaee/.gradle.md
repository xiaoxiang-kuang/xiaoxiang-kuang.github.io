---
title: gradle
categories:
  - [javaee]
site: javaee
date: 2021-08-16 10:41:51
---

* 每个task都代表了构建执行过程中的一个原子性的操作，`doFirst`和`doLast`是在task开始/结束时执行。

* 添加maven仓库

```groovy
repositories{
    mavenCentral()
}
```

* 添加依赖

```groovy
dependencies {
    
}
```

* 当需要使用本地的jar包，就需要使用`buildscript`，`buildscript`对所有子模块可见。

```groovy
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath group: 'commons-codec', name: 'commons-codec', version: '1.2'
    }
}
```

