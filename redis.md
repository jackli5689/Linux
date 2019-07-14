#Redis

redis官方网站：www.redis.io
#redis是什么：
	1. NOSQL数据库，开源，BSD许可，高级的key-value存储系统
	2. 可以用来存储字符串，哈希结构，链表，集合，因此，常用来提供数据结构服务。

redis和memcached相比的独特之处：
	1. redis可以用来做存储(storage)，而memcached是用来做缓存(cache),这个特点主要因为其有“持久化”功能
	2. redis存储的数据有“结构”，对于memcached来说，存储的数据只有一种类型--“字符串”，而redis则可以存储字符串，链表，哈希结构集合，有序集合。
#注：如果redis只做缓存的话，那么就跟memcached一样。

#redis下载安装：
[root@lnmp src]# wget http://download.redis.io/releases/redis-5.0.5.tar.gz
[root@lnmp src]# tar xf redis-5.0.5.tar.gz 
[root@lnmp src]# cd redis-5.0.5/
[root@lnmp redis-5.0.5]# make #没有./configure，因为redis已经给你生成了makefile环境配置文件，所以执行make进行编译
[root@lnmp redis-5.0.5]# make test #进行安装前测试，看是否通过环境配置
cd src && make test
make[1]: Entering directory `/usr/local/src/redis-5.0.5/src'
    CC Makefile.dep
make[1]: Leaving directory `/usr/local/src/redis-5.0.5/src'
make[1]: Entering directory `/usr/local/src/redis-5.0.5/src'
You need tcl 8.5 or newer in order to run the Redis test #报错，需要安装tcl 8.5及以后的版本
make[1]: *** [test] Error 1
make[1]: Leaving directory `/usr/local/src/redis-5.0.5/src'
make: *** [test] Error 2
[root@lnmp redis-5.0.5]# yum install tcl -y
[root@lnmp redis-5.0.5]# make PREFIX=/usr/local/redis install #安装并指定redis路径
cd src && make install
make[1]: Entering directory `/usr/local/src/redis-5.0.5/src'

Hint: It's a good idea to run 'make test' ;)

    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
make[1]: Leaving directory `/usr/local/src/redis-5.0.5/src'
[root@lnmp redis]# cd /usr/local/redis/
[root@lnmp redis]# ls
bin
[root@lnmp redis]# ll bin/
total 32736
-rwxr-xr-x 1 root root 4366608 Jul 14 12:15 redis-benchmark
-rwxr-xr-x 1 root root 8111816 Jul 14 12:15 redis-check-aof
-rwxr-xr-x 1 root root 8111816 Jul 14 12:15 redis-check-rdb
-rwxr-xr-x 1 root root 4806840 Jul 14 12:15 redis-cli
lrwxrwxrwx 1 root root      12 Jul 14 12:15 redis-sentinel -> redis-server
-rwxr-xr-x 1 root root 8111816 Jul 14 12:15 redis-server
#make install之后,得到如下几个文件
redis-benchmark  性能测试工具
redis-check-aof  日志文件检测工(比如断电造成日志损坏,可以检测并修复)
redis-check-dump  快照文件检测工具,效果类上
redis-cli  客户端
redis-server 服务端
[root@lnmp bin]# cp /usr/local/src/redis-5.0.5/redis.conf /usr/local/redis/ #复制配置文件
[root@lnmp redis]# vim /etc/profile.d/redis.sh
export PATH=$PATH:/usr/local/redis/bin
[root@lnmp redis]# . /etc/profile.d/redis.sh 
[root@lnmp redis]# redis-server /usr/local/redis/redis.conf #启动redis服务
[root@lnmp ~]# redis-cli  #打开另一个终端进行redis终端
127.0.0.1:6379> 
注：redis-cli -h <hostname>  -p <port>  -s <socket>  -a <password> 
127.0.0.1:6379> set site www.zhixue.it #设置一个键值
OK
127.0.0.1:6379> get site
"www.zhixue.it"
127.0.0.1:6379> quit
[root@lnmp ~]# vim /usr/local/redis/redis.conf
daemonize yes #把no设为yes，使其运行为守护进程
[root@lnmp redis]# redis-server /usr/local/redis/redis.conf  #此时是以守护进程运行
18157:C 14 Jul 2019 12:27:47.858 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
18157:C 14 Jul 2019 12:27:47.858 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=18157, just started
18157:C 14 Jul 2019 12:27:47.858 # Configuration loaded

