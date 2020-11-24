## Java 8 阅读手册



## java.util.concurrent

### 1. locks

#### 1.1 ReentrantLock

##### 前言

Java中的大部分同步类（Lock、Semaphore、ReentrantLock等）都是基于AbstractQueuedSynchronizer（简称为AQS）实现的。在Java5.0之前，在协调对共享对象的访问时可以使用的机制只有synchronized和volatile。Java5.0增加了一种新的机制：ReentrantLock。ReentrantLock并不是一种替代内置加锁的方法，而是作为一种可选择的高级功能。ReentrantLock实现了Lock接口，提供了一种无条件的、可轮询的、定时的以及可中断的锁获取操作，所有加锁和解锁方法都是显式的。

我们基本不会直接使用AQS，AQS是一个构建锁和同步器的框架，许多同步器都可以通过AQS很容易高效的构造出来，基本能够满足绝大多数情况的需求。不仅ReentrantLock，Semaphore、CountDownLatch、ReentrantReadWriteLock、FutureTask也是基于AQS构建的。AQS解决了实现同步器的大量细节，等待线程采用FIFO队列操作顺序；还负责管理同步器类中的状态 ，可以通过getState,setState以及compareAndSetState方法来操作。

##### 文档导读

- ReentrantLock继承树及重要方法
- 非公平锁及公平锁的获取
- tryLock()，lockInterruptibly()
- 释放资源
- ReentrantLock相关面试题
- 总结

##### Reentrantlock 使用实例

```java
public class ReentrantLock01 {
    // ReentrantLock
    public static ReentrantLock reentrantLock = new ReentrantLock();
    public static int count = 0;

    public static void main(String[] args) {
        ReentrantLock01 lock = new ReentrantLock01();
        lock.run();
        System.out.println("计算结果 = " + count);
    }
    public void run() {
        // 加锁
        reentrantLock.lock();
        try {
            for (int i = 0; i < 1000; i++) {
                count++;
            }
        } finally {
            reentrantLock.unlock();
        }
    }
}
```

以上代码通过lock来实现 count++的原子操作

-  reentrantLock.lock() 用来获取锁
-  reentrantLock.unlock()用来释放锁。

那么多线程下，如何保证同步操作？如何释放锁？如何判断没有竞争到锁的线程处于等待状态？什么时候唤醒等待线程？

##### ReentrantLock继承关系概述

（1）**继承关系概述** 

首先看一下继承关系图，对它整体的构造有一个初步的认识。

![1606188717559](assets/1606188717559.png) ![1606188740989](assets/1606188740989.png) 

我们发现，ReenTrantLock实现了公平锁和非公平锁，都通过它们的父类 Sync 调度

- **Sync**：是提供AQS实现的工具，类似于适配器，提供了抽象的lock()，便于快速创建非公平锁。
- **FairSync**(公平锁)：线程获取锁的顺序和调用lock()的顺序一样，FIFO。
- **NoFairSync**(非公平锁)：线程获取锁的顺序和调用lock()的顺序无关，抢到CPU的时间片即可调度。

##### ReentrantLock 重要方法

**（1）构造方法**

- 无参构造方法，默认创建非公平锁
- 有参构造方法，当 fair==true时，创建公平锁。

```java
    //维护了一个Sync，对于锁的操作都交给sync来处理
    private final Sync sync;
    public ReentrantLock() { sync = new NonfairSync();}
    public ReentrantLock(boolean fair) {  sync = fair ? new FairSync() : new NonfairSync(); }
```

**（2）获取锁方法：可以看出请求都是交给 Sync 来调度的**

```java
    //请求锁资源，会阻塞且 不处理中断请求，
    //没有调用unLock()，则会一直被阻塞。
    public void lock() {  sync.lock();}
    
    //线程在请求lock并被阻塞时，如果被interrupt，则此线程会被唤醒并被要求处理, 加锁的同时处理中断请求
    public void lockInterruptibly() throws InterruptedException { sync.acquireInterruptibly(1);}
    
    //尝试获取锁，默认获取的是非公平锁，失败后不会阻塞
    //直接返回true或false
    public boolean tryLock() {  return sync.nonfairTryAcquire(1);}
   
    //重载方法，在规定时间内获取锁，获取不到则返回false
    public boolean tryLock(long timeout, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireNanos(1, unit.toNanos(timeout));
    }
```

**（3）释放锁方法：** 不管是公平还是非公平锁，都会调用AQS.release(1)，给当前线程持有锁的数量-1。

```java
  // 如果是当前线程持有锁，就将持有锁的数量减一，直到持有锁的数量为零时，释放锁
  public void unlock() { sync.release(1); }
```

##### ReentrantLock 深入理解

我们主要看非公平锁与公平锁获取资源的方法，因为释放资源的逻辑是一样的。

**（1）Sync 获取锁**

sync中定义了获取锁的总入口，具体的调用还是看实现类是什么。

```java
abstract void lock();
```

**（2）公平锁获取资源** 

