## These open variables are used to dynamically pass sensitive information into the terraform plan without exposing them to source control.
variable "cluster-name" {}
variable "domain_name" {}
variable "region" {}
variable "hosted-zone-id" {}
variable "vpn_cidr_block" {}
variable "endpoint_public_access" {}
variable "endpoint_private_access" {}
variable "ec2_ssh_key" {}
variable "aws_creds" {}

variable "eks_desired_size" {
    default = 3
}

variable "eks_max_size" {
    default = 3
}

variable "eks_min_size" {
    default = 3
}

variable "az1" {
     default = "a"
}

variable "az2" {
     default = "b"
}

variable "az3" {
     default = "c"
}

variable "instanceTenancy" {
    default = "default"
}

variable "dnsSupport" {
    default = true
}

variable "dnsHostNames" {
    default = true
}

variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}

variable "subnetCIDRblockA" {
    default = "10.0.4.0/24"
}

variable "subnetCIDRblockB" {
    default = "10.0.6.0/24"
}

variable "subnetCIDRblockC" {
    default = "10.0.8.0/24"
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "mapPublicIP" {
    default = true
}

variable "enable_cross_zone_load_balancing" {
  default = true
}