#第二节：通用命令操作
[root@lnmp ~]# redis-cli
127.0.0.1:6379> get site
"www.zhixue.it"
127.0.0.1:6379> set age 29
OK
#在redis里,允许模糊查询key
有3个通配符 *, ? ,[]
*: 通配任意多个字符
?: 通配单个字符
[]: 通配括号内的某1个字符
127.0.0.1:6379> keys * #查询当前有哪些key
1) "age"
2) "site"
127.0.0.1:6379> keys sit[ey]
1) "site"
127.0.0.1:6379> randomkey #返回随机的key
"site"
127.0.0.1:6379> randomkey #返回随机的key
"age"
127.0.0.1:6379> type age #查看键是什么类型，redis上没有int类型，是string类型
string
127.0.0.1:6379> EXISTS age #判断key是否存在,返回1/0
(integer) 1
127.0.0.1:6379> del age #删除一个key
(integer) 1
127.0.0.1:6379> keys *
1) "site"
127.0.0.1:6379> RENAME site wangzhi #给key改名称
OK
127.0.0.1:6379> exists site
(integer) 0
127.0.0.1:6379> exists wangzhi
(integer) 1
127.0.0.1:6379> get wangzhi
"www.zhixue.it"
127.0.0.1:6379> set site www.zixue.it
OK
127.0.0.1:6379> set search www.so.com
OK
127.0.0.1:6379> rename site search #此只老的search将会被覆盖
OK
127.0.0.1:6379> keys *
1) "search"
127.0.0.1:6379> get search #www.so.com这个键值没有了
"www.zixue.it"
127.0.0.1:6379> renamenx site search #renamenx表示不存在时才重名命
(integer) 0
127.0.0.1:6379> renamenx site sea
(integer) 1
127.0.0.1:6379> keys *
1) "sea"
2) "search"
[root@lnmp redis]# grep database redis.conf
databases 16 #redis默认有16个数据库
127.0.0.1:6379> select 1 #切换1号数据库，总共为0-15
OK
127.0.0.1:6379[1]> keys * #因为我们之前设置的是0数据库上，所以在1号数据库上没有数据
(empty list or set)
127.0.0.1:6379[1]> select 0
OK
127.0.0.1:6379> keys *
1) "sea"
2) "search"
127.0.0.1:6379> move sea 1 #移动key到1号数据库上
(integer) 1
127.0.0.1:6379> select 1
OK
127.0.0.1:6379[1]> keys *
1) "sea"
127.0.0.1:6379> ttl search #查询key的有效期，-1表示永远不失效,单位是秒数
(integer) -1
127.0.0.1:6379> ttl aa #当返回-2是表示为不存在的key
(integer) -2
127.0.0.1:6379> expire search 10 #设置这个key是10秒有效期
(integer) 1
127.0.0.1:6379> get search
"www.so.com"
127.0.0.1:6379> ttl search
(integer) 1
127.0.0.1:6379> ttl search #此时这个key为-2表示key已经没有了
(integer) -2
注：设置毫秒的为pexpire命令,显示key的毫秒级有效期为pttl
127.0.0.1:6379[1]> expire sea 10 #设置key的有效时间
(integer) 1
127.0.0.1:6379[1]> ttl sea
(integer) 8
127.0.0.1:6379[1]> ttl sea
(integer) 7
127.0.0.1:6379[1]> persist sea #设置key为永久有效
(integer) 1
127.0.0.1:6379[1]> ttl sea
(integer) -1
127.0.0.1:6379[1]> get sea
"www.zixue.it"

