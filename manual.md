
## 项目wxw-document部署手册


## 前言

本项目是基于 [Docsify](https://docsify.js.org/#/?id=docsify) 技术生成的静态文档网站。

Docsify 是一个动态生成文档网站的工具。不同于 GitBook、Hexo 的地方是它不会生成将 .md 转成 .html 文件，所有转换工作都是在运行时进行，也不会因为生成的一堆 .html 文件“污染” commit 记录，非常实用。

## 环境准备
（1）安装前提
安装前需要具备的环境基础
1. 安装了node
2. 安装了npm

（2）安装脚手架工具 docsify-cli

```bash
$ npm i docsify-cli -g
```

## 使用手册
```bash
// 初始化文档
$ docsify init docs

// 启动本地服务预览
$ docsify serve docs

```
## 相关资料

1. [docsify官网文档](https://docsify.js.org/#/?id=docsify)







