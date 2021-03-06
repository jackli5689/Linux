﻿#lvs
<pre>
#ipvs
从Linux内核版本2.6起，ip_vs code已经被整合进了内核中，因此，只要在编译内核的时候选择了ipvs的功能，您的Linux即能支持LVS。Linux 2.4.23以后的内核版本也整合了ip_vs code，但如果是更旧的内核版本，您得自己手动将ip_vs code整合进内核原码中，并重新编译内核方可使用lvs。

#ipvs类型：
	1. NAT:地址转换
	2. DR：直接路由
	3. TUN：隧道
NAT:
	1. 集群节点跟director必须在同一个IP网络中
	2. RIP（RealServer IP）通常是私用地址，仅用于各集群节点间的通信
	3. director位于client和realServer之间，并负责处理进出的所有通信
	4. realServer必须将网关指向DIP(DirectorIP)
	5. 支持端口映射
	6. realServer可以使用任意os
	7. 较大规模应用场景中，director易成为系统瓶颈（一般最多带10个RealServer）
DR:
	1. 集群节点跟director必须在同一个物理网络中
	2. RIP可以使用公网地址，实现便捷的远程管理和监控
	3. director仅负责处理入站请求，响应报文则由RealServer直接发往客户端
	4. 不支持端口映射
TUN:
	1. 集群节点可以跨越Internet
	2. RIP必须是公网地址
	3. director仅负责处理入站请求，响应报文则由RealServer直接发往客户端
	4. RealServer网关不能指向director
	5. 只有支持隧道功能的os才能用于realserver
	6. 不支持端口映射


#关于ipvsadm:
ipvs的命令行管理工具
ipvsadm是运行于用户空间、用来与ipvs交互的命令行工具，它的作用表现在：
1、定义在Director上进行dispatching的服务(service)，以及哪此服务器(server)用来提供此服务；
2、为每台同时提供某一种服务的服务器定义其权重（即概据服务器性能确定的其承担负载的能力）；
注：权重用整数来表示，有时候也可以将其设置为atomic_t；其有效表示值范围为24bit整数空间，即（2^24-1）；
因此，ipvsadm命令的主要作用表现在以下方面：
1、添加服务（通过设定其权重>0）；
2、关闭服务（通过设定其权重>0）；此应用场景中，已经连接的用户将可以继续使用此服务，直到其退出或超时；新的连接请求将被拒绝；
3、保存ipvs设置，通过使用“ipvsadm-sav > ipvsadm.sav”命令实现；
4、恢复ipvs设置，通过使用“ipvsadm-sav < ipvsadm.sav”命令实现；
5、显示ip_vs的版本号，下面的命令显示ipvs的hash表的大小为4k；
  # ipvsadm
    IP Virtual Server version 1.2.1 (size=4096)
6、显示ipvsadm的版本号
  # ipvsadm --version
   ipvsadm v1.24 2003/06/07 (compiled with popt and IPVS v1.2.0)
ipvsadm下载地址： http://www.linuxvirtualserver.org/software/ipvs.html#kernel-2.6

二、ipvsadm使用中应注意的问题
默认情况下，ipvsadm在输出主机信息时使用其主机名而非IP地址，因此，Director需要使用名称解析服务。如果没有设置名称解析服务、服务不可用或设置错误，ipvsadm将会一直等到名称解析超时后才返回。当然，ipvsadm需要解析的名称仅限于RealServer，考虑到DNS提供名称解析服务效率不高的情况，建议将所有RealServer的名称解析通过/etc/hosts文件来实现；

三、调度算法
四种静态算法：
	1. rr
	2. wrr
	3. dh
	4. sh
六种动态算法：
	1. lc
	2. wlc
	3. sed
	4. nq
	5. lblc
	6. lblcr
