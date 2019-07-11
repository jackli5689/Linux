#varnish详解并无实操
<pre>
#缓存类型：
公共缓存:缓存服务器，不能缓存cooking的
私有缓存：客户端缓存
把经常变动的cooking信息都会去掉的，来提高命中率的。
一般只能缓存GET操作，而且不能缓存GET操作中带有帐户和密码的信息。PUT,POST是不能缓存的
#CDN:内容颁发网络，结合智能DNS来判定客户端的来源，从而返回离用户最近的缓存服务器。 当子缓存服务器没有缓存结果则去父缓存服务器查找，无则去找原始服务器
公共智能DNS服务器：dnspod

Expire:绝对时间计时法
max-age:相对时间计时法
Cache-control:用于定义所有的缓存机制都必须遵循的缓存指示，这些指示是一些特定的指令，包括public,private,no-cache(表示可以缓存，每一次去询问服务端缓存是否有效)no-store,max-age,s-maxage,must-revalidate等，[当定义了Expire时，而又定义了Cache-Control：max-age时，则Cache-Control会覆盖Expire]
Etag:验证tag随机数是否发生变化的，有变化跟本地tag对比不一样则说明更新过，一样则说明未更新过，可以避免时间上的粗糙。
###著名的缓存服务器varnish
Squid:varnish好比httpd:nginx，前者宝刀未老，后者新贵，但受人追捧
一般使用Nginx+varnish 或者 Nginx+Squid
配置文件是编译后（通过VCL[varnish control language]）的二进制文件，被各子进程读取的
</pre>

#Tomcat
<pre>
servlet:类似php的cgi协议，这个是java使用的servlet框架，可以使得java开发web项目了
JSP：Jave Server Page,可以使得java像php一样在html中嵌入java语言。
SSH框架：Structs,Spring,Hebernate.java著名的开发框架
JSP脚本---通过Jasper---转换成Servlet，然后Servlet通过java编译器编译成类
#JSP性能比PHP好得多，而且java比php流行。大型站点都使用JSP。facebook网站是php写的，但是它把所有php程序转换面C++代码，最后才运行。
applet,servlet：都是特殊的类，applet运行在客户端的，servlet运行在服务端的。

JSP：
	.jsp（通过jasper转换成.java）-->.java（通过servlet转换为.class[有javac编译器]）-->.class(JVM运行)
Servlet Container:Servlet容器（包括了jdk和其他的程序），用来编译.java文件成.class文件并运行
Web Container:Web容器=jasper+Servlet容器
#hadoop和tomcat一样是java写的
线程私有内存区：
	1. 程序计数器
	2. java虚拟机栈：存放本地变量的
线程共享内存区：	
	1. 方法区
	2. 堆：存储对象的，jvm启动时就启动
#JAVA可以自动完成内存的回收，GC（Garbage collector）来完成垃圾批量回收的
垃圾回收算法：
	1. 标记-清除
	2. 复制
		1. 只有二分之一可用，避免内存碎片，但浪费空间
		2. 划分比例来复制清除
	3. 标记-整理：也可避免内存碎片
垃圾回收器：
	1. Serial
	2. ParNew
	3. Parallel Scavenge
	4. Serial Old
	5. Parallel Old
	6. CMS:并行标记清除器，由Parallel Scavenge和arallel Old整合而来
			CMS优点：并发收集、低停顿
			CMS缺点：无法浮动垃圾、由于基于标记-清除算法可能会产生内存碎片
	7. G1

SUN:
	JRE,JDK
Open:
	OpenJDK
#安装JDK方法：
	1. rpm
	2. 通用二进制格式，.bin格式
	3. 源码安装（通过OpenJDK编译）
#rpm包安装javaJDK:
[root@mysql-slave bin]# wget http://download.oracle.com/otn/java/jdk/6u45-b06/jdk-6u45-linux-x64-rpm.bin 
配置java环境变量:
vim /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/jdk1.6.0_21
export PATH=$PATH:$JAVA_HOME/bin
$java -version  #有信息说明java环境配好了
source /etc/profile.d/java.sh

