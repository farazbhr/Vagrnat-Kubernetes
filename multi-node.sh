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
docker pull quay.io/coreos/etcd/etcd:v3.5.6
docker pull k8s.gcr.io/coredns:v1.9.3
docker pull calico/node:v3.18.6
docker pull calico/kube-controllers:v3.18.6

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
kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
 --discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
  --control-plane --apiserver-advertise-address 192.168.1.202

#join master3
kubeadm join 192.168.1.100:6443 --token m8v5qt.uhclwsswy69rvxia \
 --discovery-token-ca-cert-hash sha256:67381bcbe5c721f94abe46257b25f5d45f51b26093391c39dfa20bd94aaa5a0b \
  --control-plane --apiserver-advertise-address 192.168.1.203



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
