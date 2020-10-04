# terraform_modules
terraform aws module that I will be creating and testing

# VPC module: create and manage this vpc

# VPC module: example usage
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