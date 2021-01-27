---
title: DataOutputStream的writeChars
categories:
  - [java]
date: 2021-01-27 11:02:06
---


* DataOutputStream的writeChars不推荐使用！
* writeChars是将String直接拆成了byte（即先获取String对应的char数组，再将一个char分割成两个byte）。如果在客户端使用了该方法写入一个字符串，再在服务端读取，因为DataInputStream并没有readChars方法，只能使用read方法读取一个byte数组。这就会导致一个问题，byte数组转化为String会有一个编码的问题，服务端可能会出现错误。
* 正确的姿势是使用DataOutputStream的write方法写入一个byte数组，两端使用相同的编码。