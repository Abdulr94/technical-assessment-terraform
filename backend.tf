terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket         	   = "prod-terraform-backend-remote-tf-state"
    key              	 = "terraform/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table     = "terraform-state-lock-table"
  }
}