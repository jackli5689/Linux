#Redis
#teacher:燕十八
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
redis-check-dump  快照文件检测工具,效果如上
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
127.0.0.1:6379> rename site search #此前老的search将会被覆盖
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
例：A和a的ASCII码二进制值
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
#link(list)类型插入的数据顺序是你插入值的先后顺序
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
127.0.0.1:6379> lrange int 0 -1
1) "1"
2) "3"
3) "5"
4) "8"
5) "9"
127.0.0.1:6379> linsert int before 7 6 #link insert 在7前面插入6，由于link中无7值，所以不成功 
(integer) -1
127.0.0.1:6379> lrange int 0 -1
1) "1"
2) "3"
3) "5"
4) "8"
5) "9"
127.0.0.1:6379> linsert int before 8 6  #link insert 在8前面插入6，由于link中有值，所以成功 
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
127.0.0.1:6379> rpush job 1 #这个是另外一们终端push的一个值
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
127.0.0.1:6379> multi  #进入事务
OK
127.0.0.1:6379> decrby wang 100 #wang减100
QUEUED
127.0.0.1:6379> incrby zhao 100 #zhao加100
QUEUED
127.0.0.1:6379> exec #提交执行
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
127.0.0.1:6379> subscribe news  #订阅news
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "news"
3) (integer) 1
127.0.0.1:6379> publish news 'test' #发布news
(integer) 1
127.0.0.1:6379> subscribe news 
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "news"
3) (integer) 1
1) "message"
2) "news"
3) "test"  #此时已经接收到消息了
127.0.0.1:6379> psubscribe new*  #用通配符来匹配频道订阅
Reading messages... (press Ctrl-C to quit)
1) "psubscribe"
2) "new*"
3) (integer) 1
1) "pmessage"
2) "new*"
127.0.0.1:6379> publish newstop 'psubscribe' #发布newstop频道
(integer) 1
127.0.0.1:6379> psubscribe new* 
Reading messages... (press Ctrl-C to quit)
1) "psubscribe"
2) "new*"
3) (integer) 1
1) "pmessage"
2) "new*"
3) "newstop"
4) "psubscribe"  #此时会自动接收到newstop的消息
#注：消息和订阅用于在线群聊和聊天室接收消息，非常方便

#第十一节：rdb快照持久化
#就是在某个时间从内存快照一份到持久存储设备上保存,恢复时则从持久设备到内存中快速恢复.
[root@lnmp redis]# egrep -v '#|^$' /usr/local/redis/redis.conf 
save 900 1  #表示15分钟内有1次改变时才写入到持久设备
save 300 10  #表示5分钟内有10次改变时才写入到持久设备
save 60 10000  #表示1分钟内有10000次改变时才写入到持久设备
stop-writes-on-bgsave-error yes #表示rdb导出时发生错误则停止客户端写入，否则数据会更加不一致
rdbcompression yes  #rdb压缩
rdbchecksum yes  #rdb从持久设备导入到内存时检查rdb的校验码是否和导出的校验码一致。
dbfilename dump.rdb #导出rdb的名称
dir ./ #rdb的放置路径
#注：如果注释save保存的参数，则不导出保存rdb了
[root@lnmp redis]# mkdir /var/rdb
[root@lnmp redis]# vim redis.conf 
save 900 1
save 300 10
save 60 3000 #更改为1分钟内更改了3000次则保存
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/rdb/  #更改dump.rdb的路径
[root@lnmp redis]# killall redis-server #停止redis
[root@lnmp redis]# redis-server redis.conf  #重新加载配置文件并重启服务
[root@lnmp redis]# ps aux | grep redis-server
root      4800  0.0  0.0 153892  2284 ?        Ssl  22:05   0:00 redis-server 127.0.0.1:6379
root      4886  0.0  0.0 112708   984 pts/3    S+   22:05   0:00 grep --color=auto redis-server
127.0.0.1:6379> set test 123 #选设置一个string类型键
OK
127.0.0.1:6379> get test
"123"
[root@lnmp redis]# redis-benchmark 3000 #用redis-benchmark工具测试3000次操作
====== 3000 ======
  100000 requests completed in 1.05 seconds
  50 parallel clients
  3 bytes payload
  keep alive: 1

