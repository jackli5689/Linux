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
#ALTER修改表
help alter table #查看修改帮助
BTREE索引和HASH索引对表查询优化有很大影响
mysql> create table student(SID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,Name varchar(30) NOT NULL,CID TINYINT unsigned NOT NULL);
Query OK, 0 rows affected (0.33 sec)
mysql> desc courses;
+-------+---------------------+------+-----+---------+----------------+
| Field | Type                | Null | Key | Default | Extra          |
+-------+---------------------+------+-----+---------+----------------+
| CID   | tinyint(3) unsigned | NO   | PRI | NULL    | auto_increment |
| Couse | varchar(50)         | NO   |     | NULL    |                |
+-------+---------------------+------+-----+---------+----------------+
2 rows in set (0.00 sec)

mysql> desc student;
+-------+---------------------+------+-----+---------+----------------+
| Field | Type                | Null | Key | Default | Extra          |
+-------+---------------------+------+-----+---------+----------------+
| SID   | int(10) unsigned    | NO   | PRI | NULL    | auto_increment |
| CID   | tinyint(3) unsigned | NO   | MUL | NULL    |                |
| name  | varchar(30)         | NO   |     | NULL    |                |
+-------+---------------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)
mysql> insert into student (Name,CID) values ('zwj',2),('lhc',3);
mysql> select * from student;
+-----+-----+------+
| SID | CID | name |
+-----+-----+------+
|   1 |   2 | zwj  |
|   2 |   3 | lhc  |
+-----+-----+------+
2 rows in set (0.00 sec)

mysql> select Name,Couse from courses,student where courses.CID=student.CID;  #多表查询
+------+---------------+
| Name | Couse         |
+------+---------------+
| zwj  | pixiejianfa   |
| lhc  | kuihuabaodian |
+------+---------------+
2 rows in set (0.01 sec)
mysql> insert into student (Name,CID) values ('zhangwuji',5); #现在这个student表没有外键约束所以可以插入主表中没有的CID
Query OK, 1 row affected (0.05 sec)
#建立外键：
mysql> alter table student add FOREIGN KEY(CID) REFERENCES courses(CID) ;  #插入外键时报错，原因在于外键不允许在InnoDB外的存储引擎上使用
ERROR 1005 (HY000): Can't create table 'students.#sql-63d8_9' (errno: 150)
mysql> show table status like 'student'\G;
*************************** 1. row ***************************
           Name: student
         Engine: InnoDB
        Version: 10
     Row_format: Compact
           Rows: 3
 Avg_row_length: 5461
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: NULL
    Create_time: 2019-06-20 08:56:54
    Update_time: NULL
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)

ERROR: 
No query specified

mysql> show table status like 'courses'\G;
*************************** 1. row ***************************
           Name: courses
         Engine: MyISAM   #因为主键表是MyISAM存储引擎的
        Version: 10
     Row_format: Dynamic
           Rows: 3
 Avg_row_length: 20
    Data_length: 60
Max_data_length: 281474976710655
   Index_length: 2048
      Data_free: 0
 Auto_increment: 4
    Create_time: 2019-06-19 22:34:32
    Update_time: 2019-06-19 22:45:38
     Check_time: NULL
      Collation: utf8_general_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)

ERROR: 
No query specified
mysql> alter table courses ENGINE=InnoDB; #更改表存储引擎
Query OK, 3 rows affected (0.22 sec)
Records: 3  Duplicates: 0  Warnings: 0
mysql> alter table student add FOREIGN KEY foreign_id (CID) REFERENCES courses (CID) ; 
Query OK, 2 rows affected (0.51 sec)
Records: 2  Duplicates: 0  Warnings: 0
mysql> insert into student (Name,CID) values ('zhangwuji',6); #此时报错，因为有外键限制
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`students`.`student`, CONSTRAINT `student_ibfk_1` FOREIGN KEY (`CID`) REFERENCES `courses` (`CID`))
mysql> insert into student (Name,CID) values ('zhangwuji',1); #这个主键有，所以成功
Query OK, 1 row affected (0.06 sec)

#索引：
索引只能增加、查询、删除，不能修改索引。
mysql> show indexes from student;
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table   | Non_unique | Key_name   | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| student |          0 | PRIMARY    |            1 | SID         | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
| student |          1 | foreign_id |            1 | CID         | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
+---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
2 rows in set (0.00 sec)
mysql> create index name_on_student on student (name) using btree; #新建索引并使用btree索引，默认是btree索引，可以省略不写
Query OK, 0 rows affected (0.23 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show indexes from student;
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table   | Non_unique | Key_name        | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| student |          0 | PRIMARY         |            1 | SID         | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
| student |          1 | foreign_id      |            1 | CID         | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
| student |          1 | name_on_student |            1 | name        | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
+---------+------------+-----------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.00 sec)
mysql> drop index name_on_student on student; #删除索引
Query OK, 0 rows affected (0.27 sec)
Records: 0  Duplicates: 0  Warnings: 0
mysql> create index name_on_student on student (name(5) desc) using btree; #新建索引并且只引用从左到右五位，后面的不参加索引，可能节约资源有很大帮助，desc是降序，asc是升序。
Query OK, 0 rows affected (0.09 sec)
Records: 0  Duplicates: 0  Warnings: 0

#第七节：单表查询、多表查询和子查询
查询语句类型：
	1. 简单查询
	2. 多表查询
	3. 子查询
select语句：投影、选择、别名
SELECT DISTINCT Gender FROM students;  #Gender中有好多M和F行，这条语句查出来结果只显示两行，一行为M一行为F，只显示不同行的,去重

#简单查询
FROM子句：要查询的关系，可以是表、多个表、其它SELECT语句
WHERE子句：布尔关系表达式，判断是否的，=、>、>=、<、<=、<>|!=、<=>  #<=>是对空值时运行比较的，而<>|!=是对所有数据进行比较的
逻辑关系：AND,OR,NOT，BETWEEN，LIKE(_单个字符，%任意字符),REGEXP|RLIKE(正则表达式)，IN，IS NULL|NOT NULL,AS，LIMIT
排序：ORDER BY field_name {ASC|DESC} #默认是ASC升序
聚合：AVG(age),MAX(age),MIN(age),SUM(age),COUNT(age),
分组：GROUP BY，，HAVING(对使用分组的语句最后再进行一次筛选)

##SELECT语句样例：
SELECT Name,Age FROM students WHERE Age<=25 AND Age>=20; #查询20到25的用户
SELECT Name,Age FROM students WHERE Age BETWEEN 20 AND 25; #查询20到25之间
SELECT Name FROM students WHERE Name LIKE '%ing%' #模糊搜索
SELECT Name FROM students WHERE Name RLIKE '^[XP].*$'; #以正则表达式模糊搜索
SELECT Name FROM students WHERE Age IN (18,20,25); #查找年龄为18，20，25的用户
SELECT Name FROM students WHERE CID2 IS NULL; #查询课程2为家的用户
SELECT Name FROM students WHERE CID2 IS NULL ORDER BY Name DESC; #降序排序
SELECT Name AS Student_Name FROM students; #将显示的字段Name重合名为Student_Name
SELECT Name FROM students LIMIT 2; #显示前两行
SELECT Name FROM students LIMIT 2，3;  #从最前面偏移两个，第三个开始显示3行
SELECT Avg(Age) FROM students GROUP BY Gender; #先对Gender进行分组，然后对每个分组进行求平均值
SELECT COUNT(CID1) AS Persons,CID1 FROM students GROUP BY CID1 HAVING Persons>=2; #查找分组CID1课程的每门人数，并最后使用HAVING进行筛选大于等于2个人的，也可以在关联查询中使用别名进行查询

mysql> SELECT 2+1;
+-----+
| 2+1 |
+-----+
|   3 |
+-----+
mysql> SELECT 2+1 AS sum;
+-----+
| sum |
+-----+
|   3 |
+-----+

