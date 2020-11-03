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








