# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # common setting
  config.vm.box = "bento/centos-7.7"
  config.vm.box_check_update = false
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # configure resources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # setup private ip address
  config.vm.network "private_network", ip: "192.168.33.10"

  # install utility common package
  config.vm.provision "shell", inline: <<-SHELL
    yum -y install bash-completion bash-completion-extras
  SHELL

  # disable swap
  config.vm.provision "shell", inline: <<-SHELL
    swapoff -a
    sed -i '/swap/d' /etc/fstab
  SHELL

  # put config files
  config.vm.provision "file", source: "./provision", destination: "/tmp/provision"
  config.vm.provision "shell", inline: <<-SHELL
    cp -a /tmp/provision/* /
    rm -rf /tmp/provision
    sysctl --system
  SHELL

  # install docker daemon
  config.vm.provision "shell", inline: <<-SHELL
    yum -y install yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum -y update && yum -y install docker-ce
    systemctl enable --now docker
  SHELL

  # install k8s for master
  config.vm.provision "shell", inline: <<-SHELL
    yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    systemctl enable --now kubelet
  SHELL

  # init k8s for master
  config.vm.provision "shell", inline: <<-SHELL
    kubeadm init --apiserver-advertise-address=192.168.33.10 --pod-network-cidr=10.244.0.0/16

    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config

    mkdir -p /home/vagrant/.kube
    cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
    chown -R vagrant:vagrant /home/vagrant/.kube/config

    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  SHELL

end
