# [Security]()
### Check cluster role bindings:
```bash
 kubectl get rolebinding,clusterrolebinding --all-namespaces
 kubectl get clusterrolebindings --no-headers | wc -l
 kubectl describe clusterrolebinding cluster-admin
```
- clusterrole and cluster role bindings sample
```bash
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: storage-admin
rules:
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["get", "watch", "list", "create", "delete"]
- apiGroups: ["storage.k8s.io"]
  resources: ["storageclasses"]
  verbs: ["get", "watch", "list", "create", "delete"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: michelle-storage-admin
subjects:
- kind: User
  name: michelle
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: storage-admin
  apiGroup: rbac.authorization.k8s.io
```
- get service accounts
```bash
kubectl get serviceaccounts
kubectl describe serviceaccounts default
kubectl create serviceaccount dashboard-sa #create service account
kubectl create token dashboard-sa #create a token for service account
kubectl set serviceaccount deploy/web-dashboard dashboard-sa
```