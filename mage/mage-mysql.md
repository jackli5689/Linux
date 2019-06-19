#Mysql数据库

<pre>
#第一节：关系型数据体系结构
学习要点：
	1. sql/mysql
	2. 事务，隔离，并发控制，锁
	3. 用户和权限
	4. 监控
		1. status
	5. 索引类型：查询
		1. variables
	6. 备份和恢复*
	7. 复制功能
	8. mysql集群

DBMS:
	1. 层次模型
	2. 网关模型
	3. 关系模型
RDBMS：
	1. 关系模型
	2. 实体-关系模型
	3. 对象关系模型：基于对象的数据模型
	4. 半结构化数据模型：使用XML(扩展标记语言)例：<name>Jerry</name>,<age>50</age>
关系：关系代数运算
	1. 交集：重合的部分
	2. 并集：属于A或属于B
	3. 差集：属于A不属于B
	4. 补集：全集减去集合等于补集
SQL:Structure Qure Language
1970年IBM研发了System R数据库系统
Ingres：世界上第一款成熟的数据库系统。Oracle,sybase商业数据库系统。
美国标准委员会定义了sql标准：ansi-sql
DML:数据操作语言
	INSERT,DELETE,UPDATE,SELECT
DDL:数据定义语言
	CREATE,DROP,ALTER
DCL:数据控制语言(用于设置访问权限的)
	GRANT
	REVOKE

RDB对象：库、表、索引、视图、用户、存储过程、存储函数、触发器、事件调度器
RDB约束(constraint)：
	域约束：数据类型约束
	外键约束：引用完整性约束
	主键约束：某字段能唯一标识此字段所属的，并且不允许为空
		一张表中只能有一个主键
	唯一键约束：每一行的某字段都不允许出现相同值，可以为空
		一张表中可以有多个唯一键
	检查性约束：age: int

文件：
	表示层：文件
	逻辑层：文件系统（类似存储引擎）
	物理层：元数据，数据（存储为数据块）
关系型数据：
	表示层：表
	逻辑层：存储引擎
	物理层：数据文件（数据文件，索引文件，日志文件）

数据存储和查询：
	存储管理器：
		1. 权限及完整性管理器
		2. 事务管理器
		3. 文件管理器
		4. 缓冲管理器
	查询管理器：
		1. DML解释器
		2. DDL解释器
		3. 查询执行管理器
mysql交互工具及应用：
	1. 应用程序
	2. sql用户
	3. dba管理工具
	4. 程序员api
mysql是单进程多线程的，有守护线程，应用线程。应尽量跟数据库交互，所以需要使用缓存和线程重用
32bit：mysql最大2.7G内存
64bit:不能确定。smp：对称多处理器。mysql不能使一个请求在多个处理器运行，只能一个请求在一个处理器运行

关系运算：
	1. 投影：只输出指定属性
	2. 选择：只输出符合条件行 WHERE
	3. 自然连接：具有相同名字的属性上所有取值相同的行
	4. 笛卡尔积： (a+b)*(c+d)=ac+ad+bc+bd
	5. 并：集合运算


#第二节：mysql服务器的体系结构
sql查询语句：
	sequel-->然后发展成SQL
	sql规范：
		sql-86
		sql-89
		sql-92
		sql-99
		sql-03
		sql-08
SQL语言的组成部分：
	DDL
	DML
	完整性定义语言：DDL的一部分功能
	视图定义：
	事务控制
	嵌入式SQL和动态SQL：嵌入式SQL是把sql放在程序设计语言上执行

oracle:pl/sql（只有一个存储引擎）
postgresql:pl/sql
sqlserver:tsql（只有一个存储引擎）
mysql:sql（有多个存储引擎）
使用程序设计语言如何跟RDBMS交互：
	嵌入式SQL:把sql放在程序设计语言上执行。与动态SQL类似，但其语言必须程序编译时完全确定下来。
	ODBC
	动态SQL:程序设计语言使用函数（mysql_connect()）或者方法与RDBMS服务器建立连接，并进行交互;通过建立连接向SQL服务器发送查询语句，并将结果保存至变量中而后进行处理;
	JDBC

mysql请求流程：
用户->连接管理器->解析器->缓存
用户->连接管理器->解析器->优化器->存储引擎
mysql支持插件式存储引擎
5.5.8-：默认MyISAM(不支持事务)，适用于查询多，修改少
5.5.8+:默认InnoDB(支持事务)，适用于在线事务处理

表管理器：负责创建、删除、重命名、移除、更新或插入之类的操作;
表维护模块：检查、修改、备份、恢复、优化(碎片管理)及解析;

行：定长，变长
文件中记录组织：
	堆文件组织：一条记录可以放在文件中的任何地方。
	顺序文件组织：根据“搜索码”值顺序存放。
	散列文件组织：
表结构定义文件，表数据文件
表空间：table space

数据字典：data dictionaty （oracle很常见）
	关系的元数据：
		关系的名字
		字段名字
		字段的类型和长度
		视图
		约束
		用户名字，授权，密码
注：初始化mysql后生成的mysql数据库说白了就是数据字典
缓冲区管理器：
	缓存转换策略
	被钉住的块不被置换出来


#第三节：数据库基础及编译安装
mysql前途未卜，所以有了mariaDB,percona是为mysql提供优化方案的
安装方式：
	1. 基于软件包发行商格式的包。dep,rpm
	2. 通用二进制安装，是gcc,icc编译安装的，用得最多的是gcc
	3. 编译安装。5.1及以前是make安装的，后面的是cmake安装的，可以编译成32位或64位平台。
1. 基于软件包发行商格式的包安装的包：MySQL-client,MySQL-devel,MySQL-shared,MySQL-shared-compat。-----MySQL-test测试组件偶尔会装
2. 通信二进制安装之前做过
修改密码3种方式：
	1. mysqladmin -u root -h host -p password 'new-password'
	2. set password for 'root'@'localhost'=password('new-password');
	3. update user set password=password('new-password') where user=root and host=localhost;