> 与非公平锁的区别是：不能直接通过CAS修改state，而是直接走AQS的 acquire()方法

lock()：是**阻塞的** ，队列中没有锁资源占用时，才进行获取锁，根据判断状态 state值

- 如果state = 0 表示还未持有锁，则set为1表示获取锁成功，并把当前线程设置为锁的持有者；
- 如果state > 0,并且是当前线程占有，则 state+1，表示重入锁
- 如果获取失败，则尝试 通过AQS.acquire() 获取锁，了解到acquire()中使用了模板模式，调用子类的tryAcquire()尝试获取锁，如果tryAcquire()返回false，则进入等待队列自旋获取，再判断前驱的waitStatus，判断是否需要被阻塞等

```java
   abstract boolean initialTryLock();

   // lock() 获取公平锁资源
   @ReservedStackAccess
   final void lock() { 
        if (!initialTryLock())
            // AQS的 acquire() 方法获取
             acquire(1);
      }
    // 公平锁 如果当前有线程在占用 则直接CAS获取或者 设置可重入
    final boolean initialTryLock() {
            Thread current = Thread.currentThread();
            // state = 0 表示当没有锁占用
            int c = getState(); 
            if (c == 0) {
                if (!hasQueuedThreads() && compareAndSetState(0, 1)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
                // 实现可重入
            } else if (getExclusiveOwnerThread() == current) {
                if (++c < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(c);
                return true;
            }
            return false;
        }
```

acquire()——>tryAcquire() : 首次等待或者没有线程占用时才会获取到锁

> tryAquire()：与非公平锁类似，AQS.acquire()会调用这个钩子方法。只不过多判断了hasQueuedPredecessors()

- **hasQueuedPredecessors()**：判断当前节点在等待队列中是否有前驱节点，
  - 如果有，则说明有线程比当前线程更早的请求资源，根据公平性，当前线程请求资源失败；
  - 如果当前节点没有前驱节点，才有做后面的逻辑判断的必要性。

```java
 public final void acquire(int arg) {
        if (!tryAcquire(arg))
            acquire(null, arg, false, false, false, 0L);
    }

 protected final boolean tryAcquire(int acquires) {
       //判断等待队列中是否有前驱节点，没有则尝试获取锁
       //hasQueuedPredecessors()返回false，表示没有前驱节点，当前线程就是头节点
        if (getState() == 0 && !hasQueuedPredecessors() &&
                compareAndSetState(0, acquires)) {
                setExclusiveOwnerThread(Thread.currentThread());
                return true;
          }
        return false;
     }
```

**（3）非公平锁获取资源** 

对应公平锁：非公平锁会首先使用CAS 尝试设置状态值，抢占锁

```java
    // jdk 14 部分 已经优化了jdk8 
    final boolean initialTryLock() {
            Thread current = Thread.currentThread();
            // 首先尝试使用CAS 尝试获取锁
            if (compareAndSetState(0, 1)) { // first attempt is unguarded
                setExclusiveOwnerThread(current);
                return true;
                // 设置可重入
            } else if (getExclusiveOwnerThread() == current) {
                int c = getState() + 1;
                if (c < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(c);
                return true;
            } else
                return false;
        }
```

tryAcquire()：走的是Sync.nofairTryAcquire()。

```java
  // jdk8中非公平锁 
  final void lock() {
       if (compareAndSetState(0, 1))
             setExclusiveOwnerThread(Thread.currentThread());
          else
             acquire(1);
       } 

  protected final boolean tryAcquire(int acquires) {
            return nonfairTryAcquire(acquires);
    }
```

nonfairTryAcquire(int acquires)：如果锁空闲，则用CAS修改state；如果锁被占用，则判断占有者是不是自己，实现可重入。最终没有获取锁到就返回false。

```java
  final boolean nonfairTryAcquire(int acquires) {
            // 获取当前线程
            final Thread current = Thread.currentThread();
            // 获取state的变量值
            int c = getState();
            if (c == 0) { //没有线程占用锁
                if (compareAndSetState(0, acquires)) {
                    //占用锁成功,设置独占线程为当前线程
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) { //当前线程已经占用该锁
                int nextc = c + acquires;
                if (nextc < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                // 更新state值为新的重入次数
                setState(nextc);
                return true;
            }
            return false;
        }
```

##### 其他获取锁的方法

ReentrantLock有3中获取锁的方法，lock()，tryLock()，lockInterruptibly()。

（1） **tryLock()--尝试获取资源** 

tryLock()：走的还是sync的方法，在指定时间内获取锁，直接返回结果。

```java
  public boolean tryLock(long timeout, TimeUnit unit)
            throws InterruptedException {
        return sync.tryAcquireNanos(1, unit.toNanos(timeout));
    }
```

tryAcquireNanos()：如果调用tryLock的规定时间内尝试方法，就会调用该方法，先判断是否中断，然后尝试获取资源，否则进入AQS.doAcquireNanos()（这个方法在上篇文章有解释）。在规定时间内自旋拿资源，拿不到则挂起再判断是否被中断。

