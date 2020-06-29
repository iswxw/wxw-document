### [Shell 编程](http://linux.51yip.com/search/man)  

### 一、Shell  前置条件

> 目标
>
> - 了解shell中的通配符
> - 熟悉grep、cut、sort等小工具和shell中的通配符的使用

#### （1）文本处理工具

##### 1. grep工具

> ` grep是行过滤工具；用于根据关键字进行行过滤`

- **语法：**

```powershell
# grep [选项] '关键字' 文件名
```

- 常见选项：

```powershell
OPTIONS:
    -i: 不区分大小写
    -v: 查找不包含指定内容的行,反向选择
    -w: 按单词搜索
    -o: 打印匹配关键字
    -c: 统计匹配到的行数
    -n: 显示行号
    -r: 逐层遍历目录查找
    -A: 显示匹配行及后面多少行	
    -B: 显示匹配行及前面多少行
    -C: 显示匹配行前后多少行
    -l：只列出匹配的文件名
    -L：列出不匹配的文件名
    -e: 使用正则匹配
    -E:使用扩展正则匹配
    ^key:以关键字开头
    key$:以关键字结尾
    ^$:匹配空行
    --color=auto ：可以将找到的关键词部分加上颜色的显示
```

- 颜色显示（别名设置）

```powershell
临时设置：
# alias grep='grep --color=auto'			//只针对当前终端和当前用户生效

永久设置：
1）全局（针对所有用户生效）
vim /etc/bashrc
alias grep='grep --color=auto'
source /etc/bashrc

2）局部（针对具体的某个用户）
vim ~/.bashrc
alias grep='grep --color=auto'
source ~/.bashrc
```

- 举例说明：

  不要直接使用/etc/passwd文件，将其拷贝到/tmp下做实验！

```powershell
 # grep -i root passwd                       忽略大小写匹配包含root的行
 # grep -w ftp passwd                        精确匹配ftp单词
 # grep -w hello passwd                      精确匹配hello单词;自己添加包含hello的行到文件
 # grep -wo ftp passwd 					   打印匹配到的关键字ftp
 # grep -n root passwd                       打印匹配到root关键字的行号
 # grep -ni root passwd 				   忽略大小写匹配统计包含关键字root的行
# grep -nic root passwd					   忽略大小写匹配统计包含关键字root的行数
# grep -i ^root passwd 					   忽略大小写匹配以root开头的行
# grep bash$ passwd 				       匹配以bash结尾的行
# grep -n ^$ passwd 				       匹配空行并打印行号
# grep ^# /etc/vsftpd/vsftpd.conf		    匹配以#号开头的行
# grep -v ^# /etc/vsftpd/vsftpd.conf	     匹配不以#号开头的行
# grep -A 5 mail passwd 				 	匹配包含mail关键字及其后5行
# grep -B 5 mail passwd 				 	匹配包含mail关键字及其前5行
# grep -C 5 mail passwd 					匹配包含mail关键字及其前后5行
 
```

##### 2. cut 工具

> cut是**列**截取工具，用于列的截取

**语法和选项**

**语法：**

```powershell
# cut 选项  文件名
```

**常见选项：**

```powershell
-c:	以字符为单位进行分割,截取
-d:	自定义分隔符，默认为制表符\t
-f:	与-d一起使用，指定截取哪个区域
```

**举例说明:**

```powershell
# cut -d: -f1 1.txt 			以:冒号分割，截取第1列内容
# cut -d: -f1,6,7 1.txt 	以:冒号分割，截取第1,6,7列内容
# cut -c4 1.txt 				截取文件中每行第4个字符
# cut -c1-4 1.txt 			截取文件中每行的1-4个字符
# cut -c4-10 1.txt 			截取文件中每行的4-10个字符
# cut -c5- 1.txt 				从第5个字符开始截取后面所有字符
```

**课堂练习：**
用小工具列出你当系统的运行级别。

1. 如何查看系统运行级别
   - 命令`runlevel`
   - 文件`/etc/inittab`
2. 如何过滤运行级别

```powershell
runlevel |cut -c3
runlevel | cut -d ' ' -f2
grep -v '^#' /etc/inittab | cut -d: -f2
grep '^id' /etc/inittab |cut -d: -f2
grep "initdefault:$" /etc/inittab | cut -c4
grep -v ^# /etc/inittab |cut -c4
grep 'id:' /etc/inittab |cut -d: -f2
cut -d':' -f2 /etc/inittab |grep -v ^#
cut -c4 /etc/inittab |tail -1
cut -d: -f2 /etc/inittab |tail -1
```

##### 3. sort 工具

> sort工具用于排序;它将文件的每一行作为一个单位，从首字符向后，依次按ASCII码值进行比较，最后将他们按升序输出。

**语法和选项**

```powershell
-u ：去除重复行
-r ：降序排列，默认是升序
-o : 将排序结果输出到文件中,类似重定向符号>
-n ：以数字排序，默认是按字符排序
-t ：分隔符
-k ：第N列
-b ：忽略前导空格。
-R ：随机排序，每次运行的结果均不同
```

**举例说明**

```powershell
# sort -n -t: -k3 1.txt 			按照用户的uid进行升序排列
# sort -nr -t: -k3 1.txt 			按照用户的uid进行降序排列
# sort -n 2.txt 						按照数字排序
# sort -nu 2.txt 						按照数字排序并且去重
# sort -nr 2.txt 
# sort -nru 2.txt 
# sort -nru 2.txt 
# sort -n 2.txt -o 3.txt 			按照数字排序并将结果重定向到文件
# sort -R 2.txt 
# sort -u 2.txt 
```

##### 4. uniq工具

> uniq用于去除连续的重复行

```powershell
常见选项：
-i: 忽略大小写
-c: 统计重复行次数
-d:只显示重复行

举例说明：
# uniq 2.txt 
# uniq -d 2.txt 
# uniq -dc 2.txt 
```

##### 5. tee工具

