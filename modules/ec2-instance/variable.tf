variable "ec2name" {
  description = "Name of the EC2 Instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID of the EC2 Instance"
  type        = string
  default     = "ami-0ac4dfaf1c5c0cce9"
}

variable "family" {
  description = "EC2 Family"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID to place the EC2 Instance"
  type        = string
}

variable "publicip" {
  description = "Enable Public IP for the instance"
  type        = bool
  default     = false
}

variable "keypair" {
  description = "Provide the keypair name of the manually created key"
  type = string
  default = null
}

variable "sgList" {
  description = "List of securityGroups to associate with EC2 Instance"
  type = list(string)
  default = []
}