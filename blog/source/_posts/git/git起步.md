---
title: git起步
categories:
  - [git]
site: git
date: 2021-01-28 13:49:03
---

* git：每一次的clone操作，实际上都是对一次代码仓库的完整备份。
* git中文件的三种状态：已修改（modified）和已暂存（staged），已提交（committed）：
  * 已修改<sup><a id="modified" herf="javascript:;">tag1</a></sup>表示已修改了某个文件，但还没有提交保存（git add之前）；
  * 已暂存表示把已修改的文件放在下次提交的清单中（git add 之后）;
  * 已提交表示该文件已经被安全保存在本地数据库中（git commit之后）；
* 每个项目都有一个git目录（.git），git工作流程如下：
  1. 在工作目录（.git的兄弟目录）中修改某些文件；
  2. 对修改后的文件保存到暂存区域；
  3. 提交跟新，将暂存区域的文件快照转储到git目录中。
  4. 提交到远程仓库。

### 开始

1. 注册git账号，github或者gitee（访问快一点），并建立一个公开的仓库（下面用）。
2. 安装git，配置个人用户名称和电子邮件地址。
    `git config --global user.name "xiaoxiang"`
    `git config --global user.email "xiaoxiang@xxxx.com"`
3. 可以使用`git config --list`查看已有的配置信息。
4. 从现有的git仓库克隆`git clone [远程仓库]`。
5. 工作目录下的文件分为两种状态：已跟踪和未跟踪：
   * 已跟踪是本地仓库中有的文件，初次克隆某个仓库时，工作目录的所有文件都是已跟踪的文件。
   * 未跟踪是新创建的文件，即对该文件从来没有执行git add命令。
   * 当编辑过某些文件后，git将这些文件标记为已修改，这就跟[tag1](#modified)对于上了。
6. 使用`git add`开始跟踪一个新文件，`git add .`暂存当前路径下的所有的已修改的文件。
   * 通过`git status`可以查看文件的状态。
   * 取消已暂存的状态`git reset [--mixed] HEAD  "文件名"`，该方式会清除暂存区的数据，保留工作目录的数据。
7. 使用`git commit -m "提交说明"`来提交暂存区的数据到**本地仓库**。
8. 使用`git push origin master` 将修改提交到远程仓库。（使用`ssh-keygen`生成密钥，并将公钥放到git上去，以后提交就不用输账号和密码了）。
   * `git push [remote-name] [branch-name]`，这是完整命令。当使用克隆命令时，默认使用origin作为远程仓库的名字，master作为本地分支的名字，`git push`不加其他参数也能用，但是如果你创建了好几个分支就得加上[remote-name]和[branch-name]。

#### tips

* 可以创建一个.gitignore文件，来指明哪些文件不需要被提交到仓库。
* 查看文件修改了什么地方，可以使用`git diff`指令。
* 从git暂存区移除文件可以使用`git rm`，他不会移除工作目录的文件（这要自己删除）。
* 查看提交历史`git log`，后跟`-2`只会显示最近两次的跟新。
* 添加一个远程仓库`git remote add [仓库名称] [仓库地址]`,抓取该仓库所有文件`git fetch [仓库名称]`,切换到该仓库`git checkout [仓库名称]/master`，修改远程仓库的名字`git remote rename [原名] [新名]`。
* `git pull`是将远程仓库抓下来，合并到本地分支。
* `git tag`可以给某一时间点的版本打标签。
* `git remote set-url origin 仓库地址`：修改仓库的远程地址
* `git remote -v`：查看当前仓库对应的远程地址。
* `git update-index --assume-unchanged 文件名`：取消本地跟踪
* `git update-index --no-assume-unchanged 文件名`：恢复本地跟踪
* 协议：
  * ssh协议：唯一一个同时支持读写操作的网络协议，但无法实现对仓库的匿名访问。
  * git协议：该协议通常用来克隆，**通常**不能用来推送（因为没有授权机制，如果允许推送操作，每一个知道该URL的人都有推送权限），比http协议高效。
  * http/s协议：容易搭建，通常用来克隆。



**参考链接：[Pro Git](http://git.oschina.net/progit/)**
**参考链接：[开源指北](https://gitee.com/opensource-guide/git_tutorial/Git%20%E5%91%BD%E4%BB%A4%E8%AF%A6%E8%A7%A3/%E5%B8%B8%E7%94%A8%20Git%20%E5%91%BD%E4%BB%A4/#git-%E5%91%BD%E4%BB%A4%E6%89%8B%E5%86%8C)**

