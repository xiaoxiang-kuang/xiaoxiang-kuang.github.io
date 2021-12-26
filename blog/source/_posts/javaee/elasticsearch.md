---
title: elasticsearch
categories:
  - [javaee]
site: javaee
date: 2021-12-19 16:15:03
---

``` sh
#启动elasticsearch
./bin/elasticsearch
#测试elasticsearch是否启动运行
curl -X GET http://localhost:9200
```

* 基本rest命令说明

| method | url地址                                  | 描述                  |
| ------ | ---------------------------------------- | --------------------- |
| GET    | ip:9200/索引名称/类型名称/文档id         | 通过文档id查询文档    |
| POST   | IP:9200/索引名称/类型名称/文档ID/_search | 查询所有数据          |
| POST   | IP:9200/索引名称/类型名称                | 创建文档（随机文档ID) |
| POST   | IP:9200/索引名称/类型名称/文档ID/_update | 修改文档              |
| PUT    | IP:9200/索引名称/类型名称/文档ID         | 创建文档（指定文档ID) |
| DELETE | IP:9200/索引名称/类型名称/文档ID         | 删除文档              |



```sh
#如果customer索引不存在会自动创建该索引，
#添加一个ID为1的document
PUT /customer/_doc/1
{
  "name": "John Doe"
}

#获取ID为1的document
GET /customer/_doc/1

#获取索引的文档，默认情况下hits包含最近的10个文档
GET /customer/_search?pretty


#按照account_number升序排序来检索bank中的所有documents，默认只包含10个文档
GET /bank/_search
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
#结果介绍
#took es查询花了多少毫秒
#timed_out 是否超时
#_shards 多少shards被搜索到，对shards的分析
#hits.total.value 找到了多少匹配的文档
#hits.sort 文档搜索位置
#hits._score

#获取从第十个10到19的结果
GET /bank/_search
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ],
  "from": 10,
  "size": 10
}

#搜索特定的字段，
#下面是搜索address字段中包含mill或者lane的结果
GET /bank/_search
{
  "query": { "match": { "address": "mill lane" } }
}

#搜索字段address中包含mill lane的结果（搜索字段未拆分）
GET /bank/_search
{
  "query": { "match_phrase": { "address": "mill lane" } }
}

#使用bool来组合更多的查询条件
#must表示必须匹配，must_not表示必须不匹配
#must_not被视为filter，它影响结果，但是不影响文档的score
#下面是匹配bank中age为40但是state不是ID的结果
GET /bank/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}

#使用一个range过滤器，获取账户余额在2000到3000之间的结果
GET /bank/_search
{
  "query": {
    "bool": {
      "must": { "match_all": {} },
      "filter": {
        "range": {
          "balance": {
            "gte": 20000,
            "lte": 30000
          }
        }
      }
    }
  }
}
```

参考链接： [Start searching | Elasticsearch Guide 7.9 | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/7.9/getting-started-search.html)

