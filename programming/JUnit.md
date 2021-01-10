# JUnit

> 使用IDEA进行基本操作

JUnit是一个回归测试框架（regression testing framework）。Junit测试是程序员测试，即所谓白盒测试，因为程序员知道被测试的软件如何（How）完成功能和完成什么样（What）的功能。Junit是一套框架，继承TestCase类，就可以用Junit进行自动测试了。



## 安装

Intellij Idea在安装时已经默认配置了Junit单元测试插件JUnit，如果没有找到此插件可以自行下载安装。

安装步骤：  Settings --> Plugins --> *Search(junit)*



## 配置

1. 创建与 `src` 平级的目录：test，存放测试类。
2. 然后 `Mark Director As`：`Test Resources Root`

![](../../image/markDirecotryAsTestResourceRoot.png)



## 创建类

在 `src/demo01` 目录下创建一个类 Student

```java
package demo01;

public class Student implements Comparable {
    private String name;
    private int age;

    public Student() {
        super();
    }

    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public int compareTo(Object o) {
        if (o instanceof Student) {
            Student s = (Student) o;
            int diff_age = this.age - s.age;
            
            return diff_age == 0 ? this.name.compareTo(s.name) : diff_age;
        }
        return 0;
    }
}

```



## 创建测试类

在类 `Student` 中，依次点击: `右击` --> `Go to` --> `Test` --> `Create New Test..`

> 或者快捷键 `Ctrl+Shift+T` --> `Create New Test..`



在 `Create Test` 弹窗中，勾选

- `setUp/@Before`

- 需要测试的 `Member`

如图所示：


![](../../image/CreateNewTest.png)



在测试类 `StudentTest` 中实例化两个 `Student`，并在 `setUp()` 中初始化，测试代码放在相同的 `Member` 中

```java
package demo01;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class StudentTest {
    private Student st1;
    private Student st2;
    private Student st3;
    private Student st4;
    private Student st5;

    @BeforeEach
    void setUp() {
        st1 = new Student("Carol", 21);
        st2 = new Student("Bob", 22);
        st3 = new Student("Alice", 23);
        st4 = new Student("Alice", 21);
        st5 = new Student("Alice", 21);
    }

    @Test
    void compareTo() {
        assertEquals(st1.compareTo(st2), -1);
        assertEquals(st3.compareTo(st4), 2);
        assertEquals(st4.compareTo(st5), 0);
    }
}
```



## 运行测试类

在测试类 `StudentTest` 中以此点击：右击 --> `Run 'StudentTest'`

> 或者快捷键：`Ctrl+Shift+F10`



## 代码覆盖测试

#### 设置

菜单来依次点击：`Run` --> `Edit Configurations...` --> `Code Coverage`

- `Sampling` 默认情况下使用自己的测试引擎

- `Tracing` 覆盖率模式会增加消耗，但是测试会更准确

#### 运行

菜单依次点击：`Run` --> `Run 'StudentTest' with Coverage`



## 批量测试



#### 在 `src/demo01` 目录下创建一个类 `User`

```java
package demo01;

public class User {
    public String getName() {
        return ("Dave");
    }
}
```

在类 `Student` 中，依次点击: `右击` --> `Go to` --> `Test` --> `Create New Test..`

> 或者快捷键 `Ctrl+Shift+T` --> `Create New Test..`

按照上文同样的方法继续...

在测试类 `UserTest` 中实例化 `User`，并在 `setUp()` 中初始化，测试代码放在相同的 `Member` 中

```java
package demo01;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserTest {
    
    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
    }

    @Test
    void getName() {
        assertEquals("Dave", user.getName());
    }
}
```



#### 批量运行测试

选中位于test目录下与待测试同名的包 demo01 依次点击：右键 --> `Run Tests in 'demo01'

> 或者快捷键：`Ctrl+Shift+F10



#### 批量运行覆盖测试

选中位于test目录下与待测试同名的包 demo01 依次点击：右键 --> `Run Tests in 'demo01' with Coverage

> 或者快捷键：`Ctrl+Shift+F10