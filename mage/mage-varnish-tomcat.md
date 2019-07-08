#varnish详解并无实操
<pre>
#缓存类型：
公共缓存:缓存服务器，不能缓存cooking的
私有缓存：客户端缓存
把经常变动的cooking信息都会去掉的，来提高命中率的。
一般只能缓存GET操作，而且不能缓存GET操作中带有帐户和密码的信息。PUT,POST是不能缓存的
#CDN:内容颁发网络，结合智能DNS来判定客户端的来源，从而返回离用户最近的缓存服务器。 当子缓存服务器没有缓存结果则去父缓存服务器查找，无则去找原始服务器
公共智能DNS服务器：dnspod

Expire:绝对时间计时法
max-age:相对时间计时法
Cache-control:用于定义所有的缓存机制都必须遵循的缓存指示，这些指示是一些特定的指令，包括public,private,no-cache(表示可以缓存，每一次去询问服务端缓存是否有效)no-store,max-age,s-maxage,must-revalidate等，[当定义了Expire时，而又定义了Cache-Control：max-age时，则Cache-Control会覆盖Expire]
Etag:验证tag随机数是否发生变化的，有变化跟本地tag对比不一样则说明更新过，一样则说明未更新过，可以避免时间上的粗糙。
###著名的缓存服务器varnish
Squid:varnish好比httpd:nginx，前者宝刀未老，后者新贵，但受人追捧
一般使用Nginx+varnish 或者 Nginx+Squid
配置文件是编译后（通过VCL[varnish control language]）的二进制文件，被各子进程读取的





</pre>