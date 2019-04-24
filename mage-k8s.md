#K8S----容器编排
<pre>
#第一节：Devops核心要点及kubernetes架构
#k8s是什么？
中文意思是舵手，docker中文意思是码头工人，k8s是google由自己企业工具Brog演变而来。
openshift是k8s的发行版，因为k8s比较底层。
k8s的特性：
1. 自动装箱、自我修复、水平扩展、服务发现和负载均衡、自动发布和回滚
2. 密钥和配置管理、存储编排、批量处理执行
k8s是有中心节点的集群系统
1.API Server（接收并处理请求的）、2.Scheduler（调度容器创建的请求），3. 控制器（loop，监控容器的健康状态），控制器管理器（管理监控控制器的，可以做冗余，确保已建立的控制器为健康的状态）
在k8s中容器不叫容器了，叫pod,pod可以运行多个容器，共享网络和存储卷，一般pod只运行一个容器，pod是k8s中最小的原子单元
k8s由多个master和多个node组成集群，一般master为3个，可做冗余高可用。node是工作节点（worker）
无论是什么硬件，只要有cpu，内存，存储空间，网络等，而且可以装上k8s的集群代理程序，都可以成为node节点。
pod有标签，laber selector(标签选择器，用来选择pod标签的，其他很多资源都能用)
#总结：
master/node
master:API Server、scheduler,Controller-Manager
node:kubelet(k8s代理程序),docker(容器引擎)，kube-proxy

#第二节：kubernetes基础概念
#Pod：Laber,Laber Selector
1. Laber:key=value,标识pod
2. Laber Selector，通过laber来选择pod
#pod有两类：1.自主式pod，2.控制管理器pod（一般用这个）
控制器pod:
	ReplicationController
	ReplicaSet
	Deployment
	StatefulSet
	DaemonSet
	Job,Ctonjob
#k8s的基础设施部份：DNS（用于内部pod之间的解析）
#pod之间的通信：
1. 同一个pod内的多个容器间通信：通过lo接口通信
2. 各pod间的通信：Overlay Network(叠加网络)
3. pod与Service之间的通信：通过node的kube-proxy来生成node的iptables规则，这个规则将会指引pod与Service通信。kube-proxy是跟API-Server之间进行联系的，当创建跟移除Service时，API-Server会产生事件，这时kube-proxy就会配置iptables的相应规则。
#API-Server的事件及laber等信息存储在哪？
存储在etcd（k8s的数据库），跟API-Server一样，需要高可用冗余，一般为3个
#证书：
1. etcd之间需要一套CA证书
2. etcd与API-Server之间需要一套CA证书
3. API-Server与etcd之间需要一套CA证书
4. API-Server与node之间需要一套CA证书
5. API-Server与外部(局域网)访问之间需要一套CA证书
#k8s不提供网络组件，所以需要借助第三方插件提供网络,只要是支持CNI标准的网络组件都支持k8s的网络
1. flannel:提供网络配置，配置简单
2. calico：提供网络配置和网络策略，但配置很难
3. canel:前面第1和第2的结合，支持网络配置和网络策略（用flannel的网络配置和calico的网络策略）,这种配置简单功能强大 
4. .......

master:API Server、Scheduler、Controller-manager
node:kuberlet、docker、kube-proxy

#第三节：kubeadm初始化Kubernetes集群
#kubeadm：可以把k8s都运行为pod
#k8s架构：
master:API-Server、Controller-Manager、scheduler、etcd、flanner
nodes:kubelet、docker、kube-proxy、flanner
#架构流程：
1. master,nodes:先安装kubelet,kubeadmin,docker,kubectl（kubectl客户端管理工具仅master安装即可）
2. master:运行kubeadm init初始化为master，预检、解决先决条件、证书、私钥、生成配置文件、生成每一个静态pod的清单文件并完成部署，接下来部署addon
3. nodes:kubeadm join加入集群，预检、解决先决条件、基于bodstip、基于预共享的令牌认证方式、来完成认证到master节点并完成本地的pod自有安装包和以addon部署kube-proxy、部署dns
参考文档：https://github.com/kubernetes/kubeadm/blob/master/docs/design/design_v1.10.md

master:192.168.1.238
node1:192.168.1.31
node2:192.168.1.37
事前准备：设置dns或hosts解析，使k8s集群能互相解析，并且使用netdate同步服务器时间使集群时间同步，否则时间不同步可能导致诡异事情发生。而且要关闭iptables和firewalld防火墙、selinux，最好设置开机禁用，因为k8s后面会自动配置的
1. 配置docker和k8s的yum源：
[root@k8s-master ~]# wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo  #docker源
[root@k8s-master yum.repos.d]# cat kubernetes.repo  #配置阿里云的k8s源
---------------
[kubernetes]
name=Kubernetes Repo
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enable=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
gpgcheck=1
---------------
[root@k8s-master yum.repos.d]# yum repolist #查看配置的yum源是否有效
2. 安装docker和k8s相关组件：
[root@k8s-master yum.repos.d]# yum install docker-ce kubelet kubeadm kubectl #kubectl为API-Serverr的客户端，kubelet为node节点的代理程序，kubeadm为快速部署k8s配置工具
 docker-ce.x86_64 3:18.09.4-3.el7           kubeadm.x86_64 0:1.14.0-0          
  kubectl.x86_64 0:1.14.0-0                  kubelet.x86_64 0:1.14.0-0    #为安装的包
