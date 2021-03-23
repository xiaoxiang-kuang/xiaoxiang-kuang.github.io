---
title: url
categories:
  - [web]
site: web
date: 2021-03-23 11:57:23
---

## url参数（get）

* 每个参数都是键值对，用&分开
* 字符a-z，A-Z，0-9，`. - * _`不变。
* 用`+`替换空格。
* 将其他所有字符编码为UTF-8，并将每个字节都编码为%后跟一个两位的16进制数字。

* 一个post请求的例子

```java
    @Test
    public void test3() throws IOException {
        URL url = new URL("http://xiaoxiang.space/login/");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        //用户可以输出到该URLConnection
        connection.setDoOutput(true);
        String param = "password=" + URLEncoder.encode("小象", "UTF-8");

        //request headers
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Accept", "text/html");
        connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:86.0) Gecko/20100101 Firefox/86.0");
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        //general headers
        connection.setRequestProperty("Connection", "close");

        //entity headers，必须放在request headers和general headers后面，否则会报错
        connection.getOutputStream().write(param.getBytes(StandardCharsets.UTF_8));

        //关闭重定向，可以打开试一试
        connection.setInstanceFollowRedirects(false);
        connection.connect();

        System.out.println("\n响应头：");
        connection.getHeaderFields().forEach((k, v) -> {
            System.out.println(k + ": " + v);
        });

        //如果有网页的话会输出该网页
        InputStream inputStream = connection.getInputStream();
        Scanner scanner = new Scanner(inputStream,"utf-8");
        while (scanner.hasNext()) {
            System.out.println(scanner.nextLine());
        }
    }
```

