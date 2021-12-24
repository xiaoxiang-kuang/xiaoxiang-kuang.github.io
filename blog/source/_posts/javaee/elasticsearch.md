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
#获取索引所有的文档，默认情况下hits包含最近的10个文档
GET 索引名称/_search
```

