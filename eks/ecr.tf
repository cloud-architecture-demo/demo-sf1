resource "aws_ecr_repository" "repository_carts" {
  name                 = "carts"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_catalogue" {
  name                 = "catalogue"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_front_end" {
  name                 = "front-end"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_orders" {
  name                 = "orders"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_payment" {
  name                 = "payment"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_queue_master" {
  name                 = "queue-master"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_shipping" {
  name                 = "shipping"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "repository_user" {
  name                 = "user"
  image_tag_mutability = "MUTABLE"
}