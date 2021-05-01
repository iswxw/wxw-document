### ClickHouse

### 1. ClickHouse 初识

ClickHouse是一个用于联机分析(OLAP)的列式数据库管理系统(DBMS)

- 官方文档：https://clickhouse.tech/docs/zh/

#### 1.1 Clickhouse 环境构建

##### 1.1.1 docker构建clickhouse

docker环境搭建好之后，利用docker安装clickhouse比较简单，clickhouse官方提供了默认的镜像，直接使用即可。

- 官方文档参考：https://hub.docker.com/r/yandex/clickhouse-server/

**1.1.1 拉取clickhouse的docker镜像** 

```dockerfile
docker pull yandex/clickhouse-server
docker pull yandex/clickhouse-client
```

**1.1.2 启动 clickhouse-server**  

```dockerfile
# 方式一：启动服务（临时启动、获取配置文件）
docker run --rm -d --name clickhouse-server --ulimit nofile=262144:262144 -p 8123:8123 -p 9009:9009 -p 9000:9000 \
yandex/clickhouse-server:latest

# 方式二：如果想指定目录启动，这里以clickhouse-test-server命令为例，可以随意写
 mkdir -p /apps/clickhouse/clickhouse-test-db       ## 创建数据文件目录
# 使用以下路径启动，在外只能访问clickhouse提供的默认9000端口，只能通过clickhouse-client连接server
docker run -d --name clickhouse-test-server --ulimit nofile=262144:262144 --volume=/spps/clickhouse/clickhouse-test-db:/var/lib/clickhouse yandex/clickhouse-server
```

**1.1.3 启动 client 并连接 clickhouse-server** 

>  docker启动clickhouse-client

```bash
## 第一次运行并启动
docker run -it --rm --link clickhouse-test-server:clickhouse-server yandex/clickhouse-client --host clickhouse-server
## 第二次启动容器使用以下命令即可
docker start [containerId]

## 第二次启动之后进入容器使用以下命令即可
# 如果退出了容器，如何继续玩耍？重新执行下面这个命令即可。
docker run -it --rm --link clickhouse-test-server:clickhouse-server yandex/clickhouse-client --host clickhouse-server 
```

![image-20210427131310760](asserts/image-20210427131310760.png)

> 查询默认的表

![image-20210427132428107](asserts/image-20210427132428107.png) 

**1.1.4 复制容器中的配置文件到宿主机** 

提前建好文件夹，不然会报错，/apps/clickhouse/config 是本机新建的目录，方便管理。该目录可以任意

```powershell
# 新建存储clickhouse配置的目录
mkdir -p /apps/clickhouse/config

# 复制配置并与宿主机关联
docker cp clickhouse-server:/etc/clickhouse-server/config.xml /apps/clickhouse/config/config.xml
docker cp clickhouse-server:/etc/clickhouse-server/users.xml /apps/clickhouse/config/users.xml
```

**1.1.5 停止ClickHouse 服务** 

```powershell
# 停止服务指令
docker stop 【容器ID/容器名称】

# example
docker stop 6a10d8d7bf36
# 或者 （格式：docker stop 容器名<第3步输入--name的值>)
docker stop clickhouse-server
```

##### 1.1.2 clickhouse 修改密码

- 配置文件位置(根据1.1.4 中复制指定的位置)

  ```powershell
  /apps/clickhouse/config/users.xml
  ```

- 修改前

  ![在这里插入图片描述](asserts/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQxMDcwMzkz,size_16,color_FFFFFF,t_70.png)

- 在password标签中加上密码123456，可以使用"加密密码",修改完成保存退出

##### 1.1.3 重启使服务生效

