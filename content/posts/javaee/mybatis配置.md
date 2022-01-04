---
title: mybatis配置
tags: 
  - javaee
date: 2021-11-02 16:00:45
---

### 总览 

* `configuration` 配置
  * `properties` 属性
  * `settings` 设置
  * `typeAliases` 类型别名
  * `typeHandlers` 类型处理器
  * `objectFactory` 对象工厂
  * `plugins` 插件
  * `environments` 环境变量
    * `environment`
      * `transactionManager` 事务管理器
      * `dataSource` 数据源
  * `databaseIdProvider` 数据库标识
  * `mappers` 映射器

### 属性properties

* 设置好的属性可以在整个配置文件中使用。
* 通过方法参数传递的属性优先级最高，resource/url属性中指定的位置文件次之，properties元素中指定的属性优先级最低。

```xml
<properties resource="org/mybatis/example/config.properties">
  <property name="username" value="dev_user"/>
  <!-- 启用默认值设置，使用方式为${username:prod_user} -->
  <property name="org.apache.ibatis.parsing.PropertyParser.enable-default-value" value="true"/>
</properties>
```

### 类型别名typeAliases

* 指定类型别名
* 内建的一些类型别名，如：string、long、integer、float、map、arraylist、date等

```xml
<typeAliases>
  <typeAlias alias="author" type="domain.blog.Author"/>
  <!-- 每一个在包domain.blog中的类，会默认使用该类的首字母小写的类名作为它的别名 -->
  <package name="domain.blog"/>
</typeAliases>
```

### 环境变量environments

``` xml
<environments default="development">
    <!--  type用来指定数据源，内建了三种数据源UNPOOLED|POOLED|JNDI，可以通过实现接口DataSourceFactory来使用第三方数据源 -->
    <dataSource type="">
      <property name="driver" value="${driver}"/>
      <property name="url" value="${url}"/>
      <property name="username" value="${username}"/>
      <property name="password" value="${password}"/>
    </dataSource>
  </environment>
</environments>
```

### 数据库标识databaseIdProvider

* mybatis可以根据不同的数据库厂商执行不同的语句。

```xml
<databaseIdProvider type="DB_VENDOR">
  <property name="SQL Server" value="sqlserver"/>
  <property name="DB2" value="db2"/>
  <property name="MySQL" value="mysql" />
</databaseIdProvider>
```

* 使用方式

```xml
<select id="select" resultType="map" databaseId="mysql">
	select * from mysql
</select>
```



### 映射器

```xml
<mappers>
  <mapper resource="org/mybatis/builder/AuthorMapper.xml"/>
  <mapper url="file:///var/mappers/PostMapper.xml"/>
  <mapper class="org.mybatis.builder.PostMapper"/>
  <package name="org.mybatis.builder"/>
</mappers>
```

<!--more-->
