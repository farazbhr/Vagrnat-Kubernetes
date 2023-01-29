# [Drain and Uncordon](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
### Use kubectl drain to remove a node from service:
```bash
kubectl drain --ignore-daemonsets --delete-emptydir-data worker1
```
- check pods
```bash
kubectl get pod -o wide
```
- resume scheduling new pods onto the node.
```bash
kubectl uncordon worker1
```