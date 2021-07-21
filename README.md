# Demo SF-1

This repo contains reference architecture expressed with infrastructure/configuration as code to observe BizDevOps workflows, in a cloud native environment.

<br>

### There are two ways to create demo-sf1
There are two ways to create demo-sf1. The first method is more automated and easier for beginners, its also just a quick way to get things started for anyone.
The Second method is a more traditional workflow where you will need to install and configure the dependencies to make terraform work. You will need to determine which method is right for you.

- [The Quickstart/Beginner's Guide](#### Quickstart/Beginner's Deployment Guide)

- [Advanced Users Deployment Guide](#### Advanced Users Deployment Guide)

#### Quickstart/Beginner's Deployment Guide

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

You'll need to add the public SSH key to your AWS account. If you need a key pair, you should be able to generate a key pair by following these steps:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair

<br>

##### Deploy:

Step 1: Clone the demo code:
```
git clone https://github.com/cloud-architecture-demo/demo-sf1.git
```

Step 2: Change directories into the code directory
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

Step 5: Create Vagrant VM to deploy environment
```
vagrant up
```
> If the processes doesn't complete successfully the first attempt, try again to see if there was a race time condition that no longer exists (waiting for cloud API).

<br>

##### Destroy:
Step 1: Change directories into the code directory
```
cd ./demo-sf1
```

Step 2: Export your AWS credentials in your local shell (terminal).

<br>

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>

Step 3: Create Vagrant VM to deploy environment
```
vagrant destroy -f
```

<br>

#### Advanced Users Deployment Guide

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

You'll need to add the public SSH key to your AWS account. If you need a key pair, you should be able to generate a key pair by following these steps:

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair


<br>

##### Deploy:

Step 1: Clone the demo code:
```
git clone https://github.com/cloud-architecture-demo/demo-sf1.git
```

Step 2: Change directories into the code directory
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


Step 5: terraform up wrapper script
```
./deploy.sh
```
> If the processes doesn't complete successfully the first attempt, try again to see if there was a race time condition that no longer exists (waiting for cloud API).

<br>

##### Destroy:
Step 1: Change directories into the code directory
```
cd ./demo-sf1
```

Step 2: Export your AWS credentials in your local shell (terminal).

Follow the official documentation to set this up, here:
> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html#envvars-set

<br>

Step 3: Create Vagrant VM to deploy environment
```
./destroy
```

<br>