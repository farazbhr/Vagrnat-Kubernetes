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
docker pull calico/node
docker pull calico/kube-controllers

#initialize master 1
kubeadm init --config /opt/kubeadm_config.yml
#44 min
#node image master 1 pulled
