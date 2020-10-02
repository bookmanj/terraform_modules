# output: region availability zones
output "aws-availability-zones" {
  value = data.aws_availability_zones.azs.names
}

# output: all of the vpc information
output "vpc_info" {
  description = "all of the vpc information"
  value       = aws_vpc.vpc
}

# output: vpc id
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

# output: vpc tags
output "vpc_tags" {
  description = "The tags of the VPC"
  value       = aws_vpc.vpc.tags
}

# output: internet gateway id
output "inet_gw_id" {
  value = aws_internet_gateway.inet_gw.id
}

# output: of public route table id
output "public_route_table_id" {
  description = "public route table ID"
  value       = aws_route_table.public_route.id
}

# output: public subnet ids
output "public_subnet_ids" {
  description = "Public Subnets IDS"
  value       = aws_subnet.public_subnet.*.id
}

# output: public subnet tags
output "public_subnet_tags" {
  description = "Public Subnets Tags"
  value       = aws_subnet.public_subnet.*.tags
}

# output: public subnent associations w\ public route table
output "public_subnet_assoc_ids" {
  value = aws_route_table_association.public_subnet_assoc.*.id
}

# output: nat gateway elastic ip address
output "nat_gw_eip_id" {
  value = aws_eip.nat_gw_eip.id
}

# output: nat gateway ip
output "nat_gw_id" {
  value = aws_nat_gateway.nat_gw.id
}

# output: private route table id
output "private_route_table_id" {
  description = "public route table ID"
  value       = aws_default_route_table.private_route.id
}

# output: private subnet ids
output "private_subnet_ids" {
  description = "Private Subnets IDS"
  value       = aws_subnet.private_subnet.*.id
}

# output: private subnet tags
output "private_subnet_tags" {
  description = "private subnet tags"
  value       = aws_subnet.private_subnet.*.tags
}

# output: private subnent associations w\ private route table
output "private_subnet_assoc_ids" {
  value = aws_route_table_association.private_subnet_assoc.*.id
}