详解调度算法：
Director在接收到来自于Client的请求时，会基于"schedule"从RealServer中选择一个响应给Client。ipvs支持以下调度算法：
1、轮询（round robin, rr),加权轮询(Weighted round robin, wrr)——新的连接请求被轮流分配至各RealServer；算法的优点是其简洁性，它无需记录当前所有连接的状态，所以它是一种无状态调度。轮叫调度算法假设所有服务器处理性能均相同，不管服务器的当前连接数和响应速度。该算法相对简单，不适用于服务器组中处理性能不一的情况，而且当请求服务时间变化比较大时，轮叫调度算法容易导致服务器间的负载不平衡。
2、最少连接(least connected, lc)， 加权最少连接(weighted least connection, wlc)——新的连接请求将被分配至当前连接数最少的RealServer；最小连接调度是一种动态调度算法，它通过服务器当前所活跃的连接数来估计服务器的负载情况。调度器需要记录各个服务器已建立连接的数目，当一个请求被调度到某台服务器，其连接数加1；当连接中止或超时，其连接数减一。
3、基于局部性的最少链接调度（Locality-Based Least Connections Scheduling，lblc）——针对请求报文的目标IP地址的负载均衡调度，目前主要用于Cache集群系统，因为在Cache集群中客户请求报文的目标IP地址是变化的。这里假设任何后端服务器都可以处理任一请求，算法的设计目标是在服务器的负载基本平衡情况下，将相同目标IP地址的请求调度到同一台服务器，来提高各台服务器的访问局部性和主存Cache命中率，从而整个集群系统的处理能力。LBLC调度算法先根据请求的目标IP地址找出该目标IP地址最近使用的服务器，若该服务器是可用的且没有超载，将请求发送到该服务器；若服务器不存在，或者该服务器超载且有服务器处于其一半的工作负载，则用“最少链接”的原则选出一个可用的服务器，将请求发送到该服务器。
4、带复制的基于局部性最少链接调度（Locality-Based Least Connections with Replication Scheduling，lblcr）——也是针对目标IP地址的负载均衡，目前主要用于Cache集群系统。它与LBLC算法的不同之处是它要维护从一个目标IP地址到一组服务器的映射，而 LBLC算法维护从一个目标IP地址到一台服务器的映射。对于一个“热门”站点的服务请求，一台Cache 服务器可能会忙不过来处理这些请求。这时，LBLC调度算法会从所有的Cache服务器中按“最小连接”原则选出一台Cache服务器，映射该“热门”站点到这台Cache服务器，很快这台Cache服务器也会超载，就会重复上述过程选出新的Cache服务器。这样，可能会导致该“热门”站点的映像会出现在所有的Cache服务器上，降低了Cache服务器的使用效率。LBLCR调度算法将“热门”站点映射到一组Cache服务器（服务器集合），当该“热门”站点的请求负载增加时，会增加集合里的Cache服务器，来处理不断增长的负载；当该“热门”站点的请求负载降低时，会减少集合里的Cache服务器数目。这样，该“热门”站点的映像不太可能出现在所有的Cache服务器上，从而提供Cache集群系统的使用效率。LBLCR算法先根据请求的目标IP地址找出该目标IP地址对应的服务器组；按“最小连接”原则从该服务器组中选出一台服务器，若服务器没有超载，将请求发送到该服务器；若服务器超载；则按“最小连接”原则从整个集群中选出一台服务器，将该服务器加入到服务器组中，将请求发送到该服务器。同时，当该服务器组有一段时间没有被修改，将最忙的服务器从服务器组中删除，以降低复制的程度。
5、目标地址散列调度（Destination Hashing，dh）算法也是针对目标IP地址的负载均衡，但它是一种静态映射算法，通过一个散列（Hash）函数将一个目标IP地址映射到一台服务器。目标地址散列调度算法先根据请求的目标IP地址，作为散列键（Hash Key）从静态分配的散列表找出对应的服务器，若该服务器是可用的且未超载，将请求发送到该服务器，否则返回空。
6、源地址散列调度（Source Hashing，sh）算法正好与目标地址散列调度算法相反，它根据请求的源IP地址，作为散列键（Hash Key）从静态分配的散列表找出对应的服务器，若该服务器是可用的且未超载，将请求发送到该服务器，否则返回空。它采用的散列函数与目标地址散列调度算法的相同。除了将请求的目标IP地址换成请求的源IP地址外，它的算法流程与目标地址散列调度算法的基本相似。在实际应用中，源地址散列调度和目标地址散列调度可以结合使用在防火墙集群中，它们可以保证整个系统的唯一出入口。

四、关于LVS追踪标记fwmark：
如果LVS放置于多防火墙的网络中，并且每个防火墙都用到了状态追踪的机制，那么在回应一个针对于LVS的连接请求时必须经过此请求连接进来时的防火墙，否则，这个响应的数据包将会被丢弃。

#命令详解
查看LVS上当前的所有连接
# ipvsadm -Lcn   
或者
#cat /proc/net/ip_vs_conn
查看虚拟服务和RealServer上当前的连接数、数据包数和字节数的统计值，则可以使用下面的命令实现：
# ipvsadm -l --stats
查看包传递速率的近似精确值，可以使用下面的命令：
# ipvsadm -l --rate

#NAT:
LVS-NAT基于cisco的LocalDirector。VS/NAT不需要在RealServer上做任何设置，其只要能提供一个tcp/ip的协议栈即可，甚至其无论基于什么OS。基于VS/NAT，所有的入站数据包均由Director进行目标地址转换后转发至内部的RealServer，RealServer响应的数据包再由Director转换源地址后发回客户端。 
VS/NAT模式不能与netfilter兼容，因此，不能将VS/NAT模式的Director运行在netfilter的保护范围之中。现在已经有补丁可以解决此问题，但尚未被整合进ip_vs code。
        ____________
       |            |
       |  client    |
       |____________|                     
     CIP=192.168.0.253 (eth0)             
              |                           
              |                           
     VIP=192.168.0.220 (eth0)             
        ____________                      
       |            |                     
       |  director  |                     
       |____________|                     
     DIP=192.168.10.10 (eth1)         
              |                           
           (switch)------------------------
              |                           |
     RIP=192.168.10.2 (eth0)       RIP=192.168.10.3 (eth0)
        _____________               _____________
       |             |             |             |
       | realserver1 |             | realserver2 |
       |_____________|             |_____________|  
