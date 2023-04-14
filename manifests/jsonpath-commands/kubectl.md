
## kubectl

### Get the list of nodes in JSON format and store it in a file at
```bash 
kubectl get nodes -o json > /opt/outputs/nodes.json
kubectl get node node01 -o json > /opt/outputs/node01.json
```

### fetch the node names
```bash 
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' > /opt/outputs/node_names.txt
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os.txt
```

### get usernames
```bash 
kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.users[*].name}" > /opt/outputs/users.txt
```

### A set of persistant valumes
```bash 
kubectl get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt
kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" > /opt/outputs/aws-context-name
```