3. 编辑docker启动脚本并启动docker服务
[root@k8s-master systemd]# vim /usr/lib/systemd/system/docker.service #在最前面加两行
Environment="HTTPS_PROXY=http://www.ik8s.io:10080"  #设置https代理到http://www.ik8s.io:10080这里下载，因为如果不使用代理，docker仓库中有些包下载不下来，所以使用https代理
Environment="NO_PROXY=127.0.0.0/8,192.168.0.0/16"  #设置127.0.0.0/8,192.168.0.0/16网段地址不使用代理
[root@k8s-master systemd]# systemctl daemon-reload  #因为你的unit文件发生改变了，必须重新读取
[root@k8s-master systemd]# systemctl start docker #启动dokcer
[root@k8s-master systemd]# docker info #查看更改是否已经生效
HTTPS Proxy: http://www.ik8s.io:10080
No Proxy: 127.0.0.0/8,192.168.0.0/16
[root@k8s-master systemd]# cat /etc/sysctl.conf   #确保iptables是1开启的，这个跟docker的网络有关
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
[root@k8s-master systemd]# sysctl -p #永久生效
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
4. master:配置并启动kubelet
[root@k8s-master systemd]# rpm -ql kubelet
/etc/kubernetes/manifests
/etc/sysconfig/kubelet #配置文件
/usr/bin/kubelet  #执行命令
/usr/lib/systemd/system/kubelet.service  #启动脚本
[root@k8s-master systemd]# cat /etc/sysconfig/kubelet  #这个文件可以更改是否启用swap
KUBELET_EXTRA_ARGS=
[root@k8s-master systemd]# systemctl enable kubelet #设置开机自启动
[root@k8s-master systemd]# systemctl enable docker #设置开机自启动
[root@k8s-master systemd]# vim /etc/sysconfig/kubelet 
KUBELET_EXTRA_ARGS="--fail-swap-on=false" #设置swap为on时不重新启动
[root@k8s-master systemd]# kubeadm init --kubernetes-version=v1.14.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap #kubeadm初始化，并指定k8s版本，pod之间的网络，kube-proxy和service之间的网络，并忽略允许使用swap
由于当前使用http://www.ik8s.io:10080代理下载时显示不可用，所以我临时搭建了tinyproxy服务器。地址为：Environment="HTTPS_PROXY=http://66.42.64.231:10080"
---------------
tinyproxy搭建方法：
yum install -y epel-release
yum install tinyproxy
vim /etc/tinyproxy/tinyproxy.conf
Port 10080
#Allow 127.0.0.1
DisableViaHeader Yes  #只修了3个参数，其他为默认
systemctl start tinyproxy
systemctl enable tinyproxy
iptables -A INPUT -s 0.0.0.0 -p tcp --dport 10080 -j ACCEPT
---------------
[root@k8s-master systemd]# kubeadm init --kubernetes-version=v1.14.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap  #kubeadm 初始化
-----------------
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube         #这3个操作是需要操作的
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.238:6443 --token 0waj98.to1dyo9i8vn9omms \
    --discovery-token-ca-cert-hash sha256:e832244b85a4aca36b24173d4c8bf1fc29bacef7db956cdc7d95a9f4dca53048