设置VS/NAT模式的LVS(这里以web服务为例)
Director:
建立服务
# ipvsadm -A -t VIP:PORT -s rr
如:
# ipvsadm -A -t 192.168.0.220:80 -s rr #-A添加director,-t表示tcp协议，VIP:PORT为director的服务地址，-s后面接调度算法，rr为round robin
设置转发：
# ipvsadm -a -t VIP:PORT -r RIP_N:PORT -m -w N #-a为添加RealServer,-t为Director服务器的tcp地址，VIP:PORT表示Director的地址，-r为RealServer，后面接RealServer地址，-m表示地址伪装（masquerade），用于地址转换，-w表示设置权重值，这里如要设置，首先Director必须为与加权相关的调度算法，否则无效
如：
# ipvsadm -a -t 192.168.0.220:80 -r 192.168.10.2 -m -w 1
# ipvsadm -a -t 192.168.0.220:80 -r 192.168.10.3 -m -w 1
打开路由转发功能
# echo "1" > /proc/sys/net/ipv4/ip_forward

服务控制脚本：
#!/bin/bash
#
# chkconfig: - 88 12
# description: LVS script for VS/NAT
#
. /etc/rc.d/init.d/functions
#
VIP=192.168.0.219
DIP=192.168.10.10
RIP1=192.168.10.11
RIP2=192.168.10.12
#
case "$1" in
start)           

  /sbin/ifconfig eth0:1 $VIP netmask 255.255.255.0 up

# Since this is the Director we must be able to forward packets
  echo 1 > /proc/sys/net/ipv4/ip_forward

# Clear all iptables rules.
  /sbin/iptables -F

# Reset iptables counters.
  /sbin/iptables -Z

# Clear all ipvsadm rules/services.
  /sbin/ipvsadm -C

# Add an IP virtual service for VIP 192.168.0.219 port 80
# In this recipe, we will use the round-robin scheduling method. 
# In production, however, you should use a weighted, dynamic scheduling method. 
  /sbin/ipvsadm -A -t $VIP:80 -s rr

# Now direct packets for this VIP to
# the real server IP (RIP) inside the cluster
  /sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -m
  /sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -m
  
  /bin/touch /var/lock/subsys/ipvsadm.lock
;;

stop)
# Stop forwarding packets
  echo 0 > /proc/sys/net/ipv4/ip_forward

# Reset ipvsadm
  /sbin/ipvsadm -C

# Bring down the VIP interface
  ifconfig eth0:1 down
  
  rm -rf /var/lock/subsys/ipvsadm.lock
;;

status)
  [ -e /var/lock/subsys/ipvsadm.lock ] && echo "ipvs is running..." || echo "ipvsadm is stopped..."
;;
*)
  echo "Usage: $0 {start|stop}"
;;
esac

#DR:
ARP问题：
                     __________
                     |        |
                     | client |
                     |________|
 	                       |
                         |
                      (router)
                         |
                         |
                         |       __________
                         |  DIP |          |
                         |------| director |
                         |  VIP |__________|
                         |
                         |
                         |
       ------------------------------------
       |                 |                |
       |                 |                |
   RIP1, VIP         RIP2, VIP        RIP3, VIP
 ______________    ______________    ______________
|              |  |              |  |              |
| realserver1  |  | realserver2  |  | realserver3  |
|______________|  |______________|  |______________|
在如上图的VS/DR或VS/TUN应用的一种模型中（所有机器都在同一个物理网络），所有机器（包括Director和RealServer）都使用了一个额外的IP地址，即VIP。当一个客户端向VIP发出一个连接请求时，此请求必须要连接至Director的VIP，而不能是RealServer的。因为，LVS的主要目标就是要Director负责调度这些连接请求至RealServer的。
因此，在Client发出至VIP的连接请求后，只能由Director将其MAC地址响应给客户端（也可能是直接与Director连接的路由设备），而Director则会相应的更新其ipvsadm table以追踪此连接，而后将其转发至后端的RealServer之一。
如果Client在请求建立至VIP的连接时由某RealServer响应了其请求，则Client会在其MAC table中建立起一个VIP至RealServer的对就关系，并以至进行后面的通信。此时，在Client看来只有一个RealServer而无法意识到其它服务器的存在。
为了解决此问题，可以通过在路由器上设置其转发规则来实现。当然，如果没有权限访问路由器并做出相应的设置，则只能通过传统的本地方式来解决此问题了。这些方法包括：
1、禁止RealServer响应对VIP的ARP请求；
2、在RealServer上隐藏VIP，以使得它们无法获知网络上的ARP请求；
3、基于“透明代理（Transparent Proxy）”或者“fwmark （firewall mark）”；
4、禁止ARP请求发往RealServers；
传统认为，解决ARP问题可以基于网络接口，也可以基于主机来实现。Linux采用了基于主机的方式，因为其可以在大多场景中工作良好，但LVS却并不属于这些场景之一，因此，过去实现此功能相当麻烦。现在可以通过设置arp_ignore和arp_announce，这变得相对简单的多了。
Linux 2.2和2.4（2.4.26之前的版本）的内核解决“ARP问题”的方法各不相同，且比较麻烦。幸运的是，2.4.26和2.6的内核中引入了两个新的调整ARP栈的标志（device flags）：arp_announce和arp_ignore。基于此，在DR/TUN的环境中，所有IPVS相关的设定均可使用arp_announce=2和arp_ignore=1/2/3来解决“ARP问题”了。
arp_annouce：Define different restriction levels for announcing the local source IP address from IP packets in ARP requests sent on interface；
	0 - (default) Use any local address, configured on any interface.
	1 - Try to avoid local addresses that are not in the target's subnet for this interface. 
	2 - Always use the best local address for this target.
	
