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
	Job,Cronjob
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
3. nodes:kubeadm join加入集群，预检、解决先决条件、基于bodstip、基于预共享的令牌认证方式、来完成认证到master节点并完成本地的pod自有安装和以addon部署kube-proxy、部署dns
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
[root@master-nginx yum.repos.d]# kubeadm join 192.168.1.238:6443 --token 0waj98.to1dyo9i8vn9omms     --discovery-token-ca-cert-hash sha256:e832244b85a4aca36b24173d4c8bf1fc29bacef7db956cdc7d95a9f4dca53048 --ignore-preflight-errors=Swap #token一串信息是master成功初始化后生成的，复制上面的token即可  --ignore-preflight-errors=Swap为后面自己添加的，意为忽略swap
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
##将type: ClusterIP改为type: NodePort即可使集群内service变成对外的service
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
	元数据资源
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
###注：docker的entrypoint,cmd相对于k8s的command,args
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
探针有三种类型：1. ExecAction(执行动作) 2. TCPSocketAction(测试指定端口) 3. HTTPGetAction(测试http服务)
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
      periodSeconds: 3  #间隔3秒钟检测一次，failureThreshold默认值为3次一个周期，如果不能访问则表示不存活
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
        path: /index.html  #检测web主页，路径从web网站的根目录开始
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
      
#启动后勾子，启动后做动作或结束前做动作，启动后为postStart,结束前为preStop
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


#第八节：Pod控制器
#回顾：
配置式清单：apiVersion,kind,metadata,spec(只读，系统自动生成的)
spec:
	containers:
	nodeSelector:
	nodeName:
	restartPolicy:
		Always,Never,OnFailure

containers:
	name
	image
	imagePullPolicy: Always,Never,IfNotPresent
	ports:
		name
		containerPort
	livenessProbe
	readinessProbe
	lifecycle
livenessProbe和readinessProbe三种内嵌相关应用：
ExecAction: exec
TCPSocketAction: tcpSocket
HTTPGetAction: httpGet
lifecycle两种内嵌相关应用：
postStart
preStop

###pod控制器
自主式pod：不是由控制器管理的pod,不可能rebuild
控制器pod：是被控制器管理的pod，可以rebuild
#####pod控制器类型：
	1. ReplicationController
	2. ReplicaSet:代用户创建指定数量的pod副本，并确定副本一直满足用户的期望数量状态，多退少补，并且支持扩缩容机制，被称为新一代的ReplicationController，主要核心三点：1.用户期望的副本数。2.标签选择器，以便选定由自己管理和控制的pod副本。3.pod资源模板来完成pod资源的新建
	3. Deployment:Deployment工作在ReplicaSet上的，是通过控制ReplicaSet来控制pod的。支持ReplicaSet的所有功能，并支持滚动更新回滚等更多强大的功能。，无状态最重要的控制器
	4. DaemonSet:用于确保集群中的节点只运行一个特定的pod副本，实现所谓的系统级的后台任务。新节点加入集群自动加一个特定的pod副本到新的节点。可能是全部节点运行一个特定的副本pod,也可能在部分节点运行一个特定的副本pod。无状态
	5. Job:可以启动多个pod，job是执行一次性的作业，是否重构取决于是否完成任务。
	6. Cronjob:周期性运行，不需要持续后台运行，只能运行无状态应用
	7. Statefulset:有状态应用，
	8. Operator:比Statefulset好得多
Helm:类似linux的yum工具，在k8s里面的工具，

###编写ReplicaSet的yaml
[root@k8s-master manifests]# cat rs-demo.yaml 
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp2
  namespace: default
spec: 
  replicas: 2
  selector:
    matchLabels:
      app: myapp2
      release: canary
  template:
    metadata:
      name: myap2-pod  #pod的名称其实没用，k8s会随机生成一个pod名
      labels:
        app: myapp2
        release: canary
    spec:
      containers:
      - name: myapp2-container
        image: ikubernetes/myapp:v1
        ports: 
        - name: http
          containerPort: 80
如何自动扩缩容
	1.可以编辑yaml文件来实现，kubectl edit replicaset myapp2来修改副本数量
	2.也可能使用scale来实现,kubectl scale --replicas=1 ReplicaSet myapp2
如何自动升级容器软件版本：
	使用kubectl edit replicaset myapp2来修改容器镜像版本，然后手动删除pod，才会重新建立新pod的版本为新版本。
	建议：蓝绿发布，重新建立一个ReplicSet的yaml为myapp3,此时有myapp2和myapp3了，我们使myapp3符合service接口的laber,这样可以对外开放，但myapp3的laber不能满足myapp2的匹配规则。所以myapp2和myapp3的label不能完全一样，但对于service来说有共同一样的label。再删除老的myapp2，完全用新的myapp3版本
	or 直接改service的label，使service匹配myapp3，不匹配myapp2。来升级新版本。
灰度、蓝绿，金丝雀(canary)

#第九节：Pod控制器2
strategy：更新策略
	type:Recreate、RollingUpdate
    如果type为RollingUpdate则可以指定滚动更新策略rollingUpdate{maxSurge(最多超出你指定的副本数有几个，可以指定数量或百分比),maxUnavailable(最大几个不可用)}
revisionHistoryLimit:在滚动更新最多在历史当中保存多少个，默认是10个
rollbackTo:指定更新到什么版本
paused:启动暂停。一般启动不暂停
###编写Deployment的yaml
[root@k8s-master manifests]# cat deploy-demo.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deploy
  namespace: default
spec:
  replicas: 2
  selector: 
    matchLabels: 
      app: myapp
      release: canary
  template: 
    metadata:
      labels: 
        app: myapp
        release: canary
    spec:
      containers:
      - name: myapp
        image: ikubernetes/myapp:v1
        ports: 
        - name: http
          containerPort: 80
[root@k8s-master manifests]# kubectl get deployment #查看deployment的pod
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
myapp          2/2     2            2           19d
myapp-deploy   2/2     2            2           97s
nginx-deploy   1/1     1            1           19d
qq             1/1     1            1           25h
test           0/2     2            0           19d
test2          1/1     1            1           19d
tt             1/1     1            1           19d
[root@k8s-master manifests]# kubectl get rs #查看replicaSet的pod
NAME                     DESIRED   CURRENT   READY   AGE
myapp-5bc569c47d         2         2         2       19d
myapp-deploy-67b6dfcd8   2         2         2       113s #myapp-deploy-67b6dfcd8前面一段是deployment的名称，后面是模板的哈希值
nginx-deploy-55d8d67cf   1         1         1       19d
qq-5c969f76f9            1         1         1       25h
test-9896c97fb           2         2         0       19d
test2-fbf68778f          1         1         1       19d
tt-896b9fc4c             1         1         1       19d
[root@k8s-master manifests]# kubectl get pods
NAME                           READY   STATUS             RESTARTS   AGE
client                         0/1     Completed          0          24h
myapp-5bc569c47d-8jbqp         1/1     Running            1          18d
myapp-5bc569c47d-hqjbr         1/1     Running            1          18d
myapp-deploy-67b6dfcd8-r4dbb   1/1     Running            0          4m #myapp-deploy-67b6dfcd8是replicaSet的名称，r4dbb是随机生成的名称
myapp-deploy-67b6dfcd8-tltlg   1/1     Running            0          4m
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            1          19d
qq-5c969f76f9-dfxnq            1/1     Running            0          25h
test-9896c97fb-2bbjs           0/1     CrashLoopBackOff   289        24h
test-9896c97fb-brgc2           0/1     CrashLoopBackOff   4990       18d
test2-fbf68778f-z4fkx          1/1     Running            1          19d
tt-896b9fc4c-gq678             1/1     Running            0          70m

[root@k8s-master manifests]# vim deploy-demo.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deploy
  namespace: default
spec:
  replicas: 3 #更改副本为3个
  selector:
    matchLabels:
      app: myapp
      release: canary
  template:
    metadata:
      labels:
        app: myapp
        release: canary
    spec:
      containers:
      - name: myapp
        image: ikubernetes/myapp:v1
        ports:
        - name: http
          containerPort: 80
[root@k8s-master manifests]# kubectl apply -f deploy-demo.yaml   #apply命令可以执行多次，而create只能执行一次
deployment.apps/myapp-deploy configured  
[root@k8s-master manifests]# kubectl get pods
NAME                           READY   STATUS             RESTARTS   AGE
client                         0/1     Completed          0          24h
myapp-5bc569c47d-8jbqp         1/1     Running            1          18d
myapp-5bc569c47d-hqjbr         1/1     Running            1          18d
myapp-deploy-67b6dfcd8-r4dbb   1/1     Running            0          7m
myapp-deploy-67b6dfcd8-tltlg   1/1     Running            0          7m
myapp-deploy-67b6dfcd8-xtsdk   1/1     Running            0          10s #新添加了一个pod副本
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            1          19d
qq-5c969f76f9-dfxnq            1/1     Running            0          25h
test-9896c97fb-2bbjs           0/1     CrashLoopBackOff   289        24h
test-9896c97fb-brgc2           0/1     Completed          4991       18d
test2-fbf68778f-z4fkx          1/1     Running            1          19d
tt-896b9fc4c-gq678             1/1     Running            0          73m
##滚动更新：
[root@k8s-master manifests]# vim deploy-demo.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deploy
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      release: canary
  template:
    metadata:
      labels:
        app: myapp
        release: canary
    spec:
      containers:
      - name: myapp
        image: ikubernetes/myapp:v2 #把版本设置为v2
        ports:
        - name: http
          containerPort: 80
~

[root@k8s-master manifests]# kubectl apply -f deploy-demo.yaml  #更新配置清单
deployment.apps/myapp-deploy configured
[root@k8s-master manifests]# kubectl get rs -o wide
NAME                      DESIRED   CURRENT   READY   AGE    CONTAINERS     IMAGES                 SELECTOR
myapp-5bc569c47d          2         2         2       19d    myapp          ikubernetes/myapp:v1   pod-template-hash=5bc569c47d,run=myapp
myapp-deploy-675558bfc5   3         3         3       3m5s   myapp          ikubernetes/myapp:v2   app=myapp,pod-template-hash=675558bfc5,release=canary #这个是滚动更新后的版本
myapp-deploy-67b6dfcd8    0         0         0       16m    myapp          ikubernetes/myapp:v1   app=myapp,pod-template-hash=67b6dfcd8,release=canary #这个保留的老版本
nginx-deploy-55d8d67cf    1         1         1       19d    nginx-deploy   nginx:1.14-alpine      pod-template-hash=55d8d67cf,run=nginx-deploy
qq-5c969f76f9             1         1         1       25h    qq             nginx:1.14-alpine      pod-template-hash=5c969f76f9,run=qq
test-9896c97fb            2         2         0       19d    test           busybox                pod-template-hash=9896c97fb,run=test
test2-fbf68778f           1         1         1       19d    test2          nginx:1.14-alpine      pod-template-hash=fbf68778f,run=test2
tt-896b9fc4c              1         1         1       19d    tt             nginx:1.14-alpine      pod-template-hash=896b9fc4c,run=tt
[root@k8s-master manifests]# kubectl rollout history deployment myapp-deploy #查看pod控制器的滚动更新历史
deployment.extensions/myapp-deploy 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
 kubectl rollout undo deployment myapp-deploy #回滚操作至上一个版本
###[root@k8s-master manifests]# kubectl patch deployment myapp-deploy -p '{"spec":{"replicas":5}}' #以打补丁的方式更新pod控制器
deployment.extensions/myapp-deploy patched
更改maxSurge和maxUnavailable
[root@k8s-master manifests]# kubectl patch deployment myapp-deploy -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}' #打补丁设置myapp-deploy的pod最多可以有1个多的，最少不能少1个
deployment.extensions/myapp-deploy patched 
[root@k8s-master manifests]# kubectl describe deployment myapp-deploy
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  0 max unavailable, 1 max surge
[root@k8s-master manifests]# kubectl get pods -l app -w #先监控
NAME                            READY   STATUS    RESTARTS   AGE
myapp-deploy-675558bfc5-4pr5r   1/1     Running   0          22m
myapp-deploy-675558bfc5-6gjcl   1/1     Running   0          22m
myapp-deploy-675558bfc5-btkj8   1/1     Running   0          32m
myapp-deploy-675558bfc5-cqckp   1/1     Running   0          32m
myapp-deploy-675558bfc5-nzb9g   1/1     Running   0          32m
[root@k8s-master manifests]# kubectl set image deployment myapp-deploy myapp=ikubernetes/myapp:v3 &&  kubectl rollout pause deployment myapp-deploy #版本更新并设置新添加的一个pod开启后不关闭老的pod 
deployment.extensions/myapp-deploy image updated
deployment.extensions/myapp-deploy paused
[root@k8s-master manifests]# kubectl rollout status deployment myapp-deploy #这个命令可查看更新状态
Waiting for deployment "myapp-deploy" rollout to finish: 1 out of 3 new replicas have been updated... 
[root@k8s-master manifests]# kubectl rollout resume deployment myapp-deploy #恢复运行
deployment.extensions/myapp-deploy resumed
[root@k8s-master manifests]# kubectl rollout status deployment myapp-deploy
deployment "myapp-deploy" successfully rolled out #此时已经成功更新完成 
[root@k8s-master manifests]# kubectl get pods -l app -o wide 
NAME                            READY   STATUS    RESTARTS   AGE     IP            NODE        NOMINATED NODE   READINESS GATES
myapp-deploy-5d64b5ffd9-bh4vc   1/1     Running   0          3m18s   10.244.2.36   k8s.node2   <none>           <none>
myapp-deploy-5d64b5ffd9-f4xh5   1/1     Running   0          8m9s    10.244.1.48   k8s.node1   <none>           <none>
myapp-deploy-5d64b5ffd9-vndp7   1/1     Running   0          3m11s   10.244.1.49   k8s.node1   <none>           <none>
[root@k8s-master manifests]# curl 10.244.1.48
Hello MyApp | Version: v4 | <a href="hostname.html">Pod Name</a> #已经更新到v4版本
[root@k8s-master manifests]# kubectl rollout history deployment myapp-deploy
deployment.extensions/myapp-deploy 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>
4         <none>
root@k8s-master manifests]# kubectl rollout undo deployment myapp-deploy --to-revision 1 #回滚到版本1
deployment.extensions/myapp-deploy rolled back
[root@k8s-master manifests]# kubectl rollout history deployment myapp-deploy
deployment.extensions/myapp-deploy  #版本1变成5发，前面一个为4
REVISION  CHANGE-CAUSE
2         <none>
3         <none>
4         <none>
5         <none>

