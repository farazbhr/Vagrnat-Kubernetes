# [Master Scheduling](https://stackoverflow.com/questions/43147941/allow-scheduling-of-pods-on-kubernetes-master)
### Allow scheduling of pods on Kubernetes master:
```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
```
- check pods
```bash
kubectl get pod -o wide
```
- taint only one node
```bash
kubectl taint nodes master1 node-role.kubernetes.io/master-
```