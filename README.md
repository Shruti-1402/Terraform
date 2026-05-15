# Terraform
# Oceans Across – DevOps Technical Assignment

## Project Overview

This project demonstrates a secure AWS infrastructure design for a multi-tenant payroll platform serving:

- Companies
- Bureaus
- Employees

The infrastructure is provisioned using Terraform with strong security and tenant isolation principles.

---

# AWS Services Used

- VPC
- EC2
- RDS PostgreSQL
- S3
- IAM
- Security Groups
- NACLs
- NAT Gateway
- Internet Gateway

---

# Infrastructure Design

## VPC Architecture

The infrastructure uses:

- Public subnets across 2 Availability Zones
- Private application subnets
- Private database subnets
- NAT Gateway for secure outbound internet access

---

# Compute Isolation

Separate EC2 instances are provisioned for:

- Company services
- Bureau services
- Employee services

This ensures isolation at the compute layer.

---

# Database Security

RDS PostgreSQL is configured with:

- Private subnet deployment
- Encryption enabled
- Public access disabled
- Dedicated security groups

---

# S3 Security

The S3 bucket includes:

- Versioning enabled
- Server-side encryption enabled
- Tenant-specific logical separation

Example:

company/
bureau/
employee/

---

# IAM Strategy

Separate IAM roles are created for:

- Company services
- Bureau services
- Employee services

This enforces least privilege access.

---

# Security Features

- Private subnet isolation
- Security Group restrictions
- NACL restrictions
- Encryption at rest
- Controlled ingress and egress
- No public database access

---

# Region Selection

Region used:

eu-west-2 (London)

This supports UK GDPR data residency requirements.

---

# Terraform Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply