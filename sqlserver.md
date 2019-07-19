#sql server
<pre>
数据存储结构：
#数据库文件和事务文件组成：
mdf：主数据库文件，提供系统数据库的信息，一个数据库只有一个主数据库文件
ndf：辅助数据库文件，用于存储主数据库未能存储的数据和一些对象
ldf: 事务日志文件，用户记录数据库被改变的操作指令，类似mysql的二进制日志，不属于任何一个文件组
#文件组：用户设置
#数据库和系统数据库：
#系统数据库：
master：主数据库，记录sqlserver的所有系统信息，登录及其他数据库存放位置
model：模板数据库，创建新数据库时结构都是相同的就是因为这个modl数据库
msdb：处理用户代理，作业，数据库备份还原信息
tempdb：存储所有临时表，临时的存储过程，是一个临时数据库，程序执行完成后会自动消失
resource:隐藏数据库，只读的，包含了sqlserver的所有对象信息
#用户数据库：用户新建的库

###数据库：
#从视图上创建数据库：
数据库属性：
限制访问：
multi_user
single_user
restricted_user #表示只允许数据库管理员登录
只读：只读数据库

新建多文件组的数据库：
先创建数据库--文件组--添加文件组FG--常规--设置数据库名称--添加--选择FG文件组

#使用SQL语句创建数据库
#创建数据库时设置主文件组、日志文件
USE master
GO  --批处理的标志
CREATE DATABASE mydb
ON PRIMARY  --主文件组
(
	NAME='mydb_data',  --主文件逻辑文件名
	FILENAME='E:\DATA\mydb.mdf',  --主文件物理文件名
	SIZE=5MB,  --主文件初始大小
	MAXSIZE=100MB,  --主文件增长的最大值
	FILEGROWTH=15%  --主文件的增长率
)  --第一个文件组结束
LOG ON  --日志文件
(
	NAME='mydb_log',  --日志文件逻辑文件名
	FILENAME='E:\DATA\mydb.ldf',  --主文件物理文件名
	SIZE=5MB,  --主文件初始大小
	FILEGROWTH=0  --未启用自动增长
) --日志文件结束
GO --结束批处理的标志

#创建数据库时设置主文件组、辅助文件组、日志文件
USE master
GO  --批处理的标志
CREATE DATABASE test
ON PRIMARY  --主文件组
(
	NAME='test_data',  --主文件逻辑文件名
	FILENAME='E:\DATA\test.mdf',  --主文件物理文件名
	SIZE=5MB,  --主文件初始大小
	MAXSIZE=100MB,  --主文件增长的最大值
	FILEGROWTH=15%  --主文件的增长率
), --主文件组结束
FILEGROUP FG  --第二个文件组
(
	NAME='test_fg_data',  --辅助文件逻辑文件名
	FILENAME='E:\DATA\test_fg.ndf',  --辅助文件物理文件名
	SIZE=10MB,  --辅助文件初始大小
	FILEGROWTH=0  --辅助文件的增长率
)  --第二个文件组结束
LOG ON  --日志文件
(   --日志1的具体描述
	NAME='test_log',  --日志文件逻辑文件名
	FILENAME='E:\DATA\test.ldf',  --日志文件物理文件名
	SIZE=5MB,  --日志文件初始大小
	FILEGROWTH=0  --未启用自动增长
),
(   --日志2的具体描述
	NAME='test1_log',  --日志文件逻辑文件名
	FILENAME='E:\DATA\test1.ldf',  --日志文件物理文件名
	SIZE=5MB,  --日志文件初始大小
	FILEGROWTH=0  --未启用自动增长
)--日志文件结束
GO --结束批处理的标志

#使用sql语句创建文件组和添加文件文件
USE test   --切换要更改的数据库
ALTER DATABASE test ADD FILEGROUP FG1 --更改数据库添加文件组FG1
GO  --批处理开始
ALTER DATABASE test ADD FILE  --更改数据库添加辅助文件
(
	NAME='FG1_test-data',
	FILENAME='E:\DATA\FG1_test_data.ndf',
	SIZE=5MB,
	FILEGROWTH=10%
)TO FILEGROUP FG1  --到文件组FG1
GO 
ALTER DATABASE test  
MODIFY FILEGROUP FG1 DEFAULT  --设置文件组FG1为默认文件组