----------------- 
[root@k8s-master ~]# docker image ls #初始化成功后会有镜像pull下来并启动了容器
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                v1.14.0             5cd54e388aba        11 days ago         82.1MB
k8s.gcr.io/kube-apiserver            v1.14.0             ecf910f40d6e        11 days ago         210MB
k8s.gcr.io/kube-controller-manager   v1.14.0             b95b1efa0436        11 days ago         158MB
k8s.gcr.io/kube-scheduler            v1.14.0             00638a24688b        11 days ago         81.6MB
k8s.gcr.io/coredns                   1.3.1               eb516548c180        2 months ago        40.3MB
k8s.gcr.io/etcd                      3.3.10              2c4adeb21b4f        4 months ago        258MB
k8s.gcr.io/pause                     3.1                 da86e6ba6ca1        15 months ago       742kB  #这个镜像是为pod提供底层基础架构的
[root@k8s-master ~]#  mkdir -p $HOME/.kube
[root@k8s-master ~]# cp -i /etc/kubernetes/admin.conf $HOME/.kube/config #作为kubectl的配置文件，指定连接k8s的API-Server并完成认证的，包含了认证信息
[root@k8s-master ~]# chown $(id -u):$(id -g) $HOME/.kube/config  #安装kubeadm初始化完成后的提示做出以上3步
[root@k8s-master ~]# kubectl get cs #cs为componentstatus,检查scheduler、controller-manager、etcd-0是否健康，API-Server没有在结果中，因为如果当API-Server不健康时kubectl请求则不会有回应，有回应说明API-Server是健康的
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
controller-manager   Healthy   ok                  
etcd-0               Healthy   {"health":"true"}  
[root@k8s-master ~]# kubectl get nodes  #查看node节点
NAME         STATUS     ROLES    AGE   VERSION
k8s-master   NotReady   master   51m   v1.14.0  #状态为NotReady ，因为没有网络组件
[root@k8s-master ~]# kubectl get ns #查看名称空间
NAME              STATUS   AGE
default           Active   56m
kube-node-lease   Active   56m
kube-public       Active   56m
kube-system       Active   56m  #系统级的pod都在这个名称空间中
#master:安装flanner网络组件
参考地址：https://github.com/coreos/flannel
对于Kubernetes v1.7 + kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml  #k8s版本为1.7+以上可以直接执行这个命令安装
[root@k8s-master ~]# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml #安装flanner
[root@k8s-master ~]# docker image ls
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy                v1.14.0             5cd54e388aba        11 days ago         82.1MB
k8s.gcr.io/kube-scheduler            v1.14.0             00638a24688b        11 days ago         81.6MB
k8s.gcr.io/kube-apiserver            v1.14.0             ecf910f40d6e        11 days ago         210MB
k8s.gcr.io/kube-controller-manager   v1.14.0             b95b1efa0436        11 days ago         158MB
quay.io/coreos/flannel               v0.11.0-amd64       ff281650a721        2 months ago        52.6MB  #会添加这个flannel镜像
k8s.gcr.io/coredns                   1.3.1               eb516548c180        2 months ago        40.3MB
k8s.gcr.io/etcd                      3.3.10              2c4adeb21b4f        4 months ago        258MB
k8s.gcr.io/pause                     3.1                 da86e6ba6ca1        15 months ago       742kB
[root@k8s-master ~]# kubectl get pod -n kube-system  #k8s集群系统的pod在kube-system名称空间当中
NAME                                 READY   STATUS    RESTARTS   AGE
coredns-fb8b8dccf-2zlk6              1/1     Running   0          60m
coredns-fb8b8dccf-brx94              1/1     Running   0          60m
etcd-k8s-master                      1/1     Running   0          59m
kube-apiserver-k8s-master            1/1     Running   0          59m
kube-controller-manager-k8s-master   1/1     Running   0          59m
kube-flannel-ds-amd64-x5s6p          1/1     Running   0          73s  #pull镜像后并运行flannel
kube-proxy-zf9ch                     1/1     Running   0          60m
kube-scheduler-k8s-master            1/1     Running   0          59m
[root@k8s-master ~]# kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   62m   v1.14.0  #此时master节点才为就绪状态
#node1：配置并启动docker，跟master一样
[root@slave-nginx ~]#  yum install docker-ce kubelet kubeadm -y #node节点安装docker-ce、kubelet、kubeadm
[root@k8s-master ~]# scp /usr/lib/systemd/system/docker.service node1:/usr/lib/systemd/system/docker.service  #复制master节点的docker配置文件，实际上是设置https_proxy代理
root@node1's password: 
docker.service                                100% 1786     1.7MB/s   00:00
[root@k8s-master ~]# scp /etc/sysconfig/kubelet node1:/etc/sysconfig/kubelet # 复制master节点的kubelet配置文件，实际上是允许swap可以在node上使用
root@node1's password: 
kubelet                                       100%   42    38.2KB/s   00:00 
[root@master-nginx yum.repos.d]# systemctl daemon-reload #重新加载unit
[root@master-nginx yum.repos.d]# systemctl start docker  #启动docker
[root@master-nginx yum.repos.d]# systemctl enable docker kubelet #设置docker和kubelet开机自启动
#node1加入k8s集群:
[root@master-nginx yum.repos.d]# kubeadm join 192.168.1.238:6443 --token 0waj98.to1dyo9i8vn9omms     --discovery-token-ca-cert-hash sha256:e832244b85a4aca36b24173d4c8bf1fc29bacef7db956cdc7d95a9f4dca53048 --ignore-preflight-errors=Swap #token一串信息是master成功初始化后生成的，复制上面的goken即可  --ignore-preflight-errors=Swap为后面自己添加的，意为忽略swap
[root@master-nginx yum.repos.d]# docker image ls  #下面的3个镜像为node自己下载并且后面要运行起来的
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
k8s.gcr.io/kube-proxy    v1.14.0             5cd54e388aba        11 days ago         82.1MB
quay.io/coreos/flannel   v0.11.0-amd64       ff281650a721        2 months ago        52.6MB
k8s.gcr.io/pause         3.1                 da86e6ba6ca1        15 months ago       742kB
[root@k8s-master ~]# kubectl get pods -n kube-system -o wide #可查看群集的所有pod
NAME                                 READY   STATUS    RESTARTS   AGE     IP              NODE         NOMINATED NODE   READINESS GATES
coredns-fb8b8dccf-2zlk6              1/1     Running   0          77m     10.244.0.2      k8s-master   <none>           <none>
coredns-fb8b8dccf-brx94              1/1     Running   0          77m     10.244.0.3      k8s-master   <none>           <none>
etcd-k8s-master                      1/1     Running   0          76m     192.168.1.238   k8s-master   <none>           <none>
kube-apiserver-k8s-master            1/1     Running   0          76m     192.168.1.238   k8s-master   <none>           <none>
kube-controller-manager-k8s-master   1/1     Running   0          76m     192.168.1.238   k8s-master   <none>           <none>
kube-flannel-ds-amd64-rfsd6          1/1     Running   0          4m32s   192.168.1.31    k8s.node1    <none>           <none> #node1运行的flannel
kube-flannel-ds-amd64-x5s6p          1/1     Running   0          18m     192.168.1.238   k8s-master   <none>           <none> #master运行的flannel
kube-proxy-jwxzw                     1/1     Running   0          4m32s   192.168.1.31    k8s.node1    <none>           <none>
kube-proxy-zf9ch                     1/1     Running   0          77m     192.168.1.238   k8s-master   <none>           <none>
kube-scheduler-k8s-master            1/1     Running   0          76m     192.168.1.238   k8s-master   <none>           <none>
[root@k8s-master ~]# kubectl get nodes
NAME         STATUS   ROLES    AGE     VERSION
k8s-master   Ready    master   79m     v1.14.0
k8s.node1    Ready    <none>   6m41s   v1.14.0 #node1不是master角色，说明可以运行为其他pod资源了
#node2：跟node1一样安装配置
[root@k8s-master ~]# kubectl get nodes #node2节点也已成功加入k8s集群
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   86m   v1.14.0
k8s.node1    Ready    <none>   13m   v1.14.0
k8s.node2    Ready    <none>   54s   v1.14.0

