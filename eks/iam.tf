
## Create IAM policy so that eks is allowed to assume itself.
resource "aws_iam_role" "eks" {
  name = "eks-main-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com",
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

## Attach AWS policy to EKS cluster Control Plane IAM role.
resource "aws_iam_role_policy_attachment" "main-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

## Attach AWS policy to EKS cluster Control Plane IAM role.
resource "aws_iam_role_policy_attachment" "main-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks.name
}


## Create an IAM role that the worker nodes are going to assume.
resource "aws_iam_role" "main-node" {
  name = "terraform-eks-main-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com",
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

## Attach EKS worker node policy to EKS worker node (main-node) IAM role.
resource "aws_iam_role_policy_attachment" "main-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.main-node.name
}

## Attach EKS CNI policy to EKS worker node IAM role.
resource "aws_iam_role_policy_attachment" "main-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.main-node.name
}

## Attach EC2 policy to EKS worker node IAM role.
resource "aws_iam_role_policy_attachment" "main-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.main-node.name
}

## Attach EC2 policy to EKS worker node IAM role.
resource "aws_iam_role_policy_attachment" "main-node-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.main-node.name
}

## Attach EKS ALB ingress policy to EKS worker node IAM role.
#resource "aws_iam_role_policy_attachment" "main-node-alb-ingress_policy" {
#  policy_arn = aws_iam_policy.alb-ingress.arn
#  role       = aws_iam_role.main-node.name
#}

## Define and EC2 instance profile, used to deploy EKS worker nodes.
resource "aws_iam_instance_profile" "main-node" {
  name = "terraform-eks-main"
  role = aws_iam_role.main-node.name
}