#复合查询或多表查询：
多表查询：
	连接：
		1. 交叉连接：笛卡尔乘积（不会这样使用）
		2. 自然连接：建立主外键关系进行查询，有的才显示，没有的不显示
		3. 外连接：有的显示值，没有的显示NULL，建立在自然连接基础之上
			1. 左外连接：... LEFT JOIN ... ON ... #省略号依次为左表，右表，条件，以左表为基准
			2. 右外连接：... RIGHT JOIN ... ON ...#省略号依次为左表，右表，条件，在名表为基准
		4. 自连接：对同一张表当作两张表进行查询

SELECT s.Name,c.Cname FROM students AS s,courses AS c WHERE s.CID1=c.CID; #自然连接并给表取别名
SELEECT s.Name,c.Cname FROM students AS s LEFT JOIN courses AS c ON s.CID1=c.CID;  #左外连接，以左表为基准，右表有值的显示，无值的也显示，显示为NULL
SELEECT s.Name,c.Cname FROM students AS s RIGHT JOIN courses AS c ON s.CID1=c.CID;  #右外连接，以右表为基准，左表有值的显示，无值的也显示，显示为NULL
SELECT c.Name AS student,s.Name AS tearcher FROM students AS c,student AS c WHERE c.TID=s.SID; #自连接

#子查询：
子查询：比较操作中使用时只能返回单个值
IN():在IN中使用子查询
在FROM中使用子查询
例：
SELECT Name FROM students WHERE Age > (SELECT AVG(Age) FROM students); #子查询，查询年龄大于平均年龄的用户
SELECT Name FROM students WHERE Age IN (SELECT Age FROM students);
SELECT Name,Age FROM (SELECT Name,Age FROM students) AS t WHERE t.Age >= 20; #将子查询看作一张临时表

#联合查询：UNION关键字
（SELECT Name,Age FROM students) UNION (SELECT Tname,Age FROM tutors); #联合查询

#第八节：多表查询、子查询及视图
SELECT Tname FROM tutors WHERE TID NOT IN (SELECT DISTINCT TID FROM courses); #从tutors表找出TID不在courses表上的老师名
SELECT CID1 FROM students GROUP BY CID1 HAVING COUNT(CID11) >=2; #找出学习的课程大于等于2的CID1
SELECT Cname FROM courses WHERE CID IN (SELECT CID1 FROM students GROUP BY CID1 HAVING COUNT(CID1) >=2); #对找出大于等于2的CID1进行显示课程名称
SELECT Name,Cname,Tname FROM students,courses,tutors WHERE students.CID1=courses.CID AND courses.TID=tutors.TID; #从学生表，老师表，课程表中查询每个学生所学的课以及对应的老师


#视图：存储下来的SELECT语句
help create view #获取新建视图帮助
CREATE VIEW sct AS SELECT Name,Cname,Tname FROM students,courses,tutors WHERE students.CID1=courses.CID AND courses.TID=tutors.TID; #新建视图为sct,视图结果为AS后面的查询结果
SHOW TABLES;  #这时可以查看新建下来的视图sct,会变成一张表存储
物化视图：将视图保存在文件中，但是在基表上插入数据时物化视图不会更新，所以在不常变的视图上才物化视图。
注：一般不允许在视图上插入数据，可以在基表上插入数据，此时视图会跟着改变，但只做为临时表用。所以会比较慢，在mysql上一般不用，只在安全需要时会筛选特定字段展示给用户。mysql视图上不能许使用索引，mysql不支持物化视图。
SHOW CREATE VIEW sct;  #查看视图sct创建时使用了什么语句
SHOW CREATE TABLE courses; #查看表创建时使用了什么样的语句

mysql -e 'CREATE DATABASE edb;'  #在bash上新建数据库，-e选项
mysql -e 'SHOW DATABASES;'  #在bash上查看数据库

#第九节：MYSQL事务与隔离级别
广义查询：SELECT,INSERT,UPDATE,DELETE
insert批量插入会提高性能的
字符串：单引号
数据弄：不需要引号
日期和时间：不需要引号
空值：NULL
auto_increment自增长，在表中删除某些行，计数器不会填补删除的空行数据，而是继续使用之前的顺序新增，除非你更改LAST_INSERT_ID()值。

#insert:
insert into students (col1,col2,...) value (val1,val2,...);#批量插入
insert into students set Tname='tom',Age=16; #特定插入
insert into students (col1,col2,...) select  #查询插入
#replace:跟insert语句一样，表示未有数据和有数据时都使用，而insert插入数据有约束时不会插入

#delete
例：DELETE FROM tb_name WHERE condition;
mysql有内部参数可以限制delete from tb_name 和 update tb_name set cou=val 误操作的。
delete from tb_name #会删除表所有数据但不清空AUTOINCREMENT计数器
TRUNCATE tb_name:清空表并重置AUTOINCREMENT计数器;

#update
update tb_name set cou=val where ;

##mysql连接执行流程：
1. 连接管理器
2. 缓存管理器（只对查询有用，返回结果给用户），分析管理器(分析语句，如有查询则去缓存管理器取，无则去优化器优化语句)
3. 优化器
4. 执行引擎（执行语句）
5. 存储引擎（将语句解析为块语言）
注：mysql是明文的，密文需要借助ssl

并发控制：两个以上访问会出现并发控制
多版本并发控制:MVCC,数据库必备的功能

锁：
	读锁：共享锁
	写锁：独占锁
		LOCK TABLES tb_name READ|WRITE
		UNLOCK TABLES
锁粒度：从大到小，MYSQL服务器仅支持表级锁，行锁需要存储引擎完成
	表锁：锁定一个表
	页锁：mysql存储是分页的
	行锁：锁定一行
注：mysql自己内部会处理锁，我们不用人为去加锁，只是使用温备份时才加锁。
mysql> lock tables student read; #会话1为表student加共享锁
Query OK, 0 rows affected (0.00 sec)
mysql> select * from student; #会话2可读
+-----+------+------+
| SID | CID  | name |
+-----+------+------+
|   1 |    2 | zwj  |
|   2 |    3 | lhc  |
|   8 |    1 | tom  |
|   9 |   10 | jack |
+-----+------+------+
4 rows in set (0.00 sec)
mysql> insert student (CID,name) values (11,'candy'); #此会会话2插入数据时会卡住，等待锁释放后才可插入

mysql> unlock tables; #会话1解除锁
Query OK, 0 rows affected (0.00 sec)
mysql> insert student (CID,name) values (11,'candy'); #此时才插入成功，耗时44秒
Query OK, 1 row affected (44.01 sec)

#####事务
RDBMS: ACID(原子性，一致性，隔离性，持久性) #支持事务必须支持这4个特性
		Automicity,Consistency,Isolation,Durability
事务日志：
	1. 重做日志  #叫redo log
	2. 撤销日志  #叫undo log
事务流程：
 1. 提交事务
 2. 写入事务日志 #当提交事务全部操作未完全写入事务日志时，mysql服务重新启动时会读取撤销日志进行撤销，否则会写入数据库。
 3. 写入数据库 #当写入数据库操作服务崩溃时，mysql服务重新启用后会读取重做日志进行重新写入数据库
注：事务日志不是越大越好，越大表示同步到磁盘越慢
隔离性：
	隔离级别：
		READ-UNCOMMITTED   #读未提交，最低隔离级别
		READ-COMMITTED    #读提交
		REPEATABLE-READ   #可重读（默认隔离级别）
		SERIABLIZABLE    #可串行
mysql> show global variables like '%iso%'; #查看mysql隔离级别
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.00 sec)

服务器变量：
	全局变量(global)：
		对全局生效，新建会话时才生效
	会话变量（session）：
		对当前会话生效，立即生效
	注：但重启服务后失败，要想永久生效必须写入文件
mysql> show global variables like '%iso%'; #全局变量默认级别
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.00 sec)
mysql> show variables like '%iso%'; #会话变量默认级别
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.01 sec)
mysql> set tx_isolation='READ-UNCOMMITTED'; #设置隔离级别
Query OK, 0 rows affected (0.00 sec)
mysql> show variables like '%iso%'; #不知道全名时可使用show进行展示
+---------------+------------------+
| Variable_name | Value            |
+---------------+------------------+
| tx_isolation  | READ-UNCOMMITTED |
+---------------+------------------+
1 row in set (0.00 sec)
mysql> select @@tx_isolation; #知道全名时可用select展示
+------------------+
| @@tx_isolation   |
+------------------+
| READ-UNCOMMITTED |
+------------------+
1 row in set (0.00 sec)


