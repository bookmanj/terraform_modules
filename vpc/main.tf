locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.private_subnets)
}

# vpc
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name" = format("%s_vpc", var.identifier)
    },
    var.global_tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id     = aws_vpc.this[0].id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

# internet gateway
resource "aws_internet_gateway" "this" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      "Name" = format("%s_inet_gw", var.identifier)
    },
    var.global_tags,
    var.igw_tags,
  )
}

# public route table w\ route to internet gateway
resource "aws_route_table" "this_public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(
    {
      "Name" = format("%s_${var.public_subnet_suffix}", var.identifier)
    },
    var.global_tags,
    var.public_route_table_tags,
  )
}

# public subnet
resource "aws_subnet" "this_public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  cidr_block              = element(var.public_subnets, count.index)
  vpc_id                  = aws_vpc.this[0].id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "%s_${var.public_subnet_suffix}_%s",
        var.identifier,
        element(data.aws_availability_zones.azs.names, count.index),
      )
    },
    var.global_tags,
    var.public_subnet_tags,
  )
}

# associate public subnet(s) with public route table
resource "aws_route_table_association" "this_public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  route_table_id = aws_route_table.this_public[0].id
  subnet_id      = aws_subnet.this_public.*.id[count.index]
}

# elastic IP
resource "aws_eip" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "%s_eip_%s",
        var.identifier,
        element(data.aws_availability_zones.azs.names, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.global_tags,
    var.nat_eip_tags,
  )
}

# nat gateway
resource "aws_nat_gateway" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    aws_eip.this[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.this_public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "%s_nat_gw_%s",
        var.identifier,
        element(data.aws_availability_zones.azs.names, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.global_tags,
    var.nat_gateway_tags,
  )
}

# private route table w\ route to nat gateway
resource "aws_route_table" "this_private" {
  count = var.create_vpc && local.nat_gateway_count > 0 ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.this[0].id
  route {
    nat_gateway_id = element(
      aws_nat_gateway.this[*].id,
      var.single_nat_gateway ? 0 : count.index,
    )
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.identifier}_${var.private_subnet_suffix}" : format(
        "%s_${var.private_subnet_suffix}_%s",
        var.identifier,
        element(data.aws_availability_zones.azs.names, count.index),
      )
    },
    var.global_tags,
    var.private_route_table_tags,
  )
}

# private subnet
resource "aws_subnet" "this_private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s_${var.private_subnet_suffix}_%s",
        var.identifier,
        element(data.aws_availability_zones.azs.names, count.index),
      )
    },
    var.global_tags,
    var.private_subnet_tags,
  )
}

# associate private subnet(s) with private route table
resource "aws_route_table_association" "this_private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id = aws_subnet.this_private.*.id[count.index]
  route_table_id = element(
    aws_route_table.this_private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}