arp_ignore: Define different modes for sending replies in response to received ARP requests that resolve local target IP address.
	0 - (default): reply for any local target IP address, configured on any interface.
	1 - reply only if the target IP address is local address configured on the incoming interface.
	2 - reply only if the target IP address is local address configured on the incoming interface and both with the sender's IP address are part from same subnet on this interface.
	3 - do not reply for local address configured with scope host, only resolutions for golbal and link addresses are replied.
	4-7 - reserved
	8 - do not reply for all local addresses
在RealServers上，VIP配置在本地回环接口lo上。如果回应给Client的数据包路由到了eth0接口上，则arp通告或请应该通过eth0实现，因此，需要在sysctl.conf文件中定义如下配置：
#vim /etc/sysctl.conf
net.ipv4.conf.eth0.arp_ignore = 1
net.ipv4.conf.eth0.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
以上选项需要在启用VIP之前进行，否则，则需要在Drector上清空arp表才能正常使用LVS。
#到达Director的数据包首先会经过PREROUTING，而后经过路由发现其目标地址为本地某接口的地址，因此，接着就会将数据包发往INPUT(LOCAL_IN HOOK)。此时，正在运行内核中的ipvs（始终监控着LOCAL_IN HOOK）进程会发现此数据包请求的是一个集群服务，因为其目标地址是VIP。于是，此数据包的本来到达本机(Director)目标行程被Director改变为经由POSTROUTING HOOK发往RealServer。这种改变数据包正常行程的过程是根据IPVS表(由管理员通过ipvsadm定义)来实现的。

如果有多台Realserver，在某些应用场景中，Director还需要基于“连接追踪”实现将由同一个客户机的请求始终发往其第一次被分配至的Realserver，以保证其请求的完整性等。其连接追踪的功能由Hash table实现。Hash table的大小等属性可通过下面的命令查看：
# ipvsadm -lcn

为了保证其时效性，Hash table中“连接追踪”信息被定义了“生存时间”。LVS为记录“连接超时”定义了三个计时器：
	1、空闲TCP会话；
	2、客户端正常断开连接后的TCP会话；
	3、无连接的UDP数据包（记录其两次发送数据包的时间间隔）；
上面三个计时器的默认值可以由类似下面的命令修改，其后面的值依次对应于上述的三个计时器：
# ipvsadm --set 28800 30 600

数据包在由Direcotr发往Realserver时，只有目标MAC地址发生了改变(变成了Realserver的MAC地址)。Realserver在接收到数据包后会根据本地路由表将数据包路由至本地回环设备，接着，监听于本地回环设备VIP上的服务则对进来的数据库进行相应的处理，而后将处理结果回应至RIP，但数据包的原地址依然是VIP。

ipvs的持久连接：
无论基于什么样的算法，只要期望源于同一个客户端的请求都由同一台Realserver响应时，就需要用到持久连接。比如，某一用户连续打开了三个telnet连接请求时，根据RR算法，其请求很可能会被分配至不同的Realserver，这通常不符合使用要求。
##DR模式脚本
#Director脚本:
#!/bin/bash
#
# LVS script for VS/DR
#
. /etc/rc.d/init.d/functions
#
VIP=192.168.0.210
RIP1=192.168.0.221
RIP2=192.168.0.222
PORT=80

#
case "$1" in
start)           

  /sbin/ifconfig eth0:1 $VIP broadcast $VIP netmask 255.255.255.255 up
  /sbin/route add -host $VIP dev eth0:1

# Since this is the Director we must be able to forward packets
  echo 1 > /proc/sys/net/ipv4/ip_forward

# Clear all iptables rules.
  /sbin/iptables -F

# Reset iptables counters.
  /sbin/iptables -Z

# Clear all ipvsadm rules/services.
  /sbin/ipvsadm -C

# Add an IP virtual service for VIP 192.168.0.219 port 80
# In this recipe, we will use the round-robin scheduling method. 
# In production, however, you should use a weighted, dynamic scheduling method. 
  /sbin/ipvsadm -A -t $VIP:80 -s wlc

# Now direct packets for this VIP to
# the real server IP (RIP) inside the cluster
  /sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -g -w 1
  /sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -g -w 2

  /bin/touch /var/lock/subsys/ipvsadm &> /dev/null
;; 

stop)
# Stop forwarding packets
  echo 0 > /proc/sys/net/ipv4/ip_forward

# Reset ipvsadm
  /sbin/ipvsadm -C

