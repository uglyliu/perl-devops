package PerlDevOps::Controller::KubeConfig;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;
use Expect;
use File::Basename;


#perl install dir
my $perl_install_dir = "/usr/local";

#k8s install log，the frontend will read log content by websocket
my $log_file = "/root/perl-devops/k8s-install.log";

my $work_static_dir = "/root/perl-devops/static";

#shoud be config by config file
my $default_user = "root";
my $default_pwd = "root";

my $log = Mojo::Log->new(path => "$log_file");



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
	 if(!$id){
	 	 #new
	 	 $param -> {createDate} = localtime();
	 	 $param -> {createUser} = "admin";
	 	 my $id = $self->app->kubeConfig->add($param);
	 }else{
	 	 #update
	 	 $param -> {updateDate} = localtime();
	 	 $param -> {updateUser} = "admin";
	 	 $self->app->kubeConfig->save($id, $param);
	 }
	 $self->redirect_to('/k8s');
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
	#start install job
	$self->app->minion->enqueue(install_k8s_task => [$kubeConfig] );
	$self->app->minion->perform_jobs;
	$self->render();
}

sub install_k8s_task{
	my($job,@args) = @_;
	my $kubeConfig = $args[0];

	my $masterAddress = $kubeConfig->{"masterAddress"};
	my $nodeAddress = $kubeConfig->{"nodeAddress"};
	my $k8sPrefix = $kubeConfig->{"masterHostName"};

	#1、config ssh login
	my $all_ip_pair = $masterAddress." ".$nodeAddress;
	my $all_ip_array = parse_ips($all_ip_pair);
	my $all_ip_str = array2str($all_ip_array);
	#ssh_login($default_user,$default_pwd,$all_ip_str);

	#2、all node config hostname
	#update_host_config($masterAddress,$nodeAddress,$k8sPrefix);
	
	#3、all node update os config
	#update_sys_config($all_ip_str);
	
	#4、all node install docker v17.03
	#install_docker($all_ip_str);
	
	#5、all node install kubernetes
	install_kubernetes($all_ip_str);
	$log->info("finish install k8s: $all_ip_pair");
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

#config user ssh secret key login
#$ipstr: ip str by space separated
sub ssh_login{
	my ($user,$passwd,$ipstr) = @_;
	$log->info("will Permanently added [$user] [$ipstr] (ECDSA) to the list of known hosts.");

	my $ssh_command = "su - $user -c \"$perl_install_dir/bin/key2nodes -u $user $ipstr\"";
	
	$log->info("----------- start ssh secret key login config ----------");
	$log->info("will exec command: [$ssh_command]");
	
	my $obj = Expect->spawn($ssh_command) or $log->error("Couldn't exec command: [$ssh_command]");
	
	my ( $pos, $err, $match, $before, $after ) = $obj->expect(10,
			[ qr/Password:/i,
			  sub{ my $self = shift; $self->send("$passwd\r"); exp_continue;}
			]
	);
	$obj->soft_close( );
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
	my ($master_ip_str,$node_ip_str,$k8s_prefix) = @_;

	$log->info("--------------start config hosts and hostname！--------------");

	my $ip_hostname_hash = {};
	my $master_ip_array = parse_ips($master_ip_str);
	my $node_ip_array = parse_ips($node_ip_str);
	#init ip-hostname map
	builder_ip_host_name_hash($ip_hostname_hash,$master_ip_array,$k8s_prefix."m");
	builder_ip_host_name_hash($ip_hostname_hash,$node_ip_array,$k8s_prefix."n");

	my $all_ip_list = [keys %$ip_hostname_hash];

	while (my ($ip, $hostname) = each %$ip_hostname_hash) {
		#1、clear config file：/etc/hosts and /etc/sysconfig/network
		invoke_sys_command("/bin/sed -i \"/$k8s_prefix/d\" /etc/hosts;sed -i \"/HOSTNAME=/d\" /etc/sysconfig/network;",$ip);
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
	my $ip_str = shift;

	$log->info("--------------start update os config--------------");

	#disable firewalld & selinux
	invoke_sys_command("systemctl stop firewalld && systemctl disable firewalld",$ip_str);
	invoke_sys_command("/bin/sed -i \"s/SELINUX=permissive/SELINUX=disabled/\" /etc/sysconfig/selinux",$ip_str);
	invoke_sys_command("setenforce 0",$ip_str);

	#disable swap
	invoke_sys_command("swapoff -a && sysctl -w vm.swappiness=0",$ip_str);
	invoke_sys_command("/bin/sed -i \"/swap.img/d\" /etc/fstab",$ip_str);
	#Redhat
	#invoke_sys_command("/bin/sed -i \"s/\/dev\/mapper\/rhel-swap/\#\/dev\/mapper\/rhel-swap/g\" /etc/fstab",$ip_str);
	#Centos
	invoke_sys_command("/bin/sed -i \"s/\/dev\/mapper\/centos-swap/\#\/dev\/mapper\/centos-swap/g\" /etc/fstab",$ip_str);
	invoke_sys_command("mount -a",$ip_str);
	#open forward, Docker v1.13
	invoke_sys_command("iptables -P FORWARD ACCEPT",$ip_str);

	$log->info("--------------finish update os config--------------");
}

# install docker
sub install_docker{
	my $ip_str = shift;
	$log->info("--------------start install Docker--------------");
	#1、install last edition
	#invoke_sys_command("curl -fsSL https://get.docker.com/ | sh",$ip_str);

	#2、install specified version 
	# invoke_sys_command("yum remove -y docker-ce docker-ce-selinux container-selinux",$ip_str);
	# invoke_sys_command("yum install -y yum-utils device-mapper-persistent-data lvm2",$ip_str);
	# invoke_sys_command("yum-config-manager --enable extras",$ip_str);
	# invoke_sys_command("sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",$ip_str);
	# invoke_sys_command("yum-config-manager --enable docker-ce-edge",$ip_str);
	# invoke_sys_command("yum makecache fast",$ip_str);
	# invoke_sys_command("yum install -y --setopt=obsoletes=0 docker-ce-17.03.1.ce-1.el7.centos docker-ce-selinux-17.03.1.ce-1.el7.centos",$ip_str);
	
	#3、install by rpm package
	unless (-e "$work_static_dir/docker-ce.rpm") {
		invoke_local_command("curl https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.3.ce-1.el7.x86_64.rpm -o $work_static_dir/docker-ce.rpm --progress");
		invoke_local_command("curl https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm -o $work_static_dir/docker-ce-selinux.rpm --progress");
	}
	#upload file to remote nodes
	upload_file_to_node("$work_static_dir/docker-ce.rpm","/temp",0,$ip_str);
	upload_file_to_node("$work_static_dir/docker-ce-selinux.rpm","/temp",0,$ip_str);
	#install docker
	invoke_sys_command("yum -y localinstall /temp/docker-ce*.rpm",$ip_str);
	#config daemon.json
	upload_file_to_node("$work_static_dir/daemon.json","/etc/docker",0,$ip_str);
	#direct-lvm config
	#https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#configure-direct-lvm-mode-for-production
	#start docker
	invoke_sys_command("systemctl enable docker && systemctl restart docker",$ip_str);
	invoke_sys_command("ps -ef | grep docker",$ip_str);
    #config system net bridge
    upload_file_to_node("$work_static_dir/k8s.conf","/etc/sysctl.d",0,$ip_str);
	invoke_sys_command("sysctl -p /etc/sysctl.d/k8s.conf",$ip_str);
	$log->info("--------------finish install Docker--------------");
}

#install kubeadm、kubelet、kubectl
sub install_kubernetes{
	my ($all_ip_str,$master_ip_str) = @_;
	$log->info("-------------- start install Kubernetes --------------");
	unless (-e "$work_static_dir/kubelet") {
		invoke_local_command("curl https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubelet -o $work_static_dir/kubelet --progress");
	}
	#master node must install kubectl
	unless (-e "$work_static_dir/kubectl") {
		invoke_local_command("curl https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl -o $work_static_dir/kubectl --progress");
	}
	unless (-e "$work_static_dir/cni-plugins-amd64-v0.7.1.tgz") {
		invoke_local_command("curl https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz -o $work_static_dir/cni-plugins-amd64-v0.7.1.tgz --progress");
	}
	unless (-e "$work_static_dir/cfssl") {
		invoke_local_command("curl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o $work_static_dir/cfssl --progress");
	}
	unless (-e "$work_static_dir/cfssljson") {
		invoke_local_command("curl https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o $work_static_dir/cfssljson --progress");
	}

	#upload kubelet to all node & chmod +x /usr/local/bin/kubelet
	upload_file_to_node("$work_static_dir/kubelet","/usr/local/bin",0,$all_ip_str);
	invoke_sys_command("chmod +x /usr/local/bin/kubelet",$all_ip_str);
	
	#upload kubectl to all master node & chmod +x /usr/local/bin/kubectl
	upload_file_to_node("$work_static_dir/kubectl","/usr/local/bin",0,$master_ip_str);
	invoke_sys_command("chmod +x /usr/local/bin/kubectl",$master_ip_str);
	
	#upload CNI to all node & unpack
	upload_file_to_node("$work_static_dir/cni-plugins-amd64-v0.7.1.tgz","/opt/cni/bin",1,$all_ip_str);
	
	#m1 node need intall cfssl,use for create CA and TLS
	invoke_local_command("cp -n $work_static_dir/cfssl /usr/local/bin/");
	invoke_local_command("cp -n $work_static_dir/cfssljson /usr/local/bin/");
	invoke_local_command("chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson");

	$log->info("-------------- finish download k8s file, start config CA --------------");

	#download k8s-manual-files
	invoke_local_command("git clone https://github.com/kairen/k8s-manual-files.git ~/k8s-manual-files");

	invoke_local_command("mkdir -p /etc/etcd/ssl");
	invoke_local_command("cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare /etc/etcd/ssl/etcd-ca");

	$log->info("-------------- finish install Kubernetes --------------");
}

#invoke local command
sub invoke_local_command{
	my $command = shift;
	$log->info("start exec local command: [$command]");
	my $exec_result = `$command`;
	$log->info("finish exec local command: [$command] [$exec_result]");
}

#use for invoke system command
sub invoke_sys_command{
	my ($command,$ip_str) = @_;

	my $exec_command = "su - $default_user -c '\"$perl_install_dir\"/bin/atnodes -L -u $default_user \"$command\" \"$ip_str\"'";

	$log->info("start exec command: [$exec_command]");
	my $exec_result = `$exec_command`;
	$log->info("finish exec command: [$exec_command] [$exec_result]");
}

#upload file to node dir
# $full_name: current file full path filename: /root/perl-devops/static/tomcat.tar
# $targetdir: will upload targetNode pathName: /opt/tomcat
sub upload_file_to_node{
	my($full_name,$targetdir,$ispack,$ipstr) = @_;
	#get fileName
	my $filename = basename($full_name);
	#create remote host targetdir
	invoke_sys_command("mkdir -p $targetdir;",$ipstr);
	#exec upload file
	my $upload_command = "su - $default_user -c \"$perl_install_dir/bin/tonodes -L $full_name -u $default_user $ipstr:$targetdir/\"";

	$log->info("start exec upload file command: [$upload_command]");
	my $exec_result = `$upload_command`;
	$log->info("finish exec upload file command: [$upload_command] [$exec_result]");
	# ispack
	if ($ispack) {
		$log->info("start exec unpack command: [$upload_command]");
		invoke_sys_command("/bin/tar -xzvf $targetdir/$filename -C $targetdir/;",$ipstr);
		$log->info("start exec unpack command: [$upload_command]");
	}
}


#create CA
sub create_ca{

}




1;