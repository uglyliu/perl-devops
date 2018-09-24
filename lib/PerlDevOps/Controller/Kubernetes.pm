package PerlDevOps::Controller::Kubernetes;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;
use Expect;


#默认安装路径
my $perl_install_dir = "/usr/local";

#将来需要设置成自定义路径
my $log_file = "/root/perl-devops/k8s-install.log";

#将来需要设置成自定义用户名、密码
my $default_user = "root";
my $default_pwd = "root";

my $log = Mojo::Log->new(path => "$log_file");

#安装k8s任务
app->minion->add_task(install_k8s_task => \&install_8s_task);

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

sub status{


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



#安装前配置项检测
sub install_check{
	my ($self,$k8s_id) = @_;
	my $kubeConfig = $self->app->kubernetes->find($k8s_id);
	return $kubeConfig;
}

#安装etcd集群
sub install_etcd{

}

#安装
#1、配置免登录
#2、关闭系统配置
sub install{
	my $self = shift;
	my $kubeConfig = install_check($self,$self->param("id"));
	#启动job
	$self->minion->enqueue(install_k8s_task => $kubeConfig);
	$self->render();
｝

#具体安装逻辑
sub install_8s_task{
	 my($job,$kubeConfig) = @_;

	my $masterAddress = $kubeConfig->{"masterAddress"};
	my $nodeAddress = $kubeConfig->{"nodeAddress"};

	# my $ssh_ip_str = parse_ips($masterAddress+" "+$nodeAddress);
	# $log->info("准备配置SSH免密钥登录[$default_user]: $sshIP");
	# ssh_login($default_user,$default_pwd,$ssh_ip_str);


	$job->app->log->debug("完成安装: $masterAddress");
}


sub showLog{
	my $self = shift;
	say "==================";
	$log->info("-========================");
	$self->on(message => sub {
		my ($self, $msg) = @_;
		$self->send("echo: $msg");
	});
}

#解析ip集合，返回数组
#ips=192.18.10.14.[0-9] 192.18.10.130 192.18.10.12.[0-3]
sub parse_ips{
	my $ips = shift;
	#$ips =~ s/,/ /g;
	my $parse_command = "$perl_install_dir/bin/fornodes $ips";
	my $parse_result = `$parse_command`;
	my @parse_array = split(/\s+/,$parse_result);
	return \@parse_array;
}

#将数组$array转换成以$flag分割字符串
#默认以空格分割
sub array2str{
	my ($array,$flag) = @_;
	if (ref($array) eq 'ARRAY') {
		if (!$flag) {
			$flag = " ";
		}
		return join($flag,@$array);
	}
}

#配置某个用户的ssh互通
#$ipstr = 以空格分割ip字符串
sub ssh_login{
	
	my ($user,$passwd,$ipstr) = @_;
	
	my $ssh_command = "su - $user -c \"$perl_install_dir/bin/key2nodes -u $user $ipstr\"";
	
	$log->info("-------------- 开始批量配置 $user 用户的ssh无密码登录！--------------$ssh_command");
	
	my $obj = Expect->spawn($ssh_command) or $log->error("Couldn't exec command:$ssh_command.");
	
	my ( $pos, $err, $match, $before, $after ) = $obj->expect(10,
			[ qr/Password:/i,
			  sub{ my $self = shift; $self->send("$passwd\r"); exp_continue;}
			]
	);
	$obj->soft_close( );
	$log->info("--------------完成批量配置 $user 用户的ssh无密码登录！--------------");

}

#修改系统配置
sub update_sys_config{

}

#下载相应安装包
sub download_package{

}


#创建CA并产生凭证
sub create_ca{

}




1;