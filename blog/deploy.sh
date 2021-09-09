#必须在根路径执行该命令
echo "文件生成中..."
hexo clean
hexo generate
tar -cf public.tar public/
echo "正在传输文件到服务器..." 
scp public.tar root@xiaoxiang.space:/www
echo "正在登录远程linux..."
ssh root@xiaoxiang.space "sh /www/deploy.sh"
rm -f public.tar