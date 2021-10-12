---
title: gradle
categories:
  - [javaee]
site: javaee
date: 2021-08-30 17:46:59
---

##### `settings.gradle`

``` groovy
rootProject.name = 'demo'
include('app')
```

* rootProject指定了构建的名称，默认以上级目录命名。
* include('...')定义了一个叫app的子项目，子项目包含自己的代码和构建逻辑。

##### `gradle.properties`

最终的配置组合了所有的命令行提供的属性和gradle.properties文件。

###### 配置优先级：

1. 命令行使用-P/--project-prop传递的参数；
2. GRADLE_USER_HOME目录的gradle.properties;
3. 项目根目录的gradle.properties;
4. gradle安装目录的gradle.properties.

``` properties
#指定构建时jvm参数。
org.gradle.jvmargs=-Xms2g
#并行编译，会使用org.gradle.workers.max参数
org.gradle.parallel=(true,false)
#默认为CPU的数量
org.gradle.workers.max=

#使用systemProp.前缀可在gradle.properties中配置系统属性，或者命令行中使用-D（不加systemProp，有多个project时，只有根路径下的以systemProp开头的属性会被使用，其他的都会被忽略。

```

**参考链接：**[Build Environment (gradle.org)](https://docs.gradle.org/current/userguide/build_environment.html)

