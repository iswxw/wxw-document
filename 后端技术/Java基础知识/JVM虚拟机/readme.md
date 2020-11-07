## JVM 虚拟机

## 常见经典异常问题

### 1. Java heap space

#### （1）背景介绍

> 案例分析

```java
       /**
         * 创建一个插入对象为一亿，误报率为0.01%的布隆过滤器
         */
        BloomFilter<CharSequence> bloomFilter = 
                                 BloomFilter.create(Funnels.stringFunnel(Charset.forName("utf-8")), 100000000, 0.0001);
        bloomFilter.put("121");
        bloomFilter.put("122");
        bloomFilter.put("123");
        System.out.println(bloomFilter.mightContain("121"));
```

- 异常提示

```java
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
	at java.util.concurrent.atomic.AtomicLongArray.<init>(AtomicLongArray.java:81)
	at com.google.common.hash.BloomFilterStrategies$LockFreeBitArray.<init>(BloomFilterStrategies.java:158)
	at com.google.common.hash.BloomFilter.create(BloomFilter.java:429)
	at com.google.common.hash.BloomFilter.create(BloomFilter.java:405)
	at com.google.common.hash.BloomFilter.create(BloomFilter.java:379)
	at com.wxw.common.bloomfilter.BloomFilterTools.main(BloomFilterTools.java:19)
```

- 问题分析

 在 JVM 中如果98%的时间是用于 GC(Garbage Collection) 且可用的 Heap size 不足2%的时候将抛出异常信息：

` java.lang.OutOfMemoryError: Java heap space。 ` 所以产生这个异样的原因通常有两种：

1. 程序中出现了死循环
2. 程序占用内存太多，超过了 JVM 堆设置的最大值

#### （2）解决方案与分析

- 对于第一种需要根据jdk分析工具，找对应的代码分析，具体方案可以参考 [文章](https://blog.csdn.net/qq_41893274/article/details/108901595) 

- 第二种问题处理方案：我们手工扩大JVM堆的参数设置

**Jvm 堆的设置**： 是指Java程序运行过程中JVM可以调配使用的内存空间的设置

在 JVM 启动时，JVM 会自动设置 heap size 值。通常情况下，初始空间（-Xms）默认值是物理内存的1/64，最大空间是物理内存的1/4，可以利用JVM 提供的 ` -Xmn、 -Xms 、 -Xmx ` 等选项进行设置。

```xml
-Xms：初始值 
-Xmx：最大值 
-Xmn：最小值 
```

Heap Size 设置不宜太大，也不宜太小。设置太大程序的响应速度就会变慢了，因为GC占用了更多的时间，这样应用分配到的执行时间就会越少，太大也会造成空间的浪费，而且也会影响其它程序的正常运行。

- Heap Size 最大最好不要超过可用物理内存的80%，建议将 ` -Xms 和 -Xmx` 选项设置为相同，而·` -Xmn` 为 1/4的` -Xmx` 值

**设置方法如下：** 

1. 在执行Java类文件时，加上这个参数

   ```java
   java -Xms32m -Xmx800m className 
   ```

   如果是开发测试，则可以设置环境参数：` VM arguments 中输入-Xms32m -Xmx800m这个参数` 

2. 可以在windows 更改系统环境变量加上 ` JAVA_OPTS=-Xms64m -Xmx512` 

3. 如果用的tomcat则windows下的 tomcat目录下catalina.bat 文件设置 ` set JAVA_OPTS=-Xms64m -Xmx256m` 

   位置在: rem Guess CATALINA_HOME if not defined 这行的下面加合适

4. 如果是Linux系统则设置如下

   ```java
   在{tomcat_home}/bin/catalina.sh的前面，加 set JAVA_OPTS='-Xms64 -Xmx512'
   ```







































