#第三节：redis字符串类型的操作
127.0.0.1:6379[1]> keys *
1) "sea"
127.0.0.1:6379[1]> flushdb #清空1号数据库
OK
127.0.0.1:6379[1]> keys *
(empty list or set)
127.0.0.1:6379> set site www.zuxue.it
OK
127.0.0.1:6379> set site www.baidu.com nx #表示不存在时才创建或修改
(nil)
127.0.0.1:6379> set site www.baidu.com xx #表示存在时才创建或修改
OK
127.0.0.1:6379> set test tt ex 10 #设置key并指定有效时间，ex为秒，px为毫秒
OK
127.0.0.1:6379> ttl test
(integer) 7
127.0.0.1:6379> ttl test
(integer) -2
127.0.0.1:6379> mset a 1 b 2 c 3 #一次设置多个key
OK
127.0.0.1:6379> keys *
1) "c"
2) "a"
3) "b"
127.0.0.1:6379> mget a b c #一次获取多个key
1) "1"
2) "2"
3) "3"
127.0.0.1:6379> set test hello
OK
127.0.0.1:6379> get test
"hello"
127.0.0.1:6379> setrange test 2 aa #设置字符串范围值，偏移量为2开始设置
(integer) 5
127.0.0.1:6379> get test
"heaao"
127.0.0.1:6379> set long hello
OK
127.0.0.1:6379> get long
"hello"
127.0.0.1:6379> setrange long 6 aa #当原字符串长度没有指定偏移量长，则用\x00填充
(integer) 8
127.0.0.1:6379> get long
"hello\x00aa"
127.0.0.1:6379> append test jack #追加字符串到key中
(integer) 9
127.0.0.1:6379> get test
"heaaojack"
127.0.0.1:6379> get long
"hello\x00aa"
127.0.0.1:6379> getrange long 4 5 #获取字符串的范围，指定偏移量和长度
"o\x00"
注意: 
1: start>=length, 则返回空字符串
2: stop>=length,则截取至字符结尾

127.0.0.1:6379> set status sleep
OK
127.0.0.1:6379> getset status wakeup #先获取旧值，然后设置新值
"sleep"
127.0.0.1:6379> get status
"wakeup"
127.0.0.1:6379> getset status working
"wakeup"
127.0.0.1:6379> set age 25
OK
127.0.0.1:6379> get age
"25"
127.0.0.1:6379> incr age #自增长1
(integer) 26
127.0.0.1:6379> decr age #自减少1
(integer) 25
127.0.0.1:6379> incrby age 5 #自增长5
(integer) 30
127.0.0.1:6379> decrby age 10
(integer) 20
127.0.0.1:6379> incrbyfloat age 0.3 #自增加0.3
"20.3"
例：
A 01000001
a 01100001
127.0.0.1:6379> set char A
OK
127.0.0.1:6379> setbit char 2 1 #设置char的值的二进制数的第2位偏移量值设为1
(integer) 0
127.0.0.1:6379> get char  #可以把大写变小写，反之亦然
"a"
127.0.0.1:6379> setbit char 4294967296 1
(error) ERR bit offset is not an integer or out of range
127.0.0.1:6379> setbit char 4294967295 1  #最大2^32-1
(integer) 0
设置offset对应二进制位上的值
返回: 该位上的旧值
注意: 
1:如果offset过大,则会在中间填充0,
3:offset最大2^32-1,可推出最大的的字符串为512M

127.0.0.1:6379> setbit lower 2 1 #设置lower的二进制值的第2个偏移量值为1
(integer) 0
127.0.0.1:6379> set char A
OK
127.0.0.1:6379> bitop or test char lower #char和lower两个key交集后生成的值为char 
(integer) 1
127.0.0.1:6379> get test #交集的结果为小写a
"a"
对key1,key2..keyN作operation,并将结果保存到 destkey 上。
operation 可以是 AND 、 OR 、 NOT 、 XOR
a:1001
b:1011
1001 and  #表示多个key中对应位值都为1时才显示为1
1011 or  #表示多个key中对应位值都为1或者有1时才显示为1
0010 xor  #表示多个key中对应位值不同时才显示为1
bitop not j a #此时j的值跟a的值相反，为011011..，后面0的都为1
#第四节：redis的list结构及命令详解
#link链表结果：
127.0.0.1:6379> lpush character a #left push到character值为a
(integer) 1
127.0.0.1:6379> rpush character b  #right push到character值为b
(integer) 2
127.0.0.1:6379> rpush character d
(integer) 3
127.0.0.1:6379> lpush character 8
(integer) 4
127.0.0.1:6379> lrange character 0 -1 #link range显示character键的0到-1的值
1) "8"
2) "a"
3) "b"
4) "d"
127.0.0.1:6379> lpop character  #left pop删除character最左侧的值
"8"
127.0.0.1:6379> rpop character
"d"
127.0.0.1:6379> lrange character 0 -1
1) "a"
2) "b"
127.0.0.1:6379> rpush aa a b c d a d a  #从右边push值
(integer) 7
127.0.0.1:6379> lrange aa 0 -1
1) "a"
2) "b"
3) "c"
4) "d"
5) "a"
6) "d"
7) "a"
127.0.0.1:6379> lrem aa 1 b #link remove移除b,从前面开始删除1个
(integer) 1
127.0.0.1:6379> lrange aa 0 -1
1) "a"
2) "c"
3) "d"
4) "a"
5) "d"
6) "a"
127.0.0.1:6379> lrem aa -2 a #link remove移除a,从后面开始删除2个
(integer) 2
127.0.0.1:6379> lrange aa 0 -1
1) "a"
2) "c"
3) "d"
4) "d"

