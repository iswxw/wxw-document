### 每天一个知识点



### Java基础

1. 双亲委派模型的过程以及优势

2. Java 类加载过程

3. [一个ArrayList在循环过程中删除，会不会出问题，为什么？](https://www.cnblogs.com/hunrry/p/9183172.html) 

   > 顺序遍历或for-each 遍历都会检查modCount值 影响后续遍历

   - 倒序删除
   - 迭代器删除 

4. [Java：传值还是传引用？](https://www.cnblogs.com/hunrry/p/9183145.html) 

   - Java 的参数参数传递都是**值传递** 


### 并发编程

1. volatile和synchronized原理
2. volatile用在什么场景？答了个单例模式；
3. ThreadLocal原理
4. HashMap，ConcurrentHashMap
5. 分析线程池的实现原理和线程的调度过程
6. Synchronized和Lock的区别

### JVM

- dump文件的分析
- 常用的JVM调优参数
- JVM垃圾回收机制，何时触发MinorGC等操作
- Eden和Sur[vivo](https://www.nowcoder.com/jump/super-jump/word?word=vivo)r的比例分配等【Eden区和Survivor区的比例是8：1：1】
- JVM 对 final 关键字的编译优化
- [为了保证对象的内存分配过程中的线程安全性，HotSpot虚拟机提供了一种叫做TLAB(Thread Local Allocation Buffer)的技术](https://mp.weixin.qq.com/s/Wws24Fhg1nH4dHvtcFYi2g) 

### Spring

1. [Spring中使用了哪些设计模式](https://www.cnblogs.com/kyoner/p/10949246.html)   

   - **工厂模式**：Spring使用工厂模式可以通过 `BeanFactory` 或 `ApplicationContext` 创建 bean 对象

   - **单例模式** ：Spring中bean的默认作用域就是singleton(单例)的，除了singleton作用域，Spring中bean还有下面几种作用域：prototype、request、session、global-session等

   - **代理模式** ：Spring AOP（事务处理、日志管理、权限控制）就是基于动态代理的，如果要代理的对象实现了某个接口，那么Spring AOP会使用JDK Proxy，去创建代理对象，而对于没有实现接口的对象，Spring AOP会使用Cglib，这时候Spring AOP会使用Cglib生成一个被代理对象的子类来作为代理

   - **模板方法模式：** Spring 中 `jdbcTemplate`、`hibernateTemplate` 等以 Template 结尾的对数据库操作的类

   - **适配器模式**：Spring AOP 的实现是基于代理模式，但是 Spring AOP 的增强或通知(Advice)使用到了适配器模式，与之相关的接口是`AdvisorAdapter`  ，在Spring MVC中，`DispatcherServlet` 根据请求信息调用 `HandlerMapping`，解析请求对应的 `Handler` ，解析到对应的 `Handler`（也就是我们平常说的 `Controller` 控制器）后，开始由`HandlerAdapter` 适配器处理。`HandlerAdapter` 作为期望接口，具体的适配器实现类用于对目标类进行适配，`Controller` 作为需要适配的类。

   - **装饰者模式：** 装饰者模式可以动态地给对象添加一些额外的属性或行为。相比于使用继承，装饰者模式更加灵活。简单点儿说就是当我们需要修改原有的功能，但我们又不愿直接去修改原有的代码时，设计一个Decorator套在原有代码外面。

     1. 在 JDK 中就有很多地方用到了装饰者模式，比如 `InputStream`家族，`InputStream` 类下有 `FileInputStream` (读取文件)、`BufferedInputStream` (增加缓存,使读取文件速度大大提升)等子类都在不修改`InputStream` 代码的情况下扩展了它的功能


     2.  我们的项目需要连接多个数据库，而且不同的客户在每次访问中根据需要会去访问不同的数据库。这种模式让我们可以根据客户的需求能够动态切换不同的数据源。Spring 中用到的包装器模式在类名上含有 `Wrapper`或者 `Decorator`。这些类基本上都是动态地给一个对象添加一些额外的职责

   - **观察者模式**：Spring **事件驱动模型**就是观察者模式

     事件流程：

     1. 定义一个事件: 实现一个继承自 `ApplicationEvent`，并且写相应的构造函数；
     2. 定义一个事件监听者：实现 `ApplicationListener` 接口，重写 `onApplicationEvent()` 方法；
     3. 使用事件发布者发布消息: 可以通过 `ApplicationEventPublisher` 的 `publishEvent()` 方法发布消息。 

2. 动态代理[jdk、cglib] 

3. Spring AOP与IOC的实现

4. [@transactional注解在什么情况下会失效，为什么。](https://www.cnblogs.com/hunrry/p/9183209.html) 
   - 检查你方法是不是public的
   - 你的异常类型是不是unchecked异常 
   - 如果我想check异常也想回滚怎么办，注解上面写明异常类型即可 @Transactional(rollbackFor=Exception.class) 

5. 



### MySQL

1. MySQL InnoDB存储的文件结构 
  
- [MYSQL INNODB数据存储结构](https://blog.csdn.net/bohu83/article/details/81086474) 
  
2. 索引树是如何维护的？

3. [如何合理的配置数据库连接池大小？](https://blog.csdn.net/qq_41893274/article/details/108167823) 

3. 数据库自增主键可能的问题 

   (1) 自增id用完之后插入数据会报主键冲突。[mysql 自增id作为主键 策略](https://www.jianshu.com/p/f20ad8c34595)  

   (2) 在一张表分布到多个数据库的情况下，使用表自增将会出现id重复的问题 

   - [小总结](https://blog.csdn.net/riemann_/article/details/94321174)   

4. 为什么Mysql用B+树做索引而不用B-树或红黑树？【[阅读1](http://www.coder55.com/question/139)】

5. 给定 student_score 中 name， subject ，score ，查挂了两门课程以上学生的个数

   ```mysql
    select studentid from student_score where score < 60 group by studentid having count(*)>1 
    select studentid from (select studentid from student_score where score<60) where count(*) >1
   ```

   ​


### MyBatis



### Redis

1. Redis 对象类型，底层数据结构
2. 如何解决redis的并发竞争key问题   [cblogs](https://www.cnblogs.com/2019wxw/p/11700562.html) 
3. **如何应对缓存穿透 【不存在的key】和缓存雪崩问题**  
4. **redis和数据库双写一致性问题** 
   - 延迟双删策略
   - 设定过期时间（一致性要求不是很高的情况下）
5. [bitmap-如何判断某个整数是否存在40亿个整数中？](https://www.cnblogs.com/kyoner/p/11129477.html)  （**bitmap算法, **就是**用位来代表一个数字，每一位的0或1来表示整数的两种状态**，从而大大节省了内存空间）
6. [布隆过滤器 - 如何在100个亿URL中快速判断某URL是否存在？](https://www.cnblogs.com/kyoner/p/11109536.html) 

### Dubbo/Zookpeer

1. RPC底层原理
2. Dubbo的底层实现原理和机制 



### 网络编程

1. OSI七层模型与TCP/IP 五层模型
2. TCP与UDP区别和应用场景，基于TCP的协议有哪些，基于UDP的有哪些
3. TCP三次握手过程以及每次握手后的状态改变，为什么三次？ 为什么两次不行？
4. 没有用过异步I/O，说一下select、poll、epoll的区别

### 操作系统

1. 进程和线程的区别
2. 进程间通信方式IPC 
   - 管道 (使用最简单)
   - 信号 (开销最小)
   - 共享映射区 (无血缘关系)
   - 本地套接字 (最稳定)
3. 死锁条件，解决方式。
   - ​

### Maven

1. Maven出现版本冲突如何解决 ？
   - **第一声明者优先原则：**在pom文件定义依赖，先声明的依赖为准。
   - **路径近者优先原则：** 
   - **排除原则** 
   - **版本锁定** 

### 分布式

2. **缓存**：缓存的目的是提升系统访问速度和增大系统处理容量
3. **限流**：限流的目的是通过对并发访问/请求进行限速，或者对一个时间窗口内的请求进行限速来保护系统，一旦达到限制速率则可以拒绝服务、排队或等待、降级等处理
4. ​

### 服务治理

1. 接口幂等性
2. 负载均衡
   - [Nginx 负载均衡](https://www.cnblogs.com/lcword/p/12513155.html) 
3. 一致性hash算法

### 微服务

1. [服务描述](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%8F%8F%E8%BF%B0)   <https://blog.csdn.net/haponchang/article/details/90746408> 
2. [注册中心](https://blog.csdn.net/haponchang/article/details/93488503#%E6%B3%A8%E5%86%8C%E4%B8%AD%E5%BF%83)   <https://blog.csdn.net/haponchang/article/details/93467008> 
3. [服务框架](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%A1%86%E6%9E%B6)   <https://blog.csdn.net/haponchang/article/details/93468031>  
4. [服务监控](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E7%9B%91%E6%8E%A7)   <https://blog.csdn.net/haponchang/article/details/93469050  
5. [服务追踪](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E8%BF%BD%E8%B8%AA)   <https://blog.csdn.net/haponchang/article/details/93486963> 
6. [服务治理](https://blog.csdn.net/haponchang/article/details/93488503#%E6%9C%8D%E5%8A%A1%E6%B2%BB%E7%90%86)   <https://blog.csdn.net/haponchang/article/details/93488503> 

### 算法

1. 找出数组中不重复的元素   
   - O(n) hashset 丢弃
   - 位运算异或
2. NC127 [最长公共子串](https://www.nowcoder.com/jump/super-jump/word?word=%E6%9C%80%E9%95%BF%E5%85%AC%E5%85%B1%E5%AD%90%E4%B8%B2) 
3. [二叉树右视图](https://www.nowcoder.com/jump/super-jump/practice?questionId=1073834) 

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