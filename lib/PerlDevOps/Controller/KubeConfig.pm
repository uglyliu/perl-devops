package PerlDevOps::Controller::KubeConfig;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;
use Expect;
use File::Basename;


#perl install dir
my $perl_install_dir = "/usr/local";

my $bin = "$perl_install_dir/bin";

my $root_dir = "/root/perl-devops";
my $tmp_dir = "$root_dir/tmp";
my $work_static_dir = "$root_dir/static";

my $ca_dir = "$work_static_dir/ca";
my $service_dir = "$work_static_dir/service";
my $kubelet_dir = "$work_static_dir/kubelet";

#k8s install log，the frontend will read log content by websocket
my $log_file = "$tmp_dir/k8s-install.log";

#shoud be config by config file
my $default_user = "root";
my $default_pwd = "root";
my $vip_nic_prefix = "vip_nic";
my $pki_dir = "$work_static_dir/pki";
my $tmp_host_route_ip = {};
my $log = Mojo::Log->new(path => "$log_file");
my $default_docker_hub = "limengyu1990";
my $default_retry_time_flag = 0;

sub index{
	my $self = shift;
	$self->render(); 
}

sub configPage{
	my $self = shift;
	#kubeConfig => $self->kubeConfig->find()
  	$self->render(kubeConfig => {});
}

sub config{
	 my $self = shift;
	 my $v = $self->_validation;
	 return $self->redirect_to("/k8s") if $v->has_error;
	
	 my $param = $v->output;
     my $id = $self->param('id');
     my $deploy = $self->param('deploy');
     if($deploy){
     	 say "the k8s cluster have deploy....";
     	 $self->redirect_to('/k8s');
     }
	 if(!$id){
	 	 $param -> {createDate} = localtime();
	 	 $param -> {createUser} = "admin";
	 	 my $id = $self->app->kubeConfig->add($param);
	 }else{
	 	 $param -> {updateDate} = localtime();
	 	 $param -> {updateUser} = "admin";
	 	 $self->app->kubeConfig->save($id, $param);
	 }
	 save_kube_cluster($self,$param -> {kubeName},$param -> {masterAddress},$param -> {nodeAddress});
	 $self->redirect_to('/k8s');
}

sub save_kube_cluster{
	my ($self,$kubeName,$masterAddress,$nodeAddress) = @_;

	 #clear & save
	 $self->app->kubeCluster->remove_by_cluster($kubeName);

	 my $master_ip_array = parse_ips($masterAddress);
	 foreach my $master_ip (@$master_ip_array){
	 	 my $id = $self->app->kubeConfig->add("{\"ip\":\"$master_ip\",\"type\":1,\"ssh\":0,\"cluster\":\"$kubeName\",\"user\":\"root\",\"password\":\"root\",\"port\":22}");
	 }

	 my $node_ip_array = parse_ips($nodeAddress);
	 foreach my $node_ip (@$node_ip_array){
	 	 my $id = $self->app->kubeConfig->add("{\"ip\":\"$node_ip\",\"type\":1,\"ssh\":0,\"cluster\":\"$kubeName\",\"user\":\"root\",\"password\":\"root\",\"port\":22}");
	 }

}

sub _validation {
  	my $self = shift;

  	my $v = $self->validation;
	$v->required('kubeName');
	$v->required('kubeVersion');
	$v->required('kubeCniVersion');
	$v->required('etcdVersion');
	$v->required('dockerVersion');
	$v->required('netMode');
	$v->required('clusterIP');
	$v->required('serviceClusterIP');
	$v->required('dnsIP');
	$v->required('dnsDN');
	$v->required('apiVIP');
	$v->required('ingressVIP');
	$v->required('sshUser');
	$v->required('sshPort');
	$v->required('masterAddress');
	$v->required('masterHostName');
	$v->required('nodeHostName');
	$v->required('etcdAddress');
	$v->required('yamlDir');
	$v->required('nodePort');
	# $v->required('kubeToken');
	$v->required('loadBalance');
	$v->required('kubeDesc');
	$v->required('keepalivedAddress');
	$v->required('deploy');
  	return $v;
}

#config info check before install
sub install_check{
	my ($self,$k8s_id) = @_;
	my $kubeConfig = $self->app->kubeConfig->find($k8s_id);
	return $kubeConfig;
}

sub install{
	my $self = shift;
	my $kubeConfig = install_check($self,$self->param("id"));
	my $cluster_node_array = $self->app->kubeCluster->find_cluster_no_config_ssh($kubeConfig->{"kubeName"});
	#start install job
	$self->app->minion->enqueue(install_k8s_task => [$kubeConfig,$cluster_node_array] );
	#$self->app->minion->perform_jobs;
	my $worker = $self->app->minion->worker;
	$worker->run;
	$self->render();
}

sub print_hash{
	my ($hash,$desc) = @_;
	say "print $desc: ";
	while (my ($k, $v) = each %$hash ) {
	   say "\t\t $k ======== $v";
	}
}

