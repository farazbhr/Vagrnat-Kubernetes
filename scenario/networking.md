#### Check network commands:
```bash
ip link 
netstat -anp | grep etcd | grep 2380 | wc -l
netstat -anp | grep etcd | grep 2379 | wc -l 
```
- check pods
```bash
kubectl get pod -o wide
```
- taint only one node
```bash
kubectl taint nodes master1 node-role.kubernetes.io/master-
```

- CRN for kubelet
```bash
ps -aux | grep kubelet | grep 'container-runtime-endpoint'
The CNI binaries are located under /opt/cni/bin by default.
```

- What is the CNI plugin configured to be used on this kubernetes cluster?
```bash
ls /etc/cni/net.d/
```

- Identify the name of the bridge network/interface 
created by weave on each node.
```bash
ip link
```

What is the POD IP address range configured by weave?
```bash
ip addr show weave
```

What is the range of IP addresses configured for PODs on this cluster?
```bash
kubectl logs <weave-pod-name> weave -n kube-system
```

What is the IP Range configured for the services within the cluster?
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range
```