#Oracle
<pre>
使用图形化安装好oracle 11g.
打开cmd:sqlplus / as sysdba  #sys为超级管理员，dba为系统角色
alter user scott account unlock; #解释普通用户scott,oracle 12c普通用户为hr
alter user scott identified by scott; #修改scott用户密码为scott
show user;  #查看当前用户
password ;  #修改当前用户的密码
exit
sqlplus scott/scott  #用帐户和密码登录oracle
SQL> select * from tab;  #查看当前用户下的所有对象
SQL> desc emp;  #查看表结构
 名称                                      是否为空? 类型
 ----------------------------------------- -------- ----------------------------
 EMPNO                                     NOT NULL NUMBER(4)
 ENAME                                              VARCHAR2(10)
 JOB                                                VARCHAR2(9)
 MGR                                                NUMBER(4)
 HIREDATE                                           DATE
 SAL                                                NUMBER(7,2)
 COMM                                               NUMBER(7,2)
 DEPTNO                                             NUMBER(2)
SQL> host cls #执行主机的命令cls
SQL> /   #执行上一条命令
NVL(a,'')  #跟mysql的ifnull(),sqlserver的isnull()函数一样。
SQL> select 'hello' || 'jack' "column" from dual;  #||这字符连接符，oracle中别名必须使用双引号括起来，使用连接符时必需使用from关键字，dual是哑表或伪表，常与select关键字一起使用
column
------------------
hellojack
SQL> select sysdate from dual;  #查看系统日志
SYSDATE
--------------
09-9月 -19




</pre>