---
title: String
date: 2020-09-25 21:17:32
categories: 
- javase
site: javase
---

### String的基本特性

* String类的声明为final。
* String实现了Serializable接口：表明字符串是支持序列化的。实现了Comparable接口：表面字符串是可以比较大小。
* String再jdk8及以前使用 final char[] value存储字符串数据，jdk9改为byte[]。
* String的字符串常量池是一个固定大小的hashtable，在jdk7中默认大小是60013，（jdk8中1009是可以设置的最小值），使用<b>-XX:StringTableSize=</b>可以设置StringTable的长度。如果字符串常量池中的字符串非常多，就可能会造成hash冲突，从而导致链表变得很长（链表长度大于8时会转化成红黑树），但还是会导致性能下降（比如在调用intern时）。

* 字符串的拼接操作

   * 常量与常量的拼接是放在String Pool中，原因是编译期优化。
   * 只要其中有一个是变量，结果就放在堆中。变量拼接的原理是StringBuilder。
   * 如果拼接的结果调用intern方法，则主动将常量池中还没有的字符串放入池中，并返回其地址（如果String Pool中有，则直接返回其地址），下面还要对intern进行讨论。

### 字符串的拼接操作
```java
String s1="a";
String s2="b";
String s3="ab";
String s4=s1+s2;
/*
如果被拼接的字符串中有变量，执行字符串拼接操作会进行如下几个步骤
①StringBuilder s=new StringBuilder();
②s.append(s1); s.append(s2);
③s.toString();
如果要被拼接的字符串中全是常量或者常量引用，则仍然使用编译器优化，不会涉及到上面三步。
*/
System.out.println(s4==s3);//false
```

### 部分源码分析

```java
//下面这两行代码输出的结果为什么是nullabc呢？一起来分析一下源码吧
String s=null+"abc";
System.out.println(s);//nullabc

//StringBuilder类，当传入一个对象时会将该对象转化成一个字符串
public StringBuilder append(Object obj) {
	return append(String.valueOf(obj));
}
//String类，当该对象为null时，会返回一个"null"字符串，否则返回该对象的toString方法
public static String valueOf(Object obj) {
	return (obj == null) ? "null" : obj.toString();
}
```

### 部分考点分析

```java
String s=new String("ab");
/*
创建了两个对象
对象1：new String("ab");
对象2：常量池中的"ab";
*/

String s1=new String("a")+new String("b");
/*
创建了6个对象
对象1：new StringBuilder();
对象2：new String("a");
对象3：常量池中的"a";
对象4：new String("b");
对象5：常量池中的"b";
对象6：当append操作结束后，会调用StringBuilder的toString方法，将StringBuilder对象转化为String对象，
	此时又发生了一次new的操作:new String(value, 0, count);
tips：这里虽然创建了6个对象，但实际上在常量池中并没有创建"ab";
*/
```
### intern

从jdk7开始，当我们调用String对象的intern()方法：

* 如果常量池中有这个字符串，则返回常量池中该串的地址。
* 如果常量池中没有该串，则会把**对象的引用地址**复制一份，放入常量池，并返回常量池中的引用地址。

```java
String s1=new String("ab");
s1.intern();
String s2="ab";
System.out.println(s1==s2);//false;
/*
这是因为一个是堆中的对象，一个是常量池中的对象
*/

String s3=new String("a")+new String("b");
s3.intern();
String s4="ab";
System.out.println(s3==s4);//true(jdk7及以上版本的结果);
/*
这个是不是感觉很匪夷所思？
原因是在创建了s3之后，常量池中并没有"ab"这个对象，
而在执行s3.intern()后，常量池中多了一个指向堆中的对象的指针，
所以当执行s4="ab"时，s4实际上也是指向了堆中创建的那个对象。
为什么这么做呢？指针才占4个字节，用指针省空间。
*/
```




