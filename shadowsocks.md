#shadowsocks
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