#JAVA配置参数：
	-XX:+<PTION>:开启此参数指定的功能
	-XX:-<option>:关闭功能
	-XX:<option>=<value>:给option指定的选项赋值

java -XX:+PrintFlagsFinal #查看最终参数的配置
-D<name>=<value>: set a system property

Sun JDK监控和故障处理工具：
	jps: JVM Process status Tool:显示指定系统内所有的HotSpot虚拟机进程
	jstat: JVM Statistics Monitoring Tool:收集并显示HotSpot虚拟机各大方面的运行数据 
	jinfo: 显示正在运行的某HotSpot虚拟机配置信息
	jmap: 生成某HotSpot虚拟机的内存转储快照
可视化工具：
	jconsole:java的监控与管理控制平台
	jvisualvm:
###Tomcat的实例
#tomcat的访问由外到里：
Server(每一个实例)，顶级组件
	service（将一个或多个连接器关联到一个引擎去的，一个service只有一个引擎）
		Engine(Serverlet Container)[一个引擎有多个虚拟主机，还有多个context，context类似httpd的别名URI路径，主机和context都可以运行一个实例的]
			JVM
server-->service-->Connector-->engine|Servlet Container-->Host,context--JVM

容器组件：Engine,host,context
顶级组件：server,service
Realm（领域）:用户帐号数据库，对用户进行认证的
Valve（阀门）:基于ip认证，过滤访问日志类型，需要logger进行记录日志
logger: 日志记录器，定义日志位置
#如果想让整个引擎上定义Realm，则在引擎上定义即可，如果想定义在host或context，则在相应位置定义即可。

###tomcat的配置文件
server.xml：tomcat的核心配置文件
<Server>
	<Service>
		<Connector />
		<Engine>
			<Host>
				<Context>  </Context>
			</Host>
		</Engine>
	</Service>
</Server>
#注：tomcat依赖的是jdk而不是jre，因为需要的不光是jvm，而且需要库编译

#安装tomcat方式：
	1. rpm包
	2. 通用二进制包
	3. 源码包

