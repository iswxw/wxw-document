### 数据持久化技术

---

### 一、MyBatis 的用法

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

