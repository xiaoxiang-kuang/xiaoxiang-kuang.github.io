---
title: git远程仓库
tags: 
  - git
date: 2021-11-24 19:17:57
---

* 查看远程仓库

```sh
#列出指定的每一个远程服务器的简写
git remote
#显示远程仓库的简写与对应的URL
git remote -v
#查看某个远程仓库的更多信息，会列出远程仓库的URL和跟踪分支的信息。
git remote show origin
```

* 添加、修改和删除远程仓库

```sh
#添加一个远程仓库，并指定一个简写
git remote add pb https://xxx.xxx/xxx/xxx
#修改仓库的远程地址
git remote set-url origin 仓库地址
#远程仓库的重命名
git remote rename pb paul
#移除一个远程仓库
git remote remove paul
```

* 从远程服务器抓取数据

```sh
#git fetch只会将数据下载到本地仓库，并不会合并。需要手动合并
git fetch pb
#自动抓取远程分支并合并到本地分支
git pull
```

参考链接：[Git - 远程仓库的使用 (git-scm.com)](https://git-scm.com/book/zh/v2/Git-基础-远程仓库的使用)


<!--more-->
