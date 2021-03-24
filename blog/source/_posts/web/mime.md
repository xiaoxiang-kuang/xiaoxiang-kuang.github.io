---
title: mime
categories:
  - [web,http]
site: web
date: 2021-02-19 16:47:06
---

* MIME：multipurpose internet mail extensions媒体类型
* 浏览器通常使用mime类型来确定如何处理url

## 语法

### 通用结构

```html
#大小写不敏感
type/subtype
```

### 类型

```html
#text表明是普通文本
text/html 
text/css
text/xml
#image表示是某种图像（包括动态图片）
image/jpeg
image/png
#applicaiton表示是某种二进制数据
application/pdf
application/json
text/javascript
#audio表示是某种音频文件
#video表示是某种视频文件
#multipart表示细分领域的文件类型的种类
#...
```

### 部分MIME类型介绍

* `application/octet-stream`：这是应用程序的默认值，意思是未知的应用程序文件。
* `text/plain`文本的默认值
* `text/css`：网页中要被解析为css的任何css文件必须指定MIME为`text/css`。

参考链接：[MIME类型](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Basics_of_HTTP/MIME_Types) | [常见MIME类型列表](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types)