99.98% <= 1 milliseconds
100.00% <= 1 milliseconds
94876.66 requests per second
[root@lnmp redis]# ls /var/rdb/ #此时满足了redis配置文件中的每一分钟3000次操作将dump rdb存储
dump.rdb
127.0.0.1:6379> set jack 456 #此时再设置一个string类型键
OK
127.0.0.1:6379> get jack
"456"
[root@lnmp rdb]# killall redis-server #假设redis服务突然断电导出服务中断
[root@lnmp rdb]# redis-server /usr/local/redis/redis.conf  #假如电恢复时服务重新上线
127.0.0.1:6379> get jack #此时再获取时无值,表示这个没有达到导出rdb存储的要求条件
#注:这时需要借助于aof日志持久化系统来修复这个问题,一般是由rdb跟aof结合使用

#第十二节:aof日志持久化
#aof参数文件注解:
appendonly yes #是否打开 aof日志功能
appendfsync always   # 每1个命令,都立即同步到aof. 安全,速度慢
appendfsync everysec # 折中方案,每秒写1次,建议这种方式
appendfilename "appendonly.aof" #设定aof文件名,默认路径是在之前设置的路径dir /var/rdb/下
appendfsync no      # 写入工作交给操作系统,由操作系统判断缓冲区大小,统一写入到aof. 同步频率低,速度快,
no-appendfsync-on-rewrite  yes: # 正在导出rdb快照的过程中,要不要停止同步aof
auto-aof-rewrite-percentage 100 #aof文件大小比起上次重写时的大小,增长率100%时,重写
auto-aof-rewrite-min-size 64mb #aof文件,至少超过64M时,重写
#[root@lnmp rdb]# egrep -v '#|^$' /usr/local/redis/redis.conf
appendonly yes
appendfsync everysec
appendfilename "appendonly.aof"
no-appendfsync-on-rewrite  yes
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 32mb
#aof重写:把记录redis-cli中的每个命令记入到aof文件时的命令重写成一条命令.
#注:现在我设置的是当appendonly.aof文件大于32M时就重写,这个场景会在用户一直接操作redis生成命令,aof会记录每条命令到aof日志当中,此aof日志文件会不断变大,当达到32M时就会重写,最后会变成几M大小不等,这个就是重写的效果
bgrewriteaof  #在redis-cli中手动命令aof日志文件重写

问: 2种是否可以同时用?
答: 可以,而且推荐这么做
问: 恢复时rdb和aof哪个恢复的快
答: rdb快,因为其是数据的内存映射,直接载入到内存,而aof是命令,需要逐条执行
问: 如果rdb文件,和aof文件都存在,优先用谁来恢复数据?
答: aof
注: 在dump rdb过程中,aof如果停止同步,会不会丢失?
答: 不会,所有的操作缓存在内存的队列里, dump完成后,统一操作.
注: aof重写是指什么?
答: aof重写是指把内存中的数据,逆化成命令,写入到.aof日志里.
以解决 aof日志过大的问题.

#redis集群
#主从复制架构1
		从   	
主
		从
