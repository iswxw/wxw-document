### 设计模式



### 常见问题

(1) 策略模式、工厂模式和责任链模式的区别

> 策略模式与工厂模式

- 工厂方法处理问题比较单一，工厂模式在main函数中可以拼装
- 策略模式处理方法比较全面，策略模式在main函数中不可以拼装
- 工厂模式算法都是暴露给程序员的，策略模式比较隐秘

> 责任链模式

- 可扩展性好、增加新的请求处理类很方便。



### 设计原则

#### 1. 单一职责原则

单一职责原则规定一个类应该有且仅有一个引起它变化的原因，否则类应该被拆分；

##### 1.1 缺点

该原则提出对象不应该承担太多职责，如果一个对象承担了太多的职责，至少存在以下**两个缺点**：

1. 一个职责的变化可能会削弱或者抑制这个类实现其他职责的能力；
2. 当客户端需要该对象的某一个职责时，不得不将其他不需要的职责全都包含进来，从而造成冗余代码或代码的浪费。

##### 1.2 优点

单一职责原则的核心就是控制类的粒度大小、将对象解耦、提高其内聚性。如果遵循单一职责原则将有以下优点。

- 降低类的复杂度。一个类只负责一项职责，其逻辑肯定要比负责多项职责简单得多。
- 提高类的可读性。复杂性降低，自然其可读性会提高。
- 提高系统的可维护性。可读性提高，那自然更容易维护了。
- 变更引起的风险降低。变更是必然的，如果单一职责原则遵守得好，当修改一个功能时，可以显著降低对其他功能的影响。

##### 1.4 实现

单一职责原则是最简单但又最难运用的原则，需要设计人员发现类的不同职责并将其分离，再封装到不同的类或模块中。而发现类的多重职责需要设计人员具有较强的分析设计能力和相关重构经验。下面以大学学生工作管理程序为例介绍单一职责原则的应用。

**分析**：大学学生工作主要包括学生生活辅导和学生学业指导两个方面的工作，其中生活辅导主要包括班委建设、出勤统计、心理辅导、费用催缴、班级管理等工作，学业指导主要包括专业引导、学习辅导、科研指导、学习总结等工作。如果将这些工作交给一位老师负责显然不合理，正确的做 法是生活辅导由辅导员负责，学业指导由学业导师负责，其类图如图 1 所示。

