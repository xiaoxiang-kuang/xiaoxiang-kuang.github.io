---
title: "Hugo模板"
date: 2022-01-03T17:09:17+08:00
draft: false
---

* hugo使用go的"html/template"和"text/template"库作为模板的基础。

* go模板是添加了变量和函数的html文件。他们都被包裹在`{{}}`中。
* 一个预定义的变量可以是已存在在当前的作用域中或者是一个自定义的变量。
* 多个函数的参数可以使用空格分开，类似与`{{ add 1 2 }}`（add函数接收1和2这两个参数）。
* 方法和函数可以通过`.`来访问访问。如获取在文章front matter中定义的bar`{{ .Params.bar }}`
* 圆括号可以用来将items组合在一起`{{ if or (isset .Params "alt") (isset .Params "caption") }} Caption {{ end }}`
* 原始字符可以包含换行。

## 变量

* 在hugo中，每个模板都有一个Page对象，.Title是Page的一个元素之一。当Page是模板的默认作用域时，title可以通过`.`直接来带哦用`{{.Title }}`。
* 自定义变量需要有`$`前缀。
* 变量可以存储在自定义变量中并在稍后被引用。

```go
{{ $address := "123 Main St."}}
{{ $address }}
```

* 变量可以使用`=`来重新定义。

```go
{{ $var := "Hugo Page" }}
{{ if .IsHome }}
    {{ $var = "Hogo Home" }}
{{ end }}
Var is {{ $var }}
```

## 函数

* go模板只提供了一些基本的函数，但也提供了扩展原始集的机制。
* 调用函数使用他们的名字跟上需要的参数，参数需要用空格隔开。

```go
{{ add 1 2 }}
<!--数字求和，输出3-->
{{ lt 1 2 }}
<!--比较大小，输出true-->
```

## includes

* 一个模板中包含另一个模板。
* hugo中的模板位置都是在`layouts/`目录开始。
* `partial`函数用来包含部分模板

```go
<!--包含layouts/partials/header.html-->
{{ partial "header.html" . }}
```

* `template`函数用来在老版本的hugo中包含模板和用来调用内部模板。

```go
{{ template "_indernal/opengraph.html" . }}
```

## logic

* 使用`range`来进行迭代。

```go
{{ range $array }}
    <!--.代表$aray的一个元素-->
    {{ . }}
{{ end }}


<!--将数组的元素的值赋值给变量-->
{{ range $elem_val := $array }}
    {{ $elem_val }}
{{ end }}

<!--将数组的元素的下标和值都复制给变量-->
{{ range $elem_index, $elem_val := $array }}
   {{ $elem_index }} -- {{ $elem_val }}
{{ end }}
```



<!--more-->
