

### Linux 简介

Linux 内核最初只是由芬兰人林纳斯·托瓦兹（Linus Torvalds）在赫尔辛基大学上学时出于个人爱好而编写的。

Linux 是一套免费使用和自由传播的类 Unix 操作系统，是一个基于 POSIX 和 UNIX 的多用户、多任务、支持多线程和多 CPU 的操作系统。

Linux 能运行主要的 UNIX 工具软件、应用程序和网络协议。它支持 32 位和 64 位硬件。Linux 继承了 Unix 以网络为核心的设计思想，是一个性能稳定的多用户网络操作系统。

- Linux 入门文档：https://www.runoob.com/linux/linux-intro.html
- Linux 内核文档：https://www.kernel.org/doc/html/latest/index.html
- Linux 命令大全：https://man.linuxde.net/
- Linux 官网手册：https://www.gnu.org/software/bash/manual/bash.html
- Linux 在线读书：https://www.linuxprobe.com/chapter-06.html

#### 1.1 Linux 发行版

> Linux 的发行版说简单点就是将 Linux 内核与应用软件做一个打包。

![](https://www.runoob.com/wp-content/uploads/2014/06/1511849829609658.jpg)

目前市面上较知名的发行版有：Ubuntu、RedHat、CentOS、Debian、Fedora、SuSE、OpenSUSE、Arch Linux、SolusOS 等。

#### 1.2 Linux 应用领域

今天各种场合都有使用各种 Linux 发行版，从嵌入式设备到超级计算机，并且在服务器领域确定了地位，通常服务器使用 LAMP（Linux + Apache + MySQL + PHP）或 LNMP（Linux + Nginx+ MySQL + PHP）组合。目前 Linux 不仅在家庭与企业中使用，并且在政府中也很受欢迎。

### Linux  的启动过程

Linux系统的启动过程，可以分为5个阶段

- 内核的引导。
- 运行 init。
- 系统初始化。
- 建立终端 。
- 用户登录系统。

> init程序的类型：
>
> - **SysV:** init, CentOS 5之前, 配置文件： /etc/inittab。
> - **Upstart:** init,CentOS 6, 配置文件： /etc/inittab, /etc/init/*.conf。
> - **Systemd：** systemd, CentOS 7,配置文件： /usr/lib/systemd/system、 /etc/systemd/system。

#### 2.1 内核引导

当计算机打开电源后，首先是BIOS开机自检，按照BIOS中设置的启动设备（通常是硬盘）来启动。

操作系统接管硬件以后，首先读入 /boot 目录下的内核文件。

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081702.png)

#### 2.2 运行 init

init 进程是系统所有进程的起点，你可以把它比拟成系统所有进程的老祖宗，没有这个进程，系统中任何进程都不会启动。

init 程序首先是需要读取配置文件 /etc/inittab。

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081703.png)

**运行级别** 

许多程序需要开机启动。它们在Windows叫做"服务"（service），在Linux就叫做"守护进程"（daemon）。

init进程的一大任务，就是去运行这些开机启动的程序。

但是，不同的场合需要启动不同的程序，比如用作服务器时，需要启动Apache，用作桌面就不需要。

Linux允许为不同的场合，分配不同的开机启动程序，这就叫做"运行级别"（runlevel）。也就是说，启动时根据"运行级别"，确定要运行哪些程序。

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081704.png)

Linux系统有7个运行级别(runlevel)：

- 运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
- 运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
- 运行级别2：多用户状态(没有NFS)
- 运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
- 运行级别4：系统未使用，保留
- 运行级别5：X11控制台，登陆后进入图形GUI模式
- 运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

#### 2.3 系统初始化

在init的配置文件中有这么一行： si::sysinit:/etc/rc.d/rc.sysinit　它调用执行了/etc/rc.d/rc.sysinit，而rc.sysinit是一个bash shell的脚本，它主要是完成一些系统初始化的工作，rc.sysinit是每一个运行级别都要首先运行的重要脚本。

- 它主要完成的工作有：激活交换分区，检查磁盘，加载硬件模块以及其它一些需要优先执行任务。

```bash
l5:5:wait:/etc/rc.d/rc 5
```

这一行表示以5为参数运行/etc/rc.d/rc，/etc/rc.d/rc是一个Shell脚本，它接受5作为参数，去执行/etc/rc.d/rc5.d/目录下的所有的rc启动脚本，/etc/rc.d/rc5.d/目录中的这些启动脚本实际上都是一些连接文件，而不是真正的rc启动脚本，真正的rc启动脚本实际上都是放在/etc/rc.d/init.d/目录下。

而这些rc启动脚本有着类似的用法，它们一般能接受start、stop、restart、status等参数。

/etc/rc.d/rc5.d/中的rc启动脚本通常是K或S开头的连接文件，对于以 S 开头的启动脚本，将以start参数来运行。

而如果发现存在相应的脚本也存在K打头的连接，而且已经处于运行态了(以/var/lock/subsys/下的文件作为标志)，则将首先以stop为参数停止这些已经启动了的守护进程，然后再重新运行。

这样做是为了保证是当init改变运行级别时，所有相关的守护进程都将重启。

至于在每个运行级中将运行哪些守护进程，用户可以通过chkconfig或setup中的"System Services"来自行设定。

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081705.png)

#### 2.4 建立终端

rc执行完毕后，返回init。这时基本系统环境已经设置好了，各种守护进程也已经启动了。

init接下来会打开6个终端，以便用户登录系统。在inittab中的以下6行就是定义了6个终端：

```bash
1:2345:respawn:/sbin/mingetty tty1
2:2345:respawn:/sbin/mingetty tty2
3:2345:respawn:/sbin/mingetty tty3
4:2345:respawn:/sbin/mingetty tty4
5:2345:respawn:/sbin/mingetty tty5
6:2345:respawn:/sbin/mingetty tty6
```

从上面可以看出在2、3、4、5的运行级别中都将以respawn方式运行mingetty程序，mingetty程序能打开终端、设置模式。

同时它会显示一个文本登录界面，这个界面就是我们经常看到的登录界面，在这个登录界面中会提示用户输入用户名，而用户输入的用户将作为参数传给login程序来验证用户的身份。

#### 2.5 用户登录系统

一般来说，用户的登录方式有三种：

- （1）命令行登录
- （2）ssh登录
- （3）图形界面登录

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081706.png)

对于运行级别为5的图形方式用户来说，他们的登录是通过一个图形化的登录界面。登录成功后可以直接进入 KDE、Gnome 等窗口管理器。

而本文主要讲的还是文本方式登录的情况：当我们看到mingetty的登录界面时，我们就可以输入用户名和密码来登录系统了。

Linux 的账号验证程序是 login，login 会接收 mingetty 传来的用户名作为用户名参数。

然后 login 会对用户名进行分析：如果用户名不是 root，且存在 /etc/nologin 文件，login 将输出 nologin 文件的内容，然后退出。

这通常用来系统维护时防止非root用户登录。只有/etc/securetty中登记了的终端才允许 root 用户登录，如果不存在这个文件，则 root 用户可以在任何终端上登录。

- /etc/usertty文件用于对用户作出附加访问限制，如果不存在这个文件，则没有其他限制。

**图形模式与文字模式的切换** 

Linux预设提供了六个命令窗口终端机让我们来登录。

默认我们登录的就是第一个窗口，也就是tty1，这个六个窗口分别为tty1,tty2 … tty6，你可以按下Ctrl + Alt + F1 ~ F6 来切换它们。

如果你安装了图形界面，默认情况下是进入图形界面的，此时你就可以按Ctrl + Alt + F1 ~ F6来进入其中一个命令窗口界面。

当你进入命令窗口界面后再返回图形界面只要按下Ctrl + Alt + F7 就回来了。

如果你用的vmware 虚拟机，命令窗口切换的快捷键为 Alt + Space + F1~F6. 如果你在图形界面下请按Alt + Shift + Ctrl + F1~F6 切换至命令窗口。

![img](https://www.runoob.com/wp-content/uploads/2014/06/bg2013081707.png)

#### 2.6 Linux 关机

在linux领域内大多用在服务器上，很少遇到关机的操作。毕竟服务器上跑一个服务是永无止境的，除非特殊情况下，不得已才会关机。

正确的关机流程为：sync > shutdown > reboot > halt

关机指令为：shutdown ，你可以man shutdown 来看一下帮助文档。

例如你可以运行如下命令关机：

``` css
sync 将数据由内存同步到硬盘中。
shutdown 关机指令，你可以man shutdown 来看一下帮助文档。例如你可以运行如下命令关机：
shutdown –h 10 ‘This server will shutdown after 10 mins’ 这个命令告诉大家，计算机将在10分钟后关机，并且会显示在登陆用户的当前屏幕中。
shutdown –h now 立马关机
shutdown –h 20:25 系统会在今天20:25关机
shutdown –h +10 十分钟后关机
shutdown –r now 系统立马重启
shutdown –r +10 系统十分钟后重启
reboot 就是重启，等同于 shutdown –r now
halt 关闭系统，等同于shutdown –h now 和 poweroff
```

最后总结一下，不管是重启系统还是关闭系统，首先要运行 **sync** 命令，把内存中的数据写到磁盘中。

关机的命令有 **shutdown –h now halt poweroff** 和 **init 0** , 重启系统的命令有 **shutdown –r now reboot init 6**。

### Linux 系统目录结构

树状目录结构：

![img](https://www.runoob.com/wp-content/uploads/2014/06/d0c50-linux2bfile2bsystem2bhierarchy.jpg)

**目录解释** 

1.  ` /bin` 

   bin 是 Binaries (二进制文件) 的缩写, 这个目录存放着最经常使用的命令。

2. ` /boot` 

   这里存放的是启动 Linux 时使用的一些核心文件，包括一些连接文件以及镜像文件，(Linux 内核文件)

3. ` /dev` 

   dev 是 Device(设备) 的缩写, 该目录下存放的是 Linux 的外部设备，在 Linux 中访问设备的方式和访问文件的方式是相同的。
   
4.  ` /etc` 

    etc 是 Etcetera(等等) 的缩写,这个目录用来存放所有的系统管理所需要的**配置文件**和**子目录**。

5.  ` /home` 

    用户的主目录，在 Linux 中，每个用户都有一个自己的目录，一般该目录名是以用户的账号命名的，如上图中的 alice、bob 和 eve。

6.  ` /lib` 

    lib 是 Library(库) 的缩写这个目录里存放着系统最基本的动态连接共享库，其作用类似于 Windows 里的 DLL 文件。几乎所有的应用程序都需要用到这些共享库。

7.  ` /lost+found` 

    这个目录一般情况下是空的，当系统非法关机后，这里就存放了一些文件。

8.  ` /media` 

    linux 系统会自动识别一些设备，例如U盘、光驱等等，当识别后，Linux 会把识别的设备挂载到这个目录下。

9.  ` /mnt` 

    系统提供该目录是为了让用户临时挂载别的文件系统的，我们可以将光驱挂载在 /mnt/ 上，然后进入该目录就可以查看光驱里的内容了。 

10.  ` /opt` 

     opt 是 optional(可选) 的缩写，这是给主机额外安装软件所摆放的目录。比如你安装一个ORACLE数据库则就可以放到这个目录下。默认是空的。

11.  ` /proc` 

     proc 是 Processes(进程) 的缩写，/proc 是一种伪文件系统（也即虚拟文件系统），存储的是当前内核运行状态的一系列特殊文件，这个目录是一个虚拟的目录，它是系统内存的映射，我们可以通过直接访问这个目录来获取系统信息。

     这个目录的内容不在硬盘上而是在内存里，我们也可以直接修改里面的某些文件，比如可以通过下面的命令来屏蔽主机的ping命令，使别人无法ping你的机器：

     ```bash
     echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
     ```

12. ` /root` 

    该目录为系统管理员，也称作超级权限者的用户主目录。

13. ` /sbin` 

    s 就是 Super User 的意思，是 Superuser Binaries (超级用户的二进制文件) 的缩写，这里存放的是系统管理员使用的系统管理程序。

14. **/selinux**：
     这个目录是 Redhat/CentOS 所特有的目录，Selinux 是一个安全机制，类似于 windows 的防火墙，但是这套机制比较复杂，这个目录就是存放selinux相关的文件的。

15. **/srv**：
     该目录存放一些服务启动之后需要提取的数据。

16. **/sys**：

    这是 Linux2.6 内核的一个很大的变化。该目录下安装了 2.6 内核中新出现的一个文件系统 sysfs 。

    sysfs 文件系统集成了下面3种文件系统的信息：针对进程信息的 proc 文件系统、针对设备的 devfs 文件系统以及针对伪终端的 devpts 文件系统。

    该文件系统是内核设备树的一个直观反映。

    当一个内核对象被创建的时候，对应的文件和目录也在内核对象子系统中被创建。

17. **/tmp**：
    tmp 是 temporary(临时) 的缩写这个目录是用来存放一些临时文件的。

18. **/usr**：
     usr 是 unix shared resources(共享资源) 的缩写，这是一个非常重要的目录，用户的很多应用程序和文件都放在这个目录下，类似于 windows 下的 program files 目录。

19. **/usr/bin：**
    系统用户使用的应用程序。

20. **/usr/sbin：**
    超级用户使用的比较高级的管理程序和系统守护程序。

21. **/usr/src：**
    内核源代码默认的放置目录。

22. **/var**：
    var 是 variable(变量) 的缩写，这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。包括各种日志文件。

23. **/run**：
    是一个临时文件系统，存储系统启动以来的信息。当系统重启时，这个目录下的文件应该被删掉或清除。如果你的系统上有 /var/run 目录，应该让它指向 run。

在 Linux 系统中，有几个目录是比较重要的，平时需要注意不要误删除或者随意更改内部文件。

**/etc**： 上边也提到了，这个是系统中的配置文件，如果你更改了该目录下的某个文件可能会导致系统不能启动。

**/bin, /sbin, /usr/bin, /usr/sbin**: 这是系统预设的执行文件的放置目录，比如 ls 就是在 /bin/ls 目录下的。

值得提出的是，/bin, /usr/bin 是给系统用户使用的指令（除root外的通用户），而/sbin, /usr/sbin 则是给 root 使用的指令。

**/var**： 这是一个非常重要的目录，系统上跑了很多程序，那么每个程序都会有相应的日志产生，而这些日志就被记录到这个目录下，具体在 /var/log 目录下，另外 mail 的预设放置也是在这里。

### Linux 文件管理

#### 4.1 Linux 文件基本属性

Linux 系统是一种典型的多用户系统，不同的用户处于不同的地位，拥有不同的权限。

为了保护系统的安全性，Linux 系统对不同的用户访问同一文件（包括目录文件）的权限做了不同的规定。

在 Linux 中我们通常使用以下两个命令来修改文件或目录的所属用户与权限：

- chown (change ownerp) ： 修改所属用户与组。
- chmod (change mode) ： 修改用户的权限。

下图中通过 chown 来授权用户，通过 chmod 为用户设置可以开门的权限。

![img](https://www.runoob.com/wp-content/uploads/2014/06/1_151733904241.png) 

在 Linux 中我们可以使用 **ll** 或者 **ls –l** 命令来显示一个文件的属性以及文件所属的用户和组，如：

```bash
[root@www /]# ls -l
total 64
dr-xr-xr-x   2 root root 4096 Dec 14  2012 bin
dr-xr-xr-x   4 root root 4096 Apr 19  2012 boot
```

实例中，**bin** 文件的第一个属性用 **d** 表示。**d** 在 Linux 中代表该文件是一个目录文件。

在 Linux 中第一个字符代表这个文件是目录、文件或链接文件等等。

- 当为 **d** 则是目录
- 当为 **-** 则是文件；
- 若是 **l** 则表示为链接文档(link file)；
- 若是 **b** 则表示为装置文件里面的可供储存的接口设备(可随机存取装置)；
- 若是 **c** 则表示为装置文件里面的串行端口设备，例如键盘、鼠标(一次性读取装置)。

接下来的字符中，以三个为一组，且均为 **rwx** 的三个参数的组合。其中， **r** 代表可读(read)、 **w** 代表可写(write)、 **x** 代表可执行(execute)。 要注意的是，这三个权限的位置不会改变，如果没有权限，就会出现减号 **-** 而已。

![img](https://www.runoob.com/wp-content/uploads/2014/06/file-llls22.jpg) 

每个文件的属性由左边第一部分的 10 个字符来确定（如下图）。

![363003_1227493859FdXT](https://www.runoob.com/wp-content/uploads/2014/06/363003_1227493859FdXT.png) 

从左至右用 **0-9** 这些数字来表示。

第 **0** 位确定文件类型，第 **1-3** 位确定属主（该文件的所有者）拥有该文件的权限。

第4-6位确定属组（所有者的同组用户）拥有该文件的权限，第7-9位确定其他用户拥有该文件的权限。

其中，第 **1、4、7** 位表示读权限，如果用 **r** 字符表示，则有读权限，如果用 **-** 字符表示，则没有读权限；

第 **2、5、8** 位表示写权限，如果用 **w** 字符表示，则有写权限，如果用 **-** 字符表示没有写权限；第 **3、6、9** 位表示可执行权限，如果用 **x** 字符表示，则有执行权限，如果用 **-** 字符表示，则没有执行权限。

#### 4.2 Linux 更改文件权限

- **` chgrp:`更改文件属组** 

```bash
chgrp [-R] 属组名 文件名

参数选项
-R：递归更改文件属组，就是在更改某个目录文件的属组时，如果加上-R的参数，那么该目录下的所有文件的属组都会更改。
```

- **chown：更改文件属主，也可以同时更改文件属组** 

```bash
chown [–R] 属主名 文件名
chown [-R] 属主名：属组名 文件名

进入 /root 目录（~）将install.log的拥有者改为bin这个账号：
[root@www ~] cd ~
[root@www ~]# chown bin install.log
[root@www ~]# ls -l
-rw-r--r--  1 bin  users 68495 Jun 25 08:53 install.log

将install.log的拥有者与群组改回为root：
[root@www ~]# chown root:root install.log
[root@www ~]# ls -l
-rw-r--r--  1 root root 68495 Jun 25 08:53 install.log
```

- **chmod：更改文件9个属性** 

Linux 文件属性有两种设置方式：一种是数字，一种是符号

Linux 文件的基本权限有9个：分别是  **owner/group/others(拥有者/组/其他)** 三种身份各有自己的 **read/write/execute** 权限。

> **数字类型改变文件权限** 

先复习一下刚刚上面提到的数据：文件的权限字符为： **-rwxrwxrwx** ， 这九个权限是三个三个一组的！其中，我们可以使用数字来代表各个权限，各权限的分数对照表如下：

```bash
r——4  // 读
w——2  // 写
x——1  // 执行
```

每种身份(owner/group/others)各自的三个权限(r/w/x)分数是需要累加的，例如当权限为： **-rwxrwx---** 分数则是：

- owner = rwx = 4+2+1 = 7
- group = rwx = 4+2+1 = 7
- others= --- = 0+0+0 = 0

所以等一下我们设定权限的变更时，该文件的权限数字就是 **770**。变更权限的指令 chmod 的语法是这样的：

```bash
 chmod [-R] xyz 文件或目录
 
 选项与参数：
    -xyz : 就是刚刚提到的数字类型的权限属性，为 rwx 属性数值的相加。
    -R : 进行递归(recursive)的持续变更，亦即连同次目录下的所有文件都会变更
    
举例来说，如果要将 .bashrc 这个文件所有的权限都设定启用，那么命令如下：

[root@www ~]# ls -al .bashrc
-rw-r--r--  1 root root 395 Jul  4 11:45 .bashrc
[root@www ~]# chmod 777 .bashrc
[root@www ~]# ls -al .bashrc
-rwxrwxrwx  1 root root 395 Jul  4 11:45 .bashrc
```

那如果要将权限变成 *-rwxr-xr--* 呢？那么权限的分数就成为  [4+2+1] [4+0+1] [4+0+0]=754。

> **符号类型改变文件权限** 

还有一个改变权限的方法，从之前的介绍中我们可以发现，基本上就九个权限分别是：

- user：用户
- group：组
- others：其他

那么我们就可以使用 **u, g, o** 来代表三种身份的权限。

此外， **a** 则代表 **all**，即全部的身份。读写的权限可以写成 **r, w, x**，也就是可以使用下表的方式来看：

| chmod | u g o a | +(加入) -(除去) =(设定) | r w x | 文件或目录 |
| ----- | ------- | ----------------------- | ----- | ---------- |
|       |         |                         |       |            |

如果我们需要将文件权限设置为 **-rwxr-xr--** ，可以使用 **chmod u=rwx,g=rx,o=r 文件名** 来设定:

```bash
#  touch test1    // 创建 test1 文件
# ls -al test1    // 查看 test1 默认权限
-rw-r--r-- 1 root root 0 Nov 15 10:32 test1
# chmod u=rwx,g=rx,o=r  test1    // 修改 test1 权限
# ls -al test1
-rwxr-xr-- 1 root root 0 Nov 15 10:32 test1

而如果是要将权限去掉而不改变其他已存在的权限呢？例如要拿掉全部人的可执行权限，则：

#  chmod  a-x test1
# ls -al test1
-rw-r--r-- 1 root root 0 Nov 15 10:32 test1
```

**更多参考** 

- [Linux chgrp 命令](https://www.runoob.com/linux/linux-comm-chgrp.html)
- [Linux chown 命令](https://www.runoob.com/linux/linux-comm-chown.html)
- [Linux chmod 命令](https://www.runoob.com/linux/linux-comm-chmod.html)

#### 4.3 LInux 文件与目录管理

我们知道Linux的目录结构为树状结构，最顶级的目录为根目录 /。

其他目录通过挂载可以将它们添加到树中，通过解除挂载可以移除它们。

- 绝对路径：由根目录 **/** 写起，例如： /usr/share/doc 这个目录。
- 相对路径：不是由 **/** 写起，例如由 /usr/share/doc 要到 /usr/share/man 底下时，可以写成： **cd ../man** 这就是相对路径的写法。

**处理目录的常见命令** 

- ls（英文全拼：list files）: 列出目录及文件名
- cd（英文全拼：change directory）：切换目录
- pwd（英文全拼：print work directory）：显示目前的目录
- mkdir（英文全拼：make directory）：创建一个新的目录
- rmdir（英文全拼：remove directory）：删除一个空的目录
- cp（英文全拼：copy file）: 复制文件或目录
- rm（英文全拼：remove）: 移除文件或目录
- mv（英文全拼：move file）: 移动文件与目录，或修改文件与目录的名称

> 案例分析

```bash
cp (复制文件或目录) 
cp [options] [source] [destination]

用 root 身份，将 root 目录下的 .bashrc 复制到 /tmp 下，并命名为 bashrc
[root@www ~]# cp ~/.bashrc /tmp/bashrc
[root@www ~]# cp -i ~/.bashrc /tmp/bashrc
cp: overwrite `/tmp/bashrc'? n  <==n不覆盖，y为覆盖 
```

```bash
rm （移除文件目录）
rm [-fir] 文件或目录
选项与参数：
-f ：就是 force 的意思，忽略不存在的文件，不会出现警告信息；
-i ：互动模式，在删除前会询问使用者是否动作
-r ：递归删除啊！最常用在目录的删除了！这是非常危险的选项！！！
```

```bash
mv (移动文件与目录、修改名称)
语法：
[root@www ~]# mv [-fiu] source destination
[root@www ~]# mv [options] source1 source2 source3 .... directory
-f ：force 强制的意思，如果目标文件已经存在，不会询问而直接覆盖；
-i ：若目标文件 (destination) 已经存在时，就会询问是否覆盖！
-u ：若目标文件已经存在，且 source 比较新，才会升级 (update)
```

#### 4.4 Linux 文件内容查看

Linux系统中使用以下命令来查看文件的内容：

- cat  由第一行开始显示文件内容
- tac  从最后一行开始显示，可以看出 tac 是 cat 的倒着写！
- nl   显示的时候，顺道输出行号！
- more 一页一页的显示文件内容
- less 与 more 类似，但是比 more 更好的是，他可以往前翻页！
- head 只看头几行
- tail 只看尾巴几行

**less 用法** 

```c#
less运行时可以输入的命令有：

空白键    ：向下翻动一页；
[pagedown]：向下翻动一页；
[pageup]  ：向上翻动一页；
/字串     ：向下搜寻『字串』的功能；
?字串     ：向上搜寻『字串』的功能；
n         ：重复前一个搜寻 (与 / 或 ? 有关！)
N         ：反向的重复前一个搜寻 (与 / 或 ? 有关！)
q         ：离开 less 这个程序；
```

> **Linux 链接的概念** 

Linux 链接分两种，一种被称为硬链接（Hard Link），另一种被称为符号链接（Symbolic Link）。默认情况下，**ln** 命令产生硬链接。

Linux 与其他类 UNIX 系统一样并不区分文件与目录：目录是记录了其他文件名的文件。我们知道文件都有文件名与数据，这在 Linux 上被分成两个部分：用户数据 (user data) 与元数据 (metadata)。

- 用户数据，即文件数据块 (data block)，数据块是记录文件真实内容的地方；
- 元数据，是文件的附加属性，如文件大小、创建时间、所有者等信息。

在 Linux 中，元数据中的 inode 号（inode 是文件元数据的一部分但其并不包含文件名，inode 号即索引节点号）才是文件的唯一标识而非文件名。文件名仅是为了方便人们的记忆和使用，系统或程序通过 inode 号寻找正确的文件数据块。

![image001.jpg](https://segmentfault.com/img/bVHDyF?w=320&h=120)

为解决文件的共享使用，Linux 系统引入了两种链接，Linux系统中提供了两种链接方式：

- 硬链接（Hard Link）
- 软链接（Soft Link），又称符号链接（Symbolic Link）

![图 2. 软链接的访问](https://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/image002.jpg) 

**硬连接**

硬连接指通过索引节点来进行连接。在 Linux 的文件系统中，保存在磁盘分区中的文件不管是什么类型都给它分配一个编号，称为索引节点号(Inode Index)。  若一个 inode 号对应多个文件名，则称这些文件为硬链接。换言之，硬链接就是同一个文件使用了多个别名（上图hard link 就是 file 的一个别名，他们有共同的 inode）

由于硬链接是有着相同 inode 号仅文件名不同的文件，因此硬链接存在以下几点特性：

1. 文件有相同的 inode 及 data block；
2. 只能对已存在的文件进行创建；
3. 不能交叉文件系统进行硬链接的创建；
4. 不能对目录进行创建，只可对文件创建；
5. 删除一个硬链接文件并不影响其他有相同 inode 号的文件。

**软连接**

另外一种连接称之为符号连接（Symbolic Link），也叫软连接。软链接文件有类似于 Windows 的快捷方式。它实际上是一个特殊的文件。在符号连接中，文件实际上是一个文本文件，其中包含的有另一文件的位置信息。软链接与硬链接不同，若文件用户数据块中存放的内容是另一文件的路径名的指向，则该文件就是软连接。软链接就是一个普通文件，只是数据块内容有点特殊。软链接有着自己的 inode 号以及用户数据块。因此软链接的创建与使用没有类似硬链接的诸多限制：

1. 软链接有自己的文件属性及权限等；
2. 可对不存在的文件或目录创建软链接；
3. 软链接可交叉文件系统；
4.  软链接可对文件或目录创建；
5. 创建软链接时，链接计数 i_nlink 不会增加；
6. 删除软链接并不影响被指向的文件，但若被指向的原文件被删除，则相关软连接被称为死链接（即 dangling link，若被指向路径文件被重新创建，死链接可恢复为正常的软链接）。

- ### 通过实验加深理解

```bash
[oracle@Linux]$ touch f1          #创建一个测试文件f1
[oracle@Linux]$ ln f1 f2          #创建f1的一个硬连接文件f2
[oracle@Linux]$ ln -s f1 f3       #创建f1的一个符号连接文件f3
[oracle@Linux]$ ls -li            # -i参数显示文件的inode节点信息
total 0
9797648 -rw-r--r--  2 oracle oinstall 0 Apr 21 08:11 f1
9797648 -rw-r--r--  2 oracle oinstall 0 Apr 21 08:11 f2
9797649 lrwxrwxrwx  1 oracle oinstall 2 Apr 21 08:11 f3 -> f1
```

从上面的结果中可以看出，硬连接文件 f2 与原文件 f1 的 inode 节点相同，均为 9797648，然而符号连接文件的 inode 节点不同。

```bash
[oracle@Linux]$ echo "I am f1 file" >>f1
[oracle@Linux]$ cat f1
I am f1 file
[oracle@Linux]$ cat f2
I am f1 file
[oracle@Linux]$ cat f3
I am f1 file
[oracle@Linux]$ rm -f f1
[oracle@Linux]$ cat f2
I am f1 file
[oracle@Linux]$ cat f3
cat: f3: No such file or directory
```

通过上面的测试可以看出：当删除原始文件 f1 后，硬连接 f2 不受影响，但是符号连接 f1 文件无效

> Linux 链接文件总结

依此您可以做一些相关的测试，可以得到以下全部结论：

-  1).删除符号连接f3,对f1,f2无影响；
-  2).删除硬连接f2，对f1,f3也无影响；
-  3).删除原文件f1，对硬连接f2没有影响，导致符号连接f3失效；
-  4).同时删除原文件f1,硬连接f2，整个文件会真正的被删除。

参考文章：[硬链接和软连接的区别](https://segmentfault.com/a/1190000007977924) 

#### 4.5 Linux 用户和用户组

Linux系统是一个多用户多任务的分时操作系统，任何一个要使用系统资源的用户，都必须首先向系统管理员申请一个账号，然后以这个账号的身份进入系统。

用户的账号一方面可以帮助系统管理员对使用系统的用户进行跟踪，并控制他们对系统资源的访问；另一方面也可以帮助用户组织文件，并为用户提供安全性保护。

每个用户账号都拥有一个唯一的用户名和各自的口令。

用户在登录时键入正确的用户名和口令后，就能够进入系统和自己的主目录。

实现用户账号的管理，要完成的工作主要有如下几个方面：

- 用户账号的添加、删除与修改。
- 用户口令的管理。
- 用户组的管理。

##### （1）**Linux 系统用户账号管理** 

用户账号的管理工作主要涉及到用户账号的添加、修改和删除。

添加用户账号就是在系统中创建一个新账号，然后为新账号分配用户号、用户组、主目录和登录Shell等资源。刚添加的账号是被锁定的，无法使用。

1. 添加账号

   ```bash
   useradd 选项 用户名
   
   -c comment 指定一段注释性描述。
   -d 目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
   -g 用户组 指定用户所属的用户组。
   -G 用户组，用户组 指定用户所属的附加组。
   -s Shell文件 指定用户的登录Shell。 // 登录用户时，默认打开的shell窗口 （默认是 /bin/bash）
   -u 用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。
   ```

   实例

   ```bash
   实例 1
   useradd –d  /home/sam -m sam         # 创建了一个用户sam，其中-d和-m选项用来为登录名sam产生一个主目录 /home/sam（/home为默认的用户主目录所在的父目录）
   
   实例 2 
   useradd -s /bi n/sh -g group –G wxw   
   # 此命令新建了一个用户gem，该用户的登录Shell是 /bin/sh，它属于group用户组，同时又属于adm和root用户组，其中group用户组是其主组。
   # 这里可能新建组：#groupadd group及groupadd adm
   # 增加用户账号就是在/etc/passwd文件中为新用户增加一条记录，同时更新其他系统文件如/etc/shadow, /etc/group等。
   # Linux提供了集成的系统管理工具userconf，它可以用来对用户账号进行统一管理。
   ```

2. 删除账号

   如果一个用户的账号不再使用，可以从系统中删除。删除用户账号就是要将/etc/passwd等系统文件中的该用户记录删除，必要时还删除用户的主目录。

   删除一个已有的用户账号使用`userdel`命令，其格式如下：

   ```bash
   userdel 选项 用户名
   
   实例 1
   userdel -r sam  ## 常用的选项是 -r，它的作用是把用户的主目录一起删除
   此命令删除用户sam在系统文件中（主要是/etc/passwd, /etc/shadow, /etc/group等）的记录，同时删除用户的主目录。
   ```

3. 修改账号

   修改用户账号就是根据实际情况更改用户的有关属性，如用户号、主目录、用户组、登录Shell等。

   修改已有用户的信息使用`usermod`命令，其格式如下：

   ```bash
   usermod 选项 用户名
   ```

常用的选项包括`-c, -d, -m, -g, -G, -s, -u以及-o等`，这些选项的意义与`useradd`命令中的选项一样，可以为用户指定新的资源值。

另外，有些系统可以使用选项：-l 新用户名

这个选项指定一个新的账号，即将原来的用户名改为新的用户名。

```bash
usermod -s /bin/ksh -d /home/z –g developer sam
```

此命令将用户sam的登录Shell修改为ksh，主目录改为/home/z，用户组改为developer。

4. 用户口令的管理

   用户管理的一项重要内容是用户口令的管理。用户账号刚创建时没有口令，但是被系统锁定，无法使用，必须为其指定口令后才可以使用，即使是指定空口令。

   指定和修改用户口令的Shell命令是`passwd`。超级用户可以为自己和其他用户指定口令，普通用户只能用它修改自己的口令。命令的格式为：

   ```bash
   passwd 选项 用户名
   
   可使用的选项：
   -l 锁定口令，即禁用账号。
   -u 口令解锁。
   -d 使账号无口令。
   -f 强迫用户下次登录时修改口令。
   ```

   - 如果默认用户名，则修改当前用户的口令。

    ```bash
   例如，假设当前用户是sam，则下面的命令修改该用户自己的口令：
   $ passwd 
   Old password:****** 
   New password:******* 
   Re-enter new password:*******
    ```

   - 如果是超级用户，可以用下列形式指定任何用户的口令：

   ```bash
   # passwd sam 
   New password:******* 
   Re-enter new password:*******
   ```

   普通用户修改自己的口令时，passwd命令会先询问原口令，验证后再要求用户输入两遍新口令，如果两次输入的口令一致，则将这个口令指定给用户；而超级用户为用户指定口令时，就不需要知道原口令。

   为了系统安全起见，用户应该选择比较复杂的口令，例如最好使用8位长的口令，口令中包含有大写、小写字母和数字，并且应该与姓名、生日等不相同。

   ```bash
   # passwd -d sam
   ```

   此命令将用户 sam 的口令删除，这样用户 sam 下一次登录时，系统就不再允许该用户登录了。

   passwd 命令还可以用 -l(lock) 选项锁定某一用户，使其不能登录，例如：

   ```bash
   # passwd -l sam
   ```

##### （2）Linux 系统用户组管理

每个用户都有一个用户组，系统可以对一个用户组中的所有用户进行集中管理。不同Linux 系统对用户组的规定有所不同，如Linux下的用户属于与它同名的用户组，这个用户组在创建用户时同时创建。

用户组的管理涉及用户组的添加、删除和修改。组的增加、删除和修改实际上就是对/etc/group文件的更新。

1. ### 增加一个新的用户组使用groupadd命令。其格式如下：

```bash
groupadd 选项 用户组

-g GID 指定新用户组的组标识号（GID）。
-o 一般与-g选项同时使用，表示新用户组的GID可以与系统已有用户组的GID相同。

实例 1
groupadd group1 # 此命令向系统中增加了一个新组group1，新组的组标识号是在当前已有的最大组标识号的基础上加1

实例 2
groupadd -g 101 group2 # 此命令向系统中增加了一个新组group2，同时指定新组的组标识号是101。
```

2. ### 如果要删除一个已有的用户组，使用groupdel命令，其格式如下：

```bash
groupdel 用户组

实例 1
groupdel group1  # 此命令从系统中删除组group1。
```

3. ### 修改用户组的属性使用groupmod命令。其语法如下：

```bash
groupmod 选项 用户组

常用的选项有：
   -g GID 为用户组指定新的组标识号。
   -o 与-g选项同时使用，用户组的新GID可以与系统已有用户组的GID相同。
   -n 新用户组 将用户组的名字改为新名字
实例1：
groupmod -g 102 group2  # 此命令将组group2的组标识号修改为102。

实例2：
groupmod –g 10000 -n group3 group2  # 此命令将组group2的标识号改为10000，组名修改为group3。
```

4. 如果一个用户在多个用户组中，那么用户可以在多个用户组之间切换，以便具有其它用户组的权限

```bash
用户可以在登录后，使用命令newgrp切换到其他用户组，这个命令的参数就是目的用户组。例如：
$ newgrp root # 这条命令将当前用户切换到root用户组，前提条件是root用户组确实是该用户的主组或附加组。类似于用户账号的管理，用户组的管理也可以通过集成的系统管理工具来完成。
```

##### （3）与用户账号有关的系统文件

完成用户管理的工作有许多种方法，但是每一种方法实际上都是对有关的系统文件进行修改。

与用户和用户组相关的信息都存放在一些系统文件中，这些文件包括/etc/passwd, /etc/shadow, /etc/group等。

下面分别介绍这些文件的内容。

- **/etc/passwd文件是用户管理工作涉及的最重要的一个文件** 

Linux系统中的每个用户都在/etc/passwd文件中有一个对应的记录行，它记录了这个用户的一些基本属性。

这个文件对所有用户都是可读的。它的内容类似下面的例子：

```bash
＃ cat /etc/passwd

root:x:0:0:Superuser:/:
daemon:x:1:1:System daemons:/etc:
bin:x:2:2:Owner of system commands:/bin:
sys:x:3:3:Owner of system files:/usr/sys:
adm:x:4:4:System accounting:/usr/adm:
uucp:x:5:5:UUCP administrator:/usr/lib/uucp:
auth:x:7:21:Authentication administrator:/tcb/files/auth:
cron:x:9:16:Cron daemon:/usr/spool/cron:
listen:x:37:4:Network daemon:/usr/net/nls:
lp:x:71:18:Printer administrator:/usr/spool/lp:
sam:x:200:50:Sam san:/home/sam:/bin/sh
```

从上面的例子我们可以看到，/etc/passwd中一行记录对应着一个用户，每行记录又被冒号(:)分隔为7个字段，其格式和具体含义如下：

```bash
用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell
```

1. ### "用户名"是代表用户账号的字符串。

   通常长度不超过8个字符，并且由大小写字母和/或数字组成。登录名中不能有冒号(:)，因为冒号在这里是分隔符。

   为了兼容起见，登录名中最好不要包含点字符(.)，并且不使用连字符(-)和加号(+)打头。

2. ### “口令”一些系统中，存放着加密后的用户口令字。

   虽然这个字段存放的只是用户口令的加密串，不是明文，但是由于/etc/passwd文件对所有用户都可读，所以这仍是一个安全隐患。因此，现在许多Linux 系统（如SVR4）都使用了shadow技术，把真正的加密后的用户口令字存放到/etc/shadow文件中，而在/etc/passwd文件的口令字段中只存放一个特殊的字符，例如“x”或者“*”。

3. ### “用户标识号”是一个整数，系统内部用它来标识用户。

   一般情况下它与用户名是一一对应的。如果几个用户名对应的用户标识号是一样的，系统内部将把它们视为同一个用户，但是它们可以有不同的口令、不同的主目录以及不同的登录Shell等。

   通常用户标识号的取值范围是0～65 535。0是超级用户root的标识号，1～99由系统保留，作为管理账号，普通用户的标识号从100开始。在Linux系统中，这个界限是500。

4. ### “组标识号”字段记录的是用户所属的用户组。

   它对应着/etc/group文件中的一条记录。

5. ### “注释性描述”字段记录着用户的一些个人情况。

   例如用户的真实姓名、电话、地址等，这个字段并没有什么实际的用途。在不同的Linux 系统中，这个字段的格式并没有统一。在许多Linux系统中，这个字段存放的是一段任意的注释性描述文字，用做finger命令的输出。

6. ### “主目录”，也就是用户的起始工作目录。

   它是用户在登录到系统之后所处的目录。在大多数系统中，各用户的主目录都被组织在同一个特定的目录下，而用户主目录的名称就是该用户的登录名。各用户对自己的主目录有读、写、执行（搜索）权限，其他用户对此目录的访问权限则根据具体情况设置。

7. ### 用户登录后，要启动一个进程，负责将用户的操作传给内核，这个进程是用户登录到系统后运行的命令解释器或某个特定的程序，即Shell。

   Shell是用户与Linux系统之间的接口。Linux的Shell有许多种，每种都有不同的特点。常用的有sh(Bourne Shell), csh(C Shell), ksh(Korn Shell), tcsh(TENEX/TOPS-20 type C Shell), bash(Bourne Again Shell)等。

   系统管理员可以根据系统情况和用户习惯为用户指定某个Shell。如果不指定Shell，那么系统使用sh为默认的登录Shell，即这个字段的值为/bin/sh。

   用户的登录Shell也可以指定为某个特定的程序（此程序不是一个命令解释器）。

   利用这一特点，我们可以限制用户只能运行指定的应用程序，在该应用程序运行结束后，用户就自动退出了系统。有些Linux 系统要求只有那些在系统中登记了的程序才能出现在这个字段中。

8. ### 系统中有一类用户称为伪用户（pseudo users）。

   这些用户在/etc/passwd文件中也占有一条记录，但是不能登录，因为它们的登录Shell为空。它们的存在主要是方便系统管理，满足相应的系统进程对文件属主的要求。

   常见的伪用户如下所示：

   常见的伪用户如下所示：

   ```bash
   伪 用 户 含 义 
   bin 拥有可执行的用户命令文件 
   sys 拥有系统文件 
   adm 拥有帐户文件 
   uucp UUCP使用 
   lp lp或lpd子系统使用 
   nobody NFS使用
   ```

- **拥有用户文件** 

**1、除了上面列出的伪用户外，还有许多标准的伪用户，例如：audit, cron, mail, usenet等，它们也都各自为相关的进程和文件所需要。**

由于/etc/passwd文件是所有用户都可读的，如果用户的密码太简单或规律比较明显的话，一台普通的计算机就能够很容易地将它破解，因此对安全性要求较高的Linux系统都把加密后的口令字分离出来，单独存放在一个文件中，这个文件是/etc/shadow文件。 有超级用户才拥有该文件读权限，这就保证了用户密码的安全性。

**2、/etc/shadow中的记录行与/etc/passwd中的一一对应，它由pwconv命令根据/etc/passwd中的数据自动产生**

它的文件格式与/etc/passwd类似，由若干个字段组成，字段之间用":"隔开。这些字段是：

```bash
登录名:加密口令:最后一次修改时间:最小时间间隔:最大时间间隔:警告时间:不活动时间:失效时间:标志
```

1. "登录名"是与/etc/passwd文件中的登录名相一致的用户账号
2. "口令"字段存放的是加密后的用户口令字，长度为13个字符。如果为空，则对应用户没有口令，登录时不需要口令；如果含有不属于集合 { ./0-9A-Za-z }中的字符，则对应的用户不能登录。
3. "最后一次修改时间"表示的是从某个时刻起，到用户最后一次修改口令时的天数。时间起点对不同的系统可能不一样。例如在SCO Linux 中，这个时间起点是1970年1月1日。
4. "最小时间间隔"指的是两次修改口令之间所需的最小天数。
5. "最大时间间隔"指的是口令保持有效的最大天数。
6. "警告时间"字段表示的是从系统开始警告用户到用户密码正式失效之间的天数。
7. "不活动时间"表示的是用户没有登录活动但账号仍能保持有效的最大天数。
8. "失效时间"字段给出的是一个绝对的天数，如果使用了这个字段，那么就给出相应账号的生存期。期满后，该账号就不再是一个合法的账号，也就不能再用来登录了。

下面是/etc/shadow的一个例子：

```bash
＃ cat /etc/shadow

root:Dnakfw28zf38w:8764:0:168:7:::
daemon:*::0:0::::
bin:*::0:0::::
sys:*::0:0::::
adm:*::0:0::::
uucp:*::0:0::::
nuucp:*::0:0::::
auth:*::0:0::::
cron:*::0:0::::
listen:*::0:0::::
lp:*::0:0::::
sam:EkdiSECLWPdSa:9740:0:0::::
```

- **用户组的所有信息都存放在/etc/group文件中。** 

将用户分组是Linux 系统中对用户进行管理及控制访问权限的一种手段。

每个用户都属于某个用户组；一个组中可以有多个用户，一个用户也可以属于不同的组。

当一个用户同时是多个组中的成员时，在/etc/passwd文件中记录的是用户所属的主组，也就是登录时所属的默认组，而其他组称为附加组。

用户要访问属于附加组的文件时，必须首先使用newgrp命令使自己成为所要访问的组中的成员。

用户组的所有信息都存放在/etc/group文件中。此文件的格式也类似于/etc/passwd文件，由冒号(:)隔开若干个字段，这些字段有：

```
组名:口令:组标识号:组内用户列表
```

1. "组名"是用户组的名称，由字母或数字构成。与/etc/passwd中的登录名一样，组名不应重复。
2. "口令"字段存放的是用户组加密后的口令字。一般Linux 系统的用户组都没有口令，即这个字段一般为空，或者是*。
3. "组标识号"与用户标识号类似，也是一个整数，被系统内部用来标识组。
4. "组内用户列表"是属于这个组的所有用户的列表/b]，不同用户之间用逗号(,)分隔。这个用户组可能是用户的主组，也可能是附加组。

/etc/group文件的一个例子如下：

```
root::0:root
bin::2:root,bin
sys::3:root,uucp
adm::4:root,adm
daemon::5:root,daemon
lp::7:root,lp
users::20:root,sam
```

##### （4）添加批量用户

添加和删除用户对每位Linux系统管理员都是轻而易举的事，比较棘手的是如果要添加几十个、上百个甚至上千个用户时，我们不太可能还使用useradd一个一个地添加，必然要找一种简便的创建大量用户的方法。Linux系统提供了创建大量用户的工具，可以让您立即创建大量用户，方法如下：

- **先编辑一个文本用户文件** 

每一列按照`/etc/passwd`密码文件的格式书写，要注意每个用户的用户名、UID、宿主目录都不可以相同，其中密码栏可以留做空白或输入x号。一个范例文件user.txt内容如下：

```user.md
user001::600:100:user:/home/user001:/bin/bash
user002::601:100:user:/home/user002:/bin/bash
user003::602:100:user:/home/user003:/bin/bash
user004::603:100:user:/home/user004:/bin/bash
user005::604:100:user:/home/user005:/bin/bash
user006::605:100:user:/home/user006:/bin/bash
```

- **以root身份执行命令 `/usr/sbin/newusers`，从刚创建的用户文件`user.txt`中导入数据，创建用户：** 

```bash
newusers < user.txt
```

然后可以执行命令 `vipw` 或 `vi /etc/passwd` 检查 `/etc/passwd` 文件是否已经出现这些用户的数据，并且用户的宿主目录是否已经创建。

- ### 执行命令/usr/sbin/pwunconv。

将 `/etc/shadow` 产生的 `shadow` 密码解码，然后回写到 `/etc/passwd` 中，并将`/etc/shadow`的`shadow`密码栏删掉。这是为了方便下一步的密码转换工作，即先取消 `shadow password` 功能。

```bash
 pwunconv # 执行pwunconv指令可以关闭用户投影密码，它会把密码从shadow文件内，重回存到passwd文件里。
```

- **编辑每个用户的密码对照文件** 

格式为：

```
用户名:密码
```

实例文件 `passwd.txt` 内容如下：

```
user001:123456
user002:123456
user003:123456
user004:123456
user005:123456
user006:123456
```

- **以 root 身份执行命令 `/usr/sbin/chpasswd`。**

创建用户密码，`chpasswd` 会将经过 `/usr/bin/passwd` 命令编码过的密码写入 `/etc/passwd` 的密码栏。

```
# chpasswd < passwd.txt
```

- **确定密码经编码写入/etc/passwd的密码栏后。** 

执行命令 `/usr/sbin/pwconv` 将密码编码为 `shadow password`，并将结果写入 `/etc/shadow`。

```bash
 pwconv  # 开启用户的投影密码,投影密码将文件内的密码改存在/etc目录下的shadow和gshadow文件内，只允许系统管理者读取，同时把原密码置换为"x"字符，有效的强化了系统的安全性。
```

这样就完成了大量用户的创建了，之后您可以到/home下检查这些用户宿主目录的权限设置是否都正确，并登录验证用户密码是否正确。

### Linux 磁盘管理

Linux磁盘管理好坏直接关系到整个系统的性能问题。

Linux磁盘管理常用三个命令为df、du和fdisk。

- df：列出文件系统的整体磁盘使用量
- du：检查磁盘空间使用量
- fdisk：用于磁盘分区

#### 5.1 ` df` 

检查文件系统的磁盘空间占用情况。可以利用该命令来获取硬盘被占用了多少空间，目前还剩下多少空间等信息。

```shell
df [-ahikHTm] [目录或文件名]

选项与参数：
-a ：列出所有的文件系统，包括系统特有的 /proc 等文件系统；
-k ：以 KBytes 的容量显示各文件系统；
-m ：以 MBytes 的容量显示各文件系统；
-h ：以人们较易阅读的 GBytes, MBytes, KBytes 等格式自行显示；
-H ：以 M=1000K 取代 M=1024K 的进位方式；
-T ：显示文件系统类型, 连同该 partition 的 filesystem 名称 (例如 ext3) 也列出；
-i ：不用硬盘容量，而以 inode 的数量来显示
```

实例

```bash
[root@www ~] df -h /etc 将 /etc  #底下的可用的磁盘容量以易读的容量格式显示
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdc2             9.5G  3.7G  5.4G  41% /
```

#### 5.2 ` du` 

> 与df命令不同的是Linux du命令是对文件和目录磁盘使用的空间的查看

```bash
du [-ahskm] 文件或目录名称

选项与参数：
-a ：列出所有的文件与目录容量，因为默认仅统计目录底下的文件量而已。
-h ：以人们较易读的容量格式 (G/M) 显示；
-s ：列出总量而已，而不列出每个各别的目录占用容量；
-S ：不包括子目录下的总计，与 -s 有点差别。
-k ：以 KBytes 列出容量显示；
-m ：以 MBytes 列出容量显示；
```

实例

```bash
[root@www ~]# du  //只列出当前目录下的所有文件夹容量（包括隐藏文件夹）:
8       ./test4     <==每个目录都会列出来
8       ./test2
....中间省略....
12      ./.gconfd   <==包括隐藏文件的目录
220     .           <==这个目录(.)所占用的总量
```

通配符 * 来代表每个目录。

```bash
# 检查根目录底下每个目录所占用的容量
[root@www ~]# du -sm /*
7       /bin
6       /boot
.....中间省略....
0       /proc
.....中间省略....
1       /tmp
3859    /usr     <==系统初期最大就是他了啦！
77      /var
```

#### 5.3 ` 磁盘的挂载与卸除`  

> Linux 的磁盘挂载使用 `mount` 命令，卸载使用 `umount` 命令。

磁盘挂载语法：

```
mount [-t 文件系统] [-L Label名] [-o 额外选项] [-n]  装置文件名  挂载点
```

实例 1

用默认的方式，将刚刚创建的 /dev/hdc6 挂载到 /mnt/hdc6 上面！

```
[root@www ~]# mkdir /mnt/hdc6
[root@www ~]# mount /dev/hdc6 /mnt/hdc6
[root@www ~]# df
Filesystem           1K-blocks      Used Available Use% Mounted on
.....中间省略.....
/dev/hdc6              1976312     42072   1833836   3% /mnt/hdc6
```

磁盘卸载命令 `umount` 语法：

```bash
umount [-fn] 装置文件名或挂载点

选项与参数：
-f ：强制卸除！可用在类似网络文件系统 (NFS) 无法读取到的情况下；
-n ：不升级 /etc/mtab 情况下卸除。

[root@www ~]# umount /dev/hdc6    # 卸载/dev/hdc6 
```

### Linux 文件系统

- 详情参考文章：https://www.linuxprobe.com/chapter-06.html

用户在硬件存储设备中执行的文件建立、写入、读取、修改、转存与控制等操作都是依靠文件系统来完成的。文件系统的作用是合理规划硬盘，以保证用户正常的使用需求。Linux系统支持数十种的文件系统，而最常见的文件系统如下所示

- **Ext3**：是一款日志文件系统，能够在系统异常宕机时避免文件系统资料丢失，并能自动修复数据的不一致与错误。然而，当硬盘容量较大时，所需的修复时间也会很长，而且也不能百分之百地保证资料不会丢失。它会把整个磁盘的每个写入动作的细节都预先记录下来，以便在发生异常宕机后能回溯追踪到被中断的部分，然后尝试进行修复。

- **Ext4**：Ext3的改进版本，作为RHEL 6系统中的默认文件管理系统，它支持的存储容量高达1EB（1EB=1,073,741,824GB），且能够有无限多的子目录。另外，Ext4文件系统能够批量分配block块，从而极大地提高了读写效率。

- **XFS**：是一种高性能的日志文件系统，而且是RHEL 7中默认的文件管理系统，它的优势在发生意外宕机后尤其明显，即可以快速地恢复可能被破坏的文件，而且强大的日志功能只用花费极低的计算和存储性能。并且它最大可支持的存储容量为18EB，这几乎满足了所有需求。

​      文件的实际内容则保存在block块中（大小可以是1KB、2KB或4KB），一个inode的默认大小仅为128B（Ext3），记录一个block则消耗4B。当文件的inode被写满后，Linux系统会自动分配出一个block块，专门用于像inode那样记录其他block块的信息，这样把各个block块的内容串到一起，就能够让用户读到完整的文件内容了。对于存储文件内容的block块，有下面两种常见情况（以4KB的block大小为例进行说明）。

1. 情况1：文件很小（1KB），但依然会占用一个block，因此会潜在地浪费3KB。

2. 情况2：文件很大（5KB），那么会占用两个block（5KB-4KB后剩下的1KB也要占用一个block）。

计算机系统在发展过程中产生了众多的文件系统，为了使用户在读取或写入文件时不用关心底层的硬盘结构，Linux内核中的软件层为用户程序提供了一个VFS（Virtual File System，虚拟文件系统）接口，这样用户实际上在操作文件时就是统一对这个虚拟文件系统进行操作了。图6-5所示为VFS的架构示意图。从中可见，实际文件系统在VFS下隐藏了自己的特性和细节，这样用户在日常使用时会觉得“文件系统都是一样的”，也就可以随意使用各种命令在任何文件系统中进行各种操作了（比如使用cp命令来复制文件）。

![第6章 存储结构与磁盘划分。第6章 存储结构与磁盘划分。](https://www.linuxprobe.com/wp-content/uploads/2015/02/%E8%99%9A%E6%8B%9F%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9FVFS.png) 



#### 6.1 挂载 硬件设备

我们在用惯了Windows系统后总觉得一切都是理所当然的，平时把U盘插入到电脑后也从来没有考虑过Windows系统做了哪些事情，才使得我们可以访问这个U盘的。接下来我们会逐一学习在Linux系统中挂载和卸载存储设备的方法，以便大家更好地了解Linux系统添加硬件设备的工作原理和流程。前面讲到，在拿到一块全新的硬盘存储设备后要先分区，然后格式化，最后才能挂载并正常使用。“分区”和“格式化”大家以前经常听到，但“挂载”又是什么呢？

- 挂载：当用户需要使用硬盘设备或分区中的数据时，需要先将其与一个已存在的目录文件进行关联，而这个关联动作就是“挂载”

mount命令用于挂载文件系统，格式为“mount 文件系统 挂载目录”。mount命令中可用的参数及作用如表6-3所示。挂载是在使用硬件设备前所执行的最后一步操作。只需使用mount命令把硬盘设备或分区与一个目录文件进行关联，然后就能在这个目录中看到硬件设备中的数据了。对于比较新的Linux系统来讲，一般不需要使用-t参数来指定文件系统的类型，Linux系统会自动进行判断。而mount 中的-a参数则厉害了，它会在执行后自动检查/etc/fstab文件中有无疏漏被挂载的设备文件，如果有，则进行自动挂载操作。

表6-1                                             mount命令中的参数以及作用

| 参数 | 作用                                 |
| ---- | ------------------------------------ |
| -a   | 挂载所有在/etc/fstab中定义的文件系统 |
| -t   | 指定文件系统的类型                   |

实例：

要把设备/dev/sdb2挂载到/backup目录，只需要在mount命令中填写设备与挂载目录参数就行，系统会自动去判断要挂载文件的类型，因此只需要执行下述命令即可：

```bash
[root@linuxprobe ~]# mount /dev/sdb2 /backup
```

虽然按照上面的方法执行mount命令后就能立即使用文件系统了，但系统在重启后挂载就会失效，也就是说我们需要每次开机后都手动挂载一下。这肯定不是我们想要的效果，如果想让硬件设备和目录永久地进行自动关联，就必须把挂载信息按照指定的填写格式“设备文件 挂载目录 格式类型 权限选项 是否备份 是否自检”（各字段的意义见表6-4）写入到/etc/fstab文件中。这个文件中包含着挂载所需的诸多信息项目，一旦配置好之后就能一劳永逸了。

表6-2                        用于挂载信息的指定填写格式中，各字段所表示的意义

| 字段     | 意义                                                         |
| -------- | ------------------------------------------------------------ |
| 设备文件 | 一般为设备的路径+设备名称，也可以写唯一识别码（UUID，Universally Unique Identifier） |
| 挂载目录 | 指定要挂载到的目录，需在挂载前创建好                         |
| 格式类型 | 指定文件系统的格式，比如Ext3、Ext4、XFS、SWAP、iso9660（此为光盘设备）等 |
| 权限选项 | 若设置为defaults，则默认权限为：rw, suid, dev, exec, auto, nouser, async |
| 是否备份 | 若为1则开机后使用dump进行磁盘备份，为0则不备份               |
| 是否自检 | 若为1则开机后自动进行磁盘自检，为0则不自检                   |

如果想将文件系统为ext4的硬件设备/dev/sdb2在开机后自动挂载到/backup目录上，并保持默认权限且无需开机自检，就需要在/etc/fstab文件中写入下面的信息，这样在系统重启后也会成功挂载。

```bash
[root@linuxprobe ~]# vim /etc/fstab
#
# /etc/fstab
# Created by anaconda on Wed May 4 19:26:23 2017
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/rhel-root / xfs defaults 1 1
UUID=812b1f7c-8b5b-43da-8c06-b9999e0fe48b /boot xfs defaults 1 2
/dev/mapper/rhel-swap swap swap defaults 0 0
/dev/cdrom /media/cdrom iso9660 defaults 0 0 
/dev/sdb2 /backup ext4 defaults 0 0
```

umount命令用于撤销已经挂载的设备文件，格式为“umount [挂载点/设备文件]”。我们挂载文件系统的目的是为了使用硬件资源，而卸载文件系统就意味不再使用硬件的设备资源；相对应地，挂载操作就是把硬件设备与目录进行关联的动作，因此卸载操作只需要说明想要取消关联的设备文件或挂载目录的其中一项即可，一般不需要加其他额外的参数。我们来尝试手动卸载掉/dev/sdb2设备文件：

```bash
[root@linuxprobe ~]# umount /dev/sdb2
```

#### 6.2 管理磁盘设备

> **fdisk命令** : 用于管理磁盘分区，格式为“fdisk  [磁盘名称]”，它提供了集添加、删除、转换分区等功能于一身的“一站式分区服务”

#### 6.3 交换分区

SWAP（交换）分区是一种通过在硬盘中预先划分一定的空间，然后将把内存中暂时不常用的数据临时存放到硬盘中，以便腾出物理内存空间让更活跃的程序服务来使用的技术，其设计目的是为了解决真实物理内存不足的问题。但由于交换分区毕竟是通过硬盘设备读写数据的，速度肯定要比物理内存慢，所以只有当真实的物理内存耗尽后才会调用交换分区的资源。

交换分区的创建过程与前文讲到的挂载并使用存储设备的过程非常相似。在对/dev/sdb存储设备进行分区操作前，有必要先说一下交换分区的划分建议：在生产环境中，交换分区的大小一般为真实物理内存的1.5～2倍，为了让大家更明显地感受交换分区空间的变化，这里取出一个大小为5GB的主分区作为交换分区资源。在分区创建完毕后保存并退出即可：



### Linux 常用案例

1. [Linux 忘记密码解决方法](https://www.runoob.com/linux/linux-forget-password.html)  [重启系统 3秒内按回车] 


#### 7.1 创建可访问指定目录的子账号

> 创建/home/wxw/ 为wxw用户可编辑

（1）创建账号 ：` useradd   wxw  ` 

（2）设置密码：` passwd xxxxx ` 

（3）配置develop这个用户目录，为sftp指向目录，即/home/

```powershell
vim /etc/ssh/sshd_config
```

修改配置

```c
//这个记得要在原有的配置文件注释掉
#Subsystem      sftp    /usr/libexec/openssh/sftp-server
 
Subsystem sftp internal-sftp 
Match User develop //develop 是我们要配置的用户
ChrootDirectory /home/  // /home  是我们要指定的目录
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
```

重启sshd服务

```powershell
service sshd restart
chown root:root /home
chown -R wxw:wxw /home/wxw
chmod 760 /home/wxw
```




### Linux 常用命令

- [Linux 命令大全](https://www.runoob.com/linux/linux-command-manual.html) 

#### 8.1 文件管理

##### （1）[scp](https://www.runoob.com/linux/linux-comm-scp.html) 远程复制文件和目录

- 用法 `scp [可选参数] file_source file_target ` 

  ```bash
  -r： 递归复制整个目录。
  -P port：注意是大写的P, port是指定数据传输用到的端口号
  ```

- 案例：

  ```
  #scp 命令使用端口号 4588
  scp -P 4588 -r wxw@10.1.1.76:/usr/local/sin.sh  /home/test
  ```

##### （2）给指定目录添加软连接

- 用法：` ln -s 源地址路径 新地址路径  ` 

  ![1606871897509](assets/1606871897509.png) 

#### 8.1 系统设置

##### （1）ulimit 用于控制shell程序的资源。

语法：

```bash
ulimit [-aHS][-c <core文件上限>][-d <数据节区大小>][-f <文件大小>][-m <内存大小>][-n <文件数目>][-p <缓冲区大小>]
             [-s <堆叠大小>][-t <CPU时间>][-u <程序数目>][-v <虚拟内存大小>]
参数列表：     
    -a 　显示目前资源限制的设定。
    -c <core文件上限> 　设定core文件的最大值，单位为区块。
    -d <数据节区大小> 　程序数据节区的最大值，单位为KB。
    -f <文件大小> 　shell所能建立的最大文件，单位为区块。
    -H 　设定资源的硬性限制，也就是管理员所设下的限制。
    -m <内存大小> 　指定可使用内存的上限，单位为KB。
    -n <文件数目> 　指定同一时间最多可开启的文件数。
    -p <缓冲区大小> 　指定管道缓冲区的大小，单位512字节。
    -s <堆叠大小> 　指定堆叠的上限，单位为KB。
    -S 　设定资源的弹性限制。
    -t <CPU时间> 　指定CPU使用时间的上限，单位为秒。
    -u <程序数目> 　用户最多可开启的程序数目。
    -v <虚拟内存大小> 　指定可使用的虚拟内存上限，单位为KB。
```




（3）修改目录所属用户权限

```bash
chown -R wxw:wxw  study_test

-R : 表示递归修改
```



### Linux 常见问题

（1）Linux下切换root用户提示Authentication failure错误的解决方法

- 解决方案：https://blog.csdn.net/renrenxu/article/details/82725659



































































