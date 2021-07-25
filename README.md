# Demo SF-1

This repo contains reference architecture expressed with infrastructure/configuration as code to observe BizDevOps workflows, in a cloud native environment.
The architecture in this demo utilizes [Amazon Web Services'](https://aws.amazon.com/) [Elastic Kubernetes Service](https://aws.amazon.com/eks/) as the Core Infrastructure layer.
For the Business Application layer, the [Jenkins Kubernetes Operator](https://github.com/jenkinsci/kubernetes-operator) and the [Configuration as Code plugin](https://github.com/jenkinsci/configuration-as-code-plugin) are used to automate the configuration of each CI/CD Pipeline.
Finally, in the Business Application layer, we are using the [sock-shop demo, from Weaveworks](https://microservices-demo.github.io/).

<br>

<br>

---

<br>


### There are two ways to create demo-sf1

There are two ways to create demo-sf1. The first method is more automated and easier for beginners, its also just a quick way to get things started for anyone.
The Second method is a more traditional workflow where you will need to install and configure the dependencies to make terraform work. You will need to determine which method is right for you.

- [The Quickstart and Beginner's Guide](#quickstart-and-beginners-deployment-guide)

- [Advanced Users Deployment Guide](#advanced-users-deployment-guide)

<br>

> NOTE:
>
> When switching back and fourth between the Quickstart deploy method and the advanced deploy method, it is advisable that you first delete any demo-sf1 infrastructure that you currently have deployed.
> Then. delete the `terraform.tfstate` and `terraform.tfstate.backup` files.
> ```
> cd ./demo-sf1/eks/
> ls
>
> rm terraform.tfstate*
> ```

<br>

<br>

---

<br>


<a name="quickstart-and-beginners-deployment-guide"></a>
### Quickstart and Beginner's Deployment Guide

This section was created as a quickstart guide to help beginners create the demo environment. It differs from the advanced deployment guide in that you don't need to install and configure the typical dependencies yourself. Instead, a VM get's provisioned on your local machine where all of the business happens.

<br>

##### Dependencies:

For this guide you will need to install the following dependencies:

1. VirtualBox: https://www.virtualbox.org/
2. Vagrant: https://www.vagrantup.com/
3. (mac/linux) git: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

4. If you are using Windows, it is suggested to install git for windows instead: https://gitforwindows.org/

   > Don't forget to make sure that the path to your git and vagrant binary is in the $PATH. i.e. `export PATH=$PATH:/path/to/binaries/`

<br>

##### Pre-deployment

- You'll need to add the public SSH key to your AWS account. If you need a key pair, you should be able to generate a key pair by following these steps:

  - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair

- You also need an AWS programmatic API key pair. We will be exporting it as an Environment Variable in your BASH shell (terminal). If you don't yet have an API key pair, please review the official documentation:
  - https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys


<br>

##### Deploy:

Step 1: Clone the demo code.
```
git clone https://github.com/cloud-architecture-demo/demo-sf1.git
```

Step 2: Change directories into the code directory.
```
cd ./demo-sf1
```

Step 3: You will need to copy the file `secrets.tfvars.example` and name it `secrets.tfvars`. Be sure to replace the default values with those relevant to you.

```
## EKS architecture demo sf1 secrets
cluster-name = "cad-sf1"
region = "us-east-1"

vpn_cidr_block = "0.0.0.0/0"
endpoint_public_access = "true"
endpoint_private_access = "true"
ec2_ssh_key = "your-keypair-name"

```
> Change **_vpn_cidr_block_** to match your company VPN CIDR if relevant for you.
If you aren't sure, try leaving it as is.

<br>

Step 4: Export your AWS credentials in your local shell (terminal).

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>

Step 5: Create Vagrant VM, it should automatically pick up your AWS credentials from the shell and deploy the demo-sf1 infrastructure in the cloud.
```
vagrant up
```
> If the processes doesn't complete successfully the first attempt, try again to see if there was a race time condition that no longer exists (waiting for cloud API).
>  `vagrant up --provison`

At this point, your demo should be deployed and the access information displayed on your terminal screen. Congrats!


> NOTE: 
>
> When deploying Jenkins or the Sock Shop app, please be patient while the automation stands them up, they might not yet be ready to start accepting connections. If you are browsing for them and the application doesn't seem to be available, wait a minute for the containers to deploy fully, then refresh your browser page.

<br>

##### Destroy:
Step 1: Change directories into the code directory.
```
cd ./demo-sf1
```

Step 2: Export your AWS credentials in your local shell (terminal).

<br>

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>

Step 3: Destroy Vagrant VM, it should automatically pick up your AWS credentials from the shell and destroy the demo-sf1 infrastructure in the cloud.
```
vagrant destroy -f
```

<br>

<br>

---

<br>

<a name="advanced-users-deployment-guide"></a>
### Advanced Users Deployment Guide

This guide is written for people who are comfortable installing and configuring dependencies on their local environment and are used to working in shell environments.

<br>


##### Dependencies:

For this guide you will need to install the following dependencies:

1. git: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
2. Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
3. AWS cli: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
4. kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#install-on-windows-using-chocolatey-or-scoop
5. If you are using Windows, it is suggested to install git for windows instead: https://gitforwindows.org/

   > Don't forget to make sure that the path to your git, terraform, aws and kubectl binaries are in the $PATH. i.e. `export PATH=$PATH:/path/to/binaries/`

<br>

##### Pre-deployment

- You'll need to add the public SSH key to your AWS account. If you need a key pair, you should be able to generate a key pair by following these steps:

  - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair

- You also need an AWS programmatic API key pair. We will be exporting it as an Environment Variable in your BASH shell (terminal). If you don't yet have an API key pair, please review the official documentation:
  - https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys


<br>

##### Deploy:

Step 1: Clone the demo code:
```
git clone https://github.com/cloud-architecture-demo/demo-sf1.git
```

Step 2: Change directories into the code directory.
```
cd ./demo-sf1
```

Step 3. You will need to copy the file `secrets.tfvars.example` and name it `secrets.tfvars`. Be sure to replace the default values with those relevant to you.

```
## EKS architecture demo sf1 secrets
cluster-name = "cad-sf1"
region = "us-east-1"

vpn_cidr_block = "0.0.0.0/0"
endpoint_public_access = "true"
endpoint_private_access = "true"
ec2_ssh_key = "your-keypair-name"

```
> Change **_vpn_cidr_block_** to match your company VPN CIDR if relevant for you.
If you aren't sure, try leaving it as is.

<br>

Step 4: Export your AWS credentials in your local shell (terminal).

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>


Step 5: Deploy demo-sf1. Run the `terraform up` wrapper script, `deploy.sh`.
```
./deploy.sh
```
> If the processes doesn't complete successfully the first attempt, try again to see if there was a race time condition that no longer exists (waiting for cloud API).
>`./deploy.sh`

At this point, your demo should be deployed and the access information displayed on your terminal screen. Congrats!

> NOTE: 
>
> When deploying Jenkins or the Sock Shop app, please be patient while the automation stands them up, they might not yet be ready to start accepting connections. If you are browsing for them and the application doesn't seem to be available, wait a minute for the containers to deploy fully, then refresh your browser page.


<br>

##### Destroy:
Step 1: Change directories into the code directory.
```
cd ./demo-sf1
```

Step 2: Export your AWS credentials in your local shell (terminal).

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>

Step 3: Destroy demo-sf1. Run the `terraform destroy` wrapper script, `destroy.sh`.
```
./destroy
```

<br>

<br>

---

<br>
