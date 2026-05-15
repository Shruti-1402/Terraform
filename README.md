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

- RDS is deployed in private subnets with no public access.
- EC2 instances use separate security groups for tenant isolation.
- IAM roles enforce least-privilege access.
- S3 encryption and versioning are enabled.
- Network ACLs restrict unnecessary traffic.
- Region eu-west-2 supports UK GDPR data residency requirements.

---

# Assumptions

- Infrastructure is designed for demonstration purposes.
- NAT Gateway is deployed in a single AZ to reduce cost.
- AWS Secrets Manager should be used in production for DB credentials.
- SSH access should ideally be restricted through VPN or AWS SSM Session Manager.
- Auto Scaling and Load Balancer are excluded from Task 1 scope.

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



# Task 6 – UK Compliance Considerations

# 1. AWS-Native Controls for UK GDPR Compliance

To support UK GDPR compliance while handling employee PII and bank data, the following AWS-native security controls would be implemented:

## Encryption

- AWS KMS encryption for RDS and S3
- TLS/HTTPS encryption for all data in transit
- Encrypted EBS volumes for EC2 instances

---

## Access Control

- IAM least-privilege access policies
- Role-based access control (RBAC)
- Multi-factor authentication (MFA) for administrative users

---

## Monitoring & Auditing

- AWS CloudTrail for API auditing
- AWS Config for compliance monitoring
- CloudWatch Logs for operational visibility
- GuardDuty for threat detection

---

## Secrets Management

Sensitive values would be stored using:

- AWS Secrets Manager
- AWS Systems Manager Parameter Store

No hardcoded credentials would be stored in code repositories or CI/CD pipelines.

---

## Network Security

- Private subnets for databases
- Security Groups and NACL restrictions
- No public database exposure

---

# 2. Ensuring UK/EU Data Residency

To comply with UK/EU data residency requirements:

- Infrastructure is deployed in:
  
```text
eu-west-2 (London)
```

- Backups and snapshots remain within UK/EU AWS regions
- Cross-region replication outside UK/EU is disabled
- S3 buckets and RDS instances are provisioned only within approved UK/EU regions

This helps ensure payroll and employee data remains within compliant geographic boundaries.

---

# 3. Right to Erasure (Permanent Data Deletion)

If an employee requests permanent deletion of their data, the following process would be followed:

## Step 1 – Identity Verification

Verify the identity and authorization of the requestor before processing deletion.

---

## Step 2 – Application Data Deletion

Delete employee-related records from:

- payroll tables
- profile tables
- authentication systems
- cached application data

---

## Step 3 – S3 Document Deletion

Delete:

- payroll reports
- uploaded documents
- exported files

from tenant-specific S3 storage locations.

---

## Step 4 – Backup Retention Handling

Data scheduled for deletion would also be removed from backup systems according to retention and compliance policies.

Expired backups containing deleted employee data would be securely destroyed.

---

## Step 5 – Access Revocation

Revoke:

- active sessions
- tokens
- credentials
- linked integrations

associated with the employee account.

---

## Step 6 – Audit Logging

The deletion request and completion process would be logged for compliance and auditability.

Logs would include:

- deletion timestamp
- affected systems
- operator identity
- request reference

---

# Conclusion

The platform design incorporates:

- encryption
- least-privilege access
- monitoring
- auditability
- secure deletion processes

to support secure handling of sensitive payroll data and align with UK GDPR compliance requirements.