--删除数据库
if exists (select * from sysdatabases where name='mydb') drop database mydb
--登录名只能登录数据库，不能操作数据库

#使用sql进行用户新建和赋权
--创建登录名
USE master
GO
CREATE LOGIN pbmaster WITH PASSWORD='123456'
GO
--创建test数据库用户pbmaster
USE test
GO
CREATE USER pbuser FOR LOGIN pbmaster
GO
--为pbuser赋予testtab表查看，新增，修改的操作权限
USE test
GO
GRANT SELECT,INSERT,UPDATE ON table1 TO pbuser
GO
--回收testtab表updata权限
USE test
GO
REVOKE UPDATE ON table1 FROM pbuser
GO

#服务器角色
dbo是所有数据库的所有者
sysadmin角色：做的动作也都是属于dbo的
public:所以数据库用户都属于public
sa用户：为每个数据库映射了dbo到sa上
数据库级别的一个对象，只能包含用户名
角色分类：
	1. 固定数据库角色
	2. 自定义数据库角色

#数据库状态
#脱机与联机：
--使用sql语句来查看数据的状态
SELECT state_desc  FROM sys.databases WHERE name='test'
select * from sysdatabases
--使用函数来查看数据的状态
SELECT DATABASEPROPERTYEX('test','status')
--脱机：断开数据库与所有人的连接
--联机：开启断气库与所有人的连接
#分离与附加数据库
--使用存储过程来分离与附加数据库
--分离
EXEC sp_detach_db @dbname=test    --使用存储过程sp_detach_db来分离
--附加
EXEC sp_attach_db @dbname=test,    --使用存储过程sp_attach_db来分离
@filename1='E:\DATA\test.mdf',     --指定mdf,ndf,ldf文件路径
@filename2='E:\DATA\test_fg.ndf',
@filename3='E:\DATA\FG1_test_data.ndf',
@filename4='E:\DATA\test.ldf',
@filename5='E:\DATA\test1.ldf'
GO  --进行批处理
#注：无论是分离还是脱机，都可以复制数据库文件进行备份

#收缩数据库
收缩数据库作用：
	删除数据库的每个文件中已经分配但还没有使用的页，收缩后数据库空间自动减少
收缩方式：
	自动收缩
	手动收缩
自动收缩操作：
	右键数据库属性---常规---可以查看大小和可用空间---自动收缩选择为true（以后每半个小时会检查）
手动收缩操作：
	右键数据库任务---收缩---数据库或者文件---进行收缩

######数据库的备份与还原
sqlserver提供四种数据库备份方式：
	完整备份：备份整个数据库的所有内容包括事务日志
	差异备份：只备份上次完整备份后更改的数据部份
	事务日志备份：只备份事务日志里的内容
	文件或文件组备份：只备份文件或文件组中的某些文件
在数据库完整备份期间，sqlserver做以下工作：
	备份数据及数据库中所有表的结构和相关的文件结构
	备份在备份期间发生的所有活动
	备份在事务日志中未确认的事务

####T-SQL数据语言操作
DECLARE @color varchar(4)  #声明一个变量并设置名称及类型
SET @color='白色'  #设置一个变量
SELECT '我最喜欢的颜色'+@color  #测评+号连接符
GO  #开启批处理

#使用tsql创建表：
#创建表
USE test
GO
CREATE TABLE CommoditySort(
	SortId int IDENTITY(1,1) NOT NULL,
	SortName varchar(50) NOT NULL
)
GO
--商品信息表
USE test
GO
CREATE TABLE CommodityInfo(
	CommodityId int IDENTITY(1,1) NOT NULL,
	SortId int NOT NULL,
	CommodityName varchar(50) NOT NULL,
	Picture image,
	Inprice float NOT NULL,
	Outprice float NOT NULL,
	Amount int NOT NULL
)
GO

