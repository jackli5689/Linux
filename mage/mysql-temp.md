memcached是旁路服务器，只是一个API
mysql proxy(需要lua插件)，amoeba，
mysql-mmm另外一个项目，是对mysql多主复制的管理工具，可以使mysql多主功能更好

mysql-proxy依赖包：
	libevent,lua,glib2,pkg-config,libtool,mysql-devel
rpm -q lua #确保已经安装lua，才可安装mysql-proxy
#源代码安装：
	./configure
	make && make install 

#使用通用二进制安装：
[root@lnmp mysql-proxy]# rpm -qa | grep lua #确保lua已经安装
lua-5.1.4-15.el7.x86_64
[root@lnmp download]# wget https://downloads.mysql.com/archives/get/file/mysql-proxy-0.8.3-linux-glibc2.3-x86-64bit.tar.gz
[root@lnmp download]# useradd -r mysql-proxy
[root@lnmp download]# tar xf mysql-proxy-0.8.3-linux-glibc2.3-x86-64bit.tar.gz -C /usr/local/
[root@lnmp download]# ln -sv /usr/local/mysql-proxy-0.8.3-linux-glibc2.3-x86-64bit/ /usr/local/mysql-proxy
‘/usr/local/mysql-proxy’ -> ‘/usr/local/mysql-proxy-0.8.3-linux-glibc2.3-x86-64bit/’
[root@lnmp mysql-proxy]# echo 'export PATH=$PATH:/usr/local/mysql-proxy/bin' > /etc/profile.d/mysql-proxy.sh
[root@lnmp mysql-proxy]# . /etc/profile.d/mysql-proxy.sh 
[root@lnmp mysql-proxy]# mysql-proxy --help-all
Usage:
  mysql-proxy [OPTION...] - MySQL Proxy

Help Options:
  -?, --help                                              Show help options
  --help-all                                              Show all help options
  --help-proxy                                            Show options for the proxy-module

proxy-module
  -P, --proxy-address=<host:port>                         #mysql-proxy地址
  -r, --proxy-read-only-backend-addresses=<host:port>     #只读后端服务器
  -b, --proxy-backend-addresses=<host:port>               #读写后端服务器
  --proxy-skip-profiling                                  disables profiling of queries (default: enabled)
  --proxy-fix-bug-25371                                   fix bug #25371 (mysqld > 5.1.12) for older libmysql versions
  -s, --proxy-lua-script=<file>                           #lua脚本路径
  --no-proxy                                              don't start the proxy-module (default: enabled)
  --proxy-pool-no-change-user                             don't use CHANGE_USER to reset the connection coming from the pool (default: enabled)
  --proxy-connect-timeout                                 #写超时时长
  --proxy-read-timeout                                    #读超时时长
  --proxy-write-timeout                                   #写超时时长

Application Options:
  -V, --version                                           Show version
  --defaults-file=<file>                                  #默认读取的配置文件路径
  --verbose-shutdown                                      Always log the exit code when shutting down
  --daemon                                                Start in daemon-mode
  --user=<user>                                           Run mysql-proxy as user
  --basedir=<absolute path>                               Base directory to prepend to relative paths in the config
  --pid-file=<file>                                       PID file in case we are started as daemon
  --plugin-dir=<path>                                     path to the plugins
  --plugins=<name>                                        plugins to load
  --log-level=(error|warning|info|message|debug)          log all messages of level ... or higher
  --log-file=<file>                                       log all messages in a file
  --log-use-syslog                                        log all messages to syslog
  --log-backtrace-on-crash                                try to invoke debugger on crash
  --keepalive                                             try to restart the proxy if it crashed
  --max-open-files                                        maximum number of open files (ulimit -n)
  --event-threads                                         number of event-handling threads (default: 1)
  --lua-path=<...>                                        set the LUA_PATH
  --lua-cpath=<...>                                       set the LUA_CPATH

[root@lnmp mysql-proxy]# mysql-proxy --daemon --log-level=debug --log-file=/var/log/mysql-proxy.log --plugins="proxy" --proxy-backend-addresses="192.168.1.31:3306" --proxy-read-only-backend-addresses="192.168.1.37:3306" #开启mysql-proxy，运行在4040端口，--plugins="proxy"必须开启proxy插件，否则无法启动
[root@lnmp mysql-proxy]# tail /var/log/mysql-proxy.log 
2019-07-02 22:44:50: (critical) plugin proxy 0.8.3 started
2019-07-02 22:44:50: (debug) max open file-descriptors = 1024
2019-07-02 22:44:50: (message) proxy listening on port :4040
2019-07-02 22:44:50: (message) added read/write backend: 192.168.1.31:3306
2019-07-02 22:44:50: (message) added read-only backend: 192.168.1.37:3306
#注：此时可以连接192.168.1.233:4040进行连接主从服务器，但mysql-proxy不会给我们进行读写分离，要想读写分离必须借助lua脚本才可实现

