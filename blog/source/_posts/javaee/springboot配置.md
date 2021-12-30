---
title: springboot配置
categories:
  - [javaee, spring]
site: javaee
date: 2021-09-01 15:21:57
---

## springboot配置

### 配置加载顺序

* 优先级从高到低

1. **命令行传入的参数。**
2. SPRING_APPLICATION_JSON中的属性，是以JSON格式配置在系统环境变量中的内容。
3. java:comp/env中的JNDI属性。
4. java的系统属性，可以通过System.getProperties()获得的内容。
5. 操作系统的环境变量。
6. 通过random.*配置的随机属性。
7. **位于当前jar包之外，针对于特定的环境的而指定的配置文件。**如application-prod.yml。
8. **位于当前jar包内，针对于特定环境的而指定配置文件。**
9. **位于当前jar包外的application.properties和yml文件。**
10. **位于当前jar包内的application.properties和yml文件。**
11. 在@Configuration注解修饰的类中，通过@PropertySource注解定义的属性。
12. 应用默认属性，使用SpringAppication.setDefaultProperties定义的内容。

### 注入到类

1. resources/properties/person.properties

```properties
person.name=xiaoxiang
person.age=21
person.sex=1
person.weight=67
person.height=177
```

2. java/space/xiaoxiang/properties/Person

```java
@Component
@PropertySource(value = "classpath:properties/person.properties",ignoreResourceNotFound = false)
@ConfigurationProperties(prefix = "person")
@Data //必须要有setter方法，否则无法注入
public class Person {
    private String name;
    private int age;
    private int sex;
    private double weight;
    private double height;
    private String description;
}
```

3. controller中注入

```java
@Autowired
private Person person;
```

### 注入某个字段

1. application.yml

```yaml
sbl:
  hostname: xiaoxiang.space
```

2. controller

```java
@RestController
public class IndexController {

    //注入
    @Value("${sbl.hostname}")
    private String sblHostname;
	
    //...
}
```

### 参数引用

* 在application.yml中的各个参数之间，可以通过placeholder的方式进行引用。

```yaml
sbl:
  hostname: ${hostname}
hostname: xiaoxiang.space
```

### 使用随机数

``` yaml
#随机字符串
value1: ${random.value}
#随机int
value2: ${random.int}
#随机long
value3: ${random.long}
#10以内的随机数
value4: ${random.int(10)}
#10-20的随机数
value5: ${random.int[10,20]}
```

**参考链接：**[Spring Boot 2.x基础教程：配置文件详解 | 程序猿DD](https://blog.didispace.com/spring-boot-learning-21-1-3/)
