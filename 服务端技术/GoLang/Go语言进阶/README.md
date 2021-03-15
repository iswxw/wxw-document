### GoLang 进阶

> 来源bilibili

1. 七米老师的学习视频：[点我传送](https://www.bilibili.com/video/BV17Q4y1P7n9)
2. 李文周老师的博客：[点我传送](https://www.liwenzhou.com/) 

### 1. Go 操作MySQL

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





