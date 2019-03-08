#shadowsocks
#安装shadowsocks:
#CentOS:
yum install python-setuptools && easy_install pip
pip install shadowsocks
#Debian / Ubuntu:
apt-get install python-pip
pip install shadowsocks
使用:
ssserver -p 443 -k password -m rc4-md5
后台运行：
sudo ssserver -p 443 -k password -m rc4-md5 --user nobody -d start
停止：
sudo ssserver -d stop
检查日志：
sudo less /var/log/shadowsocks.log

#配置BBR加速：
TCP BBR是谷歌出品的TCP拥塞控制算法。BBR目的是要尽量跑满带宽，并且尽量不要有排队的情况。BBR可以起到单边加速TCP连接的效果。
BBR解决了两个问题：
在有一定丢包率的网络链路上充分利用带宽。非常适合高延迟，高带宽的网络链路。
降低网络链路上的buffer占用率，从而降低延迟。非常适合慢速接入网络的用户。
Google 在 2016年9月份开源了他们的优化网络拥堵算法BBR，最新版本的 Linux内核(4.9-rc8)中已经集成了该算法。

升级内核，第一步首先是升级内核到支持BBR的版本：
yum update
安装elrepo并升级内核：
[root@myshadowsocks ~]# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@myshadowsocks ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
[root@myshadowsocks ~]# yum --enablerepo=elrepo-kernel install kernel-ml -y
更新grub文件并重启系统：
[root@myshadowsocks ~]# egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
CentOS Linux 7 Rescue 5da862e233914df79eb3f48c2fd5f90a (5.0.0-2.el7.elrepo.x86_64)
CentOS Linux (5.0.0-2.el7.elrepo.x86_64) 7 (Core)
CentOS Linux (3.10.0-957.1.3.el7.x86_64) 7 (Core)
CentOS Linux (3.10.0-957.el7.x86_64) 7 (Core)
CentOS Linux (0-rescue-84d6e1c3c43d427ab345edad898ac223) 7 (Core)
[root@myshadowsocks ~]# grub2-set-default 0
[root@myshadowsocks ~]# reboot
[root@myshadowsocks ~]# uname -r
5.0.0-2.el7.elrepo.x86_64
开启bbr：
[root@myshadowsocks ~]# vim /etc/sysctl.conf    # 在文件末尾添加如下内容
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
加载系统参数：
[root@myshadowsocks ~]# sysctl -p
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.eth0.accept_ra = 2
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
如上，输出了我们添加的那两行配置代表正常。
确定bbr已经成功开启：
[root@myshadowsocks ~]# sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = reno cubic bbr
[root@myshadowsocks ~]# lsmod | grep bbr
tcp_bbr                20480  30
输出内容如上，则表示bbr已经成功开启。