> tee工具是从标准输入读取并写入到标准输出和文件，即：双向覆盖重定向（屏幕输出|文本输入）

```powershell
选项：
-a 双向追加重定向

# echo hello world
# echo hello world|tee file1
# cat file1 
# echo 999|tee -a file1
# cat file1 
```

##### 6. diff工具

> diff工具用于逐行比较文件的不同

注意：diff描述两个文件不同的方式是告诉我们==怎样改变第一个==文件之后==与第二个文件匹配==。

**语法和选项**

**语法：**

```powershell
diff [选项] 文件1 文件2
```

**常用选项：**

| 选项     | 含义               | 备注 |
| -------- | ------------------ | ---- |
| -b       | 不检查空格         |      |
| -B       | 不检查空白行       |      |
| -i       | 不检查大小写       |      |
| -w       | 忽略所有的空格     |      |
| --normal | 正常格式显示(默认) |      |
| -c       | 上下文格式显示     |      |
| -u       | 合并格式显示       |      |

**举例说明：**

- 比较两个==普通文件==异同，文件准备：

```powershell
[root@MissHou ~]# cat file1
aaaa
111
hello world
222
333
bbb
[root@MissHou ~]#
[root@MissHou ~]# cat file2
aaa
hello
111
222
bbb
333
world
```

1）正常显示

```powershell
diff目的：file1如何改变才能和file2匹配
[root@MissHou ~]# diff file1 file2
1c1,2					第一个文件的第1行需要改变(c=change)才能和第二个文件的第1到2行匹配			
< aaaa				小于号"<"表示左边文件(file1)文件内容
---					---表示分隔符
> aaa					大于号">"表示右边文件(file2)文件内容
> hello
3d3					第一个文件的第3行删除(d=delete)后才能和第二个文件的第3行匹配
< hello world
5d4					第一个文件的第5行删除后才能和第二个文件的第4行匹配
< 333
6a6,7					第一个文件的第6行增加(a=add)内容后才能和第二个文件的第6到7行匹配
> 333					需要增加的内容在第二个文件里是333和world
> world
```

2）上下文格式显示

```powershell
[root@MissHou ~]# diff -c file1 file2
前两行主要列出需要比较的文件名和文件的时间戳；文件名前面的符号***表示file1，---表示file2
*** file1       2019-04-16 16:26:05.748650262 +0800
--- file2       2019-04-16 16:26:30.470646030 +0800
***************	我是分隔符
*** 1,6 ****		以***开头表示file1文件，1,6表示1到6行
! aaaa				!表示该行需要修改才与第二个文件匹配
  111
- hello world		-表示需要删除该行才与第二个文件匹配
  222
- 333					-表示需要删除该行才与第二个文件匹配
  bbb
--- 1,7 ----		以---开头表示file2文件，1,7表示1到7行
! aaa					表示第一个文件需要修改才与第二个文件匹配
! hello				表示第一个文件需要修改才与第二个文件匹配
  111
  222
  bbb
+ 333					表示第一个文件需要加上该行才与第二个文件匹配
+ world				表示第一个文件需要加上该行才与第二个文件匹配

```

3）合并格式显示

```powershell
[root@MissHou ~]# diff -u file1 file2
前两行主要列出需要比较的文件名和文件的时间戳；文件名前面的符号---表示file1，+++表示file2
--- file1       2019-04-16 16:26:05.748650262 +0800
+++ file2       2019-04-16 16:26:30.470646030 +0800
@@ -1,6 +1,7 @@
-aaaa
+aaa
+hello
 111
-hello world
 222
-333
 bbb
+333
+world
```

- 比较两个==目录不同==

```powershell
默认情况下也会比较两个目录里相同文件的内容
[root@MissHou  tmp]# diff dir1 dir2
diff dir1/file1 dir2/file1
0a1
> hello
Only in dir1: file3
Only in dir2: test1
如果只需要比较两个目录里文件的不同，不需要进一步比较文件内容，需要加-q选项
[root@MissHou  tmp]# diff -q dir1 dir2
Files dir1/file1 and dir2/file1 differ
Only in dir1: file3
Only in dir2: test1

```

**其他小技巧：**

有时候我们需要以一个文件为标准，去修改其他文件，并且修改的地方较多时，我们可以通过打补丁的方式完成。

```powershell
1）先找出文件不同，然后输出到一个文件
[root@MissHou ~]# diff -uN file1 file2 > file.patch
-u:上下文模式
-N:将不存在的文件当作空文件
2）将不同内容打补丁到文件
[root@MissHou ~]# patch file1 file.patch
patching file file1
3）测试验证
[root@MissHou ~]# diff file1 file2
[root@MissHou ~]#

```

##### 7. paste工具

> paste工具用于合并文件行

```powershell
常用选项：
-d：自定义间隔符，默认是tab
-s：串行处理，非并行
```

##### 8.  tr工具

> tr用于字符转换，替换和删除；主要用于==删除文件中控制字符==或进行==字符转换==

**语法和选项**

**语法：**

```powershell
用法1：命令的执行结果交给tr处理，其中string1用于查询，string2用于转换处理

 commands|tr  'string1'  'string2'

用法2：tr处理的内容来自文件，记住要使用"<"标准输入

 tr  'string1'  'string2' < filename

用法3：匹配string1进行相应操作，如删除操作

 tr [options] 'string1' < filename
```

**常用选项：**

```powershell
-d 删除字符串1中所有输入字符。
-s 删除所有重复出现字符序列，只保留第一个；即将重复出现字符串压缩为一个字符串
```

**常匹配字符串：**

| 字符串             | 含义                 | 备注                        |
| ------------------ | -------------------- | --------------------------- |
| ==a-z==或[:lower:] | 匹配所有小写字母     | 所有大小写和数字[a-zA-Z0-9] |
| ==A-Z==或[:upper:] | 匹配所有大写字母     |                             |
| ==0-9==或[:digit:] | 匹配所有数字         |                             |
| [:alnum:]          | 匹配所有字母和数字   |                             |
| [:alpha:]          | 匹配所有字母         |                             |
| [:blank:]          | 所有水平空白         |                             |
| [:punct:]          | 匹配所有标点符号     |                             |
| [:space:]          | 所有水平或垂直的空格 |                             |

