---
title: "CSS Flex"
date: 2022-01-04T21:47:18+08:00
tags:
  - 前端
draft: false
---

## 弹性容器属性。

* 弹性盒子（Flex Box），能将当前页面适应不同的屏幕大小。
* 弹性盒子由弹性容器（Flex container）和弹性子元素（Flex item）组成。
* 弹性容器通过设置display属性的值为flex或inline-flex将其定义为弹性容器，弹性容器内包含了一个或多个弹性子元素。
* 弹性容器外及弹性子元素内是正常渲染的。弹性盒子只定义了弹性子元素如何在弹性容器内布局。
* 弹性子元素通常在弹性盒子内一行显示，默认每个容器只有一行。

### flex-direction

* flex-direction指定了弹性子元素在父容器中的位置。

```css
flex-direction: row | row-reverse | column | column-reverse
```

* flex-direction的值：
  * row：从左到右排列，默认。
  * row-reverse：从右到左排列。最后一项在最前面。
  * column：从上到下排列。
  * column-reverse：从下到上排列。最后一项在最上面。

### justify-content

* justify-content属性应用在弹性容器上，把弹性容器沿着弹性容器的主轴线对其。

``` css
justify-content: flex-start | flex-end | center | space-between | space-around
```

* justify-content值：
  * flex-start：从左边开始挨着填充，默认。
  * flex-end：从右边开始挨着填充。最后一项在最后边。
  * center： 所有弹性项目挨着居中。
  * space-between：弹性容器平均分布在该行上，如果剩余空间为负或者只有一个弹性项，则该值等于flex-start。否则第一个弹性子元素和行的起始位置对其，最后一个弹性子元素和行的结束位置对其，其他元素平均分布。
  * space-around：弹性容器平均分布在改行上，如果剩余空间为负或只有一个弹性元素，该值等于center。否则弹性子元素间彼此间隔相等（如20px），第一个和最后一个弹性子元素和容器之间有一半的间隔（10px）。

### align-items

* align-items用来设置弹性盒子在纵轴方向上的对齐方式。

```css
align-items: flex-start | flex-end | center | baseline | stretch
```

* align-items的值：
  * flex-start：弹性子元素的起始位置靠着该行的最上方。
  * flex-end：弹性子元素的起始位置靠着该行的最下方。
  * center：弹性盒子在该行水平方向的中心。如果该行的高度小于弹性子元素的尺寸，则会在两个方向上溢出相同的长度。
  * baseline：
  * stretch：使弹性子元素的高度和弹性容器的高度一致，该值也会受到margin、height等的影响。

### flex-wrap属性

* flex-wrap属性指定弹性盒子的子元素的换行方式。

```css
flex-wrap: nowrap | wrap | wrap-reverse | initial | inherit;
```

* flex-wrap的值：
  * nowrap：弹性容器为单行，默认。
  * wrap：弹性容器为多行，该情况下溢出的弹性子元素会被放到新行。
  * wrap-reverse：反转wrap排列。

### align-content

* align-content属性用来设置flex-wrap的行为，它设置各个行的对齐方式。

```css
align-content: flex-start | flex-end | center | space-between | space-around | stretch
```

* align-content的值：
  * stretch：默认，各行将会伸展以占用剩余的空间。
  * flex-start：各行向弹性容器的顶部对齐。
  * flex-end：各行向弹性容器的底部对齐。
  * center：各行向弹性容器的中间位置对齐。
  * space-between：各行在弹性容器中平均分布，上下两端不保留间距。如果只有一行，则等于flex-start。
  * space-around：各行在弹性容器中平均分布，容器上下两端保留子元素和子元素之间间距大小的一半。

## 弹性子元素属性

### 排序

* 用整数来设置子元素的排列顺序，数值小的排在前面，可以为负值。

```css
order: -1
```

### 对齐

* 设置margin的值为auto时，自动获取弹性容器中的**剩余空间**。

### align-self

* align-self属性用于设置弹性子元素在纵轴方向上的对齐方式。

```css
align-self: auto | flex-start | flex-end | center | baseline | stretch
```

* align-self的值：
  * auto：计算夫元素的align-items值，如果父元素没有此属性，则为stretch。
  * flex-start：弹性盒子靠住该行的顶部。
  * flex-end：弹性盒子靠住该行的底部。
  * center：弹性盒子在弹性容器中竖直居中。
  * baseline：
  * stretch：子元素的高度为容器的高度，但仍然受到height、margin等影响。

### flex

* flex指定弹性子元素如何分配空间。

```css
flex: 1
```

* flex的值：当有三个子元素，flex分别为2 1 1，则第一个分两份，后面两个分别分一份。

<!--more-->

