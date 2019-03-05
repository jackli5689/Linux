#Nginx
<pre>
#一.安装nginx
#安装所需的pcre库。注：安装这个pcre库是为了让nginx支持HTTP Rewrite模块
1. 下载pcre软件
ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.43.tar.gz
2. 编译安装
tar zxf pcre-8.43.tar.gz
cd pcre-8.43
yum install -y gcc gcc-c++
make && make install

#安装Nginx
[root@master-nginx pcre-8.43]# useradd -M -s /sbin/nologin  nginx
[root@master-nginx nginx-1.0.1]# ./configure \
> --user=nginx \
> --group=nginx \
> --prefix=/application/nginx-1.10.1 \
> --with-http_stub_status_module \
> --with-http_ssl_module
> --with-pcre=/download/src/pcre-8.43
注意这里不是安装后的目录，而是源码目录
[root@master-nginx nginx-1.0.1]#make && make install

#启动服务
[root@master-nginx src]# ln -s /application/nginx-1.10.1/ /application/nginx
[root@master-nginx nginx-1.10.1]# cd conf/
[root@master-nginx conf]# cp ../sbin/nginx /etc/init.d/
[root@master-nginx conf]# /etc/init.d/nginx  #启动
[root@master-nginx conf]# ps -ef | grep nginx  #查看是否启动
root       636     1  0 17:33 ?        00:00:00 nginx: master process /etc/init.d/nginx
nginx      637   636  0 17:33 ?        00:00:00 nginx: worker process
root       639 10547  0 17:33 pts/0    00:00:00 grep --color=auto nginx

[root@master-nginx conf]# /application/nginx/sbin/nginx -t  #检查语法
nginx: the configuration file /application/nginx-1.10.1/conf/nginx.conf syntax is ok
nginx: configuration file /application/nginx-1.10.1/conf/nginx.conf test is successful

有的时候也会提示有错误

[root@localhost nginx-1.10.1]# /application/nginx/sbin/nginx -t /application/nginx/sbin/nginx: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory

出现错误提示 提示说明无法打开libpcre.so.1这个文件，没有这个文件或目录，出现这个提示的原因是因为在系统的/etc/ld.so.conf这个文件里没有libpcre.so.1的路径配置

解决方法如下：
[root@localhost nginx-1.10.1]# find / -name libpcre.so.1
/download/tools/pcre-8.38/.libs/libpcre.so.1
/usr/local/lib/libpcre.so.1
[root@localhost nginx-1.10.1]# vi /etc/ld.so.conf
include ld.so.conf.d/*.conf
/usr/local/lib   #添加此路径即可
[root@localhost nginx-1.10.1]# ldconfig  #生效配置

#测试nginx
http://192.168.1.31/
如果出现无法访问的现象可以从以下几个方面排错:
1、防火墙是否关闭
2、与WEB服务器的联通性
3、selinux是否为disable
4、telnet下80端口
5、查看错误日志记录进行分析问题所在
              

#二.Nginx服务配置文件介绍
1、Nginx服务目录结构介绍
[root@master-nginx nginx]# tree
.
├── client_body_temp
├── conf     #nginx服务配置文件目录
│   ├── fastcgi.conf   #fastcgi配置文件
│   ├── fastcgi.conf.default
│   ├── fastcgi_params   #fastcgi参数配置文件
│   ├── fastcgi_params.default
│   ├── koi-utf
│   ├── koi-win
│   ├── mime.types
│   ├── mime.types.default
│   ├── nginx.conf   #nginx服务的主配置文件
│   ├── nginx.conf.default   #nginx服务的默认配置文件
│   ├── scgi_params
│   ├── scgi_params.default
│   ├── uwsgi_params
│   ├── uwsgi_params.default
│   └── win-utf
├── fastcgi_temp
├── html    #编译安装nginx默认的首页配置文件目录
│   ├── 50x.html   #错误页面配置文件
│   ├── index.html   #默认的首页配置文件
│   └── index.html.bak
├── logs    #日志配置文件目录
│   ├── access.log   #访问日志文件
│   ├── error.log    #错误日志文件
│   └── nginx.pid
├── proxy_temp
├── sbin    #命令目录
│   └── nginx    #Nginx服务启动命令
├── scgi_temp   #临时目录      
└── uwsgi_temp

2、Nginx服务主配置文件介绍
[root@master-nginx nginx]# egrep -v "#|^$" conf/nginx.conf  #过滤配置文件
worker_processes  1;  #工作进程数
events {    #事件
    worker_connections  1024;   #并发数，单位时间内最大连接数
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {     #虚拟主机标签
        listen       80;    #监听的端口号
        server_name  localhost;   #服务器主机名
        location / {
            root   html;    #默认站点目录
            index  index.html index.htm;      #默认首页文件
        }
        error_page   500 502 503 504  /50x.html;    #错误页面文件
        location = /50x.html { 
            root   html;
        }
    }
}

3、Nginx服务帮助信息
[root@master-nginx nginx]# /application/nginx/sbin/nginx -h
nginx version: nginx/1.10.1
Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

Options:
  -?,-h         : this help
  -v            : show version and exit  #显示版本并退出
  -V            : show version and configure options then exit  #显示版本信息与配置后退出
  -t            : test configuration and exit  #检查配置（检查语法）
  -T            : test configuration, dump it and exit
  -q            : suppress non-error messages during configuration testing
  -s signal     : send signal to a master process: stop, quit, reopen, reload
  -p prefix     : set prefix path (default: /application/nginx-1.10.1/)
  -c filename   : set configuration file (default: conf/nginx.conf)  #指定配置文件，而非使用nginx.conf
  -g directives : set global directives out of configuration file

4、nginx编译参数查看
[root@master-nginx nginx]# /application/nginx/sbin/nginx -v
nginx version: nginx/1.10.1
[root@master-nginx nginx]# /application/nginx/sbin/nginx -V
nginx version: nginx/1.10.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --user=nginx --group=nginx --prefix=/application/nginx-1.10.1 --with-http_stub_status_module --with-http_ssl_module --with-pcre=/download/src/pcre-8.43
实际生产环境比较实用的查看参数，比如服务非你自己所安装，但又没有相关文档参考，此参数可以提供一些相关的信息


</pre>