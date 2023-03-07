# [SSL-check](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
### Location for kube api server:
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep tls
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd-certfile
--etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
```
### Location for kubelet,etcd certs:
```bash
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep kubelet
cat /etc/kubernetes/manifests/etcd.yaml
```

- check certificate details
```bash
openssl x509 -in file-path.crt -text -noout
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout #api server
openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout #etcd server certificate
openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout # root ca certificate
```
- create ssl for users
```bash
cat akshay.csr | base64 -w 0
---
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: akshay
spec:
  groups:
  - system:authenticated
  request: <Paste the base64 encoded value of the CSR file>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
---
kubectl apply -f akshay-csr.yaml
kubectl get csr
kubectl certificate approve akshay
kubectl certificate deny agent-smith
kubectl delete csr agent-smith
```