###编写DaemonSet的yaml
DaemonSet每个节点只有一个pod，不允许多个pod。DaemonSet默认是不部署在master上的，因为它不容忍master的污点，只有手动指定才可以运行在污点中
[root@k8s-master manifests]# cat daemon.yaml 
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: myapp-daemon
  namespace: default
spec:
  selector: 
    matchLabels: 
      app: filebeat
      release: stable
  template: 
    metadata:
      labels: 
        app: filebeat
        release: stable
    spec:
      containers:
      - name: filebeat
        image: ikubernetes/filebeat:5.6.5-alpine
        env:
        - name: REDIS_HOST
          value: redis.default.svc.cluster.local
        - name: REDIS_LOG_LEVEL
          value: info
[root@k8s-master manifests]# kubectl apply -f daemon.yaml 
daemonset.apps/myapp-daemon created
[root@k8s-master manifests]# kubectl get pods
NAME                           READY   STATUS             RESTARTS   AGE
client                         0/1     Completed          0          42h
myapp-5bc569c47d-8jbqp         1/1     Running            1          18d
myapp-5bc569c47d-hqjbr         1/1     Running            1          18d
myapp-daemon-l78l5             1/1     Running            0          22s #新添加的两个
myapp-daemon-lg8hr             1/1     Running            0          22s
myapp-deploy-67b6dfcd8-f6p4q   1/1     Running            0          16h
myapp-deploy-67b6dfcd8-qpp25   1/1     Running            0          16h
myapp-deploy-67b6dfcd8-wrdp7   1/1     Running            0          16h
nginx-deploy-55d8d67cf-t4wbj   1/1     Running            1          20d
qq-5c969f76f9-dfxnq            1/1     Running            0          42h
test-9896c97fb-2bbjs           0/1     CrashLoopBackOff   494        42h
test-9896c97fb-brgc2           0/1     CrashLoopBackOff   5194       18d
test2-fbf68778f-z4fkx          1/1     Running            1          20d
tt-896b9fc4c-gq678             1/1     Running            0          18h

[root@k8s-master manifests]# kubectl delete -f daemon.yaml 
[root@k8s-master manifests]# cat daemon.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
      role: logstor
  template:
    metadata:
      labels:
        app: redis
        role: logstor
    spec:
      containers:
      - name: redis
        image: redis:4.0-alpine
        ports:
        - name: redis
          containerPort: 6379
---     #两个pod控制器类型可以写在同一个文件上，用---分开 
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: filebeat-ds
  namespace: default
spec:
  selector: 
    matchLabels: 
      app: filebeat
      release: stable
  template: 
    metadata:
      labels: 
        app: filebeat
        release: stable
    spec:
      containers:
      - name: filebeat
        image: ikubernetes/filebeat:5.6.5-alpine
        env:
        - name: REDIS_HOST
          value: redis.default.svc.cluster.local #指定redis主机的地址为redes接口
        - name: REDIS_LOG_LEVEL
          value: info

[root@k8s-master manifests]# kubectl apply -f daemon.yaml 
[root@k8s-master ~]# kubectl get pods -l app=filebeat -o wide
NAME                READY   STATUS    RESTARTS   AGE   IP            NODE        NOMINATED NODE   READINESS GATES
filebeat-ds-j7fgc   1/1     Running   0          12m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-s9dhc   1/1     Running   0          12m   10.244.1.54   k8s.node1   <none>           <none>
[root@k8s-master manifests]# kubectl expose deployment redis --port=6379
service/redis exposed   #暴露svervice接口
[root@k8s-master manifests]# kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        20d
nginx        ClusterIP   10.98.100.175   <none>        80/TCP         20d
qq           NodePort    10.106.125.38   <none>        80:30684/TCP   43h
redis        ClusterIP   10.106.1.89     <none>        6379/TCP       26s
注：DaemonSet也支持滚动更新。[root@k8s-master manifests]# kubectl explain ds.spec.updateStrategy
[root@k8s-master manifests]# kubectl set image daemonset filebeat-ds filebeat=ikubernetes/filebeat:5.6.6-alpine  #滚动更新
[root@k8s-master manifests]# kubectl get pods -l app=filebeat -o wide -w
NAME                READY   STATUS    RESTARTS   AGE   IP            NODE        NOMINATED NODE   READINESS GATES
filebeat-ds-j7fgc   1/1     Running   1          57m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-s9dhc   1/1     Running   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-s9dhc   1/1     Terminating   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-s9dhc   0/1     Terminating   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-s9dhc   0/1     Terminating   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-s9dhc   0/1     Terminating   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-s9dhc   0/1     Terminating   0          57m   10.244.1.54   k8s.node1   <none>           <none>
filebeat-ds-6v8wl   0/1     Pending       0          0s    <none>        <none>      <none>           <none>
filebeat-ds-6v8wl   0/1     Pending       0          0s    <none>        k8s.node1   <none>           <none>
filebeat-ds-6v8wl   0/1     ContainerCreating   0          0s    <none>        k8s.node1   <none>           <none>
filebeat-ds-6v8wl   1/1     Running             0          15s   10.244.1.55   k8s.node1   <none>           <none>
filebeat-ds-j7fgc   1/1     Terminating         1          58m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-j7fgc   0/1     Terminating         1          58m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-j7fgc   0/1     Terminating         1          58m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-j7fgc   0/1     Terminating         1          58m   10.244.2.39   k8s.node2   <none>           <none>
filebeat-ds-mcxkz   0/1     Pending             0          0s    <none>        <none>      <none>           <none>
filebeat-ds-mcxkz   0/1     Pending             0          1s    <none>        k8s.node2   <none>           <none>
filebeat-ds-mcxkz   0/1     ContainerCreating   0          1s    <none>        k8s.node2   <none>           <none>
filebeat-ds-mcxkz   1/1     Running             0          15s   10.244.2.40   k8s.node2   <none>           <none>
注：因为DaemonSet的滚动更新策略maxUnavailable默认值是1，没
有maxSurge，因为每个节点只允许运行1个pod
## Job,Cronjob这两个控制器自己去操作。Statefulset现在的知识无法应用到，后面会有范例


#第十节:Services资源
service需要CoreDNS,或者kubeDNS
service3种网络：Pod Network,Node Network,Cluster Network(Service Network)
Pod Network和Node Network的ip是实在的ip，而Cluster Network是虚拟的ip，叫Virtual IP
service网络的三种代理模式：
	1. user space（k8s1.1版本及以前用，1.1-）
	2. iptables(k8s1.10版本及以前用，1.10-)
	3. ipvs(k8s1.11版本，1.11+)
注：用户创建service时会把信息传递给apiServer存储在etcd数据库当中，此时节点的kube-proxy Watch到apiServer接收到的service信息，kube-proxy会生成iptables规则或ipvs规则，这个操作是同步完成的，会非常快。
ipvs没有激活默认会降级到iptables
类型：ExternalName, ClusterIP, NodePort, LoadBalancer
[root@k8s-master manifests]# kubectl explain svc.spec #查看svc的帮助 

[root@k8s-master manifests]# kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   20d #这个service是面向集群内部的，让pod与apiserver联系的apserver ip地址
##创建ClusterIP类型的service
[root@k8s-master manifests]# cat redis-svc.yaml 
apiVersion: v1
kind: Service
metadata:
  name: redis
  namespace: default
spec:
  selector:
    app: redis
    role: logstor
  clusterIP: 10.97.97.97  #实际操作中不要固定写，应不写这行
  type: ClusterIP
  ports:
  - port: 6379
    targetPort: 6379
[root@k8s-master manifests]# kubectl apply -f redis-svc.yaml 
service/redis created
[root@k8s-master manifests]# kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP    20d
redis        ClusterIP   10.97.97.97   <none>        6379/TCP   3s
资源记录：
	SVC_NAME.NS_NAME.DOMAIN.LTD.
	svc.cluster.local.
	redis.default.svc.cluster.local.  #yaml创建的service就是这个域名解析名

##创建NodePort类型的service
[root@k8s-master manifests]# cat myapp-svc.yaml 
apiVersion: v1
kind: Service
metadata:
  name: myapp
  namespace: default
spec:
  selector:
    app: myapp
    release: canary
  clusterIP: 10.99.99.99 #ip建议自动获取
  type: NodePort
  ports:
  - port: 80
    targetPort: 80 
    nodePort: 30080 #端口也可以自动获取得到，但是建议手动固定设置
[root@k8s-master manifests]# kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP        20d
myapp        NodePort    10.99.99.99   <none>        80:30080/TCP   3s  #NodePort
redis        ClusterIP   10.97.97.97   <none>        6379/TCP       9m37s #ClusterIP
###LoadBalancer接口类型：
k8s支持lbaas的云计算环境，可以使用LoadBalancer service类型。类似在阿里云中有4个节点，使用LoadBalancer接口类型暴露了3个端口后，会调用lbaas的云计算API生成一个软件的负载均衡器。
###ExternalName接口类型：
当k8s集群中的pod想访问k8s集群外的服务时，去的流程是这样的：pod-->ClusterIP:servicePort-->nodeIP:nodePort-->out_target_IP:port,回来的流程是这样的：out_target-->nodeIP:nodePort-->ClusterIP:servicePort-->podIP:containerPort
##例如访问外部的域名时，这个外部的域名首先在集群中的kubeDNS或者CoreDNS上有CNAME记录指向自己，而集群内访问时使用的是内部DNS设定的新的CNAME名称，从而达到访问外部的服务。
[root@k8s-master manifests]# kubectl explain svc.spec.sessionAffinity #sessionAffinity可支持会话绑定，绑定一个用户访问时获取到的第一个pod，可以支持打补丁的方式进行绑定也可以支持edit yaml文件的方式。
[root@k8s-master manifests]# kubectl patch svc myapp -p '{"spec":{"sessionAffinity":"ClientIP"}}' #这个为绑定会话联系sessionAffinity
service/myapp patched
[root@k8s-master manifests]# while true; do curl http://192.168.1.31:30080/hostname.html; sleep 1 ;done
myapp-deploy-7f577979c8-m58mz
myapp-deploy-7f577979c8-m58mz
myapp-deploy-7f577979c8-b9ktd
myapp-deploy-7f577979c8-m58mz
myapp-deploy-7f577979c8-g6nq9  #开始绑定了
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
myapp-deploy-7f577979c8-g6nq9
[root@k8s-master manifests]# kubectl patch svc myapp -p '{"spec":{"sessionAffinity":"None"}}' #这个为不绑定会话联系sessionAffinity

#headless接口类型，无头serice,就是没有service ip的service,service名称直接指向podIp 
[root@k8s-master manifests]# vim headless.yaml 
apiVersion: v1
kind: Service
metadata:
  name: headless
  namespace: default
spec:
  selector:
    app: myapp
    release: canary
  clusterIP: None
  ports:
  - port: 80
    targetPort: 80
"headless.yaml" 15L, 196C written                                                     
[root@k8s-master manifests]# kubectl apply -f headless.yaml 
service/headless created
[root@k8s-master manifests]# kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
headless     ClusterIP   None          <none>        80/TCP     6s #无头ip的service
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP    20d
redis        ClusterIP   10.97.97.97   <none>        6379/TCP   59m
[root@k8s-master manifests]# dig -t A headless.default.svc.cluster.local. @10.96.0.10

; <<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<>> -t A headless.default.svc.cluster.local. @10.96.0.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12803
;; flags: qr aa rd; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;headless.default.svc.cluster.local. IN A

