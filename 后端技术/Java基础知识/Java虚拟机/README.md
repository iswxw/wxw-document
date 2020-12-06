## Java 虚拟机

线上故障主要会包括cpu、磁盘、内存以及网络问题，而大多数故障可能会包含不止一个层面的问题，所以进行排查时候尽量四个方面依次排查一遍。同时例如jstack、jmap等工具也是不囿于一个方面的问题的，基本上出问题就是df、free、top 三连，然后依次jstack、jmap伺候，具体问题具体分析即可。

- 官网工具地址：<https://docs.oracle.com/javase/8/docs/technotes/tools/> 

![img](assets/20201017150614753.png) 

## 故障排除工具

### 堆内存分析工具

内存问题排查起来相对比CPU麻烦一些，场景也比较多。主要包括OOM、GC问题和堆外内存。一般来讲，我们会先用`free`命令先来检查一发内存的各种情况。

- 内存问题大多还都是堆内内存问题。表象上主要分为OOM和StackOverflow。

#### _OOM

#### _**Stack Overflow** 

**分析过程** ：

1. 关于OOM和StackOverflow的代码排查方面，我们一般使用JMAP`jmap -dump:format=b,file=filename pid`来导出dump文件  
2. 通过mat(Eclipse Memory Analysis Tools)导入dump文件进行分析，内存泄漏问题一般我们直接选Leak Suspects即可，mat给出了内存泄漏的建议。另外也可以选择Top Consumers来查看最大对象报告。和线程相关的问题可以选择thread overview进行分析。除此之外就是选择Histogram类概览来自己慢慢分析，大家可以搜搜mat的相关教程。



- mat
- jmap

> **堆内存OOM分析案例** 

1. [排查堆内存溢出](https://mp.weixin.qq.com/s/7XGD-Z3wrThv5HyoK3B8AQ) 

### 栈内存分析工具

#### _使用jstack分析cpu问题

**分析过程：** 

1. 先用ps命令找到对应进程的pid(如果你有好几个目标进程，可以先用top看一下哪个占用比较高) 
2. 用`top -H -p pid`来找到cpu使用率比较高的一些线程
3. 将占用最高的pid转换为16进制`printf '%x\n' pid`得到nid 
4. 直接在jstack中找到相应的堆栈信息`jstack pid |grep 'nid' -C5 –color` 
5. `cat jstack.log | grep "java.lang.Thread.State" | sort -nr | uniq -c`来对jstack的状态有一个整体的把握 

> **栈内存分析案例**

1. [**业务逻辑问题(死循环)、频繁gc**以及**上下文切换过多**](https://blog.csdn.net/qq_41893274/article/details/108901595)  
2. [CPU打到100%](https://mp.weixin.qq.com/s/roEMz-5tzBZvGxbjq8NhOQ) 

#### _频繁GC

使用**jstat -gc pid 1000**命令来对gc分代变化情况进行观察

- 1000表示采样间隔(ms)
- S0C/S1C、S0U/S1U、EC/EU、OC/OUMC/MU分别代表两个Survivor区、Eden区、老年代、元数据区的容量和使用
- YGC/YGT、FGC/FGCT、GCT则代表YoungGc、FullGc的耗时和次数以及总耗时

#### _上下文切换

- **vmstat** - 内存，进程和分页等的简要信息。

-  **iostat** - CPU统计信息，设备和分区的输入/输出统计信息

  ​