sub install_k8s_task{
	my($job,@args) = @_;
	my $kubeConfig = $args[0];
	#all cluster node
	my $cluster_node_array = $args[1];
	my $master_prefix = $kubeConfig->{"masterHostName"};
	my $node_prefix = $kubeConfig->{"nodeHostName"};

	my $etcd_default_port = $kubeConfig->{"etcd_default_port"};

	my $haproxy_default_port = $kubeConfig->{"haproxy_default_port"};

	my %cluster_ip_host_hash = map { 
		$_ -> {"ip"} , 
		$_ -> {'type'} eq "master" ? $master_prefix.$_ -> {'id'} : $node_prefix.$_ -> {'id'}
	} @$cluster_node_array;

	my @master_node_array = grep $_ -> {"type"} eq "master" , @$cluster_node_array;

	my @node_array = grep $_ -> {"type"} eq "node" , @$cluster_node_array;

	my %master_ip_host_hash =  map { 
		$_ -> {"ip"} , 
		$master_prefix.$_ -> {'id'}
	} @master_node_array;

	my %node_ip_host_hash =  map { 
		$_ -> {"ip"} , 
		$node_prefix.$_ -> {'id'}
	} @node_array;

	my @all_ip_array = keys %cluster_ip_host_hash;
	my @all_host_array = values %cluster_ip_host_hash;

	my $all_ip_str = array2str(\@all_ip_array);
	my $all_host_str = array2str(\@all_host_array);
	
	my @master_ip_array = keys %master_ip_host_hash;
	my $master_ip_str = array2str(\@master_ip_array);

	my @master_host_array = values %master_ip_host_hash;
	my $master_host_str = array2str(\@master_host_array);

	my @node_ip_array = keys %node_ip_host_hash;
	my $node_ip_str = array2str(\@node_ip_array);

	print_hash(\%cluster_ip_host_hash,"all cluster node");
	print_hash(\%master_ip_host_hash,"all master node");
	print_hash(\%node_ip_host_hash,"all node");

	#0、stop all container
	#stop($all_ip_str);
	#1、config ssh login
	ssh_login($default_user,$default_pwd,$all_ip_str);

	#2、all node config hostname
	update_host_config(\%cluster_ip_host_hash,$master_prefix,$node_prefix);
	
	#2.1、config hostname login
	ssh_login($default_user,$default_pwd,$all_host_str);
	
	#3、all node update os config
	update_sys_config($all_ip_str);
	
	#4、all node install docker v17.03
	#install_docker($all_ip_str);
	#4、pull images
	#pull_master_images($master_ip_str);
	# my $id = $self->app->minion->enqueue(pull_master_images => [$master_ip_str] );
	# say "队列任务===========>$id";
	# my $worker = $self->app->minion->worker;
	# $worker->run;
	#5、all node install kubernetes
	#download_kubernetes($all_ip_str,$master_ip_str,$kubeConfig,0);
	#install_kubernetes($all_ip_str,$master_ip_str,\@master_ip_array,\%master_ip_host_hash,$kubeConfig);
	#6、master node install component
	my $kube_api_ip = $kubeConfig->{"kube_api_ip"}; 
	my $k8s_dir = $kubeConfig->{"kube_dir"}; 
	install_component(\%master_ip_host_hash,$k8s_dir,$etcd_default_port,$haproxy_default_port,$kube_api_ip);
	#7、config k8s cluster enable service
	#config_enable_start($master_ip_str,$all_ip_str);
	$log->info("finish install k8s cluster");
}

sub stop{
	my $all_ip_str = shift;
	invoke_sys_command("systemctl stop kubelet.service",$all_ip_str);
	invoke_sys_command("docker stop \\\$(docker ps -a -q)",$all_ip_str);
	invoke_sys_command("docker rm \\\$(docker ps -a -q)",$all_ip_str);
}

sub log{
	my $self = shift;
	say "========websocket have connection==========";
	$self->on(message => sub {
		my ($self, $msg) = @_;
		$self->send("echo: $msg");
	});
}

#parse ip to array
#ips=192.18.10.14.[0-9] 192.18.10.130 192.18.10.12.[0-3]
sub parse_ips{
	my $ips = shift;
	#$ips =~ s/,/ /g;
	my $parse_command = "$perl_install_dir/bin/fornodes $ips";
	my $parse_result = `$parse_command`;
	my @parse_array = split(/\s+/,$parse_result);
	return \@parse_array;
}


#split $array by $flag,default by space
sub array2str{
	my ($array,$flag) = @_;
	if (ref($array) eq 'ARRAY') {
		if (!$flag) {
			$flag = " ";
		}
		return join($flag,@$array);
	}
}

sub replace_str{
	my $ip_str_space = shift;
	$ip_str_space =~ s/\s/,/g;
	return $ip_str_space;
}

#config user ssh secret key login
#$ipstr: ip str by space separated
sub ssh_login{
	my ($user,$passwd,$ipstr) = @_;
	
	my $ssh_command = "su - $user -c \"$perl_install_dir/bin/key2nodes -u $user $ipstr\"";	
	$log->info("----------- start ssh secret key login config ----------");
	$log->info("will exec command: [$ssh_command]");
	
	my $obj = Expect->spawn($ssh_command) or $log->error("Couldn't exec command: [$ssh_command]");
	$log->info("will Permanently added [$user] [$ipstr] (ECDSA) to the list of known hosts.");
	my ($pos, $err, $match, $before, $after) = $obj->expect(60,
			[ qr#Enter passphrase#i,
			  sub{ my $self = shift; $self->send("\r"); exp_continue;}
			],
			[ qr#Enter same passphrase again#i,
			  sub{ my $self = shift; $self->send("\r"); exp_continue;}
			],
			[ qr#want to continue connecting#i,
			  sub{ my $self = shift; $self->send("yes\r"); exp_continue;}
			],
			[ qr/Password:/i,
			  sub{ my $self = shift; $self->send("$passwd\r"); exp_continue;}
			]
	);
	$obj->soft_close();
	$log->info("------------ finish ssh secret key login config  -----");
}

sub builder_ip_host_name_hash{
	my ($ip_hostname_hash,$ip_array,$k8s_prefix) = @_;
	foreach my $ip (@$ip_array) {
		$ip_hostname_hash->{$ip} = $k8s_prefix.$ip;
	}
}

# config ip-hostname map
sub update_host_config{
	my ($ip_hostname_hash,$master_prefix,$node_prefix) = @_;

	$log->info("--------------start config hosts and hostname！--------------");

	#init ip-hostname map

	my $all_ip_list = [keys %$ip_hostname_hash];

	while (my ($ip, $hostname) = each %$ip_hostname_hash) {
		#1、clear config file：/etc/hosts and /etc/sysconfig/network
		invoke_sys_command("/bin/sed -i \"/k8s/d\" /etc/hosts;/bin/sed -i \"/k8s/d\" /etc/hosts;/bin/sed -i \"/HOSTNAME=/d\" /etc/sysconfig/network;",$ip);
		#2、update hostname 
		invoke_sys_command("/bin/echo \"HOSTNAME=$hostname\" >> /etc/sysconfig/network;/bin/hostname $hostname",$ip);
	}
	foreach my $item (@$all_ip_list) {
		#3、update ip-hostname
		$log->info("...start config《 $item 》hosts...");
		while (my ($k, $v) = each %$ip_hostname_hash) {
			invoke_sys_command("/bin/echo  $k               $v  >> /etc/hosts",$item);
		}
		$log->info("...finish config《 $item 》hosts...");
	}
	#4、flush config file
	invoke_sys_command("service network restart;",array2str($all_ip_list));
	$log->info("--------------finish config hosts and hostname！--------------");
}

