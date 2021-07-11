
# Create VPC/Subnet/Security Group
provider "aws" {
  version = "~> 2.0"
  #access_key = var.access_key
  #secret_key = var.secret_key
  shared_credentials_file = var.aws_creds
  region     = var.region
}

# Create the VPC
resource "aws_vpc" "eks" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster-name} VPC"
  }
}

# create the Subnet a
resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.subnetCIDRblockA
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = "${var.region}${var.az1}"
  tags = {
     Name = "${var.cluster-name} - ${var.region}${var.az1} VPC Subnet"
     "kubernetes.io/cluster/${var.cluster-name}" = "shared" ## This tag is critical to associate a VPC subnet with a specific EKS cluster network.
  }
}

# create the Subnet b
resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.subnetCIDRblockB
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = "${var.region}${var.az2}"
  tags = {
     Name = "${var.cluster-name} - ${var.region}${var.az2} VPC Subnet"
     "kubernetes.io/cluster/${var.cluster-name}" = "shared" ## This tag is critical to associate a VPC subnet with a specific EKS cluster network.
  }
}

# create the Subnet c
resource "aws_subnet" "c" {
  vpc_id                  = aws_vpc.eks.id
  cidr_block              = var.subnetCIDRblockC
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = "${var.region}${var.az3}"
  tags = {
     Name = "${var.cluster-name} - ${var.region}${var.az3} VPC Subnet"
     "kubernetes.io/cluster/${var.cluster-name}" = "shared" ## This tag is critical to associate a VPC subnet with a specific EKS cluster network.
  }
}

# Create the Internet Gateway (VPC router).
resource "aws_internet_gateway" "eks_VPC_GW" {
  vpc_id = aws_vpc.eks.id
  tags = {
    Name = "${var.cluster-name} Internet Gateway"
  }
}

# Create the route table in order to map netowrk routes to the internet gateway.
resource "aws_route_table" "eks_VPC_route_table" {
  vpc_id = aws_vpc.eks.id
  tags = {
        Name = "${var.cluster-name} VPC Route Table"
  }
}

# Create a network route to the internet gateway.
resource "aws_route" "eks_VPC_internet_access" {
  route_table_id         = aws_route_table.eks_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.eks_VPC_GW.id
}

resource "aws_route_table_association" "eks_VPC_association_a" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.eks_VPC_route_table.id
}

resource "aws_route_table_association" "eks_VPC_association_b" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.eks_VPC_route_table.id
}

resource "aws_route_table_association" "eks_VPC_association_c" {
  subnet_id      = aws_subnet.c.id
  route_table_id = aws_route_table.eks_VPC_route_table.id
}

## Create a security group that mangages access to the EKS Control Plane.
resource "aws_security_group" "eks" {
  name        = "terraform-eks"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      aws_subnet.a.cidr_block,
      aws_subnet.b.cidr_block,
      aws_subnet.c.cidr_block,
      var.vpn_cidr_block
    ]
  }
}

## Create security group that manages access to the EKS worker nodes.
resource "aws_security_group" "main-node" {
  name        = "terraform-eks-main-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## Create an EKS worker node security group rule.
resource "aws_security_group_rule" "main-node-ingress-self" {
  type              = "ingress"
  description       = "Allow node to communicate with each other"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.main-node.id
  to_port           = 65535
  cidr_blocks       = [
    aws_subnet.a.cidr_block,
    aws_subnet.b.cidr_block,
    aws_subnet.c.cidr_block,
    var.vpn_cidr_block
  ]
}

## Create an EKS Control Plane security group rule.
resource "aws_security_group_rule" "main-node-ingress-cluster" {
  type                     = "ingress"
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.main-node.id
  source_security_group_id = aws_security_group.eks.id
  to_port                  = 65535
}


locals {
  main-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.main.endpoint}' --b64-cluster-ca '${aws_eks_cluster.main.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA

## Update kubeconfig with: terraform output kubeconfig > ~/.kube/config
  kubeconfig = <<KUBECONFIG
## Generated by Terraform
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${aws_eks_cluster.main.certificate_authority.0.data}
    server: ${aws_eks_cluster.main.endpoint}
  name: ${aws_eks_cluster.main.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.main.arn}
    user: ${aws_eks_cluster.main.arn}
  name: ${aws_eks_cluster.main.arn}
current-context: ${aws_eks_cluster.main.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.main.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - --region
      - ${var.region}
      - eks
      - get-token
      - --cluster-name
      - ${var.cluster-name}
      command: aws
KUBECONFIG
  ## append more locals/outputs as needed.

}

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "kubeconfig-tf-${var.cluster-name}"
}