# Bring down the VIP interface
  /sbin/ifconfig eth0:1 down
  /sbin/route del $VIP
  
  /bin/rm -f /var/lock/subsys/ipvsadm
  
  echo "ipvs is stopped..."
;;

status)
  if [ ! -e /var/lock/subsys/ipvsadm ]; then
    echo "ipvsadm is stopped ..."
  else
    echo "ipvs is running ..."
    ipvsadm -L -n
  fi
;;
*)
  echo "Usage: $0 {start|stop|status}"
;;
esac


RealServer脚本:

#!/bin/bash
#
# Script to start LVS DR real server.
# description: LVS DR real server
#
.  /etc/rc.d/init.d/functions

VIP=192.168.0.219
host=`/bin/hostname`

case "$1" in
start)
       # Start LVS-DR real server on this machine.
        /sbin/ifconfig lo down
        /sbin/ifconfig lo up
        echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
        echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
        echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
        echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce

        /sbin/ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
        /sbin/route add -host $VIP dev lo:0

;;
stop)

        # Stop LVS-DR real server loopback device(s).
        /sbin/ifconfig lo:0 down
        echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
        echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
        echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
        echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce

;;
status)

        # Status of LVS-DR real server.
        islothere=`/sbin/ifconfig lo:0 | grep $VIP`
        isrothere=`netstat -rn | grep "lo:0" | grep $VIP`
        if [ ! "$islothere" -o ! "isrothere" ];then
            # Either the route or the lo:0 device
            # not found.
            echo "LVS-DR real server Stopped."
        else
            echo "LVS-DR real server Running."
        fi
;;
*)
            # Invalid entry.
            echo "$0: Usage: $0 {start|status|stop}"
            exit 1
;;
esac

#HeartBeat（检查心跳信息）
运行于备用主机上的Heartbeat可以通过以太网连接检测主服务器的运行状态，一旦其无法检测到主服务器的“心跳”则自动接管主服务器的资源。通常情况下，主、备服务器间的心跳连接是一个独立的物理连接，这个连接可以是串行线缆、一个由“交叉线”实现的以太网连接。Heartbeat甚至可同时通过多个物理连接检测主服务器的工作状态，而其只要能通过其中一个连接收到主服务器处于活动状态的信息，就会认为主服务器处于正常状态。从实践经验的角度来说，建议为Heartbeat配置多条独立的物理连接，以避免Heartbeat通信线路本身存在单点故障。
	1、串行电缆：被认为是比以太网连接安全性稍好些的连接方式，因为hacker无法通过串行连接运行诸如telnet、ssh或rsh类的程序，从而可以降低其通过已劫持的服务器再次侵入备份服务器的几率。但串行线缆受限于可用长度，因此主、备服务器的距离必须非常短。
	2、以太网连接：使用此方式可以消除串行线缆的在长度方面限制，并且可以通过此连接在主备服务器间同步文件系统，从而减少了从正常通信连接带宽的占用。

基于冗余的角度考虑，应该在主、备服务器使用两个物理连接传输heartbeat的控制信息；这样可以避免在一个网络或线缆故障时导致两个节点同时认为自已是唯一处于活动状态的服务器从而出现争用资源的情况，这种争用资源的场景即是所谓的“脑裂”（split-brain）或“partitioned cluster”。在两个节点共享同一个物理设备资源的情况下，脑裂会产生相当可怕的后果。
为了避免出现脑裂，可采用下面的预防措施：
1、如前所述，在主、备节点间建立一个冗余的、可靠的物理连接来同时传送控制信息；
2、一旦发生脑裂时，借助额外设备强制性地关闭其中一个节点；
第二种方式即是俗称的“将其它节点‘爆头’（shoot the other node in the head）”，简称为STONITH。基于能够通过软件指令关闭某节点特殊的硬件设备，Heartbeat即可实现可配置的Stonith。但当主、备服务器是基于WAN进行通信时，则很难避免“脑裂”情景的出现。因此，当构建异地“容灾”的应用时，应尽量避免主、备节点共享物理资源。

#Heartbeat的控制信息：
1. “心跳”信息: （也称为状态信息）仅150 bytes大小的广播、组播或多播数据包。可为以每个节点配置其向其它节点通报“心跳”信息的频率，以及其它节点上的heartbeat进程为了确认主节点出节点出现了运行等错误之前的等待时间。
2. 集群变动事务（transition）信息：ip-request和ip-request-rest是相对较常见的两种集群变动信息，它们在节点间需要进行资源迁移时为不同节点上heartbeat进程间会话传递信息。比如，当修复了主节点并且使其重新“上线”后，主节点会使用ip-request要求备用节点释放其此前从因主节点故障而从主节点那里接管的资源。此时，备用节点则关闭服务并使用ip-request-resp通知主节点其已经不再占用此前接管的资源。主接点收到ip-request-resp后就会重新启动服务。
3. 重传请求：在某集群节点发现其从其它节点接收到的heartbeat控制信息“失序”（heartbeat进程使用序列号来确保数据包在传输过程中没有被丢弃或出现错误）时，会要求对方重新传送此控制信息。 Heartbeat一般每一秒发送一次重传请求，以避免洪泛。

