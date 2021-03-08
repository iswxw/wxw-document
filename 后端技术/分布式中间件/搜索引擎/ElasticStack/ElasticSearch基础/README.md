# ElasticStack 基础文档

## Elastic Stack简介

如果你没有听说过Elastic Stack，那你一定听说过ELK，实际上ELK是三款软件的简称，分别是Elasticsearch、Logstash、Kibana组成，在发展的过程中，又有新成员Beats的加入，所以就形成了Elastic Stack。所以说，ELK是旧的称呼，Elastic Stack是新的名字。

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/KSLh6Fx3Fz@B.png) 

全系的Elastic Stack技术栈包括：

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/y19B!4LqehUt.png) 

- **Elasticsearch** 

  Elasticsearch 基于java，是个开源分布式搜索引擎，它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful风格接口，多数据源，自动搜索负载等。

- **Logstash** 

  Logstash 基于java，是一个开源的用于收集,分析和存储日志的工具。

- **Kibana** 

  Kibana 基于nodejs，也是一个开源和免费的工具，Kibana可以为 Logstash 和 ElasticSearch 提供的日志分析友好的Web 界面，可以汇总、分析和搜索重要数据日志。

- **Beats**

  Beats是elastic公司开源的一款采集系统监控数据的代理agent，是在被监控服务器上以客户端形式运行的数据收集器的统称，可以直接把数据发送给Elasticsearch或者通过Logstash发送给Elasticsearch，然后进行后续的数据分析活动。Beats由如下组成:

  - Packetbeat：是一个网络数据包分析器，用于监控、收集网络流量信息，Packetbeat嗅探服务器之间的流量，解析应用层协议，并关联到消息的处理，其支 持ICMP (v4 and v6)、DNS、HTTP、Mysql、PostgreSQL、Redis、MongoDB、Memcache等协议；
  - Filebeat：用于监控、收集服务器日志文件，其已取代 logstash forwarder；
  - Metricbeat：可定期获取外部系统的监控指标信息，其可以监控、收集 Apache、HAProxy、MongoDB
    MySQL、Nginx、PostgreSQL、Redis、System、Zookeeper等服务；

> Beats和Logstash其实都可以进行数据的采集，但是目前主流的是使用Beats进行数据采集，然后使用 Logstash进行数据的分割处理等，早期没有Beats的时候，使用的就是Logstash进行数据的采集。



**相关资料** 

