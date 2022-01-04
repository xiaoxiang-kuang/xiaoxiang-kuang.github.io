---
title: java线程的6种状态
tags: 
  - javase
  - java并发
date: 2020-10-08 21:28:45
---
* 操作系统层面线程有5种状态

* 在 java中，Thread.State 将线程分为六种状态

```java
public enum State {
        // 线程刚被创建，但是还没调用start方法
        NEW,

        /**
         * 该状态的线程在jvm中是执行状态，但是在操作系统中可能是在等待其他的资源。
         * 此状态涵盖了操作系统中的 运行态、就绪态、阻塞态
         */
        RUNNABLE,

        /**
         * 此状态的线程会等待一个monitor lock。
         * A thread in the blocked state is waiting for a monitor lock 
         * to enter a synchronized block/method or
         * reenter a synchronized block/method after calling Object.wait
         */
        BLOCKED,

        /**
         * Thread state for a waiting thread.
         * 以下方法可使线程进入此状态：
         * 	 Object.wait with no timeout
         * 	 Thread.join with no timeout 
         * 	 LockSupport.park
         * 该状态的线程会等待其他线程通过特定的动作唤醒。
         */
        WAITING,

        /**
         * Thread state for a waiting thread with a specified(特定的) waiting time.
         * 以下方法可使线程进入此状态：
         * 	 Thread.sleep
         * 	 Object.wait with timeout
         * 	 Thread.join with timeout
         * 	 LockSupport.parkNanos
         * 	 LockSupport.parkUntil
         */
        TIMED_WAITING,

        // 线程已经完成了执行，终止了的状态。
        TERMINATED;
    }
```

<!--more-->
