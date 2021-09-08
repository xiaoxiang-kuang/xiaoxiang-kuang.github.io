---
title: jmeter
categories:
  - [javaee]
site: javaee
date: 2021-09-06 18:11:39
---

* 默认情况下JMeter的堆大小为1GB，可以调整堆的大小。可以在启动脚本时指定这些参数，也可以在bin路径下创建setenv.bat（windows）或setenv.sh（linux），格式如下：

``` bash
#windows
set HEAP=-Xms2g -Xmx2g -XX:MaxMetaspaceSize=256m

#linux
export HEAP="-Xms1024m -Xmx1024m"
```

* 解决cookie跨域`CookieManager.check.cookies=false`

#### 创建web测试

##### 1. 添加Users 

![](/img/javaee/jmeter/1.png)

![](/img/javaee/jmeter/2.png)

* Number of Threads：启动的线程数。
* Ramp-Up Period：每秒启动的用户=user/seconds，0表示立即启动所有的用户。
* Loop Count：每个线程执行每个HTTP请求的次数。

##### 2. 添加默认HTTP请求属性

* HTTP Request Defaults 只是定义了一些默认值，不发送HTTP请求，发送请求的是HTTP Request。

![](/img/javaee/jmeter/3.png)

![](/img/javaee/jmeter/4.png)

##### 3. 添加cookie

* 添加cookie管理后不需要做配置，除非需要在多个请求间共享cookie。添加了cookie管理后cookie会为每个请求管理cookie。

![](/img/javaee/jmeter/5.png)

![](/img/javaee/jmeter/6.png)

##### 4. 添加HTTP请求

* 这里创建两个HTTP请求，HTTP发送请求的顺序是从上到下。

![](/img/javaee/jmeter/7.png)

* HTTP请求1，因为在Request Defaults中指定了域名，所以这里可以不写，这里还修改了Name，方便和其他的HTTP请求区分。

![](/img/javaee/jmeter/8.png)

* HTTP请求2

![](/img/javaee/jmeter/9.png)

##### 5. 添加监听器来查看存储的测试结果

* 查看HTTP结果，响应数据。

![](/img/javaee/jmeter/10.png)

* 查看总结

![](/img/javaee/jmeter/11.png)

##### 点击绿色三角执行测试，点击靠右边的扫帚清除之前的测试数据。

* 官方不建议在GUI模式下加载测试，GUI模式下用来创建测试案例和调试bug，测试需要在CLI模式下执行（命令行模式）。

**参考链接：**[Apache JMeter - User's Manual: Building a Web Test Plan](https://jmeter.apache.org/usermanual/build-web-test-plan.html)

#### 命令行模式（CLI Mode）

* -n指定JMeter运行在cli模式。
* -t指定JMX文件。
* -l 指定jtl文件的名称，该文件是用来记录结果。
* -e加载完测试后生成报告。
* -o生成报告的文件夹的位置，必须为空或者不存在。

```sh
jmeter -n -t  test.jmx -l sso.jtl -e -o test
```

**参考链接：**[Apache JMeter - User's Manual: Getting Started](http://jmeter.apache.org/usermanual/get-started.html#non_gui)
