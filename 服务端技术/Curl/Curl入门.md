![curl logo](https://curl.haxx.se/logo/curl-logo.svg)

[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/63/badge)](https://bestpractices.coreinfrastructure.org/projects/63)[![Coverity passed](https://scan.coverity.com/projects/curl/badge.svg)](https://scan.coverity.com/projects/curl)[[![Sponsors on Open Collective](https://opencollective.com/curl/sponsors/badge.svg)](#sponsors)

- Curl是用于传输用URL语法指定的数据的命令行工具。阅读[curl.1手册页](https://curl.haxx.se/docs/manpage.html)或[MANUAL文档，](https://curl.haxx.se/docs/manual.html)了解如何使用curl 。阅读[INSTALL文档，](https://curl.haxx.se/docs/install.html)了解如何安装Curl 。

- libcurl是curl用来完成其工作的库。您的软件可以随时使用它。阅读[libcurl.3手册页](https://curl.haxx.se/libcurl/c/libcurl.html)以了解操作方法！

  您可以在[常见问题解答文档中](https://curl.haxx.se/docs/faq.html)找到最常见问题的答案。

- 官网地址：https://curl.haxx.se

- git 地址：` git clone https://github.com/curl/curl.git` 

### 概述

> curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。

它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。



### 开发指南

#### 1. curl  基本命令

`  curl [-可选参数]  www.baidu.com  // 默认是get请求`

|                  命令组合                  |         命令参数          | 参数解释                                                     | 类型         |
| :----------------------------------------: | :-----------------------: | ------------------------------------------------------------ | ------------ |
|       curl -o [文件名] www.sina.com        |            -o             | 查看网页源码（ -o 相当于wget,可以将当前页面保存下来）        | 查看源码     |
|            curl -L www.sina.com            |            -L             | 自动跳转 （使用`-L`参数，curl就会跳转到新的网址）            | 自动跳转     |
|            curl -i www.sina.com            |            -i             | 显示http response的头信息                                    | 显示头信息   |
|            curl -v www.sina.com            |            -v             | 显示一次http通信的整个过程，包括端口连接和http request头信息 | 显示通信过程 |
|    curl --trace output.txt www.sina.com    |    --trace output.txt     | 更详细的通信http过程,输出到文件                              | ——           |
| curl --trace-ascii output.txt www.sina.com | --trace-ascii  output.txt | 更详细的通信http过程，输出到文件                             | ——           |

```php
# 调试类
-v, --verbose                          输出信息
-q, --disable                          在第一个参数位置设置后 .curlrc 的设置直接失效，这个参数会影响到 -K, --config -A, --user-agent -e, --referer
-K, --config FILE                      指定配置文件
-L, --location                         跟踪重定向 (H)

# CLI显示设置
-s, --silent                           Silent模式。不输出任务内容
-S, --show-error                       显示错误. 在选项 -s 中，当 curl 出现错误时将显示
-f, --fail                             不显示 连接失败时HTTP错误信息
-i, --include                          显示 response的header (H/F)
-I, --head                             仅显示 响应文档头
-l, --list-only                        只列出FTP目录的名称 (F)
-#, --progress-bar                     以进度条 显示传输进度

# 数据传输类
-X, --request [GET|POST|PUT|DELETE|…]  使用指定的 http method 例如 -X POST
-H, --header <header>                  设定 request里的header 例如 -H "Content-Type: application/json"
-e, --referer                          设定 referer (H)
-d, --data <data>                      设定 http body 默认使用 content-type application/x-www-form-urlencoded (H)
    --data-raw <data>                  ASCII 编码 HTTP POST 数据 (H)
    --data-binary <data>               binary 编码 HTTP POST 数据 (H)
    --data-urlencode <data>            url 编码 HTTP POST 数据 (H)
-G, --get                              使用 HTTP GET 方法发送 -d 数据 (H)
-F, --form <name=string>               模拟 HTTP 表单数据提交 multipart POST (H)
    --form-string <name=string>        模拟 HTTP 表单数据提交 (H)
-u, --user <user:password>             使用帐户，密码 例如 admin:password
-b, --cookie <data>                    cookie 文件 (H)
-j, --junk-session-cookies             读取文件中但忽略会话cookie (H)
-A, --user-agent                       user-agent设置 (H)

# 传输设置
-C, --continue-at OFFSET               断点续转
-x, --proxy [PROTOCOL://]HOST[:PORT]   在指定的端口上使用代理
-U, --proxy-user USER[:PASSWORD]       代理用户名及密码

# 文件操作
-T, --upload-file <file>               上传文件
-a, --append                           添加要上传的文件 (F/SFTP)

# 输出设置
-o, --output <file>                    将输出写入文件，而非 stdout
-O, --remote-name                      将输出写入远程文件
-D, --dump-header <file>               将头信息写入指定的文件
-c, --cookie-jar <file>                操作结束后，要写入 Cookies 的文件位置
```

#### 2. 发送表单信息

> 发送表单信息有GET和POST两种方法

- **Get 请求** : 默认为Get，只需要把网址写在后面就可以

```php
 curl 127.0.0.1:8080/ip/info   // 发送Get 请求
```

- **Post 请求** ：POST方法必须把数据和网址分开，curl就要用到--data参数

```php
curl -X POST --data "data=xxx" 127.0.0.1:8080/ip/post
    
curl -X POST --data-urlencode "date=April 1" 127.0.0.1:8080/ip/post  // 如果你的数据没有经过表单编码，还可以让curl为你编码，参数是`--data-urlencode` 这样就不会中文乱码
```

#### 3. HTTP 动词

> curl默认的HTTP动词是GET，使用`-X`参数可以支持其他动词。

```pgp
curl -X POST www.example.com
curl -X DELETE www.example.com
```

- **增加头信息**

  有时需要在http request之中，自行增加一个头信息。`--header`参数就可以起到这个作用。

  ```http
   curl --header "Content-Type:application/json" http://example.com
  ```

#### 4. 文件上传

假设文件上传是这样：

```html
　<form method="POST" enctype='multipart/form-data' action="upload.cgi">
　　　　<input type=file name=upload>
　　　　<input type=submit name=press value="OK">
　　</form>
```

你可以用curl这样上传文件：

```bash
curl --form upload=@localfilename --form press=OK [URL]
```

#### 5. **Referer字段**

有时你需要在http request头信息中，提供一个referer字段，表示你是从哪里跳转过来的。

```php
curl --referer http://www.example.com http://www.example.com
```

#### 6. **User Agent字段**

这个字段是用来表示客户端的设备信息。服务器有时会根据这个字段，针对不同设备，返回不同格式的网页，比如手机版和桌面版。

- 比如：iPhone4的User Agent如下：

  ```css
  　Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7
  ```

- curl可以这样模拟

  ```CQL
  $ curl --user-agent "[User Agent]" [URL]
  ```

#### 7. Cookie

> 使用`--cookie`参数，可以让curl发送cookie。

```http
    curl --cookie "name=xxx" www.example.com
```

至于具体的cookie的值，可以从http response头信息的`Set-Cookie`字段中得到。

- `-c cookie-file`可以保存服务器返回的cookie到文件

- `-b cookie-file`可以使用这个文件作为cookie信息，进行后续的请求。

```http
　  curl -c cookies http://example.com
　　curl -b cookies http://example.com
```

#### 8. HTTP 认证

- 有些网域需要HTTP认证，这时curl需要用到`--user`参数。

  ```http
  curl --user name:password example.com
  ```

### 实践案例

### 附件开发手册

> ` curl --help   // 查看帮助手册`    

```bash
在以下选项中，(H) 表示仅适用 HTTP/HTTPS ，(F) 表示仅适用于 FTP
    --anyauth      选择 "any" 认证方法 (H)
-a, --append        添加要上传的文件 (F/SFTP)
    --basic        使用HTTP基础认证（Basic Authentication）(H)
    --cacert FILE  CA 证书，用于每次请求认证 (SSL)
    --capath DIR    CA 证书目录 (SSL)
-E, --cert CERT[:PASSWD] 客户端证书文件及密码 (SSL)
    --cert-type TYPE 证书文件类型 (DER/PEM/ENG) (SSL)
    --ciphers LIST  SSL 秘钥 (SSL)
    --compressed    请求压缩 (使用 deflate 或 gzip)
-K, --config FILE  指定配置文件
    --connect-timeout SECONDS  连接超时设置
-C, --continue-at OFFSET  断点续转
-b, --cookie STRING/FILE  Cookies字符串或读取Cookies的文件位置 (H)
-c, --cookie-jar FILE  操作结束后，要写入 Cookies 的文件位置 (H)
    --create-dirs  创建必要的本地目录层次结构
    --crlf          在上传时将 LF 转写为 CRLF
    --crlfile FILE  从指定的文件获得PEM格式CRL列表
-d, --data DATA    HTTP POST 数据 (H)
    --data-ascii DATA  ASCII 编码 HTTP POST 数据 (H)
    --data-binary DATA  binary 编码 HTTP POST 数据 (H)
    --data-urlencode DATA  url 编码 HTTP POST 数据 (H)
    --delegation STRING GSS-API 委托权限
    --digest        使用数字身份验证 (H)
    --disable-eprt  禁止使用 EPRT 或 LPRT (F)
    --disable-epsv  禁止使用 EPSV (F)
-D, --dump-header FILE  将头信息写入指定的文件
    --egd-file FILE  为随机数据设置EGD socket路径(SSL)
    --engine ENGINGE  加密引擎 (SSL). "--engine list" 指定列表
-f, --fail          连接失败时不显示HTTP错误信息 (H)
-F, --form CONTENT  模拟 HTTP 表单数据提交（multipart POST） (H)
    --form-string STRING  模拟 HTTP 表单数据提交 (H)
    --ftp-account DATA  帐户数据提交 (F)
    --ftp-alternative-to-user COMMAND  指定替换 "USER [name]" 的字符串 (F)
    --ftp-create-dirs  如果不存在则创建远程目录 (F)
    --ftp-method [MULTICWD/NOCWD/SINGLECWD] 控制 CWD (F)
    --ftp-pasv      使用 PASV/EPSV 替换 PORT (F)
-P, --ftp-port ADR  使用指定 PORT 及地址替换 PASV (F)
    --ftp-skip-pasv-ip 跳过 PASV 的IP地址 (F)
    --ftp-pret      在 PASV 之前发送 PRET (drftpd) (F)
    --ftp-ssl-ccc  在认证之后发送 CCC (F)
    --ftp-ssl-ccc-mode ACTIVE/PASSIVE  设置 CCC 模式 (F)
    --ftp-ssl-control ftp 登录时需要 SSL/TLS (F)
-G, --get          使用 HTTP GET 方法发送 -d 数据  (H)
-g, --globoff      禁用的 URL 队列 及范围使用 {} 和 []
-H, --header LINE  要发送到服务端的自定义请求头 (H)
-I, --head          仅显示响应文档头
-h, --help          显示帮助
-0, --http1.0      使用 HTTP 1.0 (H)
    --ignore-content-length  忽略 HTTP Content-Length 头
-i, --include      在输出中包含协议头 (H/F)
-k, --insecure      允许连接到 SSL 站点，而不使用证书 (H)
    --interface INTERFACE  指定网络接口／地址
-4, --ipv4          将域名解析为 IPv4 地址
-6, --ipv6          将域名解析为 IPv6 地址
-j, --junk-session-cookies 读取文件中但忽略会话cookie (H)
    --keepalive-time SECONDS  keepalive 包间隔
    --key KEY      私钥文件名 (SSL/SSH)
    --key-type TYPE 私钥文件类型 (DER/PEM/ENG) (SSL)
    --krb LEVEL    启用指定安全级别的 Kerberos (F)
    --libcurl FILE  命令的libcurl等价代码
    --limit-rate RATE  限制传输速度
-l, --list-only    只列出FTP目录的名称 (F)
    --local-port RANGE  强制使用的本地端口号
-L, --location      跟踪重定向 (H)
    --location-trusted 类似 --location 并发送验证信息到其它主机 (H)
-M, --manual        显示全手动
    --mail-from FROM  从这个地址发送邮件
    --mail-rcpt TO  发送邮件到这个接收人(s)
    --mail-auth AUTH  原始电子邮件的起始地址
    --max-filesize BYTES  下载的最大文件大小 (H/F)
    --max-redirs NUM  最大重定向数 (H)
-m, --max-time SECONDS  允许的最多传输时间
    --metalink      处理指定的URL上的XML文件
    --negotiate    使用 HTTP Negotiate 认证 (H)
-n, --netrc        必须从 .netrc 文件读取用户名和密码
    --netrc-optional 使用 .netrc 或 URL; 将重写 -n 参数
    --netrc-file FILE  设置要使用的 netrc 文件名
-N, --no-buffer    禁用输出流的缓存
    --no-keepalive  禁用 connection 的 keepalive
    --no-sessionid  禁止重复使用 SSL session-ID (SSL)
    --noproxy      不使用代理的主机列表
    --ntlm          使用 HTTP NTLM 认证 (H)
-o, --output FILE  将输出写入文件，而非 stdout
    --pass PASS    传递给私钥的短语 (SSL/SSH)
    --post301      在 301 重定向后不要切换为 GET 请求 (H)
    --post302      在 302 重定向后不要切换为 GET 请求 (H)
    --post303      在 303 重定向后不要切换为 GET 请求 (H)
-#, --progress-bar  以进度条显示传输进度
    --proto PROTOCOLS  启用/禁用 指定的协议
    --proto-redir PROTOCOLS  在重定向上 启用/禁用 指定的协议
-x, --proxy [PROTOCOL://]HOST[:PORT] 在指定的端口上使用代理
    --proxy-anyauth 在代理上使用 "any" 认证方法 (H)
    --proxy-basic  在代理上使用 Basic 认证  (H)
    --proxy-digest  在代理上使用 Digest 认证 (H)
    --proxy-negotiate 在代理上使用 Negotiate 认证 (H)
    --proxy-ntlm    在代理上使用 NTLM 认证 (H)
-U, --proxy-user USER[:PASSWORD]  代理用户名及密码
    --proxy1.0 HOST[:PORT]  在指定的端口上使用 HTTP/1.0 代理
-p, --proxytunnel  使用HTTP代理 (用于 CONNECT)
    --pubkey KEY    公钥文件名 (SSH)
-Q, --quote CMD    在传输开始前向服务器发送命令 (F/SFTP)
    --random-file FILE  读取随机数据的文件 (SSL)
-r, --range RANGE  仅检索范围内的字节
    --raw          使用原始HTTP传输，而不使用编码 (H)
-e, --referer      Referer URL (H)
-J, --remote-header-name 从远程文件读取头信息 (H)
-O, --remote-name  将输出写入远程文件
    --remote-name-all 使用所有URL的远程文件名
-R, --remote-time  将远程文件的时间设置在本地输出上
-X, --request COMMAND  使用指定的请求命令
    --resolve HOST:PORT:ADDRESS  将 HOST:PORT 强制解析到 ADDRESS
    --retry NUM  出现问题时的重试次数
    --retry-delay SECONDS 重试时的延时时长
    --retry-max-time SECONDS  仅在指定时间段内重试
-S, --show-error    显示错误. 在选项 -s 中，当 curl 出现错误时将显示
-s, --silent        Silent模式。不输出任务内容
    --socks4 HOST[:PORT]  在指定的 host + port 上使用 SOCKS4 代理
    --socks4a HOST[:PORT]  在指定的 host + port 上使用 SOCKSa 代理
    --socks5 HOST[:PORT]  在指定的 host + port 上使用 SOCKS5 代理
    --socks5-hostname HOST[:PORT] SOCKS5 代理，指定用户名、密码
    --socks5-gssapi-service NAME  为gssapi使用SOCKS5代理服务名称
    --socks5-gssapi-nec  与NEC Socks5服务器兼容
-Y, --speed-limit RATE  在指定限速时间之后停止传输
-y, --speed-time SECONDS  指定时间之后触发限速. 默认 30
    --ssl          尝试 SSL/TLS (FTP, IMAP, POP3, SMTP)
    --ssl-reqd      需要 SSL/TLS (FTP, IMAP, POP3, SMTP)
-2, --sslv2        使用 SSLv2 (SSL)
-3, --sslv3        使用 SSLv3 (SSL)
    --ssl-allow-beast 允许的安全漏洞，提高互操作性(SSL)
    --stderr FILE  重定向 stderr 的文件位置. - means stdout
    --tcp-nodelay  使用 TCP_NODELAY 选项
-t, --telnet-option OPT=VAL  设置 telnet 选项
    --tftp-blksize VALUE  设备 TFTP BLKSIZE 选项 (必须 >512)
-z, --time-cond TIME  基于时间条件的传输
-1, --tlsv1        使用 => TLSv1 (SSL)
    --tlsv1.0      使用 TLSv1.0 (SSL)
    --tlsv1.1      使用 TLSv1.1 (SSL)
    --tlsv1.2      使用 TLSv1.2 (SSL)
    --trace FILE    将 debug 信息写入指定的文件
    --trace-ascii FILE  类似 --trace 但使用16进度输出
    --trace-time    向 trace/verbose 输出添加时间戳
    --tr-encoding  请求压缩传输编码 (H)
-T, --upload-file FILE  将文件传输（上传）到指定位置
    --url URL      指定所使用的 URL
-B, --use-ascii    使用 ASCII/text 传输
-u, --user USER[:PASSWORD]  指定服务器认证用户名、密码
    --tlsuser USER  TLS 用户名
    --tlspassword STRING TLS 密码
    --tlsauthtype STRING  TLS 认证类型 (默认 SRP)
    --unix-socket FILE    通过这个 UNIX socket 域连接
-A, --user-agent STRING  要发送到服务器的 User-Agent (H)
-v, --verbose      显示详细操作信息
-V, --version      显示版本号并退出
-w, --write-out FORMAT  完成后输出什么
    --xattr        将元数据存储在扩展文件属性中
-q            .curlrc 如果作为第一个参数无效
```







