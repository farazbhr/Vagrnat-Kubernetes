#!/bin/bash

#Author: Faraz Behrouzieh
#This Script will install the basic tools needed for Kubernetes installation.

### on  master1
cp kubeadm_config /opt/kubeadm_config.yml  #done

#get image list
kubeadm config images list --config /opt/kubeadm_config.yml   #list the images I Need in the cluster
kubeadm config images pull --config /opt/kubeadm_config.yml

#pull all images
docker pull k8s.gcr.io/kube-apiserver:v1.26.0
docker pull k8s.gcr.io/kube-controller-manager:v1.26.0
docker pull k8s.gcr.io/kube-scheduler:v1.26.0
docker pull k8s.gcr.io/kube-proxy:v1.26.0
docker pull k8s.gcr.io/pause:3.9
docker pull quay.io/coreos/etcd/etcd:v3.4.16
docker pull k8s.gcr.io/coredns:v1.9.3
docker pull calico/node:v3.18.6
docker pull calico/kube-controllers:v3.18.6

docker pull registry.k8s.io/kube-apiserver:v1.22.17
docker pull registry.k8s.io/kube-controller-manager:v1.22.17
docker pull registry.k8s.io/kube-scheduler:v1.22.17
docker pull registry.k8s.io/kube-proxy:v1.22.17
docker pull registry.k8s.io/pause:3.5
docker pull quay.io/coreos/etcd:v3.4.16
docker pull registry.k8s.io/coredns/coredns:v1.8.4

#initialize master 1
kubeadm init --config /opt/kubeadm_config.yml

# kubectl config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Deploy Calico Network
kubectl create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml

# SSH Configuration
cat /etc/ssh/sshd_config | grep PermitRootLogin
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config | grep PermitRootLogin
systemctl restart sshd
passwd

# Copy Certificate on master2 and master3
scp -r root@192.168.1.201:/etc/kubernetes/pki /etc/kubernetes/


#join master2
#to create a new token, the old one xpires after 24 hours
kubeadm token create --print-join-command
kubeadm token list

kubeadm join 192.168.1.100:6443 --token ahcvrm.ow0bsyrlgr2he90e \
 --discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
  --control-plane --apiserver-advertise-address 192.168.1.203 --v=5

kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
 --discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
  --control-plane --apiserver-advertise-address 192.168.1.202

#join master3
kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
 --discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
  --control-plane --apiserver-advertise-address 192.168.1.203

#install etcd


# on master node we check the etcd server
export endpoint="https://192.168.1.201:2379,192.168.1.202:2379,192.168.1.203:2379"
export flags="--cacert=/etc/kubernetes/pki/etcd/ca.crt \
              --cert=/etc/kubernetes/pki/etcd/server.crt \
              --key=/etc/kubernetes/pki/etcd/server.key"
endpoints=$(sudo ETCDCTL_API=3 etcdctl member list $flags --endpoints=${endpoint} \
            --write-out=json | jq -r '.members | map(.clientURLs) | add | join(",")')


# Verify
sudo ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} member list
sudo ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} endpoint status
sudo ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} endpoint health
sudo ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} alarm list
sudo ETCDCTL_API=3 etcdctl $flags --endpionts=${endpoint} get / --prefix --keys-only --limit
etcdctl member list $flags --endpoints=${endpoint} --write-out=table
etcdctl endpoint status $flags --endpoints=${endpoint} --write-out=table

# Accessing the Dashboard UI
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl get namespace

# change ClusterIP to NodePort Service
kubectl patch svc -n kubernetes-dashboard kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'

kubectl get service -A

#Get node port assaign to a service
kubectl get services -n kubernetes-dashboard kubernetes-dashboard -o go-template='{{(index .spec.ports 0).nodePoert}}'

# create service account
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# define ClusterRoleBinding
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

#Getting a Bearer Token
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')


# describe a pod situation
kubectl -n kubernetes-dashboard describe pod

#get all
kubectl -n kubernetes-dashboard get all

# pods in default namespace
kubectl get pod

# describe a pod
kubectl describe pod web-65856fb89b-5ptq2

#create pod - not recommended
kubectl run nginx --image nginx:alpine

# our kubelet manifests - static pods
ls /etc/kubernetes/manifests/

kubectl get replicasets.app
kubectl get deployments.app

#edit deployment web
kubectl edit deployments.apps web

# delete pod
kubectl delete pod nginx

kubectl get namespace

kubectl get daemonsets.apps -A

kubectl get configmap -A

ubectl describe -n kube-system configmaps calico-config

kubectl get pod -A -o wide
kubectl get pod,service,deployment,cm -n kube-system


#kubectl bash auto completion
source /usr/share/bash-completion/bash_completion
kubectl completion bash > /etc/bash_completion.d/kubectl
source /etc/bash_completion.d/kubectl

#manifest
k get pod kube-proxy-dzwd9 -o yaml

#edit a pod
kubectl edit pod simple

#get the nodes
kubectl get nodes













Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
	--discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
	--control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
	--discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b
-----------
ck
W0206 12:37:18.365911  133424 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
W0206 12:37:18.752175  133424 warnings.go:70] policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
NAME: loki-grafana
LAST DEPLOYED: Mon Feb  6 12:37:16 2023
NAMESPACE: loki-stack
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace loki-stack loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   loki-grafana.loki-stack.svc.cluster.local

   Get the Grafana URL to visit by running these commands in the same shell:
     export POD_NAME=$(kubectl get pods --namespace loki-stack -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=loki-grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace loki-stack port-forward $POD_NAME 3000

3. Login with the password from step 1 and the username: admin
