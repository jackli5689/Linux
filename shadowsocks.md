#shadowsocks
<pre>
=======
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
##########ssserver以配置文件方式运行
###不分密码端口不在乎流量
[root@lnmp ~]# cat /etc/shadowsocks.json
{
    "server": "0.0.0.0",
    "server_port": 1024,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "pass123",
    "timeout": 300,
    "method": "aes-256-cfb"
}
###分密码端口不在乎流量
[root@lnmp ~]# cat /etc/shadowsocks.json
{
    "server": "0.0.0.0",
    "port_password": {
        "8381": "foobar1",
        "8382": "foobar2",
        "8383": "foobar3",
        "8384": "foobar4"
    },
    "timeout": 300,
    "method": "aes-256-cfb"
}
###分密码端口在乎流量
git clone https://github.com/Flyzy2005/ss-bash.git #克隆脚本
git clone https://github.com/Flyzy2005/ss-bash.git #添加需要限制的用户
#自定义配置ss-bash/ssmlt.template #默认不用更改
"server": "0.0.0.0",
"timeout": 300,
"method": "aes-256-cfb",
#自定义配置ss-bash/sslib.sh：
INTERVEL=600  #检查间隔时间
SSSERVER=/usr/bin/ssserver #ssserver的执行文件路径 
ss-bash/ssadmin.sh start   #事先必须关闭ssserver服务，用这个服务直接启动
ss-bash/ssadmin.sh help
###分密码分端口，并且希望更精确的了解各个ss用户的流浪使用情况 ----这个未成功配置
#1.准备环境：
[root@lnmp ~]# yum update -y  
[root@lnmp ~]# yum install -y git screen wget 
[root@lnmp ~]# yum install -y npm nodejs #安装环境
#2.安装 shadowsocks-libev:
https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-libev.sh
[root@lnmp ~]# chmod +x shadowsocks-libev.sh
[root@lnmp ~]# ./shadowsocks-libev.sh 
Congratulations, Shadowsocks-libev server install completed!
Your Server IP        :  180.168.251.178 
Your Server Port      :  10000 
Your Password         :  test 
Your Encryption Method:  aes-256-cfb 
#3.安装shadowsocks-manager：
[root@lnmp ~]# git clone https://github.com/shadowsocks/shadowsocks-manager.git
[root@lnmp ~]# cd shadowsocks-manager/
[root@lnmp shadowsocks-manager]# npm install
[root@lnmp shadowsocks-manager]# npm build
[root@lnmp shadowsocks-manager]# npm i
[root@lnmp bin]# vim /etc/profile.d/shadowsocks-manager.sh
#!/bin/bash
export PATH=$PATH:/root/shadowsocks-manager/bin
[root@lnmp bin]# . /etc/profile.d/shadowsocks-manager.sh
#4.配置并运行：
#使用 screen 来实现守护进程
[root@lnmp shadowsocks-manager]# screen -S ss-manager
[root@lnmp bin]# ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4500
[root@lnmp bin]# netstat -tunlp
udp        0      0 127.0.0.1:4500          0.0.0.0:*                           27916/ss-manager  #确保启动
#在 ~/.ssmgr 下新建 default.yml：
[root@lnmp ~]# vim .ssmgr/default.yml
type: s
shadowsocks:
  address: 127.0.0.1:4500
manager:
  address: 0.0.0.0:7500
  password: '12345678'
db: 'ss.sqlite'




#注：限制用户某个端口的连接数，可用iptables规则：iptables -I INPUT 9 -d 192.168.1.19 -p tcp --dport 21 -m connlimit ! --connlimit-above 2 -j ACCEPT #限定ftp最大连接数为2，超过则不予连接
#参数注解：
Name	说明
server	服务器地址，填ip或域名
local_address	本地地址
local_port	本地端口，一般1080，可任意
server_port	服务器对外开的端口
password	密码，可以每个服务器端口设置不同密码
port_password	server_port + password ，服务器端口加密码的组合
timeout	超时重连
method	默认: “aes-256-cfb”，见 Encryption
fast_open	开启或关闭 TCP_FASTOPEN, 填true / false，需要服务端支持
####配置方式启动
[root@lnmp ~]# ssserver -c /etc/shadowsocks.json -d start  #后台运行启动
[root@lnmp ~]# ps aux | grep ssserver  #查看是否启动
root      7656  0.0  0.2 207204 10344 ?        Ss   13:38   0:00 /usr/bin/python /usr/bin/ssserver -c /etc/shadowsocks.json -d start
root      7666  0.0  0.0 112716  2236 pts/0    S+   13:38   0:00 grep --color=auto ssserve
[root@lnmp ~]# /usr/bin/ssserver -c /etc/shadowsocks/shadowsocks.json -d start #进行开机启动
=======
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
</pre>