#第十节：事务和隔离级别
RDBMS: ACID(原子性，一致性，隔离性，持久性)
	Automicity 原子性：事务所引起的数据库操作，要么都完成，要么都不执行
	Consistency 一致性：两都事务前后状态一致
	Isolation 隔离性：
					事务调度：事务之间影响最小
					MVCC:多版本并发控制
	Durability 持久性：一旦事务成功完成，系统必须保证任何故障都不会引起事务表示出不一致性
		1. 事务提交之前就已经写出数据至持久性存储
		2. 结合事务日志完成
			1. 事务日志：写入时是顺序IO
			2. 数据文件：写入时是随机IO
事务的状态：
	1. 活动的：active
	2. 部分提交的：最后一条语句执行后部分已经提交成功的
	3. 失败的
	4. 中止的
	5. 提交的
事务允许并发执行：
	1. 提高吞吐量和资源利用率
	2. 减少等待时间
事务调度：	
	1. 可恢复调度
	2. 无级联调度
调度级别：
	1. READ-UNCOMMITTED #读未提交
	2. READ-COMMITTED #读提交
	3. REPEATABLE-READ #可重读  MYSQL默认这个，大多数RDBMS是第2个读提交
	4. SERIALIZABLE #可串行
并发控制依赖的技术手段：
	1. 锁
	2. 时间戳
	3. 多版本和快照隔离



SQL语句或者ODBC的命令 
START TRANSACTION  #启动事务
	SQL 1
	SQL 2 
	......
COMMIT  #提交事务，使用事务日志的重做日志进行写入持久存储设备
ROLLBACK  #未提交事务前可使用此命令进行回滚撤销，使用事务日志的撤销日志进行回滚
mysql> select @@autocommit; #如果没有明确启动事务，自动提交是开启的
+--------------+
| @@autocommit |
+--------------+
|            1 |
+--------------+
1 row in set (0.00 sec)
建议：在事务性数据库上，手动明确使用事务，并且关闭自动提交，这样可以减少数据库io的
mysql> set autocommit=0； #此时关闭自动提交功能，在使用select语句后需要使用commit提交才可写入持久性存储
mysql> set global autocommit=0; #这个是设置全局变量的自动提交 
Query OK, 0 rows affected (0.00 sec)
mysql> select @@autocommit;
+--------------+
| @@autocommit |
+--------------+
|            0 |
+--------------+
1 row in set (0.00 sec)

保存点：SAVEPOINT  #在事务中使用
SAVEPOINT a; #建立一个保存点
ROLLBACK TO a;  #回滚到保存点a
例：
mysql> select * from student;
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   1 |    2 | zwj   |
|   2 |    3 | lhc   |
|   8 |    1 | tom   |
|   9 |   10 | jack  |
|  10 |   11 | candy |
+-----+------+-------+
5 rows in set (0.00 sec)
mysql> select @@autocommit;
+--------------+
| @@autocommit |
+--------------+
|            0 |
+--------------+
1 row in set (0.00 sec)

mysql> delete from student where SID=10;
Query OK, 1 row affected (0.00 sec)

mysql> savepoint a;
Query OK, 0 rows affected (0.00 sec)

mysql> delete from student where SID=9;
Query OK, 1 row affected (0.00 sec)

mysql> savepoint b;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from student;
+-----+------+------+
| SID | CID  | name |
+-----+------+------+
|   1 |    2 | zwj  |
|   2 |    3 | lhc  |
|   8 |    1 | tom  |
+-----+------+------+
3 rows in set (0.00 sec)
mysql> rollback to a;  #回滚到某个保存点
Query OK, 0 rows affected (0.00 sec)

mysql> select * from student;
+-----+------+------+
| SID | CID  | name |
+-----+------+------+
|   1 |    2 | zwj  |
|   2 |    3 | lhc  |
|   8 |    1 | tom  |
|   9 |   10 | jack |
+-----+------+------+
4 rows in set (0.00 sec)

####验证隔离级别：
先启动两个mysql会话：
1. SET tx_isolation=READ-UNCOMMITTED(读未提交);两个会话隔离性都为读未提交时，当一个会话启动事务进行增删改操作时，未使用COMMIT提交，另外一个会话也会看到同样的结果，这就是读未提交隔离的效果。但是会产生幻影问题
2. SET tx_isolation=READ-COMMITTED(读提交);两个会话隔离性都为读提交时，当一个会话启动事务进行增删改操作时，使用COMMIT提交，另外一个会话也会看到同样的结果，这就是读提交隔离的效果。如果未提交则另外一个会话看不到改变的数据，但是会产生幻影问题
3. SET tx_isolation=REPEATABLE-READ(可重读);两个会话隔离性都为可重读时，当一个会话启动事务进行增删改操作时，使用COMMIT提交，另外一个会话不会看到同样的结果，此时另外一个会话看到的一直都是另外会话自己看到的结果，当另外一个会话也COMMIT时才会看到当前同样的结果，这就是可重读隔离的效果。但是会产生幻影问题
4. SET tx_isolation=SEREALABLE(可串行);两个会话隔离性都为可串行时，当一个会话启动事务进行增删改操作时，未使用COMMIT提交，另外一个会话查询时不会有任何结果显示且会卡住查询会话，当当前会话COMMIT时，另外一个会话查询才会有结果显示。
#注：如果不是银行证券行业，可以适当降低隔离级别，提升性能是相当明显的

#第十一节：MYSQL用户和权限管理
用户：只是认证
权限：是用来授权用户访问数据库的权限

#mysqld服务启动时会加载mysql数据库中user,db,tables_priv,columns_priv,procs_priv,proxies_priv6张表并生成一张授权表到内存当中。
user表：用户帐号、全局权限 
db表：库级别权限
tables_priv表：表级别权限
columns_priv表：列级别权限 
procs_priv：存储过程和存储函数相关的权限 
proxies+_priv:代理用户权限

#用户帐号：用户名@主机	
权限级别：
	1. 全局级别：super(可查看设置全局变量的权限)
	2. 库：
	3. 表：delete,alter
	4. 列：select,insert,update
	5. 存储过程和存储函数

临时表：存储在内存中，执行快，heap:16M大小 
触发器：主动数据库，在mysql上执行某些操作时触发另外一个动作的
--skip-grant-tables --skip-networking#跳过授权表,并且关闭网络连接
--skip-name-resolve #跳过名称解析

create user jack@'%' identified by '123';这个命令新建用户mysql自动触发刷新特权表
mysql> show grants for jack@"%"; #查看某个用户权限，这个用户默认只有usage权限
+-----------------------------------------------------------------------------------------------------+
| Grants for jack@%                                                                                   |
+-----------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'jack'@'%' IDENTIFIED BY PASSWORD '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257' |
+-----------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

GRANT ALL PRIVILEGES ON [object_type] db.* TO username@'%'; #[object_type]：TABLE,FUNCTION,PROCEDURE
GRANT EXECUTE ON FUNCTION db.abc TO username@'%'; #授权db.abc存储函数执行权限给某个用户。
with_option:
    GRANT OPTION  #可以把权限授权给其他用户的权限 
  | MAX_QUERIES_PER_HOUR count  #每小时最大查询数，为0则为不限制，其大正数为限定值，下面也一样
  | MAX_UPDATES_PER_HOUR count  #每小时最大更新数
  | MAX_CONNECTIONS_PER_HOUR count #每小时用户最大连接数
  | MAX_USER_CONNECTIONS count #用户最大连接数

GRANT UPDATE(Age) ON db.abc TO username@'%'; #授权更新某个表某个字段权限给用户
#REVOKE
REVOKE SELECT ON cactidb.* FROM cactiuser@'%';
##找回root密码：在mysql脚本中编辑启动脚本段，设置启动mysql_safe时传递两个参数 --skip-grant-tables --skip-networking ，也可在/etc/my.cnf中[mysqld]字段写入，然后启动mysqld服务，update user表更改密码，关闭mysqld服务，删除刚刚设置的 --skip-grant-tables --skip-networking两个参数，并重启服务即可。