| [:cntrl:]          | 所有控制字符         | \f Ctrl-L        走行换页<br/>\n Ctrl-J  	换行
\r Ctrl-M        回车
\t Ctrl-I  	tab键 |

**举例说明：**

```powershell
[root@MissHou  shell01]# cat 3.txt 	自己创建该文件用于测试
ROOT:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin
boss02:x:516:511::/home/boss02:/bin/bash
vip:x:517:517::/home/vip:/bin/bash
stu1:x:518:518::/home/stu1:/bin/bash
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
smmsp:x:51:51::/var/spool/mqueue:/sbin/nologin
aaaaaaaaaaaaaaaaaaaa
bbbbbb111111122222222222233333333cccccccc
hello world 888
666
777
999


# tr -d '[:/]' < 3.txt 				删除文件中的:和/
# cat 3.txt |tr -d '[:/]'			删除文件中的:和/
# tr '[0-9]' '@' < 3.txt 			将文件中的数字替换为@符号
# tr '[a-z]' '[A-Z]' < 3.txt 		将文件中的小写字母替换成大写字母
# tr -s '[a-z]' < 3.txt 			匹配小写字母并将重复的压缩为一个
# tr -s '[a-z0-9]' < 3.txt 		匹配小写字母和数字并将重复的压缩为一个
# tr -d '[:digit:]' < 3.txt 		删除文件中的数字
# tr -d '[:blank:]' < 3.txt 		删除水平空白
# tr -d '[:space:]' < 3.txt 		删除所有水平和垂直空白

```

##### 小试牛刀

1. 使用小工具分别截取当前主机IP；截取netmask；截取广播地址；截取MAC地址

```powershell
# ifconfig eth0|grep 'Bcast'|tr -d '[a-zA-Z ]'|cut -d: -f2,3,4
10.1.1.1:10.1.1.255:255.255.255.0
# ifconfig eth0|grep 'Bcast'|tr -d '[a-zA-Z ]'|cut -d: -f2,3,4|tr ':' '\n'
10.1.1.1
10.1.1.255
255.255.255.0
# ifconfig eth0|grep 'HWaddr'|cut -d: -f2-|cut -d' ' -f4
00:0C:29:25:AE:54
# ifconfig eth0|grep 'HW'|tr -s ' '|cut -d' ' -f5
00:0C:29:B4:9E:4E

# ifconfig eth1|grep Bcast|cut -d: -f2|cut -d' ' -f1
# ifconfig eth1|grep Bcast|cut -d: -f2|tr -d '[ a-zA-Z]'
# ifconfig eth1|grep Bcast|tr -d '[:a-zA-Z]'|tr ' ' '@'|tr -s '@'|tr '@' '\n'|grep -v ^$
# ifconfig eth0|grep 'Bcast'|tr -d [:alpha:]|tr '[ :]' '\n'|grep -v ^$
# ifconfig eth1|grep HWaddr|cut -d ' ' -f11
# ifconfig eth0|grep HWaddr|tr -s ' '|cut -d' ' -f5
# ifconfig eth1|grep HWaddr|tr -s ' '|cut -d' ' -f5
# ifconfig eth0|grep 'Bcast'|tr -d 'a-zA-Z:'|tr ' ' '\n'|grep -v '^$'
```

2. 将系统中所有普通用户的用户名、密码和默认shell保存到一个文件中，要求用户名密码和默认shell之间用tab键分割

```powershell
# grep 'bash$' passwd |grep -v 'root'|cut -d: -f1,2,7|tr ':' '\t' |tee abc.txt
```

#### （2）bash的特性

##### 1、命令和文件自动补全

Tab只能补全==命令和文件== （RHEL6/Centos6）

##### 2、常见的快捷键

```powershell
^c   			终止前台运行的程序
^z	  			将前台运行的程序挂起到后台
^d   			退出 等价exit
^l   			清屏 
^a |home  	     光标移到命令行的最前端
^e |end  	     光标移到命令行的后端
^u   			删除光标前所有字符
^k   			删除光标后所有字符
^r	 			搜索历史命令
```

##### 3 、常用的通配符（重点）

```powershell
*:	匹配0或多个任意字符
?:	匹配任意单个字符
[list]:	匹配[list]中的任意单个字符,或者一组单个字符   [a-z]
[!list]: 匹配除list中的任意单个字符
{string1,string2,...}：匹配string1,string2或更多字符串


# rm -f file*
# cp *.conf  /dir1
# touch file{1..5}
```

##### 4、 bash中的引号（重点）

- 双引号""   :会把引号的内容当成整体来看待，允许通过$符号引用其他变量值
- 单引号''     :会把引号的内容当成整体来看待，禁止引用其他变量值，shell中特殊符号都被视为普通字符
- 反撇号``  :反撇号和$()一样，引号或括号里的命令会优先执行，如果存在嵌套，反撇号不能用

```powershell
[root@MissHou  dir1]# echo "$(hostname)"
server
[root@MissHou  dir1]# echo '$(hostname)'
$(hostname)
[root@MissHou  dir1]# echo "hello world"
hello world
[root@MissHou  dir1]# echo 'hello world'
hello world

[root@MissHou  dir1]# echo $(date +%F)
2018-11-22
[root@MissHou  dir1]# echo `echo $(date +%F)`
2018-11-22
[root@MissHou  dir1]# echo `date +%F`
2018-11-22
[root@MissHou  dir1]# echo `echo `date +%F``
date +%F
[root@MissHou  dir1]# echo $(echo `date +%F`)
2018-11-22
```

##### 5、 运行shell脚本

**1、作为可执行程序**