127.0.0.1:6379> rpush char a b c d e f  
(integer) 6
127.0.0.1:6379> lrange char 0 -1
1) "a"
2) "b"
3) "c"
4) "d"
5) "e"
6) "f"
127.0.0.1:6379> ltrim char 2 5  #link trim截取
OK
127.0.0.1:6379> lrange char 0 -1
1) "c"
2) "d"
3) "e"
4) "f"
127.0.0.1:6379> ltrim char 1 -2
OK
127.0.0.1:6379> lrange char 0 -1
1) "d"
2) "e"
127.0.0.1:6379> lindex char 1 #link index 显示索引的值
"e"
127.0.0.1:6379> llen char  #link length显示key的长度
(integer) 2
LINSERT key BEFORE|AFTER pivot value
127.0.0.1:6379> rpush int 1 3 5 8 9 
(integer) 5
127.0.0.1:6379> lrange int
(error) ERR wrong number of arguments for 'lrange' command
127.0.0.1:6379> lrange int 0 -1
1) "1"
2) "3"
3) "5"
4) "8"
5) "9"
127.0.0.1:6379> linsert int before 7 6
(integer) -1
127.0.0.1:6379> lrange int 0 -1
1) "1"
2) "3"
3) "5"
4) "8"
5) "9"
127.0.0.1:6379> linsert int before 8 6
(integer) 6
127.0.0.1:6379> lrange int 0 -1
1) "1"
2) "3"
3) "5"
4) "6"
5) "8"
6) "9"

RPOPLPUSH source destination
作用: 把source的尾部拿出,放在dest的头部,
并返回 该单元值
业务逻辑:
1:Rpoplpush task bak
2:接收返回值,并做业务处理
3:如果成功,rpop bak 清除任务. 如不成功,下次从bak表里取任务
127.0.0.1:6379> rpush num a 2 b 4 d 5
(integer) 6
127.0.0.1:6379> lrange num 0 -1
1) "a"
2) "2"
3) "b"
4) "4"
5) "d"
6) "5"
127.0.0.1:6379> rpoplpush num tmp #先rpop键num的最后一个值5，然后把这个值lpush给新键tmp
"5"
127.0.0.1:6379> lrange tmp 0 -1
1) "5"
127.0.0.1:6379> lrange num 0 -1
1) "a"
2) "2"
3) "b"
4) "4"
5) "d"

127.0.0.1:6379> brpop job 50 #brpop一直等待在50秒时间内，直到key中有值时才rpop并结束，否则等待计时器的到来，时间为0,则一直等待
1) "job"
2) "1"
(24.10s)  #等到rpush值时花了多少时间
127.0.0.1:6379> rpush job 1 #这个是push一个值
(integer) 1

#第五节：位图法统计活跃用户
#题目：
1. 1亿个用户，用户有频繁登陆的，也有不经常登陆的。
2. 如何来记录用户的登陆信息
3. 如何来查询活跃用户[如1周内登陆3次的]
注：如果用数据库理论是可以完成，但是效率太低下。如果用redis来可以快速并便捷
#如下表示5个用户每天登录时为1，没登录时为0
周一：1 0 1 0 1
周二：1 1 1 0 1
周三: 1 1 1 0 1

