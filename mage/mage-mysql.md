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
	物理层：无数据，数据（存储为数据块）
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
cmake用法：
./configure    cmake .
./configure --help    cmake . LH   or   ccmake .
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
[root@lnmp mysql-5.5.37]# cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/mydata/data -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_ZLIB=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf-8 -DDEFAULT_COLLATION=utf8_general_ci
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
[root@lnmp etc]# mysql -u root -h 192.168.1.233 -p  #登录报错，因为只允许本机访问，而本机访问是通过socket访问的，现在指明ip地址，则mysql认为是使用tcp连接的，所以用root用户tcp连接跟设置的root用户socket连接不符，所以报错
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












</pre>