#第四节：kubernetes应用快速入门
kubectl是k8s集群中唯一一个管理工具，集合了增删改查等功能，是API-Server的客户端 
管理对象：pod,service,controller(replicaset,deployment,statefulet,daemonset,job,cronjob),node等
[root@k8s-master ~]# kubectl describe node k8s-master #查看节点的详细信息
[root@k8s-master ~]# kubectl version #查看k8s客户端和服务端的版本信息
Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.0", GitCommit:"641856db18352033a0d96dbc99153fa3b27298e5", GitTreeState:"clean", BuildDate:"2019-03-25T15:53:57Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.0", GitCommit:"641856db18352033a0d96dbc99153fa3b27298e5", GitTreeState:"clean", BuildDate:"2019-03-25T15:45:25Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}
[root@k8s-master ~]# kubectl cluster-info #查看集群信息
Kubernetes master is running at https://192.168.1.238:6443
KubeDNS is running at https://192.168.1.238:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
#怎样使用k8s的增删改查
#新建pod
[root@k8s-master ~]# kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=1 --dry-run=true #增加一个deployment类型控制器叫nginx-deploy，镜像为docker hub上的nginx:1.14-alpine，暴露端口为80，副本为1，--dry-run=true为处于干跑模式
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/nginx-deploy created (dry run)
#[root@k8s-master ~]# kubectl run nginx-deploy --image=nginx:1.14-alpine --port=80 --replicas=1 #非干跑模式
[root@k8s-master ~]# kubectl get pods #查看所有pod
NAME                           READY   STATUS              RESTARTS   AGE
nginx-deploy-55d8d67cf-8ww68   0/1     ContainerCreating   0          12s
[root@k8s-master ~]# kubectl get deployment #查看deployment控制器下的pod
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   0/1     1            0           17s #可用为0，因为新建后要做就绪性检查，就绪后才可用
[root@k8s-master ~]# kubectl get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE     IP           NODE        NOMINATED NODE   READINESS GATES
nginx-deploy-55d8d67cf-8ww68   1/1     Running   0          2m56s   10.244.1.2   k8s.node1   <none>           <none> #为可用了
[root@slave-nginx ~]# curl 10.244.1.2 #此时可以在node节点之中访问了，因为10.244.0.0/16为pod之间的网络。
注意：10.244.1.2/24为10.244.0.0/16的子网网络，由k8s默认分配的，node1网络为10.244.1.2/24网段，node2为10.244.2.2/24网段，依次类推
[root@k8s-master ~]# kubectl delete pods nginx-deploy-55d8d67cf-8ww68
pod "nginx-deploy-55d8d67cf-8ww68" deleted #删除一个pod，随后k8s会新建一个，因为pod被控制器管理，而我们当时新建这个上pod时，指定了副本为1个，所以控制器自己会rebuild一个pod
[root@k8s-master ~]# kubectl get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE        NOMINATED NODE   READINESS GATES
nginx-deploy-55d8d67cf-t4wbj   1/1     Running   0          71s   10.244.2.2   k8s.node2   <none>           <none>
#新建一个service
[root@k8s-master ~]# kubectl expose deployment nginx-deploy --name=nginx --port=80 --target-port=80 --protocol=TCP  #新建一个Service，暴露的目标是deployment类型的控制器，这个控制器叫nginx-deploy,为Service取名叫nginx,对外端口为80，对内服务端口为80，协议为TCP 
service/nginx exposed
[root@k8s-master ~]# kubectl get services #或者使用简写svc，查看接口,ip是动态生成的
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP   3h56m
nginx        ClusterIP   10.98.100.175   <none>        80/TCP    74m
[root@k8s-master ~]# kubectl get svc -n kube-system #查看kube-system 中的dns service，
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   4h3m  #dns地址为10.96.0.10
#新建一个pod客户端查看coreDNS
[root@k8s-master ~]# kubectl run client -it --image=busybox --replicas=1 --restart=Never #新建一个pod客户端，失败后从不重启
/ # cat /etc/resolv.conf 
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
/ # wget -O - -q http://nginx #结果是可以访问到的
[root@k8s-master ~]# kubectl describe svc nginx #查看nginx的service信息
Name:              nginx
Namespace:         default
Labels:            run=nginx-deploy
Annotations:       <none>
Selector:          run=nginx-deploy
Type:              ClusterIP
IP:                10.98.100.175
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         10.244.2.2:80
Session Affinity:  None
Events:            <none>
[root@k8s-master ~]# kubectl get pod --show-labels #查看pod时顺便把lable标签显示出来
NAME                           READY   STATUS    RESTARTS   AGE    LABELS
client                         1/1     Running   0          24m    run=client
nginx-deploy-55d8d67cf-t4wbj   1/1     Running   0          122m   pod-template-hash=55d8d67cf,run=nginx-deploy
注意：service的ip改变后会快速反映到coreDNS上的，所以coreDNS可以动态的关联ip解析
[root@k8s-master ~]# kubectl run test2 --image=nginx:1.14-alpine --port=80 --replicas=2 #新建2个副本，叫test2的控制器，属于deployment类型
[root@k8s-master ~]# kubectl get deployment#查看deployment 类型控制器，加参数-w可监控控制器的状态
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
myapp          2/2     2            2           9m56s
nginx-deploy   1/1     1            1           152m
test           0/2     2            0           4m38s
test2          2/2     2            2           32s 
[root@k8s-master ~]# kubectl expose deployment test2 --name test2  #在test2控制器中创建test2 service接口
#pod个数的动态变动
[root@k8s-master ~]# kubectl scale --replicas=5 deployment test2
deployment.extensions/test2 scaled #把控制器test2下的pod动态扩展为5个
[root@k8s-master ~]# kubectl scale --replicas=3 deployment test2 #动态缩容为3个
deployment.extensions/test2 scaled
[root@k8s-master ~]# kubectl get pod  #其余2个test2为Terminating（结束状态）
NAME                           READY   STATUS             RESTARTS   AGE
client                         1/1     Running            0          52m
myapp-5bc569c47d-g27qd         1/1     Running            0          14m
myapp-5bc569c47d-pvr5x         1/1     Running            0          14m
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            0          150m
test-9896c97fb-6l7pg           0/1     CrashLoopBackOff   7          14m
test-9896c97fb-msm79           0/1     CrashLoopBackOff   7          14m
test2-fbf68778f-br77v          1/1     Running            0          10m
test2-fbf68778f-p6hkd          0/1     Terminating        0          2m17s
test2-fbf68778f-qwbt7          1/1     Running            0          2m17s
test2-fbf68778f-twhsq          0/1     Terminating        0          2m17s
test2-fbf68778f-z4fkx          1/1     Running            0          10m
#滚动更新
[root@k8s-master ~]# kubectl set image deployment test2 test2=nginx:1.14-alpine #设置更新镜像，控制器类型为deployment,控制器叫test2,容器叫test2,镜像为nginx:1.14-alpine（容器名可使用kubectl describe pod test2-fbf68778f-z4fkx 命令查看指定的pod信息）
[root@k8s-master ~]# kubectl rollout status deployment test2 #查看指定控制器的回滚更新状态
deployment "test2" successfully rolled out
#回滚
[root@k8s-master ~]# kubectl rollout undo deployment test2 #指定控制器回滚到上一个版本
#如何使用集群外地址访问集群内服务
[root@k8s-master ~]# kubectl edit svc test2 #编辑最外面的service，使其类型为NodePort
  type: NodePort