```powershell
## 启动方式一：指定目录启动 clickhouse-test-server
docker run -d --name=clickhouse-server -p 8123:8123 -p 9009:9009 -p 9000:9000 --ulimit nofile=262144:262144 \
--volume=/spps/clickhouse/clickhouse-test-db:/var/lib/clickhouse yandex/clickhouse-server

## 启动方式二：挂载（用此可能不当）数据、日志、配置文件到指定目录
docker run -d --name=clickhouse-server \
-p 8123:8123 -p 9009:9009 -p 9000:9000 \
--ulimit nofile=262144:262144 \
-v /Users/vick/data/programs/docker/clickhouse/data:/var/lib/clickhouse:rw \
-v /Users/vick/data/programs/docker/clickhouse/conf/config.xml:/etc/clickhouse-server/config.xml \
-v /Users/vick/data/programs/docker/clickhouse/conf/users.xml:/etc/clickhouse-server/users.xml \
-v /Users/vick/data/programs/docker/clickhouse/log:/var/log/clickhouse-server:rw \
yandex/clickhouse-server:latest
```

##### 1.1.4 启动clickhouse 客户端

```powershell
## 启动客户端
docker run -it --rm --link clickhouse-server:clickhouse-server yandex/clickhouse-client --host clickhouse-server --password=123456

# 启动客户端相关指令
clickhouse-client
    --host, -h     	：服务端host名称，默认 localhost
    --port         	：连接端口，默认9000
    --user, -u     	：用户名，默认 default
    --password     	：密码，默认空
    --query, -q    	：非交互模式下的查询语句
    --database, -d 	：默认当前操作的数据库，默认default
    --multiline, -m ：允许多行语句查询，在clickhouse中默认回车即为sql结束，可使用该参数多行输入
    --format, -f		：使用指定的默认格式输出结果      csv,以逗号分隔
    --time, -t			：非交互模式下会打印查询执行的时间
    --stacktrace		：出现异常会打印堆栈跟踪信息
    --config-file		：配置文件名称
```

#### 1.2 ClickHouse 使用指南

> 来源：https://clickhouse.tech/docs/zh/getting-started/tutorial/

##### **1.2.1 ClickHouse 单机使用**  

- 常用脚本

```sql
show database;    --- 查看所有数据库
use [数据库名称]    --- 使用某个数据库
show tables;      --- 查看该库下的所有表
desc [TableName]  --- 查看表结构
```

- 创建数据库

  ```sql
  CREATE DATABASE IF NOT EXISTS wxw
  ```

- 创建表

  ```sql
  CREATE TABLE wxw.user_info( \
      `user_id` UInt64,       \
      `user_name` String,     \
      `age` Int16,            \
      `birthday` DateTime,    \
      `create_date` Date)     \
  ENGINE = MergeTree()        \
  PARTITION BY toYYYYMM(create_date) \
  ORDER BY (create_date, birthday, intHash32(user_id)) \
  SAMPLE BY intHash32(user_id)
  ```