[root@lnmp mysql-proxy]# ls /usr/local/mysql-proxy/share/doc/mysql-proxy
active-queries.lua       ro-balance.lua           tutorial-resultset.lua
active-transactions.lua  ro-pooling.lua           tutorial-rewrite.lua
admin-sql.lua            rw-splitting.lua         tutorial-routing.lua
analyze-query.lua        tutorial-basic.lua       tutorial-scramble.lua
auditing.lua             tutorial-constants.lua   tutorial-states.lua
commit-obfuscator.lua    tutorial-inject.lua      tutorial-tokenize.lua
commit-obfuscator.msc    tutorial-keepalive.lua   tutorial-union.lua
COPYING                  tutorial-monitor.lua     tutorial-warnings.lua
histogram.lua            tutorial-packets.lua     xtab.lua
load-multi.lua           tutorial-prep-stmts.lua
README                   tutorial-query-time.lua
注： rw-splitting.lua这个脚本是实现读写分离的
[root@lnmp mysql-proxy]# killall mysql-proxy #先停掉服务
[root@lnmp mysql-proxy]# mysql-proxy --daemon --log-level=debug --log-file=/var/log/mysql-proxy.log --plugins="proxy" --proxy-backend-addresses="192.168.1.31:3306" --proxy-read-only-backend-addresses="192.168.1.37:3306" --proxy-lua-script="/usr/local/mysql-proxy/share/doc/mysql-proxy/rw-splitting.lua" #加入读写分离功能
[root@lnmp mysql-proxy]# cat /usr/local/mysql-proxy/share/doc/mysql-proxy/admin.lua 
---------------------mysql-proxy admin插件lua脚本--------------------------
function set_error(errmsg) 
        proxy.response = {
                type = proxy.MYSQLD_PACKET_ERR,
                errmsg = errmsg or "error"
        }
end

