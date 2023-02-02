#Vegrant file
#Author: Faraz Behrouzieh

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "bootstrap.sh"

    config.vm.define "k8s-lb" do |lb|
      lb.vm.box = "bento/ubuntu-22.04"
      lb.vm.hostname = "lb.faraz"
      lb.vm.network "private_network", ip: "192.168.1.100"
      lb.vm.provider "virtualbox" do |v|
        v.name = "lb.faraz"
        v.memory = 1024
        v.cpus = 1
      end
      #lb.vm.provision "shell", path: "lb_config.sh"
    end

  MasterNodeCount=3
  # Type2 Nodes
  (1..MasterNodeCount).each do |master_vm_id|
    config.vm.define "master#{master_vm_id}" do |masternode|
      masternode.vm.box = "bento/ubuntu-22.04"
      masternode.vm.hostname = "master#{master_vm_id}.faraz"
      masternode.vm.network "private_network", ip: "192.168.1.20#{master_vm_id}"
      masternode.vm.provider "virtualbox" do |v|
        v.name = "master#{master_vm_id}"
        v.memory = 2048
        v.cpus = 3
      end
      masternode.vm.provision "shell", path: "bootstrap_t1.sh"
    end
  end

  WorkerNodeCount=1
  # Type2 Nodes
  (1..WorkerNodeCount).each do |worker_vm_id|
    config.vm.define "worker#{worker_vm_id}" do |workernode|
      workernode.vm.box = "bento/ubuntu-22.04"
      workernode.vm.hostname = "worker#{worker_vm_id}.faraz"
      workernode.vm.network "private_network", ip: "192.168.1.21#{worker_vm_id}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "worker#{worker_vm_id}"
        v.memory = 1500
        v.cpus = 2
      end
    end
  end
  
end
