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

</pre>




