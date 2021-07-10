> #### [Nacos 入门文档](https://nacos.io)  <!-- {docsify-ignore} -->   



### Nacos 概览

> 一个更易于构建云原生应用的动态服务发现、配置管理和服务管理平台。

[![Gitter](https://camo.githubusercontent.com/c17905400d4e5faef3b71b784d87b66ce31fa98e/68747470733a2f2f6261646765732e6769747465722e696d2f616c69626162612f6e61636f732e737667)](https://gitter.im/alibaba/nacos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) [![License](https://camo.githubusercontent.com/8cb994f6c4a156c623fe057fccd7fb7d7d2e8c9b/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d417061636865253230322d3445423142412e737667)](https://www.apache.org/licenses/LICENSE-2.0.html) [![Gitter](https://camo.githubusercontent.com/192a6c600894b5d37fce00fd6a5d746a23bbe27f/68747470733a2f2f7472617669732d63692e6f72672f616c69626162612f6e61636f732e7376673f6272616e63683d6d6173746572)](https://travis-ci.org/alibaba/nacos)

- [Nacos 官网文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)  
- [Nacos 源码github](https://github.com/alibaba/nacos)   

#### 1.1 应用领域

- [Kubernetes Service](https://kubernetes.io/docs/concepts/services-networking/service/) 
- [gRPC](https://grpc.io/docs/guides/concepts.html#service-definition) & [Dubbo RPC Service](https://dubbo.incubator.apache.org/) 
- [Spring Cloud RESTful Service](https://spring.io/understanding/REST) 

#### 1.2 Nacos 关键特性

- **服务发现和服务健康监测** 


- **动态配置服务** 


- **动态 DNS 服务** 
- **服务及其元数据管理** 

更多特性及发展：[传送门](https://nacos.io/zh-cn/docs/roadmap.html) 

#### 1.3 Nacos 2.0 

主要关注在统一服务管理、服务共享及服务治理体系的开放的服务平台的建设上，主要包括两个方面:

- Dubbo 4.0 + Nacos 2.0 开放的服务平台

![Screen Shot 2018-07-11 at 22.32.17.png](https://cdn.yuque.com/lark/0/2018/png/15914/1531319724777-d19b0304-535c-4af9-bee1-f358b6e55d91.png)

- Kubernetes + Spring Cloud 统一服务管理

![Screen Shot 2018-07-11 at 22.35.30.png](https://cdn.yuque.com/lark/0/2018/png/15914/1531319755930-0040e67e-ca05-47b9-9cd0-07ffd7452eae.png)

#### 1.4 Nacos 生态

![nacos_landscape.png](https://cdn.nlark.com/lark/0/2018/png/11189/1533045871534-e64b8031-008c-4dfc-b6e8-12a597a003fb.png)

如 Nacos 全景图所示，Nacos 无缝支持一些主流的开源生态，例如

- [Spring Cloud](https://nacos.io/en-us/docs/quick-start-spring-cloud.html)
- [Apache Dubbo and Dubbo Mesh](https://nacos.io/zh-cn/docs/use-nacos-with-dubbo.html)
- [Kubernetes and CNCF](https://nacos.io/zh-cn/docs/use-nacos-with-kubernetes.html)。

关于如何在这些生态中使用 Nacos，请参考以下文档：

### Nacos 实践

- [Nacos与Spring Cloud一起使用](https://nacos.io/zh-cn/docs/use-nacos-with-springcloud.html)
- [Nacos与Kubernetes一起使用](https://nacos.io/zh-cn/docs/use-nacos-with-kubernetes.html)
- [Nacos与Dubbo一起使用](https://nacos.io/zh-cn/docs/use-nacos-with-dubbo.html)
- [Nacos与gRPC一起使用](https://nacos.io/zh-cn/docs/roadmap.html)
- [Nacos与Istio一起使用](https://nacos.io/zh-cn/docs/use-nacos-with-istio.html)

#### 2.1 基本使用

> **启动服务** 

- Linux/Unix/Mac

启动命令(standalone代表着单机模式运行，非集群模式):

`sh startup.sh -m standalone`

如果您使用的是ubuntu系统，或者运行脚本报错提示[[符号找不到，可尝试如下运行：

`bash startup.sh -m standalone`

- Windows

启动命令(standalone代表着单机模式运行，非集群模式):

`cmd startup.cmd -m standalone`

> **服务注册&发现和配置管理** 

- 服务注册

```php
curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
```

- 服务发现

```php
curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName'
```

- 发布配置

```php
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=HelloWorld"
```

- 获取配置

```
curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
```

> **关闭服务器**

- Linux/Unix/Mac

`sh shutdown.sh`

- Windows

`cmd shutdown.cmd`

或者双击shutdown.cmd运行文件。

#### 2.2 控制台手册

[Nacos 控制台](http://console.nacos.io/nacos/index.html)主要旨在于增强对于服务列表，健康状态管理，服务治理，分布式配置管理等方面的管控能力，以便进一步帮助用户降低管理微服务应用架构的成本，将提供包括下列基本功能:

- 服务管理
  - 服务列表及服务健康状态展示
  - 服务元数据存储及编辑
  - 服务流量权重的调整
  - 服务优雅上下线
- 配置管理
  - 多种配置格式编辑
  - 编辑DIFF
  - 示例代码
  - 推送状态查询
  - 配置版本及一键回滚
- 命名空间
- 登录管理

**主页预览** 

> 预览地址：http://127.0.0.1:8848/nacos/index.html    
>
> 用户名/密码：nacos/nacos

**使用手册** 

- 控制台操作手册：[传送门](https://nacos.io/zh-cn/docs/console-guide.html) 

![https://gitee.com/wwxw/image/raw/master/blog/服务端/springcloudalibaba/DD4iyH^ePvHK.png](https://gitee.com/wwxw/image/raw/master/blog/服务端/springcloudalibaba/DD4iyH^ePvHK.png) 



#### 2.3 监控手册

Nacos 0.8.0版本完善了监控系统，支持通过暴露metrics数据接入第三方监控系统监控Nacos运行状态，目前支持prometheus、elastic search和influxdb，下面结合prometheus和grafana如何监控Nacos，官网[grafana监控页面](http://monitor.nacos.io/)。与elastic search和influxdb结合可自己查找相关资料

**普罗米修斯监控** 

- prometheus官网地址：https://prometheus.io
- grafana 官网地址：https://grafana.com

> Prometheus和grafana如何监控Nacos,使用手册地址：https://nacos.io/en-us/docs/monitor-guide.html

**Nacos监控分为三个模块** 

- nacos监视器显示核心监视项目 

![å¾ç](https://img.alicdn.com/tfs/TB1PMpUCQvoK1RjSZFDXXXY3pXa-2832-1584.png)

- nacos细节显示指数变化曲线 

![å¾ç](https://img.alicdn.com/tfs/TB1ZBF4CNjaK1RjSZFAXXbdLFXa-2742-1480.png)

- nacos警报是有关nacos的警报 

![å¾ç](https://img.alicdn.com/tfs/TB1ALlUCFzqK1RjSZFCXXbbxVXa-2742-1476.png)



#### 2.4 服务配置性能测试

**测试目的** 

让大家了解Nacos主要性能负载和容量，以帮助我们更好地管理Nacos性能质量，帮助用户更快地评估Nacos系统负载。

- 相关教程地址：https://nacos.io/en-us/docs/nacos-config-benchmark.html

#### 2.5 服务发现性能测试

**测试目的** 

主要了解Nacos服务发现性能负载和容量，以帮助我们更好地管理Nacos性能质量，帮助用户更快地评估Nacos系统负载。

- 相关教程地址：https://nacos.io/en-us/docs/nacos-naming-benchmark.html

#### 2.6 数据迁移至Nacos

**NacosSync迁移用户指南** 

- 启动NacosSync服务
- 通过一个简单的示例，演示了如何向迁移Nacos的Zookeeper Dubbo客户端注册。

> 具体迁移流程：https://nacos.io/en-us/docs/nacos-sync-use.html



### 常见问题

1. nacos [启动默认是集群模式，设置为单机默认](https://www.cnblogs.com/dingzt/p/13666101.html) 