##通用二进制安装：
1. 先安装jdk:
#bin包安装javaJDK:
[root@mysql-slave download]# ./jdk-6u45-linux-x64.bin 
[root@mysql-slave download]# mv jdk1.6.0_45/ /usr/local/
[root@mysql-slave download]# ln -sv /usr/local/jdk1.6.0_45/ /usr/local/jdk
‘/usr/local/jdk’ -> ‘/usr/local/jdk1.6.0_45
配置java环境变量:
[root@mysql-slave download]# vim /etc/profile.d/java.sh
export JAVA_HOME=/usr/local/jdk
export PATH=$PATH:$JAVA_HOME/bin
[root@mysql-slave download]# . /etc/profile.d/java.sh 
[root@mysql-slave download]# java -version
java version "1.6.0_45"  #说明已经安装好
Java(TM) SE Runtime Environment (build 1.6.0_45-b06)
Java HotSpot(TM) 64-Bit Server VM (build 20.45-b01, mixed mode)
#安装tomcat:
[root@mysql-slave download]# wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-7/v7.0.94/bin/apache-tomcat-7.0.94.tar.gz
[root@mysql-slave download]# tar xf apache-tomcat-7.0.94.tar.gz -C /usr/local/
[root@mysql-slave local]# ln -sv /usr/local/apache-tomcat-7.0.94/ /usr/local/tomcat
‘/usr/local/tomcat’ -> ‘/usr/local/apache-tomcat-7.0.9
[root@mysql-slave tomcat]# ll
total 132
drwxr-xr-x 2 root root  4096 Jul 10 21:21 bin
-rw-r--r-- 1 root root 18099 Apr 11 00:57 BUILDING.txt
drwxr-xr-x 2 root root   158 Apr 11 00:57 conf
-rw-r--r-- 1 root root  6090 Apr 11 00:57 CONTRIBUTING.md
drwxr-xr-x 2 root root  4096 Jul 10 21:21 lib
-rw-r--r-- 1 root root 56846 Apr 11 00:57 LICENSE
drwxr-xr-x 2 root root     6 Apr 11 00:56 logs
-rw-r--r-- 1 root root  1241 Apr 11 00:57 NOTICE
-rw-r--r-- 1 root root  3255 Apr 11 00:57 README.md
-rw-r--r-- 1 root root  9365 Apr 11 00:57 RELEASE-NOTES
-rw-r--r-- 1 root root 16978 Apr 11 00:57 RUNNING.txt
drwxr-xr-x 2 root root    30 Jul 10 21:21 temp
drwxr-xr-x 7 root root    81 Apr 11 00:57 webapps
drwxr-xr-x 2 root root     6 Apr 11 00:56 work
[root@mysql-slave tomcat]# ls bin/  #catalina.sh是核心脚本，其他.sh脚本可以当做参数传给catalina.sh调用的
bootstrap.jar                 daemon.sh         startup.sh
catalina.bat                  digest.bat        tomcat-juli.jar
catalina.sh                   digest.sh         tomcat-native.tar.gz
catalina-tasks.xml            setclasspath.bat  tool-wrapper.bat
commons-daemon.jar            setclasspath.sh   tool-wrapper.sh
commons-daemon-native.tar.gz  shutdown.bat      version.bat
configtest.bat                shutdown.sh       version.sh
configtest.sh                 startup.bat
[root@mysql-slave tomcat]# ll conf/
total 212
-rw------- 1 root root  13342 Apr 11 00:57 catalina.policy #定义tomcat的安全策略
-rw------- 1 root root   6776 Apr 11 00:57 catalina.properties #应用程序属性的
-rw------- 1 root root   1394 Apr 11 00:57 context.xml #上下文文件
-rw------- 1 root root   3562 Apr 11 00:57 logging.properties  #日志属性的
-rw------- 1 root root   6613 Apr 11 00:57 server.xml #核心配置文件
-rw------- 1 root root   1950 Apr 11 00:57 tomcat-users.xml #用户帐户认证文件
-rw------- 1 root root 170604 Apr 11 00:57 web.xml #默认的部署描述符
部署描述符：将一个web应用程序所依赖到的类装载进JVM
#运行tomcat
export CATALINA_HOME=/usr/local/tomcat #定义变量CATALINA_HOME或者CATALINA_BASE来定义tomcat的目录的，一个物理机上可以运行多个tomcat,但端口不能冲突
[root@mysql-slave tomcat]# vim /etc/profile.d/tomcat.sh #为永久有效写入文件
export CATALINA_HOME=/usr/local/tomcat
export PATH=$PATH:$CATALINA_HOME/bin
[root@mysql-slave tomcat]# . /etc/profile.d/tomcat.sh 
[root@mysql-slave tomcat]# catalina.sh version #其实是version.sh脚本，但是建议这样用
Using CATALINA_BASE:   /usr/local/tomcat
Using CATALINA_HOME:   /usr/local/tomcat
Using CATALINA_TMPDIR: /usr/local/tomcat/temp
Using JRE_HOME:        /usr/local/jdk
Using CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
Server version: Apache Tomcat/7.0.94
Server built:   Apr 10 2019 16:56:40 UTC
Server number:  7.0.94.0
OS Name:        Linux
OS Version:     3.10.0-957.el7.x86_64
Architecture:   amd64
JVM Version:    1.6.0_45-b06
JVM Vendor:     Sun Microsystems Inc
[root@mysql-slave tomcat]# catalina.sh start #启动tomcat
Using CATALINA_BASE:   /usr/local/tomcat
Using CATALINA_HOME:   /usr/local/tomcat
Using CATALINA_TMPDIR: /usr/local/tomcat/temp
Using JRE_HOME:        /usr/local/jdk
Using CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
Tomcat started.
[root@mysql-slave tomcat]# netstat -tunlp | grep 80 #验证已经启动成功
tcp6       0      0 :::8009                 :::*                    LISTEN      27199/java          
tcp6       0      0 :::8080                 :::*                    LISTEN      27199/java          
tcp6       0      0 127.0.0.1:8005          :::*                    LISTEN      27199/java          
[root@mysql-slave logs]# ll /usr/local/tomcat/logs/
total 20
-rw-r--r-- 1 root root 6237 Jul 10 21:43 catalina.2019-07-10.log #tomcat启动时记录的日志
-rw-r--r-- 1 root root 6237 Jul 10 21:43 catalina.out #当前正在使用的文件
-rw-r--r-- 1 root root    0 Jul 10 21:43 host-manager.2019-07-10.log #host-manager的日志文件
-rw-r--r-- 1 root root  601 Jul 10 21:43 localhost.2019-07-10.log #定义的主机日志文件，包括错误日志文件等信息
-rw-r--r-- 1 root root    0 Jul 10 21:43 localhost_access_log.2019-07-10.txt #定义的主机访问日志文件
-rw-r--r-- 1 root root    0 Jul 10 21:43 manager.2019-07-10.log #manager的日志文件
#日志对应的URI，从catalina.2019-07-10.log可以看出
/usr/local/apache-tomcat-7.0.94/webapps/host-manager #host-manager日志记录的对应位置
 /usr/local/apache-tomcat-7.0.94/webapps/manager #manager日志记录的对应位置