#第十二节：MYSQL日志管理一
mysql> show global variables like '%log%';
#错误日志：log_warnings，log_error #默认开启的
	1. mysql服务器启动和关闭过程中的信息
	2. mysql服务器运行过程中的错误信息
	3. 事件调度器运行一个事件时产生的信息
	4. 在从服务器上启动从服务器进行时产生的信息
	
#一般查询日志：general_log，general_log_file，log,log_output[TABLE|FILE|NONE]可以设定在mysql表中，sql_log_off（用于控制是否禁止将一般查询日志类信息记录进查询日志文件）   #不建议开启
                          
#慢查询日志：long_query_time，log_slow_queries|slow_query_log，slow_query_log_file，log_output[TABLE|FILE|NONE] #建议开启，日志输出可以同时输出TABLE,FILE中
mysql> show global variables like '%long_quer%';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+

#二进制日志：任何引起或可能引起数据库变化的操作     #必须开启
	binlog_format=MIXED ，
	log_bin（设置日志开关并且设置二进制文件路径）
	 sql_log_bin（二进制日志文件开关，当以后恢复备份时需要临时把二进制日志文件关闭，完成后恢复）
	 binlog_cache_size(大小取决于binlog_stmt_cache_size)
	binlog_stmt_cache_size（二进制文件语句缓存大小）
	sync_binlog（设置对二进制每多少次写操作后同步一次，0表示不同步）
	expire_logs_days：设置二进制日志过期天数
	滚动记录日志，mysqld启动时也会滚动记录日志
	复制、即时点恢复：
	mysqlbinlog,查看二进制日志命令
	二进制日志的格式：
		基于语句：statement
		基于行：row
		混合方式：mixed
	二进制日志事件：
		产生的时间
		位置
	二进制日志文件：
		索引文件
		二进制日志文件
	查看当前正在使用的二进制日志文件：
	mysql> SHOW MASTER STATUS ;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000009 |  1132572 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
mysql> show binlog events in 'mysql-bin.000003';
+------------------+-----+-------------+-----------+-------------+---------------------------------------+
| Log_name         | Pos | Event_type  | Server_id | End_log_pos | Info                                  |
+------------------+-----+-------------+-----------+-------------+---------------------------------------+
| mysql-bin.000003 |   4 | Format_desc |         1 |         107 | Server ver: 5.5.37-log, Binlog ver: 4 |
| mysql-bin.000003 | 107 | Stop        |         1 |         126 |                                       |
+------------------+-----+-------------+-----------+-------------+---------------------------------------+
2 rows in set (0.00 sec)
	SHOW BINLOG EVENTS IN 'mysql-bin.000009' [FROM pos]; #详细查看二进制日志文件事件的信息
	mysqlbinlog命令：
		--start-datetime 'yyyy-mm-dd hh:mm:ss'
		--stop-datetime 'yyyy-mm-dd hh:mm:ss'
		--start-position
		--stop-position
	[root@lnmp mydata]# mysqlbinlog --start-position=220554 --stop-position=223392 mysql-bin.000009 > /root/a.sql #查看起始位置到结束位置的日志并导出到sql脚本上，另外mysql数据库导入即可恢复
	mysql> flush logs; #滚动二进制日志和从服务器中继日志的命令
Query OK, 0 rows affected (0.00 sec)

mysql> show master status ;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000010 |      107 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
	mysql> show binary logs; #查看当前保存下来的二进制文件
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |     26636 |
| mysql-bin.000002 |   1069399 |
| mysql-bin.000003 |       126 |
| mysql-bin.000004 |       126 |
| mysql-bin.000005 |       737 |
| mysql-bin.000006 |       126 |
| mysql-bin.000007 |       126 |
| mysql-bin.000008 |       126 |
| mysql-bin.000009 |   1132615 |
| mysql-bin.000010 |       107 |
+------------------+-----------+
mysql> purge binary logs to 'mysql-bin.000003'; #删除指定日志文件以前所有的二进制日志文件
Query OK, 0 rows affected (0.01 sec)

mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000003 |       126 |
| mysql-bin.000004 |       126 |
| mysql-bin.000005 |       737 |
| mysql-bin.000006 |       126 |
| mysql-bin.000007 |       126 |
| mysql-bin.000008 |       126 |
| mysql-bin.000009 |   1132615 |
| mysql-bin.000010 |       107 |
+------------------+-----------+
8 rows in set (0.00 sec)
#中继日志：
#事务日志：ACIO，InnoD有事务日志

#任何变量涉及文件的操作必须重启服务器才能生效

mysql> show global variables like '%log%'; #查看全局所有log相关日志
+-----------------------------------------+---------------------------+
| Variable_name                           | Value                     |
+-----------------------------------------+---------------------------+
| back_log                                | 50                        |
| binlog_cache_size                       | 32768                     |
| binlog_direct_non_transactional_updates | OFF                       |
| binlog_format                           | MIXED                     |
| binlog_stmt_cache_size                  | 32768                     |
| expire_logs_days                        | 0                         |
| general_log                             | OFF                       |
| general_log_file                        | /mydata/lnmp.log          |
| innodb_flush_log_at_trx_commit          | 1                         |
| innodb_locks_unsafe_for_binlog          | OFF                       |
| innodb_log_buffer_size                  | 8388608                   |
| innodb_log_file_size                    | 5242880                   |
| innodb_log_files_in_group               | 2                         |
| innodb_log_group_home_dir               | ./                        |
| innodb_mirrored_log_groups              | 1                         |
| log                                     | OFF                       |
| log_bin                                 | ON                        |
| log_bin_trust_function_creators         | OFF                       |
| log_error                               | /mydata/lnmp.jack.com.err | #错误日志
| log_output                              | FILE                      |
| log_queries_not_using_indexes           | OFF                       |
| log_slave_updates                       | OFF                       |
| log_slow_queries                        | OFF                       |
| log_warnings                            | 1                         | #记录警告日志
| max_binlog_cache_size                   | 18446744073709547520      |
| max_binlog_size                         | 1073741824                |
| max_binlog_stmt_cache_size              | 18446744073709547520      |
| max_relay_log_size                      | 0                         |
| relay_log                               |                           |
| relay_log_index                         |                           |
| relay_log_info_file                     | relay-log.info            |
| relay_log_purge                         | ON                        |
| relay_log_recovery                      | OFF                       |
| relay_log_space_limit                   | 0                         |
| slow_query_log                          | OFF                       |
| slow_query_log_file                     | /mydata/lnmp-slow.log     |
| sql_log_bin                             | ON                        |
| sql_log_off                             | OFF                       |
| sync_binlog                             | 0                         |
| sync_relay_log                          | 0                         |
| sync_relay_log_info                     | 0                         |
+-----------------------------------------+---------------------------+
41 rows in set (0.00 sec)


#第十三节：MYSQL日志管理二
#中继日志：从主服务器的二进制日志文件中复制而来的事件，并保存的日志文件，用于从服务器复制的
#事务日志：ACIO，InnoD有事务日志
	innodb_flush_log_at_trx_commit：内存中缓存的日志同步到事务日志中来，值为1时表示每当有事务提交时同步事务日志，并执行磁盘flush操作，值为2时表示每有事务提交才同步，但不执行磁盘flush操作，值为0时每秒钟同步一次并告次内核不要在内核缓存直接保存到事务日志当中（执行磁盘flush操作）
	innodb_log_buffer_size：内存缓存大小，默认8M
	innodb_log_file_size：事务日志大小，默认5M
	innodb_log_files_in_group：事务日志组，默认为2个
	innodb_log_group_home_dir：事务日志存储位置
	innodb_mirrored_log_groups：事务日志镜像组


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
MYISAM存储引擎：
	1. 不支持事务
	2. 只支持表锁
	3. 不支持外键
	4. 支持BTree索引，FULLTEXT索引，空间索引，
	5. 支持表压缩
	.frm 表结构
	.MYI 表索引
	.MYD 表数据
