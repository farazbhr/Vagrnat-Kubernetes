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