#updage os config
sub update_sys_config{
	my $all_ip_str = shift;

	$log->info("--------------start update os config--------------");

	#disable firewalld & selinux
	invoke_sys_command("systemctl stop firewalld && systemctl disable firewalld",$all_ip_str);
	invoke_sys_command("/bin/sed -i \"s/SELINUX=permissive/SELINUX=disabled/\" /etc/sysconfig/selinux",$all_ip_str);
	invoke_sys_command("setenforce 0",$all_ip_str);

	#load ipvs 
	#lsmod | grep ip_vs
	invoke_sys_command("modprobe ip_vs",$all_ip_str);
	invoke_sys_command("modprobe ip_vs_rr",$all_ip_str);
	invoke_sys_command("modprobe ip_vs_wrr",$all_ip_str);
	invoke_sys_command("modprobe ip_vs_sh",$all_ip_str);
	invoke_sys_command("modprobe nf_conntrack_ipv4",$all_ip_str);
	upload_file_to_node("$work_static_dir/k8s-ipvs.conf","/etc/modules-load.d/",0,$all_ip_str);

	#disable swap
	invoke_sys_command("swapoff -a && sysctl -w vm.swappiness=0",$all_ip_str);
	invoke_sys_command("/bin/sed -i \"/swap.img/d\" /etc/fstab",$all_ip_str);
	#Redhat
	#invoke_sys_command("/bin/sed -i \"s/\/dev\/mapper\/rhel-swap/\#\/dev\/mapper\/rhel-swap/g\" /etc/fstab",$all_ip_str);
	#Centos
	invoke_sys_command('/bin/sed -i \"s/^\/dev\/mapper\/centos-swap/#&/g\" /etc/fstab',$all_ip_str);
	invoke_sys_command("mount -a",$all_ip_str);
	#open forward, Docker v1.13
	invoke_sys_command("iptables -P FORWARD ACCEPT",$all_ip_str);

	$log->info("--------------finish update os config--------------");
}

# install docker
sub install_docker{
	my $all_ip_str = shift;
	$log->info("--------------start install Docker--------------");
	invoke_sys_command("systemctl stop docker && systemctl disable docker",$all_ip_str);
	#1、install last edition
	#invoke_sys_command("curl -fsSL https://get.docker.com/ | sh",$all_ip_str);

	#2、install specified version 
	# invoke_sys_command("yum remove -y docker-ce docker-ce-selinux container-selinux",$all_ip_str);
	# invoke_sys_command("yum install -y yum-utils device-mapper-persistent-data lvm2",$all_ip_str);
	# invoke_sys_command("yum-config-manager --enable extras",$all_ip_str);
	# invoke_sys_command("sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",$ip_str);
	# invoke_sys_command("yum-config-manager --enable docker-ce-edge",$all_ip_str);
	# invoke_sys_command("yum makecache fast",$all_ip_str);
	# invoke_sys_command("yum install -y --setopt=obsoletes=0 docker-ce-17.03.1.ce-1.el7.centos docker-ce-selinux-17.03.1.ce-1.el7.centos",$ip_str);
	
	#3、install by rpm package
	unless (-e "$tmp_dir/docker-ce.rpm") {
		invoke_local_command("curl https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.3.ce-1.el7.x86_64.rpm -o $tmp_dir/docker-ce.rpm --progress");
		invoke_local_command("curl https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm -o $tmp_dir/docker-ce-selinux.rpm --progress");
	}
	#upload file to remote nodes
	upload_file_to_node("$tmp_dir/docker-ce.rpm","/tmp",0,$all_ip_str);
	upload_file_to_node("$tmp_dir/docker-ce-selinux.rpm","/tmp",0,$all_ip_str);
	#install docker
	invoke_sys_command("yum -y localinstall /tmp/docker-ce*.rpm",$all_ip_str);
	#config daemon.json
	upload_file_to_node("$work_static_dir/daemon.json","/etc/docker",0,$all_ip_str);
	#https://www.daocloud.io/mirror
	invoke_sys_command("curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io",$all_ip_str);
	#direct-lvm config
	#https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#configure-direct-lvm-mode-for-production
	#start docker
	invoke_sys_command("systemctl daemon-reload && systemctl restart docker && systemctl enable docker",$all_ip_str);
	invoke_sys_command("ps -ef | grep docker",$all_ip_str);
    #config system net bridge
    upload_file_to_node("$work_static_dir/k8s.conf","/etc/sysctl.d",0,$all_ip_str);
	invoke_sys_command("sysctl -p /etc/sysctl.d/k8s.conf",$all_ip_str);
	$log->info("--------------finish install Docker--------------");
	#todo check & ensure all node have install docker
}

#download kubernetes resources
#no_override = 0 means again download
sub download_kubernetes{
	my ($all_ip_str,$master_ip_str,$no_override) = @_;
	$log->info("-------------- start download k8s file --------------");
	unless (-e "$tmp_dir/kubelet" && $no_override) {
		$log->info("-------------- start download kubelet --------------");
		invoke_local_command("curl -s https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubelet -o $tmp_dir/kubelet");
	}
	#master node must install kubectl
	unless (-e "$tmp_dir/kubectl" && $no_override) {
		$log->info("-------------- start download kubectl --------------");
		invoke_local_command("curl -s https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl -o $tmp_dir/kubectl");
	}
	unless (-e "$tmp_dir/cni-plugins-amd64-v0.7.1.tgz" && $no_override) {
		$log->info("-------------- start download cni-plugins-amd64-v0.7.1.tgz --------------");
		invoke_local_command("curl -s https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz -o $tmp_dir/cni-plugins-amd64-v0.7.1.tgz");
	}
	invoke_local_command("rm -rf $bin/cfssl*");
	invoke_local_command("curl -s -L -o $bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64");
	invoke_local_command("curl -s -L -o $bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64");
	invoke_local_command("curl -s -L -o $bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64");
	invoke_local_command("chmod +x $bin/cfssl*");
	#upload kubelet to all node & chmod +x /usr/local/bin/kubelet
	upload_file_to_node("$tmp_dir/kubelet","/usr/local/bin/",0,$all_ip_str);
	invoke_sys_command("chmod +x /usr/local/bin/kubelet",$all_ip_str);
	
	#upload kubectl to all master node & chmod +x /usr/local/bin/kubectl
	upload_file_to_node("$tmp_dir/kubectl","/usr/local/bin/",0,$master_ip_str);
	invoke_sys_command("chmod +x /usr/local/bin/kubectl",$master_ip_str);
	
	#upload CNI to all node & unpack
	upload_file_to_node("$tmp_dir/cni-plugins-amd64-v0.7.1.tgz","/opt/cni/bin",1,$all_ip_str);
	
	#m1 node need intall cfssl,use for create CA and TLS
	

	$log->info("-------------- finish download k8s file --------------");
}

