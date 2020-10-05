# Dependency
variable "vpc_id" {
  description = "The id of the VPC where the security group needs to be created"
  type        = string
  default     = ""
}

# Secuirty Group
variable "identifier" {
  description = "Prefix to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "global_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "sg_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = ""
}

# Ingress input
variable "ingress_cidr_list" {
  description = "List of concatenated ports, protocols, CIDR (IPv4) blocks used for inbound rules"
  type        = list(string)
  default     = []
}

variable "ingress_from_self_list" {
  description = "List of concatenated ports, protocols from the same SG used for inbound rules"
  type        = list(string)
  default     = []
}

# Egress input
variable "egress_cidr_list" {
  description = "List of concatenated ports, protocols, CIDR (IPv4) blocks used for outbound rules"
  type        = list(string)
  default     = ["0,0,-1,0.0.0.0/0"]
}

variable "egress_from_self_list" {
  description = "List of concatenated ports, protocols from the same SG used for outbound rules"
  type        = list(string)
  default     = []
}

