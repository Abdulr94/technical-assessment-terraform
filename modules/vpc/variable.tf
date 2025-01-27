variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default = null
}

variable "vpc_id" {
  description = "ID of the VPC"
  type = string
  default = null
}

variable "vpc_cidr" {
  description = "The CIDR Range of the VPC"
  type        = string
  default = null
}

variable "subnets" {
  type = map(object({
    cidr = string
    az         = optional(string)
  }))
  default = {}
}

variable "nat_gateways" {
  description = "Name of the Nat Gateway"
  type = list(object({
    name = optional(string)
    subnet_id       = optional(string)
  }))
  default = []
}

variable "route_association" {
  description = "Subnet and Route Table Association"
  type = list(object({
    rtb_id     = string
    subnet_id = string
  }))
  default = []
}

variable "route_maps" {
  description = "Mapping of route table definitions"
  type = map(object({
    routes = list(object({
      cidr_block           = optional(string, null)
      gateway_id           = optional(string, null)
      nat_gateway_id        = optional(string, null)
      egress_only_gateway_id = optional(string, null)
    }))
  }))
  default = {}
}


variable "vpcID" {
  description = "VPC ID"
  type        = string
  default     = null
}