sub install_kubernetes{
	my ($all_ip_str,$master_ip_str,$master_ip_array,$master_ip_host_hash,$kubeConfig) = @_;
	$log->info("--------------start config k8s CA --------------");

	#clear old config
	invoke_sys_command("rm -rf /etc/etcd/ssl/* /etc/kubernetes/*",$all_ip_str);

	#config etcd CA
	my $etcd_ca_dir = $kubeConfig->{"etcd_ca_dir"}; 
	invoke_local_command("mkdir -p $etcd_ca_dir");
	invoke_local_command("cfssl gencert -initca $pki_dir/etcd-ca-csr.json | cfssljson -bare $etcd_ca_dir/etcd-ca");
	my $current_master_ip_str = replace_str($master_ip_str);
	invoke_local_command("cfssl gencert -ca=$etcd_ca_dir/etcd-ca.pem -ca-key=$etcd_ca_dir/etcd-ca-key.pem -config=$pki_dir/ca-config.json -hostname=127.0.0.1,$current_master_ip_str -profile=kubernetes $pki_dir/etcd-csr.json | cfssljson -bare $etcd_ca_dir/etcd");
	my @etcd_file = qw(etcd-ca-key.pem etcd-ca.pem etcd-key.pem etcd.pem);
	check_file(\@etcd_file,$etcd_ca_dir);
	$log->info("will delete temp file [$etcd_ca_dir/*.csr]");
	invoke_local_command("rm -rf $etcd_ca_dir/*.csr");
	##scp all master node
	upload_file_to_node("$etcd_ca_dir/etcd*pem","$etcd_ca_dir",0,$master_ip_str);
	
	#config kubernetes CA
	my $k8s_dir = $kubeConfig->{"kube_dir"}; 
	my $cluster_ip = $kubeConfig->{"clusterIP"}; 
	my $kube_api_ip = $kubeConfig->{"kube_api_ip"}; 
	my $kube_api_port = $kubeConfig->{"kube_api_port"} // "6443";
	my $master_host_name = $kubeConfig->{"masterHostName"};
	#api vip
	my $kube_api_server = "https://$kube_api_ip:$kube_api_port";
	my $k8s_ca_dir = "$k8s_dir/pki"; 
	invoke_local_command("mkdir -p $k8s_ca_dir");
	invoke_local_command("cfssl gencert -initca $pki_dir/ca-csr.json | cfssljson -bare $k8s_ca_dir/ca");
	my @api_vip_file = qw(ca-key.pem ca.pem);
	check_file(\@api_vip_file,$k8s_ca_dir);
	##create TLS for Kubernetes API Server
	##kubernetes.default: is service domain name by k8s auto create on default namespace
	$log->info("...........create TLS for Kubernetes API Server...........");
	invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/ca.pem -ca-key=$k8s_ca_dir/ca-key.pem -config=$pki_dir/ca-config.json -hostname=$cluster_ip,$kube_api_ip,127.0.0.1,kubernetes.default -profile=kubernetes $pki_dir/apiserver-csr.json | cfssljson -bare $k8s_ca_dir/apiserver");
	my @api_server_file = qw(apiserver-key.pem apiserver.pem);
	check_file(\@api_server_file,$k8s_ca_dir);

	## config Authenticating Proxy CA and CN
	invoke_local_command("cfssl gencert -initca $pki_dir/front-proxy-ca-csr.json | cfssljson -bare $k8s_ca_dir/front-proxy-ca");
	my @proxy_file = qw(front-proxy-ca-key.pem front-proxy-ca.pem);
	check_file(\@proxy_file,$k8s_ca_dir);

	invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/front-proxy-ca.pem -ca-key=$k8s_ca_dir/front-proxy-ca-key.pem -config=$pki_dir/ca-config.json -profile=kubernetes $pki_dir/front-proxy-client-csr.json | cfssljson -bare $k8s_ca_dir/front-proxy-client");
  	my @front_proxy_file = qw(front-proxy-client-key.pem front-proxy-client.pem);
	check_file(\@front_proxy_file,$k8s_ca_dir);

	## config Controller Manager CN
	invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/ca.pem -ca-key=$k8s_ca_dir/ca-key.pem -config=$pki_dir/ca-config.json -profile=kubernetes $pki_dir/manager-csr.json | cfssljson -bare $k8s_ca_dir/controller-manager");
  	my @controller_file = qw(controller-manager-key.pem controller-manager.pem);
	check_file(\@controller_file,$k8s_ca_dir);
	
	###config kubeconfig
	invoke_local_command("kubectl config set-cluster kubernetes --certificate-authority=$k8s_ca_dir/ca.pem --embed-certs=true --server=$kube_api_server --kubeconfig=$k8s_dir/controller-manager.conf");
	
	invoke_local_command("kubectl config set-credentials system:kube-controller-manager --client-certificate=$k8s_ca_dir/controller-manager.pem --client-key=$k8s_ca_dir/controller-manager-key.pem --embed-certs=true --kubeconfig=$k8s_dir/controller-manager.conf");
	
	invoke_local_command("kubectl config set-context system:kube-controller-manager\@kubernetes --cluster=kubernetes --user=system:kube-controller-manager --kubeconfig=$k8s_dir/controller-manager.conf");

    invoke_local_command("kubectl config use-context system:kube-controller-manager\@kubernetes --kubeconfig=$k8s_dir/controller-manager.conf");

    #config Scheduler CA and CN
    invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/ca.pem -ca-key=$k8s_ca_dir/ca-key.pem -config=$pki_dir/ca-config.json -profile=kubernetes $pki_dir/scheduler-csr.json | cfssljson -bare $k8s_ca_dir/scheduler");
  	my @schedule_file = qw(scheduler-key.pem scheduler.pem);
    check_file(\@schedule_file,$k8s_ca_dir);
    ## config Scheduler's kubeconfig
    invoke_local_command("kubectl config set-cluster kubernetes --certificate-authority=$k8s_ca_dir/ca.pem --embed-certs=true --server=$kube_api_server --kubeconfig=$k8s_dir/scheduler.conf");
    invoke_local_command("kubectl config set-credentials system:kube-scheduler --client-certificate=$k8s_ca_dir/scheduler.pem --client-key=$k8s_ca_dir/scheduler-key.pem --embed-certs=true --kubeconfig=$k8s_dir/scheduler.conf");
    invoke_local_command("kubectl config set-context system:kube-scheduler\@kubernetes --cluster=kubernetes --user=system:kube-scheduler --kubeconfig=$k8s_dir/scheduler.conf");
    invoke_local_command("kubectl config use-context system:kube-scheduler\@kubernetes --kubeconfig=$k8s_dir/scheduler.conf");
    #config  Kubernetes Admin' CN 
    invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/ca.pem -ca-key=$k8s_ca_dir/ca-key.pem -config=$pki_dir/ca-config.json -profile=kubernetes $pki_dir/admin-csr.json | cfssljson -bare $k8s_ca_dir/admin");
  	my @admin_file = qw(admin-key.pem admin.pem);
	check_file(\@admin_file,$k8s_ca_dir);
    ## create Admin' kubeconfig 
    invoke_local_command("kubectl config set-cluster kubernetes --certificate-authority=$k8s_ca_dir/ca.pem --embed-certs=true --server=$kube_api_server --kubeconfig=$k8s_dir/admin.conf");
    invoke_local_command("kubectl config set-credentials kubernetes-admin --client-certificate=$k8s_ca_dir/admin.pem --client-key=$k8s_ca_dir/admin-key.pem --embed-certs=true --kubeconfig=$k8s_dir/admin.conf");
    invoke_local_command("kubectl config set-context kubernetes-admin\@kubernetes --cluster=kubernetes --user=kubernetes-admin --kubeconfig=$k8s_dir/admin.conf");
    invoke_local_command("kubectl config use-context kubernetes-admin\@kubernetes --kubeconfig=$k8s_dir/admin.conf");

    # config Masters Kubelet, create kubelet CN for all masters node
    foreach my $m_ip (@$master_ip_array){
    	my $master = $master_host_name.$m_ip;
    	invoke_local_command("/bin/cp -rfn $pki_dir/kubelet-csr.json $pki_dir/kubelet-$master-csr.json");
    	invoke_local_command("/bin/sed -i \"s/\\\$NODE/$master/g\" $pki_dir/kubelet-$master-csr.json");
    	invoke_local_command("cfssl gencert -ca=$k8s_ca_dir/ca.pem -ca-key=$k8s_ca_dir/ca-key.pem -config=$pki_dir/ca-config.json -hostname=$master -profile=kubernetes $pki_dir/kubelet-$master-csr.json | cfssljson -bare $k8s_ca_dir/kubelet-$master");
      	#clear tmp file
      	$log->warn("will delete temp file: [$pki_dir/kubelet-$master-csr.json]");
      	invoke_local_command("rm -rf $pki_dir/kubelet-$master-csr.json");
    }
    ## check files
    foreach my $m_ip (@$master_ip_array){
    	my $master = $master_host_name.$m_ip;
    	my @master_file = ("kubelet-$master-key.pem","kubelet-$master.pem");
		check_file(\@master_file, $k8s_ca_dir);
    }
    ### upload kubelet CN to all master node
    foreach my $m_ip (@$master_ip_array){
      my $master = $master_host_name.$m_ip;
      upload_file_to_node("$k8s_ca_dir/ca.pem","$k8s_ca_dir",0,$m_ip);
      upload_file_to_node("$k8s_ca_dir/kubelet-$master-key.pem","$k8s_ca_dir/kubelet-key.pem",0,$m_ip);
      upload_file_to_node("$k8s_ca_dir/kubelet-$master.pem","$k8s_ca_dir/kubelet.pem",0,$m_ip);
      #
      $log->warn("will delete temp file: [$k8s_ca_dir/kubelet-$master-key.pem] [$k8s_ca_dir/kubelet-$master.pem]");
      invoke_local_command("rm -rf $k8s_ca_dir/kubelet-$master-key.pem $k8s_ca_dir/kubelet-$master.pem");
    }
     
    #create kubeconfig for all master node by kubectl 
    foreach my $m_ip (@$master_ip_array){
      my $master = $master_host_name.$m_ip;
      invoke_sys_command("cd $k8s_ca_dir && kubectl config set-cluster kubernetes --certificate-authority=$k8s_ca_dir/ca.pem --embed-certs=true --server=$kube_api_server --kubeconfig=$k8s_dir/kubelet.conf && kubectl config set-credentials system:node:$master --client-certificate=$k8s_ca_dir/kubelet.pem --client-key=$k8s_ca_dir/kubelet-key.pem --embed-certs=true --kubeconfig=$k8s_dir/kubelet.conf && kubectl config set-context system:node:$master\@kubernetes --cluster=kubernetes --user=system:node:$master --kubeconfig=$k8s_dir/kubelet.conf && kubectl config use-context system:node:$master\@kubernetes --kubeconfig=$k8s_dir/kubelet.conf",$m_ip);
    }

    #Service Account Key
    invoke_local_command("openssl genrsa -out $k8s_ca_dir/sa.key 2048");
    invoke_local_command("openssl rsa -in $k8s_ca_dir/sa.key -pubout -out $k8s_ca_dir/sa.pub");
    my @account_key_file = qw(sa.key sa.pub);
    check_file(\@account_key_file, $k8s_ca_dir);
    

    #delete all no useful files
    $log->info("will delete temp file [$k8s_ca_dir/*.csr]");
    invoke_local_command("rm -rf $k8s_ca_dir/*.csr");
   
    #scp CNs to all master node
	upload_file_to_node("$k8s_ca_dir/front-proxy-*.pem","$k8s_ca_dir",0,$master_ip_str);
	upload_file_to_node("$k8s_ca_dir/sa.*","$k8s_ca_dir",0,$master_ip_str);
	upload_file_to_node("$k8s_ca_dir/ca-key.pem","$k8s_ca_dir",0,$master_ip_str);
	upload_file_to_node("$k8s_ca_dir/apiserver*pem","$k8s_ca_dir",0,$master_ip_str);


 	$log->info("will agine test dir file list......");
    invoke_sys_command("ls $k8s_ca_dir/",$master_ip_str);
    $log->info("finish agine test dir file list......");

  	#scp kubeconfig to all master node
  	upload_file_to_node("$k8s_dir/admin.conf","$k8s_dir",0,$master_ip_str);
  	upload_file_to_node("$k8s_dir/controller-manager.conf","$k8s_dir",0,$master_ip_str);
  	upload_file_to_node("$k8s_dir/scheduler.conf","$k8s_dir",0,$master_ip_str);

  	
    #
	$log->info("-------------- finish config k8s CA --------------");
}