- 导入数据

  数据导入到ClickHouse是通过[INSERT INTO](https://clickhouse.tech/docs/zh/sql-reference/statements/insert-into/)方式完成的，查询类似许多SQL数据库。然而，数据通常是在一个提供[支持序列化格式](https://clickhouse.tech/docs/zh/interfaces/formats/)而不是`VALUES`子句（也支持）。

  ```sql
  INSERT INTO wxw.hits_v1 FORMAT TSV --max_insert_block_size=100000 < hits_v1.tsv
  INSERT INTO table VALUES < data.txt
  ```

- 统计表的数量

  ```sql
  SELECT COUNT(*) from wxw.user_info;
  ```

- 表的参数设置

  **数据导入时设置：**ClickHouse有很多[要调整的设置](https://clickhouse.tech/docs/zh/operations/settings/)在控制台客户端中指定它们的一种方法是通过参数，就像我们看到上面语句中的`--max_insert_block_size`。找出可用的设置、含义及其默认值的最简单方法是查询`system.settings` 表:

  ```sql
  SELECT name, value, changed, description FROM system.settings WHERE name LIKE '%max_insert_b%' FORMAT TSV
  ```

  **数据导入后的设置**：您也可以[OPTIMIZE](https://clickhouse.tech/docs/zh/sql-reference/statements/misc/#misc_operations-optimize)导入后的表。使用MergeTree-family引擎配置的表总是在后台合并数据部分以优化数据存储（或至少检查是否有意义）。 这些查询强制表引擎立即进行存储优化，而不是稍后一段时间执行:

  ```sql
  OPTIMIZE TABLE wxw.user_info FINAL
  ```

- 查看创建表的语句

  ```sql
   show create user_info;
  ```

  ![image-20210430114853861](asserts/image-20210430114853861.png) 

##### **1.2.2 ClickHouse 集群部署** 

ClickHouse集群是一个同质集群。 设置步骤:

1. 在群集的所有机器上安装ClickHouse服务端
2. 在配置文件中设置群集配置
3. 在每个实例上创建本地表
4. 创建一个[分布式表](https://clickhouse.tech/docs/zh/engines/table-engines/special/distributed/) 

[分布式表](https://clickhouse.tech/docs/zh/engines/table-engines/special/distributed/)实际上是一种`view`，映射到ClickHouse集群的本地表。 从分布式表中执行**SELECT**查询会使用集群所有分片的资源。 您可以为多个集群指定configs，并创建多个分布式表，为不同的集群提供视图。

具有三个分片，每个分片一个副本的集群的示例配置:

```xml
<remote_servers>
    <perftest_3shards_1replicas>
        <shard>
            <replica>
                <host>example-perftest01j.yandex.ru</host>
                <port>9000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>example-perftest02j.yandex.ru</host>
                <port>9000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>example-perftest03j.yandex.ru</host>
                <port>9000</port>
            </replica>
        </shard>
    </perftest_3shards_1replicas>
</remote_servers>
```

为了进一步演示，让我们使用和创建`hits_v1`表相同的`CREATE TABLE`语句创建一个新的本地表，但表名不同:

```sql
CREATE TABLE wxw.hits_local (...) ENGINE = MergeTree() ...
```

创建提供集群本地表视图的分布式表:

```sql
CREATE TABLE wxw.hits_all AS wxw.hits_local
ENGINE = Distributed(perftest_3shards_1replicas, wxw, hits_local, rand());
```

常见的做法是在集群的所有计算机上创建类似的分布式表。 它允许在群集的任何计算机上运行分布式查询。 还有一个替代选项可以使用以下方法为给定的SELECT查询创建临时分布式表[远程](https://clickhouse.tech/docs/zh/sql-reference/table-functions/remote/)表功能。

让我们运行[INSERT SELECT](https://clickhouse.tech/docs/zh/sql-reference/statements/insert-into/)将该表传播到多个服务器。

```sql
INSERT INTO wxw.hits_all SELECT * FROM wxw.hits_v1;
```

```
注意：这种方法不适合大型表的分片。 有一个单独的工具 clickhouse-copier 这可以重新分片任意大表。
```

正如您所期望的那样，如果计算量大的查询使用3台服务器而不是一个，则运行速度快N倍。

在这种情况下，我们使用了具有3个分片的集群，每个分片都包含一个副本。

为了在生产环境中提供弹性，我们建议每个分片应包含分布在多个可用区或数据中心（或至少机架）之间的2-3个副本。 请注意，ClickHouse支持无限数量的副本。

包含三个副本的一个分片集群的示例配置:

```xml
<remote_servers>
    ...
    <perftest_1shards_3replicas>
        <shard>
            <replica>
                <host>example-perftest01j.yandex.ru</host>
                <port>9000</port>
             </replica>
             <replica>
                <host>example-perftest02j.yandex.ru</host>
                <port>9000</port>
             </replica>
             <replica>
                <host>example-perftest03j.yandex.ru</host>
                <port>9000</port>
             </replica>
        </shard>
    </perftest_1shards_3replicas>
</remote_servers>
```

启用本机复制[Zookeeper](https://zookeeper.apache.org/)是必需的。 ClickHouse负责所有副本的数据一致性，并在失败后自动运行恢复过程。建议将ZooKeeper集群部署在单独的服务器上（其中没有其他进程，包括运行的ClickHouse）。

ZooKeeper位置在配置文件中指定:

```xml
<zookeeper>
    <node>
        <host>zoo01.yandex.ru</host>
        <port>2181</port>
    </node>
    <node>
        <host>zoo02.yandex.ru</host>
        <port>2181</port>
    </node>
    <node>
        <host>zoo03.yandex.ru</host>
        <port>2181</port>
    </node>
</zookeeper>
```

此外，我们需要设置宏来识别每个用于创建表的分片和副本:

```xml
<macros>
    <shard>01</shard>
    <replica>01</replica>
</macros>
```

如果在创建复制表时没有副本，则会实例化新的第一个副本。 如果已有实时副本，则新副本将克隆现有副本中的数据。 

- 您可以选择首先创建所有复制的表，然后向其中插入数据。 
- 另一种选择是创建一些副本，并在数据插入之后或期间添加其他副本。

```sql
CREATE TABLE wxw.hits_replica (...)
ENGINE = ReplcatedMergeTree(
    '/clickhouse_perftest/tables/{shard}/hits',
    '{replica}'
)
...
```

在这里，我们使用[ReplicatedMergeTree](https://clickhouse.tech/docs/zh/engines/table-engines/mergetree-family/replication/)表引擎。 在参数中，我们指定包含分片和副本标识符的ZooKeeper路径。

```sql
INSERT INTO wxw.hits_replica SELECT * FROM wxw.hits_local;
```

复制在多主机模式下运行。数据可以加载到任何副本中，然后系统自动将其与其他实例同步。复制是异步的，因此在给定时刻，并非所有副本都可能包含最近插入的数据。至少应该有一个副本允许数据摄入。另一些则会在重新激活后同步数据并修复一致性。请注意，这种方法允许最近插入的数据丢失的可能性很低。

### 2.ClickHouse SQL 参考

> 来源：https://clickhouse.tech/docs/zh/sql-reference/syntax/

#### 2.1 SQL 语法概述

**CH有2类解析器**：

- 完整SQL解析器（递归式解析器）
- 数据格式解析器（快速流式解析器）

```sql
INSERT INTO t VALUES (1, 'Hello, world'), (2, 'abc'), (3, 'def');
```

含`INSERT INTO t VALUES` 的部分由完整SQL解析器处理，包含数据的部分 `(1, 'Hello, world'), (2, 'abc'), (3, 'def')` 交给快速流式解析器解析。

**空字符** 

- sql语句中（包含sql的起始和结束）可以有任意的空字符，这些空字符类型包括：空格字符，tab制表符，换行符，CR符，换页符等。

**注释** 

CH支持SQL风格或C语言风格的注释：

- SQL风格的注释以 `--` 开始，直到行末，`--` 后紧跟的空格可以忽略
- C语言风格的注释以 `/*` 开始，以 `*/` 结束，支持多行形式，同样可以省略 `/*` 后的空格 

#### 2.2 语句

**Alter 列相关操作**   

 `ALTER` 仅支持 `*MergeTree` ，`Merge`以及`Distributed`等引擎表。

```sql
-- 修改列名称
ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name
```

#### 2.3 函数

#### 2.4 聚合函数

#### 2.5 表函数

#### 2.6 字典

#### 2.7 数据类型

### 3. SpringBoot引入ClickHouse

#### 3.1 ClickHouse JDBC驱动

- Github地址：https://github.com/ClickHouse/clickhouse-jdbc

> ` pom.xml ` 依赖

```xml
<dependency>
    <groupId>ru.yandex.clickhouse</groupId>
    <artifactId>clickhouse-jdbc</artifactId>
    <version>0.3.0</version>
</dependency>
```

#### 3.2 接入Spring Boot 配置



### 常见问题

**1.clickhouse入库操作时，报错SQLFeatureNotSupportedException,InvalidDataAccessApiUsageException** 

 clickhouse  有自增主键，导致我们插入数据时，无法指定主键进行插入数据，所以需要在mybatis中设置忽略主键插入。 [查看更多](https://blog.csdn.net/wllove99/article/details/116132016) 

```xml
在mapper中设置 <insert id="" useGeneratedKeys="false">
```







