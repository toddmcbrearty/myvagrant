Vagrant.configure("2") do |config|
    config.vm.box = "precise62"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.network :private_network, ip: '33.33.33.10'
    config.vm.provision :shell, :path => "bootstrap.sh"

    config.vm.provider :virtualbox do |vb|
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
        vb.customize ["modifyvm", :id, "--memory", "512"]
    end
end