127.0.0.1:6379> setbit one 4 0 #假如有5个用户，初始化这个key它的长度为5个用户，并且都为0
(integer) 0
127.0.0.1:6379> setbit one 0 1  #设置第1个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit one 2 1 #设置第3个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit one 4 1  #设置第5个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit two 4 0  #假如有5个用户，初始化这个key它的长度为5个用户，并且都为0
(integer) 0
127.0.0.1:6379> setbit two 0 1 #设置第1个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit two 1 1 #设置第2个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit two 2 1 #设置第3个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit two 4 1 #设置第5个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit the 4 0 #假如有5个用户，初始化这个key它的长度为5个用户，并且都为0
(integer) 0
127.0.0.1:6379> setbit the 0 1 #设置第1个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit the 1 1 #设置第2个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit the 2 1 #设置第3个用户为1表示登录
(integer) 0
127.0.0.1:6379> setbit the 4 1 #设置第25个用户为1表示登录
(integer) 0
127.0.0.1:6379> bitop and count one two the  #进行对bit操作，
(integer) 1
127.0.0.1:6379> getbit count 0  #给你一个用户UID为0时，表示这三天都连续登录过
(integer) 1
127.0.0.1:6379> getbit count 1  #给你一个用户UID为1时，表示这三天没连续登录过
(integer) 0
127.0.0.1:6379> getbit count 2  #给你一个用户UID为2时，表示这三天都连续登录过
(integer) 1
127.0.0.1:6379> getbit count 3  #给你一个用户UID为3时，表示这三天没连续登录过
(integer) 0
127.0.0.1:6379> getbit count 4  #给你一个用户UID为4时，表示这三天都连续登录过
(integer) 1
如上例,优点:
1: 节约空间, 1亿人每天的登陆情况,用1亿bit,约1200WByte,约10M 的字符就能表示
2: 计算方便

#第六节：set结构及命令详解
#集合
{1,2}=={2,1} #这两个集合是相等的
1. 无序性
2. 唯一性
3. 确定性
127.0.0.1:6379> sadd gender male female #set add 添加set
(integer) 2
127.0.0.1:6379> sadd gender yao yao  #只有一个yao生效，因为set是唯一性
(integer) 1
127.0.0.1:6379> smembers gender  #查看set集合，排序是无序的
1) "yao"
2) "male"
3) "female"
127.0.0.1:6379> srem gender yao #删除set集合的值
(integer) 1
127.0.0.1:6379> smembers gender
1) "male"
2) "female"
127.0.0.1:6379> smembers gender
1) "male"
2) "f"
3) "a"
4) "c"
5) "b"
6) "d"
7) "e"
8) "female"
9) "g"
127.0.0.1:6379> spop gender #随机删除一个集合值并显示它
"e"
127.0.0.1:6379> smembers gender 
1) "b"
2) "d"
3) "female"
4) "male"
5) "f"
6) "g"
7) "c"
8) "a"
127.0.0.1:6379> srandmember gender #随机拿出一个集合值但不删除它
"d"
127.0.0.1:6379> smembers gender
1) "female"
2) "male"
3) "f"
4) "g"
5) "c"
6) "a"
7) "d"
8) "b"
127.0.0.1:6379> sismember gender g #查看g是否集合gender中的成员
(integer) 1
127.0.0.1:6379> scard gender #显示set集合中的成员个数
(integer) 8

127.0.0.1:6379> sadd lower a b 
(integer) 2
127.0.0.1:6379> sadd upper A B 
(integer) 2
127.0.0.1:6379> smove lower upper a #移动lower的值a这upper集合中
(integer) 1
127.0.0.1:6379> smembers lower
1) "b"
127.0.0.1:6379> smembers upper
1) "a"
2) "A"
3) "B"

127.0.0.1:6379> sadd bob a b c 
(integer) 3
127.0.0.1:6379> sadd jack b c d 
(integer) 3
127.0.0.1:6379> sinter jack bob #查看集合中的交集
1) "c"
2) "b"
127.0.0.1:6379> sunion jack bob #查看集合中的并集
1) "a"
2) "c"
3) "b"
4) "d"
127.0.0.1:6379> sdiff jack bob #查看集合中的差集，用jack的值减去与bob交集的值后得出来的结果
1) "d"
127.0.0.1:6379> sinterstore result jack bob #set inter store集合交集结果存储在result中
(integer) 2
127.0.0.1:6379> smembers result
1) "c"
2) "b"
127.0.0.1:6379> sunionstore union jack bob  #set union store集合并集结果存储在union中
(integer) 4
127.0.0.1:6379> smembers union
1) "a"
2) "c"
3) "b"
4) "d"

