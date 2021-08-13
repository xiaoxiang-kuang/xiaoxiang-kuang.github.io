---
title: Buffer
categories:
  - [javase,java并发]
site: javase
date: 2021-01-27 10:57:51
---

### Buffer

* 使用Buffer读写数据一般遵循四个步骤：①写入数据到Buffer；②调用flip()方法；③从Buffer中读入数据；④调用clear()或者compact()方法。
* 缓冲区的本质是一块可以写入数据，然后可以从中读取数据的内存。
* Buffer的三个属性：1.capacity 2.position 3.limit
  * capacity 表示该内存块的大小
  * position 当你写入数据到Buffer中，position表示当前的位置。当将Buffer从写模式切换到读模式时，position会被置为0。
  * limit 写模式下，limit等于capacity。当将Buffer从写模式切换到读模式时，limit表示你最多能读入多少数据，所以此时limit会被设置为写模式下的position值。
* flip()方法将Buffer从写模式切换到读模式。调用该方法会将position设置为0，将limit设置为position的之前的值。
* rewind()将position设回0。
* clear()将position设置为0，将limit设置为capacity，表示可以写入了。
* compact()将所有未读的数据拷贝到Buffer的起始处，然后将position设置到最后一个未读元素正后面，limit设置为capacity，表示可以写入了。
* mark()可以记录一个特定的position。之后可以调用reset()恢复到这个位置。

