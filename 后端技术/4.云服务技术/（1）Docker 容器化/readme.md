### Docker 技术

---

### 一、Docker 入门

- 官网文档：https://docs.docker.com/v18.09/get-started/
- 学习教程：https://www.runoob.com/docker/windows-docker-install.html
- docker论坛：https://www.docker.org.cn/book/
- docker 镜像加速地址：https://www.runoob.com/docker/docker-mirror-acceleration.html

#### （1）环境准备

> docker 是基于 unix 开发的系列工具，所以在 windows 上安装 docker 非常容易出现环境不兼容的问题。

- 如果 windows 版本是 pro，一般是可以直接安装 docker for desktop 的。

-  如果是 windows home 版本。有 2 种方式解决，第一种方式是通过 docker toolbox, 第二种方式通过 wsl2。本文介绍第一种方式。


**过程记录**：

1. 下载 docker toolbox。

   阿里云提供了镜像，下载会比较快，直接访问 http://mirrors.aliyun.com/docker-toolbox/windows/docker-toolbox/ 下载。

2. 检查是否开启了 windows 的虚拟化技术。