InnoDB:
	1. 支持事务
	2. 行级锁
	3. 支持BTree索引，聚簇索引，自适应hash索引
	4. 表空间
	5. 支持raw磁盘设备(裸设备)
	.frm 表结构
	.ibd 表空间
	innodb_file_per_table ON #开启每一个表一个表空间
MRG_MYISAM：合并MYISAM表
CSV：在两个数据库之间进行移植时使用
ARCHIVE：用来实现归档的，
MEMORY：内存存储引擎
BLACKHOLE：级联复制，多级复制时再说
#不建议使用混合存储引擎，如果以后对事务进行rollback时MYISAM不支持，会出问题。

#第十四节：MYSQL备份和还原
RAID1,RAID10：保证硬件损坏而业务不会中止
备份是为了数据不丢失，跟硬件RAID是两个不同的概念
#备份类型：
	热备份、温备份、冷备份：
		1. 热备份：读写不受影响 
		2. 温备份：可读不可写
		3. 冷备份：离线备份，读写操作均中止
	物理备份和逻辑备份：
		1. 物理备份：复制数据文件
		2. 逻辑备份：将数据导出至文本文件中
	完全备份、增量备份、差异备份：
		1. 完全备份：备份完全数据
		2. 增量备份：仅备份上次完全备份或增量备份以后变化的数据
		3. 差异备份：仅备份上次完全备份以后变化的数据

#还原：
	要进行还原预演。不然到还原的时候还原会出问题

备份什么：
	数据、配置文件、二进制日志、事务日志

热备份：
	MYISAM:在线热备份几乎不可能，除非借助LVM快照进行热备份，否则最好的是温备份，用读锁锁定备份的所有表
	InnoDB:xtrabackup,mysqldump来进行热备份

MYSQL可以借助从服务器来进行温备份。从服务器停掉从服务器进程，此时从服务器只能读，就可进行温备份

物理备份：速度快
逻辑备份：速度慢、丢失浮点数精度，方便使用文本处理工具直接对其处理、可移植能力强;

备份策略：完全+增量;完全+差异

MySQ备份工具：
	1. mysqldump:逻辑备份工具，MyISAM(温备份)，InnoDB(热备份)
	2. mysqlhotcopy：物理备份工具、温备份
文件系统备份工具：
	1. cp:只能实现冷备，基于lv可以实现热备
	2. lv:逻辑卷的快照功能，几乎热备;
		mysql>FLUSH TABLES;
		mysql>LOCK TABLES;
		创建快照，释放锁，而后复制数据
		注：基于lv快照来说，对于MyISAM存储引擎来说几乎可以实现热备，但是InnoDB就不行了，因为可能还有部分数据正从事务日志写入数据文件中，所以得监控InnoDB的缓冲区是否全部复制完成。
第三组备份工具：
	ibbackup:针对InnoDB存储引擎的商业工具
	xtrabackup:开源工具

mysqldump备份：
	1. 先打开一个mysql终端进行锁所有表并刷新所有表：FLUSH TABLES WITH READ LOCK;
	2. 并对二进制日志进行滚动：FLUSH LOGS;SHOW BINARY LOGS;查看当前的二进制日志是哪个文件，记录稍后备份是截止到哪个二进制日志文件，但这个方式太麻烦，可在备份数据是使用[mysqldump --master-data=2 students > /root/stu-`date +%Y-%m-%d-%H:%M:%S`.sql]命令进行备份，--master-data=2表示记录你备份到二进制日志文件的哪个地方了,从备份的sql文本文件中可查看，下次从提示地方进行备份即可[CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000010', MASTER_LOG_POS=348;
]。#--master-data=0表示不记录位置，--master-data=1表示记录位置，恢复后直接启动从服务器。
	2. 再进行备份：mysqldump -uroot -p students > /root/students.sql
	3. 在另外一个mysql终端进行解锁表：UNLOCK TABLES;

--lock-all-tables #锁定所有表
--master-data={0|1|2} #记录二进制日志位置 
--flush-logs #执行二进制日志滚动
--single-transaction #如果库中的表类型为InnoDB,可使用这个参数备份，会自动锁InnoDB的表，不可与--lock-all-tables一起使用
--all-databases #备份所有库，命令会自动创建数据库，在还原的时候就不用创建库了
--databases DB_NAME,DB_NAME #备份指定库，命令会自动创建数据库，在还原的时候就不用创建库了
--events #备份事件
--routines #备份存储过程和存储函数
--triggers #备份触发器

mysqldump --lock-all-tables --master-data=2 students > /root/stu-`date +%Y-%m-%d-%H:%M:%S`.sql

备份策略：周完全+每日增量
	完全备份：mysqldump --lock-all-tables --master-data=2 students > /root/stu-`date +%Y-%m-%d-%H:%M:%S`.sql
	增量备份：备份二进制日志文件(flush logs)
例：
1. [root@lnmp ~]# mysqldump -uroot -p --flush-logs --master-data=2 --lock-all-tables --all-databases > /root/alldatabases.sql
2. [root@lnmp ~]# less alldatabases.sql 
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000014', MASTER_LOG_POS=107;
3.mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000012 |       150 |
| mysql-bin.000013 |       352 |
| mysql-bin.000014 |       107 |
+------------------+-----------+
3 rows in set (0.00 sec)
4. mysql> purge binary logs to 'mysql-bin.000014'; #腾出二进制空间，以后会越来越大，建议先备份老的二进制然后再清理

5. mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000014 |       107 |
+------------------+-----------+
1 row in set (0.00 sec)

6. mysql> select * from student;
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   2 |    3 | lhc   |
|   8 |    1 | tom   |
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
+-----+------+-------+
5 rows in set (0.00 sec)
7. mysql> delete from student where CID=3 OR CID=1; #删除两行 

8.mysql> select * from student;
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
+-----+------+-------+
3 rows in set (0.00 sec)
mysql> \q  #假如一天过去了，做了删除两行的操作

9. mysql> flush logs; #进行日志滚动
Query OK, 0 rows affected (0.01 sec)

10. mysql> show master status; #当时的二进制日志
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000015 |      107 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
11. mysql> show binary logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000014 |       717 | #这个二进制日志就是上一次完全备份后到当前期间的二进制日志
| mysql-bin.000015 |       107 |
+------------------+-----------+
2 rows in set (0.00 sec) 
12. [root@lnmp mydata]# cp mysql-bin.000014 /root/ #备份增量到/root目录下
13. [root@lnmp mydata]# mysqlbinlog mysql-bin.000014 > /root/mon-incrementa1.sql #或者这样先读出来二进制文件重定向到新建文件进行增量备份也行，12步和13步选其一即可
14. mysql> insert into student (CID,name) value (88,'ll'); #到第二天操作增加了一行
Query OK, 1 row affected (0.00 sec)
15. mysql> select * from student;
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
|  12 |   88 | ll    |
+-----+------+-------+
4 rows in set (0.00 sec)
16. 假如服务器崩溃了或者整个数据库删除了，但是日志文件在
17. [root@lnmp mydata]# cp mysql-bin.000015 /root #假如日志文件在别的目录
18. [root@lnmp mydata]# rm -rf ./* #整个数据库删了
19. [root@lnmp mydata]# killall mysqld #终止mysqld
20. [root@lnmp mysql]# scripts/mysql_install_db --user=mysql --datadir=/mydata #重新初始化mysql库
21. [root@lnmp mysql]# service mysql start #启动mysqld服务
Starting MySQL.. SUCCESS! 
22. [root@lnmp ~]# mysql -uroot -p < alldatabases.sql  #还原完全备份
Enter password: 
23. mysql> select * from student; #先查看表
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   2 |    3 | lhc   |
|   8 |    1 | tom   |
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
+-----+------+-------+
5 rows in set (0.00 sec)
24. [root@lnmp ~]# mysql -uroot -p < mon-incrementa1.sql  #还原我们的第一次增量数据
Enter password: 
25. mysql> select * from  student; #此时还原了我们删除两行的状态，但是我们插入的那行还未还原，我们刚才备份mysql-bin.000015的文件就有插入那行的数据
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
+-----+------+-------+
3 rows in set (0.00 sec)
26. [root@lnmp ~]# mysqlbinlog mysql-bin.000015 > temp.sql #生成临时文件
27. [root@lnmp ~]# mysql -uroot -p < temp.sql  #导入数据库，也可使用mysqlbinlog mysql-bin.000015 | mysql -uroot -p
Enter password: 
28. mysql> select * from  student;
+-----+------+-------+
| SID | CID  | name  |
+-----+------+-------+
|   9 |   10 | jack  |
|  10 |   11 | candy |
|  11 |   12 | bob   |
|  12 |   88 | ll    |  #已经即时点还原成功
+-----+------+-------+
4 rows in set (0.00 sec)

