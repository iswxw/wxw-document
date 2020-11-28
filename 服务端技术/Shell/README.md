### Shell 编程

---

### 1. 文件管理

**awk、sed、grep更适合的方向：** 

- grep 更适合单纯的查找或匹配文本
- sed 更适合编辑匹配到的文本
- awk 更适合格式化文本

#### 1.1 awk 

##### 基础知识

- awk是一种编程语言，主要用于在linux/unix下对文本和数据进行处理，是linux/unix下的一个工具。数据可以来自标准输入、一个或多个文件，或其它命令的输出

- awk的处理文本和数据的方式：**逐行扫描文件**，默认从第一行到最后一行，寻找匹配的特定模式的行，并在这些行上进行你想要的操作

- 工作流程

  - 读输入文件之前执行的代码段（由BEGIN关键字标识）。
  - 主循环执行输入文件的代码段。
  - 读输入文件之后的代码段（由END关键字标识）

- 命令结构

  - Begin{}    初始化代码块，在对每一行进行处理之前，初始化代码，主要是引用全局变量，设置FS分隔符
  - //            匹配代码块，可以是字符串或正则表达式
  - {}            命令代码块，包含一条或多条命令,多条命令用 ;  隔开
  - END{}      结尾代码块，在对每一行进行处理之后再执行的代码块，主要是进行最终计算或输出结尾摘要信息

  ```powershell
  awk [参数] 'BEGIN{ commands } pattern{ commands } END{ commands }' [文件名]

  特别说明：引用shell变量需用双引号引起

  参数：
    -F   指定分隔符
    -f   调用脚本
    -v   定义变量  
  ```

  例如：`  awk  'BEGIN{X=0}/root/{X+=1}END{print "I find",X,"root lines"}'   /etc/passwd`      统计 /etc/passwd 文件中包含root行的总数

  ![img](assets/20181009183035774.png)

  下面的流程图描述出了 AWK 的工作流程：

![img](assets/20170719154838100.png)

> awk 字符含义

```scss
$0           表示整个当前行
$1           每行第一个字段
NF           字段数量变量
NR           每行的记录号，多文件记录递增
FNR          与NR类似，不过多文件记录不递增，每个文件都从1开始
\t           制表符
\n           换行符
FS           BEGIN时定义分隔符
RS           输入的记录分隔符， 默认为换行符(即文本是按一行一行输入)
~            包含
!~           不包含
==           等于，必须全部相等，精确比较
!=           不等于，精确比较
&&           逻辑与
||           逻辑或
+            匹配时表示1个或1个以上
/[0-9][0-9]+/     两个或两个以上数字
/[0-9][0-9]*/     一个或一个以上数字
OFS          输出字段分隔符， 默认也是空格，可以改为其他的
ORS          输出的记录分隔符，默认为换行符,即处理结果也是一行一行输出到屏幕
-F  [:#/]    定义了三个分隔符
```

> print打印

```scss
print                                                 是 awk打印指定内容的主要命令，也可以用 printf
awk '{print}'  /etc/passwd   ==   awk '{print $0}'  /etc/passwd  
awk '{print " "}'  /etc/passwd                        不输出passwd的内容，而是输出相同个数的空行，进一步解释了awk是一行一行处理文本
awk '{print "a"}'   /etc/passwd                       输出相同个数的a行，一行只有一个a字母
awk -F:  '{print $1}'  /etc/passwd  ==   awk  -F  ":"  '{print $1}'  /etc/passwd
awk -F: '{print $1 $2}'                                  输入字段1,2，中间不分隔
awk -F: '{print $1,$3,$6}' OFS="\t" /etc/passwd          输出字段1,3,6， 以制表符作为分隔符
awk -F: '{print $1; print $2}'   /etc/passwd             输入字段1,2，分行输出
awk -F: '{print $1 "**" print $2}'   /etc/passwd         输入字段1,2，中间以**分隔
awk -F: '{print "name:"$1"\tid:"$3}' /etc/passwd         自定义格式输出字段1,2
awk -F: '{print NF}' /etc/passwd                         显示每行有多少字段
awk -F: 'NF>2{print }' /etc/passwd                       将每行字段数大于2的打印出来
awk -F: 'NR==5{print}' /etc/passwd                       打印出/etc/passwd文件中的第5行
awk -F: 'NR==5|NR==6{print}' /etc/passwd                 打印出/etc/passwd文件中的第5行和第6行
awk -F: 'NR!=1{print}'  /etc/passwd                      不显示第一行
awk -F: '{print > "1.txt"}'  /etc/passwd                 输出到文件中
awk -F: '{print}' /etc/passwd > 2.txt                    使用重定向输出到文件中               
```

