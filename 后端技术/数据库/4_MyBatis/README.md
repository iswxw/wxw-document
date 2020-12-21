## MyBatis SQL Mapper Java框架

---

![](./assets/mybatis.png)  

MyBatis SQL映射器框架使将关系数据库与面向对象的应用程序结合使用变得更加容易。MyBatis使用XML描述符或注释将对象与存储过程或SQL语句耦合。与对象关系映射工具相比，简单性是MyBatis数据映射器的最大优势。

- [官方文档](https://mybatis.org/mybatis-3/) || [源码](https://github.com/mybatis/mybatis-3) 
- [Download Latest](https://github.com/mybatis/mybatis-3/releases) 
- [Download Snapshot](https://oss.sonatype.org/content/repositories/snapshots/org/mybatis/mybatis/) 
- [Mybatis 源码构建](https://github.com/tuguangquan/mybatis) 

## MyBatis 基础知识



## MyBatis 缓存架构



### 二、MyBatis 的用法

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

1. [Mybatis 从0到1](https://my.oschina.net/u/4728925/blog/4783514) 



























