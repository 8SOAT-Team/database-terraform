variable "region" {
  default  = "us-east-1"
  type     = string
  nullable = false
}

data "aws_vpc" "vpc" {
  cidr_block = var.vpcCidr
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}