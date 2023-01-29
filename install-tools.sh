#!/bin/bash

#Author: Faraz Behrouzieh
#This Script will install the basic tools needed for Kubernetes installation.

#install octant for vmware
dpkg -i octant_0.25.1_Linux-64bit.deb
ocant
octant --help
octant --listener-addr 0.0.0.0:7777

#create pod from a manifest
vi pod-simple.yml
kubectl create -f pod-simple.yml
kubectl get node --show-labels

#edit a node
kubectl edit nodes master3

#create pvc
kubectl create -f pvc.yml
kubectl get pvc

#get endpoint
kubectl get endpoints

#scale up
k scale --replicas=2 replicaset wordpress-5994d99f46

#kubectl access
kubectl auth can-i delete pod

#To mark a Node unschedulable, run:

kubectl cordon $NODENAME