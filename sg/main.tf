terraform {
  required_providers {
    aws = {
      version = "~> 3.8.0"
    }
  }
}

# Secuirty group
resource "aws_security_group" "this" {
  name_prefix = "${var.identifier}_sg_"
  description = var.description
  vpc_id      = var.vpc_id

  # Ingress IPv4
  dynamic "ingress" {
    for_each = var.ingress_cidr_list

    content {
      from_port   = element(split(",", ingress.value), 0)
      to_port     = element(split(",", ingress.value), 1)
      protocol    = element(split(",", ingress.value), 2)
      cidr_blocks = [element(split(",", ingress.value), 3)]
      description = element(split(",", ingress.value), 4)
    }

  }

  # Ingress self
  dynamic "ingress" {
    for_each = var.ingress_from_self_list

    content {
      from_port   = element(split(",", ingress.value), 0)
      to_port     = element(split(",", ingress.value), 1)
      protocol    = element(split(",", ingress.value), 2)
      description = element(split(",", ingress.value), 3)
      self        = true
    }

  }

  # Egress IPv4
  dynamic "egress" {
    for_each = var.egress_cidr_list

    content {
      from_port   = element(split(",", egress.value), 0)
      to_port     = element(split(",", egress.value), 1)
      protocol    = element(split(",", egress.value), 2)
      cidr_blocks = [element(split(",", egress.value), 3)]
      description = element(split(",", egress.value), 4)
    }

  }

  # Egress self
  dynamic "egress" {
    for_each = var.egress_from_self_list

    content {
      from_port   = element(split(",", egress.value), 0)
      to_port     = element(split(",", egress.value), 1)
      protocol    = element(split(",", egress.value), 2)
      description = element(split(",", egress.value), 3)
      self        = true
    }

  }

  tags = merge(
    {
      "Name" = format("%s_sg", var.identifier)
    },
    var.global_tags,
    var.sg_tags,
  )
}
