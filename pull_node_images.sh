#!/bin/bash
images=(kube-proxy-amd64:v1.11.0
kube-scheduler-amd64:v1.11.0
kube-controller-manager-amd64:v1.11.0
kube-apiserver-amd64:v1.11.0
etcd-amd64:3.2.18
coredns:1.1.3
pause-amd64:3.1
kubernetes-dashboard-amd64:v1.8.3
k8s-dns-sidecar-amd64:1.14.8
k8s-dns-kube-dns-amd64:1.14.8
k8s-dns-dnsmasq-nanny-amd64:1.14.8
heapster-influxdb-amd64:v1.3.3
heapster-grafana-amd64:v4.4.3
heapster-amd64:v1.4.2)
for imageName in ${images[@]}; do
 docker pull registry.cn-hangzhou.aliyuncs.com/k8sth/$imageName
 docker tag registry.cn-hangzhou.aliyuncs.com/k8sth/$imageName k8s.gcr.io/$imageName
 docker rmi registry.cn-hangzhou.aliyuncs.com/k8sth/$imageName
done

docker pull registry.cn-shenzhen.aliyuncs.com/duyj/flannel:v0.10.0-amd64
docker tag registry.cn-shenzhen.aliyuncs.com/duyj/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64
docker rmi registry.cn-shenzhen.aliyuncs.com/duyj/flannel:v0.10.0-amd64

docker tag k8s.gcr.io/pause-amd64:3.1 k8s.gcr.io/pause:3.1

#docker pull haproxy:1.7-alpine
#docker pull docker.io/osixia/keepalived:1.4.5
#docker pull quay.io/coreos/etcd:v3.3.8
docker pull quay.io/calico/typha:v0.7.4