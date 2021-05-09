## Python3  基础



[![CPython build status on Travis CI](https://camo.githubusercontent.com/6622f53d0bab2594fbc041870e4aa79cd7dcba27/68747470733a2f2f7472617669732d63692e636f6d2f707974686f6e2f63707974686f6e2e7376673f6272616e63683d6d6173746572)](https://travis-ci.com/python/cpython) [![CPython build status on GitHub Actions](https://github.com/python/cpython/workflows/Tests/badge.svg) [![CPython code coverage on Codecov](https://camo.githubusercontent.com/8d830fe82af43496cf4e3c635576df2dc324f266/68747470733a2f2f636f6465636f762e696f2f67682f707974686f6e2f63707974686f6e2f6272616e63682f6d61737465722f67726170682f62616467652e737667)](https://codecov.io/gh/python/cpython)                                             



## Python 概述

Python是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。

- Python 官方文档：https://docs.python.org/zh-cn/3

> 程序指的就是一系列指令，用来告诉计算机做什么，而编写程序的关键在于，我们需要用计算机可以理解的语言来提供这些指令。

### 1.1 编译型语言和解释型语言

> 一句话理解：编译型语言需要两步，先编译，然后解析成机器码供计算机执行，解释型语言是通过解析器直接解析为机器码供计算机执行，但是依赖解释器

 计算机是不能理解高级语言的，更不能直接执行高级语言，它只能直接理解机器语言，所以使用任何高级语言编写的程序若想被计算机运行，都必须将其转换成计算机语言，也就是机器码。

![](https://gitee.com/wwxw/image/raw/master/blog/Python/LIRAqIRI)

计算机是不能理解高级语言的，更不能直接执行高级语言，它只能直接理解机器语言，所以使用任何高级语言编写的程序若想被计算机运行，都必须将其转换成计算机语言，也就是机器码。而这种转换的方式有两种：

1. 编译
2. 解释

由此，高级语言也分为编译型语言和解释型语言，主要区别在于，编译型语言在源程序编译后即可在该平台运行，解释型语言是在运行期间才编译，所以编译型语言运行速度快，解释型语言跨平台性好。

#### （1）**编译型语言** 

 在编译型语言写的程序执行之前，需要一个专门的编译过程，把源代码编译成机器语言的文件，如exe格式的文件，以后要再运行时，直接使用编译结果即可，如直接运行exe文件。因为只需编译一次，以后运行时不需要编译，所以编译型语言执行效率高。

**特点** 

1. 一次性的编译成平台相关的机器语言文件，运行时脱离开发环境，运行效率高；
2. 与特定平台相关，一般无法移植到其他平台；
3. 现有的Go、C、C++、Objective等都属于编译型语言。

#### （2）**解释型语言** 

解释型语言不需要事先编译，其直接将源代码解释成机器码并立即执行，所以只要某一平台提供了相应的解释器即可运行该程序。

**特点**

1. 解释型语言每次运行都需要将源代码解释称机器码并执行，效率较低；
2. 只要平台提供相应的解释器，就可以运行源代码，所以可以方便源程序移植；
3. Python/JavaScript / Perl /Shell 等属于解释型语言。

> **编译型与解释型，两者各有利弊** 

1. 编译语言：由于程序执行速度快，同等条件下对系统要求较低，因此像开发操作系统、大型应用程序、数据库系统等时都采用它，像C/C++、Pascal/Object Pascal（Delphi）等都是编译语言

2. 解释性语言：网页脚本、服务器脚本及辅助开发接口这样的对速度要求不高、对不同系统平台间的兼容性有一定要求的程序则通常使用解释性语言，如Java、JavaScript、VBScript、Perl、Python、Ruby、MATLAB，C# 等等。(Java是先编译成class文件，然后在运行时解释class文件为计算机可识别的机器码)

#### （3）关于Java

> Java和其他的语言不太一样。因为java针对不同的平台有不同的JVM，实现了跨平台。所以Java语言有一次编译到处运行的说法。

1. **你可以说它是编译型的：**因为所有的Java代码都是要编译的，.java不经过编译就什么用都没有。 

2. **你可以说它是解释型的：**因为java代码编译后不能直接运行，它是解释运行在JVM上的，所以它是解释运行的，那也就算是解释的了。 

但是，现在的JVM为了效率，都有一些JIT优化。它又会把.class的二进制代码编译为本地的代码直接运行，**所以，又是编译的。**

![](https://gitee.com/wwxw/image/raw/master/blog/Python/nThaSt9dUd9Y.png) 

解释器解释到不同平台

![](https://gitee.com/wwxw/image/raw/master/blog/Python/zepL360KvFPh.png) 

> **Java 小结**

java是解释型的语言，因为虽然java也需要编译，编译成.class文件，但是并不是机器可以识别的语言，而是字节码，最终还是需要 jvm的解释，才能在各个平台执行，这同时也是java跨平台的原因。

所以，可以说Java既是编译型语言，也是解释型语言。

### 1.2  关于 Python  

> 人生苦短，我用Python

[Python](http://c.biancheng.net/python/) 是一种面向对象的、解释型的、通用的、开源的脚本编程语言，它之所以非常流行，我认为主要有三点原因：

1. Python 简单易用，学习成本低，看起来非常优雅干净；
2. Python 标准库和第三库众多，功能强大，既可以开发小工具，也可以开发企业级应用；
3. Python 站在了人工智能和大数据的风口上，站在风口上，猪都能飞起来。

举个简单的例子来说明一下 Python 的简单。比如要实现某个功能，C语言可能需要 100 行代码，而 Python 可能只需要几行代码，因为C语言什么都要得从头开始，而 Python 已经内置了很多常见功能，我们只需要导入包，然后调用一个函数即可。

简单就是 Python 的巨大魅力之一，是它的杀手锏，用惯了 Python 再用C语言简直不能忍受。

本文就来汇总一下 Python 的特性，综合对比一下它的优缺点。  

#### （1）Python 的优点

**语法简单**

和传统的 C/[C++](http://c.biancheng.net/cplus/)[Java](http://c.biancheng.net/java/)[C#](http://c.biancheng.net/csharp/)

- Python 不要求在每个语句的最后写分号，当然写上也没错；
- 定义变量时不需要指明类型，甚至可以给同一个变量赋值不同类型的数据。

伪代码（Pseudo Code）是一种算法描述语言，它介于自然语言和编程语言之间，使用伪代码的目的是为了使被描述的算法可以容易地以任何一种编程语言（Pascal，C，Java，etc）实现。因此，伪代码必须结构清晰、代码简单、可读性好，并且类似自然语言。

如果你学过[数据结构](http://c.biancheng.net/data_structure/)，阅读过严蔚敏的书籍，那你一定知道什么是伪代码。

为什么说简单就是杀手锏？一旦简单了，一件事情就会变得很纯粹；我们在开发 Python 程序时，可以专注于解决问题本身，而不用顾虑语法的细枝末节。在简单的环境中做一件纯粹的事情，那简直是一种享受。

 **Python 是开源** 

开源，也即开放源代码，意思是所有用户都可以看到源代码。

> ① 程序员使用 Python 编写的代码是开源的。
>
> ② Python 解释器和模块是开源的。

这个世界上总有那么一小撮人，他们或者不慕名利，或者为了达到某种目的，会不断地加强和改善 Python。千万不要认为所有人都是只图眼前利益的，总有一些精英会放长线钓大鱼，总有一些极客会做一些炫酷的事情。

**Python 是免费的** 

开源并不等于免费，开源软件和免费软件是两个概念，只不过大多数的开源软件也是免费软件；Python 就是这样一种语言，它既开源又免费。

如果你想区分开源和免费的概念，请猛击：[开源就等于免费吗？用事实来说话](http://c.biancheng.net/view/vip_5041.html)

用户使用 Python 进行开发或者发布自己的程序，不需要支付任何费用，也不用担心版权问题，即使作为商业用途，Python 也是免费的。

 **Python 是高级语言** 

这里所说的高级，是指 Python 封装较深，屏蔽了很多底层细节，比如 Python 会自动管理内存（需要时自动分配，不需要时自动释放）。
高级语言的优点是使用方便，不用顾虑细枝末节；缺点是容易让人浅尝辄止，知其然不知其所以然。解释型语言一般都是跨平台的（可移植性好），Python 也不例外，我们已经在《》中进行了讲解，这里不再赘述。

**Python 是面向对象的编程语言** 

面向对象是现代编程语言一般都具备的特性，否则在开发中大型程序时会捉襟见肘。
Python 支持面向对象，但它不强制使用面向对象。Java 是典型的面向对象的编程语言，但是它强制必须以类和对象的形式来组织代码。

**Python 功能强大（模块众多）** 

Python 的模块众多，基本实现了所有的常见的功能，从简单的字符串处理，到复杂的 3D 图形绘制，借助 Python 模块都可以轻松完成。
Python 社区发展良好，除了 Python 官方提供的核心模块，很多第三方机构也会参与进来开发模块，这其中就有 Google、Facebook、Microsoft 等软件巨头。即使是一些小众的功能，Python 往往也有对应的开源模块，甚至有可能不止一个模块。

 **Python 可扩展性强** 

Python 的可扩展性体现在它的模块，Python 具有脚本语言中最丰富和强大的类库，这些类库覆盖了文件 I/O、GUI、网络编程、数据库访问、文本操作等绝大部分应用场景。
这些类库的底层代码不一定都是 Python，还有很多 C/C++ 的身影。当需要一段关键代码运行速度更快时，就可以使用 C/C++ 语言实现，然后在 Python 中调用它们。Python 能把其它语言“粘”在一起，所以被称为“胶水语言”。

#### （2）Python 的缺点

除了上面提到的各种优点，Python 也是有缺点的。

**运行速度慢** 

运行速度慢是解释型语言的通病，Python 也不例外。
Python 速度慢不仅仅是因为一边运行一边“翻译”源代码，还因为 Python 是高级语言，屏蔽了很多底层细节。这个代价也是很大的，Python 要多做很多工作，有些工作是很消耗资源的，比如管理内存。

但是速度慢的缺点往往也不会带来什么大问题。首先是计算机的硬件速度越来越快，多花钱就可以堆出高性能的硬件，硬件性能的提升可以弥补软件性能的不足。

 **代码加密困难** 

不像编译型语言的源代码会被编译成可执行程序，Python 是直接运行源代码，因此对源代码加密比较困难。

> 开源是软件产业的大趋势，传统程序员需要转变观念。

#### （3）增加代码量

增加代码量并不是要我们去盲目地编写代码，如果找不到增加代码量的方向，可以从阅读别人的代码开始。需要注意的是，在阅读他人编写的代码时，要边阅读边思考，多问几个为什么，例如代码为什么要这么写，有什么意图，有没有更简单的方法可以实现等等，必要情况下还可以给代码进行必要的注释。不仅如此，在完全理解他人代码的前提下，还可以试图对代码做修改，实现一些自己的想法。做到这些，才能说明你将别人的代码消化吸收了。

#### （4）Python 应用领域

Python 的应用领域非常广泛，几乎所有大中型互联网企业都在使用 Python 完成各种各样的任务，例如国外的 Google、Youtube、Dropbox，国内的百度、新浪、搜狐、腾讯、阿里、网易、淘宝、知乎、豆瓣、汽车之家、美团等等。

概括起来，Python 的应用领域主要有如下几个。  

> Web 应用开发

Python 经常被用于 Web 开发，尽管目前 [PHP](http://c.biancheng.net/php/) 例如，通过 mod_wsgi 模块，Apache 可以运行用 Python 编写的 Web 程序。Python 定义了 WSGI 标准应用接口来协调 HTTP 服务器与基于 Python 的 Web 程序之间的通信。
![用Python实现的豆瓣网](http://c.biancheng.net/uploads/allimg/190620/1-1Z6201F355I7.jpg)

不仅如此，全球最大的视频网站 Youtube 以及 Dropbox（一款网络文件同步工具）也都是用 Python 开发的。

> 自动化运维

很多操作系统中，Python 是标准的系统组件，大多数 Linux 发行版以及 NetBSD、OpenBSD 和 Mac OS X 都集成了 Python，可以在终端下直接运行 Python。

有一些 Linux 发行版的安装器使用 Python 语言编写，例如 Ubuntu 的 Ubiquity 安装器、Red Hat Linux 和 Fedora 的 Anaconda 安装器等等。

另外，Python 标准库中包含了多个可用来调用操作系统功能的库。例如，通过 pywin32 这个软件包，我们能访问 Windows 的 COM 服务以及其他 Windows API；使用 IronPython，我们能够直接调用 .Net Framework。

- 通常情况下，Python 编写的系统管理脚本，无论是可读性，还是性能、代码重用度以及扩展性方面，都优于普通的 shell 脚本。  

> 人工智能领域

人工智能是项目非常火的一个研究方向，如果要评选当前最热、工资最高的 IT 职位，那么人工智能领域的工程师最有话语权。而 Python 在人工智能领域内的机器学习、神经网络、深度学习等方面，都是主流的编程语言。

可以这么说，基于[大数据](http://c.biancheng.net/big_data/) 分析和深度学习发展而来的人工智能，其本质上已经无法离开 Python 的支持了，原因至少有以下几点：

1. 目前世界上优秀的人工智能学习框架，比如 Google 的 TransorFlow（神经网络框架）、FaceBook 的 PyTorch（神经网络框架）以及开源社区的 Karas 神经网络库等，都是用 Python 实现的；
2. 微软的 CNTK（认知工具包）也完全支持 Python，并且该公司开发的 VS Code，也已经把 Python 作为第一级语言进行支持。
3. Python 擅长进行科学计算和数据分析，支持各种数学运算，可以绘制出更高质量的 2D 和 3D 图像。

> VS Code 是微软推出的一款代码编辑工具（IDE），有关它的下载、安装和使用，后续章节会做详细介绍。

总之，AI 时代的来临，使得 Python 从众多编程语言中脱颖而出，Python 作为 AI 时代头牌语言的位置，基本无人可撼动！

> 网络爬虫

 Python 语言很早就用来编写网络爬虫。Google 等搜索引擎公司大量地使用 Python 语言编写网络爬虫。

从技术层面上将，Python 提供有很多服务于编写网络爬虫的工具，例如 urllib、Selenium 和 BeautifulSoup 等，还提供了一个网络爬虫框架 Scrapy。  

> 科学计算

自 1997 年，NASA 就大量使用 Python 进行各种复杂的科学运算。

并且，和其它解释型语言（如 shell、js、PHP）相比，Python 在数据分析、可视化方面有相当完善和优秀的库，例如 NumPy、SciPy、Matplotlib、pandas 等，这可以满足 Python 程序员编写科学计算程序。  

> 游戏开发

很多游戏使用 [C++](http://c.biancheng.net/cplus/) 编写图形显示等高性能模块，而使用 Python 或 Lua 编写游戏的逻辑。和 Python 相比，Lua 的功能更简单，体积更小；而 Python 则支持更多的特性和数据类型。

除此之外，Python 可以直接调用 Open GL 实现 3D 绘制，这是高性能游戏引擎的技术基础。事实上，有很多 Python 语言实现的游戏引擎，例如 Pygame、Pyglet 以及 Cocos 2d 等。


以上也仅是介绍了 Python 应用领域的“冰山一角”，例如，还可以利用 Pygame  进行游戏编程；用 PIL 和其他的一些工具进行图像处理；用 PyRo 工具包进行机器人控制编程，等等。有兴趣的读者，可自行搜索资料进行详细了解。

#### （5）Python 环境

- Python2和Python3 的区别：[快速访问](http://c.biancheng.net/view/4147.html) 
- Python 环境准备：[快速访问](http://c.biancheng.net/python/explore/) 

#### （6）Python 编码规范

1. 每个 import 语句只导入一个模块，尽量避免一次导入多个模块

   ```python
   #推荐
   import os
   import sys
   #不推荐
   import os,sys
   ```

2. 不要在行尾添加分号，也不要用分号将两条命令放在同一行

   ```python
   #不推荐
   height=float(input("输入身高：")) ; weight=fioat(input("输入体重：")) ;
   ```

3. 建议每行不超过 80 个字符，如果超过，建议使用小括号将多行内容隐式的连接起来，而不推荐使用反斜杠 \ 进行连接。例如，如果一个字符串文本无法实现一行完全显示，则可以使用小括号将其分开显示.

   ```python
   #推荐
   s=("C语言中文网是中国领先的C语言程序设计专业网站，"
   "提供C语言入门经典教程、C语言编译器、C语言函数手册等。")
   #不推荐
   s="C语言中文网是中国领先的C语言程序设计专业网站，\
   提供C语言入门经典教程、C语言编译器、C语言函数手册等。"
   ```

   注意，此编程规范适用于绝对大多数情况，但以下 2 种情况除外：

   - 导入模块的语句过长。
   - 注释里的 URL。

4. 用必要的空行可以增加代码的可读性，通常在顶级定义（如函数或类的定义）之间空两行，而方法定义之间空一行，另外在用于分隔某些功能的位置也可以空一行

5. 通常情况下，在运算符两侧、函数参数之间以及逗号两侧，都建议使用空格进行分隔。

#### （7）Python 关键字（保留字） 

保留字是 [Python](http://c.biancheng.net/python/) 语言中一些已经被赋予特定意义的单词，这就要求开发者在开发程序时，不能用这些保留字作为标识符给变量、函数、类、模板以及其他对象命名。

Python 包含的保留字可以执行如下命令进行查看：

```python
>>> import keyword
>>> keyword.kwlist
['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']
```

所有的保留字：

| and   | as   | assert | break    | class  | continue |
| ----- | ---- | ------ | -------- | ------ | -------- |
| def   | del  | elif   | else     | except | finally  |
| for   | from | False  | global   | if     | import   |
| in    | is   | lambda | nonlocal | not    | None     |
| or    | pass | raise  | return   | try    | True     |
| while | with | yield  |          |        |          |

**需要注意的是**，由于 Python 是**严格区分大小写**的，保留字也不例外。所以，我们可以说 if 是保留字，但 IF 就不是保留字。

在实际开发中，如果使用 Python 中的保留字作为标识符，则解释器会提示“invalid syntax” 的错误信息。

#### （8）Python 内置函数

[Python](http://c.biancheng.net/python/) 解释器自带的函数叫做内置函数，这些函数可以直接使用，不需要导入某个模块。

如果你熟悉 Shell 编程，了解什么是 [Shell 内置命令](http://c.biancheng.net/view/1136.html)，那么你也很容易理解什么是 Python 内置函数，它们的概念是类似的。

> 将使用频繁的代码段封装起来，并给它起一个名字，以后使用的时候只要知道名字就可以，这就是函数。函数就是一段封装好的、可以重复使用的代码，它使得我们的程序更加模块化，不需要编写大量重复的代码。

- Python 3.x 中的所有内置函数

  | 内置函数      |             |              |              |                |
  | ------------- | ----------- | ------------ | ------------ | -------------- |
  | abs()         | delattr()   | hash()       | memoryview() | set()          |
  | all()         | dict()      | help()       | min()        | setattr()      |
  | any()         | dir()       | hex()        | next()       | slicea()       |
  | ascii()       | divmod()    | id()         | object()     | sorted()       |
  | bin()         | enumerate() | input()      | oct()        | staticmethod() |
  | bool()        | eval()      | int()        | open()       | str()          |
  | breakpoint()  | exec()      | isinstance() | ord()        | sum()          |
  | bytearray()   | filter()    | issubclass() | pow()        | super()        |
  | bytes()       | float()     | iter()       | print()      | tuple()        |
  | callable()    | format()    | len()        | property()   | type()         |
  | chr()         | frozenset() | list()       | range()      | vars()         |
  | classmethod() | getattr()   | locals()     | repr()       | zip()          |
  | compile()     | globals()   | map()        | reversed()   | __import__()   |
  | complex()     | hasattr()   | max()        | round()      |                |

表 1 中各个内置函数的具体功能和用法，可通过访问 https://docs.python.org/zh-cn/3/library/functions.html 进行查看。

**注意：** 不要使用内置函数的名字作为标识符使用（例如变量名、函数名、类名、模板名、对象名等），虽然这样做 Python 解释器不会报错，但这会导致同名的内置函数被覆盖，从而无法使用。例如：

```python
>>> print = "http://c.biancheng.net/python/"  #将print作为变量名
>>> print("Hello World!")  #print函数被覆盖，失效
Traceback (most recent call last):
  File "<pyshell#1>", line 1, in <module>
    print("Hello World!")
TypeError: 'str' object is not callable
```

## Python 快速入门

### 1. 前言

```python
python3                   ## 查看是否安装成功。
pip3 install [扩展包名称]   ## 下载python的一些扩展包
pip3 install ipython      ## 自动安装python扩展包
pip3  list                ## 查看当前python环境中安装了哪些扩展包】
```

### 2. 常用语法

#### 2.1 if __name__ == '__main__':的作用和原理

（1）**作用** 

一个python文件通常有两种使用方法，

- 第一是作为脚本直接执行
- 第二是 import 到其他的 python 脚本中被调用（模块重用）执行。

因此 if __name__ == 'main': 的作用就是控制这两种情况执行代码的过程，在 if __name__ == 'main': 下的代码只有在第一种情况下（即文件作为脚本直接执行）才会被执行，而 import 到其他脚本中是不会被执行的。举例说明如下：

```python
if __name__ == '__main__':
```

（2）**原理** 

**每个python模块**（python文件）都包含**内置的变量 __name__**

- 当该模块被**直接执行**的时候，**__name__ 等于文件名（包含后缀 .py ）**；
- 如果该模块 **import** 到其他模块中，**则该模块的 __name__ 等于模块名称（不包含后缀.py）。** 

而 **“__main__” 始终指当前执行模块的名称（包含后缀.py）**。进而当模块被**直接执行**时**，__name__ == 'main' 结果为真。** 



## Python 基础语法

### 2.1 变量类型与运算符



### 2.2 列表、元组、字典和集合



































