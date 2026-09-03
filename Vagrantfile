# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos8"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "db01" do |db|
    db.vm.hostname = "db01"
    db.vm.network "private_network", ip: "192.168.56.11"
    db.vm.provision "shell", path: "scripts/db01-setup.sh"
  end

  config.vm.define "mc01" do |mc|
    mc.vm.hostname = "mc01"
    mc.vm.network "private_network", ip: "192.168.56.12"
    mc.vm.provision "shell", path: "scripts/mc01-setup.sh"
  end

  config.vm.define "rmq01" do |rmq|
    rmq.vm.hostname = "rmq01"
    rmq.vm.network "private_network", ip: "192.168.56.13"
    rmq.vm.provision "shell", path: "scripts/rmq01-setup.sh"
  end

  config.vm.define "app01" do |app|
    app.vm.hostname = "app01"
    app.vm.network "private_network", ip: "192.168.56.14"
    app.vm.provision "shell", path: "scripts/app01-setup.sh"
  end

  config.vm.define "web01" do |web|
    web.vm.hostname = "web01"
    web.vm.network "private_network", ip: "192.168.56.15"
    web.vm.box = "generic/ubuntu2204"
    web.vm.provision "shell", path: "scripts/web01-setup.sh"
  end
end