###3. 编译安装mysql5.6：
1. 确保已经安装了cmake:[root@localhost yum.repos.d]# yum install cmake -y
#cmake用法：
./configure    cmake .
./configure --help    cmake . -LH   or   ccmake .
make && make install     make && make install
[root@localhost yum.repos.d]# yum groupinstall "Development Tools" "RPM Development Tools" -y  #安装开发环境
编译参数：
默认编译的存储引擎包括：csv、myisam、myisammrt和heap
-DWITH_READLINE=1  #开启批量导入功能
-DWITH_SSL=system #开启ssl,对于复制功能至关重要
-DWITH_ZLIB=system #压缩库
-DSYSCONFDIR=/etc #配置文件路径
-DMYSQL_DATADIR=/mydata/data #数据库路径
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql #安装路径
-DWITH_INNOBASE_STORAGE_ENGINE=1 #打开innoDB存储引擎
-DWITH_ARCHIVE_STORAGE_ENGINE=1 #打开archive存储引擎
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 #打开mysql黑洞存储引擎
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock #指定mysql套接字路径
-DDEFAULT_CHARSET=utf-8 #默认字符集
-DDEFAULT_COLLATION=utf8_general_ci #字符集默认排序规则，例如拼音排序，笔画排序
-DWITH_LIBWRAP=0  #禁用tcp_wrap访问
[root@localhost download]# mkdir /mydata/data -pv
[root@localhost data]# useradd -r -g 3306 -u 3306 -s /sbin/nologin mysql
[root@localhost data]# chown -R mysql.mysql /mydata/data/
[root@lnmp mysql-5.5.37]# cmake . -LH
[root@lnmp mysql-5.5.37]# cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/mydata/ -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_ZLIB=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf-8 -DDEFAULT_COLLATION=utf8_general_ci  #当后面mysql无法启动时，可以不单独设置-DDEFAULT_CHARSET=utf-8 -DDEFAULT_COLLATION=utf8_general_ci参数
/down/mysql-5.5.37/sql/sql_yacc.yy:14770:23: note: in expansion of macro ‘Lex’
             LEX *lex= Lex;
                       ^
make[2]: *** [sql/CMakeFiles/sql.dir/sql_yacc.cc.o] Error 1
make[1]: *** [sql/CMakeFiles/sql.dir/all] Error 2
make: *** [all] Error 2
[root@lnmp mysql-5.5.37]# echo $? #编辑报错
2
[root@lnmp ~]# rpm -qa | grep bison
bison-3.0.4-2.el7.x86_64  #版本太高
[root@lnmp ~]# rpm -e bison
[root@lnmp ~]# rpm -qa | grep bison
[root@lnmp ~]# wget ftp://ftp.gnu.org/gnu/bison/bison-2.5.1.tar.xz #下载2.5.1低版本
tar xf bison-2.5.1.tar 
cd bison-2.5.1/
./configure && make && make install
[root@lnmp mysql-5.5.37]# make && make install
[root@lnmp mysql-5.5.37]# cd /usr/local/
[root@lnmp local]# chown -R :mysql mysql/
[root@lnmp mysql]# ./scripts/mysql_install_db --user=mysql --datadir=/mydata/data
Installing MySQL system tables...
OK
Filling help tables...
OK
[root@lnmp mysql]# cp support-files/my-large.cnf /etc/my.cnf
cp: overwrite ‘/etc/my.cnf’? y
[root@lnmp mysql]# cp support-files/mysql.server /etc/init.d/mysqld
[root@lnmp mysql]# chkconfig --add mysqld
[root@lnmp mysql]# chkconfig --list mysqld
mysqld          0:off   1:off   2:on    3:on    4:on    5:on    6:off
[root@lnmp mysql]# vim /etc/profile.d/mysql.sh
export PATH=$PATH:/usr/local/mysql/bin
[root@lnmp mysql]# . /etc/profile
[root@lnmp etc]# service mysqld start
Starting MySQL.. SUCCESS! 
注：当上面所有设置过，启动不成功一般有4点原因：
	1. 此前服务未关闭端口占用，关闭之前的服务
	2. 数据初始化失败,查看数据目录/mydata下的$HOST.err错误文件
	3. 数据目录位置错误，数据目录/mydata下无$HOST.err错误文件，在my.cnf中明确定义datadir = /mydata
	4. 数据目录权限问题

#在同一台主机上，mysql和mysqld是如何进行通信的：
linux:
	mysql-->mysql.sock-->mysqld  #套接字
windows:
	mysql-->memory(pipe)-->mysqld   #共享内存或管道
mysql客户端工具：mysql、mysqldump、mysqladmin、mysqlcheck、mysqlimport   #my.cnf中client字段的配置都会对这些客户端工具生效
mysql非客户端工具：myisamchk、myisampark
mysql客户端使用参数：
	-u -h -p --protocal --port
	默认使用socket,其它protocol有tcp、memory、pipe

[root@lnmp etc]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 5.5.37-log Source distribution  #这里显示源码安装的

Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
8 rows in set (0.00 sec) 
注：默认存储引擎为InnoDB


[root@lnmp etc]# vim /etc/my.cnf
thread_concurrency = 4 #4个并发线程
datadir = /mydata/data  #源码编译安装的mysql没有这个路径，但不报错，因为编译的时候已经指定了，为了保险起见，写上这行
[root@lnmp etc]# service mysqld restart
[root@lnmp etc]# mysql
mysql> select User,Host,Password from user;
+------+---------------+----------+
| User | Host          | Password |
+------+---------------+----------+
| root | localhost     |          |
| root | lnmp.jack.com |          |
| root | 127.0.0.1     |          |
| root | ::1           |          |
|      | localhost     |          |  #有两个匿名用户，需要删除
|      | lnmp.jack.com |          |
+------+---------------+----------+
mysql> drop user ''@localhost;
Query OK, 0 rows affected (0.00 sec)

mysql> drop user ''@lnmp.jack.com;
Query OK, 0 rows affected (0.00 sec)

mysql> drop user 'root'@'::1';
Query OK, 0 rows affected (0.00 sec)

mysql> select User,Host,Password from user;
+------+---------------+----------+
| User | Host          | Password |
+------+---------------+----------+
| root | localhost     |          |
| root | lnmp.jack.com |          |
| root | 127.0.0.1     |          |
+------+---------------+----------+
3 rows in set (0.00 sec)
mysql> update user set password=password('root123') where user='root';  #设置保留的三个用户密码
Query OK, 3 rows affected (0.00 sec)
Rows matched: 3  Changed: 3  Warnings: 0

mysql> select User,Host,Password from user;
+------+---------------+-------------------------------------------+
| User | Host          | Password                                  |
+------+---------------+-------------------------------------------+
| root | localhost     | *FAAFFE644E901CFAFAEC7562415E5FAEC243B8B2 |
| root | lnmp.jack.com | *FAAFFE644E901CFAFAEC7562415E5FAEC243B8B2 |
| root | 127.0.0.1     | *FAAFFE644E901CFAFAEC7562415E5FAEC243B8B2 |
+------+---------------+-------------------------------------------+
[root@lnmp etc]# mysql -u root -h 192.168.1.233 -p  #登录报错，因为只允许本机访问，而且本机访问只能是通过socket访问的，现在指明ip地址，则mysql认为是使用tcp连接的，所以用root用户tcp连接跟设置的root用户socket连接不符，所以报错
Enter password: 
ERROR 1130 (HY000): Host 'linux-node1-salt.jack.com' is not allowed to connect to this MySQL server

