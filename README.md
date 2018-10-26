# perl-devops


![](img/index.png)
![](img/version.png)
![](img/assets.png)
![](img/k8s.png)

### 安装依赖 & 启动
```perl
$ cd /root/perl_devops && perl install.pl

$ morbo -l http://*:3000 -w ./ script/perl_dev_ops
```


### Kubernetes集群
```perl
部署k8s集群前，需要将各个服务器节点的root用户密码配置好(当前版本只支持root用户执行)

建议部署两个集群：
一个用于生产环境(pro)
一个用于测试环境，如果有多个测试环境，如dev、test、uat，可通过namespace实现


测试环境可以使用虚拟机来完成，Vagrantfile文件是VirtualBox虚拟机配置
```

#### 说明

##### static/kubelet
该目录中的文件会传输到各个master节点，用来配置自启动kubelet服务

##### static/ca
该目录中的文件用来生成各个组件的ca凭证

##### static/pki 
该目录中的文件用来生成各个组件的pki

##### static/manifests
该目录中的文件是各个组件的yaml配置文件

##### static/encryption
该目录中的文件是秘钥配置

##### static/audit
该目录中的文件是policy配置

##### static/conf
该目录中的文件是用来配置etcd和haproxy



程序会自动下载以下工具包到/root/perl-devops/tmp临时目录
```perl
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.3.ce-1.el7.x86_64.rpm (docker-ce.rpm)

https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm (docker-ce-selinux.rpm)  

https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubelet
https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl

https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz 

https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 (cfssl)
https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 (cfssljson)
https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 (cfssl-certinfo)

```

#### 生成的部分文件完整性检查
```perl
[/etc/etcd/ssl]		[etcd-ca-key.pem	etcd-ca.pem	etcd-key.pem	etcd.pem]
[/etc/kubernetes/pki]	[ca-key.pem	ca.pem]
[/etc/kubernetes/pki]	[apiserver-key.pem	apiserver.pem]
[/etc/kubernetes/pki]	[front-proxy-ca-key.pem	front-proxy-ca.pem]
[/etc/kubernetes/pki]	[front-proxy-client-key.pem	front-proxy-client.pem]
[/etc/kubernetes/pki]	[controller-manager-key.pem	controller-manager.pem]
[/etc/kubernetes/pki]	[scheduler-key.pem	scheduler.pem]
[/etc/kubernetes/pki]	[admin-key.pem	admin.pem]
[/etc/kubernetes/pki]	[kubelet-k8s-11.11.11.111-key.pem	kubelet-k8s-11.11.11.111.pem]
[/etc/kubernetes/pki]	[kubelet-k8s-11.11.11.112-key.pem	kubelet-k8s-11.11.11.112.pem]
[/etc/kubernetes/pki]	[kubelet-k8s-11.11.11.113-key.pem	kubelet-k8s-11.11.11.113.pem]
[/etc/kubernetes/pki]	[sa.key	sa.pub]
```

