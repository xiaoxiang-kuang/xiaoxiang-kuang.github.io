---
title: html
tags:
  - 前端
date: 2021-03-02 20:22:15
---

## head

* `<meta>`:元数据就是描述数据的地方

  * `<meta charset="utf-8">`：指定文档中字符的编码。

  * 添加作者描述和该网页的描述，这些数据会被搜索引擎解析。
    ```html
    <meta name="author" content="xiaoxiang">
    <meta name="description" content="A learning notes,about java,git,etc"
    ```
    `<meta name="keywords" content="xxx">`：keywords关键字已不再使用了。因为该关键字是提供给搜索引擎，搜索引擎根据不同的关键字找到相关网站，但是有些网站填充了大量的关键字到keyword，错误的引导了搜索结果。
  
* `<link rel="shortcut icon"  href="favicon.ico">`：添加网页图标

* `<link rel="stylesheet"  href="index.css">`：添加样式表

* `<html lang="zh-CN">`：为站点设置语言，如果该项设置了，网站就会被搜索引擎更好的索引（如允许他在不同的语言中正确显示）。也可在在其他标签中设置该属性`<span lang="en">小象</span>`。

## body

* `<em>`：emphasis斜体显示。
* `<a href="mailto:example@example.com,exp@exp.com?cc=exp2@exp2.com&subject=hello&body=hi">向example和exp发邮件</a>`当点击一个链接或按钮时，打开一个新的电子邮件发送信息而不是连接到一个资源（邮件地址可为空，表示打开电子邮件）,cc表示抄送，subject表示主题，body表示主体，每个字段的值必须是URL编码的，即不能有非打印字符，中文要转意成%xx的形式。
* 列表
  * `<ol>`:ordered list
  * `<ul>`:unordered list
  * `<dl>`:description list
  * `<li>`:list item
  * `<dt>`:description term
  * `<dd>`definition description
* `<abbr>`:Abbreviation缩写    例：<span>我们使用<abbr title="超文本标记语言（Hyper text Markup Language）">HTML</abbr>来组织文档。</span>
* `<address>`：标记联系方式的元素。
* `<code> <pre> <var> <kbd> <samp>`：用于展示计算机代码。
* `<time datetime="2021-03-10">2021年3月10日</time>`：标记时间，可供机器识别格式。
* 一个block形式展现的块级元素不会被嵌套进内联元素中，但可以嵌套在其他块级元素中。

https://developer.mozilla.org/zh-CN/docs/Learn/HTML/Introduction_to_HTML/Document_and_website_structure
<!--more-->
