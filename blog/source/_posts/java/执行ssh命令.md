---
title: 执行ssh命令
categories:
  - [java]
site: java
date: 2021-04-19 11:14:54
---

* 如何使用ssh连接linux执行shell命令？
```java
package space.xiaoxiang;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * 通过ssh连接到linux主机，并执行一些shell命令，需要导入JSch这个包
 */
public class App {

    private static final String host = "localhost";
    private static final int port = 22;
    private static final String username = "xiaoxiang";
    private static final String password = "asdf";

    //连接到linux主机
    public Session connect() throws  JSchException {
        JSch jsch = new JSch();
        Session session = jsch.getSession(username, host, port);
        session.setPassword(password);
        session.setConfig("StrictHostKeyChecking", "no");
        //开启会话
        session.connect();
        return session;
    }

    //执行shell命令
    public void execCommand(Session session, String command) throws JSchException, IOException {
        ChannelExec channelExec = (ChannelExec) session.openChannel("exec");
        InputStream in = channelExec.getInputStream();
        channelExec.setCommand(command);
        BufferedReader reader = new BufferedReader(new InputStreamReader(channelExec.getInputStream()));
        channelExec.connect();
        String line;
        while((line = reader.readLine()) != null){
            System.out.println(line);
        }
        channelExec.disconnect();
    }

    public static void main(String[] args) throws IOException, JSchException {
        App app = new App();
        Session session = app.connect();
        app.execCommand(session, "ls -l");
        System.out.println("----------");
        app.execCommand(session, "df -h");
        session.disconnect();
    }
}

```

