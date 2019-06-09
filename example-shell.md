#SysV风格脚本
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