> 字符匹配

```scss
awk  -F: '/root/{print }'  /etc/passwd                         打印出文件中含有root的行
awk  -F: '/'$A'/{print }'  /etc/passwd                         打印出文件中含有变量 $A的行
awk -F: '!/root/{print}' /etc/passwd                           打印出文件中不含有root的行
awk -F:  '/root|tom/{print}'  /etc/passwd                    打印出文件中含有root或者tom的行
awk -F: '/mail/,mysql/{print}'  test                            打印出文件中含有 mail*mysql 的行，*代表有0个或任意多个字符
awk -F: '/^[2][7][7]*/{print}'  test                              打印出文件中以27开头的行，如27,277,27gff 等等
awk -F: '$1~/root/{print}' /etc/passwd                     打印出文件中第一个字段是root的行
awk -F: '($1=="root"){print}' /etc/passwd               打印出文件中第一个字段是root的行，与上面的等效
awk -F: '$1!~/root/{print}' /etc/passwd                   打印出文件中第一个字段不是root的行
awk -F: '($1!="root"){print}' /etc/passwd                打印出文件中第一个字段不是root的行，与上面的等效
awk -F: '$1~/root|ftp/{print}' /etc/passwd               打印出文件中第一个字段是root或ftp的行
awk -F: '($1=="root"||$1=="ftp"){print}' /etc/passwd   打印出文件中第一个字段是root或ftp的行，与上面的等效
awk -F: '$1!~/root|ftp/{print}' /etc/passwd              打印出文件中第一个字段不是root或不是ftp的行
awk -F: '($1!="root"||$1!="ftp"){print}' /etc/passwd    打印出文件中第一个字段不是root或不是ftp的行，与上面等效
awk -F: '{if($1~/mail/) {print $1} else {print $2}}'  /etc/passwd   如果第一个字段是mail，则打印第一个字段，否则打印第2个字段
```

> 格式化输出

```powershell
awk  '{printf  "%-5s %.2d",$1,$2}'  test
```

- printf 表示格式输出
- %格式化输出分隔符
- -8表示长度为8个字符
- s表示字符串类型，d表示小数

##### 使用实例

> 先创建一个名为 marks.txt 的文件。其中包括序列号、学生名字、课程名称与所得分数。

```txt
1)    张三    语文    80
2)    李四    数学    90
3)    王五    英语    87
```

（1）使用 AWK 脚本来显示输出文件中的内容，同时输出表头信息

```powershell
awk 'BEGIN{printf "序号\t名字\t课程\t分数\n"} {print}' marks.txt
```

![60653212999](assets/1606532129995-1606532133045.png)

程序开始执行时，AWK 在开始块中输出表头信息。在主体块中，AWK 每读入一行就将读入的内容输出至标准输出流中，一直到整个文件被全部读入为止

（2）输出marks.txt文本中姓名和分数

```powershell
# 每行按空格或TAB分割，输出文本中的2、4项
awk 'BEGIN{printf "姓名\t分数\n"} {print $2,$4 }' marks.txt
```

![60653251952](assets/1606532519523-1606532521384.png)

###### 基本用法

log.txt文本内容如下：

```txt
2 this is a test
3 Are you like awk
This's a test
10 There are orange,apple,mongo
```

用法一：单行匹配

```powershell
awk '{[pattern] action}' {filenames}   # 行匹配语句 awk '' 只能用单引号
```

实例：

```powershell
# 每行按空格或TAB分割，输出文本中的1、4项
 $ awk '{print $1,$4}' log.txt
 ---------------------------------------------
 2 a
 3 like
 This's
 10 orange,apple,mongo
 
 # 格式化输出
 $ awk '{printf "%-8s %-10s\n",$1,$4}' log.txt
 ---------------------------------------------
 2        a
 3        like
 This's
 10       orange,apple,mongo
```

用法二：分割字符

```
awk -F  #-F相当于内置变量FS, 指定分割字符
```

实例：字符分割

```powershell
# 使用","分割
 $  awk -F, '{print $1,$2}'   log.txt
 ---------------------------------------------
 2 this is a test
 3 Are you like awk
 This's a test
 10 There are orange apple
 
 # 或者使用内建变量
 $ awk 'BEGIN{FS=","} {print $1,$2}'     log.txt
 ---------------------------------------------
 2 this is a test
 3 Are you like awk
 This's a test
 10 There are orange apple
 
 # 使用多个分隔符.先使用空格分割，然后对分割结果再使用","分割
 $ awk -F '[ ,]'  '{print $1,$2,$5}'   log.txt
 ---------------------------------------------
 2 this test
 3 Are awk
 This's a
 10 There apple
```

