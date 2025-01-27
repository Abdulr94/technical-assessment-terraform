module "network_vpc" {
  source  = "./modules/vpc"
  vpc_cidr    = "10.0.0.0/16"
  vpc_name    = "Production-Application-VPC"
  subnets = {
    "app-public-01" = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    },
    "app-public-02" = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    },
    "app-public-03" = {
      cidr = "10.0.3.0/24"
      az   = "us-east-1c"
    },
    "app-private-01" = {
      cidr = "10.0.4.0/24"
      az   = "us-east-1a"
    },
    "app-private-02" = {
      cidr = "10.0.5.0/24"
      az   = "us-east-1b"
    },
    "app-private-03" = {
      cidr = "10.0.6.0/24"
      az   = "us-east-1c"
    }
  }
}

module "network_nat_gateway" {
  source      = "./modules/vpc"
  nat_gateways = [{
    name      = "nat-prod"
    subnet_id =module.network_vpc.subnetid[0]["app-public-01"]["id"]
  }]
  depends_on = [module.network_vpc]
}

module "network_route_tables" {
  source     = "./modules/vpc"
  vpc_id     = module.network_vpc.vpcid[0]
  route_maps = {
    "public-routes" = {
      routes = [
        {
          cidr_block = "0.0.0.0/0"
          gateway_id = module.network_vpc.igw_id[0]
        }
      ]
    },
    "private-routes" = {
      routes = [
        {
          cidr_block    = "0.0.0.0/0"
          nat_gateway_id = module.network_nat_gateway.nat_gwid[0]["0"]["id"]
        }
      ]
    }
  }
  depends_on = [module.network_vpc, module.network_nat_gateway]
}

module "network_rtb_associations" {
  source           = "./modules/vpc"
  route_association = [{
    rtb_id   = module.network_route_tables.rtb_id[0]["private-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-private-01"]["id"]
  },
  {
    rtb_id   = module.network_route_tables.rtb_id[0]["private-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-private-02"]["id"]
  },
  {
    rtb_id   = module.network_route_tables.rtb_id[0]["private-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-private-03"]["id"]
  },
  {
    rtb_id   = module.network_route_tables.rtb_id[0]["public-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-public-01"]["id"]
  },
  {
    rtb_id   = module.network_route_tables.rtb_id[0]["public-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-public-02"]["id"]
  },
  {
    rtb_id   = module.network_route_tables.rtb_id[0]["public-routes"]["id"]
    subnet_id =module.network_vpc.subnetid[0]["app-public-03"]["id"]
  }
  ]
  depends_on = [module.network_route_tables]
}

module "app_sg" {
  source             = "./modules/network-security-group"
  name               = "Application-Security-Group"
  description        = "Security group for production application servers"
  vpc_id             = module.network_vpc.vpcid[0]
  ingress_rules = [{
    cidr     = "0.0.0.0/0"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  },
  {
    cidr     = "0.0.0.0/0"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }]
  egress_rules = [{
    cidr     = "0.0.0.0/0"
    protocol = "-1"
  }]
  depends_on = [module.network_vpc]
}

module "web_ec2_instance" {
  source             = "./modules/ec2-instance"
  ec2name               = "web-server"
  subnet_id          =module.network_vpc.subnetid[0]["app-public-01"]["id"]
  publicip = true
  keypair           = "prod-ssh-key"
  sgList =  [ module.app_sg.sg_id]
  depends_on         = [module.app_sg]
}

module "backend_ec2_instance" {
  source             = "./modules/ec2-instance"
  ec2name               = "backend-server"
  subnet_id          =module.network_vpc.subnetid[0]["app-private-01"]["id"]
  publicip = false
    sgList = [ module.app_sg.sg_id]
  keypair           = "prod-ssh-key"
  depends_on         = [module.app_sg]
}

output "vpc_id" {
  description = "The unique identifier of the VPC created for the production application."
  value       = module.network_vpc.vpcid[0]
}

output "subnet_public_app01" {
  description = "The ID of the first public subnet (app-public-01) created within the VPC."
  value       = module.network_vpc.subnetid[0]["app-public-01"]["id"]
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway created to allow outbound traffic from private subnets."
  value       = module.network_nat_gateway.nat_gwid[0]["0"]["id"]
}

output "app_sg_id" {
  description = "The ID of the security group created for the application."
  value       = module.app_sg.sg_id
}

output "web_server_id" {
  description = "The unique identifier of the web server EC2 instance deployed in the public subnet."
  value       = module.web_ec2_instance.id
}

output "web_server_privateip" {
  description = "The Private IP of the web server EC2 instance deployed in the private subnet."
  value       = module.web_ec2_instance.private_ip
}

output "backend_server_id" {
  description = "The unique identifier of the backend server EC2 instance deployed in the private subnet."
  value       = module.backend_ec2_instance.id
}

output "backend_server_privateip" {
  description = "The Public IP of the web server EC2 instance deployed in the private subnet."
  value       = module.backend_ec2_instance.private_ip
}