---
title: django起步
categories:
  - [python, django]
site: python
date: 2021-03-16 15:38:07
---

## 起步

* django项目目录

```python
mysite/
    manage.py #管理django项目的命令行工具
    mysite/	#python包，名字就是当引用它内部任何东西时需要用到的python包名
        __init__.py	#告诉python这个目录应该被认为是一个python包
        settings.py	#项目的配置文件
        urls.py #url声明
        asgi.py #运行在asgi兼容的web服务器上的入口
        wsgi.py #运行在wsgi兼容的web服务器上的入口
```

* 运行项目的命令`python manage.py runserver`
* 创建一个应用`python manage.py startapp polls`
* 函数path()有四个参数，两个必须参数route和view，两个可选参数kwargs和name
  * route是一个匹配URL的准则，当响应一个请求时，他会从urlpatterns的第一项开始，按顺序依次匹配列表中的项。这些准则不会匹配get和post参数或域名
  * view：当找到了一个匹配的准则，就会调用这个特定的视图函数，并传入一个HttpRequest对象作为第一个参数，被捕获的参数以关键字参数的形式传入。
  * kwages：任意个关键字参数可作为一个字典传递给目标视图函数。
  * name：为url取名

## 模型

### 设置mysite/sittings.py

* 设置时区`TIME_ZONE = 'Asia/Shanghai' USE_TZ = True`
  * 当启用了时区支持（即`USE_TZ = True`），Django将在数据库中以UTC存储日期信息，而在模板和表单中转化为最终用户的时区
* 设置数据库
* `INSTALLED_APPS`是在项目中启用的Django应用，这里面的某些应用需要数据表，可以用`python manage.py migrate`生成

### 创建模型

* 模型设真实数据的描述，它包含了存储的数据所必要的字段和行为。
* Django的迁移代码是从模型文件中自动生成的
* 每个模型都是`django.db.models.Model`类的子类，每个模型有许多的类变量，他们都表示一个数据库的字段，每个字段都是Field类的实例，每个Field类实例变量的名字也是数据库的列名。

```python
#polls/models.py
from django.db import models

class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
```

### 激活和修改模型

* 首先把应用安装到项目中，在`INSTALLED_APPS`中添加`polls.apps.PollsConfig`
* 执行`python manage.py makemigrations polls`
* 迁移数据存放在应用的`migrations/0001_initial.py`中，可以通过`python manage.py sqlmigrate polls 0001`来查看对应的sql
* 运行`python manage.py migtate`来应用数据库迁移
* 通过`python manage.py shell`可进入当前项目对应的命令行
* 给模型增加`__str__`方法能带来一些方便

## Django管理页面

* 首先创建一个能登陆管理界面的用户`python manage.py createsuperuser`
* 将创建的models注册，以便后台可以管理

```python
#polls/admin.py
from django.contrib import admin
from .models import Question

admin.site.register(Question)
```

* 运行项目`python manage.py runserver`

https://docs.djangoproject.com/zh-hans/3.1/intro/tutorial03/