;; ANSWER SECTION:
headless.default.svc.cluster.local. 5 IN A      10.244.2.41  #无头service直接指向3个pod的ip
headless.default.svc.cluster.local. 5 IN A      10.244.1.56
headless.default.svc.cluster.local. 5 IN A      10.244.2.42
[root@k8s-master manifests]# kubectl get pod -l release=canary -o wide
NAME                            READY   STATUS    RESTARTS   AGE   IP            NODE        NOMINATED NODE   READINESS GATES
myapp-deploy-7f577979c8-b9ktd   1/1     Running   0          47m   10.244.2.42     k8s.node2   <none>           <none>  #IP正好对应pod的ip
myapp-deploy-7f577979c8-g6nq9   1/1     Running   0          47m   10.244.1.56   k8s.node1   <none>           <none>
myapp-deploy-7f577979c8-m58mz   1/1     Running   0          47m   10.244.2.41   k8s.node2   <none>           <none>
[root@k8s-master manifests]# dig -t A redis.default.svc.cluster.local. @10.96.0.10

; <<>> DiG 9.9.4-RedHat-9.9.4-61.el7 <<>> -t A redis.default.svc.cluster.local. @10.96.0.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59325
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;redis.default.svc.cluster.local. IN    A

;; ANSWER SECTION:
redis.default.svc.cluster.local. 5 IN   A       10.97.97.97 #这个是有头的service，所以指向serviceIP

;; Query time: 0 msec
;; SERVER: 10.96.0.10#53(10.96.0.10)
;; WHEN: Sat Apr 27 13:17:29 CST 2019
;; MSG SIZE  rcvd: 107
[root@k8s-master manifests]# kubectl get svc -n kube-system  #可以查看k8s集群的dns
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   20d

#第十一节：ingress及Ingress Controller
#如何启用ipvs：
1. 需要在/etc/sysconfig/kubelet的配置文件上添加一行KUBE_PROXY_MODE=ipvs
2. 写脚本使node主机启动时自动装载ipvs模块。ip_vs,ip_vs_rr,ip_vs_wrr,ip_vs_sh,nf_conntrack_ipv4几个模块
3. 初始化安装kublet就可以安装ipvs了。只能在刚开始装的时候开启。

##k8s组成：
master组件:APIServer,Scheduler,Controll Manager 【ReplicaSet,Deployment,DaemonSet】
node组件:kubelet,docker,kube-proxy
四个核心附件：DNS,Dashboard(K8S集群的全部功能都要基于Web的UI，来管理集群中的应用和集群自身。),Heapster(容器和节点的性能监控与分析系统，它收集并解析多种指标数据，如资源利用率、生命周期时间，在最新的版本当中，其主要功能逐渐由Prometheus结合其他的组件进行代替。),Ingress Controller
##Ingress Controll自己独立运行的一个或一组pod资源，拥有七层代理能力和调度能力的应用程序，在做微服务的有三种：Nginx,Traefik,Envoy

##流程：用户访问最外层的四层负载均衡LVS的VIP,然后LVS代理到集群部分节点的DaemonSet类型的pod，被代理的pod实现污点，使DaemonSet能容忍污点从而部署DaemonSet类型的pod,且每个pod共享节点的网络空间，这个共享节点网络空间的pod是Ingress Controller，是七层负载均衡器(有Nginx,Traefik,Envoy,Haproxy[最不受待见])，Ingress Controller指向后端的http pod，他们之间是明文传输的，而对集群外提供的Ingress Controller七层负载均衡器是https协议的，可以卸载用户ssl会话和重载pod的ssl会话，从而实现大量http网站的https部署。因为后端的pod随时会变化，所以要建一个service，这个service会从APIServer上实时收集变动的信息来重新分类pod,而ingress会watch收集service的pod信息，并且会注入到ingress-nginx的配置文件当中,从而实现配置文件的动态扩展。

注：怎么定义Ingress,有两种方法：1.基于虚拟主机名访问。2.基于url路径访问。
##操作：
#参考链接：https://github.com/kubernetes/ingress-nginx
#参考链接https://kubernetes.github.io/ingress-nginx/deploy/
命令创建名称空间：kubectl create namespace dev  #kubectl delete ns/dev
#部署ingress Controller
1. [root@k8s-master ingress-nginx]# for i in configmap.yaml namespace.yaml rbac.yaml with-rbac.yaml  ;do wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/$i;done
----------------
[root@k8s-master ingress-nginx]# cat namespace.yaml #先创建名称空间
apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
----------------
[root@k8s-master ingress-nginx]# cat configmap.yaml #为ingress-nginx注入配置的
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-configuration
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx

---
kind: ConfigMap
apiVersion: v1
metadata:
  name: tcp-services
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx

---
kind: ConfigMap
apiVersion: v1
metadata:
  name: udp-services
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
----------------
[root@k8s-master ingress-nginx]# cat rbac.yaml #定义clster role，让Ingress Controll拥有它本来到达不了的名称空间权限，角色绑定，kubeadm默认rbac是启用的
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: nginx-ingress-clusterrole
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
rules:
  - apiGroups:
      - ""
    resources:
      - configmaps
      - endpoints
      - nodes
      - pods
      - secrets
    verbs:
      - list
      - watch
  - apiGroups:
      - ""
    resources:
      - nodes
    verbs:
      - get
  - apiGroups:
      - ""
    resources:
      - services
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - "extensions"
    resources:
      - ingresses
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - ""
    resources:
      - events
    verbs:
      - create
      - patch
  - apiGroups:
      - "extensions"
    resources:
      - ingresses/status
    verbs:
      - update

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: nginx-ingress-role
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
rules:
  - apiGroups:
      - ""
    resources:
      - configmaps
      - pods
      - secrets
      - namespaces
    verbs:
      - get
  - apiGroups:
      - ""
    resources:
      - configmaps
    resourceNames:
      # Defaults to "<election-id>-<ingress-class>"
      # Here: "<ingress-controller-leader>-<nginx>"
      # This has to be adapted if you change either parameter
      # when launching the nginx-ingress-controller.
      - "ingress-controller-leader-nginx"
    verbs:
      - get
      - update
  - apiGroups:
      - ""
    resources:
      - configmaps
    verbs:
      - create
  - apiGroups:
      - ""
    resources:
      - endpoints
    verbs:
      - get

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: nginx-ingress-role-nisa-binding
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: nginx-ingress-role
subjects:
  - kind: ServiceAccount
    name: nginx-ingress-serviceaccount
    namespace: ingress-nginx

---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: nginx-ingress-clusterrole-nisa-binding
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: nginx-ingress-clusterrole
subjects:
  - kind: ServiceAccount
    name: nginx-ingress-serviceaccount
    namespace: ingress-nginx

----------------
[root@k8s-master ingress-nginx]# cat with-rbac.yaml  #部署ingress controller并且带上rbac部署
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/part-of: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/part-of: ingress-nginx
      annotations:
        prometheus.io/port: "10254"
        prometheus.io/scrape: "true"
    spec:
      serviceAccountName: nginx-ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.24.1
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
            - --tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
            - --udp-services-configmap=$(POD_NAMESPACE)/udp-services
            - --publish-service=$(POD_NAMESPACE)/ingress-nginx
            - --annotations-prefix=nginx.ingress.kubernetes.io
          securityContext:
            allowPrivilegeEscalation: true
            capabilities:
              drop:
                - ALL
              add:
                - NET_BIND_SERVICE
            # www-data -> 33
            runAsUser: 33
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
          livenessProbe:
            failureThreshold: 3
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 10
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 10
----------------
2. 创建tcp-services-configmap.yaml和udp-services-configmap.yaml，configmap.yaml这个文件中有，所有可以不用写这两个文件了
----------------
[root@k8s-master ingress-nginx]# cat tcp-services-configmap.yaml 
apiVersion: v1
kind: ConfigMap
metadata:
  name: tcp-services
  namespace: ingress-nginx
[root@k8s-master ingress-nginx]# cat udp-services-configmap.yaml 
apiVersion: v1
kind: ConfigMap
metadata:
  name: udp-services
  namespace: ingress-nginx
----------------
3. [root@k8s-master ingress-nginx]# kubectl apply -f namespace.yaml  #先创建名称空间，后面操作是基于这个操作的
namespace/ingress-nginx created
[root@k8s-master ingress-nginx]# kubectl get ns 
NAME              STATUS   AGE
default           Active   21d
ingress-nginx     Active   9s
kube-node-lease   Active   21d
kube-public       Active   21d
kube-system       Active   21d
4. [root@k8s-master ingress-nginx]# ls
configmap.yaml  rbac.yaml                    udp-services-configmap.yaml
namespace.yaml  tcp-services-configmap.yaml  with-rbac.yaml
[root@k8s-master ingress-nginx]# kubectl apply -f ./ #创建当前目录下的所有yaml文件
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
namespace/ingress-nginx unchanged
serviceaccount/nginx-ingress-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-role created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
configmap/tcp-services configured
configmap/udp-services configured
deployment.apps/nginx-ingress-controller created
##注：通用部署：如果想简单部署，可以下载部署这个yaml文件即可【https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml】，这个yaml文件包括了上面几个文件

#创建ingress:
#为了ingress能显现真正的效果来，我们先做前提准备，部署后端应用：
5. [root@k8s-master ingress-nginx]# cat deployment.yaml #创建nginx后端pod
apiVersion: v1
kind: Service
metadata:
  name: myapp 
  namespace: default 
spec:
  selector:
    app: myapp
    release: canary
  ports:
  - name: http
    targetPort: 80
    port: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deploy
  namespace: default
spec:
  replicas: 3
  selector: 
    matchLabels: 
      app: myapp
      release: canary
  template: 
    metadata:
      labels: 
        app: myapp
        release: canary
    spec:
      containers:
      - name: myapp
        image: ikubernetes/myapp:v2
        ports: 
        - name: http
          containerPort: 80
[root@k8s-master ingress-nginx]# kubectl get pods -l app
NAME                            READY   STATUS    RESTARTS   AGE
myapp-deploy-675558bfc5-9ms5m   1/1     Running   0          10s
myapp-deploy-675558bfc5-mbkt8   1/1     Running   0          10s
myapp-deploy-675558bfc5-shhtf   1/1     Running   0          10s
[root@k8s-master ingress-nginx]# kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   21d
myapp        ClusterIP   10.106.152.155   <none>        80/TCP    17s
#现在定义NodePort Service，使Ingress Controller可使集群外的用户访问
6. [root@k8s-master ingress-nginx]# wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/baremetal/service-nodeport.yaml
7. [root@k8s-master ingress-nginx]# ls
configmap.yaml  rbac.yaml              tcp-services-configmap.yaml  with-rbac.yaml
namespace.yaml  service-nodeport.yaml  udp-services-configmap.yaml
8. [root@k8s-master ingress-nginx]# cat service-nodeport.yaml 
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 30080
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      nodePort: 30443
      protocol: TCP
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
9. [root@k8s-master ingress-nginx]# kubectl apply  -f service-nodeport.yaml 
service/ingress-nginx created
10. [root@k8s-master ingress-nginx]# kubectl get svc -n ingress-nginx
NAME            TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx   NodePort   10.97.189.167   <none>        80:30080/TCP,443:30443/TCP   2m13s
#定义Ingress:
11. [root@k8s-master ingress-nginx]# cat ingress-nginx.yaml 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-myapp
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx" #这项很重要，说明是nginx还是envoy,traefik
spec:
  rules:
  - host: myapp.magedu.com
    http:
      paths: 
      - path: 
        backend:
          serviceName: myapp
          servicePort: 80
[root@k8s-master ingress-nginx]# kubectl apply -f ingress-nginx.yaml 
ingress.extensions/ingress-myapp created
12. root@k8s-master ingress-nginx]# kubectl exec -it -n ingress-nginx nginx-ingress-controller-5694ccb578-cmb7h -- /bin/sh  #进入ingress controller查看配置文件是否被ingress的规则匹配到
#注：删除多余的pod始终删不掉，自己会重构，此时可查看pod的控制器类型，删除符合的控制器即可[root@k8s-master manifests]# kubectl delete deploy qq
deployment.extensions "qq" deleted
13. 编辑C:\Windows\System32\drivers\etc,添加hosts记录
192.168.1.31 myapp.magedu.com 
#部署tomcat
[root@k8s-master ingress-nginx]# cat tomcat-deploy.yaml 
apiVersion: v1
kind: Service
metadata:
  name: tomcat 
  namespace: default 
spec:
  selector:
    app: tomcat
    release: canary
  ports:
  - name: http
    targetPort: 8080
    port: 8080
  - name: ajp
    targetPort: 8009
    port: 8009
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deploy
  namespace: default
spec:
  replicas: 3
  selector: 
    matchLabels: 
      app: tomcat
      release: canary
  template: 
    metadata:
      labels: 
        app: tomcat
        release: canary
    spec:
      containers:
      - name: tomcat
        image: tomcat:8.5.32-jre8-alpine
        ports: 
        - name: http
          containerPort: 8080
        - name: ajp
          containerPort: 8009