代码保存为 test.sh，并 cd 到相应目录：

```powershell
 chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本
```

注意，一定要写成 **./test.sh**，而不是 **test.sh**，运行其它二进制的程序也一样，直接写 test.sh，linux 系统会去 PATH 里寻找有没有叫 test.sh 的，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里，你的当前目录通常不在 PATH 里，所以写成 test.sh 是会找不到命令的，要用 ./test.sh 告诉系统说，就在当前目录找。

**2、作为解释器参数**

这种运行方式是，直接运行解释器，其参数就是 shell 脚本的文件名，如：

```
/bin/sh test.sh
/bin/php test.php
```

这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。

### 二、Shell  背景

**前言：**

计算机只能认识（识别）机器语言(0和1)，如（11000000 这种）。但是，我们的程序猿们不能直接去写01这样的代码，所以，要想将程序猿所开发的代码在计算机上运行，就必须找"人"（工具）来==翻译成机器语言==，这个"人"(工具)就是我们常常所说的**编译器**或者**解释器**

![](./img/编译和解释型语言区别.png)

#### （1）编程语言分类

- **编译型语言**

  程序在执行之前需要一个专门的编译过程，把程序编译成为机器语言文件，运行时不需要重新翻译，直接使用编译的结果就行了。程序执行效率高，依赖编译器，跨平台性差些。如C、C++

- **解释型语言**

   程序不需要编译，程序在运行时由**解释器**翻译成机器语言，每执行一次都要翻译一次。因此效率比较低。比如Python/JavaScript/ Perl /ruby/Shell等都是解释型语言

![](./img/语言分类.png)

- **总结**

  **编译型语言**比**解释型语言**速度较快，但是**不如解释型语言跨平台性好**。如果做底层开发或者大型应用程序或者操作系开发一般都用编译型语言；如果是一些服务器脚本及一些辅助的接口，对速度要求不高、对各个平台的兼容性有要求的话则一般都用解释型语言。

#### （2）Shell 简介

![](./img/00_shell介绍.png)

- **总结**

  1. Shell 是人机交互的一个桥梁
  2. Shell 的种类

  ```powershell
  [root@MissHou ~]# cat /etc/shells 
  /bin/sh				#是bash的一个快捷方式
  /bin/bash			#bash是大多数Linux默认的shell，包含的功能几乎可以涵盖shell所有的功能
  /sbin/nologin		#表示非交互，不能登录操作系统
  /bin/dash			#小巧，高效，功能相比少一些
  
  /bin/csh		    #具有C语言风格的一种shell，具有许多特性，但也有一些缺陷
  /bin/tcsh			#是csh的增强版，完全兼容csh
  ```

- **思考：** 终端和Shell 有什么区别？

  ![](./img/01_shell介绍.png)

#### （3）Shell 脚本

##### 1. 什么是shell脚本？

> 将要执行的命令保存到文本中，按照顺序地执行，它是解释型的，意味着不需要编译

- 若干命令 + 脚本的基本格式 + 脚本特定语法 + 思想= shell脚本

##### 2. 什么时候用到shell 脚本？

- 重复化、复杂化的工作，通过把工作的命令写成脚本，以后仅仅需要执行脚本就能完成这些工作。

##### 3. shell脚本能做什么？

​     ①自动化软件部署	LAMP/LNMP/Tomcat...	

​     ②自动化管理		系统初始化脚本、批量更改主机密码、推送公钥...

​     ③自动化分析处理	 统计网站访问量

​     ④自动化备份		数据库备份、日志转储...

​     ⑤自动化监控脚本

##### 4. 如何学习shell脚本？

1. 尽可能记忆更多的命令(记忆命令使用功能和场景)
2. 掌握脚本的标准的格式（指定魔法字节、使用标准的执行方式运行脚本）
3. 必须**熟悉掌握**脚本的基本语法（重点)

##### 5. 学习脚本的秘诀

- 多看（看懂）——>模仿（多练）——>多思考（多写）

##### 6. shell 脚本的基本写法

1. **脚本第一行**，魔法字符**#!**指定解释器【必写】

   `#!/bin/bash`  表示以下内容使用bash解释器解析

**注意：** 

如果直接将解释器路径写死在脚本里，可能在某些系统就会存在找不到解释器的兼容性问题，所以可以使用:**`#!/bin/env 解释器`**  **`#!/bin/env bash`**