[root@mysql-slave tomcat]# ls webapps/ROOT/ #每一个webapps目录下的WEB-INF、META-INF表示私有信息，绝不允许用户URI访问，也访问不到的。
asf-logo-wide.svg  bg-middle.png    bg-nav.png    favicon.ico  RELEASE-NOTES.txt  tomcat.gif  tomcat-power.gif  WEB-INF
bg-button.png      bg-nav-item.png  bg-upper.png  index.jsp    tomcat.css         tomcat.png  tomcat.svg
[root@mysql-slave tomcat]# ls work/  #tomcat的工作目录
Catalina
[root@mysql-slave tomcat]# ls work/Catalina/ #表示Catalina这个引擎
localhost
[root@mysql-slave tomcat]# ls work/Catalina/localhost/ #表示引擎下的主机localhost
_  docs  examples  host-manager  manager  #这些都是主机下的实例，context
[root@mysql-slave tomcat]# ls work/Catalina/localhost/_/ #下面无任何信息，需要访问才可编译生成
注：访问http://192.168.1.37:8080/
[root@mysql-slave tomcat]# ls work/Catalina/localhost/_/
org  #现在生成了编译的文件
[root@mysql-slave tomcat]# tree  work/Catalina/localhost/_/
work/Catalina/localhost/_/
└── org
    └── apache
        └── jsp
            ├── index_jsp.class  #这个就是编译的文件
            └── index_jsp.java
[root@mysql-slave tomcat]# jps
27369 Jps
27199 Bootstrap  #已经运行了
###tomcat脚本
[root@mysql-slave tomcat]# vim /etc/init.d/tomcatd
[root@mysql-slave ~]# cat /etc/init.d/tomcatd 
#!/bin/sh
# Tomcat init script for Linux.
# chkconfig: 2345 96 04
# description: The Apache Tomcat servlet/JSP container.
export JAVA_HOME=/usr/local/jdk
export CATALINA_HOME=/usr/local/tomcat
#export CATALINA_OPTS="-Xms128m -Xmx256m"
case $1 in
        restart)
                $CATALINA_HOME/bin/catalina.sh stop
                sleep 2
                $CATALINA_HOME/bin/catalina.sh start
                ;;
        *)
                $CATALINA_HOME/bin/catalina.sh $*
                ;;