[root@k8s-master ingress-nginx]# cat tomcat-ingress.yaml 
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-tomcat
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: tomcat.magedu.com
    http:
      paths: 
      - path: 
        backend:
          serviceName: tomcat
          servicePort: 8080
14. [root@k8s-master ingress-nginx]# kubectl apply -f tomcat-deploy.yaml 
service/tomcat created
[root@k8s-master ingress-nginx]# kubectl apply -f tomcat-ingress.yaml 
ingress.extensions/ingress-myapp configured
##配置Ingress Controller为https的主机，把证书和私钥做成secret，就是打包成secret
15. [root@k8s-master ingress-nginx]# openssl genrsa -out tls.key 2048 #生成私钥
16. [root@k8s-master ingress-nginx]# openssl req -new -x509 -key tls.key -out tls.crt -subj /C=CN/ST=Shanghai/L=Shanghai/O=DevOps/CN=tomcat.magedu.com #生成公钥
17. [root@k8s-master ingress-nginx]# kubectl create secret tls tomcat-ingress-secret --cert=tls.crt --key=tls.key #创建secret，类型为tls，名字为tomcat-ingress-secret，指定证书和私钥
secret/tomcat-ingress-secret created
18. [root@k8s-master ingress-nginx]# kubectl get secret
NAME                    TYPE                                  DATA   AGE
default-token-lw499     kubernetes.io/service-account-token   3      22d
tomcat-ingress-secret   kubernetes.io/tls                     2      58s
19. [root@k8s-master ingress-nginx]# kubectl describe secret tomcat-ingress-secret 
Name:         tomcat-ingress-secret
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1302 bytes
tls.key:  1679 bytes
20. [root@k8s-master ingress-nginx]# cat tomcat-ingress-tls.yaml  #编写ingress-tomcat-tls Ingress,使tomcat.magedu.com虚拟主机访问时加密访问的，实现https
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-tomcat-tls
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - tomcat.magedu.com
    secretName: tomcat-ingress-secret
  rules:
  - host: tomcat.magedu.com
    http:
      paths: 
      - path: 
        backend:
          serviceName: tomcat
          servicePort: 8080
21. [root@k8s-master ingress-nginx]# kubectl apply -f tomcat-ingress-tls.yaml #应用ingress
22. [root@k8s-master ingress-nginx]# kubectl get ingresses
NAME                 HOSTS               ADDRESS   PORTS     AGE
ingress-tomcat       tomcat.magedu.com             80, 443   3h17m
ingress-tomcat-tls   tomcat.magedu.com             80, 443   5m52s
23. 浏览器访问https://tomcat.magedu.com:30443/即可实现https访问。而后端跟Ingress Controller是明文传输的。

##Ingress Controller总结：Ingress Controller通常是实现https的，通常Ingress Controller有nginx,envoy,traefik三种，上面演示的是ingress-nginx，而ingress则是生成规则，匹配对应的service，使service下的pod为目标主机，pod的改变会被service知道，而ingress一直在监视service，从而pod的变化ingress也是第一时间知道，所以ingress是用来固定pod的目标主机ip的，而且会把信息生成配置注入到Ingress Controller当中，实现Ingress-nginx的动态反向代理。pod也是用户真正访问到的站点，而Ingress Controller和pod之间是明文传输的，用户与Ingress Controller是密文传输的，当用户请求到达Ingress Controller时把tls卸载，使Ingress Controller和pod之间是明文交互，当pod到达Ingress Controller后，Ingress Controller则加载tls，最后实现密文传输给用户。最终实现用户与站点的https交互。

#第十二节：存储卷
SAN:iSCSI,FC
NAS:nfs,cifs,http
分布式存储：glusterfs,ceph:rdb和cephfs
云存储：EBS(亚马逊),Azure Disk(微软)，阿里巴巴和谷歌都有
kubectl explain pods.spec.volume #查看pod支持哪些存储卷
1. emptyDir:空目录，随着pod的消失目录而消失
2. hostPath:宿主机目录挂载，pod的消失而宿主机目录不消失
3. gitRepo:同步git仓库的资源到本地容器当中，是基于emptyDir的
构建存储卷步骤：
1. 在pod上创建pvc并关联到物理存储系统
2. 在容器上使用volumemounts挂载到pod上的pvc

##emptyDir：
-------------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-demo
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    imagePullPolicy: IfNotPresent
    ports:
    - name: http
      containerPort: 80
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html/
  - name: busybox
    image: busybox:latest
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: html
      mountPath: /data/
    command: ['/bin/sh','-c','while true;do echo $(date) >> /data/index.html;sleep 2;done']
  volumes:
  - name: html
    emptyDir: {}   #表示使用默认值

##结论：在两个容器当中他们是共享html挂载点的，但是一但这个上pod挂掉之后，则这个挂载目录的数据会全部丢失。
-------------------------------
#hostPath: #共享主机上的目录，节点挂了数据就全没了
-------------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-vol-hostpath
  namespace: default
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    volumeMounts: 
    - name: html
      mountPath: /usr/share/nginx/html/
  volumes:
  - name: html
    hostPath:
      path: /data/pod/volume1
      type: DirectoryOrCreate #类型为DirectoryOrCreate,表示没有此目录就会新建，irectory则为不自主新建
##结论：此时这个容器会运行在某个节点上，在运行的节点上会新建/data/pod/volume1此目录进行挂到到容器共享，当pod挂掉时，数据还在，但当pod重新运行时，可能这个容器运行在另外的一个节点上，而之前的数据不会被访问掉。
-------------------------------
#NFS： #独立于节点外的存储系统，节点挂了数据还存在于存储系统当中
#先安装nfs存储系统：
yum install nfs-utils -y
[root@kvm ~]# mkdir -p /data/volumes #nfs目录
[root@kvm ~]# vim /etc/exports
/data/volumes   192.168.0.0/16(rw,no_root_squash) #指定nfs目录，指定允许访问的ip地址，并给定读写权限，设定root用户权限不被压缩。
[root@kvm ~]# netstat -tnlp | grep 2049
tcp        0      0 0.0.0.0:2049            0.0.0.0:*               LISTEN      -                   
tcp6       0      0 :::2049                 :::*                    LISTEN      -                   
#NFS配置清单文件：
-------------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-vol-nfs
  namespace: default
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    volumeMounts: 
    - name: html  #存储系统名称
      mountPath: /usr/share/nginx/html/ #容器挂载目录
  volumes:
  - name: html
    nfs:
      path: /data/volumes  #nfs存储系统的目录
      server: stor01.magedu.com #nfs存储系统的服务地址
-------------------------------
每个节点上要设置nfs的解析：echo '192.168.1.233 nfs' >> /etc/hosts
每个节点上要安装nfs客户端：yum install nfs-utils -y 
#PC和PVC
存储工程师：管理存储设备，建立存储单元
集群管理员：建立PV，与存储单元建立关系，一般一个PV对应一个存储单元
集群用户：建立PVC，并设置PVC规则使之与PV建立关系，一个PVC只能对应一个PV,一个PVC可以被多个Pod引用（是否被多个pod访问主要看PVC的访问模式设置）
PV是集群级别的，namespace也是集群级别的，pod，service等是namespace级别的
#注意：当PVC与PV没有绑定，此时PVC状态为Pending（挂起），直至PV符合PVC的规则时PVC才能被绑定。
1. 设置存储单元：
[root@kvm volumes]# mkdir v{1,2,3,4,5}
[root@kvm volumes]# cat /etc/exports
/data/volumes/v1        192.168.0.0/16(rw,no_root_squash)
/data/volumes/v2        192.168.0.0/16(rw,no_root_squash)
/data/volumes/v3        192.168.0.0/16(rw,no_root_squash)
/data/volumes/v4        192.168.0.0/16(rw,no_root_squash)
/data/volumes/v5        192.168.0.0/16(rw,no_root_squash)
[root@kvm volumes]# exportfs -arv #重新导出并更新所有nfs列表
exporting 192.168.0.0/16:/data/volumes/v5
exporting 192.168.0.0/16:/data/volumes/v4
exporting 192.168.0.0/16:/data/volumes/v3
exporting 192.168.0.0/16:/data/volumes/v2
exporting 192.168.0.0/16:/data/volumes/v1
[root@kvm ~]# showmount -e #查看NFS服务导出列表
Export list for kvm:
/data/volumes/v5 192.168.0.0/16
/data/volumes/v4 192.168.0.0/16
/data/volumes/v3 192.168.0.0/16
/data/volumes/v2 192.168.0.0/16
/data/volumes/v1 192.168.0.0/16
2. 定义PV
[root@k8s-master ~]# kubectl explain pv.spec #查看配置清单帮助，跟定义在pod上的存储一模一样
[root@k8s-master volume]# cat pv-demo.yaml 
-------------------------------
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv001  #pv的名称。因为是集群级别，所以没有namespace
  labels:
    name: pv001
spec:
  nfs:
    path: /data/volumes/v1  #nfs的存储单元路径
    server: nfs  #nfs服务器地址
  accessModes: ['ReadWriteMany','ReadWriteOnce'] #PV的访问模式为多路读写，单路读写，还有一种为多路只读(ReadOnlyMany),对应可以简写为：RWX,RWO,ROX
  capacity:
    storage: 2Gi  #容量为2G，是以1024为单位的，2G单位为1000
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv002
  labels:
    name: pv002
spec:
  nfs:
    path: /data/volumes/v2
    server: nfs
  accessModes: ['ReadWriteOnce']
  capacity:
    storage: 5Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv003
  labels:
    name: pv003
spec:
  nfs:
    path: /data/volumes/v3
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 20Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv004
  labels:
    name: pv004
spec:
  nfs:
    path: /data/volumes/v4
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 10Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv005
  labels:
    name: pv005
spec:
  nfs:
    path: /data/volumes/v5
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 10Gi
---
-------------------------------
[root@k8s-master volume]# kubectl apply -f pv-demo.yaml 
persistentvolume/pv001 created
persistentvolume/pv002 created
persistentvolume/pv003 created
persistentvolume/pv004 created
persistentvolume/pv005 created
[root@k8s-master volume]# kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv001   2Gi        RWO,RWX        Retain           Available                                   3m47s #Retain为回收策略中的保留，Available为可用，表示未被PVC绑定
pv002   5Gi        RWO            Retain           Available                                   3m47s
pv003   20Gi       RWO,RWX        Retain           Available                                   3m47s
pv004   10Gi       RWO,RWX        Retain           Available                                   3m47s
pv005   10Gi       RWO,RWX        Retain           Available                                   3m47s
#注：回收策略：Retain（保留用户数据），recycle（把数据全删了，PV腾出来给另的PVC使用），delete（PVC删了，PV也删了）

3. 定义PVC
[root@k8s-master volume]# cat pod-vol-pvc.yaml 
----------------------------
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
  namespace: default
spec:
  accessModes: ['ReadWriteMany'] #指定pvc对pod端的访问模式，这个访问模式必须是PV所能支持的（也被称为PV的子集）
  resources:
    requests:
      storage: 6Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-vol-mypvc
  namespace: default
  labels:
    app: mypvc
    tier: frontend
  annotations: 
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html/
  volumes:
  - name: html
    persistentVolumeClaim:
      claimName: mypvc 
----------------------------
[root@k8s-master volume]# kubectl get pv -o wide
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM           STORAGECLASS   REASON   AGE
pv001   2Gi        RWO,RWX        Retain           Available                                           25m
pv002   5Gi        RWO            Retain           Available                                           25m
pv003   20Gi       RWO,RWX        Retain           Available                                           25m
pv004   10Gi       RWO,RWX        Retain           Bound       default/mypvc                           25m #被default/mypvc 绑定了
pv005   10Gi       RWO,RWX        Retain           Available                                           25m
[root@k8s-master volume]# kubectl get pvc -o wide
NAME    STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mypvc   Bound    pv004    10Gi       RWO,RWX                       7m11s #这个pvc是已经绑定了，绑定的PV是pv004,大小为10Gi,PV的访问模式是单路读写和多路读写
注：只有pod运行在节点上，其它资源基本保存在etcd当中

#第十三节：configMap和secret
#动态供给：给pv创建类，pvc选择类。
#configMap和secret
configMap:是配置中心，1.容器可以把configMap挂载在容器中使用 2.把configMap注入到容器的变量当中，容器引入变量来使用配置文件。但configMap是明文的。
secret:跟configMap一样是配置中心，但是是base64编码的配置中心。

#配置容器化应用的试：
1. 自定义命令行参数，通过command和args来传命令
2. 把配置文件直接写入到镜像，写得太死了
3. 环境变量，1.通过预处理脚本entrypoint来读取变量并把值传给容器的配置文件 2.Cloud Native的应用程序直接通过环境变量加载到配置文件
4. 存储卷

