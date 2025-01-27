output "vpcid" {
  description = "The unique identifier of the Virtual Private Cloud (VPC) where all resources are provisioned."
  value       = aws_vpc.vpc[*].id
}

output "vpcarn" {
  description = "The Amazon Resource Name (ARN) of the VPC, uniquely identifying it across AWS."
  value       = aws_vpc.vpc[*].arn
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with the VPC, used as the default for any subnets without explicit associations."
  value       = aws_vpc.vpc[*].main_route_table_id
}

output "default_security_group_id" {
  description = "The ID of the default security group created with the VPC, used to control network traffic for resources."
  value       = aws_vpc.vpc[*].default_security_group_id
}

output "igw_id" {
  description = "The unique identifier of the Internet Gateway attached to the VPC, enabling internet connectivity for public subnets."
  value       = aws_internet_gateway.igw[*].id
}

output "nat_gwid" {
  description = "The unique identifiers of the NAT Gateways, used to provide outbound internet connectivity for private subnets."
  value       = aws_nat_gateway.natgw[*]
}

output "rtb_id" {
  description = "The unique identifiers of the route tables in the VPC, which define routing rules for subnets."
  value       = aws_route_table.route-tb[*]
}

output "subnetid" {
  description = "The unique identifiers of the subnets within the VPC, categorized into public and private subnets."
  value       = aws_subnet.subnet[*]
}