#主从复制架构2
主------从1------从2
#注：架构2的会好，因为当主挂了，直接会把从1当成主，而从2不会变。而架构1主坏了，从redis之间还要进行协商选举，相对麻烦
#主从复制原理：
1）从服务器向主服务器发送 SYNC 命令。
2）接到 SYNC 命令的主服务器会调用BGSAVE 命令，创建一个 RDB 文件，并使用缓冲区记录接下来执行的所有写命令。
3）当主服务器执行完 BGSAVE 命令时，它会向从服务器发送 RDB 文件，而从服务器则会接收并载入这个文件。
4）主服务器将缓冲区储存的所有写命令发送给从服务器执行。
#SYNC与PSYNC
1）在 Redis2.8版本之前，断线之后重连的从服务器总要执行一次完整重同步（fullresynchronization）操作。
2）从 Redis2.8开始，Redis使用PSYNC命令代替SYNC命令。
3）PSYNC比起SYNC的最大改进在于PSYNC实现了部分重同步（partial resync）特性：
在主从服务器断线并且重新连接的时候，只要条件允许，PSYNC可以让主服务器只向从服务器同步断线期间缺失的数据，而不用重新向从服务器同步整个数据库。
注：
PSYNC这个特性需要主服务器为被发送的复制流创建一个内存缓冲区（in-memory backlog）， 并且主服务器和所有从服务器之间都记录一个复制偏移量（replication offset）和一个主服务器 ID（master run id），当出现网络连接断开时，从服务器会重新连接，并且向主服务器请求继续执行原来的复制进程：
1）如果从服务器记录的主服务器ID和当前要连接的主服务器的ID相同，并且从服务器记录的偏移量所指定的数据仍然保存在主服务器的复制流缓冲区里面，那么主服务器会向从服务器发送断线时缺失的那部分数据，然后复制工作可以继续执行。
2）否则的话，从服务器就要执行完整重同步操作。
#PSYNC经常断线
1）PSYNC只会将从服务器断线期间缺失的数据发送给从服务器。两个例子的情况是相同的，但SYNC 需要发送包含整个数据库的 RDB 文件，而PSYNC 只需要发送三个命令。
2）如果主从服务器所处的网络环境并不那么好的话（经常断线），那么请尽量使用 Redis 2.8 或以上版本：通过使用 PSYNC 而不是 SYNC 来处理断线重连接，可以避免因为重复创建和传输 RDB文件而浪费大量的网络资源、计算资源和内存资源。
#Redis是怎么保证数据安全呢
1）从服务器以每秒一次的频率 PING 主服务器一次， 并报告复制流的处理情况。主服务器会记录各个从服务器最后一次向它发送 PING 的时间。用户可以通过配置， 指定网络延迟的最大值 min-slaves-max-lag ， 以及执行写操作所需的至少从服务器数量 min-slaves-to-write 。
2）如果至少有 min-slaves-to-write 个从服务器， 并且这些服务器的延迟值都少于 min-slaves-max-lag 秒， 那么主服务器就会执行客户端请求的写操作。你可以将这个特性看作 CAP 理论中的 C 的条件放宽版本： 尽管不能保证写操作的持久性， 但起码丢失数据的窗口会被严格限制在指定的秒数中。
3）另一方面， 如果条件达不到 min-slaves-to-write 和 min-slaves-max-lag 所指定的条件， 那么写操作就不会被执行， 主服务器会向请求执行写操作的客户端返回一个错误。

