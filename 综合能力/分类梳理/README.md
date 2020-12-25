### 每天一个知识点



### Java

1. HashMap，ConcurrentHashMap；
2. Synchronized和Lock的区别
3. 分析线程池的实现原理和线程的调度过程



### 并发编程

1. volatile和synchronized原理
2. volatile用在什么场景？答了个单例模式；

### JVM

- JVM垃圾回收机制，何时触发MinorGC等操作
- Eden和Sur[vivo](https://www.nowcoder.com/jump/super-jump/word?word=vivo)r的比例分配等【Eden区和Survivor区的比例是8：1：1】
- JVM 对 final 关键字的编译优化
- [为了保证对象的内存分配过程中的线程安全性，HotSpot虚拟机提供了一种叫做TLAB(Thread Local Allocation Buffer)的技术](https://mp.weixin.qq.com/s/Wws24Fhg1nH4dHvtcFYi2g) 

### Spring

1. 动态代理[jdk、cglib] 
2. Spring AOP与IOC的实现



### MySQL

1. MySQL InnoDB存储的文件结构 
   
- [MYSQL INNODB数据存储结构](https://blog.csdn.net/bohu83/article/details/81086474) 
   
2. 索引树是如何维护的？

3. 数据库自增主键可能的问题 

   (1) 自增id用完之后插入数据会报主键冲突。[mysql 自增id作为主键 策略](https://www.jianshu.com/p/f20ad8c34595)  

   (2) 在一张表分布到多个数据库的情况下，使用表自增将会出现id重复的问题 

   - [小总结](https://blog.csdn.net/riemann_/article/details/94321174)   

4. 为什么Mysql用B+树做索引而不用B-树或红黑树？【[阅读1](http://www.coder55.com/question/139)】

   

### MyBatis



### Redis

1. 如何解决redis的并发竞争key问题   [cblogs](https://www.cnblogs.com/2019wxw/p/11700562.html) 

2. **如何应对缓存穿透 【不存在的key】和缓存雪崩问题**  

3. **redis和数据库双写一致性问题** 

   > 采取正确更新策略，先更新数据库，再删缓存。其次，因为可能存在删除缓存失败的问题，提供一个补偿措施即可，例如利用消息队列。

4. 

### Dubbo/Zookpeer

1. RPC底层原理
2. Dubbo的底层实现原理和机制 



### 网络编程

1. TCP 三次握手，四次挥手，TCP在OSI七层模型哪一层
2. 没有用过异步I/O，说一下select、poll、epoll的区别

### Maven

1. Maven出现版本冲突如何解决 ？
   - **第一声明者优先原则：**在pom文件定义依赖，先声明的依赖为准。
   - **路径近者优先原则：** 
   - **排除原则** 
   - **版本锁定** 

### 分布式

1. 服务治理
2. **缓存**：缓存的目的是提升系统访问速度和增大系统处理容量
3. **限流**：限流的目的是通过对并发访问/请求进行限速，或者对一个时间窗口内的请求进行限速来保护系统，一旦达到限制速率则可以拒绝服务、排队或等待、降级等处理
4. 

### 服务治理

1. 接口幂等性
2. 负载均衡
   - [Nginx 负载均衡](https://www.cnblogs.com/lcword/p/12513155.html) 

### 微服务

1. [服务描述](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%8F%8F%E8%BF%B0)   <https://blog.csdn.net/haponchang/article/details/90746408> 
2. [注册中心](https://blog.csdn.net/haponchang/article/details/93488503#%E6%B3%A8%E5%86%8C%E4%B8%AD%E5%BF%83)   <https://blog.csdn.net/haponchang/article/details/93467008> 
3. [服务框架](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%A1%86%E6%9E%B6)   <https://blog.csdn.net/haponchang/article/details/93468031>  
4. [服务监控](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E7%9B%91%E6%8E%A7)   <https://blog.csdn.net/haponchang/article/details/93469050  
5. [服务追踪](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E8%BF%BD%E8%B8%AA)   <https://blog.csdn.net/haponchang/article/details/93486963> 
6. [服务治理](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%B2%BB%E7%90%86)   <https://blog.csdn.net/haponchang/article/details/93488503> 

### 算法

- 找出数组中不重复的元素  [O(n) hashset 丢弃、位运算异或]
- 


### 经验题

- [怎么排查堆内存溢出啊？](https://mp.weixin.qq.com/s/7XGD-Z3wrThv5HyoK3B8AQ) 

### 客观题

- 你如果在项目里遇到问题怎么办？

  遇到问题我先查资料，如果实在没法解决，不会拖，会及时问相关的人，即使加班，也会在规定的时间内解决。

### 经典题目

1. [JAVA 面试题 合辑（一）https://blog.csdn.net/haponchang/article/details/92741553](https://blog.csdn.net/haponchang/article/details/92741553) 
2. [JAVA 面试题 合辑（二）](https://blog.csdn.net/haponchang/article/details/92829739)<https://blog.csdn.net/haponchang/article/details/92829739> 
3. [JAVA 面试题 合辑（三）https://blog.csdn.net/haponchang/article/details/92833016](https://blog.csdn.net/haponchang/article/details/92833016) 




### 平时积累

1. [需要注意的点？](https://www.zhihu.com/question/433284877/answer/1615549774) 