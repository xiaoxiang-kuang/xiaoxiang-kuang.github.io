---
title: "CSS Flex"
date: 2022-01-04T21:47:18+08:00
tags:
  - 前端
draft: false
---

## flexbox的轴线

* 使用flex布局时，flex有两根轴线：主轴和交叉轴，主轴由flex-direction定义，另一根轴垂直于它。

### 主轴

* 主轴由flex-direction定义，有四个值：
  * row
  * row-reverse
  * column
  * column-reverse
* 当选择了row或者row-reverse，主轴将沿着水平方向延伸。

![](/img/前端/css-flex/1.png)

* 当选择了column或者column-reverse，主轴就会沿着上下方向延伸。

![](/img/前端/css-flex/2.png)

### 交叉轴

* 交叉轴始终垂直于主轴。

### 起始线和终止线

* 如果flex-direction是row，那么主轴的起始线是左边，终止线是右边。

![](/img/前端/css-flex/3.png)

## flex容器

* 采用了flexbox的区域就叫做flex容器，通过将一个标签的display属性改为`flex`或`inline-flex`来创建一个flex容器，这样容器内的直系子元素就会变成flex元素。所有的css属性都会有一个初始行为（假设元素未设置width、height、margin等属性）：
  * 元素排列成一行（flex-direction属性的初始值为row）。
  * 元素从主轴线的起始线开始。
  * 元素不会在主轴方向不会被拉伸，但可能会缩小。
  * 元素会被拉伸来填充交叉轴的大小。
  * flex-basis的属性为auto。
  * flex-wrap属性为nowrap。

### flex-wrap实现多行flex容器

* 当项目太大而无法全部显示在一行中，添加`flex-wrap:wrap`，项目就会换行显示。这样每一行都相当于是一个新的flex容器，在该行上发生的空间分布不会影响其他行。
* 当`flew-wrap`设置为`unwrap`，所有的flex元素都不会换行，它们将缩小以适配容器。如果项目的子元素无法缩小，使用`nowrap`会导致溢出。

### flex-flow

* `flex-direction`和`flex-wrap`可以组合简写为属性`flex-flow`第一个值为`flex-direction`，第二个值为`flex-wrap`。如`flex-flow: row wrap`。

### align-items

* `align-items`设置元素在交叉轴方向上对齐，默认值为`stretch`。
* 相应的值：
  * `stretch`  拉伸以贴到交叉轴的起始线和终止线。
  * `flex-start` 贴着交叉轴的起始线。
  * `flex-end` 贴着交叉轴的终止线。
  * `center` 交叉轴方向上居中。
  * `baseline` 

图中`flex-direction: row`。

![](/img/前端/css-flex/4.png)

### justify-content

* `justify-content`属性用来使元素在主轴方向上对齐，默认值是`flex-start`。
* 相应的值：
  * `stretch` 
  * `flex-start` 沿着主轴的起始线对齐。
  * `flex-end` 沿着主轴的终止线对齐。
  * `center` 主轴方向上居中
  * `space-around` 使每个元素的左右空间相等，第一个和最后一个元素距离起始线和终止线的距离是其他元素间隔的1/2。 
  * `space-between` 使每个元素的左右空间相等，第一个和最后一个元素贴上起始线和终止线。

图中`flex-direction: row`。

![](/img/前端/css-flex/5.png)

## flex元素

* flex容器里除了元素所占的空间以外的空间就是**可用空间**。

### flex-basis

* flex-basis定义了该元素的空间大小，该属性的默认值是元素内容的尺寸（auto）。

### flex-grow

* 处理flex元素在主轴上增加空间的问题。

* 该值被设定为一个正数时，flex会以flex-basis为基础，按照比例沿着主轴方向扩展尺寸。
* 当给flex中所有的元素设定flex-grow为1时，容器中的可用空间会被这些元素平分，他们会延展以填充主轴方向上的空间。

### flex-shrink

* 处理flex元素在主轴上收缩的问题。
* 如果容器中没有足够排列flex元素的空间，就可以设置flex-shrink属性为正整数来缩小它占用的空间到flex-shrink以下。
* 给flex-shrink属性更大的数值可以比赋值小数值的同级元素收缩程度更大。

### flex属性的简写

* `flex-grow、flex-shrink、flex-basis`可以简写为flex，顺序也是`flex-grow、flex-shrink、flex-basis`。
* `flex`有预定义的简写形式：
  * `flex:initial` 相当于`flex: 0 1 auto` ，`flex-grow`的值为0，所以flex元素不会超过他们的`flex-basis`尺寸，`flex-shrink`为1，可以缩小flex元素来防止他们溢出。
  * `flex: auto` 相当于`flex: 1 1 auto`，和上面的`flex: initial`基本相同，但是flex元素在需要的时候既可以拉伸也可以伸缩。
  * `flex: none` 相当于`flex: 0 0 auto`，元素既不能拉伸也不能收缩。
  * `flex: 1`或`flex: 2` 相当于`flex: 1 1 0`。

### align-self

* `align-self`设置元素在交叉轴方向上的排列方式，会覆盖已有的`align-items`元素。
* 值：
  * `auto`设置为父元素的`align-items`的值
  * `stretch` 拉伸贴上交叉轴的起始线和终止线。
  * `center` 交叉轴方向上居中。
  * `flex-start` 贴上交叉轴起始线。
  * `flex-end`  贴上交叉轴终止线。

参考链接：[flex 布局的基本概念 - CSS（层叠样式表） | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox)

参考链接：[Flex 布局教程：语法篇 - 阮一峰的网络日志 (ruanyifeng.com)](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html?utm_source=tuicool)

<!--more-->

