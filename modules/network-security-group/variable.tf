variable "name" {
  description = "Name of the Secueity Group"
  type        = string
}

variable "description" {
  description = "Description of the securityGroup"
  type        = string
  default     = "Default SG"
}

variable "vpc_id" {
  description = "VPC ID for the security Grouo"
  type        = string
}

variable "ingress_rules" {
  description = "Rules for the securityGroup"
  type = list(object({
    cidr     = string
    from_port = number
    protocol = string
    to_port   = number
  }))
}

variable "egress_rules" {
  description = "Rules for the securityGroup"
  type = list(object({
    cidr     = string
    protocol = string
  }))
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default = {
    "ManagedBy" = "Terraform"
  }
}