如何在本机上不指定用户名主机密码登录mysql:
[root@lnmp ~]# cat .my.cnf 
[client]  #client为所有客户端生效，当为mysql时只针对mysql客户端
user = 'root'
password = 'root123'
host = 'localhost'
[root@lnmp ~]# chmod 600 .my.cnf 
[root@lnmp ~]# service mysqld restart #重启即可
Shutting down MySQL. SUCCESS! 
Starting MySQL.. SUCCESS! 
#认识数据库文件：
[root@lnmp mysql]# cd /mydata/data/mysql/ #进入系统数据库mysql
[root@lnmp mysql]# ls  #对于myISAM来说每个表有3个文件 
db.frm  #对于MyISAM存储引擎来说这个是表结构文件
db.MYD  #对于MyISAM存储引擎来说这个是表存储文件
db.MYI  #对于MyISAM存储引擎来说这个是表索引文件
InnoDB:
	所有表共享一个表空间文件，不好
	建议：每表一个独立的表空间文件
mysql> show variables like '%innodb%';
innodb_file_per_table           | OFF #把这个打开就可以支持每张表生成一个表空间文件
#为了永久生效，编辑 vim /etc/my.cnf文件
[mysqld]
innodb_file_per_table = 1
[root@lnmp bison-2.5.1]# service mysqld restart #重启服务
mysql> show global variables like '%innodb_file_per_table%';
+-----------------------+-------+
| Variable_name         | Value |
+-----------------------+-------+
| innodb_file_per_table | ON    |
+-----------------------+-------+

##例：创建一张表
mysql> create database mydb;
Query OK, 1 row affected (0.00 sec)

mysql> use mydb;
Database changed
mysql> create table testdb(
    -> id int not null,
    -> name char(30));
Query OK, 0 rows affected (0.00 sec)
[root@lnmp bison-2.5.1]# cd /mydata/data/mydb/
[root@lnmp mydb]# ll
total 208
-rw-rw---- 1 mysql mysql    65 Jun 13 17:27 db.opt #当前数据默认的字符集和排序规则
-rw-rw---- 1 mysql mysql  8586 Jun 13 17:27 testdb.frm #innoDB的.frm为表结构
-rw-rw---- 1 mysql mysql 98304 Jun 13 17:27 testdb.ibd #innoDB的.ibd为表空间，存储了表的数据

##第四节：客户端工具的使用
mysql登入参数：
	1. -u or user
	2. -p or password
	3. -h or host
	4. --protocol
	5. --port
	6. --database or -D 

mysql两种交换模式
	1. 交互式模式
	2. 批处理模式  #mysql < init.sql  #sql文件为sql语句 

