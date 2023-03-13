
## where is the kubeConfig?
```bash 
cat .kube/config
```

### set current context
```bash 
kubectl config --kubeconfig=/root/my-kube-config use-context research
```


### to know the current context
```bash 
kubectl config --kubeconfig=/root/my-kube-config current-contextkubectl config --kubeconfig=/root/my-kube-config use-context research
```