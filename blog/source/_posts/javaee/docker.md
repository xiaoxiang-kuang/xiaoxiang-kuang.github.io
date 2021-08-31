---
title: docker
categories:
  - [javaee]
site: javaee
date: 2021-08-31 18:21:38
---

* 容器container是一个进程，它与主机上的所有其他进程隔离。
* 镜像image包含了容器的文件系统，也包含了很多其他的配置。（镜像运行起来就是容器）

```shell
docker run -d -p 80:80 image_name:image_version
```

* `-d`后台运行。
* `-p`将主机的端口映射到容器的端口。

```shell
docker build -t image_name:image_version .
```

* 构建一个镜像。
* `-t`给镜像起个名字。
* ` . `表示在当前路径下。

```shell
#启动一个shell，执行了两个命令，第一个命令随机挑选了一个数并写到了txt文件中，第二个命令让容器保持运行
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
#查看容器内此txt文件内容
docker exec <container-id> cat /data.txt
#执行后面的命令
docker run -it ubuntu ls /
```

```shell
docker ps #获取容器的id
docker stop <container-id> #停止容器运行
docker rm <container-id> #移除容器
docker rm -f <container-id> #停止并移除容器运行
```

