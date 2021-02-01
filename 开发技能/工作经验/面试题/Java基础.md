### 基础知识



### Java

#### Java 基础

1. Java线程的状态及转换  [小提示1](https://blog.csdn.net/qq_41893274/article/details/107170224) 
2. Java创建线程的方式 [小提示：三种](https://blog.csdn.net/qq_41893274/article/details/107170224) 
3. 创建线程池的方式有哪些
   - 构造函数 ThreadPoolExecute
   - Executers 工具类
   - ForkJoinPool 框架
4. 线程池的几种拒绝策略及其应用场景
5. ​

#### Java 集合

1. linkList 和arrayList、vector的区别
2. hashmap的数据结构
3. concurrentHashMap 源码
4. Java集合类常用哪些，ArrayList与LinkedList区别；HashMap底层实现，为什么扩容是2的幂次；如果想要线程安全该怎么用

#### Java 并发编程

1. Synchronized和Lock的区别

2. 并发与并行的区别  [小提示](https://blog.csdn.net/java_zero2one/article/details/51477791) 

   - 并发是指一个处理器同时处理多个任务。 
   - 并行是指多个处理器或者是多核的处理器同时处理多个不同的任务。 

   并发是逻辑上的同时发生（simultaneous），而并行是物理上的同时发生

3. JUC包下的类，能说多少说多少 

   - atomic
   - locks
   - ...

4. volitile的内存语义，底层如何实现

#### Java 虚拟机

1. JVM垃圾回收机制，何时触发MinorGC等操作
2. 老年代回收会**STW**，什么时候会STW?
3. **G1**的回收机制？
4. JVM内存模型，新生代有哪些区，作用是什么；如何判断对象是否可以被回收（1引用计数2可达性分析）
5. JVM常用垃圾回收算法，讲一下CMS原理

### MySQL

1. 数据库的事务？
2. 数据库隔离级别？
3. MySQL的 delete from t1 limit 3和delete from t1的区别？ [小提示](https://blog.csdn.net/wjxbj/article/details/84809186)  
4. MySQL的索引及区别
5. MySQL是如何优化的，数据量有多少
6. MySQL索引如何实现，为什么用B+树不用B树二叉树；聚簇索引和非聚簇索引的区别；平时索引优化如何做，最左匹配原则


### Redis

1. Redis常用数据结构；有序集合底层实现；查找排名在底层如何实现；如何用Redis实现分布式锁，可能遇到的问题和解决办法

### ElasticSearch

1. 倒排索引与正排索引的区别
2. ElasticSearch的原理(倒排索引+TF/IDF)

### Zookeeper

1. Zookeeper一般用在什么场景
2. 除了ZAB协议，在介绍几个分布式一致性协议(Paxos、Raft)
3.  Leader选举算法和流程


### 网络编程

1. time_wait在哪一端产生，作用是什么 ， [小提示1](https://blog.csdn.net/u013616945/article/details/77510925)  [小提示2](https://yuerblog.cc/2020/03/09/%E5%85%B3%E4%BA%8Etime_wait%E9%97%AE%E9%A2%98%E7%AE%80%E8%BF%B0%E4%B8%8E%E4%BC%98%E5%8C%96/) 
2. TCP3次握手过程，第三次是否可以携带数据，如何避免SYN攻击（syncookies）；
3. TCP四次挥手说一下，为什么要等待2MSL，第二次和第三次挥手是否可以合并（可以）。
4. 进程、线程和协程的区别；如果创建很多个线程会有什么问题；进程间通信方式有哪些


### Linux编程

1. linux中，想要查找日志中的某些信息，用什么命令查找？


### 微服务

1. 微服务的特点，如何实现服务发现和负载均衡



### 管理工具

1. Maven出现版本冲突如何解决 [小提示1](https://github.com/GitHubWxw/wxw-document/tree/master/%E6%9E%B6%E6%9E%84%E6%8A%80%E6%9C%AF/%E7%BC%96%E7%A0%81%E5%AE%9E%E6%88%98/Maven) 

### 设计类

1. 设计一个[算法](https://www.nowcoder.com/jump/super-jump/word?word=%E7%AE%97%E6%B3%95)，抽奖次数越多中奖概率就越高  [均匀抽奖](https://blog.csdn.net/z69183787/article/details/81430400)   



### 海量数据

- TopK问题 [小提示](https://blog.csdn.net/xushiyu1996818/article/details/106801793) 
  - 全局排序
  - 局部淘汰（冒泡、快排+二分）
  - 分治法（hash%K）
  - bitmap

### **项目相关** 

1. 项目中难点及解决办法





**相关文章** 

1. [海量数据处理算法策略——1](https://blog.csdn.net/java_zero2one/article/details/51477791) 
2. [互联网公司面试总结（Java）](https://zhuanlan.zhihu.com/p/106997736) 