sub install_component{
	my ($master_ip_host_hash,$k8s_dir,$etcd_default_port,$haproxy_default_port,$kube_api_ip) = @_;
	my $if_get_route = 0;
	my @master_ip_array = keys %$master_ip_host_hash;
	my @master_host_array = values %$master_ip_host_hash;
	my $master_host_str = array2str(\@master_host_array);
	my $master_ip_str = array2str(\@master_ip_array);
	#clear old config file
	invoke_sys_command("systemctl stop kubelet.service && systemctl disbale kubelet.service",$master_ip_str);
	invoke_sys_command("rm -rf /etc/etcd/config.yml /etc/haproxy/*",$master_ip_str);
	invoke_sys_command("rm -rf /etc/kubernetes/manifests/* /etc/kubernetes/encryption/* /etc/kubernetes/audit/*",$master_ip_str);
	invoke_sys_command("rm -rf /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /lib/systemd/system/kubelet.service /etc/systemd/system/kubelet.service.d",$master_ip_str);
	#
	invoke_sys_command("mkdir -p /etc/etcd /etc/haproxy /etc/kubernetes/manifests /etc/kubernetes/encryption /etc/kubernetes/audit",$master_ip_str);
	#check generate file /etc/etcd/config.yml、/etc/haproxy/haproxy.cfg
	get_ip_route($master_ip_host_hash,$if_get_route);
	print_hash($tmp_host_route_ip,"route-ip-host-2");
	
	generate_etcd_haproxy_config($master_ip_host_hash,$etcd_default_port,$haproxy_default_port);

	#generate Static pod YAML & EncryptionConfig
	#check generate file /etc/kubernetes/manifests、/etc/kubernetes/encryption、/etc/kubernetes/audit
	generate_manifests_config($master_ip_host_hash,$k8s_dir,$kube_api_ip,$etcd_default_port,$haproxy_default_port);
	# invoke_local_command("export NODES=\"$master_host_str\";export ADVERTISE_VIP=\"$kube_api_ip\";cd $k8s_manual_files;echo \$ADVERTISE_VIP;echo \$NODES;./hack/gen-manifests.sh");
	##update /etc/kubernetes/manifests/kube-apiserver.yml set '–insecure-port=8080'
	invoke_sys_command("perl -pi -e 's/insecure-port=0/insecure-port=8080/gi' /etc/kubernetes/manifests/kube-apiserver.yml",$master_ip_str);
	#config k8s component
	invoke_sys_command("mkdir -p /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /etc/systemd/system/kubelet.service.d",$master_ip_str);
	upload_file_to_node("$kubelet_dir/config.yml","/var/lib/kubelet/",0,$master_ip_str);
	upload_file_to_node("$kubelet_dir/10-kubelet.conf","/etc/systemd/system/kubelet.service.d/",0,$master_ip_str);
	upload_file_to_node("$kubelet_dir/kubelet.service","/lib/systemd/system/",0,$master_ip_str);
	#
	invoke_sys_command("/bin/cp -fn /etc/kubernetes/admin.conf ~/",$master_ip_str);
	invoke_sys_command("chown \$(id -u):\$(id -g) \$HOME/admin.conf",$master_ip_str);
	invoke_sys_command("/bin/sed -i \"/KUBECONFIG/d\" \$HOME/.bash_profile",$master_ip_str);
	invoke_sys_command('/bin/sed -i \"/PATH=/i KUBECONFIG=~/admin.conf\" ~/.bash_profile ',$master_ip_str);
	invoke_sys_command("source ~/.bash_profile",$master_ip_str);
	invoke_sys_command("export KUBECONFIG=\$HOME/admin.conf",$master_ip_str);
	
	# #start kubelet
	invoke_sys_command("systemctl start kubelet.service",$master_ip_str);

	#$log->debug("......watch netstat -ntlp......");
	#invoke_local_command("watch netstat -ntlp");
}