esac
[root@mysql-slave tomcat]# chmod +x /etc/init.d/tomcatd
[root@mysql-slave tomcat]# chkconfig --add tomcatd
[root@mysql-slave tomcat]# chkconfig --list tomcatd
tomcatd         0:off   1:off   2:on    3:on    4:on    5:on    6:off
[root@mysql-slave tomcat]# service tomcatd stop
[root@mysql-slave tomcat]# service tomcatd start

#会话保持的几种方式：
             1、session sticky      注： 会话粘性
                      source ip     注:  基于ip地址的会话保持
                      cookie        注: 基于cookie绑定
             2、session cluster:    注：session集群，不同节点之间可以通过session复制的方式来同步session    
             3、session server      注:  session服务器，专门建立一个服务器来保存session   
                                         session server上装一个memcache或者redis           
                                         它们是用key-value技术实现的

########tomcat的负载均衡实现方式，
  1、 nginx做反向代理   nginx+tomcat
  2、 apache做方向代理  apache+tomcat
#apache实现反向代3种方式需要的模块
    1、apache: 
                mod_proxy
                mod_proxy_http
                mod_proxy_balancer

              tomcat:
                http connector

    2 、apache: 
                 mod_proxy
                 mod_proxy_ajp
                 mod_proxy_balancer                

            tomcat:
                ajp connector

    3、 apache:
                mod_jk
             tomcat:
                ajp connector

#nginx+tomcat部署：
实验部署：
1、三个节点，第一个几点的ip地址为172.16.0.131，后两个几点分别为172.16.0.134和172.16.0.135
2、后两个节点分别准备jdk和tomcat的安装包
3、第一个节点安装nginx
#tomcat-node1:
[root@mysql-slave conf]# vim server.xml 
<Engine name="Catalina" defaultHost="www.magedu.com" jvmRoute="TomcatA"> #设置默认虚拟主机，并且设置jvmRouteID
<Host name="www.magedu.com"  appBase="/web"
    unpackWARs="true" autoDeploy="true">
    <Context path="" docBase="webapps" reLoadable="true" />
</Host>
#tomcat-node2:
[root@mysql-slave conf]# vim server.xml 
<Engine name="Catalina" defaultHost="TC2.magedu.com" jvmRoute="TomcatB"> #设置默认虚拟主机，并且设置jvmRouteID
<Host name="TC2.magedu.com"  appBase="/web"
    unpackWARs="true" autoDeploy="true">
    <Context path="" docBase="webapps" reLoadable="true" />
</Host>
#nginx:
upstream tomcatserver{
	server www.magedu.com:8080;
	server TC2.magedu.com:8080;
}
location / {
            root   html;
            index  index.html index.htm;     
}
location ~* \.(jsp|do)$ {
	  		proxy_redirect          off;  
            proxy_set_header        Host            $host;  
            proxy_set_header        X-Real-IP       $remote_addr;  
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;  
            proxy_set_header        X-Forwarded-Proto  $scheme;  
            proxy_pass http://tomcatserver;  
}

##apache+tomcat
apache使用ajp协议（比http协议快）代理到后端的tomcat上
apache代理模块：
	1. mod_proxy(用得比mod_jk多，下级模块：mod_proxy_http,mod_proxy_ajp,mod_proxy_balancer)
	2. mod_jk

连接器：
	1. AJP
	2. HTTP
	3. https
	4. proxy
	注：需要java类来实现

###基于apache反向代理到tomcat,(使用ajp协议)
#配置tomcat：
[root@mysql-slave conf]# vim server.xml 
<Engine name="Catalina" defaultHost="www.magedu.com" jvmRoute="TomcatA"> #设置默认虚拟主机，并且设置jvmRouteID
<Host name="www.magedu.com"  appBase="/web"
    unpackWARs="true" autoDeploy="true">
    <Context path="" docBase="webapps" reLoadable="true" />
</Host>
service tomcat start #启动服务 