上面三种控制信息均基于UDP协议进行传送，可以在/etc/ha.d/ha.cf中指定其使用的UDP端口或者多播地址（使用以太网连接的情况下）。此外，除了使用“序列号/确认”机制来确保控制信息的可靠传输外，Heartbeat还会使用MD5或SHA1为每个数据包进行签名以确保传输中的控制信息的安全性。

#资源脚本：
资源脚本（resource scripts）即Heartbeat控制下的脚本。这些脚本可以添加或移除IP别名（IP alias)或从属IP地址（secondary IP address），或者包含了可以启动/停止服务能力之外数据包的处理功能等。通常，Heartbeat会到/etc/init.d/或/etc/ha.d/resource.d/目录中读取脚本文件。Heartbeat需要一直明确了解“资源”归哪个节点拥有或由哪个节点提供。在编写一个脚本来启动或停止某个资源时，一定在要脚本中明确判断出相关服务是否由当前系统所提供。


#Heartbeat的配置文件：
/etc/ha.d/ha.cf
定义位于不同节点上的heartbeat进程间如何进行通信；
/etc/ha.d/haresources
定义对某个资源来说哪个服务器是主节点，以及哪个节点应该拥有客户端访问资源时的目标IP地址。
/etc/ha.d/authkeys
定义Heartbeat包在通信过程中如何进行加密。

当ha.cf或authkeys文件发生改变时，需要重新加载它们就可以使用之生效；而如果haresource文件发生了改变，则只能重启heartbeat服务方可使之生效。

尽管Heartbeat并不要求主从节点间进行时钟同步，但它们彼此间的时间差距不能超过1分钟，否则一些配置为高可用的服务可能会出异常。

Heartbeat当前也不监控其所控制的资源的状态，比如它们是否正在运行，是否运行良好以及是否可供客户端访问等。要想监控这些资源，冉要使用额外的Mon软件包来实现。

haresources配置文件介绍：
主从节点上的/etc/ra.d/raresource文件必须完全相同。文件每行通常包含以下组成部分：
1、服务器名字：指正常情况下资源运行的那个节点（即主节点），后跟一个空格或tab；这里指定的名字必须跟某个节点上的命令"uname -n"的返回值相同；
2、IP别名（即额外的IP地址，可选）：在启动资源之前添加至系统的附加IP地址，后跟空格或tab；IP地址后面通常会跟一个子网掩码和广播地址，彼此间用“/”隔开；
3、资源脚本：即用来启动或停止资源的脚本，位于/etc/init.d/或/etc/ha.d/resourcd.d目录中；如果需要传递参数给资源脚本，脚本和参数之间需要用两个冒号分隔，多个参数时彼此间也需要用两个冒号分隔；如果有多个资源脚本，彼此间也需要使用空格隔开；

 格式如下：
 primary-server [IPaddress[/mask/interface/broadcast]]  resource1[::arg1::arg2]  resource2[::arg1::arg2]
 
 例如：
 primary-server 221.67.132.195 sendmail httpd

安装配置Heartbeat
yum install

cp /usr/share/doc/heartbeat-2*/authkeys, ha.cf, haresources

( echo -ne "auth 1\n1 sha1 "; \
  dd if=/dev/urandom bs=512 count=1 | openssl md5 ) \
  > /etc/ha.d/authkeys
chmod 0600 /etc/ha.d/authkeys

/usr/lib/heartbeat/ha_propagate


HA的LVS集群有两台Director，在启动时，主节点占有集群负载均衡资源（VIP和LVS的转发及高度规则），备用节点监听主节点的“心跳”信息并在主节点出现异常时进行“故障转移”而取得资源使用权，这包括如下步骤：
	1、添加VIP至其网络接口；
	2、广播GARP信息，通知网络内的其它主机目前本Director其占有VIP；
	3、创建IPVS表以实现入站请求连接的负载均衡；
	4、Stonith；	
	
弃用resource脚本，改用ldirecotord来控制LVS：
ldirectord用来实现LVS负载均衡资源的在主、备节点间的故障转移。在首次启动时，ldirectord可以自动创建IPVS表。此外，它还可以监控各Realserver的运行状态，一旦发现某Realserver运行异常时，还可以将其从IPVS表中移除。
ldirectord进程通过向Realserver的RIP发送资源访问请求并通过由Realserver返回的响应信息来确定Realserver的运行状态。在Director上，每一个VIP需要一个单独的ldirector进程。如果Realserver不能正常响应Directord上ldirectord的请求，ldirectord进程将通过ipvsadm命令将此Realserver从IPVS表中移除。而一旦Realserver再次上线，ldirectord会使用正确的ipvsadm命令将其信息重新添加至IPVS表中。
例如，为了监控一组提供web服务的Realserver，ldirectord进程使用HTTP协议请求访问每台Realserver上的某个特定网页。ldirectord进程根据自己的配置文件中事先定义了的Realserver的正常响应结果来判断当前的返回结果是否正常。比如，在每台web服务器的网站目录中存放一个页面".ldirector.html"，其内容为"GOOD"，ldirectord进程每隔一段时间就访问一次此网页，并根据获取到的响应信息来判断Realserver的运行状态是否正常。如果其返回的信息不是"GOOD"，则表明服务不正常。
ldirectord需要从/etc/ha.d/目录中读取配置文件，文件名可以任意，但建议最好见名知义。
实现过程：