sub get_ip_route{
	my ($master_ip_host_hash,$if_get_route) = @_;
	while (my ($ip, $host) = each %$master_ip_host_hash) {
		my $ip_route = invoke_sys_command("ip route get 8.8.8.8",$ip);
		$ip_route =~ m/:\s+(.*)/g;
		my $data = $1 // "";
		my @router = split(/\s/,$data);
		if($if_get_route){
			$tmp_host_route_ip->{$master_ip_host_hash->{$ip}} = $router[6];
		}else{
			$tmp_host_route_ip->{$master_ip_host_hash->{$ip}} = $ip;
		}
		$tmp_host_route_ip->{"$vip_nic_prefix-$ip"} = $router[4];
	}	
}

sub generate_etcd_haproxy_config{
	my ($master_ip_host_hash,$etcd_default_port,$haproxy_default_port) = @_;
	#todo etcd_port = 2380
	my $etcd_port = 2380;
	my $haproxy_port = $haproxy_default_port // 6443;

	my @master_ip_array = keys %$master_ip_host_hash;
	
	my $etcd_cluster = join (",",map {
		"$master_ip_host_hash->{$_}=https:\\\/\\\/$tmp_host_route_ip->{$master_ip_host_hash->{$_}}:$etcd_port"	
	} @master_ip_array);
	$log->debug("\$etcd_cluster ============> $etcd_cluster");
	my $haproxy_backends = join ("\n",map {
		"    server $master_ip_host_hash->{$_}-api $tmp_host_route_ip->{$master_ip_host_hash->{$_}}:$haproxy_port check"
	} @master_ip_array);
	$log->debug("\$haproxy_backends ============> $haproxy_backends");
	while (my ($ip, $host) = each %$master_ip_host_hash) {
	   my $public_ip = $tmp_host_route_ip -> {$host} // $ip;
	   #edit etcd's config.yml
	   $log->debug("==============handler etcd=======================");
	   invoke_local_command("/bin/cp -rfn $work_static_dir/conf/config.yml /etc/etcd/config-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${HOSTNAME}/$host/g\" /etc/etcd/config-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${PUBLIC_IP}/$public_ip/g\" /etc/etcd/config-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ETCD_SERVERS}/$etcd_cluster/g\" /etc/etcd/config-$ip.yml");
	   #upload etcd's config.xml template file to all etcd nodes
	   upload_file_to_node("/etc/etcd/config-$ip.yml","/etc/etcd/config.yml",0,$ip);
	   invoke_local_command("rm -rf /etc/etcd/config-$ip.yml");
	   $log->debug("==============handler haproxy====================");
	   #edit haproxy's haproxy.cfg
	   invoke_local_command("/bin/cp -fn $work_static_dir/conf/haproxy.cfg /etc/haproxy/haproxy-$ip.cfg");
	   invoke_local_command("perl -pi -e 's#\\\${API_SERVERS}#$haproxy_backends#g' /etc/haproxy/haproxy-$ip.cfg");
	   #upload haproxy's haproxy.cfg template file to all haproxy nodes
	   upload_file_to_node("/etc/haproxy/haproxy-$ip.cfg","/etc/haproxy/haproxy.cfg",0,$ip);
	   invoke_local_command("rm -rf /etc/haproxy/haproxy-$ip.cfg");
	}
}

