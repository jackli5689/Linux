#memcached
<pre>
将url的请求文件名为键，文件内容为值
支持text和binary
影响业务本身不影响数据本身，memcached只是一个缓存服务器
lazy模型的，懒惰的，只在不存满不会清除。
memcached:不通信的分布式缓存服务器
slab alllocator定义slab trunk的分片
slab trunk:存储每一类数据
memcached:1.缓存在内存当中，2.找到适当的trunk存储，难以避免内存浪费，3.hash存储，达到O(1)效果
#安装libevent:支持event-driven,nemcached需要它
[root@lnmp down]# wget https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz
[root@lnmp down]# tar xf libevent-2.1.10-stable.tar.gz 
[root@lnmp down]# cd libevent-2.1.10-stable/
[root@lnmp libevent-2.1.10-stable]# ./configure --prefix=/usr/local/libevent
[root@lnmp libevent-2.1.10-stable]# make && make install
#安装memcached
[root@lnmp down]# wget http://www.memcached.org/files/memcached-1.5.16.tar.gz
[root@lnmp down]# tar xf memcached-1.5.16.tar.gz 
[root@lnmp down]# cd memcached-1.5.16/
[root@lnmp down]# yum install -y cyrus-sasl-devel #安装sasl,memcached认证时需要
[root@lnmp memcached-1.5.16]# ./configure --prefix=/usr/local/memcached --enable-sasl --enable-sasl-pwdb --with-libevent=/usr/local/libevent
[root@lnmp memcached-1.5.16]# make && make install 
[root@lnmp memcached-1.5.16]# /usr/local/memcached/bin/memcached -m 128m -n 20 -f 1.1 -vv  -d -u nobody  #使用内存大小为128m，最小slab chunk为20，但是这memcache最小为72，增长因子系统为1.1，-d为后台运行，用户为nobody
[root@lnmp memcached-1.5.16]# netstat -tunlp | grep ':11211\>'
tcp        0      0 0.0.0.0:11211           0.0.0.0:*               LISTEN      4614/memcached      
tcp6       0      0 :::11211                :::*                    LISTEN      4614/memcached      
[root@lnmp memcached-1.5.16]# yum install telnet -y
[root@lnmp memcached-1.5.16]# telnet localhost 11211
Trying ::1...
Connected to localhost.
Escape character is '^]'.
<28 new auto-negotiating client connection
<28 stats
STAT pid 4614
STAT uptime 245
STAT time 1560064889
STAT version 1.5.16
STAT libevent 2.1.10-stable
STAT pointer_size 64
STAT rusage_user 0.027374
STAT rusage_system 0.015398
STAT max_connections 1024
STAT curr_connections 2
STAT total_connections 3
STAT rejected_connections 0
STAT connection_structures 3
STAT reserved_fds 20
STAT cmd_get 0
STAT cmd_set 0
STAT cmd_flush 0
STAT cmd_touch 0
STAT get_hits 0
STAT get_misses 0
STAT get_expired 0
STAT get_flushed 0
STAT delete_misses 0
STAT delete_hits 0
STAT incr_misses 0
STAT incr_hits 0
STAT decr_misses 0
STAT decr_hits 0
STAT cas_misses 0
STAT cas_hits 0
STAT cas_badval 0
STAT touch_hits 0
STAT touch_misses 0
STAT auth_cmds 0
STAT auth_errors 0
STAT bytes_read 7
STAT bytes_written 0
STAT limit_maxbytes 134217728
STAT accepting_conns 1
STAT listen_disabled_num 0
STAT time_in_listen_disabled_us 0
STAT threads 4
STAT conn_yields 0
STAT hash_power_level 16
STAT hash_bytes 524288
STAT hash_is_expanding 0
STAT slab_reassign_rescues 0
STAT slab_reassign_chunk_rescues 0
STAT slab_reassign_evictions_nomem 0
STAT slab_reassign_inline_reclaim 0
STAT slab_reassign_busy_items 0
STAT slab_reassign_busy_deletes 0
STAT slab_reassign_running 0
STAT slabs_moved 0
STAT lru_crawler_running 0
STAT lru_crawler_starts 765
STAT lru_maintainer_juggles 295
STAT malloc_fails 0
STAT log_worker_dropped 0
STAT log_worker_written 0
STAT log_watcher_skipped 0
STAT log_watcher_sent 0
STAT bytes 0
STAT curr_items 0
STAT total_items 0
STAT slab_global_page_pool 0
STAT expired_unfetched 0
STAT evicted_unfetched 0
STAT evicted_active 0
STAT evictions 0
STAT reclaimed 0
STAT crawler_reclaimed 0
STAT crawler_items_checked 0
STAT lrutail_reflocked 0
STAT moves_to_cold 0
STAT moves_to_warm 0
STAT moves_within_lru 0
STAT direct_reclaims 0
STAT lru_bumps_dropped 0
END
add mykey 0 30 5  #增加一个键
<28 add mykey 0 30 5
hello
>28 STORED
STORED
get mykey
<28 get mykey
>28 sending key mykey
>28 END
VALUE mykey 0 5
hello
END
<28 get mykey #过了30秒，所以没有缓存了
>28 END
END
#memcached脚本制作
--------------
[root@lnmp init.d]# cat memcached 
#!/bin/bash
#
#init file for memcached
#chkconfig: - 86 14
#description: Distributed memory caching daemon
#
#processname: memcached
#config: /etc/sysconfig/memcached

