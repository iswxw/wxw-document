## 持久层框架 MyBatis

---

![](./assets/mybatis.png)  

MyBatis SQL映射器框架使将关系数据库与面向对象的应用程序结合使用变得更加容易。MyBatis使用XML描述符或注释将对象与存储过程或SQL语句耦合。与对象关系映射工具相比，简单性是MyBatis数据映射器的最大优势。

- [官方文档](https://mybatis.org/mybatis-3/) || [源码](https://github.com/mybatis/mybatis-3) 
- [Download Latest](https://github.com/mybatis/mybatis-3/releases) 
- [Download Snapshot](https://oss.sonatype.org/content/repositories/snapshots/org/mybatis/mybatis/) 
- [Mybatis 源码构建](https://github.com/tuguangquan/mybatis) 
- [wxw-mybatis 源码](https://github.com/GitHubWxw/wxw-mybatis) 学习

## MyBatis 初识



## MyBatis 原理篇

### 1. MyBatis 本质与特性

### 2. MyBatis 高级功能与扩展

### 3. MyBatis 工作原理

### 4.  MyBatis 一二级缓存详解

#### 4.1 一级缓存

一级缓存默认开启，缓存范围为SqlSession会话，即一个session对象，范围太小，声明周期短。两个session对象查询后，数据存储在不同的内存地址中。当我们在commit提交后会强制清空namespace缓存。

> 高缓存命中率，提高查询速度，使用二级缓存。

#### 4.2 二级缓存



相关文章

1. https://github.com/GitHubWxw/wxw-concurrent/tree/dev-wxw/cloud-cached 

## MyBatis 实用篇

### 1. 理解插件原理，自定义插件

### 2. MyBatis 在Spring中如何保证线程安全

## MyBatis 案例

#### （1）返回值设置

##### 1. Mybatis 查询返回List集合

- 返回List<String>集合时，需要将resultType的值定义为集合中元素类型，而不是返回集合本身

  ```xml
  <select id="groupNameList" resultType="java.lang.String">
  	SELECT `asset_name` FROM `asset` group by `asset_name`
  </select>
  ```

- resultType是sql映射文件中定义返回值类型，返回值有基本类型，对象类型，List类型，Map类型等。现总结一下再解释


  resultType:

  1、基本类型  ：resultType=基本类型

  2、List类型：   resultType=List中元素的类型

  3、Map类型     resultType =map

##### （2）if 标签——关键字 In

> 封装入参为map集合

```java
Map<String, Object> params = new HashMap<String, Object>();
        params.put("otherNumber", otherNumber);
        params.put("isPass", "0,1,2,3,4");
List<SchoolCustomer> getSchoolCustomerByPhone(Map<String, Object> params);

```

> Mapper 封装返回Map集合

```xml
<select id="getSchoolCustomerByPhone" parameterType="java.util.Map" resultMap="BaseResultMap">
  	SELECT
  	<include refid="Base_Column_List" />
  	from [B_SchoolCustomer]
  	<where>
      <trim prefix="(" prefixOverrides="AND" suffix=")">
        <if test="otherNumber != null">
          // 替换函数
          and REPLACE(otherNumber,'-','') = #{otherNumber}
        </if>
        <if test="isPass != null">
	  	  and isPass in ( ${isPass} )
	  	</if>
	  </trim>
    </where>
    order by addTime asc
 </select>
```



**相关文章** 



























