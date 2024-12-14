variable "databaseName" {
  default  = "fastOrderDb"
  type     = string
  nullable = false
}

variable "user" {
  default = "sa"
}


variable "password" {
  default = "tech#2024"
}

variable "vpcCidr" {
  default = "172.31.0.0/16"
}