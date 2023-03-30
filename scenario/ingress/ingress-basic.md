#### Check ingress commands:
```bash
kubectl get pods --all-namespaces
```
- check ingress deployments
```bash
kubectl get deploy --all-namespaces
```
- check,edit ingress resource
```bash
kubectl get ingress --all-namespaces
kubectl edit -n app-space ingress ingress-wear-watch
```

- create ingress
```bash
kubectl get svc -n critical-space
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx-example
  rules:
  - http:
      paths:
      - path: /pay
        pathType: Prefix
        backend:
          service:
            name: service-pay
            port:
              number: 8282
---
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /pay
        pathType: Prefix
        backend:
          service:
           name: pay-service
           port:
            number: 8282
```

- create ingress, namespace, configmaps, service account
```bash
kubectl create configmap ingress-nginx-controller --namespace ingress-nginx
kubectl create serviceaccount ingress-nginx --namespace ingress-nginx
kubectl create serviceaccount ingress-nginx-admission --namespace ingress-nginx
kubectl get rolebinding -n ingress-nginx
```


