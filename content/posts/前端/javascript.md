---
title: javascript
tags:
  - 前端
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

## if、switch和循环

### if

```javascript
//支持&&（与）、||（或）、!（非）
if (iceCreamVanOutside || houseStatus === 'on fire') {
  console.log('You should leave the house quickly.');
} else {
  console.log('Probably should just stay in then.');
}

//三元运算符
let greeting = ( isBirthday ) ? 'Happy birthday' : 'Good morning';
```

### switch

```javascript
function setWeather() {
  var choice = select.value;

  switch (choice) {
    case 'sunny':
      para.textContent = 'It is nice and sunny outside today. ';
      break;
    case 'rainy':
      para.textContent = 'Rain is falling outside; ';
      break;
    default:
      para.textContent = '';
  }
}
```

### 循环

#### for

```javascript
for (var i = 0; i < 10; i++) {
  console.log(i);
  if (i === 5) {
      break;
  }
}
```

#### while

```javascript
let i = 0;
while (i < 10) {
  console.log(i);
  i++;
}

i = 0;
do {
  console.log(i);
  i++;
} while (i < 10);
```

## 函数

* 方法是在对象内定义的函数。

```javascript
//定义函数
function myFunction(value) {
    alert(value);
    //return不是必须的
    return value;
}

//调用函数
myFunction('hello');

//匿名函数，也可以赋值一个有名字的函数
myButton.onclick = function() {
    alert('hello');
}

//可以将匿名函数给变量，但是不建议这么写
var myGreeting = function() {
    alert('hello');
}
```

## 事件

* 事件是在编程时系统内发生的动作或者发生的事情，比如说用户在网页上点击了一个按钮，一个网页停止加载，用户在某个元素上悬停光标。
* 部分事件：
  * onfocus/onblur：聚焦或者解除焦点。
  * onclick/ondbclick：点击或者双击
  * window.onkeypress/window.onkeydown/window.onkeyup：按钮被按下时发生改变。keypress指的是通俗意义的按下按钮（按下并松开），keydown和keyup指的是按键动作的一部分，分别指按下和松开，该事件只能添加到整个浏览器窗口的window对象中。
  * onmouseover/onmouseout：鼠标挪到元素上方，鼠标从元素挪开。
* 不建议直接在html中插入javascript代码；如`<button onclick="bgChange()">Press me</button>`。

### addEventListener和removeEventListener

* 这两个函数最低支持到IE9。

```javascript
const btn = document.querySelector('button');

function bgChange() {
  const rndCol = 'rgb(' + random(255) + ',' + random(255) + ',' + random(255) + ')';
  document.body.style.backgroundColor = rndCol;
}
//该函数接收两个参数，事件名称和回应事件的函数代码
btn.addEventListener('click', bgChange);
//移除事件
btn.removeEventListener('click', bgChange);

//addEventListener支持给同一个监听器注册多个处理器
myElement.addEventListener('click', functionA);
myElement.addEventListener('click', functionB);

//onclick不能实现这点，第二行会覆盖第一行
myElement.onclick = functionA;
myElement.onclick = functionB;
```

### 事件对象

* 有时候在事件处理函数的内部，可能会看到一个固定指定名称的参数，如`event`、`evt`或`e`。它被称为事件对象，他被自动传递给事件处理函数，以提供额外的功能和信息。事件对象的`target`属性时钟返回事件刚刚发生元素的应用。

### 阻止默认行为

* 在Web表单中，当点击提交按钮时，浏览器会自动将数据提交到指定服务器。很多时候我们不需要自动提交，可以使用onsubmit事件处理程序（提交会在表单上发起一个submit事件）。

```javascript
const form = document.querySelector('form');
const fname = document.getElementById('fname');
const lname = document.getElementById('lname');
const submit = document.getElementById('submit');

form.onsubmit = function(e) {
  if (fname.value === '' || lname.value === '') {
    //停止表单提交
    e.preventDefault();
    alert("字段不可为空！")
  }
}
```

### 事件冒泡（以onclick举例）

1. 当点击某个元素时，浏览器检查实际点击的元素是否在冒泡阶段中注册了一个`onclick`事件处理程序，如果是，则运行它。
2. 然后移动到他的下一个直接的祖先元素，并且检测是否注册了一个`onclick`事件处理程序，并做同样的事情，然后是下一个，等待，直到它到达&lt;html&gt;元素。

* 现代浏览器默认情况下所有事件都在冒泡阶段进行注册。

#### stopPropagation

