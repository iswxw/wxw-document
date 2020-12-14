## Java基础知识

### 夯实基础

#### Java 基本数据类型

- 在线文档：https://www.runoob.com/java/java-basic-datatypes.html

Java语言提供了八种基本类型。六种数字类型（四个整数型，两个浮点型），一种字符类型，还有一种布尔型。



#### Java String类

- 在线文档：https://www.runoob.com/java/java-string.html

String 创建的字符串存储在公共池（常量池）中，而 new 创建的字符串对象在堆上：

```java
String s1 = "Runoob";              // String 直接创建
String s2 = "Runoob";              // String 直接创建
String s3 = s1;                    // 相同引用
String s4 = new String("Runoob");   // String 对象创建
String s5 = new String("Runoob");   // String 对象创建
```

![img](assets/java-string-1-2020-12-01.png) 

**常用方法** 

- **compareTo()**  方法用于两种方式的比较，字符串与对象进行比较和按字典顺序比较两个字符串
  - 如果参数字符串等于此字符串，则返回值 0；
  - 如果此字符串小于字符串参数，则返回一个小于 0 的值；
  - 如果此字符串大于字符串参数，则返回一个大于 0 的值。



   

#### Java Final 类

- [final 关键字](https://www.cnblogs.com/dolphin0520/p/3736238.html) 

#### Java Static 类

- [static 关键字](https://www.cnblogs.com/dolphin0520/p/10651845.html) 

### 深拷贝和浅拷贝

- **浅拷贝**只复制指向某个对象的指针，而不复制对象本身，新旧对象还是共享同一块内存。
- **深拷贝**会另外创造一个一模一样的对象，新对象跟原对象不共享内存，修改新对象不会改到原对象。

![å¾çæè¿°](assets/3483357010-5cb447fba09cc_articlex.jpg)  

相关文章

1. [浅拷贝和深拷贝](https://blog.csdn.net/riemann_/article/details/87217229) 

## Java 泛型

## Java 反射

## Java 序列化

Java 提供了一种对象序列化的机制，该机制中，一个对象可以被表示为一个字节序列，该字节序列包括该对象的数据、有关对象的类型的信息和存储在对象中数据的类型。

将序列化对象写入文件之后，可以从文件中读取出来，并且对它进行反序列化，也就是说，对象的类型信息、对象的数据，还有对象中的数据类型可以用来在内存中新建对象。

整个过程都是 Java 虚拟机（JVM）独立的，也就是说，在一个平台上序列化的对象可以在另一个完全不同的平台上反序列化该对象。

类 ObjectInputStream 和 ObjectOutputStream 是高层次的数据流，它们包含反序列化和序列化对象的方法。

ObjectOutputStream 类包含很多写方法来写各种数据类型，但是一个特别的方法例外：

```java
public final void writeObject(Object x) throws IOException  // 序列化
```

方法序列化一个对象，并将它发送到输出流。相似的 ObjectInputStream 类包含如下反序列化一个对象的方法：

```java
public final Object readObject() throws IOException, ClassNotFoundException  // 反序列化
```

该方法从流中取出下一个对象，并将对象反序列化。它的返回值为Object，因此，你需要将它转换成合适的数据类型。

为了演示序列化在Java中是怎样工作的，我将使用之前教程中提到的Employee类，假设我们定义了如下的Employee类，该类实现了Serializable 接口。

```java
public class Employee implements java.io.Serializable{
   public String name;
   public String address;
   public transient int SSN;
   public int number;
   public void mailCheck(){
      System.out.println("Mailing a check to " + nam + " " + address);
   }
}
```

一个类的对象要想序列化成功，必须满足两个条件

1. 该类必须实现 java.io.Serializable 接口。
2. 该类的所有属性必须是可序列化的。如果有一个属性不是可序列化的，则该属性必须注明是短暂的。

如果你想知道一个 Java 标准类是否是可序列化的，请查看该类的文档。检验一个类的实例是否能序列化十分简单， 只需要查看该类有没有实现 java.io.Serializable接口。

### 1.1 序列化

ObjectOutputStream 类用来序列化一个对象，如下的 SerializeDemo 例子实例化了一个 Employee 对象，并将该对象序列化到一个文件中。

该程序执行后，就创建了一个名为 employee.ser 文件。该程序没有任何输出，但是你可以通过代码研读来理解程序的作用。**注意：** 当序列化一个对象到文件时， 按照 Java 的标准约定是给文件一个 .ser 扩展名。

```java
    // 序列化
    public static void seriableObject(Apple apple) {
        try {
            File file = new File(path);
            FileOutputStream fileOut = new FileOutputStream(file);
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(apple);
            out.close();
            fileOut.close();
            System.out.printf("Serialized data is saved in /tmp/employee.ser");
        } catch (IOException i) {
            i.printStackTrace();
        }
    }
```

### 1.2 反序列化

DeserializeDemo 程序实例了反序列化，/tmp/employee.ser 存储了 Employee 对象。

```java
 // 反序列化
    public static Apple unSeriableObject() {
        Apple newApple = null;
        try {
            FileInputStream fileIn = new FileInputStream(path);
            ObjectInputStream in = new ObjectInputStream(fileIn);
            newApple = (Apple) in.readObject();
            in.close();
            fileIn.close();
        } catch (IOException i) {
            i.printStackTrace();
        } catch (ClassNotFoundException c) {
            System.out.println("Apple class not found");
            c.printStackTrace();
        }
        return newApple;
    }
```

> 注意以下要点：

- readObject() 方法中的 try/catch代码块尝试捕获 ClassNotFoundException 异常。对于 JVM 可以反序列化对象，它必须是能够找到字节码的类。如果JVM在反序列化对象的过程中找不到该类，则抛出一个 ClassNotFoundException 异常。

注意，readObject() 方法的返回值被转化成 Employee 引用。

- 当对象被序列化时，属性 SSN 的值为 111222333，但是因为该属性是短暂的，该值没有被发送到输出流。所以反序列化后 Employee 对象的 SSN 属性为 0。

## Java8 新特性

- 示例代码：[快速定位](https://github.com/GitHubWxw/java-general/tree/master/java-jdkx/src/test/java/com/wxw/jdk8) 

> 终于有人说明白了这些新特性

-   **Consumer<T>** – 在T上执行一个操作，无返回结果
-   **Supplier<T>** –无输入参数，返回T的实例
-   **Predicate<T>** –输入参数为T的实例，返回boolean值
-   **Function<T,R>** –输入参数为T的实例，返回R的实例

| 序号 | 特性                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | [Lambda 表达式](https://www.runoob.com/java/java8-lambda-expressions.html) |
| 2    | [方法引用](https://www.runoob.com/java/java8-method-references.html) |
| 3    | [函数式接口](https://www.runoob.com/java/java8-functional-interfaces.html) |
| 4    | [默认方法](https://www.runoob.com/java/java8-default-methods.html) |
| 5    | [Stream](https://www.runoob.com/java/java8-streams.html)     |
| 6    | [Optional 类](https://www.runoob.com/java/java8-optional-class.html) |
| 7    | [新的日期时间 API](https://www.runoob.com/java/java8-datetime-api.html) |
| 8    | [Base64](https://www.runoob.com/java/java8-base64.html)      |

### 1.1 Lambda表达式

个人认为：**超过3行的逻辑就不适用Lambda表达式了**，虽然看着很先进，其实Lambda表达式的本质只是一个"[**语法糖**](http://zh.wikipedia.org/wiki/%E8%AF%AD%E6%B3%95%E7%B3%96)",由编译器推断并帮你转换包装为常规的代码,因此你可以使用更少的代码来实现同样的功能。本人建议不要乱用,因为这就和某些很高级的黑客写的代码一样,简洁,难懂,难以调试,维护人员想骂娘.

Lambda表达式还改进了Collection库。Java SE 8添加了两个与Collection的批量数据操作相关的软件包，即java.util.function软件包和java.util.stream。流就像迭代器一样，但是具有很多额外的功能。总之，lambda表达式和流是Java编程的最大变化，因为泛型和注释已添加到该语言中。在本文中，我们将从简单示例到复杂示例，探索lambda表达式和流的功能。

```java
// 1. 不需要参数,返回值为 5
() -> 5
 
// 2. 接收一个参数(数字类型),返回其2倍的值
x -> 2 * x
 
// 3. 接受2个参数(数字),并返回他们的差值
(x, y) -> x – y
 
// 4. 接收2个int型整数,返回他们的和
(int x, int y) -> x + y
 
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)
(String s) -> System.out.print(s)
```

实用案例：

```java
@Test
    public void testDate1() {
        List<String> names01 = Arrays.asList("Google", "JD", "BaiDu", "Tencent", "AliBaBa", "TaoBao");
        List<String> names02 = Arrays.asList("谷歌", "京东", "百度", "腾讯", "阿里", "淘宝");

        LambdaTest01 tester = new LambdaTest01();
        // 类型声明
        MathOperation addition1 = (int a, int b) -> a + b;
        // 在 Java 8 中使用双冒号操作符(double colon operator)
        MathOperation addition2 = Integer::sum;

        // 不用类型声明
        MathOperation subtraction = (a, b) -> a - b;

        // 大括号中的返回语句
        MathOperation multiplication = (int a, int b) -> {
            return a * b;
        };

        // 没有大括号及返回语句
        MathOperation division = (int a, int b) -> a / b;

        System.out.println("10 + 5 = " + tester.operate(10, 5, addition1));
        System.out.println("10 - 5 = " + tester.operate(10, 5, subtraction));
        System.out.println("10 x 5 = " + tester.operate(10, 5, multiplication));
        System.out.println("10 / 5 = " + tester.operate(10, 5, division));
        
        // 不用括号
        GreetingService greetService1 = message ->
                System.out.println("Hello " + message);

        // 用括号
        GreetingService greetService2 = (message) ->
                System.out.println("Hello " + message);

        greetService1.sayMessage("Runoob");
        greetService2.sayMessage("Google");

    }
    
    interface MathOperation {
        int operation(int a, int b);
    }

    private int operate(int a, int b, MathOperation mathOperation) {
        return mathOperation.operation(a, b);
    }

    interface GreetingService {
        void sayMessage(String message);
    }
    
    /**
     * 排序
     */
    @Test
    public void testData2() {
        // 准备一个集合
        List<Integer> list = Arrays.asList(10, 5, 25, -15, 20);
        list.sort((a, b) -> {
            return a - b;
        });
        System.out.println("list = " + list);
    }
```

### 1.2 函数式接口

函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。

函数式接口可以被隐式转换为 lambda 表达式。

Lambda 表达式和方法引用（实际上也可认为是Lambda表达式）上

> 定义了一个函数式接口如下：

```java
@FunctionalInterface
interface GreetingService {
    void sayMessage(String message);
}
```

那么就可以使用Lambda表达式来表示该接口的一个实现(注：JAVA 8 之前一般是用匿名类实现的)：

```java
GreetingService greetService1 = message -> System.out.println("Hello " + message);
```

函数式接口可以对现有的函数友好地支持 lambda。

> 函数式接口实例

Predicate <T> 接口是一个函数式接口，它接受一个输入参数 T，返回一个布尔值结果。

该接口包含多种默认方法来将Predicate组合成其他复杂的逻辑（比如：与，或，非）。

该接口用于测试对象是 true 或 false。

我们可以通过以下实例来了解函数式接口 Predicate <T> 的使用：

```java
 @Test
    public void  FuctionInterface(){
        List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9);

        // Predicate<Integer> predicate = n -> true
        // n 是一个参数传递到 Predicate 接口的 test 方法
        // n 如果存在则 test 方法返回 true

        // 传递参数 n
        eval(list, n->true);

        // Predicate<Integer> predicate1 = n -> n%2 == 0
        // n 是一个参数传递到 Predicate 接口的 test 方法
        // 如果 n%2 为 0 test 方法返回 true

        System.out.println("输出所有偶数:");
        eval(list, n-> n%2 == 0 );

        // Predicate<Integer> predicate2 = n -> n > 3
        // n 是一个参数传递到 Predicate 接口的 test 方法
        // 如果 n 大于 3 test 方法返回 true

        System.out.println("输出大于 3 的所有数字:");
        eval(list, n-> n > 3 );

    }
    public static void eval(List<Integer> list, Predicate<Integer> predicate) {
        for(Integer n: list) {
            if(predicate.test(n)) {
                System.out.println(n + " ");
            }
        }
    }
```

### 1.3 方法引用（::）

> 方法引用通过方法的名字来指向一个方法。

1. 方法引用可以使语言的构造更紧凑简洁，减少冗余代码。
2. 方法引用使用一对冒号 :: 。

下面，我们在 Car 类中定义了 4 个方法作为例子来区分 Java 中 4 种不同方法的引用。

```java
@FunctionalInterface // 函数式接口
public interface Supplier<T> {
    T get();
}
 
class Car {
    //Supplier是jdk1.8的接口，这里和lamda一起使用了
    public static Car create(final Supplier<Car> supplier) {
        return supplier.get();
    }
 
    public static void collide(final Car car) {
        System.out.println("Collided " + car.toString());
    }
 
    public void follow(final Car another) {
        System.out.println("Following the " + another.toString());
    }
 
    public void repair() {
        System.out.println("Repaired " + this.toString());
    }
}
```

- **构造器引用** ：它的语法是Class::new，或者更一般的Class< T >::new实例如下：

```java
final Car car = Car.create( Car::new );
final List< Car > cars = Arrays.asList( car );
```

- **静态方法引用：**它的语法是Class::static_method，实例如下：

```java
cars.forEach( Car::collide );
```

- **特定类的任意对象的方法引用：**它的语法是Class::method实例如下：

```java
cars.forEach( Car::repair );
```

- **特定对象的方法引用：**它的语法是instance::method实例如下：

```java
final Car police = Car.create( Car::new );
cars.forEach( police::follow );
```

方法引用实例：

```java
    @Test
    public void test1(){
        List<Car> names = new ArrayList();
        // System.out::println 方法作为静态方法来引用
        names.forEach(System.out::println);
        // 构造器引用
        final Car car = Car.create(Car::new);
        names.add(car);
        // 特定类的任意对象的方法引用
        names.forEach(Car::repair);
        // 特定对象的方法引用
        final Car police = Car.create( Car::new );
        names.forEach( police::follow );

    }
```

### 1.4 接口默认方法

Java 8 新增了接口的默认方法。

简单说，默认方法就是接口可以有实现方法，而且不需要实现类去实现其方法。

我们只需在方法名前面加个 default 关键字即可实现默认方法。

> **为什么要有这个特性？**

之前的接口是个双刃剑，好处是面向抽象而不是面向具体编程，缺陷是，当需要修改接口时候，需要修改全部实现该接口的类，目前的 java 8 之前的集合框架没有 foreach 方法，通常能想到的解决办法是在JDK里给相关的接口添加新的方法及实现。然而，对于已经发布的版本，是没法在给接口添加新方法的同时不影响已有的实现。所以引进的默认方法。他们的**目的是为了解决接口的修改与现有的实现不兼容的问题**。

**语法格式** 

```java
public interface Vehicle {
   default void print(){
      System.out.println("我是一辆车!");
   }
}
```

**多个默认方法** 

一个接口有默认方法，考虑这样的情况，一个类实现了多个接口，且这些接口有相同的默认方法，以下实例说明了这种情况的解决方法：

```java
public interface Vehicle {
   default void print(){
      System.out.println("我是一辆车!");
   }
}
 
public interface FourWheeler {
   default void print(){
      System.out.println("我是一辆四轮车!");
   }
}
```

**解决办法** 

1. 创建自己的默认方法，来覆盖重写接口的默认方法：

   ```java
   public class Car implements Vehicle, FourWheeler {
      default void print(){
         System.out.println("我是一辆四轮汽车!");
      }
   }
   ```

2. 使用 super 来调用指定接口的默认方法：

   ```java
   public class Car implements Vehicle, FourWheeler {
      public void print(){
         Vehicle.super.print();
      }
   }
   ```

**静态默认方法** 

Java 8 的另一个特性是接口可以声明（并且可以提供实现）静态方法。例如：

```java
public interface Vehicle {
   default void print(){
      System.out.println("我是一辆车!");
   }
    // 静态方法
   static void blowHorn(){
      System.out.println("按喇叭!!!");
   }
}
```

示例代码：

我们可以通过以下代码来了解关于默认方法的使用

```java
 @Test
    public void test(){
        Vehicle vehicle = new Car();
        vehicle.print();
    }

    interface Vehicle {
        // 默认方法
        default void print(){
            System.out.println("我是一辆车!");
        }
        // 静态方法
        static void blowHorn(){
            System.out.println("按喇叭!!!");
        }
    }

    interface FourWheeler {
        default void print(){
            System.out.println("我是一辆四轮车!");
        }
    }
    class Car implements Vehicle, FourWheeler {
        public void print(){
            Vehicle.super.print();
            FourWheeler.super.print();
            Vehicle.blowHorn();
            System.out.println("我是一辆汽车!");
        }
    }
```

### 1.5 Stream 流

Java 8 API添加了一个新的抽象称为流Stream，可以让你以一种声明的方式处理数据。

Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。

```java
+--------------------+       +------+   +------+   +---+   +-------+
| stream of elements +-----> |filter+-> |sorted+-> |map+-> |collect|
+--------------------+       +------+   +------+   +---+   +-------+
```

以上的流程转换为 Java 代码为：

```java
List<Integer> transactionsIds = 
widgets.stream()
             .filter(b -> b.getColor() == RED)
             .sorted((x,y) -> x.getWeight() - y.getWeight())
             .mapToInt(Widget::getWeight)
             .sum();
```

**Stream（流）**是一个来自数据源的元素队列并支持聚合操作

- 元素是特定类型的对象，形成一个队列。 Java中的Stream并不会存储元素，而是按需计算。
- **数据源** 流的来源。 可以是集合，数组，I/O channel， 产生器generator 等。
- **聚合操作** 类似SQL语句一样的操作， 比如filter, map, reduce, find, match, sorted等。

和以前的Collection操作不同， Stream操作还有两个基础的特征：

- **Pipelining**: 中间操作都会返回流对象本身。 这样多个操作可以串联成一个管道， 如同流式风格（fluent style）。 这样做可以对操作进行优化， 比如延迟执行(laziness)和短路( short-circuiting)。
- **内部迭代**： 以前对集合遍历都是通过Iterator或者For-Each的方式, 显式的在集合外部进行迭代， 这叫做外部迭代。 Stream提供了内部迭代的方式， 通过访问者模式(Visitor)实现。

**生成流** ：

在 Java 8 中, 集合接口有两个方法来生成流：

- **stream()** − 为集合创建串行流。
- **parallelStream()** − 为集合创建并行流。

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

#### （1）forEach

Stream 提供了新的方法 'forEach' 来迭代流中的每个数据。以下代码片段使用 forEach 输出了10个随机数：

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

#### （2）map

map 方法用于映射每个元素到对应的结果，以下代码片段使用 map 输出了元素对应的平方数：

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取对应的平方数
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
```

#### （3）filter

filter 方法用于通过设置的条件过滤出元素。以下代码片段使用 filter 方法过滤出空字符串：

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
long count = strings.stream().filter(string -> string.isEmpty()).count();
```

#### （4）limit

limit 方法用于获取指定数量的流。 以下代码片段使用 limit 方法打印出 10 条数据：

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

#### （5）sorted

sorted 方法用于对流进行排序。以下代码片段使用 sorted 方法对输出的 10 个随机数进行排序：

```java
Random random = new Random();
random.ints().limit(10).sorted().forEach(System.out::println);
```

#### （6）并行程序（parallel）

parallelStream 是流并行处理程序的代替方法。以下实例我们使用 parallelStream 来输出空字符串的数量：

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
long count = strings.parallelStream().filter(string -> string.isEmpty()).count();
```

我们可以很容易的在顺序运行和并行直接切换。

#### （7）Collectors

Collectors 类实现了很多归约操作，例如将流转换成集合和聚合元素。Collectors 可用于返回列表或字符串：

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
 
System.out.println("筛选列表: " + filtered);
String mergedString = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.joining(", "));
System.out.println("合并字符串: " + mergedString);
```

#### （8）统计

另外，一些产生统计结果的收集器也非常有用。它们主要用于int、double、long等基本类型上，它们可以用来产生类似如下的统计结果。

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
 
IntSummaryStatistics stats = numbers.stream().mapToInt((x) -> x).summaryStatistics();
 
System.out.println("列表中最大的数 : " + stats.getMax());
System.out.println("列表中最小的数 : " + stats.getMin());
System.out.println("所有数之和 : " + stats.getSum());
System.out.println("平均数 : " + stats.getAverage());
```

示例代码：

```java
  /**
     *  Java8的流主要有两种：
     *     1. stream() − 为集合创建串行流。
     *     2. parallelStream() − 为集合创建并行流。
     */
    @Test
    public void testData1(){

        // 'forEach' 来迭代流中的每个数据
        Random random = new Random();
        random.ints().limit(2).forEach(n-> System.out.println(n));
        random.ints().limit(2).forEach(System.out::println);  // 对象::方法

        // map 方法用于映射每个元素到对应的结果
        List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
        // 获取对应的平方数
        List<Integer> integers = numbers.stream().map(n -> {
            return n * n;
        }).distinct().collect(Collectors.toList());

        //filter 方法用于通过设置的条件过滤出元素
        List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
        // 获取空字符串的数量
        long count = strings.stream().filter(s -> s.isEmpty()).count();

        // limit 获取指定数量的流
        Random random01 = new Random();
        random01.ints().limit(2).forEach(System.out::print);

        // sorted 用于对流进行排序
        Random random02 = new Random();
        random02.ints().limit(2).sorted().forEach(System.out::print);

        // 并行程序 parallel是流并行处理程序的代替方法
        List<String> strList01 = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
        // 获取空字符串的数量
        long count_01 = strList01.parallelStream().filter(string -> string.isEmpty()).count();

        // Collectors 实现了很多归约操作，例如将流转换为集合和聚合元素
        List<String> list_01 = Arrays.asList("百度", "京东", "美团", "阿里", "淘宝", "腾讯","");
        List<String> collect_01 = list_01.stream().filter(s -> !s.isEmpty()).collect(Collectors.toList());
        System.out.println();
        System.out.println("collect_01 筛选列表 = " + collect_01);
        /* 合并为字符串 */
        String String_01 = list_01.stream().filter(s -> !s.isEmpty()).collect(Collectors.joining(","));
        System.out.println("String_01 List拆分为一个一“，”分割的字符串 = " + String_01);
    }

    @Test
    public void testData2(){
        //  产生及统计结果的统计器
        List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);

        IntSummaryStatistics stats = numbers.stream().mapToInt((x) -> x).summaryStatistics();

        System.out.println("列表中最大的数 : " + stats.getMax());
        System.out.println("列表中最小的数 : " + stats.getMin());
        System.out.println("所有数之和 : " + stats.getSum());
        System.out.println("平均数 : " + stats.getAverage());
    }
```

### 1.6 Optional 类

Optional 类是一个可以为null的容器对象。如果值存在则isPresent()方法会返回true，调用get()方法会返回该对象。

Optional 是个容器：它可以保存类型T的值，或者仅仅保存null。Optional提供很多有用的方法，这样我们就不用显式进行空值检测。

**Optional 类的引入很好的解决空指针异常。**

**类声明** 

以下是一个 **java.util.Optional<T>** 类的声明：

```java
public final class Optional<T> extends Object
```

我们可以通过以下实例来更好的了解 Optional 类的使用：

```java
 @Test
    public void test(){
        final OptionalTest optionalTest = new OptionalTest();
        Integer value1 = null;
        Integer value2 = new Integer(10);
        // Optional.ofNullable - 允许传递为 null 参数
        Optional<Integer> a = Optional.ofNullable(value1);

        // Optional.of - 如果传递的参数是 null，抛出异常 NullPointerException
        Optional<Integer> b = Optional.of(value2);
        System.out.println(optionalTest.sum(a,b));

    }

    public Integer sum(Optional<Integer> a, Optional<Integer> b){
        // Optional.isPresent - 判断值是否存在
        System.out.println("第一个参数值存在: " + a.isPresent());
        System.out.println("第二个参数值存在: " + b.isPresent());

        // Optional.orElse - 如果值存在，返回它，否则返回默认值 0
        Integer value1 = a.orElse(new Integer(0));

        //Optional.get - 获取值，值需要存在
        Integer value2 = b.get();
        return value1 + value2;
    }
```

### 1.7 Java8 日期API

Java 8通过发布新的Date-Time API (JSR 310)来进一步加强对日期与时间的处理。

在旧版的 Java 中，日期时间 API 存在诸多问题，其中有：

- **非线程安全** − java.util.Date 是非线程安全的，所有的日期类都是可变的，这是Java日期类最大的问题之一。
- **设计很差** − Java的日期/时间类的定义并不一致，在java.util和java.sql的包中都有日期类，此外用于格式化和解析的类在java.text包中定义。java.util.Date同时包含日期和时间，而java.sql.Date仅包含日期，将其纳入java.sql包并不合理。另外这两个类都有相同的名字，这本身就是一个非常糟糕的设计。
- **时区处理麻烦** − 日期类并不提供国际化，没有时区支持，因此Java引入了java.util.Calendar和java.util.TimeZone类，但他们同样存在上述所有的问题。

Java 8 在 **java.time** 包下提供了很多新的 API。以下为两个比较重要的 API：

- **Local(本地)** − 简化了日期时间的处理，没有时区的问题。
- **Zoned(时区)** − 通过制定的时区处理日期时间。

新的java.time包涵盖了所有处理日期，时间，日期/时间，时区，时刻（instants），过程（during）与时钟（clock）的操作。

```java
 @Test
    public void test(){
        // 获取当前的日期时间
        LocalDateTime currentTime = LocalDateTime.now();
        System.out.println("当前时间: " + currentTime);

        LocalDate date1 = currentTime.toLocalDate();
        System.out.println("日期: " + date1);

        Month month = currentTime.getMonth();
        int day = currentTime.getDayOfMonth();
        int seconds = currentTime.getSecond();
        System.out.println("月: " + month +", 日: " + day +", 秒: " + seconds);

        LocalDateTime date2 = currentTime.withDayOfMonth(10).withYear(2012);
        System.out.println("date2: " + date2);

        // 12 december 2014
        LocalDate date3 = LocalDate.of(2014, Month.DECEMBER, 12);
        System.out.println("date3: " + date3);

        // 22 小时 15 分钟
        LocalTime date4 = LocalTime.of(22, 15);
        System.out.println("date4: " + date4);

        // 解析字符串
        LocalTime date5 = LocalTime.parse("20:15:30");
        System.out.println("date5: " + date5);
    }
```

### 1.8 Base64

在Java 8中，Base64编码已经成为Java类库的标准。

Java 8 内置了 Base64 编码的编码器和解码器。

Base64工具类提供了一套静态方法获取下面三种BASE64编解码器：

- **基本：**输出被映射到一组字符A-Za-z0-9+/，编码不添加任何行标，输出的解码仅支持A-Za-z0-9+/。
- **URL：**输出映射到一组字符A-Za-z0-9+_，输出是URL和文件。
- **MIME：**输出隐射到MIME友好格式。输出每行不超过76字符，并且使用'\r'并跟随'\n'作为分割。编码输出最后没有行分割。

```java
 try {
         // 使用基本编码
         String base64encodedString = Base64.getEncoder().encodeToString("runoob?java8".getBytes("utf-8"));
         System.out.println("Base64 编码字符串 (基本) :" + base64encodedString);
        
         // 解码
         byte[] base64decodedBytes = Base64.getDecoder().decode(base64encodedString);
        
         System.out.println("原始字符串: " + new String(base64decodedBytes, "utf-8"));
         base64encodedString = Base64.getUrlEncoder().encodeToString("runoob?java8".getBytes("utf-8"));
         System.out.println("Base64 编码字符串 (URL) :" + base64encodedString);
        
         StringBuilder stringBuilder = new StringBuilder();
        
         for (int i = 0; i < 10; ++i) {
            stringBuilder.append(UUID.randomUUID().toString());
         }
        
         byte[] mimeBytes = stringBuilder.toString().getBytes("utf-8");
         String mimeEncodedString = Base64.getMimeEncoder().encodeToString(mimeBytes);
         System.out.println("Base64 编码字符串 (MIME) :" + mimeEncodedString);
         
      }catch(UnsupportedEncodingException e){
         System.out.println("Error :" + e.getMessage());
      }
```



> 相关文章

1. [www.developer.com](https://www.developer.com/java/start-using-java-lambda-expressions.html) 

常见问题

1. 线程和进程的区别？
2. HTTP和TCP的却别？
3. time wait的状态是什么？