. /etc/rc.d/init.d/functions

##Default variables
PORT='11211'
USER='nobody'
MAXCONN='1024'
CACHESIZE='64'
OPTIONS=''

[ -f /etc/sysconfig/memcached ] && . /etc/sysconfig/memcached

RETVAL=0
prog="/usr/local/memcached/bin/memcached"
desc="Distributed memory caching"
lockfile="/var/lock/subsys/memcached"

start(){
        echo -n $"Starting $desc (memcached):"
        daemon $prog -d -p $PORT -u $USER -c $MAXCONN -m $CACHESIZE $OPTIONS
        RETVAL=$?
        echo 
        [ $RETVAL -eq 0 ] && touch $lockfile
        return $RETVAL
}

stop(){
        echo -n $"Shutting down $desc (memcached) "
        killproc $prog
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $lockfile
        return $RETVAL
}

restart (){
        stop
        start
}

reload(){
        echo -n $"Reloading $desc ($prog):"
        killproc $prog -HUP
        RETVAL=$?
        echo
        return $RETVAL
}

case "$1" in 
        start)
                start;;
        stop)
                stop;;
        restart)
                restart;;
        reload)
                reload;;
        status)
                status $prog;;
        condrestart)
                [ -e $lockfile ] && restart 
                RETVAL=$?;;
        *)
                echo $"Usage: $0 {start|stop|reload|restart|condrestart|status}"
                RETVAL=1;;
esac
exit #RETVAL
--------------
#memcached客户端
perl module
	cache::memcached
php
	memcache
	memcached  #比memcache功能更强大 
c/c++
	libmemcached
	以上都是命令行工具
memadmin：基于php的GUI工具
#安装php的memcache客户端：
wget http://pecl.php.net/get/memcache-2.2.6.tgz
[root@lnmp memcache-2.2.6]# /usr/local/php/bin/phpize 
Configuring for:
PHP Api Version:         20100412
Zend Module Api No:      20100525
Zend Extension Api No:   220100525
[root@lnmp memcache-2.2.6]# ./configure --with-php-config=/usr/local/php/bin/php-config --enable-memcache
[root@lnmp memcache-2.2.6]# make && make install 
[root@lnmp memcache-2.2.6]# cat /etc/php.d/memcache.ini
extension=/usr/local/php-5.4.24/lib/php/extensions/no-debug-non-zts-20100525/memcache.so
[root@lnmp memcache-2.2.6]# service php-fpm restart
Gracefully shutting down php-fpm . done
Starting php-fpm  done
然后可用phpinfo()函数查看memcache是否安装成功
phpinfo()脚本 
---------
[root@lnmp pma]# cat index.php 
<?php
$conn=mysql_connect('192.168.1.233','jack','jack123');
        if ($conn)
                echo "Success...";
        else
                echo "Faild.....";

phpinfo()
?>
---------
测试是否可以连接memcache脚本
---------
[root@lnmp pma]# cat test.php 
<?php
$mem = new Memcache;
$mem->connect("127.0.0.1",11211) or die("Could not connect");

$version = $mem->getVersion();
echo "Server's version: ".$version."<br/>\n";

$mem->set('testkey','Hello World',0,600) or die("Faild to save data at the memcached server");
echo "Store data in the cache (data will expire in 600 seconds)<br/>\n";

$get_result = $mem->get('testkey');
echo "$get_result is from memcached server.";
?>
---------
访问http://192.168.1.233/test.php
Server's version: 1.5.16
Store data in the cache (data will expire in 600 seconds)
Hello World is from memcached server. #提示已经存储在memcached中

[root@lnmp pma]# telnet localhost 11211
Trying ::1...
Connected to localhost.
Escape character is '^]'.
get testkey #查看确定存在
VALUE testkey 0 11
Hello World
END

###nginx整合memcached
server{
	listen 80;
	server_name www.magedu.com;
	location / {
		set $memcached_key $uri;  #设置memcached的键为uri路径
		memcached_pass	127.0.0.1:11211; #指定memcached服务器地址
		default_type	text/html;  #指定memcached默认查找的类型为text/html
		error_page		404 @fallback; #当memcached中没有找到缓存时调用@fallback
	}
	
	location @fallback {
		proxy_pass http://192.168.1.233;#当调用fallback函数时去找后端web server,然后将数据缓存在memcached当中
	}
}

##让session会话存储在memcached当中
[root@lnmp php-5.4.24]# vim /etc/php.ini  
session.save_handler = memcache
session.save_path = "tcp://192.168.1.233:11211?persistent=1&weight=1&timeout=1&retry_interval=15" #更改上面两行
session.name = PHPSESSID #这个以后要用到的，
#memadmin管理
[root@lnmp down]# wget http://www.junopen.com/memadmin/memadmin-1.0.12.tar.gz 


</pre>