* 当在事件对象上调用stopPropagation时，他只会让当前事件处理程序运行，事件不会在冒泡链上进一步扩大，因此不会向上冒泡。

```javascript
video.onclick = function(e) {
    e.stopPropagation();
    video.play();
}
```

### 事件捕捉

1. 浏览器首先检测最外层的`<html>`，是否在捕获阶段注册了一个onclick事件处理程序，如果是则运行它。
2. 然后，他移动到`<html>`中单击元素的下一个祖先元素，并执行相同的操作，然后是单击元素的再下一个祖先元素，以此类推，直到到达实际点击的元素。

## JavaScript对象

* 对象是一个包含属性和方法的集合。
* 一个对象由许多的成员组成，每一个成员都拥有一个名字和一个值，每一个名字/值被逗号分隔，并且名字和值之间由冒号分隔。
* 每个页面在加载完毕之后，会有一个Document的实例被创建，叫做document。
* 通过手动的写出对象的内容来创建一个对象，我们称之为对象的字面量。

```javascript
//创建对象
var person = {
  name : {
      first : 'Bob', 
      last : 'Smith'
  },
  age : 32,
  gender : 'male',
  interests : ['music', 'skiing'],
  bio : function() {
    alert(this.name[0] + ' ' + this.name[1] + ' is ' + this.age + ' years old. He likes ' + this.interests[0] + ' and ' + this.interests[1] + '.');
  },
  greeting: function() {
    //this指向了当前代码运行时的对象
    alert('Hi! I\'m ' + this.name[0] + '.');
  }
};

//调用对象的属性或方法
//点表示法
person.age;
person.name.first;
person.bio();
//括号表示法
person['age'];
person['name']['first'];

//设置对象成员
person.age = 45;
person['name']['last'] = 'xiao';
//添加新的对象属性
person['eyes'] = 'hazel';
person.farewell = function() {
    alert('Bye everyBody!');
}
```

### JavaScript层面的类

```javascript
//创建类
function Person(name) {
  this.name = name;
  this.greeting = function() {
    alert('Hi! I\'m ' + this.name + '.');
  };
}

//创建对象
let person1 = new Person('Bob');
let person2 = new Person('Sarah');

```

### 创建对象的其他方式

* 几乎所有的对象都是Object类型的实例，他们都会从Object.prototype继承属性和方法。

```javascript
//使用Object()构造函数可以创建一个空对象
var person3 = new Object();
//给空对象添加属性
person3.name = 'Chris';
//可以将对象文本传递给Object()构造函数作为参数
var person1 = new Object({
  name : 'Chris',
  age : 38,
  greeting : function() {
    alert('Hi! I\'m ' + this.name + '.');
  }
});

//JavaScript有个内嵌的方法create()，可以基于现有对象创建新的对象
//create实际做的是从指定原型对象创建一个新的对象
var person2 =Object.create(person1);
```

### 对象原型

* 每个对象都拥有一个原型对象，对象以其原型为模板，从原型继承方法和属性，原型对象也可能拥有原型，并从中继承方法和属性。一层一层、以此类推，这种关系常被称为原型链（prototype chain）。
* 在javascript中，函数可以有属性，每个函数都有一个特殊的属性叫做原型（prototype）。

```javascript
function doSomething(){}
//输出原型属性
console.log(doSomething.prototype);
//添加一些属性到doSomething的原型上面
doSomething.prototype.foo = 'bar';
//使用new运算符再现在的这个原型的基础上创建一个doSomething的实例
//doSomeInstancing的__proto__属性就是doSomething.prototype
var doSomeInstancing = new doSomething();
```

* 当访问doSomeInstancing的一个属性时，浏览器会首先查找doSomeInstancing是否有这个属性，如果doSomeInstancing没有这个属性，然后浏览器就会在doSomeInstancing的`__proto__`中找这个属性，如果还没有，就继续往上找，直到到window.Object.prototype。
* 原型链中的方法和属性没有被复制到其他对象，它们访问需要通过"原型链"的方式。
* 只有在`Object.prototype`中的属性会被继承。
* 当更新类的prototype时，原型链也会动态的更新。

#### constructor属性

* 每个对象都从原型中继承了一个constructor属性，该属性指向了用于构造此实例对象的构造函数。
* 获取某个对象实例的构造器的名字：`person1.constructor.name`。

### 继承

```javascript
function Teacher(first, last, age, gender, interests, subject) {
  Person.call(this, first, last, age, gender, interests);
  this.subject = subject;
}
```

**TO BE CONTINUED**

<!--more-->
