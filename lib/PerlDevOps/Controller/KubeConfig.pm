package PerlDevOps::Controller::KubeConfig;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;
use Expect;


#perl install dir
my $perl_install_dir = "/usr/local";

#k8s install log，the frontend will read log content by websocket
my $log_file = "/root/perl-devops/k8s-install.log";

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
	 	 #新建
	 	 $param -> {createDate} = localtime();
	 	 $param -> {createUser} = "admin";
	 	 my $id = $self->app->kubeConfig->add($param);
	 }else{
	 	 #修改
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
	#启动job
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
	my $all_ip = $masterAddress." ".$nodeAddress;
	my $ipArray = parse_ips($all_ip);
	my $ssh_ip_str = array2str($ipArray);
	#ssh_login($default_user,$default_pwd,$ssh_ip_str);

	update_host_config($masterAddress,$nodeAddress,$k8sPrefix);
	#2、update os config
	
	#3、
	$log->info("finish install k8s: $all_ip");
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

	while (($ip, $hostname) = each %$ip_hostname_hash) {
		#1、clear config file：/etc/hosts and /etc/sysconfig/network
		my $clean_command = $perl_install_dir."/bin/atnodes -w -L -u $user \"/bin/sed -i \"/$k8s_prefix/d\" /etc/hosts;sed -i \"/HOSTNAME=/d\" /etc/sysconfig/network;\" $ip";
		invoke_sys_command($clean_command);
		#2、update hostname 
		my $hostname_command = $perl_install_dir."/bin/atnodes -w -L -u $user \"/bin/echo \"HOSTNAME=$hostname\" >> /etc/sysconfig/network;/bin/hostname $hostname\" $ip";
		invoke_sys_command($hostname_command);
	}
	foreach my $item (@$all_ip_list) {
		$log->info("...start config《 $item 》hosts...");		
		while (($k, $v) = each %$ips) {
			my $hosts_command = $perl_install_dir."/bin/atnodes -w -L -u $user \"/bin/echo  $k               $v  >> /etc/hosts \" $item";
			invoke_sys_command($hosts_command);
		}
		$log->info("...finish config《 $item 》hosts...");
	}
	#3、flush config file
	my $flush_command = $perl_install_dir."/bin/atnodes -w -L -u $user \"service network restart;\" $ip";
	invoke_sys_command($flush_command);
	$log->info("--------------finish config hosts and hostname！--------------");
}

#updage os config
sub update_sys_config{
	my $ip_str = shift;

	my $bin =  "su - $user -c $perl_install_dir/bin/atnodes -u $user";
	#disable firewalld & selinux
	invoke_sys_command("$bin \"systemctl stop firewalld && systemctl disable firewalld\" $ip_str");
	invoke_sys_command("$bin \"sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux\" $ip_str");
	invoke_sys_command("$bin \"setenforce 0\" $ip_str");

	#disable swap
	invoke_sys_command("$bin \"swapoff -a && sysctl -w vm.swappiness=0\" $ip_str");
	invoke_sys_command("$bin \"sed -i '/swap.img/d' /etc/fstab\" $ip_str");
}

# install docker
sub install_docker{


}

#config network forward param
sub config_net_forward_param{
	# cat <<EOF >  /etc/sysctl.d/k8s.conf
	# net.ipv4.ip_forward = 1
	# net.bridge.bridge-nf-call-ip6tables = 1
	# net.bridge.bridge-nf-call-iptables = 1
	# vm.swappiness=0
	# EOF
	# sysctl --system
}

#use for invoke system command
sub invoke_sys_command{
	my ($command,$desc)= @_;
	if($desc){
		log->info("~~~~~~~~~~~~~".$desc."~~~~~~~~~~~~~");	
	}
	$log->info("start exec command: [$command]");
	my $exec_result = `$command`;
	$log->info("finish exec command: [$command] [$exec_result]");
}

#create CA
sub create_ca{

}




1;