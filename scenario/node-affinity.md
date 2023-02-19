# Node affinity


## [Node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)


### Apply a label on a node

```bash
kubectl label node node01 color=blue
```
## You add a taint to a node using kubectl taint.
```bash
kubectl taint nodes node1 key1=value1:NoSchedule
```

### Create a pod with node affinity
```bash 
---
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity

spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - antarctica-east1
            - antarctica-west1
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value

  containers:
  - name: with-node-affinity
    image: registry.k8s.io/pause:2.0
```

### To remove the taint
```bash
kubectl taint nodes node1 key1=value1:NoSchedule-
```