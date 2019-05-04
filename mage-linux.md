#Linux基础
<pre>
man命令：
1.用户命令
2.系统调用
3.库用户
4.特殊文件（设备文件）
5.文本格式（配置文件的语法）
6.游戏
7.杂项
8.管理员命令
<>:必选
[]:可选
|:多选一
...:可以出现多次
{}:分组
NAME:命令名称及功能简要说明
SYNOPSIS：用法说明，包括可用的选项
DESCRIPTION:命令功能的详尽说明，可能包括每一个选项的意义
FILES:此命令相关的配置文件 
BUGS:报告BUG给谁的
EXAMPLES:示例
SEE ALSO:另外参照

文件目录：
/boot:系统启动的文件，如内核、initrd,以及grub(bootloader)
/dev:设备文件
设备文件：
	块设备：随机访问，数据块
	字符设备：线性访问，按字符为单位
/etc:配置文件
/home:用户家目录
/sys:伪文件系统，跟硬件设备相关的属性映射文件
/proc:伪文件系统，内核映射文件 
/opt:可选目录，第三方程序的安装目录
/lib:库文件
	静态库 .a
	动态库 .dll .so(share object)
	/lib/modules:内核映射文件
/tmp:临时文件目录，一个月内自动清理，每个人只能清理自己的文件
/var:可变化的文件，/var/tmp/
/bin:可执行文件，用户命令
/sbin:可执行文件，管理命令
/usr:全局共享只读文件
	/usr/bin
	/usr/sbin
	/usr/lib
/usr/local: #第三方软件的安装目录
	/usr/local/bin
	/usr/local/sbin
	/usr/local/lib
/media:挂载目录，移动设备
/mnt:挂载目录

命名规则：
1、长度不能超过255个字符
2、不能使用/当文件名
相对路径、绝对路径

文件管理
ls
cd
pwd
mkdir
mkdir ./{a/x,b}_{c,d} -pv
touch
rm
stat
[root@smb-server tmp]# touch -m -t 12100915 a
[root@smb-server tmp]# stat a
  File: "a"
  Size: 4096            Blocks: 8          IO Block: 4096   目录
Device: 812h/2066d      Inode: 7340039     Links: 6
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-04-23 16:05:24.442942913 +0800
Modify: 2019-12-10 09:15:00.000000000 +0800
Change: 2019-04-23 16:09:27.983343327 +0800
cp -a
mv
目录管理

运行程序
设备管理
软件管理
进程管理
网络管理

命令行快捷键：
ctrl+a ctrl+e ctrl+u ctrl+k ctrl+l
history命令：
!!
!-4
!789
!cd
!$ | ESC . #打开前一个命令的最后一个参数

#包管理器：rpm
软件包管理器的核心功能：
1、制件软件包
2、安装、卸载、升级、查询、校验
打包成一个软件包：二进制程序、库文件、配置文件、帮助文件
Redhat、SUSE:RPM
Debian:dpt
后端工具：RPM,dpt
前端工具：yum,apt-get

rpm命令：
	rpm：管理rpm包的
	rpmbuild:构建rpm包的
rpm数据库：/var/lib/rpm  #一般是hash格式的数据库，因为查找快得多
rpm提供的功能：安装、查询、卸载、升级、校验、数据库的重建、验证数据包等工作
rpm命名：
包：组成部分
	主包：
		bind-version
		bind-9.7.1-1.el5.i586.rpm
	子包:
		bind-libs-9.7.1-1.el5.i586.rpm
		bind-utils-9.7.1-1.el5.i586.rpm
	包名：
		name-version-release.arch.rpm
		bind-major.minor.release-release.arch.rpm  #major.minor.release-release主版本，次版本，修证号，发行号
rpm包：
	源码包：需要编译
	二进制包：直接使用
1、rpm安装：
rpm -ivh *.rpm #安装rpm包
--nodeps:忽略依赖关系
--force:强行安装,可以实现重装或降级 --replacepags:重新安装，替换原有安装 --oldpackage：降级软件包
--test:测试安装rpm包，检查依赖关系
2、rpm查询：
rpm -qa | grep softwarename    查看需要查找的软件是否安装
rpm -qi softwarename    查看软件的信息
rpm -qd softwarename    查看软件的手册信息
rpm -qf  /bin/ls   查看执行文件软件于个软件包
rpm -ql  softwarename  列出软件包里面的文件
rpm -qc  softwarename  列出软件包里面的配置文件 
rpm -q --scripts softwarename 列出软件包的脚本
rpm -qpl softwarename 查询尚未安装的软件包如果安装后生成的说明信息及文件，l可为i，c，d
3、rpm包升级
rpm -Uvh softwarename 如果有老版本则升级，如果没老版本则安装 --oldpackage包降级
rpm -Fvh softwarename 如果有教务处槽 升级，如果没有老版本则退出
4、rpm卸载包
rpm -e softwarename   删除包 --nodeps
5、rpm包校验：
 rpm -V axel-2.4-1.el6.rf.x86_64 检验软件是否被非法更改的，具体属性解释请查看man rpm
