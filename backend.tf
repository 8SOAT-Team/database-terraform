terraform {
  backend "s3" {
    bucket = "team-soat-bucket-bessa"
    key    = "fast-order/tf/rds/terraform.tfstate"
    region = "us-east-1"
  }
}