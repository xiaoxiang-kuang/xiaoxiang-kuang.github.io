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
