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

## 构建

### Project和tasks

* 每个gradle build由多个projects组成，一个project又由多个tasks组成。

``` groovy
tasks.register('upper') {
    doLast {
        String someString = 'mY_nAmE'
        println "Original: $someString"
        println "Upper case: ${someString.toUpperCase()}"
    }
}
tasks.register('hello') {
    dependsOn tasks.upper
    doLast {
        print 'hello world'
    }
}

#执行gradle -q hello，-q表示抑制日志消息
```

```groovy


tasks.register('hello') {
    doLast {
        println 'Hello Earth'
    }
}
tasks.named('hello') {
    doFirst {
        println 'Hello Venus'
    }
}
tasks.named('hello') {
    doLast {
        println 'Hello Mars'
    }
}
tasks.named('hello') {
    doLast {
        println 'Hello Jupiter'
    }
}

#执行gradle -q hello
#doFirst和doLast可以被执行多次，他们被添加到task的actions list的开始或结束位置，当task执行时，在action list中的action会被按顺序执行。
```

#### 默认task

* gradle允许定义多个默认的task

```groovy
defaultTasks 'clean', 'run'

tasks.register('clean') {
    doLast {
        println 'Default Cleaning!'
    }
}

tasks.register('run') {
    doLast {
        println 'Default Running!'
    }
}
#通过gradle -q执行
```

#### 为构建脚本添加外部依赖

* 如果构建脚本需要使用外部的库，可以使用buildscript，buildscript中添加的依赖只对构建脚本有效。

```groovy
//使用改库中的某个类
import org.apache.commons.codec.binary.Base64

buildscript {
    repositories {
        mavenCentral()
    }
    //将库添加到classpath路径下
    dependencies {
        classpath group: 'commons-codec', name: 'commons-codec', version: '1.2'
    }
}

tasks.register('encode') {
    doLast {
        def byte[] encodedString = new Base64().encode('hello world\n'.getBytes())
        println new String(encodedString)
    }
}

#gradle -q encode
```

