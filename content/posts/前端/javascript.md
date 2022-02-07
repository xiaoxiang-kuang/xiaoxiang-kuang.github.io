---
title: "Javascript"
date: 2022-01-31T08:20:15+08:00
tags:
  - 前端
draft: false
---

## 基本语法

* 变量如果只声明而没有赋值，则该变量的值是`undefined`。
* js是一种动态类型语言，变量的类型没有限制，变量可以随时更改类型。

* js引擎的工作方式是先解析代码，获取所有被声明的变量，然后再一行行的运行，这会使得所有变量的声明语句，都会被提升到代码的头部。
* 变量命名规则如下：第一个字符可以是任意Unicode字母以及`$`和`_`，第二个字符及后面的字符还可以用数字0-9。

### if...else

```javascript
if (m === 3) {
  // 满足条件时，执行的语句
} else {
  // 不满足条件时，执行的语句
}
```

### switch

* `switch`语句后面的表达式，与`case`语句后面的表示式比较运行结果时，采用的是严格相等运算符（`===`），这意味着比较时不会发生类型转换。

```javascript
switch (x) {
  case 1:
    console.log('x 等于1');
    break;
  case 2:
    console.log('x 等于2');
    break;
  default:
    console.log('x 等于其他值');
}
```

### 三元运算符

```javascript
(条件) ? 表达式1 : 表达式2
```

### 循环语句

#### while

```javascript
var i = 0;

while (i < 100) {
  console.log('i 当前为：' + i);
  i = i + 1;
}
```

#### for

```javascript
var x = 3;
for (var i = 0; i < x; i++) {
  console.log(i);
}
```

#### do...while

```javascript
var x = 3;
var i = 0;

do {
  console.log(i);
  i++;
} while(i < x);
```

### break和continue

```javascript
for (var i = 0; i < 5; i++) {
  console.log(i);
  if (i === 3)
    break;
}

var i = 0;

while (i < 100){
  i++;
  if (i % 2 === 0) {
      continue;
  }
  console.log('i 当前为：' + i);
}
```

## 数据类型

### 六种数据类型

- 数值（number）：整数和小数（比如`1`和`3.14`）。
- 字符串（string）：文本（比如`Hello World`）。
- 布尔值（boolean）：表示真伪的两个特殊值，即`true`（真）和`false`（假）。
- `undefined`：表示“未定义”或不存在，即由于目前没有定义，所以此处暂时没有任何值。
- `null`：表示空值，即此处的值为空。
- 对象（object）：各种值组成的集合。

### typeof运算符

`typeof`运算符可以返回一个值的数据类型。

数值、字符串、布尔值分别返回`number`、`string`、`boolean`。

```javascript
typeof 123 // "number"
typeof '123' // "string"
typeof false // "boolean"
```

函数返回`function`。

```javascript
function f() {}
typeof f
```

`undefined`返回`undefined`。

```javascript
typeof undefined
// "undefined"
```

`typeof`可以用来检查一个没有声明的变量，而不报错。

```javascript
typeof v
// "undefined"
```

对象返回`object`。

```javascript
typeof window // "object"
```

`null`返回`object`。

```javascript
typeof null
```

空数组（`[]`）的类型也是`object`，在 JavaScript 内部，数组本质上只是一种特殊的对象。

### null、undefined和布尔值

* null是一个表示“空”的对象，转为数值时为0；undefined是一个表示"此处无定义"的原始值，转为数值时为NaN。

* `undefined`表示“未定义”。

### 布尔值

下面的值都会被转为`false`。

- `undefined`
- `null`
- `false`
- `0`
- `NaN`
- `""`或`''`（空字符串）

空数组（`[]`）和空对象（`{}`）对应的布尔值，都是`true`。

## 数值

### 整数和浮点数

JavaScript 内部，所有数字都是以64位浮点数形式储存，即使整数也是如此。所以，`1`与`1.0`是相同的，是同一个数。

### 数值的表示方法

JavaScript 的数值有多种表示方法，默认情况下，JavaScript 内部会自动将八进制、十六进制、二进制转为十进制。

- 十进制：没有前导0的数值。
- 八进制：有前缀`0o`或`0O`的数值，或者有前导0、且只用到0-7的八个阿拉伯数字的数值。
- 十六进制：有前缀`0x`或`0X`的数值。
- 二进制：有前缀`0b`或`0B`的数值。

