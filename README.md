# perl-devops


![](img/index.png)
![](img/version.png)
![](img/assets.png)
![](img/k8s.png)

### 安装PostgreSQL
```shell
$ wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
$ rpm -ivh pgdg-centos10-10-2.noarch.rpm
$ yum install -y postgresql10-server postgresql10-contrib postgresql-devel

$ vim /etc/profile
  export POSTGRES_HOME=/usr/pgsql-10
$ source /etc/profile

$ mkdir /usr/pgsql-10/include

#支持远程客户端连接
$ vim /var/lib/pgsql/10/data/postgresql.conf
listen_addresses = '*'
#添加策略
$ vim /var/lib/pgsql/10/data/pg_hba.conf
host    all             all             远程ip/24       md5

$ systemctl restart postgresql-10.service
$ systemctl enable postgresql-10.service

#初始化数据库
$ cd /usr/pgsql-10/bin/
$ ./postgresql-10-setup initdb

$ su - postgres
psql
postgres=# alter user postgres with password '123456';
```

### 安装Perl依赖
```perl
$ sudo yum -y install perl-CPAN
$ curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious Mojo::Pg Minion Digest::MD5 Expect Compress::Raw::Zlib

$ morbo -l http://*:8080 -w ./ script/perl_dev_ops
```


### Kubernetes安装

1、建议安装2个k8s集群：
	a、一个用于生产环境(pro)b、一个用于测试环境，如果有多个测试环境，如dev、test、uat，则通过namespace实现





#mojo
https://kiwiirc.com/nextclient/#irc://irc.freenode.net/mojo?nick=guest-?
#历史数据
https://freenode.logbot.info/mojo/20180925

