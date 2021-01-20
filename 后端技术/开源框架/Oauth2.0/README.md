### Oauth 2.0 授权机制



在了解 Oauth 2.0 之前，我们先看一下**令牌**和**密码**到底有什么关系，其实令牌（token）与密码（password）的作用是一样的，都可以进入系统，但是有三点差异：

1. 令牌是短期的，到期会自动失效，且用户自己无法修改；密码一般长期有效，用户不修改，就不会发生变化。
2. 令牌可以被数据的所有者撤销，会立即失效。
3. 令牌有权限范围（scope）对于网络服务来说，只读令牌就比读写令牌更安全。密码一般是完整权限。

上面这些设计，保证了令牌既可以让第三方应用获得权限，同时又随时可控，不会危及系统安全。这就是 OAuth 2.0 的优点。

但是需要注意：只要知道了令牌，就能进入系统。系统一般不会再次确认身份，所以**令牌必须保密，泄漏令牌与泄漏密码的后果是一样的。**这也是为什么令牌的有效期，一般都设置得很短的原因。

### 什么是Oauth 2.0

OAuth 2.0 是一种授权机制，主要用来颁发令牌（token）.

OAuth 2.0  引入了一个授权层，用来分离两种不同的角色：客户端和资源所有者。待资源所有者同意以后，资源服务器可以向客户端颁发令牌。客户端通过令牌，去资源服务器请求数据。

- RFC开放标准文件：https://tools.ietf.org/html/rfc6749

#### 1. 应用场景

##### （1）第三方应用授权登录

在APP或者网页接入一些第三方应用时，时长需要用户登录另外一个合作平台，比如：QQ、微博、微信、Github、码云等授权登录。

下面以登录基于码云存储的图床案例进行分析：

- 图床地址：http://image.kevinlu98.cn/
- 码云授权第三方服务应用：https://gitee.com/oauth/applications

##### （2）原生APP 授权

app登录请求后台接口，为了安全认证，所有请求都带token信息，如果登录验证、请求后台数据。

##### （3）前后单分离单页面应用

前后端分离框架，前端请求后台数据，需要进行oauth2安全认证，比如使用vue、react后者h5开发的app。

#### 2. 名词说明

- 第三方应用：本文中又称"客户端"（client），比如打开知乎，使用第三方登录，选择qq登录，这时候知乎就是客户端。
- HTTP service：HTTP服务提供商，简称"服务提供商"，即上例的qq。
- 资源所有者（Resource  Owner）：也就是登录用户
- 用户代理（user agent）：也就是浏览器
- 认证服务（Authorization server）：服务提供商专门用来处理认证的服务器
- 资源服务器（Resource server）：服务提供商存放用户生成的资源的服务器。它与认证服务器，可以是同一台服务器，也可以是不同的服务器。

### Oauth 2.0 运行流程

```hxml
     +--------+                               +---------------+
     |        |--(A)- Authorization Request ->|   Resource    |
     |        |                               |     Owner     |
     |        |<-(B)-- Authorization Grant ---|  （登录用户）  |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(C)-- Authorization Grant -->| Authorization |
     | Client |                               |     Server    |
     |        |<-(D)----- Access Token -------|  （授权服务）  |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(E)----- Access Token ------>|    Resource   |
     |        |                               |     Server    |
     |        |<-(F)--- Protected Resource ---|  （资源服务）  |
     +--------+                               +---------------+
```

这四个角色之间的交互，包括以下的步骤：

1. （A）用户打开客户端以后，客户端要求用户给予授权。
2. （B）用户同意给予客户端授权。
3. （C）客户端使用上一步获得的授权，向认证服务器申请令牌。
4. （D）认证服务器对客户端进行认证以后，确认无误，同意发放令牌。
5. （E）客户端使用令牌，向资源服务器申请获取资源。
6. （F）资源服务器确认令牌无误，同意向客户端开放资源。

### Oauth 2.0 授权模式