#第七节：order set结构及命令详解
127.0.0.1:6379> zadd class 10 candy 20 jack 30 bob 3 sanmao #添加一个有序集合class,并设置score和对应的值，有序集合就是根据score的值去排序的
(integer) 4
127.0.0.1:6379> zrange class 0 -1 withscores #查看有序集合的范围，范围是第一个到倒数第一个，而且显示它们的score 
1) "sanmao"
2) "3"
3) "candy"
4) "10"
5) "jack"
6) "20"
7) "bob"
8) "30"
127.0.0.1:6379> zrangebyscore class 10 20  #通过score来查找有序集体的范围值，值是10到20之间并且包括本身的值。
1) "candy"
2) "jack"
127.0.0.1:6379> zrangebyscore class 10 20 limit 0 1 #比上面一个增加了limit限制显示，offset偏移量为0，表示第一个开始偏移，显示一个值
1) "candy"
127.0.0.1:6379> zrank class jack #以升序进行查找jack的排名
(integer) 2
127.0.0.1:6379> zrange class 0 -1
1) "sanmao"
2) "candy"
3) "jack"
4) "bob"
127.0.0.1:6379> zrevrank class jack #以降序进行查找jack的排名
(integer) 1
127.0.0.1:6379> zrange class 0 -1 withscores
1) "sanmao"
2) "3"
3) "candy"
4) "10"
5) "jack"
6) "20"
7) "bob"
8) "30"
127.0.0.1:6379> zremrangebyscore class 10 20 #通过score来删除class中的10到20的成员，也包括10和20的成员
(integer) 2
127.0.0.1:6379> zrange class 0 -1 withscores
1) "sanmao"
2) "3"
3) "bob"
4) "30"
127.0.0.1:6379> zrange class 0 -1 withscores
1) "sanmao"
2) "3"
3) "bob"
4) "30"
127.0.0.1:6379> zadd class 10 candy 20 jack
(integer) 2
127.0.0.1:6379> zrange class 0 -1 withscores
1) "sanmao"
2) "3"
3) "candy"
4) "10"
5) "jack"
6) "20"
7) "bob"
8) "30"
127.0.0.1:6379> zremrangebyrank class 0 1  #删除0到1的成员
(integer) 2
127.0.0.1:6379> zrange class 0 -1 withscores
1) "jack"
2) "20"
3) "bob"
4) "30"
127.0.0.1:6379> zrem class bob #删除指定成员
(integer) 1
127.0.0.1:6379> zrange class 0 -1 withscores
1) "jack"
2) "20"
127.0.0.1:6379> zadd class 30 zhangfei 35 guanyu
(integer) 2
127.0.0.1:6379> zrange class 0 -1 withscores
1) "jack"
2) "20"
3) "zhangfei"
4) "30"
5) "guanyu"
6) "35"
127.0.0.1:6379> zcard class #查看成员个数
(integer) 3
127.0.0.1:6379> zcount class 20 30 #查看指定score的成员个数
(integer) 2

127.0.0.1:6379> zadd lisi 3 dog 6 cat 8 pig 
(integer) 3
127.0.0.1:6379> zadd wang 2 dog 5 cat 10 pig 2 panda
(integer) 4
127.0.0.1:6379> zinterstore result 2 lisi wang aggregate sum #计算有序集合的交集并存储在result上，指定2个有序集合为lisi,wang，并且进行算术运算求和，默认也是求和，其他还有max,min
(integer) 3
127.0.0.1:6379> zrange result 0 -1 withscores
1) "dog"
2) "5"
3) "cat"
4) "11"
5) "pig"
6) "18"
127.0.0.1:6379> zinterstore result 2 lisi wang aggregate max
(integer) 3
127.0.0.1:6379> zrange result 0 -1 withscores
1) "dog"
2) "3"
3) "cat"
4) "6"
5) "pig"
6) "10"
127.0.0.1:6379> zinterstore result 2 lisi wang weights 2 1 aggregate max #这次设置了lisi的权重为2，wang为1，所以这次最大值lisi算了两遍，wang只算了一遍
(integer) 3
127.0.0.1:6379> zrange result 0 -1 withscores
1) "dog"
2) "6"
3) "cat"
4) "12"
5) "pig"
6) "16"
127.0.0.1:6379> zunionstore result 2 lisi wang  aggregate max #计算并集的
(integer) 4
127.0.0.1:6379> zrange result 0 -1 withscores
1) "panda"
2) "2"
3) "dog"
4) "3"
5) "cat"
6) "6"
7) "pig"
8) "10"

