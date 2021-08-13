---
title: collection和map
categories:
  - [javase]
site: javase
date: 2020-07-29 16:24:46
---

## Collection



## Map

### HashMap

* `DEFAULT_INITIAL_CAPACITY = 1 << 4`：默认初始容量为16，该容量必须为2的倍数
* `DEFAULT_LOAD_FACTOR = 0.75f`：默认的加载因子，可以大于1
* `MAXIMUM_CAPACITY = 1 <<30`：最大容量
* `TREEIFY_THRESHOLD = 8`：由链表转换成树的阈值
* `UNTREEIFY_THRESHOLD = 6`：由树转换成链表的阈值
* `MIN_TREEIFY_CAPACITY = 64`