sub generate_manifests_config{
	my ($master_ip_host_hash,$k8s_dir,$default_advertise_vip,$etcd_default_port,$haproxy_default_port) = @_;
	my $haproxy_port = $haproxy_default_port // 6443;
	my @master_ip_array = keys %$master_ip_host_hash;
	#todo etcd_port = 2379
	my $etcd_port = 2379;
	my $manifests_dir = $k8s_dir."/manifests";
	my $encryption_dir = $k8s_dir."/encryption";
	my $audit_dir = $k8s_dir."/audit";
	my $advertise_vip = $default_advertise_vip // "172.22.132.9";

	my $etcd_cluster = join (",",map {
		"https:\\\/\\\/$tmp_host_route_ip->{$master_ip_host_hash->{$_}}:$etcd_port"	
	} @master_ip_array);
	$log->debug("\$etcd_cluster ==============> $etcd_cluster");
	my $unicast_peers = join(",", values %$tmp_host_route_ip);
	$log->debug("\$unicast_peers ==============> $unicast_peers");
	my $encrypt_secret = invoke_local_command("openssl rand -hex 16");
	my @manifests_file_list = qw(etcd.yml haproxy.yml kube-controller-manager.yml kube-scheduler.yml);
	my $i = 1;
	my $priority = 100;
	while (my ($ip, $host) = each %$master_ip_host_hash) {

  	   my $vip_nic = $tmp_host_route_ip->{"$vip_nic_prefix-$ip"};

	   foreach my $manifests_file (@manifests_file_list){
 			upload_file_to_node("$work_static_dir/manifests/$manifests_file","$manifests_dir/",0,$ip);
	   }
	   #edit & upload keepalived.yml
	   invoke_local_command("/bin/cp -fn $work_static_dir/manifests/keepalived.yml $tmp_dir/keepalived-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ADVERTISE_VIP}/$advertise_vip/g\" $tmp_dir/keepalived-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ADVERTISE_VIP_NIC}/$vip_nic/g\" $tmp_dir/keepalived-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${UNICAST_PEERS}/$unicast_peers/g\" $tmp_dir/keepalived-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${PRIORITY}/$priority/g\" $tmp_dir/keepalived-$ip.yml");
	   upload_file_to_node("$tmp_dir/keepalived-$ip.yml","$manifests_dir/keepalived.yml",0,$ip);
	   invoke_local_command("rm -rf $tmp_dir/keepalived-$ip.yml");

	   #edit & upload kube-apiserver.yml
	   invoke_local_command("/bin/cp -fn $work_static_dir/manifests/kube-apiserver.yml $tmp_dir/kube-apiserver-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ADVERTISE_VIP}/$advertise_vip/g\" $tmp_dir/kube-apiserver-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ETCD_SERVERS}/$etcd_cluster/g\" $tmp_dir/kube-apiserver-$ip.yml");
	   upload_file_to_node("$tmp_dir/kube-apiserver-$ip.yml","$manifests_dir/kube-apiserver.yml",0,$ip);
	   invoke_local_command("rm -rf $tmp_dir/kube-apiserver-$ip.yml");

	   #edit & upload config.yml
	   invoke_local_command("/bin/cp -fn $work_static_dir/encryption/config.yml $tmp_dir/config-$ip.yml");
	   invoke_local_command("/bin/sed -i \"s/\\\${ENCRYPT_SECRET}/$encrypt_secret/g\" $tmp_dir/config-$ip.yml");
	   upload_file_to_node("$tmp_dir/config-$ip.yml","$encryption_dir/config.yml",0,$ip);
	   invoke_local_command("rm -rf $tmp_dir/config-$ip.yml");
	  
	   #edit & upload policy.yml
	   upload_file_to_node("$work_static_dir/audit/policy.yml","$audit_dir/",0,$ip);

	   if($i){
			$i = 0;
			$priority = 150;
	   }
	}
}

sub config_enable_start{
	my ($master_ip_str,$all_ip_str) = @_;
	$log->info("config enable service autostart ----->  etcd & kubelet");
	invoke_sys_command("systemctl disabel etcd",$master_ip_str);	
	invoke_sys_command("systemctl disabel kubelet.service",$master_ip_str);
	invoke_sys_command("systemctl enable etcd",$master_ip_str);	
	invoke_sys_command("systemctl enable kubelet.service",$master_ip_str);
}

#check if the $file_dir/$file_list file exists
sub check_file{
	my ($file_list,$file_dir) = @_;
	$log->info("check file exist [$file_dir] [".join("\t",@$file_list)."]");
	foreach my $fileName (@$file_list){
		unless (-e "$file_dir/$fileName") {
			$log->error("check_file error........ $file_dir/$fileName not exist .....$fileName");
		}
	}
}

#invoke local command
sub invoke_local_command{
	my $command = shift;
	my $exec_result = `$command`;
	$log->info("local~: [$command] [$exec_result]");
	chomp($exec_result);
	return $exec_result;
}

#use for invoke remote system command
sub invoke_sys_command{
	my ($command,$ip_str) = @_;
	my $exec_command = "su - $default_user -c 'atnodes -L -u $default_user \"$command\" \"$ip_str\"'";
	$log->info("remote: [$exec_command]");
	my $exec_result = `$exec_command`;
	$log->info("remote: [$exec_command] [$exec_result]");
	chomp($exec_result);
	return $exec_result;
}

#upload file to node dir
# $full_name: current file full path filename: /root/perl-devops/static/tomcat.tar
# $targetdir: will upload targetNode pathName: /opt/tomcat
sub upload_file_to_node{
	my($full_name,$targetdir,$ispack,$ipstr) = @_;
	#get fileName
	my $filename = basename($full_name);

	my $real_target_dir = $targetdir;

	my $tmp_file = substr($targetdir,rindex($targetdir,"/")+1,length($targetdir));
	if($tmp_file =~ m/\./){
		$real_target_dir = dirname($targetdir);
	}
	#create remote host targetdir
	invoke_sys_command("mkdir -p $real_target_dir;",$ipstr);
	
	#exec upload file
	my $upload_command = "su - $default_user -c \"$perl_install_dir/bin/tonodes -L $full_name -u $default_user -- $ipstr:$targetdir\"";

	my $exec_result = `$upload_command`;
	$log->info("upload: [$upload_command] [$exec_result]");
	# ispack
	if ($ispack) {
		if($tmp_file =~ m/\./){
			invoke_sys_command("/bin/tar -xzvf $targetdir -C $real_target_dir/;",$ipstr);
		}else{
			invoke_sys_command("/bin/tar -xzvf $targetdir/$filename -C $targetdir/;",$ipstr);
		}
		$log->info("finish exec unpack command");
	}
	$log->info("upload file,then select file.....");
	#invoke_sys_command("ls $real_target_dir",$ipstr);
}