创建/etc/ha.d/ldirectord-192.168.0.219.cf，添加如下内容：
# Global Directives
checktimeout=20    
# ldirectord等待Realserver健康检查完成的时间，单位为秒；
# 任何原因的检查错误或超过此时间限制，ldirector将会将此Realserver从IPVS表中移除；
checkinterval=5
# 每次检查的时间间隔，即检查的频率；
autoreload=yes
# 此项用来定义ldirectord是否定期每隔一段时间检查此配置文件是否发生改变并自动重新加载此文件；
logfile="/var/log/ldirectord.log"
# 定义日志文件存放位置；
quiescent=yes
# 当某台Realserver出现异常，此项可将其设置为静默状态（即其权重为“0”）从而不再响应客户端的访问请求；

# For an http virtual service
virtual=192.168.0.219:80
# 此项用来定义LVS服务及其使用的VIP和PORT
        real=192.168.0.221:80 gate 100
        # 定义Realserver，语法：real=RIP:port gate|masq|ipip [weight]
        real=192.168.0.223:80 gate 300
        fallback=127.0.0.1:80 gate
        # 当IPVS表没有任何可用的Realserver时，此“地址：端口”作为最后响应的服务；
        # 一般指向127.0.0.1，并可以通过一个包含错误信息的页面通知用户服务发生了异常；
        service=http
        # 定义基于什么服务来测试Realserver；
        request=".ldirectord.html"
        receive="GOOD"
        scheduler=wlc 
        #persistent=600
        #netmask=255.255.255.255
        protocol=tcp
        # 定义此虚拟服务用到的协议；
        checktype=negotiate
        # ldirectord进程用于监控Realserver的方法；{negotiate|connect|A number|off}
        checkport=80
        
在/etc/hd.d/haresources中添加类似如下行：
 node1.example.com 192.168.0.219 ldirectord::ldirectord-192.168.0.219.cf       

# yum install docbook-stype-xsl
# yum install net-snmp-devel
# yum install OpenIPMI-devel


# groupadd -g 694 haclient
# useradd -G haclient -d /dev/null -s /sbin/nologin -u 694 hacluster

安装glue和heartbeat
# wget http://hg.linux-ha.org/glue/archive/glue-1.0.3.tar.bz2
# tar jxvf glue-1.0.3.tar.bz2
# cd glue-1.0.3
# ./autogen.sh
# ./configure
# make
# make install

# wget http://hg.linux-ha.org/heartbeat-STABLE_3_0/archive/STABLE-3.0.2.tar.bz2
# tar jxvf STABLE-3.0.2.tar.bz2
# cd Heartbeat-3-0-STABLE-3.0.2/
# ./bootstrap
# ./ConfigureMe configure
# make
# make install
# cp doc/{ha.cf,haresources} /etc/ha.d/

生成authkeys：
# echo -ne "auth 1\n1 sha1 " >> /etc/ha.d/authkeys
# dd if=/dev/urandom bs=512 count=1 | openssl md5  >> /etc/ha.d/authkeys
# chmod 0600 /etc/ha.d/authkeys

将heartbeat服务加入到自动启动队列：
# chkconfig --add heartbeat
# chkconfig heartbeat on

# /usr/share/heartbeat/ha_propagate



####LVS & Heartbeat
# yum -y --nogpgcheck localinstall libnet-1.1.4-3.el5.i386.rpm  
# yum -y --nogpgcheck localinstall perl-MailTools-1.77-1.el5.noarch.rpm 
# yum -y --nogpgcheck localinstall heartbeat-pils-2.1.4-10.el5.i386.rpm  
# yum -y --nogpgcheck localinstall heartbeat-stonith-2.1.4-10.el5.i386.rpm 
# yum -y --nogpgcheck localinstall heartbeat-gui-2.1.4-10.el5.i386.rpm
# yum -y --nogpgcheck localinstall heartbeat-ldirectord-2.1.4-10.el5.i386.rpm
# yum -y --nogpgcheck localinstall heartbeat-devel-2.1.4-10.el5.i386.rpm
# yum -y --nogpgcheck localinstall heartbeat-2.1.4-10.el5.i386.rpm

perl-Compress-Zlib
perl-HTML-Parser
perl-HTML-Tagset
perl-URI
perl-libwww-perl
perl-MailTools
perl-TimeDate
perl-String-CRC32
net-snmp-libs

# cp -v /usr/share/doc/heartbeat-2.1.4/{ha.cf,authkeys,haresources} /etc/ha.d/
# cp /usr/share/doc/heartbeat-ldirectord-2.1.4/ldirectord.cf /etc/ha.d/

Director:
eth0 , 192.168.0.209

