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
install_calico("10.244.0.0/16");