2. **脚本第二部分**，注释(#号)说明，对脚本的基本信息进行描述【可选】

```powershell
 #!/bin/env bash
 
 # 以下内容是对脚本的基本信息的描述
 # Name: 名字
 # Desc:描述describe
 # Path:存放路径
 # Usage:用法# Update:更新时间
 
 #下面就是脚本的具体内容commands...
```

3. **脚本第三部分**，脚本要实现的具体代码内容

#### （4）脚本的执行方法

- 标准脚本执行方法（建议）

```powershell
1) 编写人生第一个shell脚本
[root@MissHou shell01]# cat first_shell.sh
#!/bin/env bash

# 以下内容是对脚本的基本信息的描述
# Name: first_shell.sh
# Desc: num1
# Path: /shell01/first_shell.sh
# Usage:/shell01/first_shell.sh
# Update:2019-05-05

echo "hello world"
echo "hello world"
echo "hello world"

2) 脚本增加可执行权限
[root@MissHou shell01]# chmod +x first_shell.sh

3) 标准方式执行脚本
[root@MissHou shell01]# pwd
/shell01
[root@MissHou shell01]# /shell01/first_shell.sh
或者
[root@MissHou shell01]# ./first_shell.sh

注意：标准执行方式脚本必须要有可执行权限。
```

- 非标准的执行方法（不建议）

1. 直接在命令行指定解释器执行

```powershell
[root@MissHou shell01]# bash first_shell.sh
[root@MissHou shell01]# sh first_shell.sh
[root@MissHou shell01]# bash -x first_shell.sh
+ echo 'hello world'
hello world
+ echo 'hello world'
hello world
+ echo 'hello world'
hello world
----------------
-x:一般用于排错，查看脚本的执行过程
-n:用来查看脚本的语法是否有问题
------------
```

2. 使用`source`命令读取脚本文件,执行文件里的代码

```powershell
[root@MissHou shell01]# source first_shell.sh
hello world
hello world
hello world
```

**小试牛刀：**写一个木有灵魂的脚本，要求如下：

1. 删除/tmp/目录下的所有文件                         ` rm -rf /tmp/*`             

2. 然后在/tmp目录里创建3个目录，分别是dir1~dir3      `mkdir /tmp/dir(1 ..3)` 

3. 拷贝/etc/hosts文件到刚创建的dir1目录里       `  cp /etc/hosts  /tmp/dir1`

4. 最后打印"==报告首长，任务已于2019-05-05 10:10:10时间完成=="内容      ` `

   `echo "报告首长，任务已于$(date +'%F %T')"`

- 脚本案例

```powershell
#!/bin/env bash
rm -rf /tmp/*
mkdir /tmp/dir(1..3)
cp /etc/hosts  /tmp/dir1
echo "报告首长，任务已于$(date +'%F %T')"

```



### 三、Shell 语法

#### （1）变量

- 变量是用来临时保存数据的，该数据是可以变化的数据。

##### 1.  什么时候使用

- 如果某个内容需要多次使用，并且在代码中**重复出现**，那么可以用变量代表该内容。这样在修改内容的时候，仅仅需要修改变量的值。
- 在代码运作的过程中，可能会把某些命令的执行结果保存起来，后续代码需要使用这些结果，就可以直接使用这个变量。

##### 2. 定义变量

` K（变量名）——V（变量值）` 

- 变量名：临时保存数据
- 变量值：临时的可变化的数据 

```powershell
[root@MissHou ~]# A=hello           定义变量A
[root@MissHou ~]# echo $A           调用变量A，要给钱的，不是人民币是美元"$"
hello
[root@MissHou ~]# echo ${A}         还可以这样调用，不管你的姿势多优雅，总之要给钱
hello
[root@MissHou ~]# A=world           因为是变量所以可以变，移情别恋是常事
[root@MissHou ~]# echo $A           不管你是谁，只要调用就要给钱
world
[root@MissHou ~]# unset A           不跟你玩了，取消变量
[root@MissHou ~]# echo $A           从此，我单身了，你可以给我介绍任何人
```

##### 3. 变量的定义规则

1. 变量名区分大小写
2.  变量名不能有特殊符号
3. 变量名不能以数字开头
4. 等号两边不能有任何空格
5. 变量名尽量做到见名知意

**特别说明**：对于有空格的字符串给变量赋值时，要用引号引起来

##### 4. 变量的定义方式

**基本方式**

- 直接赋值给一个变量

```powershell
[root@MissHou ~]# A=1234567
[root@MissHou ~]# echo $A
1234567
[root@MissHou ~]# echo ${A:2:4}     表示从A变量中第3个字符开始截取，截取4个字符
3456

说明：
$变量名 和 ${变量名}的异同
相同点：都可以调用变量
不同点：${变量名}可以只截取变量的一部分，而$变量名不可以
```

- **命令执行结果赋值给变量**

```powershell
[root@MissHou ~]# B=`date +%F`
[root@MissHou ~]# echo $B
2019-04-16
[root@MissHou ~]# C=$(uname -r)
[root@MissHou ~]# echo $C
2.6.32-696.el6.x86_64
```

- **交互式定义变量**

**目的：**让用户自己给变量赋值，比较灵活。

**语法：**`read [选项] 变量名`

**常见选项：**

| 选项 | 释义                                                       |
| ---- | ---------------------------------------------------------- |
| -p   | 定义提示用户的信息                                         |
| -n   | 定义字符数（限制变量值的长度）                             |
| -s   | 不显示（不显示用户输入的内容）                             |
| -t   | 定义超时时间，默认单位为秒（限制用户输入变量值的超时时间） |

**举例说明：**

```powershell
用法1：用户自己定义变量值
[root@MissHou ~]# read name
harry
[root@MissHou ~]# echo $name
harry
[root@MissHou ~]# read -p "Input your name:" name
Input your name:tom
[root@MissHou ~]# echo $name
tom
```

用法2：变量值来自文件

```
[root@MissHou ~]# cat 1.txt 
10.1.1.1 255.255.255.0

[root@MissHou ~]# read ip mask < 1.txt 
[root@MissHou ~]# echo $ip
10.1.1.1
[root@MissHou ~]# echo $mask
255.255.255.0
```

- **定义有类型的变量**(declare)

目的：给变量做一些限制，固定变量的类型，比如：整型、只读

**用法：**`declare 选项 变量名=变量值`

**常用选项：**

| 选项 | 释义                       | 举例                                         |
| ---- | -------------------------- | -------------------------------------------- |
| -i   | 将变量看成整数             | declare -i A=123                             |
| -r   | 定义只读变量               | declare -r B=hello                           |
| -a   | 定义普通数组；查看普通数组 |                                              |
| -A   | 定义关联数组；查看关联数组 |                                              |
| -x   | 将变量通过环境导出         | declare -x AAA=123456 等于 export AAA=123456 |

**举例说明：**

```powershell
[root@MissHou ~]# declare -i A=123
[root@MissHou ~]# echo $A
123
[root@MissHou ~]# A=hello
[root@MissHou ~]# echo $A
0

[root@MissHou ~]# declare -r B=hello
[root@MissHou ~]# echo $B
hello
[root@MissHou ~]# B=world
-bash: B: readonly variable
[root@MissHou ~]# unset B
-bash: unset: B: cannot unset: readonly variable
```

##### 5. 变量的分类

1. **本地变量**

> 当前用户自定义的变量。当前进程中有效，其他进程及当前进程的子进程无效

2. **环境变量**

> 当前进程有效，并且能够被**子进程**调用。

- `env`查看当前用户的环境变量
- `set`查询当前用户的所有变量(临时变量与环境变量)
- `export 变量名=变量值`    或者  `变量名=变量值；export 变量名`

```powershell
[root@MissHou ~]# export A=hello		临时将一个本地变量（临时变量）变成环境变量
[root@MissHou ~]# env|grep ^A
A=hello

永久生效：
vim /etc/profile 或者 ~/.bashrc
export A=hello
或者
A=hello
export A

说明：系统中有一个变量PATH，环境变量
export PATH=/usr/local/mysql/bin:$PATH
```

3. **全局变量**

> **全局变量**：全局所有的用户和程序都能调用，且继承，新建的用户也默认能调用.

- **解读相关配置文件**

| 文件名               | 说明                               | 备注                                                       |
| -------------------- | ---------------------------------- | ---------------------------------------------------------- |
| $HOME/.bashrc        | 当前用户的bash信息,用户登录时读取  | 定义别名、umask、函数等                                    |
| $HOME/.bash_profile  | 当前用户的环境变量，用户登录时读取 |                                                            |
| $HOME/.bash_logout   | 当前用户退出当前shell时最后读取    | 定义用户退出时执行的程序等                                 |
| /etc/bashrc          | 全局的bash信息，所有用户都生效     |                                                            |
| /etc/profile         | 全局环境变量信息                   | 系统和所有用户都生效                                       |
| \$HOME/.bash_history | 用户的历史命令                     | history -w   保存历史记录         history -c  清空历史记录 |

**说明：**以上文件修改后，都需要重新source让其生效或者退出重新登录。

- **用户登录**系统**读取**相关  文件的顺序
  1. `/etc/profile`
  2. `$HOME/.bash_profile`
  3. `$HOME/.bashrc`
  4. `/etc/bashrc`
  5. `$HOME/.bash_logout`

4. **系统变量**

   > **系统变量(内置bash中变量)** ： shell本身已经固定好了它的名字和作用.

| 内置变量     | 含义                                                         |
| ------------ | ------------------------------------------------------------ |
| $?           | 上一条命令执行后返回的状态；状态值为0表示执行正常，==非0==表示执行异常或错误 |
| $0           | 当前执行的程序或脚本名                                       |
| $#           | 脚本后面接的参数的==个数==                                   |
| $*           | 脚本后面==所有参数==，参数当成一个整体输出，每一个变量参数之间以空格隔开 |
| $@           | 脚本后面==所有参数==，参数是独立的，也是全部输出             |
| \$1\~$9      | 脚本后面的==位置参数==，$1表示第1个位置参数，依次类推        |
| \${10}\~${n} | 扩展位置参数,第10个位置变量必须用{}大括号括起来(2位数字以上扩起来) |
| $$           | 当前所在进程的进程号，如`echo $$`                            |
| $！          | 后台运行的最后一个进程号 (当前终端）                         |
| !$           | 调用最后一条命令历史中的参数                                 |

- 进一步了解位置参数`$1~${n}`

```powershell
#!/bin/bash
#了解shell内置变量中的位置参数含义
echo "\$0 = $0"
echo "\$# = $#"
echo "\$* = $*"
echo "\$@ = $@"
echo "\$1 = $1" 
echo "\$2 = $2" 
echo "\$3 = $3" 
echo "\$11 = ${11}" 
echo "\$12 = ${12}" 
```

- 进一步了解\$*和​\$@的区别

`$*`：表示将变量看成一个整体
`$@`：表示变量是独立的

```powershell
#!/bin/bash
for i in "$@"
do
echo $i
done

echo "======我是分割线======="

for i in "$*"
do
echo $i
done

[root@MissHou ~]# bash 3.sh a b c
a
b
c
======我是分割线=======
a b c

```



#### （2）四则运算

- 算术运算：默认情况下，shell就只能支持简单的整数运算

- 运算内容：加(+)、减(-)、乘(*)、除(/)、求余数（%）

- 原生bash不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。

  expr 是一款表达式计算工具，使用它能完成表达式的求值操作。

##### 1. 四则运算符号

| 表达式  | 举例                            |
| ------- | ------------------------------- |
| $((  )) | echo $((1+1))                   |
| $[ ]    | echo $[10-5]                    |
| expr    | expr 10 / 5                     |
| let     | n=1;let n+=1  等价于  let n=n+1 |

##### 2. 了解i++和++i

- 对变量的值的影响

```powershell
[root@MissHou ~]# i=1
[root@MissHou ~]# let i++
[root@MissHou ~]# echo $i
2
[root@MissHou ~]# j=1
[root@MissHou ~]# let ++j
[root@MissHou ~]# echo $j
2
```

- 对表达式的值的影响

```powershell
[root@MissHou ~]# unset i j
[root@MissHou ~]# i=1;j=1
[root@MissHou ~]# let x=i++         先赋值，再运算
[root@MissHou ~]# let y=++j         先运算，再赋值
[root@MissHou ~]# echo $i
2
[root@MissHou ~]# echo $j
2
[root@MissHou ~]# echo $x
1
[root@MissHou ~]# echo $y
2
```

#### （3）数组

- 普通数组：只能使用整数作为数组索引(元素的下标)
- 关联数组：可以使用字符串作为数组索引(元素的下标)

##### 1. **数组定义**

- 一次赋予一个值

```powershell
数组名[索引下标]=值
array[0]=v1
array[1]=v2
array[2]=v3
array[3]=v4
```

- 一次赋予多个值

```powershell
数组名=(值1 值2 值3 ...)
array=(var1 var2 var3 var4)

array1=(`cat /etc/passwd`)			将文件中每一行赋值给array1数组
array2=(`ls /root`)
array3=(harry amy jack "Miss Hou")
array4=(1 2 3 4 "hello world" [10]=linux)
```

##### 2. **数组的读取**

```powershell
${数组名[元素下标]}

echo ${array[0]}			获取数组里第一个元素
echo ${array[*]}			获取数组里的所有元素
echo ${#array[*]}			获取数组里所有元素个数
echo ${!array[@]}    	     获取数组元素的索引下标
echo ${array[@]:1:2}         访问指定的元素；1代表从下标为1的元素开始获取；2代表获取后面几个元素

查看普通数组信息：
[root@MissHou ~]# declare -a
```

##### 3. **关联数组定义**

 **①**首先声明关联数组

==declare -A asso_array1==

```powershell
declare -A asso_array1
declare -A asso_array2
declare -A asso_array3
```

**②** 数组赋值

- 一次赋一个值

```powershell
数组名[索引or下标]=变量值
# asso_array1[linux]=one
# asso_array1[java]=two
# asso_array1[php]=three
```

- 一次赋多个值

```powershell
# asso_array2=([name1]=harry [name2]=jack [name3]=amy [name4]="Miss Hou")
```

- 查看关联数组

```powershell
# declare -A
declare -A asso_array1='([php]="three" [java]="two" [linux]="one" )'
declare -A asso_array2='([name3]="amy" [name2]="jack" [name1]="harry" [name4]="Miss Hou" )'
```

##### 4. 获取关联数组值

```powershell
# echo ${asso_array1[linux]}
one
# echo ${asso_array1[php]}
three
# echo ${asso_array1[*]}
three two one
# echo ${!asso_array1[*]}
php java linux
# echo ${#asso_array1[*]}
3
# echo ${#asso_array2[*]}
4
# echo ${!asso_array2[*]}
name3 name2 name1 name4
```

##### 5. 其他定义方式

```powershell
[root@MissHou shell05]# declare -A books
[root@MissHou shell05]# let books[linux]++
[root@MissHou shell05]# declare -A|grep books
declare -A books='([linux]="1" )'
[root@MissHou shell05]# let books[linux]++
[root@MissHou shell05]# declare -A|grep books
declare -A books='([linux]="2" )'
```

### 四、流程控制

- 开发手册地址：[入口](http://manual.51yip.com/shell/) 

**目标** 

> - 熟悉条件判断语句，如判断整数，判断字符串等
> - 熟悉流程控制语句的基本语法，如if...else...

#### （1）条件判断语法

- 格式1：**test** 条件表达式
- 格式2：[ 条件表达式 ]
- 格式3：[[ 条件表达式 ]]    支持正则

**注意：** 

> 1. ==[==  亲亲，我两边都有空格，不空打死你呦  ==]== :imp:
> 2. ==[[==  亲亲，我两边都有空格，不空打死你呦  ==]]==:imp:
> 3.   更多判断，`man test`去查看，很多的参数都用来进行条件判断

- 此处 man是linux的使用手册： [具体介绍参考入口](https://blog.csdn.net/ac_dao_di/article/details/54718710)   

#### （2）条件判断相关参数

> 问：你要判断什么？
>
> 答：我要判断文件类型，判断文件新旧，判断字符串是否相等，判断权限等等...

##### 1.  判断文件类型

| 判断参数 | 含义                                         |
| -------- | -------------------------------------------- |
| -e       | 判断文件是否存在（任何类型文件）             |
| -f       | 判断文件是否存在并且是一个普通文件           |
| -d       | 判断文件是否存在并且是一个目录               |
| -L       | 判断文件是否存在并且是一个软连接文件         |
| -b       | 判断文件是否存在并且是一个块设备文件         |
| -S       | 判断文件是否存在并且是一个套接字文件         |
| -c       | 判断文件是否存在并且是一个字符设备文件       |
| -p       | 判断文件是否存在并且是一个命名管道文件       |
| -s       | 判断文件是否存在并且是一个非空文件（有内容） |

**举例说明：**

```powershell
test -e file					只要文件存在条件为真
[ -d /shell01/dir1 ]		 	判断目录是否存在，存在条件为真
[ ! -d /shell01/dir1 ]		判断目录是否存在,不存在条件为真
[[ -f /shell01/1.sh ]]		判断文件是否存在，并且是一个普通的文件
```

##### 2. 判断文件权限

| 判断参数 | 含义                       |
| -------- | -------------------------- |
| -r       | 当前用户对其是否可读       |
| -w       | 当前用户对其是否可写       |
| -x       | 当前用户对其是否可执行     |
| -u       | 是否有suid，高级权限冒险位 |
| -g       | 是否sgid，高级权限强制位   |
| -k       | 是否有t位，高级权限粘滞位  |

##### 3. 判断文件新旧

说明：这里的新旧指的是文件的修改时间。

| 判断参数         | 含义                                                         |
| ---------------- | ------------------------------------------------------------ |
| file1 -nt  file2 | 比较file1是否比file2新                                       |
| file1 -ot  file2 | 比较file1是否比file2旧                                       |
| file1 -ef  file2 | 比较是否为同一个文件，或者用于判断硬连接，是否指向同一个inode |

##### 4. 判断整数

| 判断参数 | 含义     |
| -------- | -------- |
| -eq      | 相等     |
| -ne      | 不等     |
| -gt      | 大于     |
| -lt      | 小于     |
| -ge      | 大于等于 |
| -le      | 小于等于 |

##### 5. 判断字符串

| 判断参数           | 含义                                        |
| ------------------ | ------------------------------------------- |
| -z                 | 判断是否为空字符串，字符串长度为0则成立     |
| -n                 | 判断是否为非空字符串，字符串长度不为0则成立 |
| string1 = string2  | 判断字符串是否相等                          |
| string1 != string2 | 判断字符串是否相不等                        |

##### 6. 多重条件判断

| 判断符号   | 含义   | 举例                                                  |
| ---------- | ------ | ----------------------------------------------------- |
| -a 和 &&   | 逻辑与 | [ 1 -eq 1 -a 1 -ne 0 ]     [ 1 -eq 1 ] && [ 1 -ne 0 ] |
| -o 和 \|\| | 逻辑或 | [ 1 -eq 1 -o 1 -ne 1 ]                                |

**特别说明：**

- &&	前面的表达式为真，才会执行后面的代码

- ||	 前面的表达式为假，才会执行后面的代码

- ;	     只用于分割命令或表达式

① 举例说明

- 数值比较

  ```powershell
  [root@server ~]# [ $(id -u) -eq 0 ] && echo "the user is admin"
  [root@server ~]$ [ $(id -u) -ne 0 ] && echo "the user is not admin"
  [root@server ~]$ [ $(id -u) -eq 0 ] && echo "the user is admin" || echo "the user is not admin"
  
  [root@server ~]# uid=`id -u`
  [root@server ~]# test $uid -eq 0 && echo this is admin
  this is admin
  [root@server ~]# [ $(id -u) -ne 0 ]  || echo this is admin
  this is admin
  [root@server ~]# [ $(id -u) -eq 0 ]  && echo this is admin || echo this is not admin
  this is admin
  [root@server ~]# su - stu1
  [stu1@server ~]$ [ $(id -u) -eq 0 ]  && echo this is admin || echo this is not admin
  this is not admin
  ```

- 类似c的风格

  ```powershell
  注意：在(( ))中，=表示赋值；==表示判断
  [root@server ~]# ((1==2));echo $?
  [root@server ~]# ((1<2));echo $?
  [root@server ~]# ((2>=1));echo $?
  [root@server ~]# ((2!=1));echo $?
  [root@server ~]# ((`id -u`==0));echo $?
   
  [root@server ~]# ((a=123));echo $a
  [root@server ~]# unset a
  [root@server ~]# ((a==123));echo $?
  ```

- 字符串比较

  ```powershell
  注意：双引号引起来，看作一个整体；= 和 == 在 [ 字符串 ] 比较中都表示判断
  [root@server ~]# a='hello world';b=world
  [root@server ~]# [ $a = $b ];echo $?
  [root@server ~]# [ "$a" = "$b" ];echo $?
  [root@server ~]# [ "$a" != "$b" ];echo $?
  [root@server ~]# [ "$a" !== "$b" ];echo $?        错误
  [root@server ~]# [ "$a" == "$b" ];echo $?
  [root@server ~]# test "$a" != "$b";echo $?
  
  
  test  表达式
  [ 表达式 ]
  [[ 表达式 ]]
  
  思考：[ ] 和 [[ ]] 有什么区别？
  
  [root@server ~]# a=
  [root@server ~]# test -z $a;echo $?
  [root@server ~]# a=hello
  [root@server ~]# test -z $a;echo $?
  [root@server ~]# test -n $a;echo $?
  [root@server ~]# test -n "$a";echo $?
  
  # [ '' = $a ];echo $?
  -bash: [: : unary operator expected
  2
  # [[ '' = $a ]];echo $?
  0
  
  
  [root@server ~]# [ 1 -eq 0 -a 1 -ne 0 ];echo $?
  [root@server ~]# [ 1 -eq 0 && 1 -ne 0 ];echo $?
  [root@server ~]# [[ 1 -eq 0 && 1 -ne 0 ]];echo $?
  ```

  

#### （3）逻辑运算符总结

1. 符号;和&&和||都可以用来分割命令或者表达式
2. 分号（;）完全不考虑前面的语句是否正确执行，都会执行;号后面的内容
3. `&&`符号，需要考虑&&前面的语句的正确性，前面语句正确执行才会执行&&后的内容；反之亦然
4. `||`符号，需要考虑||前面的语句的非正确性，前面语句执行错误才会执行||后内容；反之亦然
5. 如果&&和||一起出现，从左往右依次看，按照以上原则

#### （4）流程控制语句

  格式模板：

```powershell
if [ condition ];then
		command
		command
fi

if test 条件;then
	命令
fi

if [[ 条件 ]];then
	命令
fi

[ 条件 ] && command
```

![](./img/流程判断1.png)

参见菜鸟教程：[入口](http://manual.51yip.com/shell/)  

##### 1. if...else...结构

```powershell
在多行展示：
if [ condition ];then
		command1
	else
		command2
fi

集中在一行：（适用于终端命令提示符）
[ 条件 ] && command1 || command2
```

![](./img/流程判断2.png)

**小试牛刀** 

> 让用户自己输入字符串，如果用户输入hello,则打印world, 否则打印请输入world

1. read 定义变量

2. if...else...处理

   ```powershell
   #!/bin/env bash
   
   read -p '请输入一个字符串:' str
   if [ "$str" = 'hello' ];then
       echo 'world'
    else
       echo '请输入hello!'
   fi
   
     1 #!/bin/env bash
     2
     3 read -p "请输入一个字符串:" str
     4 if [ "$str" = "hello" ]
     5 then
     6     echo world
     7 else
     8     echo "请输入hello!"
     9 fi
     
     echo "该脚本需要传递参数"
     1 if [ $1 = hello ];then
     2         echo "hello"
     3 else
     4         echo "请输入hello"
     5 fi
   
   #!/bin/env bash
   
   A=hello
   B=world
   C=hello
   
   if [ "$1" = "$A" ];then
           echo "$B"
       else
           echo "$C"
   fi
   
   
   read -p '请输入一个字符串:' str;
    [ "$str" = 'hello' ] && echo 'world' ||  echo '请输入hello!'
   ```

   

##### 2. if...elseif..else 结构

- 选择很多，能走的只有一条

```powershell
if [ condition1 ];then
		command1  	结束
	elif [ condition2 ];then
		command2   	结束
	else
		command3
fi
注释：
如果条件1满足，执行命令1后结束；如果条件1不满足，再看条件2，如果条件2满足执行命令2后结束；如果条件1和条件2都不满足执行命令3结束.
```

![](./img/流程判断3.png)

##### 3. 层层嵌套结构