```javascript
0xff // 255
0o377 // 255
0b11 // 3
```

数值也可以采用科学计数法表示，下面是几个科学计数法的例子。

```javascript
123e3 // 123000
123e-3 // 0.123
-3.1E+12
.1e-23
```

### NaN

`NaN`是 JavaScript 的特殊值，表示“非数字”（Not a Number），主要出现在将字符串解析成数字出错的场合。

```
5 - 'x' // NaN
```

`NaN`不是独立的数据类型，而是一个特殊数值，它的数据类型依然属于`Number`，使用`typeof`运算符可以看得很清楚。

`NaN`不等于任何值，包括它本身。

```javascript
NaN === NaN // false
```

### Infinity

Infinity表示“无穷”，用来表示两种场景。一种是一个正的数值太大，或一个负的数值太小，无法表示；另一种是非0数值除以0，得到Infinity。

`Infinity`有正负之分，`Infinity`表示正的无穷，`-Infinity`表示负的无穷。

`Infinity`大于一切数值（除了`NaN`），`-Infinity`小于一切数值（除了`NaN`）。

`Infinity`的四则运算，符合无穷的数学计算规则。

```javascript
5 * Infinity // Infinity
5 - Infinity // -Infinity
Infinity / 5 // Infinity
5 / Infinity // 0
```

### 相关函数

#### parseInt

`parseInt`方法用于将字符串转为整数。

```javascript
parseInt('123') // 123
```

如果字符串头部有空格，空格会被自动去除。

```javascript
parseInt('   81') // 81
```

如果`parseInt`的参数不是字符串，则会先转为字符串再转换。

```javascript
parseInt(1.23) // 1
// 等同于
parseInt('1.23') // 1
```

字符串转为整数的时候，是一个个字符依次转换，如果遇到不能转为数字的字符，就不再进行下去，返回已经转好的部分。

```javascript
parseInt('8a') // 8
parseInt('12**') // 12
parseInt('12.34') // 12
parseInt('15e2') // 15
parseInt('15px') // 15
```

如果字符串的第一个字符不能转化为数字（后面跟着数字的正负号除外），返回`NaN`。

```javascript
parseInt('abc') // NaN
parseInt('+1') // 1
```

对于那些会自动转为科学计数法的数字，`parseInt`会将科学计数法的表示方法视为字符串，因此导致一些奇怪的结果。

```javascript
parseInt(1000000000000000000000.5) // 1
// 等同于
parseInt('1e+21') // 1
```

#### parseFloat

`parseFloat`方法用于将一个字符串转为浮点数。

```javascript
parseFloat('3.14') // 3.14
```

如果字符串符合科学计数法，则会进行相应的转换。

```javascript
parseFloat('314e-2') // 3.14
parseFloat('0.0314E+2') // 3.14
```

如果字符串包含不能转为浮点数的字符，则不再进行往后转换，返回已经转好的部分。

```javascript
parseFloat('3.14more non-digit characters') // 3.14
```

`parseFloat`方法会自动过滤字符串前导的空格。

```
parseFloat('\t\v\r12.34\n ') // 12.34
```

如果参数不是字符串，或者字符串的第一个字符不能转化为浮点数，则返回`NaN`。

```javascript
parseFloat([]) // NaN
parseFloat('') // NaN
```

#### isNaN

`isNaN`方法可以用来判断一个值是否为`NaN`。

```
isNaN(NaN) // true
isNaN(123) // false
```

但是，`isNaN`只对数值有效，如果传入其他值，会被先转成数值。比如，传入字符串的时候，字符串会被先转成`NaN`，所以最后返回`true`，`isNaN`为`true`的值，有可能不是`NaN`，而是一个字符串。

判断`NaN`更可靠的方法是，利用`NaN`为唯一不等于自身的值的这个特点，进行判断。

```javascript
function myIsNaN(value) {
  return value !== value;
}
```

#### isFinite

`isFinite`方法返回一个布尔值，表示某个值是否为正常的数值。

```javascript
isFinite(Infinity) // false
isFinite(-Infinity) // false
isFinite(NaN) // false
isFinite(undefined) // false
isFinite(null) // true
isFinite(-1) // true
```

## 字符串

字符串就是零个或多个排在一起的字符，放在单引号或双引号之中。

