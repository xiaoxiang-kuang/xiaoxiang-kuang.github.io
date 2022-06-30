---
title: "Httpcomponent"
date: 2022-06-07T16:50:15+08:00
tags:
  - javaee
draft: false
---

```java
//httpClient建议复用
CloseableHttpClient httpClient = HttpClients.createDefault();
HttpPost httpPost = new HttpPost(path);
List<NameValuePair> nameValuePairs = new ArrayList<>();
nameValuePairs.add(new BasicNameValuePair(USERNAME, admin.getUsername());
nameValuePairs.add(new BasicNameValuePair(PASSWORD, admin.getPassword());
httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
try(CloseableHttpResponse response = httpClient.execute(httpPost)) {
    Header[] cookies = response.getHeaders(COOKIE_HTTP_HEADER);
    if (cookies.length > 0) {
        return cookies[0].getValue();
    }
}
```



<!--more-->