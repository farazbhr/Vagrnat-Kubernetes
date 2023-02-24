# Logging and Monitoring


## [Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)


### Check node status
```bash
kubectl top node
```
## check pod status
```bash
kubectl top pod
```


### check logs on Pod 
```bash 
kubectl logs -f webapp-1
```
### Fix1:
```bash
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```