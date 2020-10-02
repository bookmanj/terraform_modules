
# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.vpc_tenancy
  enable_dns_support   = var.vpc_dns_support
  enable_dns_hostnames = var.vpc_dns_hostname

  tags = {
    Name = var.vpc_name
  }
}

# create internet gateway
resource "aws_internet_gateway" "inet_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# create public route table and add route to inet_gw
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.all_traffic_cidr
    gateway_id = aws_internet_gateway.inet_gw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# public subnet creation using a list of cidrs
resource "aws_subnet" "public_subnet" {
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  count                   = length(var.public_cidr_list)
  cidr_block              = element(var.public_cidr_list, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.public_ip_on_launch

  tags = {
    Name = "${var.public_subnets_prefix}_${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_cidr_list)
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
}

# request and elastic IP for nat gw
resource "aws_eip" "nat_gw_eip" {
  vpc = true

  tags = {
    Name = var.nat_gw_eip_name
  }
}

# create nat gateway, add to the first public subnet & assign eip
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet.0.id

  tags = {
    Name = var.nat_gw_name
  }
}

# modify the default route table, add route to nat_gw & add private route table name
resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    cidr_block     = var.all_traffic_cidr
  }

  tags = {
    Name = var.private_route_name
  }
}

# private subnet creation using a list of cidrs
resource "aws_subnet" "private_subnet" {
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  count             = length(var.private_cidr_list)
  cidr_block        = element(var.private_cidr_list, count.index)
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${var.private_subnets_prefix}_${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

# associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = length(var.private_cidr_list)
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
}




