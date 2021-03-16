### GoLang 进阶

> 来源bilibili

1. 七米老师的学习视频：[点我传送](https://www.bilibili.com/video/BV17Q4y1P7n9)
2. 李文周老师的博客：[点我传送](https://www.liwenzhou.com/) 
3. [go 标准文档](https://studygolang.com/pkgdoc) ：https://studygolang.com/pkgdoc

### 1.Go mod 管理Go依赖

依赖管理是一个语言非常重要的特性，很大程度上决定着一个语言的流行程度，流行的语言大多都有非常成熟的依赖管理工具：

- Java 的 maven 和 gradle
- javascript 的 npm
- python 的 pip

这些工具极大地降低了我们使用第三方库的成本，提高了生产效率，而 c++ 比较奇葩，并没有这样统一的依赖管理工具，大公司好一点，有专门的团队去做这样的工具解决依赖的问题，小公司就只能自己把源码拉下来，放到固定的目录，然后编译成二进制，运气不好的话，还要自己解决各种兼容性的问题，如果有版本更新，这个过程还得重复一遍，第三方库的使用和维护成本之高，让人简直就想放弃……

#### 1.1 前言

Golang 是自带依赖管理工具的，直接 `go get <packages>` 就可以把依赖拉下来，但是这种方式有个缺陷，没有版本控制，你每次拉下来的 `package` 都是 `master` 分支上的版本，这样是很危险的，源代码更新可能会有一些对外接口上面的调整，这些调整很有可能就导致你的程序编译通不过，而更致命的是，新的代码引入了一些新的 bug 或者接口语义上的变化会导致你的程序崩溃，所以早期的 gopher 开发了另一个依赖管理工具 [`godep`](https://github.com/tools/godep)解决了版本管理的问题，最近，golang 官方也在开发一个新的依赖管理工具 [`dep`](https://github.com/golang/dep) ;

Go项目依赖管理有两种：

1. `godep`是一个通过vender模式实现的Go语言的第三方依赖管理工具，类似的还有由社区维护准官方包管理工具`dep` 
2. `go module`是Go1.11版本之后官方推出的版本管理工具，并且从Go1.13版本开始，`go module`将是Go语言默认的依赖管理工具。 
   - ` go get XXX` 默认是指GOPATH的 src目录下

#### 1.2 vendor 模式

- **查找顺序** ：例如查找项目的某个依赖包，首先会在项目根目录下的`vender`文件夹中查找，如果没有找到就会去`$GOAPTH/src`目录下查找。
  - 当前包下的vendor目录
  - 先上级的目录查找，直到找到scr的vendor目录
  - 在GOPATH下面查找依赖包
  - 在GOROOT目录下查找

> 来源：

1. [go——依赖管理](https://www.jianshu.com/p/8f050e354c6f) 

#### 1.3 moudle 模式

```go
set GO111MODULE=on    //windows
export GO111MODULE=on //linux
```

> 来源

1. [使用 go mod 管理Go项目依赖](https://blog.csdn.net/qq_41893274/article/details/114870885) 

### 2. Go 操作MySQL

> 来源：https://www.liwenzhou.com/posts/Go/go_mysql/

MySQL是业界常用的关系型数据库，本文介绍了Go语言如何操作MySQL数据库。

#### 1.1 go 连接MySQL

Go语言中的`database/sql`包提供了保证SQL或类SQL数据库的泛用接口，并不提供具体的数据库驱动。使用`database/sql`包时必须注入（至少）一个数据库驱动。

我们常用的数据库基本上都有完整的第三方实现。例如：[MySQL驱动](https://github.com/go-sql-driver/mysql) 

**（1）下载 MySQL驱动** 

```bash
go get -u github.com/go-sql-driver/mysql 
```

使用上面 ` go get` 指令，会自动下载到GOPATH下面

**（2）使用MySQL 驱动** 

```go
func Open(driverName, dataSourceName string) (*DB, error)

参数说明：
  - dirverName 指定的数据库
  - dataSourceName 指定数据源
一般至少包括数据库文件名和其它连接必要的信息。
```

```go
import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
   // DSN:Data Source Name
	dsn := "user:password@tcp(127.0.0.1:3306)/dbname"
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		panic(err)
	}
	defer db.Close()  // 注意这行代码要写在上面err判断的下面
}
```

**思考题**： 为什么上面代码中的`defer db.Close()`语句不应该写在`if err != nil`的前面呢？

#### 1.2 初始化连接

Open函数可能只是验证其参数格式是否正确，实际上并不创建与数据库的连接。如果要检查数据源的名称是否真实有效，应该调用Ping方法。

返回的DB对象可以安全地被多个goroutine并发使用，并且维护其自己的空闲连接池。因此，Open函数应该仅被调用一次，很少需要关闭这个DB对象。

```go
// 定义一个全局对象db
var db *sql.DB

// 定义一个初始化数据库的函数
func initDB() (err error) {
	// DSN:Data Source Name
	dsn := "user:password@tcp(127.0.0.1:3306)/sql_test?charset=utf8mb4&parseTime=True"
	// 不会校验账号密码是否正确
	// 注意！！！这里不要使用:=，我们是给全局变量赋值，然后在main函数中使用全局变量db
	db, err = sql.Open("mysql", dsn)
	if err != nil {
		return err
	}
	// 尝试与数据库建立连接（校验dsn是否正确）
	err = db.Ping()
	if err != nil {
		return err
	}
	return nil
}

func main() {
	err := initDB() // 调用输出化数据库的函数
	if err != nil {
		fmt.Printf("init db failed,err:%v\n", err)
		return
	}
}
```

其中`sql.DB`是表示连接的数据库对象（结构体实例），它保存了连接数据库相关的所有信息。它内部维护着一个具有零到多个底层连接的连接池，它可以安全地被多个goroutine同时使用。

- **SetMaxOpenConns**：设置与数据库建立连接的最大数目。 如果n大于0且小于最大闲置连接数，会将最大闲置连接数减小到匹配最大开启连接数的限制。 如果n<=0，不会限制最大开启连接数，默认为0（无限制）。

  ```go
  func (db *DB) SetMaxOpenConns(n int)
  ```

- **SetMaxIdleConns** ：设置连接池中的最大闲置连接数。 如果n大于最大开启连接数，则新的最大闲置连接数会减小到匹配最大开启连接数的限制。 如果n<=0，不会保留闲置连接。

  ```go
  func (db *DB) SetMaxIdleConns(n int)
  ```

#### 1.3 CRUD 操作

**（1）建库建表** 

我们先在MySQL中创建一个名为`test`的数据库

```sql
-- 创建数据库
CREATE DATABASE test;

-- 进入test数据库
use test;
```

执行以下命令创建一张用于测试的数据表：

```sql
CREATE TABLE `user` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) DEFAULT '',
    `age` INT(11) DEFAULT '0',
    PRIMARY KEY(`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
```

**（2）查询** 

为了方便查询，我们事先定义好一个结构体来存储user表的数据。

```go
type user struct {
	id   int
	age  int
	name string
}
```

- **单行查询** 

单行查询`db.QueryRow()`执行一次查询，并期望返回最多一行结果（即Row）。QueryRow总是返回非nil的值，直到返回值的Scan方法被调用时，才会返回被延迟的错误。（如：未找到结果）

```go
// 查询单条数据示例
func queryRowDemo() {
	sqlStr := "select id, name, age from user where id=?"
	var c course
	// 非常重要：确保QueryRow之后调用Scan方法，否则持有的数据库链接不会被释放
	err := db.QueryRow(sqlStr, 1).Scan(&c.id, &c.name, &c.age)
	if err != nil {
		fmt.Printf("scan failed, err:%v\n", err)
		return
	}
	fmt.Printf("id:%d name:%s age:%d\n", c.id, c.name, c.age)
}
```

- **多行查询** 

多行查询`db.Query()`执行一次查询，返回多行结果（即Rows），一般用于执行select命令。参数args表示query中的占位参数。

```go
// 查询多条数据示例
func queryMultiRowDemo() {
	sqlStr := "select id, name, age from user where id > ?"
	// 非常重要：确保QueryRow之后调用Scan方法，否则持有的数据库链接不会被释放
	rows, err2 := db.Query(sqlStr, 0)
	if err2 != nil {
		fmt.Printf("scan failed, err:%v\n", err2)
		return
	}
	// 非常重要：关闭rows持有的数据库连接
	defer rows.Close()
	// 循环读取结果集中的数据
	for rows.Next(){
		var u user
		err2 := rows.Scan(&u.id, &u.name, &u.age)
		if err2 != nil {
			fmt.Printf("scan failed, err:%v \n", err2)
			return
		}
		fmt.Printf("Id: %d  name: %s  age: %d \n",u.id,u.name,u.age)
	}
}
```

**（3）插入数据** 

插入、更新和删除操作都使用`Exec`方法。

```go
func (db *DB) Exec(query string, args ...interface{}) (Result, error)
```

Exec执行一次命令（包括查询、删除、更新、插入等），返回的Result是对已执行的SQL命令的总结。参数args表示query中的占位参数。

具体插入数据示例代码如下：

```go
// 查询多条数据示例
func insertRowDemo() {
	sqlStr := "insert into user(name,age) values (?,?)"

	result, err := db.Exec(sqlStr, "阿里巴巴", 15)
	if err != nil {
		fmt.Printf("Insert failed, err：%v \n",err)
		return
	}
	// 新插入数据的ID
	insertId, err := result.LastInsertId()
	if err != nil {
		fmt.Printf("Get lastInsert ID failed,err:%v\n",err)
		return
	}
	fmt.Printf("insert success,the insertId is %d \n",insertId)
}
```

**（4）更新数据** 

具体更新数据示例代码如下：

```go
// 更新一条记录
func updateRowDemo() {
	strSql := "update user set age = ? where id = ?"
	result, err := db.Exec(strSql, 16,3)
	if err != nil {
		fmt.Printf("update failed,err ： %v\n",err)
		return
	}
	// 操作影响的行数
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		fmt.Printf("get rowsAffected failed, err: %v \n", err)
		return
	}
	fmt.Printf("update success, affected rows:%d\n", rowsAffected)
}
```

**（5）删除数据** 

具体删除数据的示例代码如下：

```go
// 删除数据
func deleteRowDemo() {
	sqlStr := "delete from user where id = ?"
	ret, err := db.Exec(sqlStr, 3)
	if err != nil {
		fmt.Printf("delete failed, err:%v\n", err)
		return
	}
	n, err := ret.RowsAffected() // 操作影响的行数
	if err != nil {
		fmt.Printf("get RowsAffected failed, err:%v\n", err)
		return
	}
	fmt.Printf("delete success, affected rows:%d\n", n)
}
```

#### 1.4 MySQL 预处理

> 普通SQL语句执行过程：

1. 客户端对SQL语句进行占位符替换得到完整的SQL语句。
2. 客户端发送完整SQL语句到MySQL服务端
3. MySQL服务端执行完整的SQL语句并将结果返回给客户端。

> 预处理执行过程

1. 把SQL语句分成两部分，命令部分与数据部分。
2. 先把命令部分发送给MySQL服务端，MySQL服务端进行SQL预处理。
3. 然后把数据部分发送给MySQL服务端，MySQL服务端对SQL语句进行占位符替换。
4. MySQL服务端执行完整的SQL语句并将结果返回给客户端。

**（1）为什么要预处理** 

1. 优化MySQL服务器重复执行SQL的方法，可以提升服务器性能，提前让服务器编译，一次编译多次执行，节省后续编译的成本。
2. 避免SQL注入问题。

**（2）Go 实现MySQL预处理** 

`database/sql`中使用下面的`Prepare`方法来实现预处理操作。

```go
func (db *DB) Prepare(query string) (*Stmt, error)
```

`Prepare`方法会先将sql语句发送给MySQL服务端，返回一个准备好的状态用于之后的查询和命令。返回值可以同时执行多个查询和命令。

查询操作的预处理示例代码如下：

```go
// 预处理查询示例
func prepareQueryDemo() {
	sqlStr := "select id, name, age from user where id > ?"
	stmt, err := db.Prepare(sqlStr)
	if err != nil {
		fmt.Printf("prepare failed, err:%v\n", err)
		return
	}
	defer stmt.Close()
	rows, err := stmt.Query(0)
	if err != nil {
		fmt.Printf("query failed, err:%v\n", err)
		return
	}
	defer rows.Close()
	// 循环读取结果集中的数据
	for rows.Next() {
		var u user
		err := rows.Scan(&u.id, &u.name, &u.age)
		if err != nil {
			fmt.Printf("scan failed, err:%v\n", err)
			return
		}
		fmt.Printf("id:%d name:%s age:%d\n", u.id, u.name, u.age)
	}
}
```

插入、更新和删除操作的预处理十分类似，这里以插入操作的预处理为例：

```go
// 预处理插入示例
func prepareInsertDemo() {
	sqlStr := "insert into user(name, age) values (?,?)"
	stmt, err := db.Prepare(sqlStr)
	if err != nil {
		fmt.Printf("prepare failed, err:%v\n", err)
		return
	}
	defer stmt.Close()
	_, err = stmt.Exec("小王子", 18)
	if err != nil {
		fmt.Printf("insert failed, err:%v\n", err)
		return
	}
	_, err = stmt.Exec("沙河娜扎", 18)
	if err != nil {
		fmt.Printf("insert failed, err:%v\n", err)
		return
	}
	fmt.Println("insert success.")
}
```

**（3）SQL 注入问题** 

**我们任何时候都不应该自己拼接SQL语句！** 

这里我们演示一个自行拼接SQL语句的示例，编写一个根据name字段查询user表的函数如下：

```sql
// sql注入示例
func sqlInjectDemo(name string) {
	sqlStr := fmt.Sprintf("select id, name, age from user where name='%s'", name)
	fmt.Printf("SQL:%s\n", sqlStr)
	var u user
	err := db.QueryRow(sqlStr).Scan(&u.id, &u.name, &u.age)
	if err != nil {
		fmt.Printf("exec failed, err:%v\n", err)
		return
	}
	fmt.Printf("user:%#v\n", u)
}
```

此时以下输入字符串都可以引发SQL注入问题：

```sql
sqlInjectDemo("xxx' or 1=1#")
sqlInjectDemo("xxx' union select * from user #")
sqlInjectDemo("xxx' and (select count(*) from user) <10 #")
```

**补充：**不同的数据库中，SQL语句使用的占位符语法不尽相同。

|   数据库   |  占位符语法  |
| :--------: | :----------: |
|   MySQL    |     `?`      |
| PostgreSQL | `$1`, `$2`等 |
|   SQLite   |  `?` 和`$1`  |
|   Oracle   |   `:name`    |

#### 1.5 Go 实现MySQL事务

**（1）事务的ACID** 

通常事务必须满足4个条件（ACID）：原子性（Atomicity，或称不可分割性）、一致性（Consistency）、隔离性（Isolation，又称独立性）、持久性（Durability）。

|  条件  |                             解释                             |
| :----: | :----------------------------------------------------------: |
| 原子性 | 一个事务（transaction）中的所有操作，要么全部完成，要么全部不完成，不会结束在中间某个环节。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。 |
| 一致性 | 在事务开始之前和事务结束以后，数据库的完整性没有被破坏。这表示写入的资料必须完全符合所有的预设规则，这包含资料的精确度、串联性以及后续数据库可以自发性地完成预定的工作。 |
| 隔离性 | 数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时由于交叉执行而导致数据的不一致。事务隔离分为不同级别，包括读未提交（Read uncommitted）、读提交（read committed）、可重复读（repeatable read）和串行化（Serializable）。 |
| 持久性 | 事务处理结束后，对数据的修改就是永久的，即便系统故障也不会丢失。 |

**（2）事务相关的方法** 

Go语言中使用以下三个方法实现MySQL中的事务操作。 

```go
-- 开始事务
func (db *DB) Begin() (*Tx, error)

-- 提交事务
func (tx *Tx) Commit() error

-- 回滚事务
func (tx *Tx) Rollback() error
```

**（3）事务示例** 

下面的代码演示了一个简单的事务操作，该事物操作能够确保两次更新操作要么同时成功要么同时失败，不会存在中间状态。

```go
// 事务操作示例
func transactionDemo() {
	tx, err := db.Begin() // 开启事务
	if err != nil {
		if tx != nil {
			tx.Rollback() // 回滚
		}
		fmt.Printf("begin trans failed, err:%v\n", err)
		return
	}
	sqlStr1 := "Update user set age=30 where id=?"
	ret1, err := tx.Exec(sqlStr1, 2)
	if err != nil {
		tx.Rollback() // 回滚
		fmt.Printf("exec sql1 failed, err:%v\n", err)
		return
	}
	affRow1, err := ret1.RowsAffected()
	if err != nil {
		tx.Rollback() // 回滚
		fmt.Printf("exec ret1.RowsAffected() failed, err:%v\n", err)
		return
	}

	sqlStr2 := "Update user set age=40 where id=?"
	ret2, err := tx.Exec(sqlStr2, 3)
	if err != nil {
		tx.Rollback() // 回滚
		fmt.Printf("exec sql2 failed, err:%v\n", err)
		return
	}
	affRow2, err := ret2.RowsAffected()
	if err != nil {
		tx.Rollback() // 回滚
		fmt.Printf("exec ret1.RowsAffected() failed, err:%v\n", err)
		return
	}

	fmt.Println(affRow1, affRow2)
	if affRow1 == 1 && affRow2 == 1 {
		fmt.Println("事务提交啦...")
		tx.Commit() // 提交事务
	} else {
		tx.Rollback()
		fmt.Println("事务回滚啦...")
	}

	fmt.Println("exec trans success!")
}
```

### 3. Go 操作 Redis

> 来源：https://www.liwenzhou.com/posts/Go/go_redis/







































