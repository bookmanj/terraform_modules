# availabilty zones
data "aws_availability_zones" "azs" {}
# misc
variable "all_traffic_cidr" {
  type        = string
  description = "cidr block to allow for all traffic"
  default     = "0.0.0.0/0"
}
variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}
variable "vpc_tenancy" {
  type        = string
  description = "vpc tenancy"
  default     = "default"
}
variable "vpc_dns_support" {
  type        = bool
  description = "vpc cidr block"
  default     = true
}
variable "vpc_dns_hostname" {
  type        = bool
  description = "vpc cidr block"
  default     = true
}
variable "vpc_name" {
  type        = string
  description = "name of the vpc"
  default     = "my_vpc"
}
# public subnet setting
variable "internet_gateway_name" {
  type        = string
  description = "name of the internet gateway"
  default     = "inet_gw"
}
variable "public_route_table_name" {
  type        = string
  description = "name of the public route table"
  default     = "pub_rt"
}
variable "public_cidr_list" {
  type        = list
  description = "list of the vpc's public cidr block(s)"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_subnets_prefix" {
  type        = string
  description = "prefix that will be put infront of the public subnet name"
  default     = "pub"
}
variable "public_ip_on_launch" {
  type        = bool
  description = "provide public IP  or not when launching an ec2 instance"
  default     = true
}
# private subnet settings
variable "nat_gw_eip_name" {
  type        = string
  description = "name for the elastic IP for the nat gateway"
  default     = "nat_gw_eip"
}
variable "nat_gw_name" {
  type        = string
  description = "name for the nat gateway"
  default     = "nat_gw"
}
variable "private_route_name" {
  type        = string
  description = "name for the private route table"
  default     = "private_rt"
}
variable "private_cidr_list" {
  type        = list
  description = "list of the vpc's private cidr block(s)"
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
variable "private_subnets_prefix" {
  type        = string
  description = "prefix that will be put infront of the private subnet name"
  default     = "priv"
}