##使用sql为表添加约束
USE test
GO
ALTER TABLE CommoditySort
ADD CONSTRAINT PK_UserID PRIMARY KEY (UserID),  --主键约束
	CONSTRAINT CK_UserPWD CHECK(LEN(UserPwd)>=6),   --检查约束
	CONSTRAINT CK_Gender CHECK(Gender=0 OR Gender=1),  --检查gender是否是男或女并约束
	CONSTRAINT DF_Gender DEFAULT(0) FOR Gender,  --设置默认约束，gender为0
	CONSTRAINT CK_Email CHECK(Email like '%@%')   --检查email中是否有@并约束
GO
#使用T-SQL向已有数据表中添加约束
ALTER TABLE CommoditySort WITH NOCHECK  --WITH NOCHECK 为不进行约束检查
ADD CONSTRAINT CK_UserPWD CHECK(LEN(UserPwd)>=6), 
GO
#删除约束
ALTER TABLE CommoditySort
DROP CONSTRAINT CK_UserPWD   #删除约束
GO

#删除表USE test 
GO
IF EXISTS (select * from sysobjects  where name='renwu')
DROP TABLE renwu
GO

#插入数据到新表
select Amount,Inprice,IDENTITY(INT,1,1) AS id INTO tmptable from CommodityInfo --从表中查询数据并插入到新表中，
TRUNCATE TABLE --清空表，删除表数据并清空自增长值且从头开始，但不能用于约束的表

#sqlserver的导入和导出用于处理大量数据的导入和导出，形式是excel格式导入和导出

##批处理
所有的批处理指令以GO作为结束的标志，GO只能在独立一行，GO不是T-SQL语句
##什么情况下会使用批处理
在脚本中的事情必须发生在另外一件事情之前或者是分开发生的时候
#GO用在批处理的每一个步骤之后，不可以多个步骤使用一个GO。

