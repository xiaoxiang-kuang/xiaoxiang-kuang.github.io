#!/bin/bash
#此脚本需要和服务器的deploy脚本配合使用
blog_path=$(pwd)
blog_dir_name=${blog_path##/*/}
if [ ${blog_dir_name} != "blog-source" ];then
	echo "必须在blog-source的路径下执行该命令!" 
	echo 1
fi
echo "文件生成中"
hugo
tar -cf public.tar public/
echo "正在传输文件到服务器..."
scp public.tar root@xiaoxiang.space:/opt/www
if [ $? -ne 0 ];then
        echo "文件传输失败..."
        rm -f public.tar
        exit 1
else
        echo "文件传输成功，服务器会自动解压，请一分钟后查看"
        rm -f public.tar
        exit 0
fi