- 来源Bilibili黑马程序员的视频：[Elastic Stack（ELK）从入门到实践](https://www.bilibili.com/video/BV1iJ411c7Az) 



## ElasticSearch 快速入门

### 1.1 简介

官网文档：[快速访问](https://www.elastic.co/guide/en/elasticsearch/reference/current/documents-indices.html) 

源码地址：https://github.com/elastic/elasticsearch

ElasticSearch配置：[官网配置文档](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/settings.html) 

ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTful web接口。Elasticsearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。

> 需求

我们建立一个网站或应用程序，并要添加搜索功能，但是想要完成搜索工作的创建是非常困难的。我们希望搜索解决方案要运行速度快，我们希望能有一个零配置和一个完全免费的搜索模式，我们希望能够简单地使用JSON通过HTTP来索引数据，我们希望我们的搜索服务器始终可用，我们希望能够从一台开始并扩展到数百台，我们要实时搜索，我们要简单的多租户，我们希望建立一个云的解决方案。因此我们利用Elasticsearch来解决所有这些问题及可能出现的更多其它问题。

ElasticSearch是Elastic Stack的核心，同时Elasticsearch 是一个分布式、RESTful风格的搜索和数据分析引擎，能够解决不断涌现出的各种用例。作为Elastic Stack的核心，它集中存储您的数据，帮助您发现意料之中以及意料之外的情况。

#### （1）什么是全文检索

全文搜索也叫全文检索，是指扫描文章中的每一个词，对每一个词进建立一个索引，指明该词在文章中出现的次数和位置，当前端用户输入的关键词发起查询请求后，搜索引擎就会根据事先建立的索引进行查找，并将查询的结果响应给用户。

- 两个关键字：分词和索引，

  Elasticsearch内部会完成这两件事情，对保存的文本内容按规则进行分词，并对这些分词后的词条建立索引，供用户查询。

#### （2）什么叫倒排索引

全文搜索过程根据关键词创建的索引叫倒排索引，顾名思义，建立正向关系“文本内容-关键词”叫正排索引，后续会介绍，倒排索引就是把原有关系倒过来，建立成“关键词-文本内容”的关系，这样的关系非常利于搜索。

> 举个例子：

- 文本1：I have a friend who loves smile
- 文本2：I have a dream today

先进行英文分词，再建立倒排索引，得到一份简易的“关键词-文本”的映射关系如下：

| 关键词 | 文本编号 |
| ------ | -------- |
| I      | 1,2      |
| have   | 1,2      |
| a      | 1,2      |
| friend | 1        |
| who    | 1        |
| loves  | 1        |
| smile  | 1        |
| dream  | 2        |
| today  | 2        |

有了这个映射表，搜索"have"关键词时，立即就能返回id为1,2的两条记录，搜索today时，返回id为2的记录，这样的搜索性能非常高。当然Elasticsearch维护的倒排索引包含更多的信息，此处只是作简易的原理介绍。

#### （3）Elasticsearch适用场景

常见场景

1. 搜索类场景
   常见的搜索场景比如说电商网站、招聘网站、新闻资讯类网站、各种app内的搜索。
2. 日志分析类场景
   经典的ELK组合（Elasticsearch/Logstash/Kibana），可以完成日志收集，日志存储，日志分析查询界面基本功能，目前该方案的实现很普及，大部分企业日志分析系统都是使用该方案。
3. 数据预警平台及数据分析场景
   例如电商价格预警，在支持的电商平台设置价格预警，当优惠的价格低于某个值时，触发通知消息，通知用户购买。
   数据分析常见的比如分析电商平台销售量top 10的品牌，分析博客系统、头条网站top 10关注度、评论数、访问量的内容等等。
4. 商业BI系统
   比大型零售超市，需要分析上一季度用户消费金额，年龄段，每天各时间段到店人数分布等信息，输出相应的报表数据，并预测下一季度的热卖商品，根据年龄段定向推荐适宜产品。Elasticsearch执行数据分析和挖掘，Kibana做数据可视化。

常见案例

- 维基百科、百度百科：有全文检索、高亮、搜索推荐功能
- stack overflow：有全文检索，可以根据报错关键信息，去搜索解决方法。
- github：从上千亿行代码中搜索你想要的关键代码。
- 日志分析系统：各企业内部搭建的ELK平台。

#### （4）Elasticsearch的架构图

![](https://img2018.cnblogs.com/blog/1834889/201911/1834889-20191114081634597-39521071.png)

架构各组件简单释义:

- gateway 底层存储系统，一般为文件系统，支持多种类型。
- distributed lucence directory 基于lucence的分布式框架，封装了建立倒排索引、数据存储、translog、segment等实现。
- 模块层 ES的主要模块，包含索引模块、搜索模块、映射模块。
- Discovery 集群node发现模块，用于集群node之间的通信，选举coordinate node操作，支持多种发现机制，如zen，ec2等。
- script 脚本解析模块，用来支持在查询语句中编写的脚本，如painless，groovy，python等。
- plugins 第三方插件，各种高级功能可由插件提供，支持定制。
- transport/jmx 通信模块，数据传输，底层使用netty框架
- restful/node 对外提供的访问Elasticsearch集群的接口
- x-pack elasticsearch的一个扩展包，集成安全、警告、监视、图形和报告功能，无缝接入，可插拔设计。

### 1.2 下载安装

- 官网下载地址：https://www.elastic.co/cn/downloads/elasticsearch

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/k)

选择对应版本的数据，这里我使用的是Linux来进行安装，所以就先下载好ElasticSearch的Linux安装包

#### （1）Docker方式安装

因为我们需要部署在Linux下，为了以后迁移ElasticStack环境方便，我们就使用Docker来进行部署，首先我们拉取一个带有ssh的centos docker镜像

```bash
# 拉取镜像
docker pull moxi/centos_ssh
# 制作容器
docker run --privileged -d -it -h ElasticStack --name ElasticStack -p 11122:22 -p 9200:9200 -p 5601:5601 -p 9300:9300 -v /etc/localtime:/etc/localtime:ro  moxi/centos_ssh /usr/sbin/init
```

然后直接远程连接11122端口即可

#### （2）单机版安装

 因为ElasticSearch不支持Root用户直接操作，因此我们需要创建一个elasticsearch用户

```powershell
# 添加新用户
useradd elsearch
# 创建一个soft目录，存放下载的软件
mkdir /soft
# 进入，然后通过xftp工具，将刚刚下载的文件拖动到该目录下
cd /soft
# 解压缩
tar -zxvf elasticsearch-7.9.1-linux-x86_64.tar.gz
#重命名
mv elasticsearch-7.9.1/ elsearch
```

因为刚刚我们是使用root用户操作的，所以我们还需要更改一下/soft文件夹的所属，改为elasticsearch用户

```bash
chown elsearch:elsearch /soft/ -R
```

然后在切换成elsearch用户进行操作

```bash
 # 切换用户
 su - elsearch
```

```bash
# 进入到 elsearch下的config目录
cd /soft/elsearch/config
```

然后找到下面的配置

```bash
#打开配置文件
vim elasticsearch.yml 

#设置ip地址，任意网络均可访问
network.host: 0.0.0.0 
```

在Elasticsearch中如果，network.host不是localhost或者127.0.0.1的话，就会认为是生产环境，会对环境的要求比较高，我们的测试环境不一定能够满足，一般情况下需要修改2处配置，如下：

```bash
# 修改jvm启动参数
vim conf/jvm.options

#根据自己机器情况修改
-Xms128m 
-Xmx128m
```

然后在修改第二处的配置，这个配置要求我们到宿主机器上来进行配置

```bash
# 到宿主机上打开文件
vim /etc/sysctl.conf
# 增加这样一条配置，一个进程在VMAs(虚拟内存区域)创建内存映射最大数量
vm.max_map_count=655360
# 让配置生效
sysctl -p
```

> **启动ElasticSearch**

首先我们需要切换到 elsearch用户

```bash
su - elsearch
```

然后在到bin目录下，执行下面

```bash
# 进入bin目录
cd /soft/elsearch/bin
# 后台启动
./elasticsearch -d
```

启动成功后，访问下面的URL

```bash
http://202.193.56.222:9200/
```

如果出现了下面的信息，就表示已经成功启动了

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/6cggn^uiiBz@.png) 

如果你在启动的时候，遇到过问题，那么请参考下面的错误分析~

> 错误分析

1. 错误情况1

   ```
   java.lang.RuntimeException: can not run elasticsearch as root
   	at org.elasticsearch.bootstrap.Bootstrap.initializeNatives(Bootstrap.java:111)
   	at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:178)
   	at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:393)
   	at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:170)
   	at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:161)
   	at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:86)
   	at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:127)
   	at org.elasticsearch.cli.Command.main(Command.java:90)
   	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:126)
   	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:92)
   For complete error details, refer to the log at /soft/elsearch/logs/elasticsearch.log
   [root@e588039bc613 bin]# 2020-09-22 02:59:39,537121 UTC [536] ERROR CLogger.cc@310 Cannot log to named pipe /tmp/elasticsearch-5834501324803693929/controller_log_381 as it could not be opened for writing
   2020-09-22 02:59:39,537263 UTC [536] INFO  Main.cc@103 Parent process died - ML controller exiting
   ```

   就说明你没有切换成 elsearch用户，因为不能使用root操作es

   ```bash
   su - elsearch
   ```

2. 错误情况2

   ```bash
   [1]:max file descriptors [4096] for elasticsearch process is too low, increase to at least[65536]
   ```

   解决方法：切换到root用户，编辑limits.conf添加如下内容

   ```bash
   vi /etc/security/limits.conf

   # ElasticSearch添加如下内容:
   * soft nofile 65536
   * hard nofile 131072
   * soft nproc 2048
   * hard nproc 4096
   ```

3. 错误情况3

   ```bash
   [2]: max number of threads [1024] for user [elsearch] is too low, increase to at least [4096]
   ```

   也就是最大线程数设置的太低了，需要改成4096

   ```bash
   #解决：切换到root用户，进入limits.d目录下修改配置文件。
   vi /etc/security/limits.d/90-nproc.conf
   #修改如下内容：
   * soft nproc 1024
   #修改为
   * soft nproc 4096
   ```

4. 错误情况 04

   ```bash
   [3]: system call filters failed to install; check the logs and fix your configuration
   or disable system call filters at your own risk
   ```

   解决：Centos6不支持SecComp，而ES5.2.0默认bootstrap.system_call_filter为true

   ```bash
   vim config/elasticsearch.yml
   # 添加
   bootstrap.system_call_filter: false
   bootstrap.memory_lock: false
   ```

5. 错误情况5

   ```bash
   [elsearch@e588039bc613 bin]$ Exception in thread "main" org.elasticsearch.bootstrap.BootstrapException: java.nio.file.AccessDeniedException: /soft/elsearch/config/elasticsearch.keystore
   Likely root cause: java.nio.file.AccessDeniedException: /soft/elsearch/config/elasticsearch.keystore
   	at java.base/sun.nio.fs.UnixException.translateToIOException(UnixException.java:90)
   	at java.base/sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:111)
   	at java.base/sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:116)
   	at java.base/sun.nio.fs.UnixFileSystemProvider.newByteChannel(UnixFileSystemProvider.java:219)
   	at java.base/java.nio.file.Files.newByteChannel(Files.java:375)
   	at java.base/java.nio.file.Files.newByteChannel(Files.java:426)
   	at org.apache.lucene.store.SimpleFSDirectory.openInput(SimpleFSDirectory.java:79)
   	at org.elasticsearch.common.settings.KeyStoreWrapper.load(KeyStoreWrapper.java:220)
   	at org.elasticsearch.bootstrap.Bootstrap.loadSecureSettings(Bootstrap.java:240)
   	at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:349)
   	at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:170)
   	at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:161)
   	at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:86)
   	at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:127)
   	at org.elasticsearch.cli.Command.main(Command.java:90)
   	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:126)
   	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:92)

   ```

   我们通过排查，发现是因为 /soft/elsearch/config/elasticsearch.keystore 存在问题

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/envn7e9v5qGh.png) 

也就是说该文件还是所属于root用户，而我们使用elsearch用户无法操作，所以需要把它变成elsearch

```bash
chown elsearch:elsearch elasticsearch.keystore
```

6. 错误情况6

   ```bash
   [1]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
   ERROR: Elasticsearch did not exit normally - check the logs at /soft/elsearch/logs/elasticsearch.log
   ```

   继续修改配置 elasticsearch.yaml

   ```bash
   # 取消注释，并保留一个节点
   node.name: node-1
   cluster.initial_master_nodes: ["node-1"]
   ```

#### （3）ElasticSearchHead可视化工具

