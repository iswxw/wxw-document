### 基础知识



### Java

#### Java 基础



#### Java 集合

1. linkList 和arrayList、vector的区别
2. hashmap的数据结构
3. concurrentHashMap

#### Java 并发编程

1. Synchronized和Lock的区别

2. 并发与并行的区别  [小提示](https://blog.csdn.net/java_zero2one/article/details/51477791) 

   - 并发是指一个处理器同时处理多个任务。 
   - 并行是指多个处理器或者是多核的处理器同时处理多个不同的任务。 

   并发是逻辑上的同时发生（simultaneous），而并行是物理上的同时发生

#### Java 虚拟机

1. JVM垃圾回收机制，何时触发MinorGC等操作
2. 老年代回收会**STW**，什么时候会STW?
3. **G1**的回收机制？
4. ​

### MySQL

1. 数据库的事务？
2. 数据库隔离级别？
3. MySQL的 delete from t1 limit 3和delete from t1的区别？ [小提示](https://blog.csdn.net/wjxbj/article/details/84809186)  



### 网络编程

1. time_wait在哪一端产生，作用是什么 ， [小提示1](https://blog.csdn.net/u013616945/article/details/77510925)  [小提示2](https://yuerblog.cc/2020/03/09/%E5%85%B3%E4%BA%8Etime_wait%E9%97%AE%E9%A2%98%E7%AE%80%E8%BF%B0%E4%B8%8E%E4%BC%98%E5%8C%96/) 
2. ​


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

**相关文章** 

1. [海量数据处理算法策略——1](https://blog.csdn.net/java_zero2one/article/details/51477791) 