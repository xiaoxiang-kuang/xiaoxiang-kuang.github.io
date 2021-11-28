---
title: javascript
categories:
  - [前端]
site: 前端
date: 2021-11-24 19:31:59
---

## 变量

- 变量不是数值本身，变量是一个用于存储数值的容器。
- 变量不要以下划线开头。
- 变量的命名遵循小写驼峰命名法。

### let

- let声明的变量只在其声明的块或者子块中可用。
- let不会在全局对象里新建一个属性。
- let声明的变量没有初始值。在变量初始化前访问该变量会导致ReferenceError。
- 未初始化的变量会处在一个“暂存死区”中，如果使用typeof 检测暂存死区的变量，会抛出ReferenceError异常。

```javascript
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

```javascript
//属性
var a = 1;
b = 2;
delete this.a; //失败
delete this.b;//成功
//变量提升
bla = 2;
var bla;
```

### 变量类型

* js是动态类型语言，不需要指定变量将包含什么数据类型。

```javascript
//Number
let myAge = 17;
//String，给一个变量赋值为字符串时，需要用单引号和双引号包起来
let name = 'xiaoxiang';
let say = name + ', hello';
//Boolean
let isAlive = true;
let test =6 < 3
//Array
let names = ['xiaoxiang', 'xiaoming', 'jim'];
names[0]; //使用
//Object
let dog = {name : 'spot', age : 10};
dog.name; //使用
//检查变量的类型
typeof dog;
```

#### Number

```javascript
//幂，下面这个相当于5*5*5*5*5，es2016中引入
5 ** 5 
//结果是1.25
10 / 8 
//自增和自减
guessCount++;
guessCount--;
//其他 +=、-=、*=、/=
//严格等于，测试左右值是否相同
5 === 2 + 4
//测试左右值是否不相同
5 !== 2 + 4
//Number对象将任何传递给它的东西转换为一个数字
let myNum = Number('123');
//每个数字都有一个toString()的方法
let myString = myNum.toString();
```

#### String

```javascript
//可以使用length属性获取字符串的长度
let browserType = 'mozilla';
browserType.length;
//查看特定的字符
browserType[0];
//找到子串的位置，找不到会返回-1
browserType.indexOf('zilla'); //2
//根据位置提取子串
browserType.slice(0,3); //moz
//提取从某个位置后的剩余所有字符串
browserType.slice(2);
//转换大小写
browserType.toLowerCase();
browserType.toUppercase();
//将字符串的一个子串替换为另一个字符串
browserType = browserType.replace('moz', 'van');
```

#### Array

```javascript
//创建一个数组
let random = ['tree', 795, [0, 1, 2]];
//修改值
random[0]='xiaoxiang';
//使用多维数组
random[2][2];
//获取数组的长度
random.length;
//使用split方法将字符串转化为数组
let names = 'xiaoxiang, xiaoming, jim';
let myNames = names.split(',');
//使用join方法将数组转为字符串，或者使用tostring方法
let myNewNameString = myNames.join(',');
myNames.toString();
//数组末尾添加和删除元素
let myArray = ['Manchester', 'London'];
myArray.push('Cardiff');
myArray.push('Bradford', 'Brighton'); //会返回新数组的长度
myArray.pop(); //返回被删除的项目
//unshift和shift用来从数组的开始添加和删除元素
myArray.unshift('Edinburgh');
let removeItem = myArray.shift();
```



