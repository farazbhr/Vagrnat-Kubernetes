#!/bin/bash

#Author: Faraz Behrouzieh
#This Script will install the basic tools needed for Kubernetes installation.

export DEBIAN_FRONTEND=noninteractive
lb_ip=192.168.1.100
master1=192.168.1.201
master2=192.168.1.202
master3=192.168.1.203
worker1=192.168.1.301

# Update Commands
apt update
apt upgrade -y

# Install Tools
echo "***Install Tools***"
apt install -y wget git vim bash-completion curl htop net-tools dnsutils \
                    atop sudo software-properties-common telnet axel jq iotop

# Install and Configure Docker
curl -fsSL https://get.docker.com -o get-docker.sh
DRY_RUN=1 sudo sh ./get-docker.sh

echo "****Docker Post Install Configure****"
groupadd docker
usermod -aG docker $USER
newgrp docker
chown "$USER":"$USER" /home/"$USER"/.docker -R
chmod g+rwx "$HOME/.docker" -R
systemctl enable docker.service
systemctl restart docker.service

echo "****Dcoker Config****"
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
systemctl daemon-reload
systemctl restart docker


# add sysctl setting
echo "****Add sysctl setting****"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable Swap
echo "****Disable and turn off SWAP****"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install apt-transport-https package
echo "****Install apt-transport-https package****"
apt-get update & apt-get -y install apt-transport-https curl
#curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add the kubernetes sources list into the source.list directory
echo "*****Add the kubernetes sources list into the source.list directory*****"
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
ls -ltr /etc/apt/sources.list.d/kubernetes.list
apt-get update -y

# Install Kubernetes
echo "*****Install Kubernetes kubeadm, kubelet and kubectl*****"
apt-get install -y kubectl=1.22.17-00
apt-get install -y kubectl=1.22.17-00
apt-get install -y kubeadm=1.22.17-00

# check versions
kubelet --version
kubeadm version
kubectl version

#kubectl bash completion
echo 'source <(kubectl completion bash)' >>~/.bashrc

#start and enable the kubelet service
echo "****Enable and start kubelet service****"
systemctl enable kubelet >/dev/null 2>&1
systemctl restart kubelet >/dev/null 2>&1
systemctl status kubelet >/dev/null 2>&1

echo "****remove all unused packages****"
apt autoremove -y

cat >>/etc/hosts<<EOF
$lb_ip
$master1
$master2
$master3
$worker1
EOF

#end
#install CRI docker D https://devopstales.github.io/home/migrate-kubernetes-to-dockershim/