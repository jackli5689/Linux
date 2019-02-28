#command 
<pre>
curl命令详解：
###curl参数值：
-x:指定代理
-T:通过ftp上传文件
-w:测试网页返回值 %{http_code}
-c:保存http的response里面的cookie信息
-D:保存http的response里面的header信息
-b:使用cookie
-A:可以让我们指定浏览器去访问网站
-e:以让我们设定referer（盗链）
-o:抓取文件并重命名
-O:下载文件以远程名字命名
-C:断点续传
-r:分段下载
-#:显示进度条
-s:静默，不显示进度条
-k:指定配置文件
-H:指定标头数据
-d:指定http数据
-i:输出时包括protocol头信息

curl示例：
1.抓取页面内容到一个文件中：
curl -o home.html http://192.168.1.31:9200
下载文件：
curl -O http://192.168.1.31/target.tar.gz
2.指定proxy服务器以及其端口：【当我们经常用curl去搞人家东西的时候，人家会把你的IP给屏蔽掉的,这个时候,我们可以用代理】
curl -x 10.10.90.83:80 -o home.html http://www.sina.com.cn
3.断点续传：
curl -C -O http://www.sina.com.cn
注：-C为启用断点续传
4.不显示下载进度信息 -s
curl -s -o aaa.jpg http://www.github.com
5.通过ftp下载文件
curl -u username:password -O ftp://192.168.1.19/store.tar.gz
curl -O ftp://username:password@192.168.1.19/store.tar.gz
6.通过ftp上传
curl -T ks-pre.log ftp://username:password@192.168.1.1
curl -T ks-pre.log -u username:password ftp://192.168.1.19
7.GET：
curl http://www.yahoo.com/login.cgi?user=nickname&password=12345
8.POST:
$curl -d "user=nickname&password=12345" http://www.yahoo.com/login.cgi
9.POST文件：
$curl -F upload= $localfile  -F $btn_name=$btn_value http://mydomain.net/~zzh/up_file.cgi
10.测试网页返回值：【在脚本中，这是很常见的测试网站是否正常的用法】
curl -o /dev/null -s -w %{http_code} 192.168.1/users/sign_in
11.保存http的response里面的header信息：
curl -D cookied.txt https://www.linux.com
12.保存http的response里面的cookie信息:
curl -c cookiec.txt https://www.linux.com
13.使用cookie：
curl -b cookiec.txt https://www.linux.com
注意：-c(小写)产生的cookie和-D里面的cookie是不一样的。
14.模仿浏览器:【有些网站需要使用特定的浏览器去访问他们，有些还需要使用某些特定的版本。curl内置option:-A可以让我们指定浏览器去访问网站】
curl -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" https://www.linux.com
注：这样服务器端就会认为是使用IE8.0去访问的
15.伪造referer（盗链）：【比如：你是先访问首页，然后再访问首页中的邮箱页面，这里访问邮箱的referer地址就是访问首页成功后的页面地址，如果服务器发现对邮箱页面访问的referer地址不是首页的地址，就断定那是个盗连了】
curl -e "www.linux.com" http://mail.linux.com
注：-e可以让我们设定referer
16.循环下载：【有时候下载图片可能是前面的部分名称是一样的，就最后的尾椎名不一样】
curl -O http://www.linux.com/dodo[1-5].JPG
17.分块下载：【有时候下载的东西会比较大，这个时候我们可以分段下载，使用内置option：-r】
curl -r 0-100 -o dodo1_part1.JPG http://www.linux.com/dodo1.JPG
curl -r 100-200 -o dodo1_part2.JPG http://www.linux.com/dodo1.JPG
curl -r 200- -o dodo1_part3.JPG http://www.linux.com/dodo1.JPG
cat dodo1_part* > dodo1.JPG
这样就可以查看dodo1.JPG的内容了
18.显示下载进度条#：
curl -# -O http://www.linux.com/dodo1.JPG


gpg命令详解：
#生成key，注：最后要你设置一个私钥密码。这个解密的时候很重要
gpg --gen-key 
#列出key
[root@clusterFS-node4-salt ~]# gpg --list-keys
/root/.gnupg/pubring.gpg
------------------------
pub   2048R/36ED2B33 2019-02-28
uid                  jackli (jackli) <595872348@qq.com>
sub   2048R/F2D4CDE8 2019-02-28
#导出公钥
gpg -a -o ./tt.key --export jackli
#导入新建的公钥文件
gpg --import pub.key  
#以指定公钥加密文件，生成加密的文件是.asc结尾
gpg -a -r 36ED2B33 --encrypt  test.txt 
#解密文件需要输入私钥密码，将密码的文件输出到tmp.txt中
gpg --decrypt -a -o tmp.txt test.txt.asc  

###mysql
MySQL授权命令grant的使用方法
grant 普通 DBA 管理某个 MySQL 数据库的权限。
grant all privileges on testdb to dba@'localhost'
其中，关键字 “privileges” 可以省略。

grant 高级 DBA 管理 MySQL 中所有数据库的权限。
grant all on *.* to dba@'localhost'

grant 作用在表中的列上
grant select(id, se, rank) on testdb.apache_log to dba@localhost;

查看 MySQL 用户权限：
查看当前用户（自己）权限：
show grants;
查看其他 MySQL 用户权限：
show grants for dba@localhost;

撤销已经赋予给 MySQL 用户权限的权限：
revoke 跟 grant 的语法差不多，只需要把关键字 “to” 换成 “from” 即可：
grant all on *.* to dba@localhost;
revoke all on *.* from dba@localhost;

MySQL grant、revoke 用户权限注意事项：
1. grant, revoke 用户权限后，该用户只有重新连接 MySQL 数据库，权限才能生效。
2. 如果想让授权的用户也可以将这些权限 grant 给其他用户，需要选项 “grant option“
grant select on testdb.* to dba@localhost with grant option;
这个特性一般用不到。实际中，数据库权限最好由 DBA 来统一管理。

linux：
安装mysql yum 源最新到80版本：
rpm -Uvh mysql80-community-release-el6-n.noarch.rpm
禁用mysql80:
sudo yum-config-manager --disable mysql80-community
启用mysql57:
sudo yum-config-manager --enable mysql57-community

Linux下MySQL的数据文件存放位置：
 show variables like '%dir%';



</pre>