[root@k8s-master ~]# kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        5h26m
nginx        ClusterIP   10.98.100.175   <none>        80/TCP         164m
test2        NodePort    10.97.168.243   <none>        80:32466/TCP   31m #对集群外访问端口为32466
#注意：只要是集群外访问集群内的任一节点都可以访问成功

#第五节：kubenetes资源清单定义入门
RESTful:
	web:GET,PUT,DELETE,POST,.....
	k8s:kubectl run,get,edit... #k8s以增删改查来使用GET,PUT等方法
资源：实例化后为对象
	workload:Pod,ReplicaSet,Deployment,StatefulSet,DaemonSet,Job,Cronjob,....
	服务发现及均衡：Service,Ingress,....
	配置与存储:Volume,CSI(容器存储接口，CNI：容器网络接口)
		configMap,Secret
		DownwardAPI
	集群级资源
		Namespace,Node,Role,ClusterRole,RoleBinding,ClusterRoleBinding
	元数据弄资源
		HPA,PodTemplate,LimitRange
	

创建资源的方法：
	apiserver仅接收JSON格式的资源定义
	yaml格式提供配置清单，apiserver可自动将yaml格式转化为JSON格式，然后提交;
大部分资源的配置清单：
	apiVersion: group/version | core  #api版本，可使用kubectl api-versions查看api版本
	kind：    #资源类别
	metadata:   #元数据
		name   #名称
		namespace   #名称空间
		labels     #标签
		annotations  #资源注解
		selfLink    #每个资源的引用PATH:/api/"GROUP/VERSION"/namespace/NAMESPACE/TYPE/NAME
	spec:		#期望的状态，disired state。最重要字段
	status: 当前状态，current state,本字段由kubenetes集群维护，用户不能更改
