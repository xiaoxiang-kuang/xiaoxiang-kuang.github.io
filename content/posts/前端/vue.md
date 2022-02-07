---
title: vue
tags:
  - 前端
date: 2021-12-11 22:10:12
draft: false
---

* 每个vue应用都是通过`createApp`函数创建一个新的应用实例开始的。

## 模板语法和指令

* Vue.js 使用了基于 HTML 的模板语法，允许开发者声明式地将 DOM 绑定至底层组件实例的数据。

### 插值{{ msg }}

* `{{msg}}`会被替代为对应组件实例中 `msg` 的值。当绑定的组件实例上 `msg`  发生了改变，插值处的内容都会更新。

```html
<span>{{ msg }}</span>
```

* 通过使用 v-once 指令，也能执行一次性地插值，当数据改变时，插值处的内容不会更新。

```html
<span v-once>{{ msg }}</span>
```

### v-html

* 双大括号会将数据解释为普通文本，为了输出真正的 HTML，需要使用`v-html` 指令。

```html
<div id="example1">
    <p>{{ rawHtml }}</p>
    <span v-html="rawHtml"></span>
</div>

<script>
const RenderHtmlApp = {
  data() {
    return {
      rawHtml: '<span style="color: red">This should be red.</span>'
    }
  }
}
Vue.createApp(RenderHtmlApp).mount('#example1')
</script>
```

### v-bind

*  `v-bind`可以动态的设置标签的属性。

```html
<div v-bind:id="dynamicId"></div>
<!--等同于-->
<div :id="dynamicId"></div>
```

* 如果绑定的值是 `null` 或 `undefined`，那么该 attribute 将不会被包含在渲染的元素上。

#### 动态参数

```javascript
<a v-bind:[attributeName]="url"> ... </a>
```

* 这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值。如果组件实例有一个 data property `attributeName`，其值为 `"href"`，那么这个绑定将等价于 `v-bind:href`。
* 动态参数预期会求出一个字符串，`null` 例外, `null` 值可以用于显式地移除绑定。任何其它非字符串类型的值都将会触发一个警告。
* 需要避免使用大写字符来命名键名，因为浏览器会把 attribute 名全部强制转为小写。

###  JavaScript 表达式

* Vue.js 提供了完全的 JavaScript 表达式支持。

```html
{{ number + 1 }}
{{ ok ? 'YES' : 'NO' }}
{{ message.split('').reverse().join('') }}
<div v-bind:id="'list-' + id"></div>
```

### v-on

*  `v-on` 指令，它用于监听 DOM 事件。
*  修饰符 (modifier) 是以 `.` 指明的特殊后缀，用于指出一个指令应该以特殊方式绑定。`.prevent` 修饰符告诉 `v-on` 指令对于触发的事件调用 `event.preventDefault()`。

```html
<a v-on:click="doSomething"> ... </a>
<!--等同于-->
<a @click="doSomething"> ... </a>

<form v-on:submit.prevent="onSubmit">...</form>

<!-- 只有在key是Enter时调用submit()方法-->
<input @keyup.enter="submit" />
```

### v-if

* 可以配合`v-else`、`v-else-if`使用。
* `v-if`是真正的条件渲染，在切换的过程中，子组件会被销毁和重建。
* 不推荐v-if和v-for一起使用。v-if比v-for有更高的优先级。

```html
<!--条件为真时才被渲染-->
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>

```

### v-show

* 只是修改元素的display为none。

```html
<h1 v-show="ok">Hello!</h1>
```

### v-for

* 用来遍历数组和对象

```html
<!--遍历数组-->
<ul id="array-rendering">
  <li v-for="item in items">
     <!--items: [{ message: 'Foo' }, { message: 'Bar' }]-->
    {{ item.message }}
  </li>
</ul>

<!--遍历对象-->
<li v-for="(value, name) in myObject">
  {{ name }}: {{ value }}
</li>

<!--把模板重复10次数-->
<div id="range" class="demo">
  <span v-for="n in 10" :key="n">{{ n }} </span>
</div>
```

### v-model

* v-model 指令在表单 `<input>`、`<textarea>` 及 `<select>` 元素上创建双向数据绑定。
* `v-model` 会忽略表单元素的 `value`、`checked`、`selected` 属性的初始值，可以在data中声明初始值。
* 多个复选框可以绑定到一个数组上。
* 自动过滤用户输入的首尾空白字符，可以给v-model添加`trim`。`<input v-model.trim="msg" />`。

## data属性

* 组件的 `data` 选项是一个函数，Vue 会在创建新组件实例的过程中调用此函数。它应该返回一个对象，然后 Vue 会通过响应性系统将其包裹起来，并以 `$data` 的形式存储在组件实例中。为了方便，该对象的任何顶级 property 也会直接通过组件实例暴露出来。

```js
const app = Vue.createApp({
  data() {
    return { count: 4 }
  }
})

const vm = app.mount('#app')

console.log(vm.$data.count) // => 4
console.log(vm.count)       // => 4

// 修改 vm.count 的值也会更新 $data.count
vm.count = 5
vm.$data.count = 6
```

* 这些实例 property 仅在实例首次创建时被添加，所以你需要确保它们都在 `data` 函数返回的对象中。必要时，要对尚未提供所需值的 property 使用 `null`、`undefined` 或其他占位的值。

## methods

* 用 `methods` 选项向组件实例添加方法。

```js
const app = Vue.createApp({
  data() {
    return { count: 4 }
  },
  methods: {
    increment() {
      // `this` 指向该组件实例
      this.count++
    }
  }
})

const vm = app.mount('#app')
console.log(vm.count) // => 4
vm.increment()
console.log(vm.count) // => 5
```

* 在定义 `methods` 时应避免使用箭头函数，因为这会阻止 Vue 绑定恰当的 `this` 指向。
* 这些 `methods` 和组件实例的其它所有 property 一样可以在组件的模板中被访问。在模板中，它们通常被当做事件监听使用。

```html
<!--点击 <button> 时，会调用 increment 方法。-->
<button @click="increment">Up vote</button>
```

## class和style的绑定

### class

```javascript
<!--isActive为true或false决定了是否应用此样式-->
<div :class="{ active: isActive }"></div>

<!--class可以和:class共存，:class中可以添加多个字段-->
<div class="static" :class="{ active: isActive, 'text-danger': hasError }"></div>

<!--绑定的数据对象可以在data中定义-->
<div :class="classObject"></div>
data() {
  return {
    classObject: {
      active: true,
      'text-danger': false
    }
  }
}

<!--可以传递一个数组-->
<div :class="[{ active: isActive }, errorClass]"></div>
data() {
  return {
    isActive: true
    errorClass: 'text-danger'
  }
}


```

### style

```html
<div :style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
data() {
  return {
    activeColor: 'red',
    fontSize: 30
  }
}

<!--直接绑定一个样式对象-->
<div :style="styleObject"></div>
data() {
  return {
    styleObject: {
      color: 'red',
      fontSize: '13px'
    }
  }
}

<!--将多个样式对象以数组的形式应用到一个元素上-->
<div :style="[baseStyles, overridingStyles]"></div>
```

<!--more-->
