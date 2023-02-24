### Commands

- vagrant
```bash
    vagrant up
    vagrant destroy
    vagrant validate
    vagrant shh k8s-lb
```    

- SSH
```bash
    ssh vagrant@192.168.1.201
    vagrant ssh master1
    sudo su #change the user to root
```

- Kubernetes
```bash
    kubectl get nodes
    kubectl get pod -A
    kubectl get namespace
    kubectl get service -A
    kubectl get pod #shows pods in default namespace
    kubectl -n research get pods #shows pods in research namespace
```

- Change Kubernetes Version
```bash
    apt purge kubelet kubeadm kubectl 
    apt auto-remove
    apt-cacahe madison kubeadm
    apt-cache madison kubeadm
    apt install kubeadm=1.22.17-00
    apt install kubelet=1.22.17-00
    apt install kubectl=1.22.17-00
    kubeadm version
```

- Calico
```bash
    https://projectcalico.docs.tigera.io/archive/v3.18/about/about-calico
<p>Calico is an open source networking and network security solution for containers, 
virtual machines, and native host-based workloads. Calico supports a broad range of 
platforms including Kubernetes, OpenShift, Docker EE, OpenStack, and bare metal services.</p>
```

- Monitoring
```bash
watch kubectl get pod,rs -o wide
```
- kubectl convert
- You can use kubectl convert to update manifest files to use a different API version. 
```bash
kubectl convert -f ./deployment.yml --output-version rbac.authorization.k8s.io/v1
```

- View kube controller option
```bash
cat /etc/kubernetes/manifests/kube-controller-manager.yaml
```

- In some cases, you may need to update resource fields that 
cannot be updated once initialized, or you may want to make a 
recursive change immediately, such as to fix broken pods created by a Deployment.
To change such fields, use replace --force, which deletes and re-creates the resource.
In this case, you can modify your original configuration file
```bash
kubectl replace -f https://k8s.io/examples/application/nginx/nginx-deployment.yaml --force
```

- Check image
```bash
kubectl describe pod -n kube-system kube-scheduler-controlplane | grep image
```

#### difference between comand filed in docker and a pod:
```bash
entrypoint [sleep] is command:["sleep2.0"]
CMD ["5"] is args:["10"]

---
apiVersion: v1 
kind: Pod 
metadata:
  name: ubuntu-sleeper-2 
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command:
      - "sleep"
      - "5000"
---
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    args: ["--color", "green"]
```

- Bash base64 encode and decode
```bash
echo  'linuxhint.com' | base64
echo 'bGludXhoaW50LmNvbQo=' | base64 --decode
```


- Install helm
  https://helm.sh/docs/intro/install/

- Install Loki
https://www.scaleway.com/en/docs/tutorials/manage-k8s-logging-loki/