[root@k8s-master ~]# kubectl explain pods #查看pod对象可以使用哪些字段及配置方法
[root@k8s-master ~]# kubectl explain pods.spec #查看pod对象二级字段用法
kubectl管理有3种用法：
1. 命令式清单
[root@k8s-master ~]# kubectl run test2 --image=nginx:1.14-alpine --port=80 --replicas=2
2. 配置清单式
-----------------
[root@k8s-master manifests]# cat pod-demo.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: pod-demo
  namespace: default
  labels:
    app: myapp
    tier: frontend
spec:
  containers:
  - name: myapp
    image: nginx:1.14-alpine
  - name: busybox
    image: busybox:latest
    command:
    - "/bin/sh"
    - "-c"
    - "sleep 3600"
3. 也叫配置清单式，但不是用kubectl命令，后面会学习
----------------- 
[root@k8s-master manifests]# kubectl create -f pod-demo.yaml   #从声明清单新建pod
pod/pod-demo created
[root@k8s-master manifests]# kubectl get pods -w #监控pod-demo执行状态 
NAME                           READY   STATUS             RESTARTS   AGE
client                         1/1     Running            0          15h
myapp-5bc569c47d-g27qd         1/1     Running            0          14h
myapp-5bc569c47d-pvr5x         1/1     Running            0          14h
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            0          16h
pod-demo                       2/2     Running            0          11s
test-9896c97fb-6l7pg           0/1     CrashLoopBackOff   173        14h
test-9896c97fb-msm79           0/1     CrashLoopBackOff   173        14h
test2-fbf68778f-br77v          1/1     Running            0          14h
test2-fbf68778f-qwbt7          1/1     Running            0          14h
test2-fbf68778f-z4fkx          1/1     Running            0          14h
tt-896b9fc4c-sd47m             1/1     Running            0          13h
[root@k8s-master manifests]# kubectl describe pods pod-demo #使用此命令可查看pod的执行情况，配置信息，事件等
[root@k8s-master manifests]# kubectl exec -it pod-demo -c myapp -- /bin/sh #可进入容器，指定pod及容器名
[root@k8s-master manifests]# kubectl delete -f pod-demo.yaml  #可能过声明清单来删除，这样可以复用，方便操作
pod "pod-demo" deleted
[root@k8s-master manifests]# kubectl logs test2-fbf68778f-z4fkx -c container-name #查看容器的log

#第六节：Pod控制器应用进阶1
一般发布版本：alpha,beta,stable
注：docker:entrypoint,cmd相对于k8s的command,args
1. 当k8s没有传入command和args时，则使用docker的entrypoint和cmd。
2. 如果k8s只传入了command，则使用command和cmd组合使用
3. 如果k8s只传入了args,则使用entrypoint和args组合使用
4. 如果k8s都传入了command和args，则使用k8s的command和args组合使用。
标签：
	key=value #key和value最大63个字符（字母、数字、_、-）,key不能为空，value可以为空，都只能以字母数字开头及结尾
[root@k8s-master ~]# kubectl create -f manifests/pod-demo.yaml 
pod/pod-demo created
[root@k8s-master ~]# kubectl get pods -l app --show-labels #查看标签中键为app的pod并显示label信息
NAME       READY   STATUS    RESTARTS   AGE   LABELS
pod-demo   2/2     Running   0          5s    app=myapp,tier=frontend
[root@k8s-master ~]# kubectl get pods -L app,run --show-labels #显示app,run这两个字段的所有pod
NAME                           READY   STATUS             RESTARTS   AGE   APP     RUN            LABELS
client                         1/1     Running            0          19h           client         run=client
myapp-5bc569c47d-g27qd         1/1     Running            0          18h           myapp          pod-template-hash=5bc569c47d,run=myapp
myapp-5bc569c47d-pvr5x         1/1     Running            0          18h           myapp          pod-template-hash=5bc569c47d,run=myapp
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            0          21h           nginx-deploy   pod-template-hash=55d8d67cf,run=nginx-deploy
pod-demo                       2/2     Running            0          85s   myapp                  app=myapp,tier=frontend
test-9896c97fb-6l7pg           0/1     CrashLoopBackOff   222        18h           test           pod-template-hash=9896c97fb,run=test
test-9896c97fb-msm79           0/1     CrashLoopBackOff   222        18h           test           pod-template-hash=9896c97fb,run=test
test2-fbf68778f-br77v          1/1     Running            0          18h           test2          pod-template-hash=fbf68778f,run=test2
test2-fbf68778f-qwbt7          1/1     Running            0          18h           test2          pod-template-hash=fbf68778f,run=test2
test2-fbf68778f-z4fkx          1/1     Running            0          18h           test2          pod-template-hash=fbf68778f,run=test2
tt-896b9fc4c-sd47m             1/1     Running            0          18h           tt             pod-template-hash=896b9fc4c,run=tt
[root@k8s-master ~]# kubectl label pods pod-demo release=canary #打新标签
pod/pod-demo labeled
[root@k8s-master ~]# kubectl get pods -l app --show-labels
NAME       READY   STATUS    RESTARTS   AGE     LABELS
pod-demo   2/2     Running   0          5m37s   app=myapp,release=canary,tier=frontend
[root@k8s-master ~]# kubectl label pods pod-demo release=stable --overwrite #更改标签
pod/pod-demo labeled
[root@k8s-master ~]# kubectl get pods -l app --show-labels
NAME       READY   STATUS    RESTARTS   AGE    LABELS
pod-demo   2/2     Running   0          6m3s   app=myapp,release=stable,tier=frontend
#标签选择器：
	等值关系：=,==,!=,
	集合关系：KEY in (VALUE1,VALUE2...) | KEY notin (VALUE1,VALUE2...) | KEY | !KEY
