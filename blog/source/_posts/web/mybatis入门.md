---
title: mybatis入门
categories:
  - [web]
site: web
date: 2021-04-02 09:26:31
---

1. 写mybatis配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!--数据库配置文件路径-->
    <!--<properties resource="config.properties"/>-->
    <environments default="dev">
        <environment id="dev">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="${driver}"/>
                <property name="url" value="${url}"/>
                <property name="username" value="${username}"/>
                <property name="password" value="${password}"/>
            </dataSource>
        </environment>
    </environments>
    <!--映射文件位置-->
    <mappers>
        <mapper resource="space/xiaoxiang/dao/XxxxMapper.xml"/>
    </mappers>
</configuration>
```

2. 数据库配置文件config.properties

```properties
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/xxxxx?serverTimezone=GMT%2B8&characterEncoding=utf-8
username=xxxx
password=xxxxxxxx
```

3. 写dao层接口和xml文件

   1. 接口

   ```java
   package space.xiaoxiang.dao;
   
   import java.util.List;
   import java.util.Map;
   
   public interface XxxxMapper {
       public List<Map<String, Object>> selectAll();
   }
   ```

   2. xml文件

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="space.xiaoxiang.dao.XxxxtMapper">
       <select id="selectAll" resultType="map">
           SELECT * FROM xxxx
       </select>
   </mapper>
   ```

4. 运行

```java
@Test
public void test() throws IOException {
    //数据库配置文件
    String databaseConfigFileName = "config.properties";
    Properties databaseConfig = new Properties();
    databaseConfig.load(Resources.getResourceAsStream(databaseConfigFileName));
    //mybatis配置文件
    String mybatisConfigFileName = "mybatis-config.xml";
    InputStream mybatisConfig = Resources.getResourceAsStream(mybatisConfigFileName);
    //一个数据库对应一个SqlSessionFactory
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(mybatisConfig,databaseConfig);
    try (SqlSession sqlSession = sqlSessionFactory.openSession()) {
        XxxxMapper xxxxMapper = sqlSession.getMapper(XxxxMapper.class);
        xxxxMapper.selectAll().forEach((map) -> {
            xxxxMapper.forEach((k, v) -> {
                System.out.println(k + " : " + v);
            });
        });
    }
}
```