#前端apache配置：
./configure --prefix=/usr/local/apache --sysconfdir=/etc/httpd --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-zlib --with-pcre --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --enable-mpms-shared=all --with-mpm=event --enable-proxy --enable-proxy-http --enable-proxy-ajp --enable-proxy-balancer --enable-lbmethod-heartbeat --enable-heartbeat --enable-slotmem-shm --enable-slotmem-plain --enable-watchdog  #后面是开启proxy反向代理和hearbeat健康检查的。 
#配置apache通过mod_proxy模块与tomcat连接
需要apache已经装载mod_proxy,mod_proy_http，mod_proxy_ajp和proxy_balancer_module(实现tomcat集群时用到)等模块
httpd -D DUMP_MODULES | grep proxy #来查找proxy模块装载了哪些
#在httpd.conf的全局配置段或虚拟主机段加入如下内容(全局配置段是可以生效的，虚拟主机未试)：
##此段是基于ajp协议反向代理到tomcat的
ProxyVia Off #用于控制在httpd首部是否使用Via,主要用于在多级代理中控制代理请求的流向
ProxyRequests Off  #关闭正向代理功能
ProxyPreserveHost Off #如果启用此功能，代理会将用户请求报文中的Host:行发送给后端的服务器，而不再使用ProxyPass指定的服务器地址，如果想在反向代理中支持虚拟主机，则需要开启此项，否则就无需打开此功能。
<Proxy *>
	Require all granted
</Proxy>
	ProxyPass / ajp://172.16.100.1:8009/
	ProxyPassReverse / ajp://172.16.100.1:8009/ #用于让apache调整HTTP重写向响应报文中的Location,Content-Location及URI标签所对应的URL,在反向代理环境中必须使用此指令避免重写向报文绕过proxy服务器。
<Location />
	Require all granted
</Location>
##此段是基于http反向代理是tomcat的
ProxyVia Off
ProxyRequests Off
ProxyPreserveHost Off 
<Proxy *>
	Require all granted
</Proxy>
	ProxyPass / http://172.16.100.1:8080/
	ProxyPassReverse / http://172.16.100.1:8080/ 
<Location />
	Require all granted
</Location>
#注：由于balancer需要slotmem_shm_module模块，所以需要开启来才可运行
#配置tomcatl连接器mod_jk，需要单独下载tomcat-connector
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.46-src.tar.gz
tar xf tomcat-connectors-1.2.46-src.tar.gz
cd tomcat-connectors-1.2.46-src/nativel
./configure --with-apxs=/usr/local/apache/bin/apxs #把tomcat-connector连接器编译成模块，php_mod也是这样编译成模块的，只要可以编译成为apache的模块就是用这种方式编译的
make && make install #安装后模块就在apache的模块目录下
#vim /etc/httpd/extra/httpd-jk.conf #编辑jk配置文件
LoadModule jk_module modules/mod_jk.so #装载模块
JKWorkersFile /etc/httpd/extra/workers.properties #指定jk工作文件
JKLogFile logs/mod_jd.log
JKLogLevel debug  #为了测试才打开debug
JKMount /* TomcatA  #把哪下个URI路径送到后端的哪一个tomcat的routeID中
JKMount /status/ stat1  #stat1这个实例是在/etc/httpd/extra/workers.properties文件当中，文件中定义了什么实例，这里就使用什么名称
#vim /etc/httpd/extra/workers.properties
worker.list=TomcatA,stat1 #stat是jk模块自带内嵌的实例，我们取了个名是stat1
worker.TomcatA.port=8009
worker.TomcatA.host=192.168.10.8 #TomcatA的ip和端口
worker.TomcatA.type=ajp13  #使用ajp的协议版本为1.3
worker.TomcatA.lbfactor=1  #负载均衡权重
worker.stat1.type=status  #指定stat1输出状态信息的
#重启httpd服务即可访问后端的tomcat，使用的是ajp协议






</pre>




