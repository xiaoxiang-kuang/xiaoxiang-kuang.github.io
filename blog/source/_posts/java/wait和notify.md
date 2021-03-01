---
title: wait和notify
categories:
  - [java,java并发]
site: java
date: 2020-10-06 19:40:01
---


* 在调用wait方法时，线程必须要持有被调用对象的锁，当调用wait方法之后，线程就会释放掉该对象的锁。
* 在调用Thread类的sleep方法时，线程是**不会释放掉对象的锁**的。

***


1. 当调用wait方法时，首先要确保调用了wait方法的线程已经持有了对象的锁。
2. 当调用了wait后，该线程就会释放掉这个对象的锁，然后进入等待状态，该线程进入对象的等待集合中（wait set）。
3. 当线程调用了wait后进入到等待状态时，它就等待其他线程调用相同对象的notify和notifyAll方法来使得自己被唤醒。
5. 调用wait方法的代码片段需要放在一个synchronized块或者被synchronized修饰的方法中。
6. 当调用了对象的notify方法时，它会随机唤醒该对象等待集合中（wait set）的任意一个线程，当某个线程被唤醒后，它就会与其他线程一同竞争对象的锁。
7. 当调用对象的notifyAll方法时，它会唤醒该对象等待集合中（wait set）中所有的线程，这些线程被唤醒后，又会开始竞争对象的锁。
8. 某一时刻，只有唯一的一个线程拥有对象的锁。

### 具体案例

Demon对象有一个int类型的属性counter，该值初始为0；
创建四个线程，两个线程对该值增1，两个线程对该值减1；
输出counter每次变化后的结果，要求输出结果为1010101010...。

##### 包含counter的Demon类

```java
//该对象提供加1和减1的操作
class Demon{
    //counter
    private int counter=0;
	//对方法加锁，当一个线程要调用该方法时，需要先获取该对象的锁
    public synchronized void inc(){//counter加1
        //此处必须使用while而不是if，防止被其他不相关的线程唤醒
        while(counter!=0){
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter++;
        System.out.print(counter);
        /*此处必须使用notifyAll，notify会从等待队列中
        随机选择一个线程唤醒，可能会导致程序一直阻塞*/
        notifyAll();
    }
	//counter减1
    public synchronized void dec(){
        while(counter!=1){
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter--;
        System.out.print(counter);
        notifyAll();
    }
}
```
**关键代码如上，剩余的代码也都比较简单，就省略了。如果你需要所有代码，可以通过`ctrl+u`查看网页源代码，并使用`ctrl+f`快捷键搜索"黑魔仙变身"即可找到完整代码。手机需要使用能查看网页源代码的浏览器，如via等。**
<!--
//黑魔仙变身
//该对象提供加1和减1的操作
class Demon{
    //counter
    private int counter=0;
	//对方法加锁，当一个线程要调用该方法时，需要先获取该对象的锁
    public synchronized void inc(){//counter加1
        //此处必须使用while而不是if，防止被其他不相关的线程唤醒
        while(counter!=0){
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter++;
        System.out.print(counter);
        /*此处必须使用notifyAll，notify会从等待队列中
        随机选择一个线程唤醒，可能会导致程序一直阻塞*/
        notifyAll();
    }
	//counter减1
    public synchronized void dec(){
        while(counter!=1){
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter--;
        System.out.print(counter);
        notifyAll();
    }
}
//执行counter++
class IncThread implements Runnable{
    private Demon demon;
    public IncThread(Demon demon){
        this.demon=demon;
    }
    //实现Runnable的run方法
    public void run() {
        for(int i=0;i<30;i++) {
            demon.inc();
        }
    }
}
//执行counter--
class DecThread implements Runnable{
    private Demon demon;
    public DecThread(Demon demon){
        this.demon=demon;
    }
    public void run() {
        for(int i=0;i<30;i++) {
            demon.dec();
        }
    }
}
//测试类
public class test {
    public static void main(String[] args) throws InterruptedException {
        Demon demon=new Demon();
        Thread t1=new Thread(new IncThread(demon));
        Thread t2=new Thread(new IncThread(demon));
        Thread t3=new Thread(new DecThread(demon));
        Thread t4=new Thread(new DecThread(demon));
        t1.start();
        t2.start();
        t3.start();
        t4.start();
    }
}
-->