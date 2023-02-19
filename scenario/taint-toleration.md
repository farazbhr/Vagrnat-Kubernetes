# Taints and Tolerations


## [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)


### Check Taints on a node

```bash
kubectl describe node node01 | grep -i taints
```
## You add a taint to a node using kubectl taint.
```bash
kubectl taint nodes node1 key1=value1:NoSchedule
```

### Create a pod with tolerations
```bash 
---
apiVersion: v1
kind: Pod
metadata:
  name: bee
spec:
  containers:
  - image: nginx
    name: bee
  tolerations:
  - key: spray
    value: mortein
    effect: NoSchedule
    operator: Equal
```
  
### To remove the taint
```bash
kubectl taint nodes node1 key1=value1:NoSchedule-
```