---------------mysql备份脚本-------------
#!/bin/bash  
#Shell Command For Backup MySQL Database Everyday Automatically By Crontab  
   
USER=root  
PASSWORD="123.com"  
DATABASE="yzm"  
HOSTNAME="localhost"  
   
WEBMASTER=test@qq.com  
   
BACKUP_DIR=/home/backup/mysql/ #备份文件存储路径  
LOGFILE=/home/backup/mysql/data_backup.log #日记文件路径  
DATE=`date '+%Y%m%d-%H%M'` #日期格式（作为文件名）  
DUMPFILE=$DATE.sql #备份文件名  
ARCHIVE=$DATE.sql.tgz #压缩文件名  
OPT='--lock-all-tables --flush-logs --master-data=2'
OPTIONS="-h$HOSTNAME -u$USER -p$PASSWORD $OPT $DATABASE"  
#mysqldump －help  
   
#判断备份文件存储目录是否存在，否则创建该目录  
if [ ! -d $BACKUP_DIR ] ;  
then  
        mkdir -p "$BACKUP_DIR"  
fi  
   
#开始备份之前，将备份信息头写入日记文件  
echo " " >> $LOGFILE  
echo " " >> $LOGFILE  
echo "———————————————–" >> $LOGFILE  
echo "BACKUP DATE:" $(date +"%y-%m-%d %H:%M:%S") >> $LOGFILE  
echo "———————————————– " >> $LOGFILE  
   
#切换至备份目录  
cd $BACKUP_DIR  
#使用mysqldump 命令备份制定数据库，并以格式化的时间戳命名备份文件  
mysqldump $OPTIONS > $DUMPFILE  
#判断数据库备份是否成功  
if [[ $? == 0 ]]; then  
    #创建备份文件的压缩包  
    tar czvf $ARCHIVE $DUMPFILE >> $LOGFILE 2>&1  
    #输入备份成功的消息到日记文件  
    echo “[$ARCHIVE] Backup Successful!” >> $LOGFILE  
    #删除原始备份文件，只需保 留数据库备份文件的压缩包即可  
    rm -f $DUMPFILE  
else  
    echo “Database Backup Fail!” >> $LOGFILE  
fi  
#输出备份过程结束的提醒消息  
echo “Backup Process Done
---------------



#第十五节：使用LVM快照进行数据备份 
SET sql_log_bin=0;
#在数据库导入恢复的时候不应该记录二进制日志文件，会产生大量IO，所以在恢复期间应该关闭记录二进制日志，恢复后开启二进制日志
mysql -u root -p  #进入mysql终端 
set sql_log_bin=0; #临时关闭记录二进制日志开关
source /root/data.sql;  #导入数据库
set sql_log_bin=1; #临时开启记录二进制日志开关
逻辑备份：
	1. 浮点数据丢失精度;
	2. 备份出的数据更占用存储空间，压缩后可大大节省空间。
	3. 不适合对大数据库做完全备份。
#innodb跟myisam同样逻辑备份时的不一样操作
mysql> flush tables with read lock; #对innodb存储引擎进行加锁
mysql> show engine innodb status; #这个地方是不一样操作。。。查看innodb存储引擎缓冲区是否还有数据写入，等缓冲区无数据时才可对数据库进行备份

MVCC：REPEATABLE-READ(可重读)时，使用--single-transaction对innoDB可做热备份原因。
#select INTO OUTFILE跟mysqldump也是裸备份
#使用SELECT * INTO OUTFILE /tmp/test.txt FROM tb_name [WHERE clause];备份某些表
#create table tb1 liki tutors; #先访造tutors生成一样的表结构
#使用LOAD DATA INFILE '/tmp/test.txt INTO TABLE tb_name;#然后恢复备份的某些表
mysqlbinlog --start-position=605 /mydata/mysql-bin.000001 > /tmp/my.sql #对二进制日志文件进行位置选定导出为sql文件
truncate table tutor; #清空表数据


#几乎热备：LVM
	快照：snapshot
	前提：
		1. 数据文件要在逻辑卷上
		2. 此逻辑卷所在卷组必须有足够空间使用快照卷
		3. 数据文件和事务日志要在同一个逻辑卷上


如果二进制日志文件跨文件了需要基于开始时间保存

LVM卷进行步骤：
	1. 打开会话，施加读锁，锁定所有表：
		mysql> FLUSH TABLES WITH READ LOCK;
		mysql> FLUSH LOGS;
	2. 在shell终端上，保存二进制日志文件信息
		# mysql -u roo -p -e 'SHOW MASTER STATUS \G' >/backup/binlog-info-`date +%Y-%m-%d-%H:%M:%S`.txt
	3. 创建lvm快照
		# lvcreate -L 50M -s -p r -n data-snap /dev/myvg/mylv
	4. 释放锁
		mysql> UNLOCK TABLES;
	5. 挂载快照卷，备份
		# mount /dev/myvg/data-snap /mnt -o ro 
		# cp /mnt/* /backup/all-database-`date +%Y-%m-%d-%H:%M:%S`/
	6. 删除LVM快照卷
		lvremove
	7. 查看保存的二进制日志文件信息，增量备份数据库目录下二进制日志文件
		mysqlbinlog --start-datetime='2019-06-23 17:00:00' mysql-bin.000004 mysql-bin.000005 > /backup/binlog01-`date +%Y-%m-%d-%H:%M:%S`.sql
		注：如果innodb打开了innodb_file_per_table=1，则只需要按需复制数据库文件夹即可，不需要全部复制。
	8. 如果数据库全部坏了，停掉mysql服务，复制/backup/all-database-`date +%Y-%m-%d-%H:%M:%S`/下的数据库文件[除开旧的二进制文件]到数据库目录下/mydata,并重启服务
	9. 进入mysql终端，临时关闭二进制日志写入功能SET sql_log_bin=0;，然后导入增量备份数据source /backup/binlog01-`date +%Y-%m-%d-%H:%M:%S`.sql
	10. 打开二进制日志写入功能SET sql_log_bin=1

例：
1. mysql> flush tables with read lock;
Query OK, 0 rows affected (0.01 sec)
2. mysql> flush logs;
Query OK, 0 rows affected (0.01 sec)
3. [root@lnmp ~]# mysql -e 'show master status '> binlog.txt 
4. [root@lnmp ~]# lvcreate -L 50M -s -p r -n mydata-snap /dev/myvg/mylv
  Rounding up size to full physical extent 52.00 MiB
  Logical volume "mydata-snap" created.
5. mysql> unlock tables; 
6. [root@lnmp mnt]#  mount /dev/myvg/mydata-snap /mnt && mkdir /backup/alldata -pv && cp -a ./* /backup/alldata/
Query OK, 0 rows affected (0.00 sec)
7. [root@lnmp ~]# umount /mnt/
8. [root@lnmp ~]# lvremove /dev/myvg/mydata-snap 
Do you really want to remove active logical volume myvg/mydata-snap? [y/n]: y
  Logical volume "mydata-snap" successfully removed
