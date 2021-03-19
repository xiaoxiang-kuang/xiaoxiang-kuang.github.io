---
title: clickhouse起步
categories:
  - [数据库,clickhouse]
site: 数据库
date: 2021-03-11 10:00:32
---

* online analytical processing of queries（OLAP）：联机分析
* clickhouse是一个用于OLAP的列式数据库管理系统（来自同一列的数据被存储在一起）。
* `sudo service clickhouse-server start`启动clickhouse.
* clickhouse不要求主键唯一

### clickhouse连接客户端

#### clickhouse-client

* [clickhouse-client命令行参数](https://clickhouse.tech/docs/zh/interfaces/cli/#command-line-options)
* `clickhouse-client`配置文件地址（使用以下第一个配置文件）
  * 通过`--config-file`参数指定
  * `./clickhouse-client.xml`
  * `~/.clickhouse-client/config.xml`
  * `/etc/clickhouse-server/config.xml`

#### mysql

* 可以通过mysql命令工具连接，需要在配置文件中配置mysql_port：`<mysql_port>9004</mysql_port>`
* 使用命令行工具mysql进行连接：`mysql --protocol tcp -u default -P 9004`

### 数据库引擎

#### mysql引擎

* 用于将远程的mysql服务器中的表映射到clickhouse中，并允许对表进行insert和select查询等，但无法执行rename、create table、alter操作。

  ```sql
  CREATE DATABASE [IF NOT EXISTS] db_name [ON CLUSTER cluster] ENGINE = MYSQL('host:port',['database'| database],'user','password')
  ```

* [类型的对应](https://clickhouse.tech/docs/en/engines/database-engines/mysql/#data_types-support)，其他的mysql数据类型全部转化为字符串

### 表引擎

#### merge tree

* MergeTree：设计用于插入大量数据当一张表当中。数据可以以数据片段的形式一个接一个的快速写入，数据片段在后台按照一定的规则进行合并。
* VersionedCollapsingMergeTree：允许快速写入不断变化的对象状态；删除后台中的旧对象状态。
* SummingMergeTree：合并SummingMergeTree表的数据片断时，clickhouse会把所有具有相同主键的行合并为一行，该行包含了被合并的行中具有数值数据类型的列的汇总值。如果主键的组合方式使得单个键值对应于大量的行，则可以显著的减少存储空间并加快数据查询的速度。
* ReplacingMergeTree：该引擎会删除排序键值相同的重复项。适用于在后台清除重复的数据以节省空间，但不保证没有重复数据出现。
* AggregateMergeTree：改变了数据片段的合并逻辑。clickhouse会将一个数据片段内所有具有相同主键的行替换为一行，这一行会存储一系列聚合函数的状态。可以使用AggregatingMergeTree表来做增量数据的聚合统计，包括物化视图的数据聚合。

##### MergeTree

* 数据可以以数据片段的形式一个接一个的快速写入，数据片段在后台按照一定的规则进行合并。

* 存储的数据按主键排序；支持数据分区（如果指定分区键的话）；支持数据副本；支持数据采样。

* 建表（[更多介绍看这里](https://clickhouse.tech/docs/zh/engines/table-engines/mergetree-family/mergetree/#table_engine-mergetree-creating-a-table)）

  * ```sql
    CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
    (
    	name [type1] [DEFAULT|MATERIALIZED|ALIAS expr1] [TTL expr1],
        name [type2] [DEFAULT|MATERIALIZED|ALIAS expr2] [TTL expr2]
        ...
        INDEX index_name1 expr1 TYPE type1(...) GRANULARITY value1,
        INDEX index_name2 expr2 TYPE type2(...) GRANULARITY value2
    ) ENGINE = MergeTree()
    ORDER BY expr
    [PARTITION BY expr]
    [PRIMARY KEY expr]
    [SAMPLE BY expr]
    [TTL expr [DELETE|TO DISK 'xxx'|to volume 'xxx'],...]
    [SETTINGS name=value,..]
    ```

  * ENGINE：引擎名和参数

  * ORDER BY：排序键，可以是一组列的元组或任意的表达式。**如果没有用PRIMARY KEY显式指定主键，clickhouse会使用排序键作为主键**，如果不需要tuple，可以使用ORDER BY tuple()

  * PARTITION BY：分区键，要按月分区，可以使用表达式toYYYYMM(date_column)，这里date_column是一个Date类型的列，分区的格式会是YYYYMM

  * PRIMARY KEY：主键，如果要选择与排序键不同的主键，可选。大部分时间不需要再专门指定一个primary key

  * SIMPLE BY：用于抽样表达式，如果要用抽样表达式，主键中必须包含这个表达式。如`SAMPLE BY intHash32(UserID) ORDER BY (CounterID, EventDate, intHash32(UserID))`

  * TTL：指定行存储的持续时间并定义数据片段在硬盘和卷上的移动逻辑的规则列表。

  * SETTINGS：控制MergeTree行为的额外参数

    * index_granularity：索引力度

* 数据存储
  * 表由按主键排序的数据片段组成。
  * 当数据被插入到表中时，会创建多个数据片段并按主键的字典排序。
  * 不同分区的数据会被分成不同的片段，clickhouse在后台合并数据片段以便更高效存储。合并机制不保证具有相同主键的行全部合并到同一个数据片中。
  * 数据片段以wide或compact格式存储。wide格式下，每一列都会在文件系统中存储为单独的文件，compact模式下所有列都存储在同一个文件下。
  * 每个数据片段被逻辑分割成颗粒。颗粒是进行数据查询时最小的不可分割数据集。每个颗粒都包含整数个行。
  
* 可以使用ORDER BY tuple()创建没有主键的表，这种情况下，clickhouse会根据数据插入的顺序存储。

* 对于select查询，如果where子句中有下面这些表达式，就可以使用索引
  * 包含一个与主键/分区键中的部分字段或全部字段相等或不等的表达式。
  * 主键/分区键 in (xxx,xxx,xxx) 或者 主键/分区键 like 'xxx'。
  * 基于主键/分区键的字段上的某些函数。
  * 基于主键/分区键的表达式的逻辑表达式。
  
* TTL

  * TTL表达式的计算结果必须是日期或日期时间类型的字段

[MergeTree](https://clickhouse.tech/docs/zh/engines/table-engines/mergetree-family/mergetree/)这一块越看越迷惑，之后再来接着看吧。