#configMap,名称空间级别
[root@k8s-master ~]# kubectl create configmap nginx-config --from-literal=nginx_port=80 --from-literal=server_name=myapp.magedu.com #1. 创建一个名叫nginx-config的configMap，并指定nginx_port=80和server_name=myapp.magedu.com的键值对值，2. --from-file=path/to/bar这里bar为键，文件内容为值，3. --from-file=key1=/path/to/bar/file1.txt这个键为key1,值为这个文件，这几种方式都可以写
configmap/nginx-config created
[root@k8s-master ~]# kubectl get cm #查看configmap
NAME           DATA   AGE
nginx-config   2      3m20s
[root@k8s-master ~]# kubectl describe cm nginx-config
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx_port:
----
80
server_name:
----
myapp.magedu.com
Events:  <none>
[root@k8s-master configmap]# kubectl create configmap nginx-www --from-file=./www.conf  #键名为www.conf，值为文件的值
configmap/nginx-www created
[root@k8s-master configmap]# kubectl get cm nginx-www  -o yaml
apiVersion: v1
data:
  www.conf: "server {\n\tserver_name myapp.magedu.com;\n\tlisten 80;\n\troot /data/web/html;\n}\n"
kind: ConfigMap
metadata:
  creationTimestamp: "2019-05-03T11:26:23Z"
  name: nginx-www
  namespace: default
  resourceVersion: "3316126"
  selfLink: /api/v1/namespaces/default/configmaps/nginx-www
  uid: 480aeeca-6d96-11e9-8f19-005056ad5cec
#配置configMap清单###以环境变量获取配置：
[root@k8s-master configmap]# vim pod-configmap.yaml 
-----------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-cm-1
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    ports:
    - name: http
      containerPort: 80
    env:
    - name: NGINX_SERVER_PORT  #在k8s和docker中以下划线分隔，横线也会被转换成下划线的，这个变量是容器新建的变量
      valueFrom: #值从外部引用
        configMapKeyRef:  #引用自configMap的Key
          name: nginx-config  #configMap的名称是nginx-config
          key: nginx_port  #键是nginx_port,所以NGINX_SERVER_PORT值为nginx_port的值
    - name: NGINX_SERVER_NAME
      valueFrom:
        configMapKeyRef:
          name: nginx-config
          key: server_name 
-----------------------------

[root@k8s-master configmap]# kubectl apply -f pod-configmap.yaml 
pod/pod-cm-1 created
#此时容器中的新变量值为设定的值，当使用kubectl edit cm nginx-config 编辑键nginx_port为8080时，容器的变量不会实时更新，只在容器创建时更新
###以存储卷获取配置
[root@k8s-master configmap]# cat pod-configmap-2.yaml 
---------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-cm-2
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    ports:
    - name: http
      containerPort: 80
    volumeMounts:
    - name: nginxconf
      mountPath: /etc/nginx/config.d/
      readOnly: true
  volumes:
  - name: nginxconf
    configMap:
      name: nginx-config
---------------------------
[root@k8s-master configmap]# kubectl edit cm nginx-config 
 nginx_port: "8080"
/etc/nginx/config.d # cat nginx_port   #以这种存储卷挂载的可以自动更新，只是会有延迟，因为是从APIserver同步过来的
8080/etc/nginx/config.d # 

##实例：创建nginx容器以存储卷方式挂载配置文件
[root@k8s-master configmap]# cat pod-configmap-3.yaml 
---------------------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-cm-3
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    ports:
    - name: http
      containerPort: 80
    volumeMounts:
    - name: nginxconf
      mountPath: /etc/nginx/conf.d/
      readOnly: true
  volumes:
  - name: nginxconf
    configMap:
      name: nginx-www
---------------------------
[root@k8s-master configmap]# kubectl apply -f pod-configmap-3.yaml 
pod/pod-cm-3 created
[root@k8s-master configmap]# kubectl exec -it pod-cm-3 -- /bin/sh
/etc/nginx/conf.d # nginx -T #查看nginx当前运行的配置
/etc/nginx/conf.d # mkdir -p /data/web/html
/etc/nginx/conf.d # echo 'configMap' > /data/web/html/index.html #创建主页
[root@k8s-master configmap]# vim /etc/hosts #设置pod解析
[root@k8s-master configmap]# curl myapp.magedu.com
configMap
[root@k8s-master configmap]# kubectl edit cm nginx-www#把80改成8080端口
/etc/nginx/conf.d # cat www.conf 
server {
        server_name myapp.magedu.com;
        listen 80;
        root /data/web/html;
}
/etc/nginx/conf.d # cat www.conf 
server {
        server_name myapp.magedu.com;
        listen 8080;       #这里会过几分钟会同步
        root /data/web/html;
}
/etc/nginx/conf.d # nginx -s reload  #使用脚本或其他方法重载配置文件
2019/05/04 05:15:54 [notice] 44#44: signal process started
/etc/nginx/conf.d # netstat -tnlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      1/nginx: master pro
[root@k8s-master configmap]# curl myapp.magedu.com:8080
configMap

###configMap可以只对文件中的部分配置来引用
把私钥和证书定义成secret,把配置文件定义成configMap,如果涉及帐号密码应该也把帐号密码定义成secret.
##secret
secret有3种类型：1.docker-registry(当从私有仓库中pull镜像是需要认证时需要用这种类型创建secret)  2.generic（当使用其他帐号和密码时使用这种）  3. tls(使用私钥和证书时使用这种)
[root@k8s-master configmap]# kubectl create secret --help
---------
Create a secret using specified subcommand.

Available Commands:
  docker-registry Create a secret for use with a Docker registry
  generic         Create a secret from a local file, directory or literal value
  tls             Create a TLS secret

Usage:
  kubectl create secret [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
---------
[root@k8s-master configmap]# kubectl create secret generic mysql-root-password --from-literal=password=Myp@ss123 #新建一个mysql密码
[root@k8s-master configmap]# kubectl get secret
NAME                    TYPE                                  DATA   AGE
default-token-lw499     kubernetes.io/service-account-token   3      27d
mysql-root-password     Opaque                                1      35s
tomcat-ingress-secret   kubernetes.io/tls                     2      5d16h
[root@k8s-master configmap]# kubectl describe secret mysql-root-password 
Name:         mysql-root-password
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  9 bytes  #secret不显示值
[root@k8s-master configmap]# kubectl describe configmap nginx-config
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
server_name:
----
myapp.magedu.com   #configmap类型显示值
nginx_port:
----
8080
Events:  <none>
[root@k8s-master configmap]# kubectl get secrets mysql-root-password -o yaml #使用此命令可查看到password Base64编码后的数据 
apiVersion: v1
data:
  password: TXlwQHNzMTIz
kind: Secret
metadata:
  creationTimestamp: "2019-05-04T05:43:59Z"
  name: mysql-root-password
  namespace: default
  resourceVersion: "3420405"
  selfLink: /api/v1/namespaces/default/secrets/mysql-root-password
  uid: 9d3885f3-6e2f-11e9-8f19-005056ad5cec
type: Opaque
[root@k8s-master configmap]# echo TXlwQHNzMTIz | base64 -d #使用此命令可以解密
Myp@ss123[root@k8s-master configmap]# 
##把secret以环境变量方式注入到容器当中
[root@k8s-master configmap]# vim pod-secret.yaml 
-------------
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-1
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    ports:
    - name: http
      containerPort: 80
    env:
    - name: MYSQL-ROOT-PASSWORD
      valueFrom:
        secretKeyRef:
          name: mysql-root-password
          key: password
-------------
[root@k8s-master configmap]# kubectl exec pod-secret-1 -- printenv | grep MYSQL-ROOT-PASSWORD   
MYSQL-ROOT-PASSWORD=Myp@ss123
###注：secret用法跟configMap用法一样。

#第十四节：statefulset控制器
CoreOS: Operator
StatefulSet:有状态副本集
	群体：cattle   个体：ped
	PetSet(1.5-)-->StatefulSet
1. 稳定且惟一的网络标识符;  #pod名称是固定唯一的
2. 稳定且持久的存储;   #采用pvc来绑定pod名称，pvc策略为数据不会删除
3. 有序、平滑地部署和扩展;  
4. 有序、平滑地终止和删除;
5. 有序的流动更新;
pod_name.service_name.namespace_name.cluster.local #集群解析名称格式 
#实例：
#重新构建PV：
[root@k8s-master volume]# vim pv-demo.yaml 
-------------  
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv001
  labels:
    name: pv001
spec:
  nfs:
    path: /data/volumes/v1
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 5Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv002
  labels:
    name: pv002
spec:
  nfs:
    path: /data/volumes/v2
    server: nfs
  accessModes: ['ReadWriteOnce']
  capacity:
    storage: 5Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv003
  labels:
    name: pv003
spec:
  nfs:
    path: /data/volumes/v3
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 5Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv004
  labels:
    name: pv004
spec:
  nfs:
    path: /data/volumes/v4
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 10Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv005
  labels:
    name: pv005
spec:
  nfs:
    path: /data/volumes/v5
    server: nfs
  accessModes: ['ReadWriteMany','ReadWriteOnce']
  capacity:
    storage: 10Gi
-------------      
[root@k8s-master volume]# kubectl apply -f pv-demo.yaml 
persistentvolume/pv001 created
persistentvolume/pv002 created
persistentvolume/pv003 created
persistentvolume/pv004 created
persistentvolume/pv005 created
[root@k8s-master volume]# kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv001   5Gi        RWO,RWX        Retain           Available                                   1s
pv002   5Gi        RWO            Retain           Available                                   1s
pv003   5Gi        RWO,RWX        Retain           Available                                   1s
pv004   10Gi       RWO,RWX        Retain           Available                                   1s
pv005   10Gi       RWO,RWX        Retain           Available                                   1s
##创建一个statefulSet的
[root@k8s-master volume]# vim statefulSet.yaml 
-------------------------------
apiVersion: v1
kind: Service
metadata: 
  name: myapp
  labels:
    app: myapp
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None   #设置无头service(无IP的headless Service)
  selector: 
    app: myapp-pod
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: myapp
spec:
  serviceName: myapp  #绑定无头service
  replicas: 3
  selector:
    matchLabels:
      app: myapp-pod
  template:
    metadata:
      labels:
        app: myapp-pod
    spec: 
        containers:
        - name: myapp
          image: ikubernetes/myapp:v1
          ports:
          - containerPort: 80
            name: web
          volumeMounts:   #挂载卷名叫myappdata到/usr/share/nginx/html/
          - name: myappdata
            mountPath: /usr/share/nginx/html/
  volumeClaimTemplates:   #这是vc模块，针对每个pod建立一个pvc
  - metadata:
      name: myappdata
    spec:
      accessModes: ['ReadWriteOnce']
      resources:
        requests:
          storage: 5Gi        
-------------------------------
[root@k8s-master volume]# kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   27d
myapp        ClusterIP   None         <none>        80/TCP    62s
[root@k8s-master volume]# kubectl get sts
NAME    READY   AGE
myapp   3/3     23s
[root@k8s-master volume]# kubectl get pods 
NAME      READY   STATUS    RESTARTS   AGE
myapp-0   1/1     Running   0          9s
myapp-1   1/1     Running   0          6s
myapp-2   1/1     Running   0          3s
[root@k8s-master volume]# kubectl get pvc
NAME                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myappdata-myapp-0   Bound    pv002    5Gi        RWO                           15s
myappdata-myapp-1   Bound    pv001    5Gi        RWO,RWX                       12s
myappdata-myapp-2   Bound    pv003    5Gi        RWO,RWX                       9s
[root@k8s-master volume]# kubectl get pv 
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                       STORAGECLASS   REASON   AGE
pv001   5Gi        RWO,RWX        Retain           Bound       default/myappdata-myapp-1                           22m
pv002   5Gi        RWO            Retain           Bound       default/myappdata-myapp-0                           22m
pv003   5Gi        RWO,RWX        Retain           Bound       default/myappdata-myapp-2                           22m
pv004   10Gi       RWO,RWX        Retain           Available                                                       22m
pv005   10Gi       RWO,RWX        Retain           Available                                                       22m
[root@k8s-master volume]# kubectl delete -f statefulSet.yaml 
service "myapp" deleted
statefulset.apps "myapp" deleted
[root@k8s-master volume]# kubectl get pods
No resources found.
[root@k8s-master volume]# kubectl get pvc #默认pvc一直存在
NAME                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myappdata-myapp-0   Bound    pv002    5Gi        RWO                           10m
myappdata-myapp-1   Bound    pv001    5Gi        RWO,RWX                       10m
myappdata-myapp-2   Bound    pv003    5Gi        RWO,RWX                       10m
[root@k8s-master volume]# kubectl apply -f statefulSet.yaml 
service/myapp created
statefulset.apps/myapp created
[root@k8s-master volume]# kubectl get pods  #新建的statefulSet还是原来的name，这是因为用同一个sts模板建立的，所以名称还和以前一样，使之前的pvc与重新构建的pod相挂载
NAME      READY   STATUS    RESTARTS   AGE
myapp-0   1/1     Running   0          6s
myapp-1   1/1     Running   0          4s
myapp-2   1/1     Running   0          3s
[root@k8s-master volume]# kubectl get pvc
NAME                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myappdata-myapp-0   Bound    pv002    5Gi        RWO                           16m
myappdata-myapp-1   Bound    pv001    5Gi        RWO,RWX                       15m
myappdata-myapp-2   Bound    pv003    5Gi        RWO,RWX                       15m

[root@k8s-master volume]# kubectl exec -it myapp-0 -- /bin/sh  #在sts控制器下的pod他们之前的pod名称是可以直接解析的
/ # nslookup myapp-0
nslookup: can't resolve '(null)': Name does not resolve

Name:      myapp-0
Address 1: 10.244.2.78 myapp-0.myapp.default.svc.cluster.local
/ # nslookup myapp-1.myapp.default.svc.cluster.local
nslookup: can't resolve '(null)': Name does not resolve

Name:      myapp-1.myapp.default.svc.cluster.local
Address 1: 10.244.1.80 myapp-1.myapp.default.svc.cluster.local
/ # nslookup myapp-2.myapp.default.svc.cluster.local #当解析pod名称时需要写service名称
nslookup: can't resolve '(null)': Name does not resolve

Name:      myapp-2.myapp.default.svc.cluster.local
Address 1: 10.244.2.79 myapp-2.myapp.default.svc.cluster.local
[root@k8s-master configmap]# kubectl scale sts myapp --replicas=5 #扩展pod
statefulset.apps/myapp scaled
[root@k8s-master volume]# kubectl get pvc
NAME                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myappdata-myapp-0   Bound    pv002    5Gi        RWO                           30m
myappdata-myapp-1   Bound    pv001    5Gi        RWO,RWX                       30m
myappdata-myapp-2   Bound    pv003    5Gi        RWO,RWX                       30m
myappdata-myapp-3   Bound    pv004    10Gi       RWO,RWX                       26s
myappdata-myapp-4   Bound    pv005    10Gi       RWO,RWX                       23s
[root@k8s-master configmap]# kubectl patch sts myapp -p '{"spec":{"replicas":2}}' #打补丁的方式缩减pod
statefulset.apps/myapp patched
[root@k8s-master configmap]# kubectl get pvc  
NAME                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
myappdata-myapp-0   Bound    pv002    5Gi        RWO                           33m
myappdata-myapp-1   Bound    pv001    5Gi        RWO,RWX                       33m
myappdata-myapp-2   Bound    pv003    5Gi        RWO,RWX                       33m  #但是之前的pvc不会删除，只会保留
myappdata-myapp-3   Bound    pv004    10Gi       RWO,RWX                       3m8s
myappdata-myapp-4   Bound    pv005    10Gi       RWO,RWX                       3m5s
#注：sts的扩展和缩减，更新都是逆序操作的。
[root@k8s-master configmap]# kubectl describe sts myapp #查看sts的更新策略
Update Strategy:    RollingUpdate
  Partition:        824636334988
[root@k8s-master configmap]# kubectl patch sts myapp -p '{"spec":{"updateStrategy":{"rollingUpdate":{"partition":4}}}}' #以打补丁方式设定sts的滚动更新策略为分区大于等于4的更新
[root@k8s-master configmap]# kubectl set image sts myapp myapp=ikubernetes/myapp:v2
statefulset.apps/myapp image updated
[root@k8s-master configmap]# kubectl get pods myapp-4 -o yaml
image: ikubernetes/myapp:v2  #可以查看到已经更新为2版本
[root@k8s-master configmap]# kubectl get pods myapp-3 -o yaml
image: ikubernetes/myapp:v1
[root@k8s-master configmap]# kubectl get sts -o wide  #控制器层面的镜像版本
NAME    READY   AGE   CONTAINERS   IMAGES
myapp   5/5     45m   myapp        ikubernetes/myapp:v2
#搜索statefulSet相关的有状态服务：kubernetes statefulset redis

#第十五节：k8s认证及service account
#restful风格详解:
Restful就是一个资源定位及资源操作的风格。不是标准也不是协议，只是一种风格。基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制。
资源：互联网所有的事物都可以被抽象为资源 
资源操作：使用POST、DELETE、PUT、GET，使用不同方法对资源进行操作。 
分别对应 添加、 删除、修改、查询。 

1. 认证  #第三方插件很多，并行认证，并非串行认证 #认证
2. 授权  #第三方插件，并行认证，并非串行认证 #RBAC  #权限检查
3. 准入控制  #第三方插件，授权后的后续准则  #进一步补充了授权机制
http认证：
只能通过http协议的认证首部来实现token的传递
kubectl-->apiServer
ssl认证:
交换证书，实现https认证。
客户端-->API server
	user:username,uid
	group:groupname,gid
	extra:注解
	API Request Path:/apis/apps/v1/namespaces/default/deployment/myapp-deploy/
	注：只有核心群组v1的可以直接写/api/v1/,如果不是核心群组必须起于/apis/apps/v1/
#执行动作：
HTTP request verb:
	put,delete,post,get
API Server requests verb:
	get（查询）,list(列出)，create(创建)，updata(修改)，patch（打补丁），watch（监控）,proxy（代理）redirect（重定向）,delete（删除），deletecollection(删除一个集合)
Resource:
Subresource:
Namespace:
API group:
####认证：
##apiserver端口是6443
#kubectl执行命令时认证的是[root@k8s-master ~]# cat .kube/config 这个文件下的证书加密和解密方式，只要把这个文件复制到其他客户端，其他客户端也可连上APIserver
[root@k8s-master ~]# curl https://localhost:6443/api/v1/namespaces #没有使用认证信息时访问apiserver会访问不成功
curl: (60) Peer's Certificate issuer is not recognized.
More details here: http://curl.haxx.se/docs/sslcerts.html

curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option.

[root@k8s-master ~]# kubectl proxy --port=8080  #在本地127.0.0.1:8080开启代理，使发送到本地的请求都给代理到apiserver，并且使用kubectl的证书来解密
[root@k8s-master ~]# curl http://localhost:8080/api/v1/namespaces #此时会访问成功 
[root@k8s-master ~]# curl http://localhost:8080/api/v1/namespaces/kube-system/
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-system",
    "selfLink": "/api/v1/namespaces/kube-system",
    "uid": "7379868a-5855-11e9-8aeb-005056ad5cec",
    "resourceVersion": "4",
    "creationTimestamp": "2019-04-06T10:19:24Z"
  },
  "spec": {
    "finalizers": [
      "kubernetes"
    ]
  },
  "status": {
    "phase": "Active"
  }
}
[root@k8s-master ~]# curl http://localhost:8080/apis/apps/v1/namespaces/kube-system/depoyments/  #查看控制器类型
##使用api操作：create,edit,delete，get
#两类认证：1. userAccount[一般人使用到的]  2. serviceAccount[pod中使用的]
创建serviceAccount,并用pod的serviceAccountName来指定serviceAccount
#serviceAccount:
[root@k8s-master ~]# kubectl create serviceaccount mysa -o yaml --dry-run #测试并输出成yaml格式，输出成框架
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: null
  name: mysa
