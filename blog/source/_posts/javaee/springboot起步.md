---
title: springboot起步
categories:
  - [javaee, spring]
site: javaee
date: 2021-09-01 15:21:57
---

## springboot配置

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
@ToString
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
