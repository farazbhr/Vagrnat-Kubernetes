###Commands

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