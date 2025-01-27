output "id" {
  description = "The unique identifier of the EC2 instance, used to manage and reference the instance."
  value       = aws_instance.ec2.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the EC2 instance, uniquely identifying it across AWS."
  value       = aws_instance.ec2.arn
}

output "instance_type" {
  description = "The instance type of the EC2 instance, defining its compute and memory capacity (e.g., t2.micro)."
  value       = aws_instance.ec2.instance_type
}

output "availability_zone" {
  description = "The Availability Zone where the EC2 instance is launched."
  value       = aws_instance.ec2.availability_zone
}

output "key_name" {
  description = "The name of the key pair used for SSH access to the EC2 instance."
  value       = aws_instance.ec2.key_name
}

output "private_ip" {
  description = "The private IP address assigned to the EC2 instance, used for internal communication within the VPC."
  value       = aws_instance.ec2.private_ip
}

output "private_dns" {
  description = "The private DNS name of the EC2 instance, accessible within the VPC."
  value       = aws_instance.ec2.private_dns
}

output "public_ip" {
  description = "The public IP address assigned to the EC2 instance, used for external communication."
  value       = aws_instance.ec2.public_ip
}

output "public_dns" {
  description = "The public DNS name of the EC2 instance, which can be used to connect to the instance."
  value       = aws_instance.ec2.public_dns
}

output "subnet_id" {
  description = "The ID of the subnet in which the EC2 instance is deployed."
  value       = aws_instance.ec2.subnet_id
}

output "vpc_security_group_ids" {
  description = "The list of security group IDs attached to the EC2 instance."
  value       = aws_instance.ec2.vpc_security_group_ids
}

output "root_block_device" {
  description = "Details of the root block device attached to the EC2 instance."
  value       = aws_instance.ec2.root_block_device
}

output "tags" {
  description = "A map of tags assigned to the EC2 instance."
  value       = aws_instance.ec2.tags
}