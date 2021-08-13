---
title: equals
categories:
  - [javase]
site: javase
date: 2021-04-26 09:37:09
---

## Object

* Object的equals方法

```java
    public boolean equals(Object obj) {
        return (this == obj);
    }
```

* Object的toString方法

```java
	public String toString() {
        return getClass().getName() + "@" + Integer.toHexString(hashCode());
    }
```

## String 

* String的equals方法

```java
    public boolean equals(Object anObject) {
        //如果指向的是同一个对象就返回true
        if (this == anObject) {
            return true;
        }
        //如果该对象是String的实例
        if (anObject instanceof String) {
            String anotherString = (String)anObject;
            //value存放的是String本身的字符串
            int n = value.length;
            //如果两个字符串的长度相等
            if (n == anotherString.value.length) {
                char v1[] = value;
                char v2[] = anotherString.value;
                int i = 0;
                //按下标比较两个字符串的字符
                while (n-- != 0) {
                    if (v1[i] != v2[i])
                        return false;
                    i++;
                }
                return true;
            }
        }
        return false;
    }
```

* String的hashCode方法

```java
	private int hash; // Default to 0	
	//...
	//当通过new String("xxx")方式创建的字符串，原hash就被赋值给了现在的hash
    public String(String original) {
        this.value = original.value;
        this.hash = original.hash;
    }
	//当hash为0并且字符串长度不为0时，现在的hash是通过循环计算出来的
	//由该计算可知道，当字符串一样，它的hashcode就一样
	public int hashCode() {
        int h = hash;
        if (h == 0 && value.length > 0) {
            char val[] = value;

            for (int i = 0; i < value.length; i++) {
                h = 31 * h + val[i];
            }
            hash = h;
        }
        return h;
    }
```

