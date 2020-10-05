terraform {
  required_providers {
    aws = {
      version = "~> 3.8.0"
    }
  }
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = var.user_data
  user_data_base64       = var.user_data_base64
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  get_password_data      = var.get_password_data
  monitoring             = var.monitoring
  placement_group        = var.placement_group

  subnet_id = var.seperate_subnet_ids && length(var.subnet_ids) == var.instance_count ? element(var.subnet_ids, count.index) : element(var.subnet_ids, 0)

  tags = merge(
    {
      "Name" = var.seperate_subnet_ids && length(var.subnet_ids) == var.instance_count ? format("%s_ec2_%s", var.identifier, count.index + 1) : format("%s_ec2", var.identifier)
    },
    var.global_tags,
    var.ec2_tags,
  )
}
