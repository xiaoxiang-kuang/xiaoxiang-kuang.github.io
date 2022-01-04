---
title: mybatis映射文件
tags: 
  - javaee
date: 2021-10-31 19:47:53
---

## resultMap

* 当返回结果时（未显示指定resultmap），mybatis会创建一个ResultMap，将属性名映射到实体类的属性上，如果列名和属性名不能匹配时，可以在select语句中设置别名来完成匹配，如`user_id as "id"`。

### 属性

* id 唯一标识，别的地方引用
* type 类的完全限定命名，或者类型别名。
* autoMapping 如果设置这个属性，mybatis将会为本结果映射开启或关闭自动映射。这个属性会覆盖全局的autoMappingBehavior。

### 元素

* `constructor` 用于在实例化类时，注入结果到构造方法中
  * `idArg` ID参数；标记出作为ID的结果可以帮助提高整体性能
  * `arg` 将被注入到构造方法的一个普通结果
* `id` 标记作为ID的结果可以帮助提高整体性能
* `result` 注入到实体类的普通结果
* `association` 关联一个复杂的类型，即数据库的一对一。
* `collection` 数据库的一对多
* `discriminator` 使用结果值来决定使用哪个resultMap
  * case 基于某些值的结果映射

* id和result唯一的不同是，id元素对应的属性会被标记为对象的标识符，在比较对象实例时使用，能提高整体的性能。

#### id&result

* `property` 映射到列的属性，如果实体类有这个名字的property，会先使用该属性。
* `column` 数据库中的列名，或者是列的别名。
* `javaType` 一个Java类的全限定命名，或者一个类型别名。如果映射到实体类，mybatis通常可以推断类型。如果映射到HashMap，则应该明确指定javaType来保证类型一致。
* `jdbcType` JDBC类型，只有可为空的列上能指定JDBC类型。
* `typeHandler` 指定类型处理器，需要是全限定命名或者类型别名。

#### association

```xml
<resultMap id="blogResult" type="Blog">
  <id property="id" column="blog_id" />
  <result property="title" column="blog_title"/>
  <!-- 这里的author指的是Blog中的属性 -->
  <association property="author" column="blog_author_id" javaType="Author" resultMap="authorResult"/>
</resultMap>

<resultMap id="authorResult" type="Author">
  <id property="id" column="author_id"/>
  <result property="username" column="author_username"/>
  <result property="password" column="author_password"/>
</resultMap>

<!-- 或者使用下面的形式-->

<resultMap id="blogResult" type="Blog">
  <id property="id" column="blog_id" />
  <result property="title" column="blog_title"/>
  <association property="author" javaType="Author">
    <id property="id" column="author_id"/>
    <result property="username" column="author_username"/>
    <result property="password" column="author_password"/>
  </association>
</resultMap>
```

```sql
<select id="selectBlog" resultMap="blogResult">
  select
    B.id            as blog_id,
    B.title         as blog_title,
    B.author_id     as blog_author_id,
    A.id            as author_id,
    A.username      as author_username,
    A.password      as author_password,
  from Blog B left outer join Author A on B.author_id = A.id
  where B.id = #{id,javaType}
</select>
```

#### collection

```xml
<resultMap id="blogResult" type="Blog">
  <id property="id" column="blog_id" />
  <result property="title" column="blog_title"/>
  <collection property="posts" ofType="Post" resultMap="blogPostResult" columnPrefix="post_"/>
</resultMap>

<resultMap id="blogPostResult" type="Post">
  <id property="id" column="id"/>
  <result property="subject" column="subject"/>
  <result property="body" column="body"/>
</resultMap>

<!-- 或者使用下面这种形式 -->
<resultMap id="blogResult" type="Blog">
  <id property="id" column="blog_id" />
  <result property="title" column="blog_title"/>
  <collection property="posts" ofType="Post">
    <id property="id" column="post_id"/>
    <result property="subject" column="post_subject"/>
    <result property="body" column="post_body"/>
  </collection>
</resultMap>
```

```sql
<select id="selectBlog" resultMap="blogResult">
  select
  B.id as blog_id,
  B.title as blog_title,
  B.author_id as blog_author_id,
  P.id as post_id,
  P.subject as post_subject,
  P.body as post_body,
  from Blog B
  left outer join Post P on B.id = P.blog_id
  where B.id = #{id}
</select>
```
<!--more-->