9. [root@lnmp alldata]# rm -rf mysql-bin.* #整理完全备份文件，删除快照无效二进制日志文件
[root@lnmp alldata]# ls
ibdata1      ib_logfile1        lnmp.jack.com.pid  mydb   performance_schema  wordpress
ib_logfile0  lnmp.jack.com.err  lost+found         mysql  test
10. [root@lnmp mydata]# mysqlbinlog --start-datetime='2019-06-23 18:59:54' mysql-bin.000006 mysql-bin.000007 > /root/a.sql #整理增量文件，时间从之前导出的binlog.txt文件看出，假如mysql服务已经是断开状态
11. [root@lnmp alldata]# service mysql stop
Shutting down MySQL.... SUCCESS!
12. [root@lnmp mydata]# ls
ibdata1      lnmp.jack.com.err  mysql             mysql-bin.000006  performance_schema
ib_logfile0  lost+found         mysql-bin.000004  mysql-bin.000007  test
ib_logfile1  mydb               mysql-bin.000005  mysql-bin.index   wordpress
13. [root@lnmp mydata]# rm -rf ./* #模拟整个数据库崩溃
14. [root@lnmp mydata]# cp -a /backup/alldata/* /mydata #复制完全备份文件到数据库目录，因为是快照，所以可以全部复制回来
15. [root@lnmp mydata]# service mysql start #可正常启动了,先要在mysql脚本上start()段 加入--skip-networking参数断网启动mysql,防止恢复时别人连入数据库
Starting MySQL SUCCESS! 
16. mysql> show databases;
+---------------------+
| Database            |
+---------------------+
| information_schema  |
| #mysql50#lost+found |
| mydb                |
| mysql               |
| performance_schema  |
| test                |
| wordpress           |
+---------------------+
7 rows in set (0.00 sec)
17. mysql> select * from stu; #完全备份后进行新添加的数据没有，需要增量还原后才可见
+----+-------+------+
| ID | Name  | Age  |
+----+-------+------+
|  1 | bob   |   21 |
|  2 | jack  |   25 |
|  3 | candy |   24 |
|  4 | aa    | NULL |
+----+-------+------+
4 rows in set (0.00 sec)
18. mysql> set sql_log_bin=0; #临时关闭二进制写入功能
19. [root@lnmp ~]# mysql < a.sql  #还原增量文件
19. mysql> select * from stu;
+----+-------+------+
| ID | Name  | Age  |
+----+-------+------+
|  1 | bob   |   21 |
|  2 | jack  |   25 |
|  3 | candy |   24 |
|  4 | aa    | NULL |
|  5 | bb    | NULL |  #这4行添加的数据正常了
|  6 | cc    | NULL |
|  7 | dd    | NULL |
|  8 | ee    | NULL |
+----+-------+------+
8 rows in set (0.00 sec)
20. mysql> set sql_log_bin=1; #开启二进制写入功能
21. [root@lnmp mydata]# service mysql stop #停止
22. [root@lnmp mydata]# service mysql start #先要在mysql脚本上start()段去掉--skip-networking参数,再启动mysql正常提供服务
##注：LVM-->有一个mylvmbackup(perl scripts)，有单独的配置，提供LVM快照的。

#第十六节：使用xtrabackup进行数据备份
innodb_support_xa               | ON  #开启innodb分布式事务的，建议开启
sync_binlog            | 0  #建议设置为1，每1次写操作将同步二进制日志到磁盘

#percona提供的xtrabackup备份工具
	xtrabackup:
		xtradb:innodb的增强版
		innodb
注：如果是源码编译mysql时，建议把mysql中innodb存储引擎源码删了，去percona官方下xtradb源码放到innodb存储引擎的位置，并更名xtradb为innodb即可编译。

参考链接：https://www.percona.com/downloads/
参考链接：https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/binary/redhat/6/x86_64/Percona-XtraBackup-2.4.9-ra467167cdd4-el6-x86_64-bundle.tar
#使用Xtrabackup进行mysql备份
##安装xtrabackup
[root@lnmp download]# wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.9/binary/redhat/6/x86_64/Percona-XtraBackup-2.4.9-ra467167cdd4-el6-x86_64-bundle.tar
[root@lnmp download]# rpm -ivh  rpm -ivh percona-xtrabackup-24-2.4.9-1.el6.x86_64.rpm 
[root@lnmp download]# yum install -y libev libev-devel perl perl-devel perl-DBD-MySQL #如果依赖需要安装
[root@lnmp download]# rpm -ql percona-xtrabackup-24-2.4.9-1.el6.x86_64
/usr/bin/innobackupex #备份工具
/usr/bin/xbcloud
/usr/bin/xbcloud_osenv
/usr/bin/xbcrypt
/usr/bin/xbstream
/usr/bin/xtrabackup
/usr/share/doc/percona-xtrabackup-24-2.4.9
/usr/share/doc/percona-xtrabackup-24-2.4.9/COPYING
/usr/share/man/man1/innobackupex.1.gz
/usr/share/man/man1/xbcrypt.1.gz
/usr/share/man/man1/xbstream.1.gz
/usr/share/man/man1/xtrabackup.1.gz
#第一阶段：备份
[root@lnmp download]# innobackupex --user=root --password=root123 /backup #备份
[root@lnmp 2019-06-23_21-25-52]# ls
backup-my.cnf  lost+found  mysql               test       xtrabackup_binlog_info  xtrabackup_info
ibdata1        mydb        performance_schema  wordpress  xtrabackup_checkpoints  xtrabackup_logfile
[root@lnmp 2019-06-23_21-25-52]# pwd
/backup/2019-06-23_21-25-52
[root@lnmp 2019-06-23_21-25-52]# cat xtrabackup_checkpoints #用记增量备份的检查点文件
backup_type = full-backuped
from_lsn = 0
to_lsn = 2245016
last_lsn = 2245016
compact = 0
recover_binlog_info = 0
[root@lnmp 2019-06-23_21-25-52]# cat xtrabackup_info #xtrabackup备份的信息
uuid = 6d2b0eba-95ba-11e9-8344-005056ad0d3c
name = 
tool_name = innobackupex
tool_command = --user=root --password=... /backup
tool_version = 2.4.9
ibbackup_version = 2.4.9
server_version = 5.5.37-log
start_time = 2019-06-23 21:25:52
end_time = 2019-06-23 21:25:53
lock_time = 0
binlog_pos = filename 'mysql-bin.000001', position '801'
innodb_from_lsn = 0
innodb_to_lsn = 2245016
partial = N
incremental = N
format = file
compact = N
compressed = N
encrypted = N
[root@lnmp 2019-06-23_21-25-52]# cat xtrabackup_binlog_info  #xtrabckup备份的二进制文件状态
mysql-bin.000001        801
#第二阶段：准备工作，将事务日志进行重读和撤销到数据文件
[root@lnmp 2019-06-23_21-25-52]# innobackupex --apply-log /backup/2019-06-23_21-25-52/ #进行事务日志写入数据文件，后面给一个路径，这个准备工作必须做，做完才可进行恢复
mysql> insert into stu (Name) value ('abcd'); #模拟在mysql做插入动作
Query OK, 1 row affected (0.00 sec)