![](http://c.biancheng.net/uploads/allimg/181113/3-1Q113133F4161.gif) 

注意：单一职责同样也适用于方法。一个方法应该尽可能做好一件事情。如果一个方法处理的事情太多，其颗粒度会变得很粗，不利于重用。

> 来源：[设计模式—单一职责原则](http://c.biancheng.net/view/1327.html)  

#### 2. 里氏替换原则

**里氏替换原则**：通俗来讲就是：子类可以扩展父类的功能，但不能改变父类原有的功能。也就是说：**子类继承父类时，除添加新的方法完成新增功能外，尽量不要重写父类的方法。** 

##### 2.1 实现

根据上述理解，对里氏替换原则的定义可以总结如下：

- 子类可以实现父类的抽象方法，但不能覆盖父类的非抽象方法
- 子类中可以增加自己特有的方法
- 当子类的方法重载父类的方法时，方法的前置条件（即方法的输入参数）要比父类的方法更宽松
- 当子类的方法实现父类的方法时（重写/重载或实现抽象方法），方法的后置条件（即方法的的输出/返回值）要比父类的方法更严格或相等

> 来源：[设计模式—里氏替换原则](http://c.biancheng.net/view/1324.html) || [案例分析](https://www.cnblogs.com/qdhxhz/p/9236604.html) 

#### 3. 依赖倒置原则

**依赖倒置原则**：

- 高层模块不应该依赖低层模块，两者都应该依赖其抽象；
- 抽象不应该依赖细节，细节应该依赖抽象
- 针对接口编程，依赖于抽象而不依赖于具体，不要面向实现编程。

##### 3.1 作用

依赖倒置原则的主要作用如下。

- 依赖倒置原则可以降低类间的耦合性。
- 依赖倒置原则可以提高系统的稳定性。
- 依赖倒置原则可以减少并行开发引起的风险。
- 依赖倒置原则可以提高代码的可读性和可维护性。

##### 3.2 实现

依赖倒置原则的目的是通过要面向接口的编程来降低类间的耦合性，所以我们在实际编程中只要遵循以下4点，就能在项目中满足这个规则。

- 每个类尽量提供接口或抽象类，或者两者都具备。

- 变量的声明类型尽量是接口或者是抽象类。

- 任何类都不应该从具体类派生。

- 使用继承时尽量遵循里氏替换原则。

#### 4. 接口隔离原则

**接口隔离原则：** 尽量将臃肿庞大的接口拆分成更小的和更具体的接口，让使用该接口的客户端仅需知道与之相关的方法即可。

- 也就是要为各个类建立它们需要的专用接口，而不要试图去建立一个很庞大的接口供所有依赖它的类去调用。

##### 4.1 和单一职责原则的区别

接口隔离原则和单一职责都是为了提高类的内聚性、降低它们之间的耦合性，体现了封装的思想，但两者是不同的：

- 单一职责原则注重的是职责，而接口隔离原则注重的是对接口依赖的隔离。
- 单一职责原则主要是约束类，它针对的是程序中的实现和细节；接口隔离原则主要约束接口，主要针对抽象和程序整体框架的构建。

##### 4.2 接口隔离原则的优点

接口隔离原则是为了约束接口、降低类对接口的依赖性，遵循接口隔离原则有以下 5 个优点。

1. 将臃肿庞大的接口分解为多个粒度小的接口，可以预防外来变更的扩散，提高系统的灵活性和可维护性。
2. 接口隔离提高了系统的内聚性，减少了对外交互，降低了系统的耦合性。
3. 如果接口的粒度大小定义合理，能够保证系统的稳定性；但是，如果定义过小，则会造成接口数量过多，使设计复杂化；如果定义太大，灵活性降低，无法提供定制服务，给整体项目带来无法预料的风险。
4. 使用多个专门的接口还能够体现对象的层次，因为可以通过接口的继承，实现对总接口的定义。
5. 能减少项目工程中的代码冗余。过大的大接口里面通常放置许多不用的方法，当实现这个接口的时候，被迫设计冗余的代码。

##### 4.3 实现

在具体应用接口隔离原则时，应该根据以下几个规则来衡量。

- 接口尽量小，但是要有限度。一个接口只服务于一个子模块或业务逻辑。
- 为依赖接口的类定制服务。只提供调用者需要的方法，屏蔽不需要的方法。
- 了解环境，拒绝盲从。每个项目或产品都有选定的环境因素，环境不同，接口拆分的标准就不同深入了解业务逻辑。
- 提高内聚，减少对外交互。使接口用最少的方法去完成最多的事情。

> 来源：[设计模式—接口隔离原则](http://c.biancheng.net/view/1330.html) 

#### 5. 开闭原则

软件实体应当**对扩展开放，对修改关闭**，在后续使用时需要合理的使用接口和抽象类实现开闭原则。

##### 5.1 实现

可以通过“**抽象约束、封装变化**”来实现开闭原则，即通过接口或者抽象类为软件实体定义一个相对稳定的抽象层，而将相同的可变因素封装在相同的具体实现类中。

因为抽象灵活性好，适应性广，只要抽象的合理，可以基本保持软件架构的稳定。而软件中易变的细节可以从抽象派生来的实现类来进行扩展，当软件需要发生变化时，只需要根据需求重新派生一个实现类来扩展就可以了。  

- 下面以 Windows 的桌面主题为例介绍开闭原则的应用。

**分析**：Windows 的主题是桌面背景图片、窗口颜色和声音等元素的组合。用户可以根据自己的喜爱更换自己的桌面主题，也可以从网上下载新的主题。这些主题有共同的特点，可以为其定义一个抽象类（Abstract Subject），而每个具体的主题（Specific Subject）是其子类。用户窗体可以根据需要选择或者增加新的主题，而不需要修改原代码，所以它是满足开闭原则的，其类图如图 1 所示。

![](http://c.biancheng.net/uploads/allimg/181113/3-1Q113100151L5.gif) 

> [设计模式—开闭原则](http://c.biancheng.net/view/1322.html) 

#### 6. 迪米特法则

> **最少知道原则** ：实体应当尽量少地与其他实体之间发生相互作用，使得系统功能模块相对独立

**广义的迪米特法则在类的设计上的体现** 

1. 优先考虑将一个类设置成不变类
2. 尽量降低一个类和成员的访问权限。
3. 谨慎使用Serializable。

即一个类应该尽量不要知道其他类太多的东西，不要和陌生的类有太多接触

### 创建型模式

#### 1. 单例模式

#### 2. 工厂模式

在工厂模式中，我们在创建对象时不会对客户端暴露创建逻辑，并且是通过使用一个共同的接口来指向新创建的对象。

![1615267384373](assets/1615267384373.png)

**2.1 主要解决的问题** 

**意图：** 定义一个创建对象的接口，让其子类自己决定实例化哪一个工厂类，工厂模式使其创建过程延迟到子类进行。

**主要解决：**主要解决接口选择的问题。

**何时使用：**我们明确地计划不同条件下创建不同实例时。

**如何解决：**让其子类实现工厂接口，返回的也是一个抽象的产品。

**关键代码：**创建过程在其子类执行。

**应用实例：** 1、Hibernate 换数据库只需换方言和驱动就可以。

**优点：** 

1. 一个调用者想创建一个对象，只要知道其名称就可以了。 
2. 扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以。
3. 屏蔽产品的具体实现，调用者只关心产品的接口。

**缺点：**每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖。这并不是什么好事。

**使用场景：** 

1. 日志记录器：记录可能记录到本地硬盘、系统事件、远程服务器等，用户可以选择记录日志到什么地方。
2. 数据库访问，当用户不知道最后系统采用哪一类数据库，以及数据库可能有变化时。
3. 设计一个连接服务器的框架，需要三个协议，"POP3"、"IMAP"、"HTTP"，可以把这三个作为产品类，共同实现一个接口。

**注意事项：**作为一种创建类模式，在任何需要生成复杂对象的地方，都可以使用工厂方法模式。有一点需要注意的地方就是复杂对象适合使用工厂模式，而简单对象，特别是只需要通过 new 就可以完成创建的对象，无需使用工厂模式。如果使用工厂模式，就需要引入一个工厂类，会增加系统的复杂度。

#### 3. 建造者模式

**3.1 建造者模式定义** 

**建造者模式（Builder Pattern）** 使用多个简单的对象一步一步构建成一个复杂的对象。这种类型的设计模式属于创建型模式，它提供了一种创建对象的最佳方式。

- 一个 Builder 类会一步一步构造最终的对象。该 Builder 类是独立于其他对象的。

**3.2主要解决问题** 

**意图：**将一个复杂的构建与其表示相分离，使得同样的构建过程可以创建不同的表示。

**主要解决：**主要解决在软件系统中，有时候面临着"一个复杂对象"的创建工作，其通常由各个部分的子对象用一定的算法构成；由于需求的变化，这个复杂对象的各个部分经常面临着剧烈的变化，但是将它们组合在一起的算法却相对稳定。

**何时使用：**一些基本部件不会变，而其组合经常变化的时候。

**如何解决：**将变与不变分离开。

**关键代码：**建造者：创建和提供实例，导演：管理建造出来的实例的依赖关系。

**应用实例：** 1、JAVA 中的 StringBuilder。

**优点：** 1、建造者独立，易扩展。 2、便于控制细节风险。

**缺点：** 1、产品必须有共同点，范围有限制。 2、如内部变化复杂，会有很多的建造类。

**使用场景：** 1、需要生成的对象具有复杂的内部结构。 2、需要生成的对象内部属性本身相互依赖。

**注意事项：**与工厂模式的区别是：建造者模式更加关注与零件装配的顺序。

```java
public class SqlSessionFactoryBuilder {

  public SqlSessionFactory build(Reader reader) {
    return build(reader, null, null);
  }

  public SqlSessionFactory build(Reader reader, String environment) {
    return build(reader, environment, null);
  }

  public SqlSessionFactory build(Reader reader, Properties properties) {
    return build(reader, null, properties);
  }

  public SqlSessionFactory build(Reader reader, String environment, Properties properties) {
    try {
      XMLConfigBuilder parser = new XMLConfigBuilder(reader, environment, properties);
      return build(parser.parse());
    } catch (Exception e) {
      throw ExceptionFactory.wrapException("Error building SqlSession.", e);
    } finally {
      ErrorContext.instance().reset();
      try {
        reader.close();
      } catch (IOException e) {
        // Intentionally ignore. Prefer previous error.
      }
    }
  }

  public SqlSessionFactory build(InputStream inputStream) {
    return build(inputStream, null, null);
  }

  public SqlSessionFactory build(InputStream inputStream, String environment) {
    return build(inputStream, environment, null);
  }

  public SqlSessionFactory build(InputStream inputStream, Properties properties) {
    return build(inputStream, null, properties);
  }

  public SqlSessionFactory build(InputStream inputStream, String environment, Properties properties) {
    try {
      XMLConfigBuilder parser = new XMLConfigBuilder(inputStream, environment, properties);
      return build(parser.parse());
    } catch (Exception e) {
      throw ExceptionFactory.wrapException("Error building SqlSession.", e);
    } finally {
      ErrorContext.instance().reset();
      try {
        inputStream.close();
      } catch (IOException e) {
        // Intentionally ignore. Prefer previous error.
      }
    }
  }

  public SqlSessionFactory build(Configuration config) {
    return new DefaultSqlSessionFactory(config);
  }

}
```

### 结构型模式

#### 1. 代理模式

![1615267711581](assets/1615267711581.png) 

- **静态代理**：同一个接口下，用一个实现类调用另外一个实现类的方法实现并在自己的方法体中逻辑增强 
- **JDK动态代理** ：基于接口实现、实现InvocationHanlder接口，使用Proxy代理类生成代理子类
- **Cglib动态代理** ： 基于ASM技术修改字节码生成子类处理，实现MethodInterceptor接口，重写它的 intercept () 方法 

相关文章

1. [代理模式](https://www.cnblogs.com/qdhxhz/p/9241412.html) || [AOP的代理](https://blog.csdn.net/qq_41893274/article/details/89333370) 

#### 2. 装饰者模式

**2.1 模式定义** 

**装饰器模式（Decorator Pattern）** : 允许向一个现有的对象添加新的功能，同时又不改变其结构。这种类型的设计模式属于结构型模式，它是作为现有的类的一个包装。

这种模式创建了一个装饰类，用来包装原有的类，并在保持类方法签名完整性的前提下，提供了额外的功能。

我们通过下面的实例来演示装饰器模式的用法。其中，我们将把一个形状装饰上不同的颜色，同时又不改变形状类。

![1615194878896](assets/1615194878896.png) 

**2.2 主要解决的问题** 

**意图：**动态地给一个对象添加一些额外的职责。就增加功能来说，装饰器模式相比生成子类更为灵活。

**主要解决：** 一般的，我们为了扩展一个类经常使用继承方式实现，由于继承为类引入静态特征，并且随着扩展功能的增多，子类会很膨胀。

**何时使用：**在不想增加很多子类的情况下扩展类的功能。

**如何解决：**将具体功能职责划分，同时继承装饰者模式。

**关键代码：** 

	 1. Component 类充当抽象角色，不应该具体实现。 
  	 2. 修饰类引用和继承 Component 类，具体扩展类重写父类方法。

**（3）优缺点** 

**优点：**装饰类和被装饰类可以独立发展，不会相互耦合，装饰模式是继承的一个替代模式，装饰模式可以动态扩展一个实现类的功能。

**缺点：**多层装饰比较复杂。

**使用场景：** 1、扩展一个类的功能。 2、动态增加功能，动态撤销。

**注意事项：**可代替继承。

**2.3 装饰者模式在MyBatis中的应用** 



相关文章

1. https://www.runoob.com/design-pattern/decorator-pattern.html

#### 3. 组合模式

组合模式（Composite Pattern），又叫部分整体模式，是用于把一组相似的对象当作一个单一的对象。组合模式依据树形结构来组合对象，用来表示部分以及整体层次。这种类型的设计模式属于结构型模式，它创建了对象组的树形结构。

这种模式创建了一个包含自己对象组的类。该类提供了修改相同对象组的方式。

**3.1 解决的问题** 

**意图：**将对象组合成树形结构以表示"部分-整体"的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。

**主要解决：**它在我们树型结构的问题中，模糊了简单元素和复杂元素的概念，客户程序可以像处理简单元素一样来处理复杂元素，从而使得客户程序与复杂元素的内部结构解耦。

**何时使用：** 

1. 您想表示对象的部分-整体层次结构（树形结构）。 
2. 您希望用户忽略组合对象与单个对象的不同，用户将统一地使用组合结构中的所有对象。

**如何解决：**树枝和叶子实现统一接口，树枝内部组合该接口。

**关键代码：**树枝内部组合该接口，并且含有内部属性 List，里面放 Component。

**优点：** 

1. 块调用简单。 
2. 节点自由增加。

**缺点：**在使用组合模式时，其叶子和树枝的声明都是实现类，而不是接口，违反了依赖倒置原则。

**使用场景：**部分、整体场景，如树形菜单，文件、文件夹的管理。

**注意事项：**定义时为具体类。

**3.2 MyBatis 中引用组合模式** 

Mybatis支持动态SQL的强大功能，比如下面的这个SQL：

![Mybatis中9种经典的设计模式！你知道几个？](assets/e4fb5d1e7e0341cb84edab0aeb888fc7.jpg) 

对于实现该SqlSource接口的所有节点，就是整个组合模式树的各个节点： 

![1615268164173](assets/1615268164173.png) 

#### 4. 适配器模式

**4.1 模式定义** 

**适配器模式（Adapter Pattern）** 是作为两个不兼容的接口之间的桥梁。这种类型的设计模式属于结构型模式，它结合了两个独立接口的功能。

这种模式涉及到一个单一的类，该类负责加入独立的或不兼容的接口功能

**4.2 主要解决的问题** 

**意图：**将一个类的接口转换成客户希望的另外一个接口。适配器模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。

**主要解决：**主要解决在软件系统中，常常要将一些"现存的对象"放到新的环境中，而新环境要求的接口是现对象不能满足的。

**何时使用：** 

1. 系统需要使用现有的类，而此类的接口不符合系统的需要。 
2. 想要建立一个可以重复使用的类，用于与一些彼此之间没有太大关联的一些类，包括一些可能在将来引进的类一起工作，这些源类不一定有一致的接口。
3. 、通过接口转换，将一个类插入另一个类系中。

**如何解决：**继承或依赖（推荐）。

**关键代码：**适配器继承或依赖已有的对象，实现想要的目标接口。

**应用实例：** 

1. JAVA JDK 1.1 提供了 Enumeration 接口，而在 1.2 中提供了 Iterator 接口，想要使用 1.2 的 JDK，则要将以前系统的 Enumeration 接口转化为 Iterator 接口，这时就需要适配器模式。 
2. 在 LINUX 上运行 WINDOWS 程序。 
3. JAVA 中的 jdbc。

**优点：** 

1. 可以让任何两个没有关联的类一起运行。 
2. 提高了类的复用。 
3. 增加了类的透明度。
4. 灵活性好。

**缺点：**

1. 过多地使用适配器，会让系统非常零乱，不易整体进行把握。比如，明明看到调用的是 A 接口，其实内部被适配成了 B 接口的实现，一个系统如果太多出现这种情况，无异于一场灾难。因此如果不是很有必要，可以不使用适配器，而是直接对系统进行重构。 2.由于 JAVA 至多继承一个类，所以至多只能适配一个适配者类，而且目标类必须是抽象类。

**使用场景：**有动机地修改一个正常运行的系统的接口，这时应该考虑使用适配器模式。

**注意事项：**适配器不是在详细设计时添加的，而是解决正在服役的项目的问题。

**4.3 mybatis 中引用案例** 

> Log 该接口定义了Mybatis直接使用的日志方法，而Log接口具体由谁来实现呢？

Mybatis提供了多种日志框架的实现，这些实现都匹配这个Log接口所定义的接口方法，最终实现了所有外部日志框架到Mybatis日志包的适配

![1615270613326](assets/1615270613326.png) 

比如 ` Slf4jImpl` 实现类的适配逻辑

```java
public class Slf4jImpl implements Log {

  private Log log;

  public Slf4jImpl(String clazz) {
    Logger logger = LoggerFactory.getLogger(clazz);

    if (logger instanceof LocationAwareLogger) {
      try {
        // check for slf4j >= 1.6 method signature
        logger.getClass().getMethod("log", Marker.class, String.class, int.class, 
                                                          String.class, Object[].class, Throwable.class);
        log = new Slf4jLocationAwareLoggerImpl((LocationAwareLogger) logger);
        return;
      } catch (SecurityException | NoSuchMethodException e) {
        // fail-back to Slf4jLoggerImpl
      }
    }

    // Logger is not LocationAwareLogger or slf4j version < 1.6
    log = new Slf4jLoggerImpl(logger);
  }

  @Override
  public boolean isDebugEnabled() {
    return log.isDebugEnabled();
  }

  @Override
  public boolean isTraceEnabled() {
    return log.isTraceEnabled();
  }

  @Override
  public void error(String s, Throwable e) {
    log.error(s, e);
  }

  @Override
  public void error(String s) {
    log.error(s);
  }

  @Override
  public void debug(String s) {
    log.debug(s);
  }

  @Override
  public void trace(String s) {
    log.trace(s);
  }

  @Override
  public void warn(String s) {
    log.warn(s);
  }

}
```



### 行为型模式

#### 1. 责任链模式

##### （1）模式定义

**责任链模式（Chain of Responsibility Pattern）** 使多个对象都有机会处理请求，从而避免了多个请求发送者和接收者之间的耦合关系。将这些对象连成一条链，并沿着这条链传递该请求，直到有对象处理该请求为止。

在这种模式中，通常每个接收者都包含对另一个接收者的引用。如果一个对象不能处理该请求，那么它会把相同的请求传给下一个接收者，依此类推。

##### （2）主要解决的问题

> 意图

避免请求发送者与接收者耦合在一起。让多个对象都有可能接收请求，将这些对象连接成一条链，并且沿着这条链传递请求，直到有对象处理它为止。

> 主要解决

职责链上的处理者负责处理请求，客户只需要将请求发送到职责链上即可，无须关心请求的处理细节和请求的传递，所以职责链将请求的发送者和请求的处理者解耦了。

> 何时使用

在处理消息的时候以过滤很多道。

> 如何解决

拦截的类都实现统一接口。

##### （3）优缺点

> 优点

1. 降低耦合度。它将请求的发送者和接收者解耦。
2. 简化了对象。使得对象不需要知道链的结构。
3. 增强给对象指派职责的灵活性。通过改变链内的成员或者调动它们的次序，允许动态地新增或者删除责任。
4. 增加新的请求处理类很方便。

> 缺点

1. 不能保证请求一定被接收。 
2. 系统性能将受到一定影响，而且在进行代码调试时不太方便，可能会造成循环调用。 
3. 可能不容易观察运行时的特征，有碍于除错。

##### （4）适用场景

1. 有多个对象可以处理同一个请求，具体哪个对象处理该请求由运行时刻自动确定。 
2. 在不明确指定接收者的情况下，向多个对象中的一个提交一个请求。
3. 可动态指定一组对象处理请求，或添加新的处理者。

适用于多节点的流程处理，每个节点完成各自负责的部分，节点之间不知道彼此的存在，比如：

1. OA 的审批流
2. Java Web 开发中的 Filter 机制。
3. 击鼓传花游戏

##### （5）实战案例

责任链模式设计两个角色：

1. **抽象处理者角色（Handler）:** 该角色对请求进行抽象，并定义一个方法以设定和返回对下一个处理者的引用。
2. **具体处理者角色（Concrete Handler）** : 该角色接到请求后，可以将请求处理掉，或者将请求传给下一个处理者，由于具体处理者持有对下一个处理者的引用，因此如果需要，具体处理者可以访问下一个处理者。

> 代码示例

源码地址：[快速访问](https://github.com/GitHubWxw/java-general/tree/master/java-designpattern/src/main/java/com/wxw/chain) 

责任链中一个处理者对象，其中只有两个行为，一是处理请求，二是将请求转送给下一个节点，不允许某个处理者对象在处理了请求后又将请求转送给上一个节点的情况。对于一条责任链来说，一个请求最终只有两种情况，一是被某个处理对象所处理，另一个是所有对象均未对其处理，前一种情况称该责任链为纯的责任链，对于后一种情况称为不纯的责任链，实际应用中，多为不纯的责任链。

#### 2. 策略模式

在**策略模式（Strategy Pattern）**中，一个类的行为或其算法可以在运行时更改。这种类型的设计模式属于行为型模式。

- 意图：定义一系列的算法,把它们一个个封装起来, 并且使它们可相互替换。
- 主要解决：在有多种算法相似的情况下，使用 if...else 所带来的复杂和难以维护。
- **何时使用：**一个系统有许多许多类，而区分它们的只是他们直接的行为。
- **如何解决：**将这些算法封装成一个一个的类，任意地替换。
- **关键代码：**实现同一个接口。

##### （1）优缺点

> 优点

1. 算法可以自由切换
2. 避免使用多重条件判断
3. 扩展性良好

> 缺点

1. 策略类会增多
2. 所有策略类都需要对外暴露

##### （2）使用场景

1. 如果在一个系统里面有许多类，它们之间的区别仅在于它们的行为，那么使用策略模式可以动态地让一个对象在许多行为中选择一种行为。
2. 一个系统需要动态地在几种算法中选择一种。 
3. 如果一个对象有很多的行为，如果不用恰当的模式，这些行为就只好使用多重的条件选择语句来实现。

> **注意事项：**如果一个系统的策略多于四个，就需要考虑使用混合模式，解决策略类膨胀的问题。

##### （3）实现

们将创建一个定义活动的 *Strategy* 接口和实现了 *Strategy* 接口的实体策略类。*Context* 是一个使用了某种策略的类。

*StrategyPatternDemo*，我们的演示类使用 *Context* 和策略对象来演示 Context 在它所配置或使用的策略改变时的行为变化。

![](https://www.runoob.com/wp-content/uploads/2014/08/strategy_pattern_uml_diagram.jpg) 

代码地址：[快速访问](https://github.com/GitHubWxw/java-general/tree/master/java-designpattern/src/main/java/com/wxw/strategy) 

#### 3. 状态模式

##### 3.1 意图

允许对象在内部状态发生改变时改变它的行为，对象看起来好像修改了它的类。

- 主要解决：对象的行为依赖于它的状态（属性），并且可以根据它的状态改变而改变它的相关行为。
- **何时使用：**代码中包含大量与对象状态有关的条件语句。
- **如何解决：**将各种具体的状态类抽象出来。

##### 3.2 模式结构

状态模式包含以下主要角色。

1. 环境类（Context）角色：也称为上下文，它定义了客户端需要的接口，内部维护一个当前状态，并负责具体状态的切换。
2. 抽象状态（State）角色：定义一个接口，用以封装环境对象中的特定状态所对应的行为，可以有一个或多个行为。
3. 具体状态（Concrete State）角色：实现抽象状态所对应的行为，并且在需要的情况下进行状态切换。

![](http://c.biancheng.net/uploads/allimg/181116/3-1Q11615412U55.gif) 

##### 3.3  应用场景

1. 行为随状态改变而改变的场景
2. 条件、分支语句的代替者

> **注意事项：**在行为受状态约束的时候使用状态模式，而且状态不超过 5 个。

> 来源：[设计模式—状态模式](http://c.biancheng.net/view/1388.html) ||   [源码](https://github.com/GitHubWxw/wxw-java/tree/master/java-designpattern/src/main/java/com/wxw/state) 

#### 4. 观察者模式

当对象间存在一对多关系时，则使用观察者模式（Observer Pattern）。比如，当一个对象被修改时，则会自动通知依赖它的对象。观察者模式属于行为型模式。

##### 4.1 基本介绍

- **意图：**定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。
- **主要解决：**一个对象状态改变给其他对象通知的问题，而且要考虑到易用和低耦合，保证高度的协作。
- **何时使用：**一个对象（目标对象）的状态发生改变，所有的依赖对象（观察者对象）都将得到通知，进行广播通知。

##### 4.2 优缺点

- **优点：** 1、观察者和被观察者是抽象耦合的。 2、建立一套触发机制。

- **缺点：** 

   1、如果一个被观察者对象有很多的直接和间接的观察者的话，将所有的观察者都通知到会花费很多时间。

   2、如果在观察者和观察目标之间有循环依赖的话，观察目标会触发它们之间进行循环调用，可能导致系统崩溃。

   3、观察者模式没有相应的机制让观察者知道所观察的目标对象是怎么发生变化的，而仅仅只是知道观察目标发生了变化。

##### 4.3 使用场景

- 一个对象的改变将导致其他一个或多个对象也发生改变，而不知道具体有多少对象将发生改变，可以降低对象之间的耦合度。
- 一个对象必须通知其他对象，而并不知道这些对象是谁。
- 需要在系统中创建一个触发链，A对象的行为将影响B对象，B对象的行为将影响C对象……，可以使用观察者模式创建一种链式触发机制

##### 4.3 模式结构与实现

实现观察者模式时要注意具体目标对象和具体观察者对象之间不能直接调用，否则将使两者之间紧密耦合起来，这违反了面向对象的设计原则。

> 模式的结构

观察者模式的主要角色如下。

1. 抽象主题（Subject）角色：也叫抽象目标类，它提供了一个用于保存观察者对象的聚集类和增加、删除观察者对象的方法，以及通知所有观察者的抽象方法。
2. 具体主题（Concrete Subject）角色：也叫具体目标类，它实现抽象目标中的通知方法，当具体主题的内部状态发生改变时，通知所有注册过的观察者对象。
3. 抽象观察者（Observer）角色：它是一个抽象类或接口，它包含了一个更新自己的抽象方法，当接到具体主题的更改通知时被调用。
4. 具体观察者（Concrete Observer）角色：实现抽象观察者中定义的抽象方法，以便在得到目标的更改通知时更新自身的状态。

**观察者模式的结构图** 

![è§å¯èæ¨¡å¼çç»æå¾](assets/3-1Q1161A6221S.gif) 

> 代码示例 

```java

import java.util.*;

public class ObserverPattern {
    public static void main(String[] args) {
        Subject subject = new ConcreteSubject();
        Observer obs1 = new ConcreteObserver1();
        Observer obs2 = new ConcreteObserver2();
        subject.add(obs1);
        subject.add(obs2);
        subject.notifyObserver();
    }
}

//抽象目标
abstract class Subject {
    protected List<Observer> observers = new ArrayList<Observer>();

    //增加观察者方法
    public void add(Observer observer) {
        observers.add(observer);
    }

    //删除观察者方法
    public void remove(Observer observer) {
        observers.remove(observer);
    }

    public abstract void notifyObserver(); //通知观察者方法
}

//具体目标
class ConcreteSubject extends Subject {
    public void notifyObserver() {
        System.out.println("具体目标发生改变...");
        System.out.println("--------------");

        for (Object obs : observers) {
            ((Observer) obs).response();
        }

    }
}

//抽象观察者
interface Observer {
    void response(); //反应
}

//具体观察者1
class ConcreteObserver1 implements Observer {
    public void response() {
        System.out.println("具体观察者1作出反应！");
    }
}

//具体观察者2
class ConcreteObserver2 implements Observer {
    public void response() {
        System.out.println("具体观察者2作出反应！");
    }
}
```

> 模式的扩展

在 Java中，通过 java.util.Observable 类和 java.util.Observer 接口定义了观察者模式，只要实现它们的子类就可以编写观察者模式实例。

**1. Observable类**

Observable 类是抽象目标类，它有一个 Vector 向量，用于保存所有要通知的观察者对象，下面来介绍它最重要的 3 个方法。

1. void addObserver(Observer o) 方法：用于将新的观察者对象添加到向量中。
2. void notifyObservers(Object arg) 方法：调用向量中的所有观察者对象的 update() 方法，通知它们数据发生改变。通常越晚加入向量的观察者越先得到通知。
3. void setChange() 方法：用来设置一个 boolean 类型的内部标志位，注明目标对象发生了变化。当它为真时，notifyObservers() 才会通知观察者。

**2. Observer 接口** 

Observer 接口是抽象观察者，它监视目标对象的变化，当目标对象发生变化时，观察者得到通知，并调用 void update(Observable o,Object arg) 方法，进行相应的工作。

示例代码：

```java
public class ZkWatcherDemo {
    public static void main(String[] args) {
        zNode zNode = new zNode();
        Watcher1 watcher1 = new Watcher1();
        Watcher2 watcher2 = new Watcher2();
        zNode.addObserver(watcher1);
        zNode.addObserver(watcher2);
        zNode.submit("监听方法");

    }
}
    // 具体目标类
    class zNode extends Observable{
        // 添加
        // 通知
        public void submit(String state){
            System.out.println("监听submit 事件触发广播");
            this.setChanged();
            this.notifyObservers(state);
        }
    }

    // 具体观察者 节点更新
    class Watcher1 implements Observer {
        @Override
        public void update(Observable observable, Object o) {
            System.out.println("Watcher1: 节点1被更新了");
        }
    }

    // 具体观察者 节点更新
    class Watcher2 implements Observer {
        @Override
        public void update(Observable observable, Object o) {
            System.out.println("Watcher2: 节点2被更新了");
        }
    }
```

> 来源： [观察者模式](http://c.biancheng.net/view/1390.html)  || [源码](https://github.com/GitHubWxw/wxw-java/tree/master/java-designpattern/src/main/java/com/wxw/observe) 

#### 5. 模板方法模式

在模板模式（Template Pattern）中，一个抽象类公开定义了执行它的方法的方式/模板。它的子类可以按需要重写方法实现，但调用将以抽象类中定义的方式进行。这种类型的设计模式属于行为型模式。模板方法模式就是利用了面向对象中的多态特性。

![模板模式的 UML 图](assets/template_pattern_uml_diagram.jpg) 

**主要解决：**一些方法通用，却在每一个子类都重新写了这一方法。

**优点：** 

1. 封装不变部分，扩展可变部分。 
2. 提取公共代码，便于维护。 
3. 行为由父类控制，子类实现。

**缺点：** 每一个不同的实现都需要一个子类来实现，导致类的个数增加，使得系统更加庞大。

**注意事项：**为防止恶意操作，一般模板方法都加上 final 关键词。

在模板方法模式中有两个重要的角色，一个是抽象模板类，另一个就是具体的实现类。

##### 5.3 应用场景

1. AQS 的实现

> 来源：[模板方法模式](https://www.runoob.com/design-pattern/template-pattern.html) 

#### 6. 迭代器模式

**6.1 模式定义** 

迭代器模式（Iterator Pattern）是 Java 和 .Net 编程环境中非常常用的设计模式。这种模式**用于顺序访问集合对象的元素**，不需要知道集合对象的底层表示。迭代器模式属于行为型模式。

**6.2 主要解决问题** 

**意图：**提供一种方法顺序访问一个聚合对象中各个元素, 而又无须暴露该对象的内部表示。

**主要解决：**不同的方式来遍历整个整合对象。

**何时使用：**遍历一个聚合对象。

**如何解决：**把在元素之间游走的责任交给迭代器，而不是聚合对象。

**关键代码：**定义接口：hasNext, next。

**应用实例：**JAVA 中的 iterator。

**优点：** 

1. 它支持以不同的方式遍历一个聚合对象。 
2. 迭代器简化了聚合类。 
3. 在同一个聚合上可以有多个遍历。 
4. 在迭代器模式中，增加新的聚合类和迭代器类都很方便，无须修改原有代码。

**缺点：**由于迭代器模式将存储数据和遍历数据的职责分离，增加新的聚合类需要对应增加新的迭代器类，类的个数成对增加，这在一定程度上增加了系统的复杂性。

**使用场景：** 

1. 访问一个聚合对象的内容而无须暴露它的内部表示。 
2. 需要为聚合对象提供多种遍历方式。 
3. 为遍历不同的聚合结构提供一个统一的接口。

**注意事项：**迭代器模式就是分离了集合对象的遍历行为，抽象出一个迭代器类来负责，这样既可以做到不暴露集合的内部结构，又可让外部代码透明地访问集合内部的数据。







