#Linux for Shadowsocks客户端
<pre>
yum install epel-release -y
yum install python-pip
pip install shadowsocks
[root@salt-server /etc/shadowsocks]# cat /etc/shadowsocks/shadowsocks.json #连接服务器信息
{
  "server":"ip",
  "server_port":1080,
  "local_address":"127.0.0.1",
  "local_post":1080,
  "password":"password",
  "timeout":600,
  "method":"rc4-md5",
  "fast_open":false,
  "workers":1
}

[root@salt-server /etc/shadowsocks]# cat /etc/systemd/system/shadowsocks.service #设置服务启动
[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target

systemctl start shadowsocks.service #启动服务
systemctl status shadowsocks.service
systemctl stop shadowsocks.service
[root@salt-server /etc/shadowsocks]# curl --socks 127.0.0.1:1080 http://httpbin.org/ip #验证是否成功
{
  "origin": "66.42.64.231, 66.42.64.231"
}

#安装配置Privoxy
Shadowsocks是一个 socket5 服务，我们需要使用 Privoxy 把流量转到 http／https 上。
下载privoxy:wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/privoxy-3.0.26-1.el7.x86_64.rpm
安装privoxy：rpm -ivh privoxy-3.0.26-1.el7.x86_64.rpm
编辑：vim /etc/privoxy/config
listen-address  127.0.0.1:8118
forward-socks5t   /               127.0.0.1:1080 .
启动privoxy: systemctl start privoxy.service
编辑/etc/profile:  vim /etc/profile
export http_proxy="http://127.0.0.1:8118"
export https_proxy="https://127.0.0.1:8118"
使配置在当前环境生效： . /etc/profile

测试是否可用：curl www.google.com


#Centos利用Shadowsocks搭建privoxy代理服务器
yum install python-pip
pip install shadowsocks #安装shadowsocks客户端
[root@salt-server ~]# cat /etc/shadowsocks/shadowsocks.json 
{
  "server": "185.243.57.221",
  "server_port": 80,
  "local_address": "127.0.0.1",
  "local_post": 1080,
  "password": "t.me/SSRSUB",
  "timeout": 600,
  "method": "rc4-md5",
  "fast_open": false,
  "workers":1
}
nohup sslocal -c /etc/shadowsocks/shadowsocks.json &>/dev/null & #启动代理在后台
[root@salt-server ~]# netstat -tunlp | grep 1080
tcp        0      0 127.0.0.1:1080          0.0.0.0:*               LISTEN      22868/python2       
udp        0      0 127.0.0.1:1080          0.0.0.0:*                           22868/python2       
[root@salt-server ~]# yum install -y privoxy
[root@salt-server ~]# vim /etc/privoxy/config 
listen-address  0.0.0.0:8118
         forward-socks5t   /               127.0.0.1:1080 .
systemctl start privoxy #启动代理服务
[root@salt-server ~]# netstat -tunlp | grep 8118
tcp        0      0 0.0.0.0:8118            0.0.0.0:*               LISTEN      23294/privoxy      
#到这一步就可以使用wget https://www.google.com访问了
#开机启动
[root@salt-server ~]# cat /etc/rc.local 
nohup sslocal -c /etc/shadowsocks/shadowsocks.json &>/dev/null & #添加此行即可
[root@k8s ~]# cat /etc/profile.d/privoxy.sh  #此脚本可使命令行下的linux能代理上网
------------
#!/bin/bash
#
export https_proxy="http://192.168.1.235:8118/"
export http_proxy="http://192.168.1.235:8118/"
------------


</pre>