[root@k8s-master ~]# kubectl get pods myapp-0 -o yaml --export #导出成配置框架，以后可以自己拿来用改改就成
[root@k8s-master ~]# kubectl create sa admin #新建一个serviceaccount
serviceaccount/admin created
[root@k8s-master ~]# kubectl get sa
NAME      SECRETS   AGE
admin     1         7s
default   1         28d
[root@k8s-master ~]# kubectl describe sa admin #查看admin的serviceaccount详细信息
Name:                admin
Namespace:           default
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   admin-token-5v6z8  #k8s为serviceaccount创建的token,只是认证作用，没有授权
Tokens:              admin-token-5v6z8
Events:              <none>
[root@k8s-master ~]# kubectl get secret
NAME                    TYPE                                  DATA   AGE
admin-token-5v6z8       kubernetes.io/service-account-token   3      90s #k8s为serviceaccount创建的token
default-token-lw499     kubernetes.io/service-account-token   3      28d #系统默认创建的token,有最小的授权
mysql-root-password     Opaque                                1      7h31m
tomcat-ingress-secret   kubernetes.io/tls                     2      6d
[root@k8s-master manifests]# vim pod-sa-demo.yaml 
-----------
apiVersion: v1
kind: Pod
metadata:
  name: pod-sa-demo
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    magedu.com/created-by: "cluster admin"
spec:
  containers:
  - name: myapp
    image: nginx:1.14-alpine
    ports:
    - name: http
      containerPort: 80
  serviceAccountName: admin  #把这个pod绑定在admin这个serviceaccount上，
-----------
[root@k8s-master manifests]# kubectl apply -f pod-sa-demo.yaml 
pod/pod-sa-demo created
[root@k8s-master manifests]# kubectl describe pods pod-sa-demo #查看是否被绑定为admin的serviceaccount
 SecretName:  admin-token-5v6z8
##当你的pod从私有仓库下载镜像时，需要用到认证信息，1. 可以在pod上使用ImagePullSecret来指定docker-registry类型的secret 2.  可以在pod上使用serviceAccountName来指定serviceAccount，在serviceAccount上加入ImagePullSecret（docker-registry的类型）
#k8s上的认证一般用专有CA,并不会轻易授权给其他用户，因为一旦授权就可以拿来认证APIserver了

#设置证书，证书持有者就是用户名
[root@k8s-master pki]# (umask 077; openssl genrsa -out magedu.key 2048) #用子shell创建magedu私钥
Generating RSA private key, 2048 bit long modulus
..................................................+++
......+++
e is 65537 (0x10001)
[root@k8s-master pki]# openssl req -new -key magedu.key -out magedu.csr -subj "/CN=magedu"  #生成证书申请请求，CN就是用户名，
[root@k8s-master pki]# openssl x509 -req -in magedu.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out magedu.crt -days 365 #用k8s的ca进行授权magedu这个用户
Signature ok
subject=/CN=magedu
Getting CA Private Key
[root@k8s-master pki]# openssl x509 -in magedu.crt -text -noout #查看证书信息
把magedu用户设成PIServer认证的用户并隐藏证书信息
[root@k8s-master pki]# kubectl config set-credentials magedu --client-certificate=./magedu.crt --client-key=./magedu.key --embed-certs=true #设置magedu为当前集群的用户
User "magedu" set.  
[root@k8s-master pki]# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
- name: magedu
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
#设定上下文使magedu能访问当前集群
[root@k8s-master pki]# kubectl config set-context magedu@kubernetes --cluster=kubernetes --user=magedu
Context "magedu@kubernetes" created.
[root@k8s-master pki]# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    user: magedu
  name: magedu@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
- name: magedu
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
[root@k8s-master pki]# kubectl config use-context magedu@kubernetes #切换用户为magedu
Switched to context "magedu@kubernetes".
[root@k8s-master pki]# kubectl get pods #此时magedu没有权限访问
Error from server (Forbidden): pods is forbidden: User "magedu" cannot list resource "pods" in API group "" in the namespace "default"
---------设置集群为样例----------
[root@k8s-master pki]# kubectl config set-cluster --help
[root@k8s-master pki]# kubectl config set-cluster mycluster --kubeconfig=/tmp/test.conf --server=https://192.168.1.238:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true #设置一个集群并新建配置文件
Cluster "mycluster" set.
[root@k8s-master pki]# kubectl config view --kubeconfig=/tmp/test.conf 
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: mycluster
contexts: []
current-context: ""
kind: Config
preferences: {}
users: []
---------设置集群为样例----------

####授权：
[root@k8s-master manifests]# kubectl config view #查看APIServer客户端的配置文件
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

#第十六节：授权，RBAC
授权插件：Node,ABAC(基于属性AC),RBAC(基于角色AC),Webhook(基于http回调AC)
现在8S使用RBAC: Role-based AC
名称空间：Role,Rolebinding
集群级别：clusterRole,clusterRolebinding
1. 使用rolebinding去绑定role和user,此时user有了名称空间级别的role权限
2. 使用clusterrolebinding去绑定clusterrole和user，此时user有了集群级别的clusterrole权限
3. 使用rolebinding绑定clusterrole和user，此时user有了名称空间的clusterrole权限，也就是user有了自己所在名称空间的所有关于clusterrole角色当中的权限
##创建role
[root@k8s-master ~]# kubectl create role pod-reader --verb=get,list,watch --resource=pods --dry-run -o yaml > ~/manifests/rbac/role.yaml#可以创建一个role，这里演示导出为yaml格式 
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: null
  name: pod-reader
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
[root@k8s-master rbac]# cat role.yaml 
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups:  #这个是rule的起始点，必须写，不过列表你可以留空
  - ""
  resources:  #对象资源
  - pods
  verbs: #执行的动作
  - get
  - list
  - watch
[root@k8s-master rbac]# mv role.yaml role-demo.yaml
[root@k8s-master rbac]# kubectl get role
NAME         AGE
pod-reader   3s
##创建rolebinding
[root@k8s-master rbac]# kubectl create rolebinding --help
Usage:
  kubectl create rolebinding NAME --clusterrole=NAME|--role=NAME