```java
  public final boolean tryAcquireNanos(int arg, long nanosTimeout)
        throws InterruptedException {
        if (!Thread.interrupted()) {
            if (tryAcquire(arg))
                return true;
            if (nanosTimeout <= 0L)
                return false;
            int stat = acquire(null, arg, false, true, true,
                               System.nanoTime() + nanosTimeout);
            if (stat > 0)
                return true;
            if (stat == 0)
                return false;
        }
        throw new InterruptedException();
    }
```

（2） **lockInterruptibly()--获取锁时响应中断** 

lockInterruptibly()：交给了调度者sync执行。

```java
   public void lockInterruptibly() throws InterruptedException {
        sync.lockInterruptibly();
    }
```

lockInterruptibly()：当尝试获取锁失败后，就进行**阻塞可中断**的获取锁的过程。调用AQS.doAcquireInterruptibly()

```java
     final void lockInterruptibly() throws InterruptedException {
            if (Thread.interrupted())
                throw new InterruptedException();
            if (!initialTryLock())
                acquireInterruptibly(1);
      }
```

（4）释放锁

公平锁与非公平锁的释放都是一样的。通过前面的阅读，可以知道，ReentrantLock.release()调用的是sync.release(1)。本质还是进入AQS.release(1)，下面看看其中的tryRelease()这个钩子方法如何实现。

**Sync释放资源** tryRelease()：尝试释放锁，彻底释放后返回true。

```java
        public final boolean release(int arg) {
            // sysc 释放锁
            if (tryRelease(arg)) {
                // 设置后继节点
                signalNext(head);
                return true;
            }
            return false;
        }

        // sync 中释放锁
        // 释放当前线程占用的锁
        protected final boolean tryRelease(int releases) {
            int c = getState() - releases; // 计算释放后state的值
            // 如果不是当前线程占用锁，抛出异常
            if (Thread.currentThread() != getExclusiveOwnerThread())
                throw new IllegalMonitorStateException();
            boolean free = false;
            if (c == 0) {
                // 锁被重入次数为0，表示释放锁成功
                free = true;
                // 清空独占线程
                setExclusiveOwnerThread(null);
            }
            // 跟新state值
            setState(c);
            return free;
        }

```

##### ReentrantLock 相关问题

**（1）ReentrantLock是如何实现可重入的？**

不管是公平锁还是非公平锁，在获取锁时调用的tryAcquire()方法，获取成功后会setExclusiveOwnerThread(current)。将本线程设置为主人，之后每次调用tryAcquire()时，发现当前线程就是主人，直接返回true。

**（2）简述公平锁与非公平锁的区别？**

- 从定义角度：
  获取锁的顺序与请求锁的时间顺序一致就是公平锁，反之则为非公平锁。公平锁每次都是从同步队列中的第一个节点获取到锁，而非公平性锁则不一定，有可能刚释放锁的线程能再次获取到锁。
  公平锁为了保证时间上的绝对顺序，需要频繁的上下文切换，而非公平锁会降低一定的上下文切换，降低性能开销。因此，ReentrantLock默认选择的是非公平锁，则是为了减少一部分上下文切换，保证了系统更大的吞吐量。
- 从源码角度：
  当锁资源已经被占用时，请求每次有请求到达，就在等待队列中排队。此时如果锁资源被释放了，刚好新来一个线程，若是非公平锁则会直接CAS获取锁，成功则返回，不成功则加入到等待队列自旋获取，自旋过程中当前驱是对头，并且tryAcquire成功时则获取成功。
  若是公平锁，则当前线程必须等待，锁必须给等待队列第一个线程，如果第一个线程被阻塞了，唤醒也是需要时间的，醒了才能拿锁。

**（3）AQS中有哪些资源访问模式？区别？**

- 独占模式和共享模式。只有一个线程才能持有这个锁就是独占模式，由Node节点中的nextWait来标识。
- ReentrantLock就是一个独占锁；而WriteAndReadLock的读锁则能由多个线程同时获取，但它的写锁则只能由一个线程持有，因此它使用了两种模式。

**（4）为什么ReentrantLock.lock()方法不能被其他线程中断？**

因为当前线程前面可能还有等待线程，在AQS.acquireQueued()的循环里，线程会再次被阻塞。parkAndCheckInterrupt()返回的是Thread.interrupted()，不仅返回中断状态，还会清除中断状态，保证阻塞线程忽略中断。



**相关文章：**

1. [Java并发包中锁原理剖析](https://blog.csdn.net/qq_41893274/article/details/105554149) 
2. [从ReentrantLock的实现看AQS的原理及应用](https://tech.meituan.com/2019/12/05/aqs-theory-and-apply.html) —美团技术团队
3. [不可不说的Java“锁”事](https://tech.meituan.com/2018/11/15/java-lock.html) —美团技术团队
4. [ReentrantLock](https://zhuanlan.zhihu.com/p/65727594)  

### 2. atomic

#### 2.1 AtomicInteger