function read_query(packet)
        if packet:byte() ~= proxy.COM_QUERY then
                set_error("[admin] we only handle text-based queries (COM_QUERY)")
                return proxy.PROXY_SEND_RESULT
        end

        local query = packet:sub(2)

        local rows = { }
        local fields = { }

        if query:lower() == "select * from backends" then
                fields = { 
                        { name = "backend_ndx", 
                          type = proxy.MYSQL_TYPE_LONG },

                        { name = "address",
                          type = proxy.MYSQL_TYPE_STRING },
                        { name = "state",
                          type = proxy.MYSQL_TYPE_STRING },
                        { name = "type",
                          type = proxy.MYSQL_TYPE_STRING },
                        { name = "uuid",
                          type = proxy.MYSQL_TYPE_STRING },
                        { name = "connected_clients", 
                          type = proxy.MYSQL_TYPE_LONG },
                }

                for i = 1, #proxy.global.backends do
                        local states = {
                                "unknown",
                                "up",
                                "down"
                        }
                        local types = {
                                "unknown",
                                "rw",
                                "ro"
                        }
                        local b = proxy.global.backends[i]

                        rows[#rows + 1] = {
                                i,
                                b.dst.name,          -- configured backend address
                                states[b.state + 1], -- the C-id is pushed down starting at 0
                                types[b.type + 1],   -- the C-id is pushed down starting at 0
                                b.uuid,              -- the MySQL Server's UUID if it is managed
                                b.connected_clients  -- currently connected clients
                        }
                end
        elseif query:lower() == "select * from help" then
                fields = { 
                        { name = "command", 
                          type = proxy.MYSQL_TYPE_STRING },
                        { name = "description", 
                          type = proxy.MYSQL_TYPE_STRING },
                }
                rows[#rows + 1] = { "SELECT * FROM help", "shows this help" }
                rows[#rows + 1] = { "SELECT * FROM backends", "lists the backends and their state" }
        else
                set_error("use 'SELECT * FROM help' to see the supported commands")
                return proxy.PROXY_SEND_RESULT
        end

        proxy.response = {
                type = proxy.MYSQLD_PACKET_OK,
                resultset = {
                        fields = fields,
                        rows = rows
                }
        }
        return proxy.PROXY_SEND_RESULT
end
---------------------
[root@lnmp mysql-proxy]# killall mysql-proxy #先停掉服务
[root@lnmp mysql-proxy]# mysql-proxy --daemon --log-level=debug --log-file=/var/log/mysql-proxy.log --plugins="proxy" --proxy-backend-addresses="192.168.1.31:3306" --proxy-read-only-backend-addresses="192.168.1.37:3306" --proxy-lua-script="/usr/local/mysql-proxy/share/doc/mysql-proxy/rw-splitting.lua" --plugins=admin --admin-username="admin" --admin-password="admin" --admin-lua-script="/usr/local/mysql-proxy/share/doc/mysql-proxy/admin.lua" #重新启动，并再加新功能开启admin
[root@lnmp mysql-proxy]# tail /var/log/mysql-proxy.log 
2019-07-02 23:01:46: (message) shutting down normally, exit code is: 0
2019-07-02 23:04:38: (critical) mysql-proxy-cli.c:503: Unknown option --admin-lua-scripts=/usr/local/mysql-proxy/share/doc/mysql-proxy/admin.lua (use --help to show all options)
2019-07-02 23:04:38: (message) Initiating shutdown, requested from mysql-proxy-cli.c:513
2019-07-02 23:04:38: (message) shutting down normally, exit code is: 1
2019-07-02 23:05:24: (critical) plugin proxy 0.8.3 started
2019-07-02 23:05:24: (critical) plugin admin 0.8.3 started
2019-07-02 23:05:24: (debug) max open file-descriptors = 1024
2019-07-02 23:05:24: (message) proxy listening on port :4040  #已经启动
2019-07-02 23:05:24: (message) added read/write backend: 192.168.1.31:3306
2019-07-02 23:05:24: (message) added read-only backend: 192.168.1.37:3306
[root@lnmp mysql-proxy]# netstat -tnlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:4040            0.0.0.0:*               LISTEN      2643/mysql-proxy    #这个是mysql-proxy代理端口
tcp        0      0 127.0.0.1:9000          0.0.0.0:*               LISTEN      19324/php-fpm: pool 
tcp        0      0 0.0.0.0:4041            0.0.0.0:*               LISTEN      2643/mysql-proxy    #这个是管理接口
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      6663/mysqld         
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/systemd           
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      29371/nginx: master 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      4902/sshd           
tcp        0      0 0.0.0.0:10050           0.0.0.0:*               LISTEN      29685/zabbix_agentd 
tcp6       0      0 :::8009                 :::*                    LISTEN      24764/java          
tcp6       0      0 :::42445                :::*                    LISTEN      24764/java          
tcp6       0      0 :::111                  :::*                    LISTEN      1/systemd           
tcp6       0      0 :::8080                 :::*                    LISTEN      24764/java          
tcp6       0      0 :::22                   :::*                    LISTEN      4902/sshd           
tcp6       0      0 :::8888                 :::*                    LISTEN      24764/java          
tcp6       0      0 :::35192                :::*                    LISTEN      24764/java          
tcp6       0      0 :::10050                :::*                    LISTEN      29685/zabbix_agentd 
tcp6       0      0 :::10052                :::*                    LISTEN      28163/java          
tcp6       0      0 127.0.0.1:8005          :::*                    LISTEN      24764/java          
#测试：
mysql> grant all on *.* to root@'192.%' identified by 'redhat'; #连接到主建立可访问用户
mysql> flush privileges;
[root@mysql-slave ~]# mysql -u admin -p -h 192.168.1.233 --port 4041 #连接mysql-proxy admin管理接口，用户密码为设置的admin
Enter password: 
mysql> select * from backends; #连进来后只能使用这个命令查看主从节点信息和状态
+-------------+-------------------+---------+------+------+-------------------+
| backend_ndx | address           | state   | type | uuid | connected_clients |
+-------------+-------------------+---------+------+------+-------------------+
|           1 | 192.168.1.31:3306 | unknown | rw   | NULL |                 0 |
|           2 | 192.168.1.37:3306 | unknown | ro   | NULL |                 0 |
+-------------+-------------------+---------+------+------+-------------------+
[root@mysql-slave ~]# mysql -uroot -p -h 192.168.1.233 -P 4040 #连接mysql代理服务器进行路由
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.6.43-log MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database hellodb; #进行写操作
Query OK, 1 row affected (0.00 sec)
mysql> select * from backends;
+-------------+-------------------+---------+------+------+-------------------+
| backend_ndx | address           | state   | type | uuid | connected_clients |
+-------------+-------------------+---------+------+------+-------------------+
|           1 | 192.168.1.31:3306 | up      | rw   | NULL |                 0 | #此时这个状态为up，说明写操作路由到主节点上了
|           2 | 192.168.1.37:3306 | unknown | ro   | NULL |                 0 |
+-------------+-------------------+---------+------+------+-------------------+
2 rows in set (0.00 sec)
mysql> select user,password from mysql.user; #读操作
+----------+-------------------------------------------+
| user     | password                                  |
+----------+-------------------------------------------+
| root     |                                           |
| root     |                                           |
| root     |                                           |
| root     |                                           |
|          |                                           |
|          |                                           |
| repluser | *D98280F03D0F78162EBDBB9C883FC01395DEA2BF |
| root     | *84BB5DF4823DA319BBF86C99624479A198E6EEE9 |
+----------+-------------------------------------------+
mysql> select * from backends;
+-------------+-------------------+---------+------+------+-------------------+
| backend_ndx | address           | state   | type | uuid | connected_clients |
+-------------+-------------------+---------+------+------+-------------------+
|           1 | 192.168.1.31:3306 | up      | rw   | NULL |                 0 | #还是路由到主，概率问题
|           2 | 192.168.1.37:3306 | unknown | ro   | NULL |                 0 |
+-------------+-------------------+---------+------+------+-------------------+

#####mysql-proxy启动脚本
#注：分为mysql-proxy脚本和/etc/sysconfig/mysql-proxy配置文件
----------------
[root@lnmp mysql-proxy]# cat /etc/init.d/mysql-proxy 
#!/bin/bash
#
# mysql-proxy This script starts and stops the mysql-proxy daemon
#
# chkconfig: - 78 30
# processname: mysql-proxy
# description: mysql-proxy is a proxy daemon for mysql
 
# Source function library.
. /etc/rc.d/init.d/functions
 
prog="/usr/local/mysql-proxy/bin/mysql-proxy"
 
# Source networking configuration.
if [ -f /etc/sysconfig/network ]; then
    . /etc/sysconfig/network
fi
 
# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0
 
# Set default mysql-proxy configuration.
ADMIN_USER="admin"
ADMIN_PASSWD="admin"
ADMIN_LUA_SCRIPT="/usr/local/mysql-proxy/share/doc/mysql-proxy/admin.lua"
PROXY_OPTIONS="--daemon"
PROXY_PID=/var/run/mysql-proxy.pid
PROXY_USER="mysql-proxy"
PROXY_ADDRESS="0.0.0.0:4040"
 
# Source mysql-proxy configuration.
if [ -f /etc/sysconfig/mysql-proxy ]; then
    . /etc/sysconfig/mysql-proxy
fi
 
RETVAL=0
 
start() {
    echo -n $"Starting $prog: "
    daemon $prog $PROXY_OPTIONS --pid-file=$PROXY_PID --proxy-address="$PROXY_ADDRESS" --user=$PROXY_USER --admin-username="$ADMIN_USER" --admin-lua-script="$ADMIN_LUA_SCRIPT" --admin-password="$ADMIN_PASSWORD"
    RETVAL=$?
    echo
    if [ $RETVAL -eq 0 ]; then
        touch /var/lock/subsys/mysql-proxy
    fi
}
 
stop() {
    echo -n $"Stopping $prog: "
    killproc -p $PROXY_PID -d 3 $prog
    RETVAL=$?
    echo
    if [ $RETVAL -eq 0 ]; then
        rm -f /var/lock/subsys/mysql-proxy
        rm -f $PROXY_PID
    fi
}
# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    condrestart|try-restart)
        if status -p $PROXY_PIDFILE $prog >&/dev/null; then
            stop
            start
        fi
        ;;
    status)
        status -p $PROXY_PID $prog
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload|status|condrestart|try-restart}"
        RETVAL=1
        ;;
esac
 
exit $RETVAL
----------------
[root@lnmp mysql-proxy]# cat /etc/sysconfig/mysql-proxy 
# Options for mysql-proxy 
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"
ADMIN_LUA_SCRIPT="/usr/local/mysql-proxy/share/doc/mysql-proxy/admin.lua"
PROXY_LUA_SCRIPT="/usr/local/mysql-proxy/share/doc/mysql-proxy/rw-splitting.lua"
PROXY_ADDRESS="0.0.0.0:3306"
PROXY_USER="mysql-proxy"
PROXY_OPTIONS="--daemon --log-level=info --log-file=/var/log/mysql-proxy.log --plugins="proxy" --proxy-backend-addresses="192.168.1.31:3306" --proxy-read-only-backend-addresses="192.168.1.37:3306" --proxy-lua-script="$PROXY_LUA_SCRIPT" --plugins="admin" "
----------------