ifconfig eth0:1 $VIP broadcast $VIP netmask 255.255.255.255
route add -host $VIP dev eth0:1

ipvsadm -A -t $VIP:80 -s wrr
ipvsadm -a -t $VIP:80 -r $RIP1 -w 5 -g
ipvsadm -a -t $VIP:80 -r $RIP2 -w 50 -g

RealServer

iptables -t nat -F
iptables -F

ipvsadm -C

ifdown lo
ifup lo

echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
 
ifconfig lo:0 $VIP broadcast $VIP netmask 255.255.255.255 up
route add -host $VIP dev lo:0

primary.mydomain.com 209.100.100.3/24/eth0/209.100.100.255 httpd

heartbeat (HA), keepalived, ultramokey, openais/corosync

RHCS:RedHat Cluster Suite, (openais/corosync), CRM

pacemaker

方法：
heartbeat v1
/etc/init.d/httpd
CIF

web

IP：192.168.0.186

primary:
	IP:192.168.0.181
	192.168.10.6
	
standby
	192.168.0.182
	192.168.10.7

web

/etc/ha.d/authkeys 该文件在两个版本作用是完全相同的，都必须设置，并且保证每个节点（node）内容一样；
/etc/ha.d/ha.cf 这个是主要配置文件，由其决定v1或v2 style格式
/etc/ha.d/haresources 这是v1的资源配置文件
/var/lib/heartbeat/crm/cib.xml 这是v2的资源配置文件，两者根据ha.cf的设定只能选其一

v2版本使用CRM管理工具，而cib.xml文件可有几种方式来编写：
	a）人工编写XML文件；
	b）使用admintools工具，其已经包含在heartbeat包中；
	c）使用GUI图形工具配置，也包含在heartbeat-gui包里面；
	d）使用python脚本转换1.x style的格式配置文件。

# more /etc/ha.d/ha.cf
#发送keepalive包的间隔时间
keepalive 2
#定义节点的失效时间
deadtime 30
#定义heartbeat服务启动后，等待外围其他设备（如网卡启动等）的等待时间
initdead 30
#使用udp端口694 进行心跳监测
udpport 694
#定义心跳
bcast   eth0 eth1               # Linux
#定义是否使用auto_failback功能
auto_failback off
#定义集群的节点
node    hatest3
node    hatest4
#使用heartbeat提供的日志服务，若use_logd设置为yes后，下面的三个选项会失效
use_logd yes
#logfile /var/log/ha_log/ha-log.log
#logfacility local7
#debugfile /var/log/ha_log/ha-debug.log
#设定一个监控网关，用于判断心跳是否正常
ping 192.168.0.254
deadping 5
#指定和heartbeat一起启动、关闭的进程
respawn hacluster /usr/local/lib64/heartbeat/ipfail
apiauth ipfail gid=haclient uid=hacluster

先停止heartbeat
service heartbeat stop

vim /etc/ha.d/ha.cf

添加/启用如下选项：
crm respawn
#下面是对传输的数据进行压缩，是可选项
compression     bz2
compression_threshold 2

转换v1.x为v2.x格式文件
heartbeat提供了一个使用python写的转换工具，可直接转换v1 style的配置文件为v2 style：
	# /usr/lib/heartbeat/haresources2cib.py /etc/ha.d/haresources
	
查看资源列表：
crm_resource -L

查看某资源在哪个节点上运行:
# crm_resource -W -r

查看节点运行状态信息：
# crm_mon -1

CRM:
	heartbeat v1, haresources
	crm
		crm
		pacemaker
	
heartbeat v2

1、停止heartbeat：
2、vim /etc/ha.d/ha.cf
	crm respawn
	
3、
# cd /usr/lib/heartbeat
# ./haresources2cib.py  /etc/ha.d/haresources  
	转换后的文件：/var/lib/heartbeat/crm/cib.xml
mv /etc/ha.d/haresources /root

# scp /var/lib/heartbeat/crm/cib.xml standby:/var/lib/heartbeat/crm

4、启动heartbeat

piranha, LVS

pacemaker, heartbeat

heartbeat2, heartbeat3

/usr/lib/ocf/resource.d/heartbeat/IPaddr meta-data

隔离
级别：
	节点级别
		STONITH: Shoot The Other Node In The Head
	资源级别
		fencing

active/active
active/passive

n/n-1
n/m
n/n

HA:

fencing
	节点
	资源
	
Message and Infrastructure Layer
Membership, CCM
Resource Allcation, CRM, LRM, CIB, PE, TE
Resource Layer, RA           

Linux: HA
	Heartbeat(v1, v2, v3) (heartbeat, pacemaker, cluster-glue)
	Keepalive
	Ultramonkey
	Corosync/openais + pacemaker
	RHCS( heartbeat )

Types of Resources

Primitives
A primitive resource, the most basic type of a resource.

Groups
Groups contain a set of resources that need to be located together, started sequentially and stopped in the reverse order.

Clones
Clones are resources that can be active on multiple hosts. Any resource can be cloned, provided the respective resource agent supports it.

Masters
Masters are a special type of clone resources, they can have multiple modes.






</pre>