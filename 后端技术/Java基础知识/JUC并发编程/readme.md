## Java 并发编程之美   <!-- {docsify-ignore} --> 



## 并发编程基础

### 1.1 共享变量的内存可见性问题

**学习目标** 

1. 掌握并发中变量可见性问题
2. 掌握造成线程安全、变量可见性问题的原因
3. 掌握volatile关键字的用途、原理和使用场景

学习地址：[CSDN 大树老师](https://live.csdn.net/room/weixin_48013460/7nnPbJQ2) 

#### （1）并发中变量可见性问题

##### 1.1.1 问题思考？

> 问题1：变量分为哪几类？

 ![](https://gitee.com/wwxw/image/raw/master/document/并发编程/yIV!my8MTdFg.png) 

> 问题2：如何在多个线程之间共享数据？

用全局变量：静态变量或共享对象 实现

> 问题3：一个变量在线程1中被改变值了，在线程2中能看到该变量的最新值吗？



> **案例分析**

代码逻辑：通过共享变量，在一个线程中控制另外一个线程的执行流程，

案例代码如下：

```java
 public class VisibilityDemo {
    // 状态标识
    private static boolean is = true;
    public static void main(String[] args) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                int i = 0;
                while (VisibilityDemo.is) {
//                    synchronized (this) { i++; }
                i++;
                }
                // 问题1：线程会停止循环打印i吗
                System.out.println("i = " + i);
            }
        }, "加加操作").start();
        // 等2秒
        try { TimeUnit.SECONDS.sleep(2); } catch (InterruptedException e) { e.printStackTrace(); }
        VisibilityDemo.is = false; // 设置is为false,使上面while停止循环
        System.out.println("is被设置为false了.");
    }
}
```

运行结果：

![](https://gitee.com/wwxw/image/raw/master/document/并发编程/jJHGRkpmXbj9.png) 

程序并没有从while循环中出来打印 i 的值，并且 状态值 is 改变后，线程"加加操作" 并没有发现 is 状态值已经变了

##### 1.1.2 什么是并发中的变量可见性问题

并发的线程能不能看到变量的最新值，这就是并发中的变量可见性问题

> 思考

1. 为什么不可见？
2. 怎么样才能可见？

> 方式一：synchronized  关键词

```java
 while (VisibilityDemo.is) {
    synchronized (this) { i++; }  // i = 67221967
         // i++;
   }            
```

运行结果：

```scss
is被设置为false了.
i = 67221967

Process finished with exit code 0
```

> 方式二：volatile 关键词

```java
    // 状态标识
    // private static  boolean is = true;
    private static volatile boolean is = true;
```

运行结果：

```java
is被设置为false了.
i = -1422341435

Process finished with exit code 0
```

#### （2）变量可见性和线程安全问题原因

##### 1.2.1 Java 内存模型

- Java 内存模型及操作规范

  1. 共享变量必须存放于主内存中
  2. 线程有自己的工作内存，线程只可操作自己的工作内存
  3. 线程要操作共享变量，需要从主内存中读取到工作内存，改变值后需要从工作内存同步到主内存

  ![](https://gitee.com/wwxw/image/raw/master/document/并发编程/v) 

> Java 内存模型会带来什么问题？——线程安全问题

- 有变量A，多线程并发对其累加会有什么问题？如三个线程并发操作变量A，大家读取A时都读到A=0，都对A+1，再将值同步回主内存。结果是多少？（答案是：1）

- **线程安全问题**是由 JMM **内存模型**导致
- **变量内存可见性问题**也是由JMM **内存模型**导致 

> 那如何解决线程安全问题呢？

1. 加锁 synchronized / lock / volatile 
2. 使用final修饰

> 如何让线程2使用A值时看到最新值？

- 线程1修改A后立即同步回主内存
- 线程2使用A前需要把A重新从主内存读取到工作内存

> 疑问1：使用前不会重新从主内存读取到工作内存吗？

> 疑问2：修改后不会立马同步回主内存吗？

**Java内存模型——同步交互协议——规定了8中原子性操作** 

1. **lock(锁定)** ：将主内存中的变量锁定，为一个线程所独占
2. **unlock(解锁)** ：将lock加的锁定解除，此时，其它线程就可以有机会访问此变量
3. **read(读取)** ： 作用于主内存变量，将主内存中的变量值读到工作内存当中
4. **load(载入)** ：作用于工作内存变量，将read读取的值保存到工作内存中的变量副本中
5. **use(使用)** ： 作用于工作内存变量，将值传递给线程代码执行引擎
6. **assign(赋值)** ：作用于工作内存变量，将执行引擎处理返回的值，重新赋值给变量的副本
7. **store(存储)**： 作用于工作内存变量，将变量副本的值传给主内存中
8. **write(写入)**：作用于主内存变量，将store传送过来的值写入主内存的共享变量中

**Java内存模型——同步交互协议——操作规范** 

- 将一个变量从主内存复制到工作内存要顺序执行 read、load 操作
- 要将变量从工作内存同步回主内存要顺序执行store 、write 操作。只需要顺序执行，不一定是连续的
- 做了assign操作，必须同步回主内存，不能没有assign,同步回主内存

##### 1.2.2 保证可见性方法

###### （1）**synchronized 保证可见性**

> synchronized 语义规范

1. 进入同步块前，先清空工作内存中的共享变量，从主内存中重新加载
2. 解锁前必须把修改的共享变量同步回主内存

> synchronized 是如何做到线程安全的

1. 锁机制保护共享资源，只有获得锁的线程才能操作共享资源

使用案例

```java
public class ClassA {
    static int count = 0;
    // 锁对象
    public synchronized void do1(){
        count++;
    }
    // 锁类
    public static synchronized void do2(){
        count++;
    }
    // 锁对象
    public  void do3(){
       synchronized (this){
           count++;
       }
    }
    public static void main(String[] args) {
        ClassA a = new ClassA();
        a.do1();
        ClassA b = new ClassA();
        b.do1();
    }
}
```

###### （2）volatile 如何保证可见性

**Volatile 语义规范** 

1. 使用volatile 变量时，必须重新从主内存加载，并且read、load 是连续的
2. 修改 volatile 变量后，必须立马同步回主内存，并且store、write 是连续的

**volatile 能否做到线程安全** 

- 不能，因为它没有锁机制，线程可并发操作共享资源

###### （3）为什么要使用 volatile

**synchronized可以保证可见性，为什么要用volatile** ?

1. 主要原因：使用 volatile 比 synchronized 简单
2. volatile 性能比 synchronized 好

**Volatile 主要用途**

1. volatile 可用于限制局部代码的指令重排  [单例模式DCL原因](https://www.cnblogs.com/2019wxw/p/11710289.html) 

   new Singleton()分为三步1、分配内存空间，2、初始化对象，3、设置instance指向被分配的地址。然而指令的重新排序，可能优化指令为1、3、2的顺序。如果是单个线程访问，不会有任何问题。但是如果两个线程同时获取getInstance，其中一个线程执行完1和3步骤，此时其他的线程可以获取到instance的地址，在进行if(instance==null)时，判断出来的结果为false，**导致其他线程直接获取到了一个未进行初始化的instance**，这可能导致程序的出错。**所以用volatile修饰instance，禁止指令的重排序，保证程序能正常运行**。（Bug很难出现，没能模拟出来）。

2. volatile 只可修饰成员变量（静态和非静态的），局部变量不可修饰（因为不可被共享）

































































































































