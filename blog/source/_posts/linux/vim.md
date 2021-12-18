---
title: vim
categories:
  - [linux]
site: linux
date: 2021-09-01 14:17:21
---

通过配置~/.vimrc（不建议修改/etc/vimrc）可以设定一些vim的属性，在vim的命令模式输入`:set all`可以查到

* `ctrl+f`向下移动一页
* `ctrl+b`向上移动一页
* `0或者home`移动到这一列的最前面
* `$或end`移到这一列最后一页
* `G(注意是大写)`移到文件的最后一列
* `gg`移到文件的第一行
* `n+enter`光标向下移动n行
* `/word`搜索为名称为word的字符串
* `:1,2s/word1/word2/g`[第一行，第二行]中所有的word1被替换成word2
* `:1,$s/word1/word2/g`第一行到最后一行所有word1被替换为word2
* `:1,$s/word1/word2/gc`第一行到最后一行所有word1被替换为word2，且在取代前会提示字符给用户确认
* `dd`删除当前一整行，`ndd` 删除光标所在的向下n行
* `yy`复制一整行，`4yy `复制4行。
* `p`将复制的数据在光标的下一行粘贴，`P`在光标的上一行粘贴
* `u`复原前一个动作
* `ctr+r`重复上一个动作
* `:w [filename]`将文件另存为
* `:set nu/nonu`开启/关闭行号
