#!/bin/bash
images=(kube-proxy-amd64:v1.11.0
        pause-amd64:3.1
        kubernetes-dashboard-amd64:v1.8.3
    heapster-influxdb-amd64:v1.3.3
    heapster-grafana-amd64:v4.4.3
    heapster-amd64:v1.4.2 )
for imageName in ${images[@]} ; do
docker pull registry.cn-shenzhen.aliyuncs.com/duyj/$imageName
docker tag registry.cn-shenzhen.aliyuncs.com/duyj/$imageName k8s.gcr.io/$imageName
docker rmi registry.cn-shenzhen.aliyuncs.com/duyj/$imageName
done

docker pull quay.io/coreos/flannel:v0.10.0-amd64
docker tag k8s.gcr.io/pause-amd64:3.1 k8s.gcr.io/pause:3.1