sub pull_master_images{
	my $master_ip_str = shift;
	$log->info("--------------start pull_master_images--------------");

	upload_file_to_node("$root_dir/pull_master_images.sh","/tmp",0,$master_ip_str);
	invoke_sys_command("chmod +x /tmp/pull_master_images.sh && sh /tmp/pull_master_images.sh",$master_ip_str);

	my %master_images_hash = (
		"kube-proxy-amd64:v1.11.0"	=>	"k8s.gcr.io/",
		"kube-scheduler-amd64:v1.11.0"	=>	"k8s.gcr.io/",
		"kube-controller-manager-amd64:v1.11.0"	=>	"k8s.gcr.io/",
		"kube-apiserver-amd64:v1.11.0"	=>	"k8s.gcr.io/",
		"coredns:1.1.3"	=>	"k8s.gcr.io/",
		"kubernetes-dashboard-amd64:v1.8.3"	=>	"k8s.gcr.io/",
		"k8s-dns-sidecar-amd64:1.14.8"	=>	"k8s.gcr.io/",
		"k8s-dns-kube-dns-amd64:1.14.8"	=>	"k8s.gcr.io/",
		"k8s-dns-dnsmasq-nanny-amd64:1.14.8"	=>	"k8s.gcr.io/",
		"pause:3.1"	=>	"k8s.gcr.io/",
		"etcd:v3.3.8"	=>	"quay.io/coreos/",
		"keepalived:1.4.5"	=>	"osixia/",
		"flannel:v0.10.0-amd64"	=>	"quay.io/coreos/",
		"haproxy:1.7-alpine"	=>	""
	);
	my $not_exist_images_ip = check_docker_images(\%master_images_hash,$master_ip_str);

	if ($not_exist_images_ip) {
		if($default_retry_time_flag < 3){
			$default_retry_time_flag++;
			say "=====================>$not_exist_images_ip";
			pull_master_images($not_exist_images_ip);
		}else{
			return;
		}
	}
	$log->info("--------------start pull_node_images--------------");
	$default_retry_time_flag = 0;
	$log->info("--------------finish pull_master_images--------------");
}

sub pull_node_images{
	my $node_ip_str = shift;
	$log->info("--------------start pull_node_images--------------");

	upload_file_to_node("$root_dir/pull_node_images.sh","/tmp",0,$node_ip_str);
	invoke_sys_command("chmod +x /tmp/pull_node_images.sh && sh /tmp/pull_node_images.sh",$node_ip_str);

	my %node_images_hash = (
		"kube-proxy-amd64:v1.11.0"	=>	"k8s.gcr.io/",	
		"pause:3.1"	=>	"k8s.gcr.io/",
		"kubernetes-dashboard-amd64:v1.8.3"	=>	"k8s.gcr.io/",
		"heapster-influxdb-amd64:v1.3.3"	=>	"k8s.gcr.io/",
		"heapster-grafana-amd64:v4.4.3"	=>	"k8s.gcr.io/",
		"heapster-amd64:v1.4.2"	=>	"k8s.gcr.io/",
		"flannel:v0.10.0-amd64"	=>	"quay.io/coreos/",
	);
	my $not_exist_images_ip = check_docker_images(\%node_images_hash,$node_ip_str);

	if ($not_exist_images_ip) {
		if($default_retry_time_flag < 3){
			$default_retry_time_flag++;
			say "=====================>$not_exist_images_ip";
			pull_node_images($not_exist_images_ip);
		}else{
			return;
		}
	}
	$default_retry_time_flag = 0;
	$log->info("--------------finish pull_node_images--------------");
}

# docker push limengyu1990/pause:3.1
sub push_docker_hub{
	my ($images,$hub_prefix,$ip_str) = @_;
	foreach my $imageName (@$images){
		invoke_sys_command("docker push $hub_prefix/$imageName",$ip_str);
	}
}

# docker pull limengyu1990/etcd:v3.3.8
# $hub_prefix = limengyu1990
# $target_prefix = quay.io/coreos
sub pull_docker_hub{
	my ($images_hash,$default_docker_hub,$ip_str) = @_;
	while (my ($imageName, $imageSource) = each %$images_hash) {
	  	invoke_sys_command("docker pull $default_docker_hub/$imageName",$ip_str);
		invoke_sys_command("docker tag $default_docker_hub/$imageName $imageSource$imageName",$ip_str);
		invoke_sys_command("docker rmi $default_docker_hub/$imageName",$ip_str);
	}
}

sub check_docker_images{
	my ($images_hash,$ip_str) = @_;
	my @ip_array = split(" ",$ip_str);
	my @not_exist_ip = ();
	foreach my $ip (@ip_array){
		my $result = invoke_sys_command("docker images",$ip);
		my $images_result = parse_docker_images($result);
		#print_hash($images_result,"$ip===========>images");
		while (my ($imageName, $imageSource) = each %$images_hash) {
			unless(exists $images_result->{"$imageSource$imageName"}){
				$log->error("docker image not exist[$ip]========>$imageSource$imageName");
				push(@not_exist_ip, $ip);
			}
		}
	}
	my $not_exist_ip_str = array2str(\@not_exist_ip);
	return $not_exist_ip_str;
}

sub parse_docker_images{
	my $result_line = shift;
	my %ip_image_name = ();
	my @lines = split(/\n/,$result_line);
	foreach my $line (@lines) {
		unless ($line !~ m/REPOSITORY/) {
			next;
		}
		unless ($line !~ m/=========/) {
			next;
		}
		my @current_line = split(" ",$line);
		$log->debug("~~~~~~~~~~~~~~~>$line");
		my $i_name = $current_line[2];
		my $i_source = $current_line[1];
		$ip_image_name{"$i_source:$i_name"}=$current_line[4];
	}
	return \%ip_image_name;
}

1;
