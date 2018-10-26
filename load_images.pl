#!/bin/perl
use 5.010;

my %images_hash = (
	
	"kube-apiserver-amd64:v1.11.0"	=>	"k8s.gcr.io/",
	"kube-scheduler-amd64:v1.11.0"	=>	"k8s.gcr.io/",
	"kube-proxy-amd64:v1.11.0"	=>	"k8s.gcr.io/",
	"kube-controller-manager-amd64:v1.11.0"	=>	"k8s.gcr.io/",
	"coredns:1.1.3"	=>	"k8s.gcr.io/",
	"etcd:v3.3.8"	=>	"quay.io/coreos/",
	"kubernetes-dashboard-amd64:v1.8.3"	=>	"k8s.gcr.io/",
	"k8s-dns-sidecar-amd64:1.14.8"	=>	"k8s.gcr.io/",
	"k8s-dns-kube-dns-amd64:1.14.8"	=>	"k8s.gcr.io/",
	"k8s-dns-dnsmasq-nanny-amd64:1.14.8"	=>	"k8s.gcr.io/",
	"pause:3.1"	=>	"k8s.gcr.io/",

	"etcd-amd64:3.2.18"	=>	"k8s.gcr.io/",
	"keepalived:1.4.5"	=>	"osixia/",
	"flannel:v0.10.0-amd64"	=>	"quay.io/coreos/",
	"haproxy:1.7-alpine"	=>	"",
	"heapster-influxdb-amd64:v1.3.3"	=>	"k8s.gcr.io/",
	"heapster-grafana-amd64:v4.4.3"	=>	"k8s.gcr.io/",
	"heapster-amd64:v1.4.2"	=>	"k8s.gcr.io/",
);

sub invoke_local_command{
	my $command = shift;
	say "pull image~: [$command]";
	my $exec_result = `$command`;
	say "pull result~: [$command] [$exec_result]";
	chomp($exec_result);
	return $exec_result;
}

sub pull_from_docker_hub{
	while (my ($imageName, $imageSource) = each %images_hash) {
		invoke_local_command("docker pull limengyu1990/$imageName");
		invoke_local_command("docker tag limengyu1990/$imageName $imageSource$imageName");
		invoke_local_command("docker rmi limengyu1990/$imageName");
	}
}
pull_from_docker_hub();