[--user=username] [--group=groupname]
[--serviceaccount=namespace:serviceaccountname] [--dry-run] [options]
[root@k8s-master rbac]# kubectl create rolebinding magedu-pods-read --role=pod-reader --user=magedu -o yaml --dry-run > rolebinding.yaml  #--user这个用户并不是新建的帐号，而是登录时k8s会匹配到的帐号
[root@k8s-master rbac]# cat rolebinding.yaml   
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: magedu-pods-read
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: magedu
[root@k8s-master rbac]# kubectl apply -f rolebinding.yaml 
rolebinding.rbac.authorization.k8s.io/magedu-pods-read created
[root@k8s-master rbac]# kubectl describe rolebinding magedu-pods-read
Name:         magedu-pods-read
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"rbac.authorization.k8s.io/v1","kind":"RoleBinding","metadata":{"annotations":{},"creationTimestamp":null,"name":"magedu-pod...
Role:
  Kind:  Role
  Name:  pod-reader  #这个是创建的role角色，有相应对象的操作权限
Subjects:
  Kind  Name    Namespace
  ----  ----    ---------
  User  magedu    #这个是绑定的user用户。
[root@k8s-master ~]# kubectl config use-context magedu@kubernetes  #切换magedu这个用户测试权限是否生效
Switched to context "magedu@kubernetes".
[root@k8s-master ~]# kubectl get pods #已生效
NAME          READY   STATUS    RESTARTS   AGE
myapp-0       1/1     Running   0          28h
myapp-1       1/1     Running   0          28h
myapp-2       1/1     Running   0          28h
myapp-3       1/1     Running   0          28h
myapp-4       1/1     Running   0          27h
pod-sa-demo   1/1     Running   0          22h
[root@k8s-master ~]# kubectl get pods -n kube-system  #因为magedu这个用户绑定的是default这个名称空间的角色，所以只具有default这个名称空间的相应权限。
Error from server (Forbidden): pods is forbidden: User "magedu" cannot list resource "pods" in API group "" in the namespace "kube-system"
##新建clusterrole
[root@k8s-master rbac]# kubectl create clusterrole clurster-reader --verb=get,list,watch --resource=pods --dry-run -o yaml  > clusterrole.yaml
[root@k8s-master rbac]# vim clusterrole.yaml 
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-reader
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
[root@k8s-master rbac]# kubectl apply -f clusterrole.yaml 
clusterrole.rbac.authorization.k8s.io/clurster-reader created
[root@k8s-master rbac]# kubectl get clusterrole clurster-reader
NAME              AGE
clurster-reader   44s
##如何使用普通用户使用超级管理权限
[root@k8s-master rbac]# useradd ik8s
[root@k8s-master rbac]# cp -rp ~/.kube/ /home/ik8s/
[root@k8s-master rbac]# chown -R ik8s.ik8s /home/ik8s/
[root@k8s-master rbac]# su - ik8s
[ik8s@k8s-master ~]$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    user: magedu
  name: magedu@kubernetes
current-context: magedu@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
- name: magedu
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
[ik8s@k8s-master ~]$ kubectl config use-context magedu@kubenetes
error: no context exists with the name: "magedu@kubenetes" #切换用户magedu@kubernetes 
[ik8s@k8s-master ~]$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    user: magedu
  name: magedu@kubernetes
current-context: magedu@kubernetes  #此时用户为magedu@kubernetes 
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
- name: magedu
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
#注：这个新建的ik8s用户切换用户不影响root环境下的用户切换
##新建clusterrolebinding
[root@k8s-master rbac]# kubectl create clusterrolebinding --help
Usage:
  kubectl create clusterrolebinding NAME --clusterrole=NAME [--user=username] [--group=groupname] [--serviceaccount=namespace:serviceaccountname] [--dry-run] [options]
[root@k8s-master rbac]# kubectl create clusterrolebinding magedu-readall-pods --clusterrole=cluster-reader --user=magedu --dry-run -o yaml > clusterrolebinding-demo.yaml
[root@k8s-master rbac]# vim clusterrolebinding-demo.yaml 
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: magedu-readall-pods
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: magedu
[root@k8s-master rbac]# kubectl apply -f clusterrolebinding-demo.yaml 
clusterrolebinding.rbac.authorization.k8s.io/magedu-readall-pods created
[root@k8s-master rbac]# kubectl describe clusterrolebinding magedu-readall-pods
Name:         magedu-readall-pods
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"rbac.authorization.k8s.io/v1beta1","kind":"ClusterRoleBinding","metadata":{"annotations":{},"name":"magedu-readall-pods"},"...
Role:
  Kind:  ClusterRole
  Name:  cluster-reader
Subjects:
  Kind  Name    Namespace
  ----  ----    ---------
  User  magedu  
[root@k8s-master rbac]# kubectl describe clusterrole cluster-reader
Name:         cluster-reader
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"rbac.authorization.k8s.io/v1","kind":"ClusterRole","metadata":{"annotations":{},"name":"cluster-reader"},"rules":[{"apiGrou...
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods       []                 []              [get list watch]
###用rolebinding去绑定clusterrole,clusterrole只针对rolebinding所在的名称空间有效
[root@k8s-master rbac]# kubectl create rolebinding magedu-read-pods --clusterrole=cluster-reader --user=magedu --dry-run -o yaml > rolebinding-clusterrole.yaml
[root@k8s-master rbac]# vim rolebinding-clusterrole.yaml 
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: magedu-read-pods
  namespace: default 
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: magedu
[root@k8s-master rbac]# kubectl apply -f rolebinding-clusterrole.yaml 
rolebinding.rbac.authorization.k8s.io/magedu-read-pods created
[root@k8s-master rbac]# kubectl get rolebinding 
NAME               AGE
magedu-read-pods   4s
##集群角色讲解
[root@k8s-master rbac]# kubectl get clusterrole
NAME                                                                   AGE
admin                                                                  29d
cluster-admin                                                          29d
这两个角色是集群中的管理员角色。
[root@k8s-master rbac]# kubectl get clusterrolebinding
NAME                                                   AGE
cluster-admin                                          29d
这个clusterrolebinding就是k8s集群中最大权限用户kubernetes-admin的绑定组
[root@k8s-master rbac]# kubectl describe clusterrolebinding cluster-admin
Name:         cluster-admin
Labels:       kubernetes.io/bootstrapping=rbac-defaults
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
Role:
  Kind:  ClusterRole
  Name:  cluster-admin
Subjects:
  Kind   Name            Namespace
  ----   ----            ---------
  Group  system:masters    #这个角色绑定了system:masters这个组
[root@k8s-master rbac]# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
- context:
    cluster: kubernetes
    user: magedu
  name: magedu@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin  #这个用户就是绑定在system:masters这个组中的
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
- name: magedu
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
[root@k8s-master pki]# ls /etc/kubernetes/pki/
apiserver.crt                 ca.key                  magedu.crt
apiserver-etcd-client.crt     ca.srl                  magedu.csr
apiserver-etcd-client.key     etcd                    magedu.key
apiserver.key                 front-proxy-ca.crt      sa.key
apiserver-kubelet-client.crt  front-proxy-ca.key      sa.pub
apiserver-kubelet-client.key  front-proxy-client.crt
ca.crt                        front-proxy-client.key

[root@k8s-master pki]# openssl x509 -in apiserver-kubelet-client.crt -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 7812310351632908911 (0x6c6ae6df982fc26f)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=kubernetes
        Validity
            Not Before: Apr  6 10:19:09 2019 GMT
            Not After : Apr  5 10:19:10 2020 GMT
        Subject: O=system:masters, CN=kube-apiserver-kubelet-client #这个CN其实就是kubernetes-admin这个超级用户，这个用户的组是O=system:masters，只要我们创建用户并指定O=system:masters，那么我们创建的用户也具有超级管理员权限
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
	.....................

#第十七节：dashboard认证及分级授权
对APIServer（restful风格的api）的访问：
	subject(用户)-->action(操作)-->object(对象)
认证：token,tls(重点认证),user/password
	帐号：UserAccount(不需要单独创建，只需要用户自己宣称就行，但是要经过认证授权才行),ServiceAcount
授权：RBAC
	role,rolebinding #名称空间角色，及名称空间角色和群集角色绑定
	clusterrole,clusterrolebinding #集群角色，及集群角色绑定
	subject:user,group,serviceaccount #定义binding操作时可以使用的用户类型
	object:resource group,resource,non-resource url #对象类型
	action:get,list,watch,patch,delete,detelecollection #操作
####dashboard
参考链接：https://github.com/kubernetes/dashboard
1.部署 2.将service改为nodePort 3.认证时的帐号必须为serviceaccount,被dashboard pod拿来进行认证
#1. 部署dashboard:
[root@k8s-master ~]# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml #应用dashboard清单文件
secret/kubernetes-dashboard-certs created
serviceaccount/kubernetes-dashboard created
role.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard-minimal created
deployment.apps/kubernetes-dashboard created
service/kubernetes-dashboard created
[root@k8s-master ~]# kubectl get pods -n kube-system
NAME                                    READY   STATUS    RESTARTS   AGE
coredns-fb8b8dccf-2zlk6                 1/1     Running   2          29d
coredns-fb8b8dccf-brx94                 1/1     Running   2          29d
etcd-k8s-master                         1/1     Running   2          29d
kube-apiserver-k8s-master               1/1     Running   2          29d
kube-controller-manager-k8s-master      1/1     Running   2          29d
kube-flannel-ds-amd64-rfsd6             1/1     Running   3          29d
kube-flannel-ds-amd64-swsdg             1/1     Running   4          29d
kube-flannel-ds-amd64-x5s6p             1/1     Running   4          29d
kube-proxy-fxvqs                        1/1     Running   3          29d
kube-proxy-jwxzw                        1/1     Running   2          29d
kube-proxy-zf9ch                        1/1     Running   2          29d
kube-scheduler-k8s-master               1/1     Running   2          29d
kubernetes-dashboard-5f7b999d65-84w4v   1/1     Running   0          74s  #已经running状态了
[root@k8s-master ~]# kubectl get svc -n kube-system
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   29d
kubernetes-dashboard   ClusterIP   10.106.234.66   <none>        443/TCP                  8m21s
[root@k8s-master ~]# kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kube-system  #映射dashboard443接口使集群外部使用
service/kubernetes-dashboard patched
[root@k8s-master ~]# kubectl get svc -n kube-system
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   29d
kubernetes-dashboard   NodePort    10.106.234.66   <none>        443:32156/TCP            10m
访问：https://192.168.1.238:32156
#有两种认证方式：kubeconfig和token认证
#Token认证：
#default名称空间权限：
[root@k8s-master pki]# kubectl create serviceaccount jack -n default
serviceaccount/jack created
[root@k8s-master pki]# kubectl create rolebinding jack-admin --clusterrole=admin --serviceaccount=default:jack
rolebinding.rbac.authorization.k8s.io/jack-admin created
[root@k8s-master pki]# kubectl get secret 
NAME                    TYPE                                  DATA   AGE
admin-token-5v6z8       kubernetes.io/service-account-token   3      41h
default-token-lw499     kubernetes.io/service-account-token   3      29d
jack-token-n8dsx        kubernetes.io/service-account-token   3      87s
mysql-root-password     Opaque                                1      2d1h
tomcat-ingress-secret   kubernetes.io/tls                     2      7d17
[root@k8s-master pki]# kubectl describe secret jack-token-n8dsx 
Name:         jack-token-n8dsx
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: jack
              kubernetes.io/service-account.uid: 719ef9a2-6fcc-11e9-8f19-005056ad5cec

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImphY2stdG9rZW4tbjhkc3giLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamFjayIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjcxOWVmOWEyLTZmY2MtMTFlOS04ZjE5LTAwNTA1NmFkNWNlYyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmphY2sifQ.DrG8E19RiZiDBNHTKk3wMX8-lyrTCOS5QJWvgJXZHFn1XyYS_Dasn0FyxURsql_qk0zK6G43tgcHmzKACR0YnQXXJF8Ef9pg_IhzeVH35Zn4_FNMcTo9zpFjY5dvu_egnLfBVwt8TRmll4L9RTg39mJXhiU5WZPi6yL5FRUpQr-9_rWODnC4KpqllrS41dJC1n83xkBAzGROQ_aeBjNQdi9x0gUn3oiMCJktZvkSDmYjKjL8CwU1m0Gge8om5agRfYxk7V83bMLMFaR58UjhtR9k8QbJbAcmn5lT24ff9V3y-dwhOa8R1g0YQbbDxFVTJh5Blxy4wLcqVPOiMiI4SQ
#注：使用jack-token-n8dsx的token就可以访问default名称空间下的所有资源所有操作了

#整个集群权限：
#新建serviceaccount
[root@k8s-master pki]# kubectl create serviceaccount dashboard-admin -n kube-system #新建sa用户dashboard-admin
serviceaccount/dashboard-admin created
[root@k8s-master pki]# kubectl get sa -n kube-system dashboard-admin
NAME              SECRETS   AGE
dashboard-admin   1         15s
[root@k8s-master pki]# kubectl create clusterrolebinding dashboard-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin #把dashboard-admin这个sa帐户绑定在集群角色cluster-admin上，并新建名称叫dashboard-cluster-admin
clusterrolebinding.rbac.authorization.k8s.io/dashboard-cluster-admin created
[root@k8s-master pki]# kubectl get secrets -n kube-system
dashboard-admin-token-hg7ts                      kubernetes.io/service-account-token   3      5m8s  #这个dashboard-admin-token-hg7ts就是serviceaccount帐户dashboard-admin的token，使用describe命令可以看到token
[root@k8s-master pki]# kubectl describe secrets dashboard-admin-token-hg7ts -n kube-system
Name:         dashboard-admin-token-hg7ts
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: dashboard-admin
              kubernetes.io/service-account.uid: 48d73c4c-6fc7-11e9-8f19-005056ad5cec

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4taGc3dHMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNDhkNzNjNGMtNmZjNy0xMWU5LThmMTktMDA1MDU2YWQ1Y2VjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.ZtH4LLN2AhXMpY2X2eND4XX33eVJRyaEzLGoejj1pbotS3foz0iVDG3jCuvGJGsfiPqRbNhnFomFS_dExoDYFgXeTA_IegdkXhW-UUQ8hSRdw9-ICJJOPKLtP18tflYJpb670ZECVN9Soft1jWsMXTIO03IwPAxp_HetJXTtIXYxiyclJZ8o3I0d3DrI4e4WEdB3vI7Q_aHhcStjuz0iY8zlYqUPcbffMJKt3Y79GTDgI_BxOziwVDKk6o2Mv47gLePd5otM7RvMsxAuP1sP5RD6yiqspkMYqs5vzKrcZEdP-m4IiPdPjXKZy_dOOoZTgIXrFObDo12pYihgg  #这个就是token,使用token即可以认证dashboard了

#使用kubeconfig认证：
[root@k8s-master ~]# kubectl get secrets jack-token-n8dsx -o json
{
    "apiVersion": "v1",
    "data": {
        "ca.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EUXdOakV3TVRrd09Wb1hEVEk1TURRd016RXdNVGt3T1Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT3ZOCjVzTzVwVzZwS1RZN0RScWw2ZlJmOXZxSUZ6MlQ0VnhCM2lRb0Q0dzg3MFVpMUJneVNNMXVCQzFHWXAyRFBtTUkKNHc4N1p6TWdxM1p0ZUJhU3pGVnVCTGwxTmFpa2FZUG1SWXdYNzZSUlZjNzlSSmRIbnl4dElWd2JBanpnS25aMgorZWVNa2cwSFBYZnR3S2Z3a0M3R1pFZUtURDdXemhJU0NIVjR2cmx6aWJVUm5vRGRUSWJHbWJQdHFUeGw3RlA4Cm9PamZxTUlyUEJFaG9CczNRZ3NuOFk3SUZkM0prdTlmMWhnVUNseFluQmdZM2dLQXVtNnVXWVFvTURnZWdnN3EKU3JLU3drYVFTOU5Ea3Mwb0l0U3I1MGRkV3Z6NVA5elVtTDJyd3Buck5SRUVnc3RBTDE1RGFHK0pQaUNYdkxYQgpzaHl1NEZTZjBOQnl5NlVYUTljQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFLUzY1MVFYZW40YVBvVHB6VEZ2RXQxS1hMWHgKSUp5a004dncvb1hVWS9PQ3pYc29Ua09GWW9veVhGdUF0QmkzSy9GM1lIc1FlODA1QTI0OEJadFUrcEw2MGVwWgpqUFRjZUtjeU5PZk9IMzY1UVdBV2NkYlNjVWlQV3Ezd1NjNHRqUE1pZGwzbm5STDRWWVAwZ1NFQ21MY1A5b3NFCkkwRTU1TXR4Sk1QbC85YXZyUjNZbDlZYmkxWDFTUnh2RWFRNlJab0NFSWo2SlFaSDkyY0R6T0NOOWtXQ2JUM2EKMlViQk1WMHFSUTVqN1EvU1JoTmUwVWxkYTN2MDFvREtXMXc4VTVKOEE0V2hzempwb293eDVpQzVoeFZvVklsZAo3Wmh1WnNMQjBRUXNaTWxnNGhZb3AzM09hb05sM2xUODduOXNJOVlhTldYUEdiSzZRYm5kdXBuRmo4TT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "namespace": "ZGVmYXVsdA==",
        "token": "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklpSjkuZXlKcGMzTWlPaUpyZFdKbGNtNWxkR1Z6TDNObGNuWnBZMlZoWTJOdmRXNTBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5dVlXMWxjM0JoWTJVaU9pSmtaV1poZFd4MElpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WldOeVpYUXVibUZ0WlNJNkltcGhZMnN0ZEc5clpXNHRiamhrYzNnaUxDSnJkV0psY201bGRHVnpMbWx2TDNObGNuWnBZMlZoWTJOdmRXNTBMM05sY25acFkyVXRZV05qYjNWdWRDNXVZVzFsSWpvaWFtRmpheUlzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJamN4T1dWbU9XRXlMVFptWTJNdE1URmxPUzA0WmpFNUxUQXdOVEExTm1Ga05XTmxZeUlzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21waFkyc2lmUS5Eckc4RTE5UmlaaURCTkhUS2szd01YOC1seXJUQ09TNVFKV3ZnSlhaSEZuMVh5WVNfRGFzbjBGeXhVUnNxbF9xazB6SzZHNDN0Z2NIbXpLQUNSMFluUVhYSkY4RWY5cGdfSWh6ZVZIMzVabjRfRk5NY1RvOXpwRmpZNWR2dV9lZ25MZkJWd3Q4VFJtbGw0TDlSVGczOW1KWGhpVTVXWlBpNnlMNUZSVXBRci05X3JXT0RuQzRLcHFsbHJTNDFkSkMxbjgzeGtCQXpHUk9RX2FlQmpOUWRpOXgwZ1VuM29pTUNKa3RadmtTRG1ZaktqTDhDd1UxbTBHZ2U4b201YWdSZll4azdWODNiTUxNRmFSNThVamh0UjlrOFFiSmJBY21uNWxUMjRmZjlWM3ktZHdoT2E4UjFnMFlRYmJEeEZWVEpoNUJseHk0d0xjcVZQT2lNaUk0U1E="
    },
    "kind": "Secret",
    "metadata": {
        "annotations": {
            "kubernetes.io/service-account.name": "jack",
            "kubernetes.io/service-account.uid": "719ef9a2-6fcc-11e9-8f19-005056ad5cec"
        },
        "creationTimestamp": "2019-05-06T06:59:08Z",
        "name": "jack-token-n8dsx",
        "namespace": "default",
        "resourceVersion": "3701307",
        "selfLink": "/api/v1/namespaces/default/secrets/jack-token-n8dsx",
        "uid": "71a0e98e-6fcc-11e9-8f19-005056ad5cec"
    },
    "type": "kubernetes.io/service-account-token"
}
[root@k8s-master ~]# kubectl get secrets jack-token-n8dsx -o jsonpath={.data.token} #截取json文件的token指定路径内容
ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklpSjkuZXlKcGMzTWlPaUpyZFdKbGNtNWxkR1Z6TDNObGNuWnBZMlZoWTJOdmRXNTBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5dVlXMWxjM0JoWTJVaU9pSmtaV1poZFd4MElpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WldOeVpYUXVibUZ0WlNJNkltcGhZMnN0ZEc5clpXNHRiamhrYzNnaUxDSnJkV0psY201bGRHVnpMbWx2TDNObGNuWnBZMlZoWTJOdmRXNTBMM05sY25acFkyVXRZV05qYjNWdWRDNXVZVzFsSWpvaWFtRmpheUlzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJamN4T1dWbU9XRXlMVFptWTJNdE1URmxPUzA0WmpFNUxUQXdOVEExTm1Ga05XTmxZeUlzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21waFkyc2lmUS5Eckc4RTE5UmlaaURCTkhUS2szd01YOC1seXJUQ09TNVFKV3ZnSlhaSEZuMVh5WVNfRGFzbjBGeXhVUnNxbF9xazB6SzZHNDN0Z2NIbXpLQUNSMFluUVhYSkY4RWY5cGdfSWh6ZVZIMzVabjRfRk5NY1RvOXpwRmpZNWR2dV9lZ25MZkJWd3Q4VFJtbGw0TDlSVGczOW1KWGhpVTVXWlBpNnlMNUZSVXBRci05X3JXT0RuQzRLcHFsbHJTNDFkSkMxbjgzeGtCQXpHUk9RX2FlQmpOUWRpOXgwZ1VuM29pTUNKa3RadmtTRG1ZaktqTDhDd1UxbTBHZ2U4b201YWdSZll4azdWODNiTUxNRmFSNThVamh0UjlrOFFiSmJBY21uNWxUMjRmZjlWM3ktZHdoT2E4UjFnMFlRYmJEeEZWVEpoNUJseHk0d0xjcVZQT2lNaUk0U1E=
[root@k8s-master ~]# DEF_NS_ADMIN_TOKEN=$(kubectl get secrets jack-token-n8dsx -o jsonpath={.data.token} | base64 -d) #用base64解
码token并保存在变量DEF_NS_ADMIN_TOKEN
#新建kubeconfig文件
[root@k8s-master ~]# kubectl config set-cluster kubernetes --server="https://192.168.1.238:6443" --certificate-authority=/etc/kubernetes/pki/ca.crt --kubeconfig=/root/def-ns-admin.conf#设置集群到文件/root/def-ns-admin.conf
Cluster "kubernetes" set.
[root@k8s-master ~]# kubectl config set-credentials def-ns-admin --token=$DEF_NS_ADMIN_TOKEN --kubeconfig=/root/def-ns-admin.conf ##设置用户的token到文件/root/def-ns-admin.conf 
User "def-ns-admin" set.
[root@k8s-master ~]# kubectl config set-context def-ns-admin@kubernetes --cluster=kubernetes --user=def-ns-admin --kubeconfig=/root/def-ns-admin.conf  #设置上下文绑定集群和用户关系
Context "def-ns-admin@kubernetes" created.
[root@k8s-master ~]# kubectl config view --kubeconfig=/root/def-ns-admin.conf  #查看绑定关系
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://192.168.1.238:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: def-ns-admin
  name: def-ns-admin@kubernetes
current-context: ""
kind: Config
preferences: {}
users:
- name: def-ns-admin
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImphY2stdG9rZW4tbjhkc3giLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamFjayIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjcxOWVmOWEyLTZmY2MtMTFlOS04ZjE5LTAwNTA1NmFkNWNlYyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmphY2sifQ.DrG8E19RiZiDBNHTKk3wMX8-lyrTCOS5QJWvgJXZHFn1XyYS_Dasn0FyxURsql_qk0zK6G43tgcHmzKACR0YnQXXJF8Ef9pg_IhzeVH35Zn4_FNMcTo9zpFjY5dvu_egnLfBVwt8TRmll4L9RTg39mJXhiU5WZPi6yL5FRUpQr-9_rWODnC4KpqllrS41dJC1n83xkBAzGROQ_aeBjNQdi9x0gUn3oiMCJktZvkSDmYjKjL8CwU1m0Gge8om5agRfYxk7V83bMLMFaR58UjhtR9k8QbJbAcmn5lT24ff9V3y-dwhOa8R1g0YQbbDxFVTJh5Blxy4wLcqVPOiMiI4SQ
[root@k8s-master ~]# kubectl config use-context def-ns-admin@kubernetes --kubeconfig=/root/def-ns-admin.conf  #切换上下文用户
Switched to context "def-ns-admin@kubernetes".
然后把root/def-ns-admin.conf 这个文件导出来即可使用kubeconfig登录认证了


###使用k8s的CA为dashboard签署证书用于部署dashboard
[root@k8s-master pki]# (umask 077;openssl genrsa -out dashboard.key 2048) #为dashboard生成私钥
Generating RSA private key, 2048 bit long modulus
.......+++
..........+++
e is 65537 (0x10001)
[root@k8s-master pki]# openssl req -new -key dashboard.key -out #为dashboard生成证书申请请求，用户名叫ui.magedu.com,以后的网站名也叫ui.magedu.com，属于用户组magedu   dashboard.csr -subj "/O=magedu/CN=ui.magedu.com"
[root@k8s-master pki]# openssl x509 -req -in dashboard.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dashboard.crt -days 365 #用k8sca签署dashboard的证书申请请求
Signature ok
subject=/O=magedu/CN=ui.magedu.com
Getting CA Private Key
[root@k8s-master pki]# kubectl create secret generic dashboard-cert -n kube-system --from-file=dashboard.crt=./dashboard.crt --from-file=dashboard.key=dashboard.key  #为dashboard的公钥和私钥生成一个generic类型的secret。因为由于在dashboard内部使用的，所以类型应该是generic而不是tls类型
secret/dashboard-cert created
[root@k8s-master pki]# kubectl get secrets dashboard-cert -n kube-system
NAME             TYPE     DATA   AGE
dashboard-cert   Opaque   2      2m51s  #opaque类型就是generic类型的


##k8s集群的管理方式：
	1. 命令式：create,run,delete,expose,edit....
	2. 命令式配置文件:create -f filename,delete -f ,replace -f
	3. 声明式配置文件:apply -f ,patch
注：一般建议不要混合使用，至少1和2可以混合使用，3不能一起使用


#第十八节：配置网络插件flanner







</pre>