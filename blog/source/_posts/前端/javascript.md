---
title: javascript
categories:
  - [前端]
site: 前端
date: 2021-11-24 19:31:59
---

## 变量

- 变量不是数值本身，变量是一个用于存储数值的容器。

### let

- let声明的变量只在其声明的块或者子块中可用。
- let不会在全局对象里新建一个属性。
- let声明的变量没有初始值。在变量初始化前访问该变量会导致ReferenceError。
- 未初始化的变量会处在一个“暂存死区”中，如果使用typeof 检测暂存死区的变量，会抛出ReferenceError异常。

```
let l = 'global';
var v = 'global';
console.log(this.l); //undefined
console.log(this.v); //"global"
```

### var

- var用来声明一个变量，并可以将其初始化一个值。
- var声明的变量有默认的初始值undefined。
- 声明的变量无论发生在何处，都在执行代码前处理（变量提升）。所以在代码中任意位置声明的变量总等效于在代码开头声明，这意味着变量可以在声明之前使用。
- 声明的变量只能是全局或整个函数块的。
- 函数外的用var声明的变量会给全局对象新增属性。非声明的变量被赋值后，变量会被隐式的创建为全局变量（他将成为全局对象的属性）。
- 使用var可用根据需要多次声明相同名称的变量。
- 声明变量在它所在的上下文环境不可配置属性，非声明变量是可配置的（如非声明变量可以被删除）。

```
//属性
var a = 1;
b = 2;
delete this.a; //失败
delete this.b;//成功
//变量提升
bla = 2;
var bla;
```

https://developer.mozilla.org/zh-CN/docs/Learn/JavaScript/First_steps/Variables