> RFC 6749 开放标准文件定义了四种授权令牌的方式 [快速访问](https://tools.ietf.org/html/rfc6749) 

1. 授权码（authorization-code）
2. 隐藏式（implicit）
3. 密码式（password）：
4. 客户端凭证（client credentials）

**注意** 不管哪一种授权方式，第三方应用申请令牌之前，都必须先到系统备案，说明自己的身份，然后会拿到两个身份识别码：

- 客户端 ID（client ID）
- 客户端密钥（client secret）

这是为了防止令牌被滥用，没有备案过的第三方应用，是不会拿到令牌的。

#### 1. 授权码

授权码模式（authorization code）最常用、安全性也最高，适用于有后端的Web应用，授权码通过前端传送，令牌则是储存在后端，而且所有与资源服务器的通信都是在后端完成，这样前后端分离可以避免令牌泄漏。

- 第一步：A 网站提供一个链接，用户点击后就会跳转到 B 网站，授权用户数据给 A 网站使用。下面就是 A 网站跳转 B 网站的一个示意链接。

` A网站———————1. 请求授权码—————————>B网站`

```scss
https://b.com/oauth/authorize?  // 请求路径
  response_type=code&           // 要求返回授权码（code）
  client_id=CLIENT_ID&          // 让B知道是谁在请求（需要提前备案）
  redirect_uri=CALLBACK_URL&    // B 接受或者拒绝请求的跳转链接
  scope=read                    // 要求的授权范围（这里是只读）
```

- 第二步：用户跳转后，B 网站会要求用户登录，然后询问是否同意给予 A 网站授权。用户表示同意，这时 B 网站就会跳回`redirect_uri`参数指定的网址。跳转时，会传回一个授权码，就像下面这样。

  ```scss
  https://a.com/callback?code=AUTHORIZATION_CODE   // Code 就是授权码
  ```

```
A网站———————1. 请求授权码—————————>B网站
    <———————2. 返回授权码———————————
```

- 第三步：A 网站拿到授权码以后，就可以在后端向 B 网站请求令牌。

```scss
https://b.com/oauth/token?
 client_id=CLIENT_ID&       
 client_secret=CLIENT_SECRET&
 grant_type=authorization_code&  // 授权类型为授权码
 code=AUTHORIZATION_CODE&        // 授权码值
 redirect_uri=CALLBACK_URL       // 令牌颁发后的回调网址。
```

```
A网站——————1. 请求授权码—————————>B网站
    <——————2. 返回授权码———————————
    ———————3. 请求令牌—————————>
```

- 第四步，B 网站收到请求以后，就会颁发令牌。具体做法是向`redirect_uri`指定的网址，发送一段 JSON 数据。

```scss
{    
  "access_token":"ACCESS_TOKEN",
  "token_type":"bearer",
  "expires_in":2592000,
  "refresh_token":"REFRESH_TOKEN",
  "scope":"read",
  "uid":100101,
  "info":{...}
}
```

上面 JSON 数据中，`access_token`字段就是令牌，A 网站在后端拿到了。

```
A网站——————1. 请求授权码—————————>B网站
    <——————2. 返回授权码———————————
    ———————3. 请求令牌—————————>
    <——————4. 返回令牌———————————
```

#### 2. 隐藏式

有些 Web 应用是纯前端应用，没有后端。这时就不能用上面的方式了，必须将令牌储存在前端。**RFC 6749 就规定了第二种方式，允许直接向前端颁发令牌。这种方式没有授权码这个中间步骤，所以称为（授权码）"隐藏式"（implicit）。**

- 第一步：A 网站提供一个链接，要求用户跳转到 B 网站，授权用户数据给 A 网站使用。

```scss
https://b.com/oauth/authorize?  
  response_type=token&         // token 表示要求直接返回令牌
  client_id=CLIENT_ID&
  redirect_uri=CALLBACK_URL&
  scope=read
```

- 第二步：用户跳转到 B 网站，登录后同意给予 A 网站授权。这时，B 网站就会跳回`redirect_uri`参数指定的跳转网址，并且把令牌作为 URL 参数，传给 A 网站。

```scss
https://a.com/callback#token=ACCESS_TOKEN   // token参数就是令牌，A 网站因此直接在前端拿到令牌
```

**注意**，令牌的位置是 URL 锚点（fragment），而不是查询字符串（querystring），这是因为 OAuth 2.0 允许跳转网址是 HTTP 协议，因此存在"中间人攻击"的风险，而浏览器跳转时，锚点不会发到服务器，就减少了泄漏令牌的风险。

```java
A网站———————1. 请求令牌—————————>B网站
    <———————2. 返回令牌———————————
```

这种方式把令牌直接传给前端，是很不安全的。因此，只能用于一些安全要求不高的场景，并且令牌的有效期必须非常短，通常就是会话期间（session）有效，浏览器关掉，令牌就失效了。

#### 3. 密码式

**如果你高度信任某个应用，RFC 6749 也允许用户把用户名和密码，直接告诉该应用。该应用就使用你的密码，申请令牌，这种方式称为"密码式"（password）。**

- 第一步：A 网站要求用户提供 B 网站的用户名和密码。拿到以后，A 就直接向 B 请求令牌。

```scss
https://oauth.b.com/token?
  grant_type=password&    // 授权方式,password表示"密码式"
  username=USERNAME&
  password=PASSWORD&      // username和password是 B 的用户名和密码
  client_id=CLIENT_ID
```

- 第二步：B 网站验证身份通过后，直接给出令牌。注意，这时不需要跳转，而是把令牌放在 JSON 数据里面，作为 HTTP 回应，A 因此拿到令牌。

这种方式需要用户给出自己的用户名/密码，显然风险很大，因此只适用于其他授权方式都无法采用的情况，而且必须是用户高度信任的应用。

#### 4. 凭证式

**最后一种方式是凭证式（client credentials），适用于没有前端的命令行应用，即在命令行下请求令牌。**

- 第一步：A 应用在命令行向 B 发出请求。

```java
https://oauth.b.com/token?
  grant_type=client_credentials&   // grant_type参数等于client_credentials表示采用凭证式
  client_id=CLIENT_ID&
  client_secret=CLIENT_SECRET      // client_id和client_secret用来让 B 确认 A 的身份
```

- B 网站验证通过以后，直接返回令牌。

这种方式给出的令牌，是针对第三方应用的，而不是针对用户的，即有可能多个用户共享同一个令牌。

### 令牌的使用

> A 网站拿到令牌以后，就可以向 B 网站的 API 请求数据了。

此时，每个发到 API 的请求，都必须带有令牌。具体做法是在请求的头信息，加上一个`Authorization`字段，令牌就放在这个字段里面。

```curl
curl -H "Authorization: Bearer ACCESS_TOKEN"  "https://api.b.com"   // ACCESS_TOKEN就是拿到的令牌
```

#### 1. 更新令牌

令牌的有效期到了，如果让用户重新走一遍上面的流程，再申请一个新的令牌，很可能体验不好，而且也没有必要。OAuth 2.0 允许用户自动更新令牌。

具体方法是，B 网站颁发令牌的时候，一次性颁发两个令牌，一个用于获取数据，另一个用于获取新的令牌（refresh token 字段）。令牌到期前，用户使用 refresh token 发一个请求，去更新令牌。

```scss
https://b.com/oauth/token?
  grant_type=refresh_token&   // grant_type参数为refresh_token表示要求更新令牌
  client_id=CLIENT_ID&
  client_secret=CLIENT_SECRET& // client_id参数和client_secret参数用于确认身份
  refresh_token=REFRESH_TOKEN  // refresh_token参数就是用于更新令牌的令牌。
```

B 网站验证通过以后，就会颁发新的令牌。

### 实战应用

> SpringBoot 整合 OAuth 2.0 登录Github

- Github地址：[快速访问](https://github.com/GitHubWxw/wxw-tools/tree/master/cloud-open-github) 