由于ES官方没有给ES提供可视化管理工具，仅仅是提供了后台的服务，elasticsearch-head是一个为ES开发的一个页面客户端工具，其源码托管于Github，地址为 [传送门](https://github.com/mobz/elasticsearch-head)

head提供了以下安装方式

- 源码安装，通过npm run start启动（不推荐）
- 通过docker安装（推荐）
- 通过chrome插件安装（推荐）
- 通过ES的plugin方式安装（不推荐）

> 通过Docker方式安装

```bash
#拉取镜像
docker pull mobz/elasticsearch-head:5
#创建容器
docker create --name elasticsearch-head -p 9100:9100 mobz/elasticsearch-head:5
#启动容器
docker start elasticsearch-head
```

通过浏览器进行访问：

![](https://gitee.com/wwxw/image/raw/master/blog/ElasticSatck/ElasticSearch/2E^g) 

注意：
由于前后端分离开发，所以会存在跨域问题，需要在服务端做CORS的配置，如下：

```bash
vim elasticsearch.yml
http.cors.enabled: true http.cors.allow-origin: "*"
```

### 1.3 ElasticSearch 基本概念

Elasticsearch是Elastic Stack核心的分布式搜索和分析引擎。Logstash和Beats有助于收集，聚合和丰富您的数据并将其存储在Elasticsearch中。使用Kibana，您可以交互式地探索，可视化和共享对数据的见解，并管理和监视堆栈。Elasticsearch是发生索引，搜索和分析魔术的地方。

> [索引与文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/documents-indices.html) 

Elasticsearch是一个分布式文档存储。Elasticsearch不会将信息存储为列数据的行，而是存储已序列化为**JSON文档的复杂数据结构**。当集群中有多个Elasticsearch节点时，存储的文档会分布在整个集群中，并且可以从任何节点立即访问。

存储文档后，将在1秒钟内[几乎实时](https://www.elastic.co/guide/en/elasticsearch/reference/current/near-real-time.html)地对其进行索引和完全搜索。Elasticsearch使用称为**倒排索引**的数据结构，该结构支持非常快速的全文本搜索。反向索引列出了出现在任何文档中的每个唯一单词，并标识了每个单词出现的所有文档。

- **索引可以认为是文档的优化集合，每个文档都是字段的集合，这些字段是包含数据的键值对。**

默认情况下，Elasticsearch对每个字段中的所有数据建立索引，并且每个索引字段都具有专用的优化数据结构。例如，文本字段存储在倒排索引中，数字字段和地理字段存储在BKD树中。使用按字段数据结构组合并返回搜索结果的能力使Elasticsearch如此之快。

> [可绳索性和弹性：集群、节点和分片](https://www.elastic.co/guide/en/elasticsearch/reference/current/scalability.html#scalability) 

Elasticsearch旨在始终可用并根据您的需求扩展。它是通过自然分布来实现的。**您可以将服务器（节点）添加到集群以增加容量**，Elasticsearch会自动在所有可用节点之间分配数据和查询负载。无需大修您的应用程序，Elasticsearch知道如何平衡多节点集群以提供扩展性和高可用性。节点越多，越好。

这是如何运作的？在幕后，Elasticsearch索引实际上只是一个或多个物理碎片的逻辑分组，其中每个碎片实际上是一个独立的索引。通过在多个分片之间的索引中分配文档，并在多个节点之间分配这些分片，Elasticsearch可以确保冗余，这既可以防止硬件故障，又可以在将节点添加到集群中时提高查询能力。随着集群的增长（或收缩），Elasticsearch会自动迁移碎片以重新平衡集群。

**分片有两种类型：** 主数据库和副本数据库。

-  索引中的每个文档都属于一个主分片
- 副本分片是主分片的副本，副本可提供数据的冗余副本，以防止硬件故障并提高处理读取请求（如搜索或检索文档）的能力。

> ##### NRT

Near Realtime，近实时，有两个层面的含义:

1. 一是从写入一条数据到这条数据可以被搜索，有一段非常小的延迟（大约1秒左右）
2. 二是基于Elasticsearch的搜索和分析操作，耗时可以达到秒级。

#### （1）**文档、类型、索引及映射**

![](https://img-blog.csdn.net/2018101011143559?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM2Mjg5Mzc3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![](https://pic4.zhimg.com/80/v2-60e13437fac9b43c13fc2f33a8de817b_720w.jpg)  

**文档 （document）** 

Elasticsearch最小的数据存储单元，JSON数据格式，类似于关系型数据库的表记录（一行数据），结构定义多样化，同一个索引下的document，结构尽可能相同。

**类型 （type）** - ——废弃

类型，原本是在**索引(Index)内进行的逻辑细分**，但后来发现企业研发为了增强可阅读性和可维护性，制订的规范约束，同一个索引下很少还会再使用type进行逻辑拆分（如同一个索引下既有订单数据，又有评论数据），因而在6.0.0版本之后，此定义**废弃**。

**索引 （index）** 

索引，具有相同结构的文档集合，类似于关系型数据库的数据库实例（6.0.0版本type废弃后，索引的概念下降到等同于数据库表的级别）。一个集群里可以定义多个索引，如客户信息索引、商品分类索引、商品索引、订单索引、评论索引等等，分别定义自己的数据结构。

**映射（mapping）** 

 映射是定义文档及其包含的字段如何存储和索引的过程。

#### （2）副本与分片

**分片（**shard**）** 

分片，是单个Lucene索引，而散布这些分片的过程叫作分片处理（sharding），由于单台机器的存储容量是有限的（如1TB），而Elasticsearch索引的数据可能特别大（PB级别，并且30GB/天的写入量），单台机器无法存储全部数据，就需要将索引中的数据切分为多个shard，分布在多台服务器上存储。利用shard可以很好地进行横向扩展，存储更多数据，让搜索和分析等操作分布到多台服务器上去执行，提升集群整体的吞吐量和性能。
shard在使用时比较简单，只需要在创建索引时指定shard的数量即可，剩下的都交给Elasticsearch来完成，只是创建索引时一旦指定shard数量，后期就不能再更改了。

分片可以是主分片，也可以是副本分片，其中副本分片是主分片的完整副本。副本分片用于搜索，或者是在原有的主分片丢失后成为新的主分片。

**注意**：可以在任何时候改变每个分片的副本分片的数量，因为副本分片总是可以被创建和移除的。这并不适用于索引划分为主分片的数量，在创建索引之前，必须决定主分片的数量。过少的分片将限制可扩展性，但是过多的分片会影响性能。默认设置的5份是一个不错的开始。

**副本（replica）** 

索引副本，完全拷贝shard的内容，shard与replica的关系可以是一对多，同一个shard可以有一个或多个replica，并且同一个shard下的replica数据完全一样，replica作为shard的数据拷贝，承担以下三个任务：

1. shard故障或宕机时，其中一个replica可以升级成shard。
2. replica保证数据不丢失（冗余机制），保证高可用。
3. replica可以分担搜索请求，提升整个集群的吞吐量和性能。

**shard的全称叫primary shard，replica全称叫replica shard**

- primary shard数量在创建索引时指定，后期不能修改
- replica shard后期可以修改。

默认每个索引的primary shard值为5，replica shard值为1，含义是5个primary shard，5个replica shard，共10个shard。

因此Elasticsearch最小的高可用配置是2台服务器。**【】【】**

### 1.4 Elasticsearch的工作原理

#### （1）启动过程

当Elasticsearch的node启动时，默认使用广播寻找集群中的其他node，并与之建立连接，如果集群已经存在，其中一个节点角色特殊一些，叫coordinate node（协调者，也叫master节点），负责管理集群node的状态，有新的node加入时，会更新集群拓扑信息。如果当前集群不存在，那么启动的node就自己成为coordinate node。

![](https://img2018.cnblogs.com/blog/1834889/201911/1834889-20191115073615238-1620969013.png) 

#### （2）应用程序与集群通信过程

虽然Elasticsearch设置了Coordinate Node用来管理集群，但这种设置对客户端（应用程序）来说是透明的，客户端可以请求任何一个它已知的node，如果该node是集群当前的Coordinate，那么它会将请求转发到相应的Node上进行处理，如果该node不是Coordinate，那么该node会先将请求转交给Coordinate Node，再由Coordinate进行转发，搓着各node返回的数据全部交由Coordinate Node进行汇总，最后返回给客户端。

![](https://img2018.cnblogs.com/blog/1834889/201911/1834889-20191115073615396-1105568420.png) 

#### （3）集群内node有效性检测

正常工作时，Coordinate Node会定期与拓扑结构中的Node进行通信，检测实例是否正常工作，如果在指定的时间周期内，Node无响应，那么集群会认为该Node已经宕机。集群会重新进行均衡：

1. 重新分配宕机的Node，其他Node中有该Node的replica shard，选出一个replica shard，升级成为primary shard。
2. 重新安置新的shard。
3. 拓扑更新，分发给该Node的请求重新映射到目前正常的Node上。


### 1.5 配置ElasticSearch

> 官方配置文档：[快速验证](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/settings.html#settings) 

**ElasticSearch配置文件** 

1. `elasticsearch.yml` 用于配置Elasticsearch
2. `jvm.options` 用于配置Elasticsearch JVM设置
3. `log4j2.properties` 用于配置Elasticsearch日志记录

#### （1）基本配置

> **path.data 和 path.logs** 

- 生产环境配置

  ```yaml
  path:
    logs: /var/log/elasticsearch
    data: /var/data/elasticsearch
  ```

> **cluster.name** 

当`cluster.name`节点与集群中的所有其他节点共享节点时，该节点只能加入集群。默认名称为`elasticsearch`，但您应将其更改为描述群集用途的适当名称。

```yaml
cluster.name: logging-prod
```

确保不要在不同的环境中重复使用相同的集群名称，否则最终可能会导致节点加入错误的集群。

> **node.name**

Elasticsearch`node.name`用作Elasticsearch特定实例的人类可读标识符，因此它被包含在许多API的响应中。它默认为计算机在Elasticsearch启动时具有的主机名，但可以`elasticsearch.yml`按以下方式显式配置 ：

```yaml
node.name: prod-data-2
```

> **network.host** 

默认情况下，Elasticsearch仅绑定到环回地址（例如`127.0.0.1` 和）`[::1]`。这足以在服务器上运行单个开发节点。

为了与其他服务器上的节点形成集群，您的节点将需要绑定到非环回地址。尽管[网络设置](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-network.html)很多 ，通常您需要配置的是 `network.host`：

```yaml
network.host: 192.168.1.10
```

该`network.host`设置也了解一些特殊的值，比如 `_local_`，`_site_`，`_global_`和喜欢修饰`:ip4`和`:ip6`，其中的细节中可以找到[特殊值`network.host`](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-network.html#network-interface-values)。

注意：一旦为提供了自定义设置`network.host`，Elasticsearch就会假定您正在从开发模式转换为生产模式，并将许多系统启动检查从警告升级为异常。有关更多信息，请参见[开发模式与生产模式](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/system-config.html#dev-vs-prod)。

#### （2）配置JVM



#### （3）HTTP

> 文档地址：[快速访问](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-http.html#modules-http) 

- HTTP机制本质上是完全异步的，这意味着没有阻塞线程在等待响应。使用HTTP异步通信的好处是解决了 [C10k问题](https://en.wikipedia.org/wiki/C10k_problem)。

#### （4）节点

> 文档地址：[快速访问](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-node.html) 

每当您启动Elasticsearch实例时，您都在启动*node*。连接的节点的集合称为[群集](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-cluster.html)。如果您正在运行Elasticsearch的单个节点，那么您将拥有一个节点的集群。

默认情况下，群集中的每个节点都可以处理[HTTP](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-http.html)和 [传输](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-transport.html)流量。传输层专门用于节点之间的通信。HTTP层由REST客户端使用。

所有节点都知道群集中的所有其他节点，并且可以将客户端请求转发到适当的节点。

默认情况下，节点据点具有以下所有类型：符合Master资格，数据，接收和（如果可用）机器学习。所有数据节点也是变换节点。

**节点角色** 

- 主节点：具有`master`角色（默认）的节点，这使其有资格被 [选作](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-discovery.html)控制群集[的](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-discovery.html)[*主*](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-discovery.html)[节点](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-discovery.html)。

- 数据节点：具有`data`角色的节点（默认）。数据节点保存数据并执行与数据相关的操作，例如CRUD，搜索和聚合。

- 提取节点：具有`ingest`角色的节点（默认）。[提取](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/pipeline.html)节点能够将 [提取管道](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/pipeline.html)应用于文档，以便在建立索引之前转换和丰富文档。在繁重的摄取负载下，使用专用的摄取节点而不包含`ingest`具有`master`或`data`角色的节点中的角色是有意义的。

- 远程客户端节点：具有`remote_cluster_client`角色（默认）的节点，这使其有资格充当远程客户端。默认情况下，集群中的任何节点都可以充当跨集群客户端并连接到远程集群。

- 机器学习的节点：具有`xpack.ml.enabled`和`ml`角色的节点，这是Elasticsearch默认分发中的默认行为。如果要使用机器学习功能，则集群中必须至少有一个机器学习节点。

  有关机器学习功能的更多信息，请参阅[Elastic Stack中的机器学习](https://www.elastic.co/guide/en/machine-learning/7.9/index.html)。

- 转换节点：具有`transform`角色的节点。如果要使用转换，则群集中至少有一个转换节点。有关更多信息，请参见 [变换设置](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/transform-settings.html)和[*变换数据*](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/transforms.html)。

**协调节点** 

诸如搜索请求或批量索引请求之类的请求可能涉及保存在不同数据节点上的数据。例如，搜索请求在两个阶段中执行，由接收客户端请求的*节点（协调节点）协调*。

在*分散*阶段，协调节点将请求转发到保存数据的数据节点。每个数据节点在本地执行该请求，并将其结果返回到协调节点。在*收集* 阶段，协调节点将每个数据节点的结果缩减为单个全局结果集。

每个节点都隐式地是一个协调节点。这意味着具有“角色”显式空列表的`node.roles`节点将仅充当协调节点，无法禁用。结果，这样的节点需要具有足够的内存和CPU才能处理收集阶段。

#### （5）线程池

一个节点使用多个线程池来管理内存消耗。与许多线程池关联的队列使待处理的请求得以保留而不是被丢弃。

更改特定线程池可以通过设置其特定于类型的参数来完成。例如，更改`write`线程池中的线程数：

```yaml
thread_pool:
    write: #ES中线程池名称
        size: 30
```

**分配的处理器设置** 

自动检测处理器数量，并基于此数量自动设置线程池设置。在某些情况下，覆盖检测到的处理器数量可能很有用。这可以通过显式设置`node.processors`设置来完成 。

```yaml
node.processors: 2
```

#### （6）TCP重传超时

> 相关文档：https://www.elastic.co/guide/en/elasticsearch/reference/7.9/system-config-tcpretries.html

 群集中的每一对节点都通过许多TCP连接进行通信，这些TCP连接[保持打开状态，](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-transport.html#long-lived-connections)直到其中一个节点关闭或由于基础结构故障导致节点之间的通信中断。

通过隐藏通信应用程序中的临时网络中断，TCP可以在偶尔不可靠的网络上提供可靠的通信。在通知发件人任何问题之前，您的操作系统将多次重发丢失的消息。大多数Linux发行版默认将任何丢失的数据包重传15次。重新传输以指数方式回退，因此这15次重新传输需要900秒钟以上的时间才能完成。这意味着使用这种方法，Linux需要花费几分钟的时间来检测网络分区或故障节点。Windows默认仅重传5次，相应的超时时间约为6秒。

Linux的默认设置允许通过可能遭受很长数据包丢失的网络进行通信，但是对于大多数Elasticsearch集群而言，此默认设置对于单个数据中心内的生产网络来说过高。高可用性群集必须能够快速检测节点故障，以便它们可以通过重新分配丢失的碎片，重新路由搜索以及可能选择一个新的主节点来迅速做出反应。因此，Linux用户应减少TCP重传的最大次数。

您可以`5`通过运行以下命令来减少最大TCP重传次数`root`。五次重发对应于大约六秒钟的超时。

```sh
sysctl -w net.ipv4.tcp_retries2=5
```

### 1.6 RestFul API

在Elasticsearch中，提供了功能丰富的RESTful API的操作，包括基本的CRUD、创建索引、删除索引等操作。

#### （1）创建非结构化索引

在Lucene中，创建索引是需要定义字段名称以及字段的类型的，在Elasticsearch中提供了非结构化的索引，就是不需要创建索引结构，即可写入数据到索引中，实际上在Elasticsearch底层会进行结构化操作，此操作对用户是透明的。

##### 1.创建空索引

```json
PUT /haoke
{
    "settings": {
        "index": {
        "number_of_shards": "2", #分片数
        "number_of_replicas": "0" #副本数
        }
    }
}
```

##### 2. 删除索引

```json
#删除索引
DELETE /haoke
{
	"acknowledged": true
}
```

##### 3. 插入数据

> URL规则： POST /{索引}/{类型}/{id}

```json
POST /haoke/user/1001
#数据
{
"id":1001,
"name":"张三",
"age":20,
"sex":"男"
}
```

说明：非结构化的索引，不需要事先创建，直接插入数据默认创建索引。不指定id插入数据：

##### 4. 更新数据

在Elasticsearch中，文档数据是不为修改的，但是可以通过覆盖的方式进行更新。

```json
PUT /haoke/user/1001
{
"id":1001,
"name":"张三",
"age":21,
"sex":"女"
}
```

可以看到数据已经被覆盖了。问题来了，可以局部更新吗？ -- 可以的。前面不是说，文档数据不能更新吗？ 其实是这样的：在内部，依然会查询到这个文档数据，然后进行覆盖操作，步骤如下：

1. 从旧文档中检索JSON
2. 修改它
3. 删除旧文档
4. 索引新文档

```json
#注意：这里多了_update标识
POST /haoke/user/1001/_update
{
"doc":{
"age":23
}
}
```

可以看到，数据已经是局部更新了

##### 5. 删除文档数据

在Elasticsearch中，删除文档数据，只需要发起DELETE请求即可，不用额外的参数

```json
DELETE 1 /haoke/user/1001
```

> 删除一个文档也不会立即从磁盘上移除，它只是被标记成已删除。Elasticsearch将会在你之后添加更多索引的时候才会在后台进行删除内容的清理。【相当于批量操作】

##### 6. 搜索数据

> 根据Id 搜索数据

```json
GET /haoke/user/BbPe_WcB9cFOnF3uebvr
#返回的数据如下
{
    "_index": "haoke",
    "_type": "user",
    "_id": "BbPe_WcB9cFOnF3uebvr",
    "_version": 8,
    "found": true,
    "_source": { #原始数据在这里
        "id": 1002,
        "name": "李四",
        "age": 40,
        "sex": "男"
        }
}
```

> #### 搜索全部数据

```json
GET 1 /haoke/user/_search
```

注意，使用查询全部数据的时候，默认只会返回10条

> 关键字搜索

```json
#查询年龄等于20的用户
GET /haoke/user/_search?q=age:20
```

#### （2）DSL 搜索

Elasticsearch提供丰富且灵活的查询语言叫做DSL查询(Query DSL),它允许你构建更加复杂、强大的查询。 DSL(Domain Specific Language特定领域语言)以JSON请求体的形式出现。

```json
POST /haoke/user/_search
#请求体
{
    "query" : {
        "match" : { #match只是查询的一种
        	"age" : 20
        }
    }
}
```

实现：查询年龄大于30岁的男性用户。

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200922162943539.png) 

```json
POST /haoke/user/_search
#请求数据
{
    "query": {
        "bool": {
            "filter": {
                    "range": {
                        "age": {
                        "gt": 30
                    }
                }
            },
            "must": {
                "match": {
                	"sex": "男"
                }
            }
        }
    }
}
```

查询出来的结果

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200922163109515.png) 

##### 1.  全文搜索

```json
POST /haoke/user/_search
#请求数据
{
    "query": {
        "match": {
        	"name": "张三 李四"
        }
    }
}
```

高亮显示，只需要在添加一个 highlight即可

```json
POST /haoke/user/_search
#请求数据
{
    "query": {
        "match": {
        	"name": "张三 李四"
        }
    }
    "highlight": {
        "fields": {
        	"name": {}
        }
    }
}
```

##### 2. 聚合

在Elasticsearch中，支持聚合操作，类似SQL中的group by操作。

```json
POST /haoke/user/_search
{
    "aggs": {
        "all_interests": {
            "terms": {
                "field": "age"
            }
        }
    }
}
```

结果如下，我们通过年龄进行聚合

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200922163614708.png) 

从结果可以看出，年龄30的有2条数据，20的有一条，40的一条。

### 1.7 ElasticSearch 核心详解

#### （1）文档

在Elasticsearch中，文档以JSON格式进行存储，可以是复杂的结构，如：

```json
{
    "_index": "haoke",
    "_type": "user",
    "_id": "1005",
    "_version": 1,
    "_score": 1,
    "_source": {
        "id": 1005,
        "name": "孙七",
        "age": 37,
        "sex": "女",
        "card": {
            "card_number": "123456789"
         }
    }
}
```

其中，card是一个复杂对象，嵌套的Card对象

- #### 元数据（metadata）

一个文档不只有数据。它还包含了元数据(metadata)——关于文档的信息。三个必须的元数据节点是：

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200922165956176.png) 

- #### index

索引(index)类似于关系型数据库里的“数据库”——它是我们存储和索引关联数据的地方。

**提示：**事实上，我们的数据被存储和索引在分片(shards)中，索引只是一个把一个或多个分片分组在一起的逻辑空间。然而，这只是一些内部细节——我们的程序完全不用关心分片。对于我们的程序而言，文档存储在索引(index)中。剩下的细节由Elasticsearch关心既可。

- #### _type

应用中，我们使用对象表示一些“事物”，例如一个用户、一篇博客、一个评论，或者一封邮件。每个对象都属于一个类(class)，这个类定义了属性或与对象关联的数据。user 类的对象可能包含姓名、性别、年龄和Email地址。 在关系型数据库中，我们经常将相同类的对象存储在一个表里，因为它们有着相同的结构。同理，在Elasticsearch 中，我们使用相同类型(type)的文档表示相同的“事物”，因为他们的数据结构也是相同的。

每个类型(type)都有自己的映射(mapping)或者结构定义，就像传统数据库表中的列一样。所有类型下的文档被存储在同一个索引下，但是类型的映射(mapping)会告诉Elasticsearch不同的文档如何被索引。

_type 的名字可以是大写或小写，不能包含下划线或逗号。我们将使用blog 做为类型名。

- #### _id

id仅仅是一个字符串，它与_index 和_type 组合时，就可以在Elasticsearch中唯一标识一个文档。当创建一个文 档，你可以自定义_id ，也可以让Elasticsearch帮你自动生成（32位长度）

#### （2）查询响应

- #### pretty

  可以在查询url后面添加pretty参数，使得返回的json更易查看。

- **指定响应字段**

在响应的数据中，如果我们不需要全部的字段，可以指定某些需要的字段进行返回。通过添加 _source

```json
GET /haoke/user/1005?_source=id,name
#响应
{
    "_index": "haoke",
    "_type": "user",
    "_id": "1005",
    "_version": 1,
    "found": true,
    "_source": {
        "name": "孙七",
        "id": 1005
     }
```

如不需要返回元数据，仅仅返回原始数据，可以这样：

```json
GET /haoke/1 user/1005/_source
```

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923101239226.png) 

还可以这样：

```json
GET /haoke/user/1005/_source?_1 source=id,name
```

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923101319728.png) 

#### （3）判断文档是否存在

如果我们只需要判断文档是否存在，而不是查询文档内容，那么可以这样：

```json
HEAD /haoke/user/1005
```

通过发送一个head请求，来判断数据是否存在

> 当然，这只表示你在查询的那一刻文档不存在，但并不表示几毫秒后依旧不存在。另一个进程在这期间可能创建新文档。

#### （4）批量操作

有些情况下可以通过批量操作以减少网络请求。如：批量查询、批量插入数据。

##### 1. 批量查询

```json
POST /haoke/user/_mget
{
	"ids" : [ "1001", "1003" ]
}
```

如果，某一条数据不存在，不影响整体响应，需要通过found的值进行判断是否查询到数据。

```json
POST /haoke/user/_mget
{
	"ids" : [ "1001", "1006" ]
}
```

也就是说，一个数据的存在不会影响其它数据的返回

##### 2. _bulk操作

在Elasticsearch中，支持批量的插入、修改、删除操作，都是通过_bulk的api完成的。

请求格式如下：（请求格式不同寻常）

```json
{ action: { metadata }}
{ request body }
{ action: { metadata }}
{ request body }
...
```

**批量插入数据：**

```json
{"create":{"_index":"haoke","_type":"user","_id":2001}}
{"id":2001,"name":"name1","age": 20,"sex": "男"}
{"create":{"_index":"haoke","_type":"user","_id":2002}}
{"id":2002,"name":"name2","age": 20,"sex": "男"}
{"create":{"_index":"haoke","_type":"user","_id":2003}}
{"id":2003,"name":"name3","age": 20,"sex": "男"}
```

注意最后一行的回车。

批量删除：

```json
{"delete":{"_index":"haoke","_type":"user","_id":2001}}
{"delete":{"_index":"haoke","_type":"user","_id":2002}}
{"delete":{"_index":"haoke","_type":"user","_id":2003}}
```

由于delete没有请求体，所以，action的下一行直接就是下一个action。

#### （5）分页

和SQL使用LIMIT 关键字返回只有一页的结果一样，Elasticsearch接受from 和size 参数：

- size: 结果数，默认10
- from: 跳过开始的结果数，默认0

如果你想每页显示5个结果，页码从1到3，那请求如下：

```json
GET /_search?size=5
GET /_search?size=5&from=5
GET /_search?size=5&from=10
```

应该当心分页太深或者一次请求太多的结果。结果在返回前会被排序。但是记住一个搜索请求常常涉及多个分 片。每个分片生成自己排好序的结果，它们接着需要集中起来排序以确保整体排序正确。

```json
GET /haoke/user/_1 search?size=1&from=2
```

> #### 在集群系统中深度分页

为了理解为什么深度分页是有问题的，让我们假设在一个有5个主分片的索引中搜索。当我们请求结果的第一 页（结果1到10）时，每个分片产生自己最顶端10个结果然后返回它们给请求节点(requesting node)，它再 排序这所有的50个结果以选出顶端的10个结果。

现在假设我们请求第1000页——结果10001到10010。工作方式都相同，不同的是每个分片都必须产生顶端的 10010个结果。然后请求节点排序这50050个结果并丢弃50040个！

你可以看到在分布式系统中，排序结果的花费随着分页的深入而成倍增长。这也是为什么网络搜索引擎中任何 语句不能返回多于1000个结果的原因。

#### （6）结构化查询

##### 1. term查询

term 主要用于精确匹配哪些值，比如数字，日期，布尔值或 not_analyzed 的字符串(未经分析的文本数据类型)：

```json
{ "term": { "age": 26 }}
{ "term": { "date": "2014-09-01" }}
{ "term": { "public": true }}
{ "term": { "tag": "full_text" }}
```

示例

```json
POST /itcast/person/_search
{
    "query":{
        "term":{
            "age":20
        }
    }
}
```

##### 2. terms查询

terms 跟 term 有点类似，但 terms 允许指定多个匹配条件。 如果某个字段指定了多个值，那么文档需要一起去 做匹配：

```json
{
    "terms":{
        "tag":[
            "search",
            "full_text",
            "nosql"
        ]
    }
}
```

示例：

```json
POST /itcast/person/_search
{
    "query":{
        "terms":{
            "age":[
                20,
                21
            ]
        }
    }
}
```

##### 3. range 范围查询

range 过滤允许我们按照指定范围查找一批数据：

```
{
    "range":{
        "age":{
            "gte":20,
            "lt":30
        }
    }
}
```

范围操作符包含：

- gt : 大于
- gte:: 大于等于
- lt : 小于
- lte: 小于等于

**示例：** 

```json
POST /itcast/person/_search
{
    "query":{
        "range":{
            "age":{
                "gte":20,
                "lte":22
            }
        }
    }
}
```

##### 4. exists 查询

exists 查询可以用于查找文档中是否包含指定字段或没有某个字段，类似于SQL语句中的IS_NULL 条件

```
{
    "exists": {
    	"field": "title"
    }
}
```

这两个查询只是针对已经查出一批数据来，但是想区分出某个字段是否存在的时候使用。示例：

```
POST /haoke/user/_search
{
    "query": {
        "exists": { #必须包含
        	"field": "card"
        }
    }
}
```

##### 5. match查询

match 查询是一个标准查询，不管你需要全文本查询还是精确查询基本上都要用到它。

如果你使用 match 查询一个全文本字段，它会在真正查询之前用分析器先分析match 一下查询字符：

```json
{
    "match": {
    	"tweet": "About Search"
    }
}
```

如果用match 下指定了一个确切值，在遇到数字，日期，布尔值或者not_analyzed 的字符串时，它将为你搜索你 给定的值：

```json
{ "match": { "age": 26 }}
{ "match": { "date": "2014-09-01" }}
{ "match": { "public": true }}
{ "match": { "tag": "full_text" }}
```

##### 6. bool查询

- bool 查询可以用来合并多个条件查询结果的布尔逻辑，它包含一下操作符：
- must :: 多个查询条件的完全匹配,相当于 and 。
- must_not :: 多个查询条件的相反匹配，相当于 not 。
- should :: 至少有一个查询条件匹配, 相当于 or 。

这些参数可以分别继承一个查询条件或者一个查询条件的数组：

```
{
    "bool":{
        "must":{
            "term":{
                "folder":"inbox"
            }
        },
        "must_not":{
            "term":{
                "tag":"spam"
            }
        },
        "should":[
            {
                "term":{
                    "starred":true
                }
            },
            {
                "term":{
                    "unread":true
                }
            }
        ]
    }
}
```

#### （7）过滤查询

前面讲过结构化查询，Elasticsearch也支持过滤查询，如term、range、match等。

示例：查询年龄为20岁的用户。

```json
POST /itcast/person/_search
{
    "query":{
        "bool":{
            "filter":{
                "term":{
                    "age":20
                }
            }
        }
    }
}
```

> **查询和过滤的对比**

- 一条过滤语句会询问每个文档的字段值是否包含着特定值。
- 查询语句会询问每个文档的字段值与特定值的匹配程度如何。
- 一条查询语句会计算每个文档与查询语句的相关性，会给出一个相关性评分 _score，并且 按照相关性对匹 配到的文档进行排序。 这种评分方式非常适用于一个没有完全配置结果的全文本搜索。
- 一个简单的文档列表，快速匹配运算并存入内存是十分方便的， 每个文档仅需要1个字节。这些缓存的过滤结果集与后续请求的结合使用是非常高效的。
- 查询语句不仅要查找相匹配的文档，还需要计算每个文档的相关性，所以一般来说查询语句要比 过滤语句更耗时，并且查询结果也不可缓存。

>  **建议：**

做精确匹配搜索时，最好用过滤语句，因为过滤语句可以缓存数据。

#### （8）中文分词

##### 1. 什么是中文分析？

分词就是指将一个文本转化成一系列单词的过程，也叫文本分析，在Elasticsearch中称之为Analysis。

举例：我是中国人 --> 我/是/中国人

##### 2. 分词api

指定分词器进行分词

```
POST /_analyze
{
    "analyzer":"standard",
    "text":"hello world"
}
```

结果如下

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923110814505.png) 

在结果中不仅可以看出分词的结果，还返回了该词在文本中的位置。

> 指定索引分词

```
POST /itcast/_analyze
{
    "analyzer": "standard",
    "field": "hobby",
    "text": "听音乐"
}
```

##### 3. 中文分词的难点

中文分词的难点在于，在汉语中没有明显的词汇分界点，如在英语中，空格可以作为分隔符，如果分隔不正确就会造成歧义。如：

- 我/爱/炒肉丝
- 我/爱/炒/肉丝

常用中文分词器，IK、jieba、THULAC等，推荐使用IK分词器。

IK Analyzer是一个开源的，基于java语言开发的轻量级的中文分词工具包。从2006年12月推出1.0版开始，IKAnalyzer已经推出了3个大版本。最初，它是以开源项目Luence为应用主体的，结合词典分词和文法分析算法的中文分词组件。新版本的IK Analyzer 3.0则发展为面向Java的公用分词组件，独立于Lucene项目，同时提供了对Lucene的默认优化实现。

采用了特有的“正向迭代最细粒度切分算法“，具有80万字/秒的高速处理能力 采用了多子处理器分析模式，支持：英文字母（IP地址、Email、URL）、数字（日期，常用中文数量词，罗马数字，科学计数法），中文词汇（姓名、地名处理）等分词处理。 优化的词典存储，更小的内存占用。

IK分词器 Elasticsearch插件地址：<https://github.com/medcl/elasticsearch-analysis-ik>

> 安装后测试

```json
POST /_analyze
{
    "analyzer": "ik_max_word",
    "text": "我是中国人"
}
```

#### （9）全文搜索

全文搜索两个最重要的方面是：

- 相关性（Relevance） 它是评价查询与其结果间的相关程度，并根据这种相关程度对结果排名的一种能力，这 种计算方式可以是 TF/IDF 方法、地理位置邻近、模糊相似，或其他的某些算法。
- 分词（Analysis） 它是将文本块转换为有区别的、规范化的 token 的一个过程，目的是为了创建倒排索引以及查询倒排索引。

##### 1. 构造数据

> ES 7.4 默认不在支持指定索引类型，默认索引类型是_doc

```
http://202.193.56.222:9200/itcast?include_type_name=true
{
    "settings":{
        "index":{
            "number_of_shards":"1",
            "number_of_replicas":"0"
        }
    },
    "mappings":{
        "person":{
            "properties":{
                "name":{
                    "type":"text"
                },
                "age":{
                    "type":"integer"
                },
                "mail":{
                    "type":"keyword"
                },
                "hobby":{
                    "type":"text",
                    "analyzer":"ik_max_word"
                }
            }
        }
    }
}
```

然后插入数据

```
POST http://202.193.56.222:9200/itcast/_bulk
{"index":{"_index":"itcast","_type":"person"}}
{"name":"张三","age": 20,"mail": "111@qq.com","hobby":"羽毛球、乒乓球、足球"}
{"index":{"_index":"itcast","_type":"person"}}
{"name":"李四","age": 21,"mail": "222@qq.com","hobby":"羽毛球、乒乓球、足球、篮球"}
{"index":{"_index":"itcast","_type":"person"}}
{"name":"王五","age": 22,"mail": "333@qq.com","hobby":"羽毛球、篮球、游泳、听音乐"}
{"index":{"_index":"itcast","_type":"person"}}
{"name":"赵六","age": 23,"mail": "444@qq.com","hobby":"跑步、游泳、篮球"}
{"index":{"_index":"itcast","_type":"person"}}
{"name":"孙七","age": 24,"mail": "555@qq.com","hobby":"听音乐、看电影、羽毛球"}
```

##### 2. 单词搜索

```json
POST /itcast/person/_search
{
    "query":{
        "match":{
            "hobby":"音乐"
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

查询出来的结果如下，并且还带有高亮

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923142131426.png) 

过程说明：

- 检查字段类型
  - 爱好 hobby 字段是一个 text 类型（ 指定了IK分词器），这意味着查询字符串本身也应该被分词。
- 分析查询字符串 。
  - 将查询的字符串 “音乐” 传入IK分词器中，输出的结果是单个项 音乐。因为只有一个单词项，所以 match 查询执行的是单个底层 term 查询。
- 查找匹配文档 。
  - 用 term 查询在倒排索引中查找 “音乐” 然后获取一组包含该项的文档，本例的结果是文档：3 、5 。
- 为每个文档评分 。
  - 用 term 查询计算每个文档相关度评分 _score ，这是种将 词频（term frequency，即词 “音乐” 在相关文档的hobby 字段中出现的频率）和 反向文档频率（inverse document frequency，即词 “音乐” 在所有文档的hobby 字段中出现的频率），以及字段的长度（即字段越短相关度越高）相结合的计算方式。

##### 3. 多词搜索

```json
POST /itcast/person/_search
{
    "query":{
        "match":{
            "hobby":"音乐 篮球"
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

可以看到，包含了“音乐”、“篮球”的数据都已经被搜索到了。可是，搜索的结果并不符合我们的预期，因为我们想搜索的是既包含“音乐”又包含“篮球”的用户，显然结果返回的“或”的关系。在Elasticsearch中，可以指定词之间的逻辑关系，如下：

```json
POST /itcast/person/_search
{
    "query":{
        "match":{
            "hobby":"音乐 篮球"
            "operator":"and"
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

通过这样的话，就会让两个关键字之间存在and关系了

##### 4. 组合搜索

在搜索时，也可以使用过滤器中讲过的bool组合查询，示例：

```json
POST /itcast/person/_search
{
    "query":{
        "bool":{
            "must":{
                "match":{
                    "hobby":"篮球"
                }
            },
            "must_not":{
                "match":{
                    "hobby":"音乐"
                }
            },
            "should":[
                {
                    "match":{
                        "hobby":"游泳"
                    }
                }
            ]
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

> 上面搜索的意思是： 搜索结果中必须包含篮球，不能包含音乐，如果包含了游泳，那么它的相似度更高。

**评分的计算规则**

- bool 查询会为每个文档计算相关度评分 _score ， 再将所有匹配的 must 和 should 语句的分数 _score 求和，最后除以 must 和 should 语句的总数。
- must_not 语句不会影响评分； 它的作用只是将不相关的文档排除。

默认情况下，should中的内容不是必须匹配的，如果查询语句中没有must，那么就会至少匹配其中一个。当然了，也可以通过minimum_should_match参数进行控制，该值可以是数字也可以的百分比。

示例：

```json
POST /itcast/person/_search
{
    "query":{
        "bool":{
            "should":[
                {
                    "match":{
                        "hobby":"游泳"
                    }
                },
                {
                    "match":{
                        "hobby":"篮球"
                    }
                },
                {
                    "match":{
                        "hobby":"音乐"
                    }
                }
            ],
            "minimum_should_match":2
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

minimum_should_match为2，意思是should中的三个词，至少要满足2个。

##### 5. 权重

有些时候，我们可能需要对某些词增加权重来影响该条数据的得分。如下：

搜索关键字为“游泳篮球”，如果结果中包含了“音乐”权重为10，包含了“跑步”权重为2。

```json
POST /itcast/person/_search
{
    "query":{
        "bool":{
            "must":{
                "match":{
                    "hobby":{
                        "query":"游泳篮球",
                        "operator":"and"
                    }
                }
            },
            "should":[
                {
                    "match":{
                        "hobby":{
                            "query":"音乐",
                            "boost":10
                        }
                    }
                },
                {
                    "match":{
                        "hobby":{
                            "query":"跑步",
                            "boost":2
                        }
                    }
                }
            ]
        }
    },
    "highlight":{
        "fields":{
            "hobby":{

            }
        }
    }
}
```

## ElasticSearch 集群

### 2.1 集群节点

ELasticsearch的集群是由多个节点组成的，通过cluster.name设置集群名称，并且用于区分其它的集群，每个节点通过node.name指定节点的名称。

在Elasticsearch中，节点的类型主要有4种：

- master节点

  配置文件中node.master属性为true(默认为true)，就有资格被选为master节点。master节点用于控制整个集群的操作。比如创建或删除索引，管理其它非master节点等。

- data 节点

  配置文件中node.data属性为true(默认为true)，就有资格被设置成data节点。data节点主要用于执行数据相关的操作。比如文档的CRUD。

- 客户端节点

  1. 配置文件中node.master属性和node.data属性均为false，也就是该节点不能作为master节点，也不能作为data节点
  2. 可以作为客户端节点，用于响应用户的请求，把请求转发到其他节点

- 部落节点

  当一个节点配置tribe.*的时候，它是一个特殊的客户端，它可以连接多个集群，在所有连接的集群上执行 搜索和其他操作。

#### （1）搭建集群

```bash
#启动3个虚拟机，分别在3台虚拟机上部署安装Elasticsearch
mkdir /itcast/es-cluster

#分发到其它机器
scp -r es-cluster elsearch@192.168.40.134:/itcast

#node01的配置：
cluster.name: es-itcast-cluster
node.name: node01
node.master: true
node.data: true
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.40.133","192.168.40.134","192.168.40.135"]
# 最小节点数
discovery.zen.minimum_master_nodes: 2
# 跨域专用
http.cors.enabled: true
http.cors.allow-origin: "*"

#node02的配置：
cluster.name: es-itcast-cluster
node.name: node02
node.master: true
node.data: true
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.40.133","192.168.40.134","192.168.40.135"]
discovery.zen.minimum_master_nodes: 2
http.cors.enabled: true
http.cors.allow-origin: "*"

#node03的配置：
cluster.name: es-itcast-cluster
node.name: node02
node.master: true
node.data: true
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.40.133","192.168.40.134","192.168.40.135"]
discovery.zen.minimum_master_nodes: 2
http.cors.enabled: true
http.cors.allow-origin: "*"

#分别启动3个节点
./elasticsearch
```

> 查看集群

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923151823672.png) 

> 创建索引

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923151851785.png) 

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923151935283.png) 

> 查询集群状态：/_cluster/health 响应

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923151953227.png) 

> 集群中有三种颜色

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923152005930.png) 

#### （2）分片和副本

了将数据添加到Elasticsearch，我们需要索引(index)——一个存储关联数据的地方。实际上，索引只是一个用来指向一个或多个分片(shards)的“逻辑命名空间(logical namespace)”.

- 一个分片(shard)是一个最小级别“工作单元(worker unit)”,它只是保存了索引中所有数据的一部分。
- 我们需要知道的是分片就是一个Lucene实例，并且它本身就是一个完整的搜索引擎。应用程序不会和它直接通 信。
- 分片可以是主分片(primary shard)或者是复制分片(replica shard)。
- 索引中的每个文档属于一个单独的主分片，所以主分片的数量决定了索引最多能存储多少数据。
- 复制分片只是主分片的一个副本，它可以防止硬件故障导致的数据丢失，同时可以提供读请求，比如搜索或者从别的shard取回文档。
- 当索引创建完成的时候，主分片的数量就固定了，但是复制分片的数量可以随时调整。

#### （3）故障转移

##### 1. **将data节点停止** 

这里选择将node02停止：

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923152229908.png) 

当前集群状态为黄色，表示主节点可用，副本节点不完全可用，过一段时间观察，发现节点列表中看不到node02，副本节点分配到了node01和node03，集群状态恢复到绿色。

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923152248547.png) 

> **将node02恢复： ./node02/1 bin/elasticsearch**

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923152328458.png) 

可以看到，node02恢复后，重新加入了集群，并且重新分配了节点信息。

##### 2. **将Master节点停止** 

 接下来，测试将node01停止，也就是将主节点停止。

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923152415890.png) 

从结果中可以看出，集群对master进行了重新选举，选择node03为master。并且集群状态变成黄色。 等待一段时间后，集群状态从黄色变为了绿色：

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923153343555.png) 

> 恢复node01节点：

```bash
./node01/1 bin/elasticsearch
```

重启之后，发现node01可以正常加入到集群中，集群状态依然为绿色

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923153415117.png) 

**特别说明：**

如果在配置文件中discovery.zen.minimum_master_nodes设置的不是N/2+1时，会出现脑裂问题，之前宕机 的主节点恢复后不会加入到集群。

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923153441693.png) 

#### （4）分布式文档

##### 1. 路由

首先来看个问题

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923153556720.png) 

如图所示：当我们想一个集群保存文档时，文档该存储到哪个节点呢？ 是随机吗？ 是轮询吗？实际上，在ELasticsearch中，会采用计算的方式来确定存储到哪个节点，计算公式如下：

```c#
shard = hash(routing) % number_1 of_primary_shards
```

其中：

- routing值是一个任意字符串，它默认是_id但也可以自定义。
- 这个routing字符串通过哈希函数生成一个数字，然后除以主切片的数量得到一个余数(remainder)，余数 的范围永远是0到number_of_primary_shards - 1，这个数字就是特定文档所在的分片

这就是为什么创建了主分片后，不能修改的原因。

##### 2. 文档的写操作

新建、索引和删除请求都是写（write）操作，它们必须在主分片上成功完成才能复制分片上

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923155314424.png) 

下面我们罗列在主分片和复制分片上成功新建、索引或删除一个文档必要的顺序步骤： 

1. 客户端给Node 1 发送新建、索引或删除请求。
2. 节点使用文档的_id 确定文档属于分片0 。它转发请求到Node 3 ，分片0 位于这个节点上。
3. Node 3 在主分片上执行请求，如果成功，它转发请求到相应的位于Node 1 和Node 2 的复制节点上。当所有 的复制节点报告成功， Node 3 报告成功到请求的节点，请求的节点再报告给客户端。

客户端接收到成功响应的时候，文档的修改已经被应用于主分片和所有的复制分片。你的修改生效了。

#### （5）搜索文档

> 文档能够从主分片或任意一个复制分片被检索。

![](https://gitee.com/moxi159753/LearningNotes/raw/master/ElasticStack/1_ElasticSearch%E4%BB%8B%E7%BB%8D%E4%B8%8E%E5%AE%89%E8%A3%85/images/image-20200923160046962.png) 

下面我们罗列在主分片或复制分片上检索一个文档必要的顺序步骤：

1. 客户端给Node 1 发送get请求。
2. 节点使用文档的_id 确定文档属于分片0 。分片0 对应的复制分片在三个节点上都有。此时，它转发请求到 Node 2 。
3. Node 2 返回文档(document)给Node 1 然后返回给客户端。对于读请求，为了平衡负载，请求节点会为每个请求选择不同的分片——它会循环所有分片副本。可能的情况是，一个被索引的文档已经存在于主分片上却还没来得及同步到复制分片上。这时复制分片会报告文档未找到，主分片会成功返回文档。一旦索引请求成功返回给用户，文档则在主分片和复制分片都是可用的。

#### （6）全文检索

对于全文搜索而言，文档可能分散在各个节点上，那么在分布式的情况下，如何搜索文档呢？

搜索，分为2个阶段，

- 搜索（query）
- 取回（fetch）

##### 1. 搜索













































