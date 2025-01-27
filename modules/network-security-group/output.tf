output "sg_id" {
  description = "The unique identifier of the security group, used to manage inbound and outbound traffic for resources."
  value       = aws_security_group.sg.id
}

output "sg_arn" {
  description = "The Amazon Resource Name (ARN) of the security group, uniquely identifying it across AWS."
  value       = aws_security_group.sg.arn
}

output "sg_owner" {
  description = "The AWS account ID of the owner of the security group."
  value       = aws_security_group.sg.owner_id
}