字符串可以被视为字符数组，因此可以使用数组的方括号运算符，用来返回某个位置的字符（位置编号从0开始）。但无法改变字符串之中的单个字符。

```javascript
var s = 'hello';
s[0] // "h"
```

### length

`length`属性返回字符串的长度。

```javascript
var s = 'hello';
s.length // 5
```

## 对象

对象就是一组“键值对”（key-value）的集合，是一种无序的复合数据集合。

```javascript
var obj = {
  foo: 'Hello',
  bar: 'World'
};
```

对象的所有键都是字符串，所以加不加引号都可以。

```javascript
var obj = {
  'foo': 'Hello',
  'bar': 'World'
};
```

对象的每一个键又称为“属性”（property），它的“键值”可以是任何数据类型。如果一个属性的值为函数，通常把这个属性称为“方法”，它可以像函数那样调用。

```javascript
var obj = {
  p: function (x) {
    return 2 * x;
  }
};

obj.p(1) // 2
```

属性可以动态创建，不必在对象声明时就指定。

```javascript
var obj = {};
obj.foo = 123;
obj.foo // 123
```

### 对象引用

如果不同的变量名指向同一个对象，那么它们都是这个对象的引用，也就是说指向同一个内存地址。修改其中一个变量，会影响到其他所有变量。

### 对象属性

读取对象的属性，有两种方法，一种是使用点运算符，还有一种是使用方括号运算符。

```javascript
var obj = {
  p: 'Hello World'
};

obj.p // "Hello World"
//如果使用方括号运算符，键名必须放在引号里面
obj['p'] // "Hello World"
```

点运算符和方括号运算符，不仅可以用来读取值，还可以用来赋值。

```javascript
var obj = {};

obj.foo = 'Hello';
obj['bar'] = 'World';
```

### 属性的查看

查看一个对象本身的所有属性，可以使用`Object.keys`方法。

```javascript
var obj = {
  key1: 1,
  key2: 2
};

Object.keys(obj);
```

### 属性的删除

`delete`命令用于删除对象的属性，删除成功后返回`true`。

删除一个不存在的属性，`delete`不报错，而且返回`true`。

```javascript
var obj = { p: 1 };
Object.keys(obj) // ["p"]

delete obj.p // true
```

### 属性是否存在：in 运算符

`in`运算符用于检查对象是否包含某个属性。

```javascript
var obj = { p: 1 };
'p' in obj // true
'toString' in obj // true
```

### 属性的遍历：for...in 循环

`for...in`循环用来遍历一个对象的全部属性。

```javascript
var obj = {a: 1, b: 2, c: 3};

for (var i in obj) {
  console.log('键名：', i);
  console.log('键值：', obj[i]);
}
```

`for...in`循环有两个使用注意点。

- 它遍历的是对象所有可遍历（enumerable）的属性，会跳过不可遍历的属性。
- 它不仅遍历对象自身的属性，还遍历继承的属性。

## 函数

### function 

`function`命令声明的代码区块，就是一个函数。`function`命令后面是函数名，函数名后面是一对圆括号，里面是传入函数的参数。函数体放在大括号里面。

```javascript
function print(s) {
  console.log(s);
}
```

### 函数表达式

除了用`function`命令声明函数，还可以采用变量赋值的写法。

```
var print = function(s) {
  console.log(s);
};
```

### name属性

函数的`name`属性返回函数的名字。

```javascript
function f1() {}
f1.name // "f1"
```

## 数组

```javascript
var arr = ['a', 'b', 'c'];

//除了在定义时赋值，数组也可以先定义后赋值。
//任何类型的数据，都可以放入数组。
var arr = [];
arr[0] = 'a';
arr[1] = [1, 2, 3];
arr[2] = {a: 1};
```

数组属于一种特殊的对象。`typeof`运算符会返回数组的类型是`object`。

`Object.keys`方法返回数组的所有键名。可以看到数组的键名就是整数0、1、2。

JavaScript 语言规定，对象的键名一律为字符串，所以，数组的键名其实也是字符串。

### length 属性   

数组的`length`属性，返回数组的成员数量。

```javascript
['a', 'b', 'c'].length // 3
```

### for...in 循环

```javascript
var a = [1, 2, 3];

for (var i in a) {
  console.log(a[i]);
}
```

<!--more-->
