---
title: join和park
categories:
  - [javase,java并发]
site: javase
date: 2020-11-19 15:48:31
---

### join源码分析

* join()是等待一个线程运行结束

```java
public class Thread implements Runnable {
    //底层是使用wait()实现
    public final synchronized void join(long millis) throws InterruptedException {
        long base = System.currentTimeMillis();//开始时间
        long now = 0;//已经等待的时间

        if (millis < 0) {
            throw new IllegalArgumentException("timeout value is negative");
        }

        if (millis == 0) {//参数为0时会一直等待线程结束
            while (isAlive()) {
                wait(0);
            }
        } else {
            while (isAlive()) {
                //防止虚假唤醒，因为wait会被notify和notifyAll唤醒
                //唤醒后需要等待的时间是millis减去已经等待的时间
                long delay = millis - now;
                if (delay <= 0) {
                    break;
                }
                wait(delay);
                now = System.currentTimeMillis() - base;
            }
        }
    }
    
    public final void join() throws InterruptedException {
        join(0);
    }
}
```

### park

* LockSupport.park();//暂停当前线程
* LockSupport.unpark(暂停线程对象);//恢复某个线程的运行
* 对应的线程状态还是wait状态
* unpark可以在park之前执行，仍然可以恢复线程的执行