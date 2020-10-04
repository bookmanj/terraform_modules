output "vpc_info" {
  description = "all of the vpc information"
  value       = aws_vpc.this
}

output "inet_gw_info" {
  description = "internet gateway information"
  value       = aws_internet_gateway.this
}

output "public_route_table_info" {
  description = "public route table information"
  value       = aws_route_table.this_public
}

output "public_subnet_info" {
  description = "public subnets information"
  value       = aws_subnet.this_public
}

output "public_subnet_association_info" {
  description = "public subnets association information"
  value       = aws_route_table_association.this_public
}

output "nat_gw_eip_info" {
  description = "nat gateway information"
  value       = aws_eip.this
}

output "private_route_table_info" {
  description = "private route table information"
  value       = aws_route_table.this_private
}

output "private_subnet_info" {
  description = "private subnets information"
  value       = aws_subnet.this_private
}

output "private_subnet_association_info" {
  description = "private subnets association information"
  value       = aws_route_table_association.this_private
}

# output: region availability zones
#output "aws-availability-zones" {
#  value = data.aws_availability_zones.azs.names
#}