用法三：设置变量

```powershell
awk -v  # 设置变量
```

实例：

```powershell
 $ awk -va=1 '{print $1,$1+a}' log.txt
 ---------------------------------------------
 2 3
 3 4
 This's 1
 10 11
 $ awk -va=1 -vb=s '{print $1,$1+a,$1b}' log.txt
 ---------------------------------------------
 2 3 2s
 3 4 3s
 This's 1 This'ss
 10 11 10s
```

用法四：awk脚本

```
awk -f {awk脚本} {文件名}
```

实例：

```
 $ awk -f cal.awk log.txt
```

常用的命令：

- **~ 表示模式开始。// 中是模式。** 

```powershell
awk '$1>2' log.txt                                  #命令 过滤第一列大于2的行
awk '$1==2 {print $1,$3}' log.txt                   #命令 过滤第一列等于2的行
awk '$1>2 && $2=="Are" {print $1,$2,$3}' log.txt    #命令 过滤第一列大于2并且第二列等于'Are'的行
awk '$2 ~ /th/ {print $2,$4}' log.txt               # 输出第二列包含 "th"，并打印第二列与第四列
awk '/re/ ' log.txt                                 # 输出包含 "re" 的行
awk 'BEGIN{IGNORECASE=1} /this/' log.txt            # 忽略大小写
awk '$2 !~ /th/ {print $2,$4}' log.txt              # 模式取反
```

###### 常用场景示例

```txt
1) Amit    Physics        80
2) Rahul    Maths        90
3) Shyam    Biology        87
4) Kedar    English        85
5) Hari    History        89
```

**打印某列或者字段** 

```powershell
awk '{print $3 "\t" $4}' marks.txt   #打印某列或者字段

Physics    80
Maths    90
Biology    87
English    85
History    89

# $3 和 $4 代表了输入记录中的第三和第四个字段。
```

**打印所有的行** 

默认情况下，AWK 会打印出所有匹配模式的行

```bash
$ awk '/a/ {print $0}' marks.txt
2)  Rahul   Maths    90
3)  Shyam   Biology  87
4)  Kedar   English  85
5)  Hari    History  89
```

上述命令会判断每一行中是否包含 a，如果包含则打印该行，如果 BODY 部分缺失则默认会执行打印，因此，上述命令和下面这个是等价的

```bash
$ awk '/a/' marks.txt
```

**打印匹配模式的列** 

当模式匹配成功时，默认情况下 AWK 会打印该行，但是也可以让它只打印指定的字段。例如，下面的例子中，只会打印出匹配模式的第三和第四个字段。

```bash
$ awk '/a/ {print $3 "\t" $4}' marks.txt
Maths    90
Biology    87
English    85
History    89
```

**任意顺序打印列**

```bash
$ awk '/a/ {print $4 "\t" $3}' marks.txt
90    Maths
87    Biology
85    English
89    History
```

**统计匹配模式的行数** 

```bash
$ awk '/a/{++cnt} END {print "Count = ", cnt}' marks.txt
Count =  4
```

**打印超过 18 个字符的行** 

```bash
$ awk 'length($0) > 18' marks.txt
3) Shyam   Biology   87
4) Kedar   English   85
```

**查找 history 历史中，最常用的 10 个命令** 

```bash
history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
```

**过滤文件中重复行** 

```bash
awk '!x[$0]++' <file> 
```

**将一行长度超过 72 字符的行打印** 

```bash
awk 'length>72' file
```

**查看最近哪些用户使用系统** 

```bash
last | grep -v "^$" | awk '{ print $1 }' | sort -nr | uniq -c
```

**计算文本中的数值的和** 

```bash
awk '{s+=$1} ENG {printf "%.0f", s}' /path/to/file
```

[awk过滤统计不重复的行](https://www.cnblogs.com/beautiful-code/p/5783517.html) 

- awk以‘\t’为分隔符区分列

  ```bash
  cat logs | grep IconsendRedirect | grep 1752 | awk -F'\t' '{print $8}'| wc -l
  ```

- awk过滤统计不重复的行

  ```bash
  cat hello.txt | awk '!a[$0]++' | wc -l
  ```

相关文章：

1. [Linux awk 命令](https://www.runoob.com/linux/linux-comm-awk.html) 

#### 1.2 sed 

**sed**是一种流编辑器，它是文本处理中非常好的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed[命令](https://www.linuxcool.com/)处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件，可以将数据行进行替换、删除、新增、选取等特定工作，简化对文件的反复操作，编写转换程序等。

 **语法** 



**相关文章** 

- [Linux之sed命令详解](https://www.linuxprobe.com/linux-sed-command.html) 

















