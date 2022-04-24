---
title: docker
tags: 
  - javaee
date: 2021-08-31 18:21:38
---

* 容器container是一个进程，它与主机上的所有其他进程隔离。
* 镜像image包含了容器的文件系统，也包含了很多其他的配置。（镜像运行起来就是容器）
* Dockerfile用来创建镜像，docker-compose指定如何运行镜像。

```sh
docker ps #获取已运行的容器
docker ps -a #获取所有的容器
docker images #获取所有镜像

#从仓库下载一个镜像
docker pull nginx:latest
#将镜像保存到本地
docker save -o docker-nginx.tar nginx
#从本地导入镜像
docker load -i docker-nginx.tar

#运行一个镜像，-d后台运行。-p将主机的端口映射到容器的端口。
docker run -d -p 80:80 image_name:image_version
#启动一个shell，执行了两个命令，第一个命令随机挑选了一个数并写到了txt文件中，第二个命令让容器保持运行
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
#启动镜像，并执行后面的命令
docker run -it ubuntu ls /
#--name 指定容器的名称
docker run -d -p 17106:3306 --name 171-mysql  mysql8:171-uam

#进入容器中，-i保持stdin打开，-t分配一个终端
docker exec -i -t <container-id> /bin/bash 
#查看容器内此txt文件内容
docker exec <container-id> cat /data.txt

#停止容器运行
docker stop <container-id> 
#移除容器
docker rm <container-id> 
#停止并移除容器运行
docker rm -f <container-id> 

#根据当前路径的dockerfile构建一个镜像。-t给镜像起个名字。
# . 表示在当前路径下，可以使用一个.dockerignore文件来忽略某些文件。
docker build -f Dockerfile -t image_name:image_version .

#创建一个named volume
docker volume create todo-db
#将volumn挂载到/etc/todos路径下
docker run -dp 3000:3000 -v todo_db:/etc/todos image_name:image_version
#查看此named volume的信息
docker volume inspect todo-db 
#使用了一个bind mounts，将主机的当前路径挂载到容器内的/app路径
#-w表示当前的工作路径，-d表示后台运行，-c表示执行后面的命令，-p表示端口映射
docker run -dp 3000:3000  -w /app -v "$(pwd):/app" node:12-alpine sh -c "yarn install && yarn run dev"
#查看logs，-f表示跟随日志输出
docker logs -f <container-id>

#创建了一个network
docker network create todo-app
#启动了一个mysql容器，并接入到network，使用-e定义了初始化数据库用的环境变量，
#mysql还支持MYSQL_HOST（mysql server的主机名）,MYSQL_USER。docker自动创建了一个todo-mysql-data的volume。
docker run -d --network todo-app --network-alias mysql \
-v todo-mysql-data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=todos \
mysql:5.7
#输入密码后就能进入到mysql中
docker exec -it <mysql-container-id> mysql -p
#加入到这个网络，并进入到bash
docker run -it --network todo-app image_name:image_version /bin/sh

#扫描一个镜像
docker scan image_name:image_version
#查看创建历史，--no-trunc获取全部输出
docker image history [--no-trunc] mysql:5.7
```

### restart策略

* 当使用`docker run`命令时可以使用`--restart`来配置容器的重启策略。可选的标志如下：

| flag                     | description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| no                       | 任何情况下不会自动重启容器(默认)                             |
| on-failure[:max-retries] | 当容器由于错误(退出代码为非0)而退出时会重启容器。使用`:max-retries`来限制容器尝试重启的次数。 |
| always                   | 始终在容器停止时重启，除非容器是被手动停止的。在docker重新启动时容器也会重启。 |
| unless-stopped           | 类似于always，但是当容器停止后，重启docker容器并不会启动。   |

参考链接: [use-a-restart-policy](https://docs.docker.com/config/containers/start-containers-automatically/#use-a-restart-policy)

## docker-compose

* `docker-compose version`获取版本信息。
* 创建一个叫`docker-compose.yml`的文件，如将下面这个命令转化为docker-compose。

```sh
#转换前
docker run -dp 3000:3000 -w /app -v "$(pwd):/app" --network todo-app \
  -e MYSQL_HOST=mysql -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret -e MYSQL_DB=todos \
  node:12-alpine  sh -c "yarn install && yarn run dev"

#转换前
docker run -d \
  --network todo-app --network-alias mysql \
  -v todo-mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos \
  mysql:5.7
```

``` yaml
#转换后
version: "3.7"

services:
  app:
    image: node:12-alpine
    ports:
      - 3000:3000
    working_dir: /app
    #docker compose中volume定义可以使用相对路径。
    volumes:
      - ./:/app
    command: sh -c "yarn install && yarn run dev"
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos
  
  mysql:
    image: mysql:5.7
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos
      
volumes:
  todo-mysql-data:
```

* 使用`docker-compose up -d`命令执行，-d参数使得在后台运行，这个命令会自动在应用间创建network。
* 使用`docker-compose logs -f`来查看日志。-f表示follow，会将日志的变化输出到控制台。
  * 使用`docker-compose logs -f app`来查看特定服务的日志。
* `docker-compose down [--volumes]`关闭并移除，--volumes指定是否删除volumes。

## dockerfile

* 一个Dockerfile大部分情况下以FROM指令开始，FROM指令指定了构建的父镜像。
* `ENV`用来设置环境变量，通过`${xxx}`的方式使用。
* CMD在docker run时运行，RUN在docker build时运行。
* RUN会在新的一层执行命令。

### 多阶段构建

```dockerfile
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps 
```

**参考链接：**[Orientation and setup | Docker Documentation](https://docs.docker.com/get-started/)


<!--more-->
