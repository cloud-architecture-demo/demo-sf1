# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "cad-sf1"
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "cad-sf1"

  ## You can create a forwarded port mapping which allows access to a specific [port within
  ## the vagrant machine from a port on the host machine. In the example below, accessing
  ## "localhost:8080" from your workstation will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  ## If true, then any SSH connections made will be able to utilize agent forwarding.
  ## The default vagrant behavior is false.
  # config.ssh.forward_agent = true

  ## If your want to share an additional folder to the guest VM, the first
  ## argument is the path on the host to the actual folder. The second
  ## argument is the path on the guest to mount the folder. And the
  ## optional third argument is a set of non-required options i.e.
  # config.vm.synced_folder "../some-local-directory", "/some-local-directory-mounted-inside-vagrant-machine"
  config.vm.synced_folder "./", "/home/vagrant/demo"

  config.trigger.before :destroy do |trigger|
    trigger.warn = "Attempting to run 'terraform destroy' to remove cloud infrastructure before destroying the Vagrant VM!"
    trigger.info = "It's a good idea to let this process complete uninterrupted, to prevent .tfstate file issues..."
    trigger.run_remote = {inline: "source /home/vagrant/.profile; export KUBECONFIG='/home/vagrant/demo/eks/kubeconfig-tf-backup'; cd /home/vagrant/demo; ./destroy.sh"}
    trigger.on_error = :continue
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", "512",
      "--cpus", "1",
      "--ioapic","on",
      "--audio", "none"
    ]
    vb.customize [
      "setextradata", :id,
      "GUI/DefaultCloseAction", "Shutdown"
    ]
  end

  #config.vm.provision "shell", inline: <<-SHELL
  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
  config.vm.provision "demo-prep", type: "shell" do |s|
    s.env = { 'AWS_DEFAULT_REGION' => ENV['AWS_DEFAULT_REGION'],
              'AWS_ACCESS_KEY_ID' => ENV['AWS_ACCESS_KEY_ID'],
              'AWS_SECRET_ACCESS_KEY' => ENV['AWS_SECRET_ACCESS_KEY'] }

    s.inline = <<-SHELL

      ## update system and install utilities
      sudo apt-get -y update
      sudo apt install -y \
      zip                 \
      curl                \
      awscli

      ## Install kubectl cli to interact with kubernetes clusters
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubectl
      mkdir /home/vagrant/.kube

      ## Install terraform cli to deploy infrastructure-as-code to the cloud
      TERRAFORM_VERSION=0.13.5
      #TERRAFORM_VERSION=1.0.2
      wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
      sudo unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin
      chmod +x /usr/local/bin/terraform

      ## Configure AWS cli
      FILE='/home/vagrant/.profile'
      grep -q "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" "${FILE}" || echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> "${FILE}"
      grep -q "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" "${FILE}" || echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> "${FILE}"
      grep -q "export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" "${FILE}" || echo "export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" >> "${FILE}"
      grep -q "export KUBECONFIG='/home/vagrant/demo/eks/kubeconfig-tf'" "${FILE}" || echo "export KUBECONFIG='/home/vagrant/demo/eks/kubeconfig-tf'" >> "${FILE}"

      aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
      aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
      aws configure set default.region ${AWS_DEFAULT_REGION}

      ## Uncomment echo lines below to debug AWS credentials environment variables
      ## to be sure that they are bing set correctly inside of your vagrant VM
      ## Note: The following commands will display your AWS credentials out to the terminal screen!!
      #echo ""
      #echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}"
      #echo "AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}"
      #echo "AWS_DEFAULT_REGION: ${AWS_DEFAULT_REGION}"
      #echo ""

      echo "#######################################################################################################"
      echo ""
      echo "  System Tools Check for demo:"
      echo ""
      echo "      terraform cli version:  `terraform version`"
      echo ""
      echo "      aws cli version:         `aws --version`"
      echo ""
      echo "      kubectl cli version:"
      echo ""
      echo "      `kubectl version --client`"
      echo ""
      echo "########################################################################################################"
      echo ""

      echo "#######################################################################################################"
      echo ""
      echo "  Executing Demo script now!..."
      echo ""
      echo ""

      source /home/vagrant/.profile; cd /home/vagrant/demo; ./deploy.sh
      cp /home/vagrant/demo/eks/kubeconfig-tf /home/vagrant/demo/eks/kubeconfig-tf-backup

    SHELL
  end
end