#实例环境：
角色	   				IP     端口
主库（master）	192.168.1.233 6379
从库（slave01）	192.168.1.233 6380
主库（slave02）	192.168.1.233 6381
#主redis：
[root@lnmp redis]# egrep -v '#|^$' /usr/local/redis/redis.conf  #主redis关闭rdb快照持久功能但开启aof日志持久功能
bind 127.0.0.1
protected-mode no
port 6379
daemonize yes
pidfile /var/run/redis_6379.pid
loglevel notice
logfile /usr/local/redis/redis.6379.log
databases 16
dbfilename dump.rdb
dir /var/rdb/6379
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite yes
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 32mb
#从1redis：
[root@lnmp redis]# egrep -v '#|^$' /usr/local/redis/redis6380.conf #从1redis开启rdb快照持久功能但关闭aof日志持久功能
bind 127.0.0.1
protected-mode no
port 6380
daemonize yes
pidfile /var/run/redis_6380.pid
loglevel notice
logfile /usr/local/redis/redis.6380.log
databases 16
save 900 1
save 300 10
save 60 3000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/rdb/6380
[root@lnmp redis]# mkdir  /var/rdb/6380 
#从2redis：
[root@lnmp redis]# egrep -v '#|^$' /usr/local/redis/redis6381.conf  #从1redis关闭rdb快照持久功能和关闭aof日志持久功能
bind 127.0.0.1
protected-mode no
port 6381
daemonize yes
pidfile /var/run/redis_6381.pid
loglevel notice
logfile /usr/local/redis/redis.6381.log
databases 16
dbfilename dump.rdb
dir /var/rdb/6381
[root@lnmp redis]# mkdir /var/rdb/6381
[root@lnmp redis]# redis-server redis.conf
[root@lnmp redis]# redis-server redis6380.conf
[root@lnmp redis]# redis-server redis6381.conf 
[root@lnmp redis]# ps aux | grep redis
root     10356  0.1  0.0 159520  3288 ?        Ssl  22:03   0:00 redis-server 127.0.0.1:6379
root     11537  0.0  0.0 153888  2276 ?        Ssl  22:06   0:00 redis-server 127.0.0.1:6380
root     12177  0.0  0.0 153888  2272 ?        Ssl  22:09   0:00 redis-server 127.0.0.1:6381
root     12192  0.0  0.0 112708   976 pts/0    S+   22:09   0:00 grep --color=auto redis
#开启主从
#从1redis加入主redis
[root@lnmp redis]# redis-cli -p 6380  #连接从1redis
127.0.0.1:6380> SLAVEOF 127.0.0.1 6379  #设置成主redis的从
OK
127.0.0.1:6380> info replication #查看主从信息
# Replication
role:slave  			 #角色变成了从库
master_host:127.0.0.1    #主库的ip
master_port:6379         #主库的端口
master_link_status:up
master_last_io_seconds_ago:2
master_sync_in_progress:0
slave_repl_offset:14
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:d4de459394e154cffab2bcac60ed4741854188d4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:14
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:14
#从2redis加入主redis
[root@lnmp ~]# redis-cli -p 6381   #连接从2redis
127.0.0.1:6381> slaveof 127.0.0.1 6379    #设置成主redis的从
OK
127.0.0.1:6381> info replication   #查看主从信息
# Replication
role:slave
master_host:127.0.0.1
master_port:6379
master_link_status:up
master_last_io_seconds_ago:4
master_sync_in_progress:0
slave_repl_offset:168
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:d4de459394e154cffab2bcac60ed4741854188d4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:168
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:169
repl_backlog_histlen:0
#在主redis上查看信息
[root@lnmp ~]# redis-cli -p 6379
127.0.0.1:6379> info replication
# Replication
role:master      #角色为主
connected_slaves:2   #有两个从
slave0:ip=127.0.0.1,port=6380,state=online,offset=280,lag=1  #从1redis的信息
slave1:ip=127.0.0.1,port=6381,state=online,offset=280,lag=1  #从2redis的信息
master_replid:d4de459394e154cffab2bcac60ed4741854188d4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:280
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:280
#####主从切换
[root@lnmp ~]# redis-cli -p 6379
127.0.0.1:6379> shutdown   #关闭主库
[root@lnmp ~]# redis-cli -p 6380  #登录从1redis
127.0.0.1:6380> info replication
# Replication
role:slave
master_host:127.0.0.1
master_port:6379
master_link_status:down   #主库状态已经down了
master_last_io_seconds_ago:-1
master_sync_in_progress:0
slave_repl_offset:420
master_link_down_since_seconds:15
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:d4de459394e154cffab2bcac60ed4741854188d4
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:420
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:420
#取消6380的主从关系 
127.0.0.1:6380> slaveof no one  #取消6380的主从关系 
OK
127.0.0.1:6380> info replication
# Replication
role:master   #此时角色为主
connected_slaves:0
master_replid:8dacbaaaa37c37a8384dd0045c28e7a9f4e79ce7
master_replid2:d4de459394e154cffab2bcac60ed4741854188d4
master_repl_offset:420
second_repl_offset:421
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:420
#将6381从库变成6380的从库
127.0.0.1:6381> slaveof 127.0.0.1 6380
OK
127.0.0.1:6381> info replication
# Replication
role:slave          #角色还是slave
master_host:127.0.0.1
master_port:6380         #主库的端口已经变成了6380
master_link_status:up
master_last_io_seconds_ago:1
master_sync_in_progress:0
slave_repl_offset:420
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:8dacbaaaa37c37a8384dd0045c28e7a9f4e79ce7
master_replid2:d4de459394e154cffab2bcac60ed4741854188d4
master_repl_offset:420
second_repl_offset:421
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:169
repl_backlog_histlen:252
#注：slaveof 127.0.0.1 6379或者replicaof 127.0.0.1 6379可以写入配置文件，可以解决一重启redis就需要再次重连的问题
#注：主服务器设置密码：redis.conf配置文件中写入requirepass passwd参数即可
#从服务器设置同步主服务器密码：redis.conf配置文件中写入masterauth passwd参数即可完成
#auth passwd #redis-cli使用密码登录

