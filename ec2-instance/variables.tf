# Dependency
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "seperate_subnet_ids" {
  description = "The VPC Subnet ID to launch in"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "used instead of subnet_id, to have each instance launch in a different subnet (number of instances must = number of subnet ids)"
  type        = list(string)
  default     = []
}

# ec2 instance
variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "identifier" {
  description = "Prefix to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = false
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "global_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "ec2_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}
