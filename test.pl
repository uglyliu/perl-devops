#!/usr/bin/perl


use 5.010;

my $work_static_dir = '/root/perl-devops/static';

sub install_calico{
	my $cluster_ip_cidr = shift;
	my $CALICO_IPV4POOL_CIDR = "192.168.0.0\\\/16";
	$cluster_ip_cidr =~ s#/#\\\/#g;
  invoke_local_command("rm -rf /$work_static_dir/cni/calico/v3.1/calico.yml");
  invoke_local_command("/bin/cp -fn $work_static_dir/cni/calico/v3.1/calico_template.yml  $work_static_dir/cni/calico/v3.1/calico.yml");
 invoke_local_command("/bin/sed -i \"s/$CALICO_IPV4POOL_CIDR/$cluster_ip_cidr/g\" $work_static_dir/cni/calico/v3.1/calico.yml");
 }

sub invoke_local_command{
	my $command = shift;
	my $exec_result = `$command`;
	chomp($exec_result);
	return $exec_result;
}

sub invoke_sys_command{
	my ($command,$ip_str) = @_;
	my $exec_command = "su - root -c 'atnodes -L -u root \"$command\" \"$ip_str\"'";
	my $exec_result = `$exec_command`;
	chomp($exec_result);
	say "执行结果：\n$exec_result";
	return $exec_result;
}


#install_calico("10.244.0.0/16");
sub print_hash{
	my ($hash,$desc) = @_;
	say "print $desc: ";
	while (my ($k, $v) = each %$hash ) {
	   say "\t\t $k ======== $v";
	}
}
my $tmp_host_route_ip = {};
my $tmp_ip_nic = {};
sub get_ip_route{
	my ($master_ip_host_hash,$if_get_route) = @_;
	while (my ($ip, $host) = each %$master_ip_host_hash) {
		my $ip_route = invoke_sys_command("ip route get 8.8.8.8",$ip);
		$ip_route =~ m/:\s+(.*)/g;
		my $data = $1 // "";
		say "解析结果：$data";
		my @router = split(/\s+/,$data);
		if($if_get_route){
			$tmp_host_route_ip->{$master_ip_host_hash->{$ip}} = $router[6];
		}else{
			$tmp_host_route_ip->{$master_ip_host_hash->{$ip}} = $ip;
		}
		$tmp_ip_nic->{"$ip"} = $router[4];
	}	
}
my %master_ip_host_hash = ("172.22.132.11","host1","172.22.132.12","host2");
get_ip_route(\%master_ip_host_hash,1);

print_hash($tmp_host_route_ip,"route-host-ip");
print_hash($tmp_ip_nic,"route-ip-nic");