6、重建数据库
rpm --rebuilddb:重建数据库，一定会重新建立
rpm --initdb:初始化数据库，有就不会覆盖，没有则初始化

7、检验来源合法性及软件完整性：
三种加密和解密算法：
对称：DES,3DES,AES 加密解密使用同一个密钥
公钥：一对密钥，公钥和私钥
单向：sha1,md5,hash算法
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6 #导入centos的对称密钥
rpm -K axel-2.4-1.el6.rf.x86_64 #使用导入centos的对称密钥解密验证从centos官方下载的包的完整校验和来源合法性检验是否具有合法性，dsa,gpg验证来源合法性，sha1,md5完整校验,可以使用--nodigest来略过完整性检验，使用--nosignature略过来源合法性校验
[root@smb-server src]# ls /var/lib/rpm/  #rpm的数据库
Basenames     __db.002  Dirnames     Installtid    Packages        Pubkeys         Sha1header
Conflictname  __db.003  Filedigests  Name          Providename     Requirename     Sigmd5
__db.001      __db.004  Group        Obsoletename  Provideversion  Requireversion  Triggername

#包管理器：yum
createrepo:创建元数据文件
HTML:HyperText Mark Language
XML:eXtended Mark Language
XML,JSON:半结构化的数据
yum仓库中的元数据文件：
primary.xml.gz
	所有RPM包的列表
	依赖关系
	每个RPM安装生成的文件列表
filelists.xml.gz
	当前仓库中所有RPM包的所有文件列表
other.xml.gz
	额外信息：RPM的修改日志
repomd.xml
	记录的是上面三个文件的时间戳和校验和
comps*.xml：RPM包分组信息
	
yum:
yum localinstall package #本地安装rpm包，可解决依赖关系，比rpm -ivh强
reinstall 重新安装 
downgrade 降级
repolist 列出所有可用仓库
list all | avaliable #列出包
--nogpgcheck #不做gpgcheck检查
update #升级最新版本
update-to #升级为指定版本
remove | erase #卸载
info #查看包信息，类似qi
provides #查看文件是由哪个包提供的，类似qf

如何为yum定义repo文件：
[Repo_Id] #repo名称，唯一标识符
name=jack repo  #描述信息
baseurl=file:///mnt/repodate  #repo的包路径,支持ftp://,http://,本地路径file:///
enable={1|0} #1表示启用，0表示禁用
gpgcheck={1|0} #验证gpg的来源合法性和完整性，1为开启，0为禁用
gpgkey=file:///mnt/RPM-GPG-KEY-CentOS-7 #校验yum的包的密钥路径，支持ftp://,http://,本地路径file:///


#RPM和YUM区别
rpm:
	二进制格式：
	源程序--编译--二进制格式
		有些特性是编译选定的，如果未选定此特性，将无法使用
		rpm包的版本会落后于源码包，甚至落后很多
所以需要定制安装：手动编译安装
编译环境，开发环境
开发库，开发工具，
C,C++,perl,java,python
gcc:GNU C Compile，C编译器
g++: C++编译器
make:C或C++的项目管理工具
makefile:定义了make(c,c++)按何种次序去编译源文件中的源程序
automake-->makefile.in-->makefile
autoconf-->configure
手动编译时使用configure指定参数来结合makefile.in来生成makefile,然后用make来根据makefile编译源代码，最后使用make install来安装源程序 
./configure 
	--prefix=/usr/local/  #例如指定软件安装目录
	--sysconfdir=/etc/  #例如指定配置文件目录
./configure --help #获取编译帮助
编译前提：安装开发环境
yum grouplist "Development and Creative Workstation" #安装开发环境
./configure --prefix=/usr/local/nginx
make 
make install 
1.修改环境变量，使nginx在环境变量当中
2.默认情况下，源码安装的软件库文件是不被其他程序调用的，其他程序调用的库路径是/lib,/usr/lib. 需要在/etc/ld.so.conf.d/中创建.conf为后缀名的文件，而后要把源码的库文件路径添加到.conf文件中
	需要即时生效需要执行ldconfig -v命令
