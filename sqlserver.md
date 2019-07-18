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




</pre>