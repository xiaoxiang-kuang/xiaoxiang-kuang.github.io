---
title: python异常-IO-进程等
categories:
  - [python]
site: python
date: 2021-03-15 13:58:56
---

## 错误

```python
try:
    i = 10 / int('a')
except ValueError as e:
    print("ValueError",e)
except ZeroDivisionError as e:
    print("ZeroDivisionError",e)
    #raise如果不带参数，就会把当前错误原样抛出
    raise 
finally:
    print("END")
```

单元测试要用到了再回来补充：[单元测试](https://www.liaoxuefeng.com/wiki/1016959663602400/1017604210683936)

## IO

* 以读的方式打开一个文件对象`f = open('test.txt','r')`
* 文件使用完毕后必须关闭，因为文件对象会占用操作系统的资源。可以使用`with open('test.txt','r') as f:`，这种形式会自动帮我们调用close()方法。
* 读取二进制文件`open('test','rb')`，读取非UTF-8编码的文件`open('gbk.txt', 'r', encoding = 'gbk')`，遇到编码错误后忽略`open('test', 'r', encoding = 'gbk', errors = 'ignore')`。
* 写文件就是将`r`参数改为`w`参数，当在写文件时，操作系统往往不会立刻把数据写入磁盘，而是先缓存起来，只有调用close方法时才会保证把没有写入的数据全部写入磁盘。

* StringIO和BytesIO是在内存中读写数据。
* [序列化](https://www.liaoxuefeng.com/wiki/1016959663602400/1017624706151424)