#第十四节：redis运维常用命令
127.0.0.1:6379> time
1) "1563288566"   #秒数
2) "547230"   	  #微秒数
127.0.0.1:6379> dbsize  #查看当前数据库下有几个key
(integer) 2
127.0.0.1:6379> bgrewriteaof  #手动执行重写aof
Background append only file rewriting started
[root@lnmp 6379]# ll
-rw-r--r-- 1 root root 219 Jul 16 22:52 appendonly.aof
[root@lnmp 6379]# ll
-rw-r--r-- 1 root root 155 Jul 16 22:52 appendonly.aof
[root@lnmp 6379]# ll
-rw-r--r-- 1 root root 207 Jul 16 22:45 dump.rdb
127.0.0.1:6379> save  #在当前进程手动执行rdb快照生成
OK
127.0.0.1:6379> lastsave
(integer) 1563289039
[root@lnmp 6379]# ll
-rw-r--r-- 1 root root 239 Jul 16 22:57 dump.rdb
127.0.0.1:6379> bgsave   #后台单起一个进程进行rdb快照生成
Background saving started
flushdb   #清空当前database数据库
flushall   #清空所有database数据库
info   #查看redis-server的信息
info stat | replication  #info后面可以跟详细参数
config get *  #获取所有参数，跟mysql的set变量差不多
127.0.0.1:6379> config set slowlog-log-slower-than 100 #设置慢日志的时间
127.0.0.1:6379> config get slowlog-log-slower-than
1) "slowlog-log-slower-than"
2) "100"
127.0.0.1:6379> slowlog get  #获取慢日志
shutdown [NOSAVE|SAVE] #关闭redis-server服务，后面可以设置参数是否保存后再关闭还是不保存后关闭

#第十五节：aof恢复与rdb服务器迁移
#假如在redis上误操作flushall后该怎么操作：
[root@lnmp redis]# redis-server redis6379.conf  #开启redis-server服务
[root@lnmp ~]# redis-cli
127.0.0.1:6379> set name jack  #假如设置两个值
OK
127.0.0.1:6379> set www www.mumuso.com
OK
127.0.0.1:6379> flushall  #误操作flushall该如何找回数据
OK
127.0.0.1:6379> shutdown nosave  #赶紧关闭redis-server服务，参数nosave表示并不把这条命令保存至aof
not connected> 
[root@lnmp 6379]# ls
appendonly.aof
[root@lnmp 6379]# vim appendonly.aof #编辑aof文件并删除flushall段参数，此做法必须在未执行rewrite aof时才有用，否则神仙也找不回来数据了
*2
$6
SELECT
$1
0
*3
$3
set
$4
name
$4
jack
*3
$3
set
$3
www
$14
www.mumuso.com  #删除后面的flushall段并保存退出
[root@lnmp ~]# redis-cli
127.0.0.1:6379> get name  #此时都还有，因为redis-server恢复时会先读取aof日志文件
"jack"
127.0.0.1:6379> get www
"www.mumuso.com"