[root@k8s-master ~]# kubectl get pods -l release --show-labels
NAME                    READY   STATUS    RESTARTS   AGE   LABELS
pod-demo                2/2     Running   0          11m   app=myapp,release=stable,tier=frontend
test2-fbf68778f-z4fkx   1/1     Running   0          19h   pod-template-hash=fbf68778f,release=canary,run=test2
[root@k8s-master ~]# kubectl get pods -l release=canary --show-labels #精确查找，多个标签时为and关系
NAME                    READY   STATUS    RESTARTS   AGE   LABELS
test2-fbf68778f-z4fkx   1/1     Running   0          19h   pod-template-hash=fbf68778f,release=canary,run=test2
[root@k8s-master ~]# kubectl get pods -l "release in (alpha,beta,canary)"
NAME                    READY   STATUS    RESTARTS   AGE
test2-fbf68778f-z4fkx   1/1     Running   0          19h
[root@k8s-master ~]# kubectl get pods -l "release notin (alpha,beta,canary)"
NAME                           READY   STATUS             RESTARTS   AGE
client                         1/1     Running            0          19h
myapp-5bc569c47d-g27qd         1/1     Running            0          19h
myapp-5bc569c47d-pvr5x         1/1     Running            0          19h
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            0          21h
pod-demo                       2/2     Running            0          21m
test-9896c97fb-6l7pg           0/1     CrashLoopBackOff   226        19h
test-9896c97fb-msm79           0/1     CrashLoopBackOff   225        19h
test2-fbf68778f-br77v          1/1     Running            0          19h
test2-fbf68778f-qwbt7          1/1     Running            0          19h
tt-896b9fc4c-sd47m             1/1     Running            0          18h
[root@k8s-master ~]# kubectl get pods -l "release"
NAME                    READY   STATUS    RESTARTS   AGE
pod-demo                2/2     Running   0          21m
test2-fbf68778f-z4fkx   1/1     Running   0          19h
#许多资源支持内嵌字段定义其使用的标签选择器：
	matchLabels: 直接给定键值
	matchExpressions: 基于给定的表达式来定义使用标签选择器，{key:"KEY",operator:"OPERATOR",values:[value1,value2,....]}
#操作符：In,NotIn,Exists,NotExists
dns最长字符不得超过253个字符，键值最长各不能超过63个字符
[root@k8s-master ~]# kubectl label nodes k8s.node1 disktype=ssd #为node节点打标签
node/k8s.node1 labeled
[root@k8s-master ~]# kubectl get nodes --show-labels
NAME         STATUS   ROLES    AGE   VERSION   LABELS
k8s-master   Ready    master   24h   v1.14.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s-master,kubernetes.io/os=linux,node-role.kubernetes.io/master=
k8s.node1    Ready    <none>   23h   v1.14.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,disktype=ssd,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s.node1,kubernetes.io/os=linux
k8s.node2    Ready    <none>   22h   v1.14.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s.node2,kubernetes.io/os=linux
[root@k8s-master ~]# kubectl explain pods.spec 
nodeSelector <map[string]string> #节点标签选择器
nodeName <string>  #直接选择在哪个节点运行
annotations: 与label不同的地方在于，它不能用于挑选资源对象，仅用于为对象提供“元数据”。注解长度不像label那样长度受限，可以任意抒写。
------------------
apiVersion: v1  #使用api接口的版本，一般优先使用稳定版
kind: Pod  #类型为pod
metadata:
  name: pod-demo  #pod名称
  namespace: default  #指定名称空间
  labels:
    app: myapp
    tier: frontend   #打标签，tier为层的意思，表示这个pod在前端，后端一般用backend表示，数据用data表示，测试用qa|test表示，开发用dev表示，生产环境用prod表示
spec:
  containers:
  - name: myapp
    image: nginx:1.14-alpine
    ports:
    - name: http  #设置端口名，
      containerPort: 80  #设置端口名对应的端口，此端口暴露与否与这里没有关系，与容器中是否开启监听端口为准
    - name: https
      containerPort: 443
  - name: busybox
    image: busybox:latest
    imagePullPolicy: IfNotPresent  #镜像pull策略，如果本地没有则去仓库下载，always为永远去仓库获取，never为从不去仓库获取只在本地获取。
    command:
    - "/bin/sh"
    - "-c"
    - "sleep 3600"
  nodeSelector:    #节点选择器，选择运行在标签是disktype=ssd的节点上运行
    disktype: ssd
