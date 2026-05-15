# AI Usage Log

## Overview

AI tools were used during this assignment to accelerate Terraform boilerplate generation, documentation drafting, and infrastructure design validation.

All generated outputs were reviewed, modified, and adapted for security, tenant isolation, and UK GDPR compliance considerations.

---

# Prompt 1

## Prompt

Create Terraform code for AWS VPC with public and private subnets across 2 availability zones.

## AI Output Used

Used Terraform templates for:
- VPC
- Public subnets
- Private application subnets
- Private database subnets

## Changes Made

- Updated CIDR ranges
- Added dedicated DB subnets
- Added naming conventions
- Improved resource tagging

---

# Prompt 2

## Prompt

Generate Terraform code for Internet Gateway, NAT Gateway, and Route Tables.

## AI Output Used

Used Terraform networking templates.

## Changes Made

- Modified route table associations
- Added NAT Gateway dependency handling
- Simplified routing structure for assignment scope

---

# Prompt 3

## Prompt

Create Terraform code for EC2 instances with separate security groups for Companies, Bureaus, and Employees.

## AI Output Used

Used EC2 and Security Group Terraform templates.

## Changes Made

- Added tenant-specific naming
- Added isolated security groups
- Restricted ingress rules
- Added IAM instance profiles

---

# Prompt 4

## Prompt

Generate Terraform code for PostgreSQL RDS in private subnets.

## AI Output Used

Used base RDS Terraform template.

## Changes Made

- Added DB subnet group
- Enabled encryption at rest
- Disabled public accessibility
- Added dedicated security group

---

# Prompt 5

## Prompt

Create Terraform code for S3 bucket with encryption and versioning enabled.

## AI Output Used

Used S3 Terraform templates.

## Changes Made

- Added server-side encryption
- Added versioning
- Structured tenant-specific prefixes

---

# Prompt 6

## Prompt

Generate IAM roles and policies for tenant isolation.

## AI Output Used

Used IAM role and policy templates.

## Changes Made

- Created separate IAM roles for:
  - Companies
  - Bureaus
  - Employees
- Added least-privilege access
- Restricted S3 access per tenant type

---

# Prompt 7

## Prompt

Provide README content for a secure AWS payroll infrastructure assignment.

## AI Output Used

Used README structure and documentation guidance.

## Changes Made

- Added security considerations
- Added UK GDPR notes
- Added assumptions section
- Added infrastructure explanations

---

# Prompt 8

## Prompt

Provide architecture guidance for a multi-tenant payroll platform on AWS.

## AI Output Used

Used architecture recommendations and network layout guidance.

## Changes Made

- Simplified architecture for assignment scope
- Added tenant isolation explanation
- Added private subnet segmentation

---

# Reflection

AI was primarily used to:
- Accelerate Terraform boilerplate generation
- Validate AWS architectural decisions
- Improve documentation quality
- Structure security and isolation strategies

All outputs were manually reviewed and adjusted to align with:
- Security best practices
- Multi-tenant isolation requirements
- UK GDPR considerations
- Assignment requirements

AI-generated code was not used blindly and was adapted where necessary to improve clarity, security, and maintainability.