#rdb服务器间迁移：
[root@lnmp 6379]# cp dump.rdb ../6381/  #复制rdb到另外一个redisServer上，名称为dump.rdb
[root@lnmp ~]# redis-server /usr/local/redis/redis6381.conf #让另外一台redisServer载入rdb，事前必须先在服务器设置好dir目录，此目录包含rdb和aof文件 
[root@lnmp ~]# redis-cli -p 6381  #连接另外一个redisServer
127.0.0.1:6381> keys *   #已经恢复
1) "name"
2) "www"
[root@lnmp 6379]# redis-check-rdb /var/rdb/6381/dump.rdb  #redis-check-rdb检查rdb的完整性
[offset 0] Checking RDB file /var/rdb/6381/dump.rdb
[offset 26] AUX FIELD redis-ver = '5.0.5'
[offset 40] AUX FIELD redis-bits = '64'
[offset 52] AUX FIELD ctime = '1563368768'
[offset 67] AUX FIELD used-mem = '1922936'
[offset 85] AUX FIELD repl-stream-db = '0'
[offset 135] AUX FIELD repl-id = '737bdbc0a114041705ecfc48a00669a76dbccaf0'
[offset 150] AUX FIELD repl-offset = '0'
[offset 166] AUX FIELD aof-preamble = '0'
[offset 168] Selecting DB ID 0
[offset 211] Checksum OK
[offset 211] \o/ RDB looks OK! \o/
[info] 2 keys read
[info] 0 expires
[info] 0 already expired
[root@lnmp 6379]# redis-check-aof appendonly.aof  #redis-check-aof表示检查aof文件的完整性
AOF analyzed: size=99, ok_up_to=99, diff=0
AOF is valid
注：config get和config set是在redis-cli命令行中进行设置和获取的

#第十六节：sentinel(哨兵)运维监控
#使用sentinel自动化故障转移redis主从架构
[root@lnmp ~]# cp /usr/local/src/redis-5.0.5/sentinel.conf /usr/local/redis/ #复制sentinal配置文件到redis根目录下
[root@lnmp ~]# egrep -v '#|^$' //usr/local/redis/sentinel.conf 
port 26379    #sentinal的监听端口
daemonize no   #是否为守护进程运行
pidfile /var/run/redis-sentinel.pid   #pid目录
logfile ""    #日志文件名称
dir /tmp   #系统文件存储目录
sentinel monitor mymaster 127.0.0.1 6379 2  #监控master的地址及端口，并指明当有多少个sentinel认为一个master失效时，master才算真正失效
sentinel down-after-milliseconds mymaster 30000  #指定了需要多少失效时间，一个master才会被这个sentinel主观地认为是不可用的。单位是毫秒，默认为30秒
sentinel parallel-syncs mymaster 1  #用来限制在一次故障转移之后，每次向新的主节点发起复制操作的从节点个数
sentinel failover-timeout mymaster 180000     
1. 同一个sentinel对同一个master两次failover之间的间隔时间。   
2. 当一个slave从一个错误的master那里同步数据开始计算时间。直到slave被纠正为向正确的master那里同步数据时。    
3.当想要取消一个正在进行的failover所需要的时间。    
4.当进行failover时，配置所有slaves指向新的master所需的最大时间。不过，即使过了这个超时，slaves依然会被正确配置为指向master，但是就不按parallel-syncs所配置的规则来了。
sentinel deny-scripts-reconfig yes #是否拒绝使用触发脚本
#实例：
[root@lnmp ~]# egrep -v '#|^$' //usr/local/redis/sentinel.conf #更改配置
port 26379
daemonize no
pidfile /var/run/redis-sentinel.pid
logfile "sentinel.log"
dir /tmp
sentinel monitor mymaster 127.0.0.1 6379 1
sentinel down-after-milliseconds mymaster 30000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 180000
sentinel deny-scripts-reconfig yes
[root@lnmp ~]# redis-server /usr/local/redis/sentinel.conf --sentinel #启动sentinel服务
[root@lnmp 6379]# redis-cli #模拟master服务停止
#sentinel会显示切换主成功，并重新把slave指向新主，这个新主是由sentinel随机选举的，如果想指定哪台slave被提升为主，可在对应的slave服务器上更改rdeis.conf配置文件：replica-priority 50
31017:X 17 Jul 2019 22:39:28.840 # +switch-master mymaster 127.0.0.1 6379 127.0.0.1 6380
31017:X 17 Jul 2019 22:39:28.840 * +slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6380
31017:X 17 Jul 2019 22:39:28.840 * +slave slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380
31017:X 17 Jul 2019 22:39:58.903 # +sdown slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380

127.0.0.1:6379> SHUTDOWN  #模拟master服务down
[root@lnmp ~]# redis-cli -p 6380
127.0.0.1:6380> info replication
# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6381,state=online,offset=3462,lag=0
[root@lnmp ~]# redis-cli -p 6381
127.0.0.1:6381> info replication
# Replication
role:slave
master_host:127.0.0.1
master_port:6380






