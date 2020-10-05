# terraform_modules
Module | Descriptions | Dependencies
--- | --- | ---
vpc | AWS VPC module for creating a VPC | none
sg  | AWS SG module for creating a security group | vpc_id

Examples: 

`vpc` module
~~~
provider "aws" {
  region = "us-east-1"
}

module "my_vpc" {
  source = "github.com/bookmanj/terraform_modules///vpc"

  identifier = "my"
  cidr       = "20.0.0.0/16"

  private_subnets = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
  public_subnets  = ["20.0.101.0/24", "20.0.102.0/24", "20.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  global_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~

`sg` module with `vpc` module, so pulling the vpc_id from `vpc` module
~~~
module "my_sg" {
  source = "github.com/bookmanj/terraform_modules//sg"
  
  identifier  = "my"
  description = "Example b"

  vpc_id      = module.my_vpc.vpc_info[0].id

  ingress_from_self_list = ["80,80,tcp,Allow HTTP"]
  ingress_cidr_list = [
    "443,443,tcp,0.0.0.0/0,Allow HTTPS",
    "22,22,tcp,47.220.150.94/32,Allow SSH"
  ]

  global_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~

`sg` module seperate from `vpc` module, pulling the vpc_id by knowing vpc's name (e.g. my_vpc)
~~~
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["my_vpc"]
  }
}

module "my_sg" {
  source = "github.com/bookmanj/terraform_modules//sg"
  
  identifier  = "my"
  description = "Example b"

  vpc_id      = data.aws_vpc.selected.id

  ingress_from_self_list = ["80,80,tcp,Allow HTTP"]
  ingress_cidr_list = [
    "443,443,tcp,0.0.0.0/0,Allow HTTPS",
    "22,22,tcp,47.220.150.94/32,Allow SSH"
  ]

  global_tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
~~~