mysql> insert into stu (Name) value ('abcd12');
Query OK, 1 row affected (0.00 sec)
mysql> flush logs; #滚动二进制日志
[root@lnmp mydata]# cp mysql-bin.000001 /root #复制完全备份后更改的二进制日志文件信息
[root@lnmp mydata]# service mysql stop 
[root@lnmp mydata]# rm -rf ./* #模拟删除全部数据
[root@lnmp mydata]# ls /mydata/
[root@lnmp backup]# innobackupex --copy-back /backup/2019-06-23_21-25-52/ #恢复全量备份
[root@lnmp mydata]# ll #恢复成功，但是属主属组不是mysql.mysql，必须改正
total 41056
-rw-r----- 1 root root 18874368 Jun 23 21:43 ibdata1
-rw-r----- 1 root root  5242880 Jun 23 21:43 ib_logfile0
-rw-r----- 1 root root  5242880 Jun 23 21:43 ib_logfile1
-rw-r----- 1 root root 12582912 Jun 23 21:43 ibtmp1
drwxr-x--- 2 root root     4096 Jun 23 21:43 lost+found
drwxr-x--- 2 root root     4096 Jun 23 21:43 mydb
drwxr-x--- 2 root root     4096 Jun 23 21:43 mysql
drwxr-x--- 2 root root     4096 Jun 23 21:43 performance_schema
drwxr-x--- 2 root root     4096 Jun 23 21:43 test
drwxr-x--- 2 root root     4096 Jun 23 21:43 wordpress
-rw-r----- 1 root root       23 Jun 23 21:43 xtrabackup_binlog_pos_innodb
-rw-r----- 1 root root      463 Jun 23 21:43 xtrabackup_info
[root@lnmp mydata]# chown -R mysql.mysql /mydata/
[root@lnmp mydata]# service mysql start #启动mysql
Starting MySQL.. SUCCESS! 
[root@lnmp 2019-06-23_21-25-52]# cat xtrabackup_binlog_info 
mysql-bin.000001        801
[root@lnmp ~]# mysqlbinlog --start-position=801 mysql-bin.000001 > a.sql
mysql> select * from stu;
+----+-------+------+
| ID | Name  | Age  |
+----+-------+------+
|  1 | bob   |   21 |
|  2 | jack  |   25 |
|  3 | candy |   24 |
|  4 | aa    | NULL |
|  5 | bb    | NULL |
|  6 | cc    | NULL |
|  7 | dd    | NULL |
|  8 | ee    | NULL |
+----+-------+------+
8 rows in set (0.00 sec)
mysql> set sql_log_bin=0;
[root@lnmp ~]# mysql < a.sql  #恢复增量备份数据
mysql> set sql_log_bin=1;
mysql> select * from stu;
+----+--------+------+
| ID | Name   | Age  |
+----+--------+------+
|  1 | bob    |   21 |
|  2 | jack   |   25 |
|  3 | candy  |   24 |
|  4 | aa     | NULL |
|  5 | bb     | NULL |
|  6 | cc     | NULL |
|  7 | dd     | NULL |
|  8 | ee     | NULL |
|  9 | abcd   | NULL | #已经恢复
| 10 | abcd12 | NULL |
+----+--------+------+
10 rows in set (0.00 sec)
#已经增量恢复了，所以现在重新做完全备份
[root@lnmp ~]# innobackupex --user=root --password=root123 /backup #重做完全备份
mysql> insert stu (Name) value ('aa1'),('aa2'); #新插入两条数据
Query OK, 2 rows affected (0.02 sec)
Records: 2  Duplicates: 0  Warnings: 0
[root@lnmp ~]# innobackupex --incremental /backup --incremental-basedir=/backup/2019-06-23_21-52-24 #做第一次增量备份，--incremental表示增量，/backup表示备份的目录，--incremental-basedir=/backup/2019-06-23_21-52-24表示在这个基础上做增量备份
[root@lnmp backup]# ll
total 0 
drwxr-x--- 8 root root 249 Jun 23 21:52 2019-06-23_21-52-24 #这个是完全
drwxr-x--- 8 root root 275 Jun 23 21:55 2019-06-23_21-55-32 #这个是增量
mysql> insert stu (Name) value ('aa1'),('cc1');
mysql> insert stu (Name) value ('aa1'),('cc2');
[root@lnmp ~]# innobackupex --incremental /backup --incremental-basedir=/backup/2019-06-23_21-55-32 #这个是第二次增量备份
[root@lnmp backup]# ll
total 0
drwxr-x--- 8 root root 249 Jun 23 21:52 2019-06-23_21-52-24
drwxr-x--- 8 root root 275 Jun 23 21:55 2019-06-23_21-55-32
drwxr-x--- 8 root root 275 Jun 23 22:00 2019-06-23_22-00-13
[root@lnmp 2019-06-23_21-52-24]# cat xtrabackup_checkpoints 
backup_type = full-backuped
from_lsn = 0
to_lsn = 2246096
last_lsn = 2246096 #完全备份的最后lsn
compact = 0
recover_binlog_info = 0
[root@lnmp 2019-06-23_21-55-32]# cat xtrabackup_checkpoints 
backup_type = incremental
from_lsn = 2246096
to_lsn = 2246774
last_lsn = 2246774 #增量备份的最后lsn
compact = 0
recover_binlog_info = 0
[root@lnmp 2019-06-23_22-00-13]# cat xtrabackup_checkpoints 
backup_type = incremental
from_lsn = 2246774
to_lsn = 2247436
last_lsn = 2247436 #增量备份的最后lsn
compact = 0
recover_binlog_info = 0
#让事务日志写入数据文件
[root@lnmp ~]# innobackupex --apply-log --redo-only /backup/2019-06-23_21-52-24/ #对完全备份操作，让事务日志写入数据文件，并且只做重读操作，不做撤销，因为如果撤销会影响后面的重读操作
[root@lnmp ~]# innobackupex --apply-log --redo-only /backup/2019-06-23_21-52-24/ --incremental-dir=/backup/2019-06-23_21-55-32/ #对增量备份1进行事务日志操作，/backup/2019-06-23_21-52-24/为写入数据文件路径，--incremental-dir=/backup/2019-06-23_21-55-32/是第1次增量备份事务日志和二进制日志路径
[root@lnmp ~]# innobackupex --apply-log --redo-only /backup/2019-06-23_21-52-24/ --incremental-dir=/backup/2019-06-23_22-00-13/ #对增量备份2进行事务日志操作，/backup/2019-06-23_21-52-24/为写入数据文件路径，--incremental-dir=/backup/2019-06-23_21-55-32/是第2次增量备份事务日志和二进制日志路径
[root@lnmp ~]# service mysql stop #停止mysql
Shutting down MySQL... SUCCESS!  
[root@lnmp mydata]# rm -rf /mydata/* #模拟崩溃
[root@lnmp mydata]# ls
[root@lnmp backup]# innobackupex --copy-back /backup/2019-06-23_21-52-24/ #完全加增量恢复
[root@lnmp mydata]# ll /mydata/
total 18488
-rw-r----- 1 root root 18874368 Jun 23 22:41 ibdata1
drwxr-x--- 2 root root     4096 Jun 23 22:41 lost+found
drwxr-x--- 2 root root     4096 Jun 23 22:41 mydb
drwxr-x--- 2 root root     4096 Jun 23 22:41 mysql
drwxr-x--- 2 root root     4096 Jun 23 22:41 performance_schema
drwxr-x--- 2 root root     4096 Jun 23 22:41 test
drwxr-x--- 2 root root     4096 Jun 23 22:41 wordpress
-rw-r----- 1 root root       24 Jun 23 22:41 xtrabackup_binlog_pos_innodb
-rw-r----- 1 root root      507 Jun 23 22:41 xtrabackup_info
[root@lnmp mydata]# chown -R mysql.mysql /mydata/
[root@lnmp mydata]# service mysql start #启动mysql
Starting MySQL.. SUCCESS! 
mysql> select * from stu;
+----+--------+------+
| ID | Name   | Age  |
+----+--------+------+
|  1 | bob    |   21 |
|  2 | jack   |   25 |
|  3 | candy  |   24 |
|  4 | aa     | NULL |
|  5 | bb     | NULL |
|  6 | cc     | NULL |
|  7 | dd     | NULL |
|  8 | ee     | NULL |
|  9 | abcd   | NULL |
| 10 | abcd12 | NULL |
| 11 | aa1    | NULL |
| 12 | aa2    | NULL |
| 13 | aa1    | NULL |
| 14 | bb1    | NULL |
| 15 | aa1    | NULL |
| 16 | bb2    | NULL |
| 17 | aa1    | NULL |
| 18 | cc1    | NULL |
| 19 | aa1    | NULL |
| 20 | cc2    | NULL |  #cc2为第二次增量备份前插入的，事实证明成功
+----+--------+------+
20 rows in set (0.00 sec)
#注：innodb_file_per_table=1必须启用每表一个表空间，innodb_expand_import=1启用导入功能


###MySQL读写分离
复制的作用：
	1. 辅助实现备份
	2. 高可用
	3. 异地容灾
	4. scale out:分担负载
主从架构中不使用MYSQL代理，通过php程序指定主从服务器来实现读写分离。
双主复制：无法减轻写操作。

#读写分离工具
读写分离：
	MySQL-Proxy
	amoeba:阿里巴巴前员工写的，已经离职
数据拆分：
	cobar：现在阿里巴巴用





</pre>