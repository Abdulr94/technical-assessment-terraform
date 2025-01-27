# Terraform Network and EC2 Deployment Guide

This guide outlines the steps to deploy the Virtual Private Cloud (VPC), networking resources, and EC2 instances with GitHub Actions using Terraform.

## Setup Instructions

### 1. Initialize Infrastructure

**Navigate to GitHub Actions:**

- Access the Actions tab in your GitHub repository.

**Trigger the Workflow:**

- Execute the workflow from `.github/workflows/terraform.yml`.

**Provide Necessary Parameters:**

- Input the required values for the Terraform modules defined within the `modules` directory.

### 2. Key Files in the Configuration

- **main.tf**: This file houses the entire infrastructure setup, including the VPC, subnets, NAT Gateway, route tables, security groups, and EC2 instances.
- **backend.tf**: Defines the backend configuration using an S3 bucket to store Terraform state.

### 3. Module Breakdown

#### VPC Module

This module configures a Virtual Private Cloud (VPC) with both public and private subnets:

- **VPC CIDR Block**: `10.0.0.0/16`

**Subnets:**

- **Public Subnets:**
  - `10.0.1.0/24` in Availability Zone `us-east-1a`
  - `10.0.2.0/24` in Availability Zone `us-east-1b`
  - `10.0.3.0/24` in Availability Zone `us-east-1c`
  
- **Private Subnets:**
  - `10.0.4.0/24` in Availability Zone `us-east-1a`
  - `10.0.5.0/24` in Availability Zone `us-east-1b`
  - `10.0.6.0/24` in Availability Zone `us-east-1c`

#### NAT Gateway Module

This module sets up a NAT Gateway within the public subnet to provide internet access for instances in private subnets:

- **NAT Gateway Name**: `nat-prod`
- **Subnet**: `app-public-01` in `us-east-1a`

#### Route Tables Module

This module configures public and private route tables:

- **Public Route Table**:
    - Routes traffic (`0.0.0.0/0`) to the internet gateway.
    
- **Private Route Table**:
    - Routes traffic (`0.0.0.0/0`) to the NAT Gateway.

#### Route Table Association Module

Associates subnets with the appropriate route tables:

- Public subnets are linked with the **public route table**.
- Private subnets are linked with the **private route table**.

#### Security Group Module

Defines a security group for the application EC2 instances:

- **Ingress Rules**:
    - Allows HTTP (`80/tcp`) and HTTPS (`443/tcp`) traffic from anywhere (`0.0.0.0/0`).
    
- **Egress Rules**:
    - Permits all outbound traffic (`-1` protocol).

#### EC2 Instance Modules

- **Web EC2 Instance** (`web-server`):
    - **Subnet**: `app-public-01`
    - **Public IP**: Enabled
    - **Security Group**: Assigned from the security group module.
    - **SSH Key**: `prod-ssh-key`
    
- **Backend EC2 Instance** (`backend-server`):
    - **Subnet**: `app-private-01`
    - **Public IP**: Disabled
    - **Security Group**: Assigned from the security group module.
    - **SSH Key**: `prod-ssh-key`

### 4. GitHub Secrets Configuration

Ensure the following secrets are stored in your GitHub repository:

- **AWS_ACCESS_KEY_ID**: Your AWS access key.
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key.

### 5. Expected Outcome

Once the Terraform plan is applied successfully, the following resources will be created:

- **VPC**: A new Virtual Private Cloud for your production application.
- **Subnets**: Public and private subnets spanning three availability zones.
- **NAT Gateway**: Allows internet access from private subnets.
- **Route Tables**: Defines routes for public and private subnets.
- **Security Groups**: Handles inbound and outbound traffic rules for EC2 instances.
- **EC2 Instances**:
    - A web server (`web-server`) in the public subnet for user-facing services.
    - A backend server (`backend-server`) in the private subnet for backend services.

### 6. Terraform Outputs

The following output values will be generated:

- **VPC ID**: The unique ID of the VPC created for the application.
- **Subnet IDs**:
    - Public Subnet (app-public-01)
    - Private Subnet (app-private-01)
- **NAT Gateway ID**: The ID of the NAT Gateway allowing private subnets to access the internet.
- **Security Group ID**: The ID of the security group associated with the application.
- **EC2 Instance IDs**:
    - `web-server`: The EC2 instance ID for the web server deployed in the public subnet.
    - `backend-server`: The EC2 instance ID for the backend server deployed in the private subnet.

Once the workflow completes, your infrastructure will be up and running, and you’ll have a fully operational environment with a VPC, NAT Gateway, route tables, security groups, and EC2 instances for your application.
