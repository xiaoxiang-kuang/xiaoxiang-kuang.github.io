---
title: vue
tags:
  - 前端
date: 2021-12-11 22:10:12
draft: true
---

* 每个vue应用都是通过`createApp`函数创建一个新的应用实例开始的。

# 模板语法

* Vue.js 使用了基于 HTML 的模板语法，允许开发者声明式地将 DOM 绑定至底层组件实例的数据。

## 插值

### 文本

* 数据绑定最常见的形式就是使用“Mustache” (双大括号) 语法的文本插值，Mustache 标签将会被替代为对应组件实例中 `msg` property 的值。无论何时，绑定的组件实例上 `msg` property 发生了改变，插值处的内容都会更新。

```html
<span>Message: {{ msg }}</span>
```

* 通过使用 v-once 指令，也能执行一次性地插值，当数据改变时，插值处的内容不会更新。

```html
<span v-once>这个将不会改变: {{ msg }}</span>
```

### 原生html

* 双大括号会将数据解释为普通文本，而非 HTML 代码。为了输出真正的 HTML，你需要使用`v-html` 指令。

```html
<div id="example1">
    <p>Using mustaches: {{ rawHtml }}</p>
    <p>Using v-html directive: <span v-html="rawHtml"></span></p>
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

### attribute

* Mustache 语法不能在 HTML attribute 中使用，可以使用 `v-bind`。

```html
<div v-bind:id="dynamicId"></div>
```

* 如果绑定的值是 `null` 或 `undefined`，那么该 attribute 将不会被包含在渲染的元素上。
* 对于布尔 attribute (它们只要存在就意味着值为 `true`)。如果 `isButtonDisabled` 的值是 truthy，那么 `disabled` attribute 将被包含在内。如果该值是一个空字符串，它也会被包括在内，与 `<button disabled="">` 保持一致。对于其他 falsy的值，该 attribute 将被省略。

```html
<button v-bind:disabled="isButtonDisabled">按钮</button>
```

### 使用 JavaScript 表达式

* Vue.js 提供了完全的 JavaScript 表达式支持。

```html
{{ number + 1 }}
{{ ok ? 'YES' : 'NO' }}
{{ message.split('').reverse().join('') }}
<div v-bind:id="'list-' + id"></div>
```

## 指令

* 指令 (Directives) 是带有 `v-` 前缀的特殊 attribute。指令在表达式的值改变时，响应式地作用于 DOM。

```html
<p v-if="seen">现在你看到我了</p>
```

### 参数

* 一些指令能够接收一个“参数”，在指令名称之后以冒号表示。例如，`v-bind` 指令可以用于响应式地更新 HTML attribute。

```html
<a v-bind:href="url"> ... </a>
```

*  `v-on` 指令，它用于监听 DOM 事件：

```html
<a v-on:click="doSomething"> ... </a>
```

### 动态参数

```html
<a v-bind:[attributeName]="url"> ... </a>
```

* 这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值。如果组件实例有一个 data property `attributeName`，其值为 `"href"`，那么这个绑定将等价于 `v-bind:href`。
* 动态参数预期会求出一个字符串，`null` 例外, `null` 值可以用于显式地移除绑定。任何其它非字符串类型的值都将会触发一个警告。
* 空格和引号，放在 HTML attribute 名里是无效的。
* 需要避免使用大写字符来命名键名，因为浏览器会把 attribute 名全部强制转为小写。

### 修饰符

* 修饰符 (modifier) 是以半角句号 `.` 指明的特殊后缀，用于指出一个指令应该以特殊方式绑定。`.prevent` 修饰符告诉 `v-on` 指令对于触发的事件调用 `event.preventDefault()`。

```html
<form v-on:submit.prevent="onSubmit">...</form>
```

### 缩写

* Vue 为 `v-bind` 和 `v-on` 这两个最常用的指令，提供了特定简写。

* `v-bind`

```html
<!-- 完整语法 -->
<a v-bind:href="url"> ... </a>

<!-- 缩写 -->
<a :href="url"> ... </a>

<!-- 动态参数的缩写 -->
<a :[key]="url"> ... </a>
```

* `v-on`

```html
<!-- 完整语法 -->
<a v-on:click="doSomething"> ... </a>

<!-- 缩写 -->
<a @click="doSomething"> ... </a>

<!-- 动态参数的缩写 -->
<a @[event]="doSomething"> ... </a>
```

# Data Property语法

## Data Property

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

## 方法

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

### 防抖和节流

https://v3.cn.vuejs.org/guide/computed.html#%E8%AE%A1%E7%AE%97%E5%B1%9E%E6%80%A7











<!--more-->
