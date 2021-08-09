---
title: android
categories:
  - [其他]
date: 2021-03-22 14:36:24
---

## 项目结构

* `app > java > 包名 > MainActivity`：主activity，是应用的入口点。
* `app > res > layout > activity_main.xml`：定义了activity界面的布局。
* `app > manifests > AndroidMainifest.xml`：描述应用的基本特性并定义其每个组件。
* `Gradle Scripts > build.gradle`：一个是针对项目的gradle，一个是针对模块的gradle。

## 安卓应用组件

1. Activity
   * 拥有界面的单个屏幕
2. 服务
   * 是一种在后台运行的组件，用于执行长时间运行的操作。如后台播放歌曲，服务不提供界面。
3. 广播接收器
   * 每个应用程序都可以对自己感兴趣的广播进行注册，这样该程序就只会收到自己关心的广播内容。
4. 内容提供程序
   * 管理一组共享的应用数据。其他应用可通过内容提供程序查询或修改数据。

## tips

* 要在ConstraintLayout中定义某个视图的位置，必须为该视图添加至少一个水平约束条件和一个垂直约束条件。
* 只能在公用同一平面的约束手柄与定位点之间创建约束条件
* 如果希望视图扩展其尺寸以满足约束条件，可以将尺寸切换为match constraints