### 分布式锁

- 学习资源：链接：https://pan.baidu.com/s/1z0qldoBpqG2ikxOpGWZyTQ   提取码：wwxw 

### 常见的分布式锁实现技术

#### 1.1 基于数据库实现分布式锁

- 性能较差，容易出现单点故障
- 锁没有失效时间，容易死锁

#### 1.2 基于缓存实现分布式锁

- 优点是性能很高，但实现复杂（比如设置过期时间、以及过期时间判断）——redis/memcache等
- 存在死锁（或短时间死锁）的可能（执行逻辑宕机后还未到过期时间，则锁得不到释放）

#### 1.3 基于Zookeeper实现分布式锁

- 实现相对简单
- 可靠性高
- 性能较好

### 由来演进

#### 1.1 模拟并发场景

示例代码：订单服务————>订单编号生成类 并发测试

```java
public class ConcurrentTestDemo {

    // 模拟并发无法保证 订单号的唯一性
    public static void main(String[] args) {
        int currency = 20;
        CyclicBarrier cb = new CyclicBarrier(currency);
        CountDownLatch cdl = new CountDownLatch(currency); // 倒计数锁存器

        OrderService orderService = new OrderServiceImpl();
        OrderService orderServiceLock = new OrderServiceImplWithLock();

        // 多线程模拟高并发
        for (int i = 0; i < currency; i++) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    System.out.println(Thread.currentThread().getName() + "：我准备好");
                    // 等待一起出发
                    try {
                        // 方式一
                        cb.await();
                        // 方式二
//                        cdl.countDown();
//                        cdl.await();
                    } catch (InterruptedException | BrokenBarrierException e) {
                        e.printStackTrace();
                    }
                    // 调用创建订单服务
                    orderService.createOrder();
//                    orderServiceLock.createOrder();
                }
            }).start();
        }
    }
}
```

#### 1.2 模拟分布式并发场景

示例代码：模拟分布式集群 并发测试

```java
public class ConcurrentTestDistributeDemo {

    public static void main(String[] args) {
        // 并发数
        int currency = 20;
        CyclicBarrier cb = new CyclicBarrier(currency);   // 循环屏障
        CountDownLatch cdl = new CountDownLatch(currency); // 倒计数锁存器

        OrderService orderService = new OrderServiceImpl();
//        OrderService orderServiceLock = new OrderServiceImplWithLock();

        // 多线程模拟高并发
        for (int i = 0; i < currency; i++) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    //模拟分布式集群场景
                    OrderService orderServiceLock = new OrderServiceImplWithLock();
                    System.out.println(Thread.currentThread().getName() + "：我准备好");
                    // 等待一起出发
                    try {
                        // 方式一
                        cb.await();
                        // 方式二
//                        cdl.countDown();
//                        cdl.await();
                    } catch (InterruptedException | BrokenBarrierException e) {
                        e.printStackTrace();
                    }
                    // 调用创建订单服务
//                    orderService.createOrder();
                    orderServiceLock.createOrder();
                }
            }).start();
        }
    }
}
```

**完整源码**： [Github快速访问](https://github.com/GitHubWxw/Java-concurrent/tree/master/cloud-concurrent-redis/src/main/java/com/wxw/common/distributed_lock) 

### 基于Redis实现分布式锁



### 基于Zookeeper实现分布式锁