mysql提示符：
	1. ->
	2. '>
	3. ">
	4. /*>
	5. `>

#mysql命令分为两种
	1. 客户端命令
	2. 服务器命令
	
#mysql的客户端命令的使用：
mysql> \?  #获取客户端命令帮助

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.  #设置服务器结束符
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically. #以列方式显示表
exit      (\q) Exit mysql. Same as quit. #退出客户端
go        (\g) Send command to mysql server. #默认以行显示
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash. #打开名称补全
source    (\.) Execute an SQL script file. Takes a file name as an argument.  #读取服务器上sql文件
status    (\s) Get status information from the server. #查看状态信息
system    (\!) Execute a system shell command. #执行系统命令
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.  #切换数据库
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets. #切换字符集
warnings  (\W) Show warnings after every statement. #开启警告信息
nowarning (\w) Don't show warnings after every statement. #关闭警告信息

For server side help, type 'help contents'

#mysql的服务器命令使用：
help KEYWORD ＃help关键字

##mysqladmin客户端工具的使用
[root@lnmp ~]# mysqladmin --help
Usage: mysqladmin [OPTIONS] command command....
mysqladmin -u root -p password "NEW_PASSWORD" #更改root密码
mysqladmin参数：
	--compress #发送接收数据时都进行压缩
	--ssl-ca=name   #指定ca路径及名称
	--ssl-capath=name  #指定多个ca路径
	--ssl-cert=name  #指定证书路径及名称
	--ssl-cipher=name  #指定加密算法列表
	--ssl-key=name  #指定key路径及名称
	--ssl-verify-server-cert #是否验证服务器证书
	create DATABASE
	drop DATABASE
	processlist   #查看mysql服务器当前执行的命令进程
	status  #查看服务器状态
		--sleep 2 #每隔2秒显示一次
		--count 2 #总共显示两次
	extended-status  #显示服务器状态变量信息
	variables  #显示服务器变量
	flush-privileges #重读mysql授权表，
	flush-status  #重置服务器的大多数变量
	flush-logs  #二进制和中继日志滚动
	flush-hosts #重置计数器可以让失误次数过多而被禁止登录的用户登录
	kill #杀死一个线程
	reload  #等同于flush-privileges 
	refresh #相同于同时执行flush-hosts和flush-logs
	shutdown #关闭mysql服务
	version #显示服务器版本及当前状态信息
	start-slave:启动从服务器复制线程
		SQL thread
		IO thread
	stop-slave:关闭从服务器复制线程

另外mysql客户端工具：mysqldump,mysqlimport,mysqlcheck

#第五节：mysql数据类型及sql模型
myISAM:
	.frm  #表结构文件
	.MYD  #表数据文件
	.MYI  #表索引文件
InnoDB
	.frm  #表结构文件
	.ibd  #表空间(数据和索引)
大多数情况下使用的是myISAM和InnoDB存储引擎，其它存储引擎为抚助存储引擎

客户端：mysql,mysqladmin,mysqldump,mysqlcheck,mysqlimport
服务器：mysqld,mysqld_safe(安全线程启动，mysql真正启动时是这个启动的),mysqld_multi(多实例)
mysqlbinlog #查看mysql二进制日志的
#my.cnf配置文件顺序：
	/etc/my.cnf,/etc/mysql/my.cnf,$MYSQL_HOME/my.cnf,--default-extra-file=/pth/to/somefile,~/.my.cnf  #后面的会覆盖前面的配置

[mysqld] #mysqld服务端配置
[mysql] #mysql客户端
[client】#所有客户端
注：所有命令行的命令都可以写到my.cnf配置文件中，也可以把my.cnf文件写在命令行中，在命令行中的_下划线和-横线在配置中一样，
#mysql配置文件帮助信息：
mysqld --help --verbose  #查看配置文件可用的参数

mysql> help show table status; #查看表的状态信息
Name: 'SHOW TABLE STATUS'
Description:
Syntax:
SHOW TABLE STATUS [{FROM | IN} db_name]
    [LIKE 'pattern' | WHERE expr]

SHOW TABLE STATUS works likes SHOW TABLES, but provides a lot of
information about each non-TEMPORARY table. You can also get this list
using the mysqlshow --status db_name command. The LIKE clause, if
present, indicates which table names to match. The WHERE clause can be
given to select rows using more general conditions, as discussed in
http://dev.mysql.com/doc/refman/5.5/en/extended-show.html.

URL: http://dev.mysql.com/doc/refman/5.5/en/show-table-status.html
mysql> show table status from mysql like 'user' \G ;
*************************** 1. row ***************************
           Name: user
         Engine: MyISAM  #表类型为MyISAM
        Version: 10
     Row_format: Dynamic
           Rows: 3
 Avg_row_length: 126
    Data_length: 380
Max_data_length: 281474976710655
   Index_length: 2048
      Data_free: 0
 Auto_increment: NULL
    Create_time: 2019-06-18 21:57:30
    Update_time: 2019-06-18 22:34:55
     Check_time: NULL
      Collation: utf8_bin
       Checksum: NULL
 Create_options: 
        Comment: Users and global privileges
1 row in set (0.00 sec)

DBA:
	开发DBA:数据库设计、SQL语句、存储过程，存储函数，触发器
	管理DBA：安装、升级、备份、恢复、用户管理、权限管理、监控、性能分析、基准测试

###mysql开发
1. mysql数据类型
2. mysql SQL语句

1.mysql数据类型：
	数值型：
		精确数值：
			1. int 
			2. decimal #十进制
		近似数值：
			1. fload
			2. double
			3. real #实数
	字符型：
		定长：CHAR(N) #不区分大小写，BINARY  #BINARY区分大小写
		变长：VARCHAR(N) #不区分大小写，VARBINARY #VARBINARY可变长的区分大小写
		大字符：text #不区分大小写   blob #区分大小写
		内置类型：ENUM  #枚举型,SET #集合型
	日期时间型：
		date,time,datatime,timestamp(时间戳)，year(N)#可为2位或4位
域属性，修改符：（进行域限制的）	
数据类型：
1. 存储的值类型：
2. 占据的存储空间：
3. 定长还是变长：
4. 如何比较及排序：
5. 是否能够索引：
#不区分大小写：
char #最大255个字符，能索引整个字段
varchar #最大65535个字符，每一个varchar将至少多占一个字符空间，超过255后需要占用两个结束符，低于255时只占用1个结束符
tinytext #255个字符，不能索引整个字段
text #65535
mediumtext #16777215
longtext  #4294967295
#区分大小写：
binary #255个字节
varbinary #65535个字节
tinyblob #255个字节，blob中为文本大对象
blob #64k
mediumblob  #16Mb空间
longblog #4G空间

tinyint(1) #括号里面的数字并不会改变数据类型的大小，只是显示数值位数，例如值为123，则这里显示个位3
date #3个字节
time #3个字节
datetime #8个字节
year #1个字节
ENUM  #枚举型，字符型，65535个字符
SET #集合型，存储的是位图，64个字符

#字段后面的限定：
1. NOTNULL
2. NULL
3. DEFAULT
4. CHARACTER SET #字符集
5. COLLATION  #排序规则
6. AUTO_INCREMENT #自增长，必须为正整形（UNSIGNED），这个字段定义为这个类型后不能为空，一定要创建索引(PRIMARY KEY或UNIQUE index)
7. ZEROFILL #多一位用0填充
mysql> select last_insert_id();
+------------------+
| last_insert_id() |
+------------------+
|                0 |
+------------------+
#所有存储函数使用select执行，存储过程使用call来调用 
#字符集和排序规则：字段从表继承，表从数据库继承，数据库从服务器继承
mysql> SHOW CHARACTER SET;  #查看当前服务器的所有字符集
+----------+-----------------------------+---------------------+--------+
| Charset  | Description                 | Default collation   | Maxlen |
+----------+-----------------------------+---------------------+--------+
| big5     | Big5 Traditional Chinese    | big5_chinese_ci     |      2 |
| dec8     | DEC West European           | dec8_swedish_ci     |      1 |
| cp850    | DOS West European           | cp850_general_ci    |      1 |
| hp8      | HP West European            | hp8_english_ci      |      1 |
| koi8r    | KOI8-R Relcom Russian       | koi8r_general_ci    |      1 |
| latin1   | cp1252 West European        | latin1_swedish_ci   |      1 |
| latin2   | ISO 8859-2 Central European | latin2_general_ci   |      1 |
| swe7     | 7bit Swedish                | swe7_swedish_ci     |      1 |
| ascii    | US ASCII                    | ascii_general_ci    |      1 |
| ujis     | EUC-JP Japanese             | ujis_japanese_ci    |      3 |
| sjis     | Shift-JIS Japanese          | sjis_japanese_ci    |      2 |
| hebrew   | ISO 8859-8 Hebrew           | hebrew_general_ci   |      1 |
| tis620   | TIS620 Thai                 | tis620_thai_ci      |      1 |
| euckr    | EUC-KR Korean               | euckr_korean_ci     |      2 |
| koi8u    | KOI8-U Ukrainian            | koi8u_general_ci    |      1 |
| gb2312   | GB2312 Simplified Chinese   | gb2312_chinese_ci   |      2 |
| greek    | ISO 8859-7 Greek            | greek_general_ci    |      1 |
| cp1250   | Windows Central European    | cp1250_general_ci   |      1 |
| gbk      | GBK Simplified Chinese      | gbk_chinese_ci      |      2 |
| latin5   | ISO 8859-9 Turkish          | latin5_turkish_ci   |      1 |
| armscii8 | ARMSCII-8 Armenian          | armscii8_general_ci |      1 |
| utf8     | UTF-8 Unicode               | utf8_general_ci     |      3 |
| ucs2     | UCS-2 Unicode               | ucs2_general_ci     |      2 |
| cp866    | DOS Russian                 | cp866_general_ci    |      1 |
| keybcs2  | DOS Kamenicky Czech-Slovak  | keybcs2_general_ci  |      1 |
| macce    | Mac Central European        | macce_general_ci    |      1 |
| macroman | Mac West European           | macroman_general_ci |      1 |
| cp852    | DOS Central European        | cp852_general_ci    |      1 |
| latin7   | ISO 8859-13 Baltic          | latin7_general_ci   |      1 |
| utf8mb4  | UTF-8 Unicode               | utf8mb4_general_ci  |      4 |
| cp1251   | Windows Cyrillic            | cp1251_general_ci   |      1 |
| utf16    | UTF-16 Unicode              | utf16_general_ci    |      4 |
| cp1256   | Windows Arabic              | cp1256_general_ci   |      1 |
| cp1257   | Windows Baltic              | cp1257_general_ci   |      1 |
| utf32    | UTF-32 Unicode              | utf32_general_ci    |      4 |
| binary   | Binary pseudo charset       | binary              |      1 |
| geostd8  | GEOSTD8 Georgian            | geostd8_general_ci  |      1 |
| cp932    | SJIS for Windows Japanese   | cp932_japanese_ci   |      2 |
| eucjpms  | UJIS for Windows Japanese   | eucjpms_japanese_ci |      3 |
+----------+-----------------------------+---------------------+--------+
39 rows in set (0.00 sec)

mysql> show collation;  #查看各个字符集下的排序规则 
+--------------------------+----------+-----+---------+----------+---------+
| Collation                | Charset  | Id  | Default | Compiled | Sortlen |
+--------------------------+----------+-----+---------+----------+---------+
| big5_chinese_ci          | big5     |   1 | Yes     | Yes      |       1 |
| big5_bin                 | big5     |  84 |         | Yes      |       1 |
| dec8_swedish_ci          | dec8     |   3 | Yes     | Yes      |       1 |
| dec8_bin                 | dec8     |  69 |         | Yes      |       1 |
| cp850_general_ci         | cp850    |   4 | Yes     | Yes      |       1 |
| cp850_bin                | cp850    |  80 |         | Yes      |       1 |
| hp8_english_ci           | hp8      |   6 | Yes     | Yes      |       1 |
| hp8_bin                  | hp8      |  72 |         | Yes      |       1 |
| koi8r_general_ci         | koi8r    |   7 | Yes     | Yes      |       1 |
| koi8r_bin                | koi8r    |  74 |         | Yes      |       1 |
| latin1_german1_ci        | latin1   |   5 |         | Yes      |       1 |
| latin1_swedish_ci        | latin1   |   8 | Yes     | Yes      |       1 |
| latin1_danish_ci         | latin1   |  15 |         | Yes      |       1 |
| latin1_german2_ci        | latin1   |  31 |         | Yes      |       2 |
| latin1_bin               | latin1   |  47 |         | Yes      |       1 |
| latin1_general_ci        | latin1   |  48 |         | Yes      |       1 |
| latin1_general_cs        | latin1   |  49 |         | Yes      |       1 |
| latin1_spanish_ci        | latin1   |  94 |         | Yes      |       1 |
| latin2_czech_cs          | latin2   |   2 |         | Yes      |       4 |
| latin2_general_ci        | latin2   |   9 | Yes     | Yes      |       1 |
| latin2_hungarian_ci      | latin2   |  21 |         | Yes      |       1 |
| latin2_croatian_ci       | latin2   |  27 |         | Yes      |       1 |
| latin2_bin               | latin2   |  77 |         | Yes      |       1 |
| swe7_swedish_ci          | swe7     |  10 | Yes     | Yes      |       1 |
| swe7_bin                 | swe7     |  82 |         | Yes      |       1 |
| ascii_general_ci         | ascii    |  11 | Yes     | Yes      |       1 |
| ascii_bin                | ascii    |  65 |         | Yes      |       1 |
| ujis_japanese_ci         | ujis     |  12 | Yes     | Yes      |       1 |
| ujis_bin                 | ujis     |  91 |         | Yes      |       1 |
| sjis_japanese_ci         | sjis     |  13 | Yes     | Yes      |       1 |
| sjis_bin                 | sjis     |  88 |         | Yes      |       1 |
| hebrew_general_ci        | hebrew   |  16 | Yes     | Yes      |       1 |
| hebrew_bin               | hebrew   |  71 |         | Yes      |       1 |
| tis620_thai_ci           | tis620   |  18 | Yes     | Yes      |       4 |
| tis620_bin               | tis620   |  89 |         | Yes      |       1 |
| euckr_korean_ci          | euckr    |  19 | Yes     | Yes      |       1 |
| euckr_bin                | euckr    |  85 |         | Yes      |       1 |
| koi8u_general_ci         | koi8u    |  22 | Yes     | Yes      |       1 |
| koi8u_bin                | koi8u    |  75 |         | Yes      |       1 |
| gb2312_chinese_ci        | gb2312   |  24 | Yes     | Yes      |       1 |
| gb2312_bin               | gb2312   |  86 |         | Yes      |       1 |
| greek_general_ci         | greek    |  25 | Yes     | Yes      |       1 |
| greek_bin                | greek    |  70 |         | Yes      |       1 |
| cp1250_general_ci        | cp1250   |  26 | Yes     | Yes      |       1 |
| cp1250_czech_cs          | cp1250   |  34 |         | Yes      |       2 |
| cp1250_croatian_ci       | cp1250   |  44 |         | Yes      |       1 |
| cp1250_bin               | cp1250   |  66 |         | Yes      |       1 |
| cp1250_polish_ci         | cp1250   |  99 |         | Yes      |       1 |
| gbk_chinese_ci           | gbk      |  28 | Yes     | Yes      |       1 |
| gbk_bin                  | gbk      |  87 |         | Yes      |       1 |
| latin5_turkish_ci        | latin5   |  30 | Yes     | Yes      |       1 |
| latin5_bin               | latin5   |  78 |         | Yes      |       1 |
| armscii8_general_ci      | armscii8 |  32 | Yes     | Yes      |       1 |
| armscii8_bin             | armscii8 |  64 |         | Yes      |       1 |
| utf8_general_ci          | utf8     |  33 | Yes     | Yes      |       1 |
| utf8_bin                 | utf8     |  83 |         | Yes      |       1 |
| utf8_unicode_ci          | utf8     | 192 |         | Yes      |       8 |
| utf8_icelandic_ci        | utf8     | 193 |         | Yes      |       8 |
| utf8_latvian_ci          | utf8     | 194 |         | Yes      |       8 |
| utf8_romanian_ci         | utf8     | 195 |         | Yes      |       8 |
| utf8_slovenian_ci        | utf8     | 196 |         | Yes      |       8 |
| utf8_polish_ci           | utf8     | 197 |         | Yes      |       8 |
| utf8_estonian_ci         | utf8     | 198 |         | Yes      |       8 |
| utf8_spanish_ci          | utf8     | 199 |         | Yes      |       8 |
| utf8_swedish_ci          | utf8     | 200 |         | Yes      |       8 |
| utf8_turkish_ci          | utf8     | 201 |         | Yes      |       8 |
| utf8_czech_ci            | utf8     | 202 |         | Yes      |       8 |
| utf8_danish_ci           | utf8     | 203 |         | Yes      |       8 |
| utf8_lithuanian_ci       | utf8     | 204 |         | Yes      |       8 |
| utf8_slovak_ci           | utf8     | 205 |         | Yes      |       8 |
| utf8_spanish2_ci         | utf8     | 206 |         | Yes      |       8 |
| utf8_roman_ci            | utf8     | 207 |         | Yes      |       8 |
| utf8_persian_ci          | utf8     | 208 |         | Yes      |       8 |
| utf8_esperanto_ci        | utf8     | 209 |         | Yes      |       8 |
| utf8_hungarian_ci        | utf8     | 210 |         | Yes      |       8 |
| utf8_sinhala_ci          | utf8     | 211 |         | Yes      |       8 |
| utf8_general_mysql500_ci | utf8     | 223 |         | Yes      |       1 |
| ucs2_general_ci          | ucs2     |  35 | Yes     | Yes      |       1 |
| ucs2_bin                 | ucs2     |  90 |         | Yes      |       1 |
| ucs2_unicode_ci          | ucs2     | 128 |         | Yes      |       8 |
| ucs2_icelandic_ci        | ucs2     | 129 |         | Yes      |       8 |
| ucs2_latvian_ci          | ucs2     | 130 |         | Yes      |       8 |
| ucs2_romanian_ci         | ucs2     | 131 |         | Yes      |       8 |
| ucs2_slovenian_ci        | ucs2     | 132 |         | Yes      |       8 |
| ucs2_polish_ci           | ucs2     | 133 |         | Yes      |       8 |
| ucs2_estonian_ci         | ucs2     | 134 |         | Yes      |       8 |
| ucs2_spanish_ci          | ucs2     | 135 |         | Yes      |       8 |
| ucs2_swedish_ci          | ucs2     | 136 |         | Yes      |       8 |
| ucs2_turkish_ci          | ucs2     | 137 |         | Yes      |       8 |
| ucs2_czech_ci            | ucs2     | 138 |         | Yes      |       8 |
| ucs2_danish_ci           | ucs2     | 139 |         | Yes      |       8 |
| ucs2_lithuanian_ci       | ucs2     | 140 |         | Yes      |       8 |
| ucs2_slovak_ci           | ucs2     | 141 |         | Yes      |       8 |
| ucs2_spanish2_ci         | ucs2     | 142 |         | Yes      |       8 |
| ucs2_roman_ci            | ucs2     | 143 |         | Yes      |       8 |
| ucs2_persian_ci          | ucs2     | 144 |         | Yes      |       8 |
| ucs2_esperanto_ci        | ucs2     | 145 |         | Yes      |       8 |
| ucs2_hungarian_ci        | ucs2     | 146 |         | Yes      |       8 |
| ucs2_sinhala_ci          | ucs2     | 147 |         | Yes      |       8 |
| ucs2_general_mysql500_ci | ucs2     | 159 |         | Yes      |       1 |
| cp866_general_ci         | cp866    |  36 | Yes     | Yes      |       1 |
| cp866_bin                | cp866    |  68 |         | Yes      |       1 |
| keybcs2_general_ci       | keybcs2  |  37 | Yes     | Yes      |       1 |
| keybcs2_bin              | keybcs2  |  73 |         | Yes      |       1 |
| macce_general_ci         | macce    |  38 | Yes     | Yes      |       1 |
| macce_bin                | macce    |  43 |         | Yes      |       1 |
| macroman_general_ci      | macroman |  39 | Yes     | Yes      |       1 |
| macroman_bin             | macroman |  53 |         | Yes      |       1 |
| cp852_general_ci         | cp852    |  40 | Yes     | Yes      |       1 |
| cp852_bin                | cp852    |  81 |         | Yes      |       1 |
| latin7_estonian_cs       | latin7   |  20 |         | Yes      |       1 |
| latin7_general_ci        | latin7   |  41 | Yes     | Yes      |       1 |
| latin7_general_cs        | latin7   |  42 |         | Yes      |       1 |
| latin7_bin               | latin7   |  79 |         | Yes      |       1 |
| utf8mb4_general_ci       | utf8mb4  |  45 | Yes     | Yes      |       1 |
| utf8mb4_bin              | utf8mb4  |  46 |         | Yes      |       1 |
| utf8mb4_unicode_ci       | utf8mb4  | 224 |         | Yes      |       8 |
| utf8mb4_icelandic_ci     | utf8mb4  | 225 |         | Yes      |       8 |
| utf8mb4_latvian_ci       | utf8mb4  | 226 |         | Yes      |       8 |
| utf8mb4_romanian_ci      | utf8mb4  | 227 |         | Yes      |       8 |
| utf8mb4_slovenian_ci     | utf8mb4  | 228 |         | Yes      |       8 |
| utf8mb4_polish_ci        | utf8mb4  | 229 |         | Yes      |       8 |
| utf8mb4_estonian_ci      | utf8mb4  | 230 |         | Yes      |       8 |
| utf8mb4_spanish_ci       | utf8mb4  | 231 |         | Yes      |       8 |
| utf8mb4_swedish_ci       | utf8mb4  | 232 |         | Yes      |       8 |
| utf8mb4_turkish_ci       | utf8mb4  | 233 |         | Yes      |       8 |
| utf8mb4_czech_ci         | utf8mb4  | 234 |         | Yes      |       8 |
| utf8mb4_danish_ci        | utf8mb4  | 235 |         | Yes      |       8 |
| utf8mb4_lithuanian_ci    | utf8mb4  | 236 |         | Yes      |       8 |
| utf8mb4_slovak_ci        | utf8mb4  | 237 |         | Yes      |       8 |
| utf8mb4_spanish2_ci      | utf8mb4  | 238 |         | Yes      |       8 |
| utf8mb4_roman_ci         | utf8mb4  | 239 |         | Yes      |       8 |
| utf8mb4_persian_ci       | utf8mb4  | 240 |         | Yes      |       8 |
| utf8mb4_esperanto_ci     | utf8mb4  | 241 |         | Yes      |       8 |
| utf8mb4_hungarian_ci     | utf8mb4  | 242 |         | Yes      |       8 |
| utf8mb4_sinhala_ci       | utf8mb4  | 243 |         | Yes      |       8 |
| cp1251_bulgarian_ci      | cp1251   |  14 |         | Yes      |       1 |
| cp1251_ukrainian_ci      | cp1251   |  23 |         | Yes      |       1 |
| cp1251_bin               | cp1251   |  50 |         | Yes      |       1 |
| cp1251_general_ci        | cp1251   |  51 | Yes     | Yes      |       1 |
| cp1251_general_cs        | cp1251   |  52 |         | Yes      |       1 |
| utf16_general_ci         | utf16    |  54 | Yes     | Yes      |       1 |
| utf16_bin                | utf16    |  55 |         | Yes      |       1 |
| utf16_unicode_ci         | utf16    | 101 |         | Yes      |       8 |
| utf16_icelandic_ci       | utf16    | 102 |         | Yes      |       8 |
| utf16_latvian_ci         | utf16    | 103 |         | Yes      |       8 |
| utf16_romanian_ci        | utf16    | 104 |         | Yes      |       8 |
| utf16_slovenian_ci       | utf16    | 105 |         | Yes      |       8 |
| utf16_polish_ci          | utf16    | 106 |         | Yes      |       8 |
| utf16_estonian_ci        | utf16    | 107 |         | Yes      |       8 |
| utf16_spanish_ci         | utf16    | 108 |         | Yes      |       8 |
| utf16_swedish_ci         | utf16    | 109 |         | Yes      |       8 |
| utf16_turkish_ci         | utf16    | 110 |         | Yes      |       8 |
| utf16_czech_ci           | utf16    | 111 |         | Yes      |       8 |
| utf16_danish_ci          | utf16    | 112 |         | Yes      |       8 |
| utf16_lithuanian_ci      | utf16    | 113 |         | Yes      |       8 |
| utf16_slovak_ci          | utf16    | 114 |         | Yes      |       8 |
| utf16_spanish2_ci        | utf16    | 115 |         | Yes      |       8 |
| utf16_roman_ci           | utf16    | 116 |         | Yes      |       8 |
| utf16_persian_ci         | utf16    | 117 |         | Yes      |       8 |
| utf16_esperanto_ci       | utf16    | 118 |         | Yes      |       8 |
| utf16_hungarian_ci       | utf16    | 119 |         | Yes      |       8 |
| utf16_sinhala_ci         | utf16    | 120 |         | Yes      |       8 |
| cp1256_general_ci        | cp1256   |  57 | Yes     | Yes      |       1 |
| cp1256_bin               | cp1256   |  67 |         | Yes      |       1 |
| cp1257_lithuanian_ci     | cp1257   |  29 |         | Yes      |       1 |
| cp1257_bin               | cp1257   |  58 |         | Yes      |       1 |
| cp1257_general_ci        | cp1257   |  59 | Yes     | Yes      |       1 |
| utf32_general_ci         | utf32    |  60 | Yes     | Yes      |       1 |
| utf32_bin                | utf32    |  61 |         | Yes      |       1 |
| utf32_unicode_ci         | utf32    | 160 |         | Yes      |       8 |
| utf32_icelandic_ci       | utf32    | 161 |         | Yes      |       8 |
| utf32_latvian_ci         | utf32    | 162 |         | Yes      |       8 |
| utf32_romanian_ci        | utf32    | 163 |         | Yes      |       8 |
| utf32_slovenian_ci       | utf32    | 164 |         | Yes      |       8 |
| utf32_polish_ci          | utf32    | 165 |         | Yes      |       8 |
| utf32_estonian_ci        | utf32    | 166 |         | Yes      |       8 |
| utf32_spanish_ci         | utf32    | 167 |         | Yes      |       8 |
| utf32_swedish_ci         | utf32    | 168 |         | Yes      |       8 |
| utf32_turkish_ci         | utf32    | 169 |         | Yes      |       8 |
| utf32_czech_ci           | utf32    | 170 |         | Yes      |       8 |
| utf32_danish_ci          | utf32    | 171 |         | Yes      |       8 |
| utf32_lithuanian_ci      | utf32    | 172 |         | Yes      |       8 |
| utf32_slovak_ci          | utf32    | 173 |         | Yes      |       8 |
| utf32_spanish2_ci        | utf32    | 174 |         | Yes      |       8 |
| utf32_roman_ci           | utf32    | 175 |         | Yes      |       8 |
| utf32_persian_ci         | utf32    | 176 |         | Yes      |       8 |
| utf32_esperanto_ci       | utf32    | 177 |         | Yes      |       8 |
| utf32_hungarian_ci       | utf32    | 178 |         | Yes      |       8 |
| utf32_sinhala_ci         | utf32    | 179 |         | Yes      |       8 |
| binary                   | binary   |  63 | Yes     | Yes      |       1 |
| geostd8_general_ci       | geostd8  |  92 | Yes     | Yes      |       1 |
| geostd8_bin              | geostd8  |  93 |         | Yes      |       1 |
| cp932_japanese_ci        | cp932    |  95 | Yes     | Yes      |       1 |
| cp932_bin                | cp932    |  96 |         | Yes      |       1 |
| eucjpms_japanese_ci      | eucjpms  |  97 | Yes     | Yes      |       1 |
| eucjpms_bin              | eucjpms  |  98 |         | Yes      |       1 |
+--------------------------+----------+-----+---------+----------+---------+
197 rows in set (0.00 sec)

##mysql的SQL模型：
违反了SQL规定时进行SQL的模型设置
mysql觉的mysql模型：
	1. ANSI QUOTES
	2. IGNORE_SPACE
	3. STRICT_ALL_TABLES
	4. STRICT_TRANS_TABLES
	5. TRADITIONAL
mysql> show global variables like 'sql_mode'; #查看服务器模型
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| sql_mode      |       |
+---------------+-------+
1 row in set (0.00 sec)

MYSQL服务器变量：
	作用域：
	1. 全局变量 #服务一启动时启动，show global variables; 
	2. 会话变量  #用户连入mysql时设置的变量，当连接断掉时会话变量也会断掉, show [session] variables;
#注意：全局变量和会话变量类似/etc/my.cnf和~/.my.cnf，后者可覆盖前者
生效时间分为两类：
	动态：可即时修改，即时生效。
	静态：写在配置文件中，有的不能写在配置文件时通过参数传递给mysqld或mysql_safe
动态调整参数的生效方式：
	全局变量：对当前会话无效，只对新建立会话生效，类似/etc/profile一样，重新建立shell才生效
	会话变量：即时生效，但只对当前会话有效。会话断掉即失效。
#注：默认会话变量从全局变量继承的

服务器变量：@@变量名
	显示：select
	设定：set global|session 变量名='value'


mysql> select  @@global.sql_mode; #查看全局变量mysql的mode
+-------------------+
| @@global.sql_mode |
+-------------------+
|                   |
+-------------------+
1 row in set (0.00 sec)
mysql> set global sql_mode='strict_all_tables'; #设置全局变量mode
Query OK, 0 rows affected (0.01 sec)

mysql> select @@global.sql_mode; 查看全局变量mode
+-------------------+
| @@global.sql_mode |
+-------------------+
| STRICT_ALL_TABLES |
+-------------------+
1 row in set (0.00 sec)
mysql> select @@sql_mode;
+------------+
| @@sql_mode |
+------------+
|            |
+------------+
1 row in set (0.00 sec)
#注：全局变量只对下次登入时生效，对当前会话不生效。局部变量对当前会话生效，会话断掉时失效。

#第六节：MYSQL管理表和索引
#新建数据库：
help create database #获取帮助信息
mysql> create schema students character set 'utf8' collate utf8_general_ci;
Query OK, 1 row affected (0.49 sec)
alter database  #修改数据库
drop database  #删除数据库
#新建表：
1. 直接定义一张空表
2. 从其它表中查询出数据，并以之创建新表
3. 以其它表为模板创建一个空表
help create table  #获取帮助信息
create table courses(CID TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,Couse VARCHAR(50) NOT NULL，Age TINYINT,PRIMARY KEY(CID),UNIQUE KEY(Course),INDEX(Age)); #另外一种设立主键方法
#键也称为约束，可用作索引，属于特殊索引（有特殊限定）：是BTree结构，另外一种结构为HASH
#第一种创建表的方法
mysql> create table courses(CID TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,Couse VARCHAR(50) NOT NULL); #新建表
Query OK, 0 rows affected (0.20 sec)
mysql> show table status from students like 'courses'\G; #查看表状态
*************************** 1. row ***************************
           Name: courses
         Engine: InnoDB #不指定存储引擎默认从数据库继承
        Version: 10
     Row_format: Compact
           Rows: 0
 Avg_row_length: 0
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 1
    Create_time: 2019-06-19 22:31:48
    Update_time: NULL
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)
mysql> drop table courses; #删除表
Query OK, 0 rows affected (0.02 sec)

mysql> create table courses(CID TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,Couse VARCHAR(50) NOT NULL)ENGINE MyISAM; #新建表并设立存储引擎MyISAM
Query OK, 0 rows affected (0.04 sec)
mysql> show table status like 'courses'\G';
*************************** 1. row ***************************
           Name: courses
         Engine: MyISAM #MyISAM存储引擎
        Version: 10
     Row_format: Dynamic
           Rows: 0
 Avg_row_length: 0
    Data_length: 0
Max_data_length: 281474976710655
   Index_length: 1024
      Data_free: 0
 Auto_increment: 1
    Create_time: 2019-06-19 22:34:32
    Update_time: 2019-06-19 22:34:32
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)
mysql> insert into courses (Couse) value ('hamagong'),('pixiejianfa'),('kuihuabaodian');
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0
mysql> select * from courses;
+-----+---------------+
| CID | Couse         |
+-----+---------------+
|   1 | hamagong      |
|   2 | pixiejianfa   |
|   3 | kuihuabaodian |
+-----+---------------+
3 rows in set (0.00 sec)

mysql> show index from courses; #显示表的索引
+---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table   | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| courses |          0 | PRIMARY  |            1 | CID         | A         |           3 |     NULL | NULL   |      | BTREE      |         |               |
+---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
                                                  #CID为索引
1 row in set (0.00 sec)  
#第二种创建表的方法
mysql> create table testcourses select * from courses where CID <= 3;
Query OK, 3 rows affected (0.33 sec) #复制表
mysql> desc testcourses; #通过查询新建的表表结构也会发生改变
+-------+---------------------+------+-----+---------+-------+
| Field | Type                | Null | Key | Default | Extra |
+-------+---------------------+------+-----+---------+-------+
| CID   | tinyint(3) unsigned | NO   |     | 0       |       |
| Couse | varchar(50)         | NO   |     | NULL    |       |
+-------+---------------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> desc courses;
+-------+---------------------+------+-----+---------+----------------+
| Field | Type                | Null | Key | Default | Extra          |
+-------+---------------------+------+-----+---------+----------------+
| CID   | tinyint(3) unsigned | NO   | PRI | NULL    | auto_increment |
| Couse | varchar(50)         | NO   |     | NULL    |                |
+-------+---------------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)
#第三种创建表的方法
mysql> create table test like courses; #复制表的结构为空表
Query OK, 0 rows affected (0.04 sec)

mysql> desc courses;
+-------+---------------------+------+-----+---------+----------------+
| Field | Type                | Null | Key | Default | Extra          |
+-------+---------------------+------+-----+---------+----------------+
| CID   | tinyint(3) unsigned | NO   | PRI | NULL    | auto_increment |
| Couse | varchar(50)         | NO   |     | NULL    |                |
+-------+---------------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

mysql> desc test;
+-------+---------------------+------+-----+---------+----------------+
| Field | Type                | Null | Key | Default | Extra          |
+-------+---------------------+------+-----+---------+----------------+
| CID   | tinyint(3) unsigned | NO   | PRI | NULL    | auto_increment |
| Couse | varchar(50)         | NO   |     | NULL    |                |
+-------+---------------------+------+-----+---------+----------------+
2 rows in set (0.01 sec)

mysql> insert into test select * from courses; #复制表数据
Query OK, 3 rows affected (0.00 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from courses;
+-----+---------------+
| CID | Couse         |
+-----+---------------+
|   1 | hamagong      |
|   2 | pixiejianfa   |
|   3 | kuihuabaodian |
+-----+---------------+
3 rows in set (0.00 sec)

mysql> select * from test;
+-----+---------------+
| CID | Couse         |
+-----+---------------+
|   1 | hamagong      |
|   2 | pixiejianfa   |
|   3 | kuihuabaodian |
+-----+---------------+
3 rows in set (0.00 sec)


</pre>