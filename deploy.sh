#!/usr/bin/env bash

#编译后的前端文件路径
file_dir="public"
#打包文件名
file_name="blog.tar"

cd "$(dirname "$1")" || exit
echo "文件生成中..."
hugo
cd "${file_dir}" || exit
tar -cvf ${file_name} ./*
echo "正在将文件传输到服务器..."
if scp ${file_name} root@xiaoxiang.space:/tmp; then
        echo "文件传输成功..."       
else
        echo "文件传输失败..."
fi
rm -f ${file_name}