~
-------------------
[root@k8s-master manifests]# cat pod-demo.yaml 
-------------
metadata:
  name: pod-demo
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:   #元数据注解，仅只有注释作用，无字符长度限制
    magedu.com/created-by: "cluster admin"
-------------
[root@k8s-master manifests]# kubectl describe pods pod-demo
Annotations:        magedu.com/created-by: cluster admin
#pod是有生命周期
pod生命周期状态：Pending(挂起),Running,Failed,Succeeded,Unknown,Ready
#客户端请求创建Pod的过程：客户端先发送请求到API-Server,API-Server把请求存储在etcd中并唤起scheduler去调度node，scheduler根据API-Server的任务清单找到合适的节点后把节点信息存储在etcd当中，这时API-Server通过etcd中scheduler调度的结果把任务发送给node的kubelet，kubelet收到任务后去创建pod并返回当前状态给API-Server，API-Server把pod的当前状态存储在etcd当中
#pod创建的过程：
	1. 先初始化容器
	2. 主容器的启动后可做勾子(hook)操作
	3. 主容器在运行时可做容器探测(存活性探测)操作（liveness probe,readiness probe）[有3种方式：1.执行命令2.向tcp端口发送请求3.向http发送get请求】
	4. 主容器在停止前可做勾子(hook)操作
pod生命周期中的重要行为：1.初始化容器 2.容器探测：liveness,readiness
restartPolicy        <string>  #容器重启策略
Always（永远重启）,OnFailure(失败时重启),Never（从不重启）, Default to Always
平滑终止信号：pod宽容期时间为30s，用户可以自定义，如果宽容期过了还未关机，就会发送kill 15信号

#第七节：Pod控制器应用进阶2
#探针：liveness（存活性检测）,readiness（就绪性检测）
#启动后勾子
探针有三种类型：1. ExecAction 2. TCPSocketAction 3. HTTPGetAction
[root@k8s-master manifests]# kubectl explain  pods.spec.containers #查看容器的探针说明 
----------------
[root@k8s-master manifests]# cat liveness-exec.yaml  #以执行命令来存活性检测
apiVersion: v1
kind: Pod
matedata:
  name: liveness-exec-pod
  namespace: default
spec:
  containers:
  - name: liveness-exec-container
    image: busybox:latest
    imagePullPolicy: IfNotPresent
    command: ["/bin/sh","-c","touch /tmp/healthy;sleep 60;rm -rf /tmp/healthy;sleep 3600"]
    livenessProbe:
      exec:
        command: ["test","-e","/tmp/healthy"]  #以执行命令来测试是否存活
      initialDelaySeconds: 1 #容器启动延迟1秒后开始检测
      periodSeconds: 3  #间隔3秒钟检测一次，3次为一个周期，如果不能访问则表示不存活
----------------
[root@k8s-master manifests]# cat liveness-httpget.yaml  #以httpget来存活性检测
apiVersion: v1
kind: Pod
metadata:
  name: liveness-httpget-pod
  namespace: default
spec:
  containers:
  - name: liveness-httpget-container
    image: nginx:1.14-alpine
    imagePullPolicy: IfNotPresent
    ports:
    - name: http
      containerPort: 80
    livenessProbe:
      httpGet:
        port: http  #http解析为80端口，上面有写到
        path: /index.html  #检测web主页
      initialDelaySeconds: 1 #容器启动延迟1秒后开始检测
      periodSeconds: 3  #隔3秒钟检测一次，3次为一个周期，如果不能访问则表示不存活
[root@k8s-master manifests]# cat readiness-httpget.yaml #以httpget来就绪性检测
apiVersion: v1
kind: Pod
metadata:
  name: readiness-httpget-pod
  namespace: default
spec:
  containers:
  - name: readiness-httpget-container
    image: nginx:1.14-alpine
    imagePullPolicy: IfNotPresent
    ports:
    - name: http  #设置别名http为80
      containerPort: 80
    readinessProbe:
      httpGet: 
        port: http  #http解析为80端口，上面有写到
        path: /index.html  #检测web主页
      initialDelaySeconds: 1 #容器启动延迟1秒后开始检测
      periodSeconds: 3  #隔3秒钟检测一次，3次为一个周期，如果不能访问则表示不存活
      
#启动后勾子
[root@k8s-master manifests]# kubectl explain pods.spec.containers.lifecycle.postStart  #在pod开始后执行事件帮助文档
[root@k8s-master manifests]# kubectl explain pods.spec.containers.lifecycle.preStop  #在pod结束前执行事件帮助文档
[root@k8s-master manifests]# cat poststart-pod.yaml  #
apiVersion: v1
kind: Pod
metadata:
  name: poststart-pod
  namespace: default
spec:
  containers:
  - name: poststart-container
    image: busybox:latest
    imagePullPolicy: IfNotPresent
    lifecycle:
      postStart:
        exec:
          command: ["/bin/sh","-c","echo hello >> /usr/index.html"] #这个命令为容器启动后执行的命令，比第一时间执行的命令慢
    command: ["/bin/sh","-c","/usr/sbin/nginx"]  #这个命令为容器启动第一时间执行的命令
    args: ["-f","-h","/usr"] #这个为第一时间执行的命令参数
注：这个声明清单没有执行成功，但逻辑命令都正确









</pre>