##########sqlserver函数
函数帮助和其他帮助都可以通过F1的索引
###字符串函数
函数：chaindex(),len(),left(),right(),replace(),stuff()
select CHARINDEX('mi','www.mi.com') --从www.mi.com中截取mi的索引开始位置
select CHARINDEX('mi','www.mi.com'，10) --并给定起始位置
--将函数放在查询语句中进行使用
select charindex('@',Email) FROM UserInfo where username='jack' --查询jack用户的emial列中@的索引值
select len(Email) FROM UserInfo where username='jack' --查询jack用户的emial列中的值的长度
select left(Email,charindex('@','Email') FROM UserInfo where username='jack' --截取jack用户的emial列中以'@'符号左边的数，right()函数也一样
select REPLACE('我是中国人','中国人','湖北人') from UserInfo where username='jack' --替换我是中国人为我是湖北人，这个是字符串替换作用
select STUFF('ABCDEF',2,3,'ZZZ') --结果是'AZZZEF'，使用是从索引2开始删除3位，并用ZZZ替换
###日期函数
函数：getdate(),dateadd(),datediff()
select getdate() --获取当前系统时间
SELECT DATEADD(MM,1,GETDATE())  --在当前时间的月份加1，可以为正负数、如果是小数则会取整省略分数后的数
select datediff(YY,'2008-8-8',GETDATE()) --日期比较，这里以YY年来比较
###数学函数和系统函数
函数：rand(),ceiling(),floor(),abs(),convert()
SELECT RAND(100)   --指定了种子数(100)，则每次返回值都相同
SELECT RAND()  --未指定种子数()，则每次返回值都不相同
select CONVERT(int,'10')+CONVERT(int,'15')  --类型转换

#############查询
#模糊查询
_,%,[],[^]
#查询中使用聚合函数
sum(),avg(),min(),max(),count()
#分组查询
group by,having,order by ----排序永远是在最后的
例：select..from..where...group by...having...order by...
#内连接查询
内连接：根据表中共同的列来进行匹配,可以使用where和inner join来使用，但where最多只能两张表
SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
        INNER JOIN
    productlines t2 ON t1.productline = t2.productline
		INNER JOIN 
	money t3 ON t2.moneyid=t3.moneyid
#联合查询
UNION ALL --联合查询方法和mysql一样，UNION ALL表示不去重显示，默认UNION是去重显示的
select userid,username into newtable from userinfo  --联合查询插入到临时表时必须在第一个from前插入into
union
select userid,payway,userage from orderinfo
注：联合查询的多表类型必须保持一致，否则不会成功
#联合查询与连接查询的区别

#EXISTS子查询
只注重子查询是否有返回行，如果查有返回行返回结果为值，否则为假
IF EXISTS (SELECT commodityid FROM order where amount >3)
	BEGEIN
		UPDATE order SET money=money*0.8 
		WHERE commodityid IN (SELECT commodityid FROM order where amount >3)
	END
--通常会使用NOT EXISTS对子查询的结果进行取反

#ALL,ANY和SOME子查询
ALL:所有
ANY:部分
SOME:与ANY等同，使用ANY的地址都可以使用SOME替换
--ALL
SELECT * FROM table2 WHERE n>ALL(SELECT n FROM table1)
--返回结果为4，--table2 n为（1，2，3，4），table1 n为（2，3）
--ANY
SELECT * FROM table2 WHERE n>ANY(SELECT n FROM table1)
--返回结果为3,4，--table2 n为（1，2，3，4），table1 n为（2，3）
--SOME
SELECT * FROM table2 WHERE n>SOME(SELECT n FROM table1)
--返回结果为3,4，--table2 n为（1，2，3，4），table1 n为（2，3）

SELECT * FROM table2 WHERE n=ANY(SELECT n FROM table1)  --加上下面这条结果都一样
SELECT * FROM table2 WHERE n IN (SELECT n FROM table1)
SELECT * FROM table2 WHERE n <> ANY(SELECT n FROM table1) --加上下面这条结果不一样
SELECT * FROM table2 WHERE n NOT IN (SELECT n FROM table1)
注：n=ANY与n IN相同的， n <> ANY和n NOT IN是不相同的

#######T-SQL程序
###变量
#局部变量
@VAR
----------
DECLARE @UserID varchar(10),@pwd varchar(20)
--变量赋值
--SET
SET @UserID='zhangzhang'
--SELECT
SELECT @pwd=UserPwd FROM Userinfo where UserID=@UserID
PRINT @UserID
PRINT @pwd
GO
----------
SELECT @UserID='zhangzhang',@pwd=UserPwd
SELECT @province=useraddress FROM Userinfo --useraddress为返回多个值
SELECT @province --显示值
----注：GO之前的变量局部变量，在GO之后是不能使用的。另外SET是不允许同时为多个变量赋值，而SELECT却可以。SELECT可以接收多个值，而且SET不可以接收多个值。SET可以接收NULL值，SELECT无法接收NULL值，所以将会输出之前的旧值，不会输出NULL值。
#全局变量
@@VAR
@@IDENTITY --返回最后插入语句的标识值的系统函数，必须有标识列，否则不会返回标识值的。
@@ERROR --返回执行的上一个Transact-SQL语句的错误号。如果前一个 Transact-SQL 语句执行没有错误，则返回 0。
SELECT @@ERROR  --SELECT输出的时候以表格结果输出的
PRINT @@ERROR  --PRINT输出的时候以文本结果输出的
SELECT @@ERROR AS 错误号  --对结果全名别名

###数据类型转换
隐式转换：类型相兼容自动转换
显示转换：可以使用CONVERT函数或CAST函数
#CONVERT与CAST函数转换：
PRINT '错误号' + convert(varchar(10),@@ERROR)
PRINT '错误号' + CAST(@@ERROR AS varchar(5))
相同点：都能够将某数据类型转换为另一种数据类型
异同点：CONVERT有三个参数，但CONVERT函数转换有优势，转换类型很多,SELECT CONVERT(VARCHAR(10),GETDATE(),111)

</pre>