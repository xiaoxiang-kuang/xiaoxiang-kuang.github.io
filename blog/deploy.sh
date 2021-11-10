#!/bin/bash
#此脚本需要和服务器的deploy脚本配合使用
blog_path=$(pwd)
blog_dir_name=${blog_path##/*/}
if [ ${blog_dir_name} != "blog" ];then
	echo "必须在blog的路径下执行该命令!" 
	echo 1
fi
echo "文件生成中"
hexo clean && hexo generate
tar -cf public.tar public/
echo "正在传输文件到服务器..."
scp public.tar root@xiaoxiang.space:/opt/www
rm -f public.tar
if [ $? -ne 0 ];then
	echo "文件传输失败..."
	exit 1
fi
echo "正在登陆服务器..."
ssh root@xiaoxiang.space "sh /opt/www/deploy.sh"
exit 0
