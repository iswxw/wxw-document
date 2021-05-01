### 单元测试



### 1. Mockito的使用

#### 1.1 注解

```java
@InjectMocks  // 根据类型对构造方法,普通方法和字段进行依赖注入
```

#### 1.2 Mockito 常用方法

- **perform**：执行一个 RequestBuilder 请求，返回一个 ResultActions 实例对象，可对请求结果进行期望与其它操作

- **get**：声明发送一个 get 请求的方法，更多的请求类型可查阅→[MockMvcRequestBuilders 文档](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/request/MockMvcRequestBuilders.html)

- **andExpect**：添加 ResultMatcher 验证规则，验证请求结果是否正确，验证规则可查阅→[MockMvcResultMatchers 文档](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/result/MockMvcResultMatchers.html)

- **andDo**：添加 ResultHandler 结果处理器，比如调试时打印结果到控制台，更多处理器可查阅→[MockMvcResultHandlers 文档](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/result/MockMvcResultHandlers.html)

- **andReturn**：返回执行请求的结果，该结果是一个恩 MvcResult 实例对象→[MvcResult 文档](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/test/web/servlet/MvcResult.html) 

1.3 

### 2. Spring Boot 引用单元测试

#### 2.1 Controller层

#### 2.2 Service 层



### 3.后记

> 相关文章

1. [SpringBoot 单元测试与 Mockito 使用](https://juejin.cn/post/6844903924248346637) 
2. [单元测试利器Mockito框架](https://juejin.cn/post/6844903631137800206#heading-3) 

> 常见问题

1. Mockito:org.mockito.exceptions.misusing.InvalidUseOfMatchersException

   ```java
   错误案例：
   Mockito.when(dtagOuterService.saveTagLock(Matchers.same(tagLock))).thenReturn("correct");
   
   从异常的信息来看，显然违反了一个Mockito框架中的Matchers匹配参数的规则。根据Matchers文档如下，在打桩阶段有一个原则，一个mock对象的方法，如果其若干个参数中，有一个是通过Matchers提供的，则该方法的所有参数都必须通过Matchers提供。而不能是有的参数通过Matchers提供，有的参数直接给出真实的具体值。
   解决方法
   就是修改两个都用具体值或者两个都用匹配。
    
   正确案例：
   Mockito.when(callerService.checkCallerAuth(Mockito.anyString(),Mockito.anyInt())).thenReturn(true);
   Mockito.when(dtagOuterService.saveTagLock(Matchers.same(tagLock))).thenReturn("correct");
   ```

2. 