#第八节：hash结构及命令详解
127.0.0.1:6379> hset user1 name jack age 25 height 174 #hash set 
(integer) 3
127.0.0.1:6379> hlen user1
(integer) 3
127.0.0.1:6379> hgetall user1
1) "name"
2) "jack"
3) "age"
4) "25"
5) "height"
6) "174"
127.0.0.1:6379> hmget user1 name age
1) "jack"
2) "25"
127.0.0.1:6379> hmset user2 name bob age 40 height 169 
OK
127.0.0.1:6379> hgetall user2
1) "name"
2) "bob"
3) "age"
4) "40"
5) "height"
6) "169"
127.0.0.1:6379> hdel user2 age height
(integer) 2
127.0.0.1:6379> hgetall user2
1) "name"
2) "bob"
127.0.0.1:6379> hset user1 name candy age 24
(integer) 0
127.0.0.1:6379> hmset user1 name candy age 24 #hmset和hset的区别在于hmset可以覆盖存在的值，而hset则不行
OK
127.0.0.1:6379> hgetall user1
1) "name"
2) "candy"
3) "age"
4) "24"
5) "height"
6) "174"
127.0.0.1:6379> hexists user1 name #查看值是否存在
(integer) 1
127.0.0.1:6379> hgetall user1
1) "name"
2) "candy"
3) "age"
4) "24"
5) "height"
6) "174"
127.0.0.1:6379> hincrby user1 age 1 #自增加某个hash中键为age的值，增加为1
(integer) 25
127.0.0.1:6379> hgetall user1
1) "name"
2) "candy"
3) "age"
4) "25"
5) "height"
6) "174"
127.0.0.1:6379> hincrbyfloat user1 age 0.3 #自增加某个hash中键为age的值，增加为0.3，类型为float
(integer) 25
"25.3"
127.0.0.1:6379> hgetall user1
1) "name"
2) "candy"
3) "age"
4) "25.3"
5) "height"
6) "174"
127.0.0.1:6379> hkeys user1 #查看某个hash的键
1) "name"
2) "age"
3) "height"
127.0.0.1:6379> hvals user1 #查看某个hash的值
1) "candy"
2) "25.3"
3) "174"

#第九节：redis事务及锁应用
		mysql					redis
开始		start transaction		multi
语句		普通语句					普通语句
失败		rollback 				discard
成功		commit					exec
#redis的事务
127.0.0.1:6379> set zhao 300
OK
127.0.0.1:6379> set wang 700
OK
127.0.0.1:6379> multi
OK
127.0.0.1:6379> decrby wang 100
QUEUED
127.0.0.1:6379> incrby zhao 100
QUEUED
127.0.0.1:6379> exec
1) (integer) 600
2) (integer) 400
127.0.0.1:6379> mget wang zhao 
1) "600"
2) "400"
127.0.0.1:6379> multi
OK
127.0.0.1:6379> decrby wang 100
QUEUED
127.0.0.1:6379> sadd wang test123 #这个语法没问题，但是对于键wang来说不是同一个的的，所以后面不能执行成功这条语句，但前面执行成功了
QUEUED
127.0.0.1:6379> exec
1) (integer) 500
2) (error) WRONGTYPE Operation against a key holding the wrong kind of value
127.0.0.1:6379> mget wang zhao #这样结果就不行了。因为wang减了100，而zhao未加100
1) "500"
2) "400"
#watch：监控某个值，当值改变时事务会撤销，否则会执行
127.0.0.1:6379> set wang 700
OK
127.0.0.1:6379> set lisi 300
OK
127.0.0.1:6379> set ticket 1
OK
127.0.0.1:6379> watch ticket
OK
127.0.0.1:6379> multi
OK
127.0.0.1:6379> decr ticket
QUEUED
127.0.0.1:6379> decrby wang 100
QUEUED
127.0.0.1:6379> exec #当执行时前，另外一个终端已经改变了ticket值，所以未提交成功
(nil)
#watch key1 key2  #可以监控多个key，但是当某个key发生改变时整个事务将会取消
#unwatch #取消watch

#第十节：频道发布与消息订阅

