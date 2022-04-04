---
title: git分支
tags: 
  - git
date: 2021-01-28 16:11:34
---

* 在git提交时，会保存一个commit对象，该对象包含指向本次提交内容快照的指针和0个或多个指向该其父对象（之前提交的）的指针。普通提交有一个父对象，分支合并提交有多个父对象。

### 开始

* git分支，是一个指向commit对象的可变指针，它在每次提交后都会指向当前的commit对象。git有一个名为HEAD的特别指针，它是一个指向当前工作的本地分支的指针。
* ![](/img/git/1.png)
* 创建一个新的分支`git branch testing`，这会在当前commit对象上新建一个分支指针。
![](/img/git/3.png)
* 切换到其他分支`git checkout testing`，这样HEAD就指向了testing分支。
  ![](/img/git/4.png)
* 当在该testing支下修改文件并提交后，会新建一个commit对象，testing指向了该对象。而在我们切换回master分支时，master仍然指向上一个commit对象
![](/img/git/5.png)
* 当在master分支下修改文件并提交后：
![](/img/git/6.png)

#### tips

* 只有在本地修改或者产生了文件才会创建主分支master，这个时候才能创建新分支。
* `git branch`查看所有的分支，`*`表示当前分支。
* `git checkout -b testing`相当于`git branch testing 和 git checkout testing`
* 删除分支`git branch -d testing`
* 分支的合并：在当前分支下（如master），执行`git merge testing`，会创建新的commit对象，master也会指向他。该commit对象有两个父指针。
* 分支的合并会用两个分支的末端以及他们的共同祖先进行一次的三方合并，当两个分支在同一个commit链上时，旧一点的那个分支发起合并，则将其直接指向了新一点的那个分支。
* 有时候分支合并会失败，比如两个分支同时修改了相同的文件。这个时候`git merge testing`仍然做了合并，但是没有提交，可以使用`git status`查看，此时就需要手动合并了。
* `git branch --merged`查看那些分支已被并入当前分支。`git branch --no-merged`查看尚未合并的分支。
* 删除远程分支`git push [远程名]:[分支名] --delete` 。
* 分支的衍合（rebase），`git rebase master`。他的结果和直接使用merge一样。**谨慎使用该方式**

**参考链接：[Pro Git](http://git.oschina.net/progit/3-Git-%E5%88%86%E6%94%AF.html)**
**参考链接：[开源指北](https://gitee.com/opensource-guide/git_tutorial/Git%20%E5%91%BD%E4%BB%A4%E8%AF%A6%E8%A7%A3/%E5%B8%B8%E7%94%A8%20Git%20%E5%91%BD%E4%BB%A4/#git-%E5%91%BD%E4%BB%A4%E6%89%8B%E5%86%8C)**


<!--more-->
