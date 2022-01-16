---
title: "Elasticsearch起步"
date: 2022-01-15T23:17:33+08:00
tags:
  - javaee
draft: false
---

* es是面向文档型数据库，一条数据在这里就是一条文档。

## 索引

* 创建索引`PUT http://ip:9200/索引名称`。
* 获取索引的相关信息`GET http://ip:9200/索引名称`。
* 获取所有的索引`GET http://ip:9200/_cat/indices?v`。
* 删除索引`DELETE http://ip:9200/索引名称`。

## 文档

### 添加文档

```
POST /索引名称/_doc
{
    "title": "xiaoxiang",
    "url": "xiaoxiang.space"
}

PUT /索引名称/_doc/id
{
    "title": "xiaoxiang",
    "url": "xiaoxiang.space"
}
```

### 查询数据

```
//查询一条数据
GET /索引名称/_doc/id

//全部查询
GET /索引名称/_search?pretty
```

### 修改数据

```
//全量更新
PUT /索引名称/_doc/id
{
    "title": "xiaoxiang",
    "url": "xiaoxiang.space"
}

//局部更新
POST /索引名称/_update/id
{
    "doc": {
        "title": "xiaoxiangmax"
    }
}
```

### 删除数据

```
DELETE /索引名称/_doc/id
```

## 文档复杂查询

### 添加查询条件

```
//增加条件查询
GET /索引名称/_search
{
    "query": {
        "match": {
            "category": "xiaoxiang"
        }
    }
}

//不拆解搜索字段
GET /gw_audit-*/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "user_name": "zhao fei"
          }
        }
      ]
    }
  }
}
```
### 添加高亮显示

```
//对某个条件添加高亮显示
GET /gw_audit-*/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match_phrase": {
            "user_name": "kpf"
          }
        }
      ]
    }
  },
  "highlight": {
    "fields": {
      "user_name": {}
    }
  }
}

```

### 多条件查询

```
//多条件查询，(相当于and)
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "category": "xiaoxiang"
          }
        },
        {
          "match": {
            "price": "5999"
          }
        }
      ]
    }
  }
}

//多条件查询，一个字段多个查询的值(相当于or)
GET /gw_audit-*/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "user_name": "kpf"
          }
        },
        {
          "match": {
            "user_name": "zj"
          }
        }
      ]
    }
  },
  "size": 20000
}
```

### 区间查询

```
#区间查询
GET /gw_audit-*/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "spent": {
              "gte": 10,
              "lte": 200
            }
          }
        }
      ]
    }
  }
}
```

### 分页查询

```
//全量分页查询
GET /gw_audit-*/_search
{
	"query": {
		"match_all": {
		
		}
	},
	"from": 0,
	"size": 10
}
```

### 只查询指定字段

```
//只查询指定字段
GET /索引名称/_search
{
	"query": {
		"match_all": {
		
		}
	},
	"from": 0,
	"size": 10,
	"_source": ["title"]
}
```

### 对结果排序

```
//对结果排序
GET /索引名称/_search
{
	"query": {
		"match_all": {
		
		}
	},
	"from": 0,
	"size": 10,
	"sort": {
		"price": {
			"order": "desc"
		}
	}
}
```

### 聚合操作，求每组的数量

```
#对查询结果进行聚合操作，统计每一组的数量
GET /gw_audit-*/_search
{
  "aggs": {
    "user_name_group": {
      "terms": {
        "field": "user_name"
      }
    }
  },
  "size": 0
}
```

### 聚合操作，统计平均值

```
#对查询结果进行聚合操作，统计平均值
GET /gw_audit-*/_search
{
  "aggs": {
    "user_name_avg": {
      "avg": {
        "field": "spent"
      }
    }
  },
  "size": 0
}
```

### 设置映射关系

```
//设置映射关系
PUT test/_mapping
{
  "properties": {
    "name": {
      "type": "text", 
      "index": true
    },
    "sex": {
      "type": "keyword", //关键字不会被分开
      "index": "true"
    },
    "tel": {
      "type": "keyword",
      "index": false
    }
  }
}
```



<!--more-->
