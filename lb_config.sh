#!/bin/bash

#Author: Faraz Behrouzieh
#This Script will install the basic tools needed for Kubernetes installation.

lb_ip=192.168.1.100
lb_port=6443
master1_ip=192.168.1.201
master2_ip=192.168.1.202
master3_ip=192.168.1.203
worker1_ip=192.168.1.211

#copy bashrc config
sudo cp /home/vagrant/.bashrc /root/

#commands

sudo apt-get install haproxy -y

cat >>/etc/haproxy/haproxy.cfg<<EOF

frontend fe-apiserver
  bind 0.0.0.0:6443
  mode tcp
  option tcplog
  default_backend be-apiserver

backend be-apiserver
  mode tcp
  option tcplog
  option tcp-check
  balance roundrobin
##default-server inter 10s downiter 5s rise 2 fall 2 showstart 60s maxconn 250 maxqueue 256

  server master1 $master1_ip:6443 check
  server master2 $master1_ip:6443 check
  server master3 $master1_ip:6443 check
EOF

cat /etc/haproxy/haproxy.cfg

echo "Enable and start haproxy service"
systemctl enable haproxy >/dev/null 2>&1
systemctl restart haproxy >/dev/null 2>&1
systemctl status haproxy >/dev/null 2>&1