3.头文件：输出给系统
	默认：头文件默认在/usr/include中
	增添头文件搜寻路径，使用链接进行：
		ln -s /usr/local/tengine/include/* /usr/include 或
		ln -s /usr/local/tengine/incllude /usr/include/tengine
4.man文件路径：安装--prefix目录下的/usr/local/tengine/man
	1 man -M /usr/local/nginx/man httpd  #临时生效
	2 在/etc/man.config中添加一条MANPATH #永久生效

#进程管理：
停止状态、就绪状态、执行中、不可中断睡眠、可中断睡眠、僵尸进程
进程有状态、有父子关系、有优先级关系
0-139，总共有140个优先级
其中0-99是内核控制的，100-139是由用户控制的
大O标准：O(1),O(n),O(logn),O(n^2),O(2^n)
O(1):无论队列多长，所花时间是一样的，XY轴平行线，也就是y等于1，
O(n)：随着队列的增长时间也随着增长，XY轴线性增长,也就是y会变化
优先级越低获得CPU的运行时间越长，并且更优先获得运行的机会
用nice值来调：-20到19，对应100-139,每一个进程nice值是0
普通用户只能调大nice值，root可以调大和调小nice值
ps命令：
	SysV风格：加-
	BSD网格：不加-

euid是有效运行的用户，uid是谁发起的用户
pgrep -t pts/0
pidof 
top
	 load average: 0.00, 0.01, 0.05 #1、5、15分钟的平均负载
	 0.0 us（用户空间使用率）,  0.0 sy（系统使用率）,  0.0 ni（nice值）,100.0 id(cpu空闲比率),  0.0 wa（io等待）,  0.0 hi（硬中断）,  0.0 si（软中断）,  0.0 st（偷走的CPU）
	 PID USER      PR（优先级，rt实时优先级）  NI（nice值）    VIRT（虚拟内存级）    RES（常驻内存级）    SHR（共享内存大小） S（状态）  %CPU %MEM     TIME+ （运行时长，真正占用cpu时长）COMMAND
交互命令：T表示cpu占用时长，M表示内存比率排序，P表示CPU比率排序

##grub
修复stage1：
1. grub  #进入命令行
2. root (hd0,0) #指定内核所在的分区，hd0为BIOS第一块硬盘，0为第一个分区，/dev/sda1 /boot
3. setup hd0  #安装stage1并指定硬盘
重新安装grup:
mkdir /mnt/boot && mount /dev/hda1 /mnt/boot
1. grub-install --root-derictory=/mnt /dev/hda  #指定修复的硬盘boot所在的父目录，例如一块硬盘/dev/hda挂载的是/mnt，则boot的父目录是/mnt,并且指定要安装的硬盘
2. sync 同步数据到硬盘
3. vim /mnt/boot/grub/gurb.conf  #创建gurb配置文件

如何修复grub.conf配置文件故障：
1. 当grub.conf故障，你重启系统的时候只会启动第1阶段，不会启动第2阶段，所以会给你grub命令行
2. find (hd0,0)/ #使用find目录查找内核所在的分区，只能一个个去找，find (hd1,0)/,然后按tab键，直至找到内核
3.  root (hd0,0) #指定内核目录
4.  kernel /vmlinuz  #指定kernel,按tab键补全
5.  initrd /initrd  ##指定initrd,按tab键补全,版本要跟内核版本一致
6.  boot  #启动系统

##kerner的初始化过程：
1. 设备探测
2. 加载驱动初始化（可能会从initrd文件中装载驱动模块）
3. 以只读方式挂载根文件系统
4. 装载第一个进程init
/etc/inittabz:
initdefault:设定默认运行级别
sysinit:系统初始化
wait:等待级别切换到此级别时运行
respawn:一旦程序终止，会重新启动
/etc/rc.d/rc.sysinit完成的任务：
1. 激活udev和selinux
2. 根据/etc/sysctl.conf文件，来设定内核参数。
3. 设定系统时钟。
4. 装载键盘映射。
5. 启用交换分区。
6. 设置主机名
7. 根文件系统检测，并以读写方式重新挂载。
8. 激活软RAID和LVM设备。
9. 启用磁盘配额。
10. 根据/etc/fstab检查并挂载其它文件系统。
11. 清理过期的锁和PID文件。





</pre>