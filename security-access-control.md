# Task 3 – Security & Access Control

# Overview

Security is the most critical requirement for the payroll platform because the system handles highly sensitive employee data including:

- Payroll records
- Bank account information
- Personal identifiable information (PII)
- Tax-related data

The platform uses a defense-in-depth security architecture with multiple independent security layers.

---

# 3a. IAM & Role-Based Access Control

# IAM Strategy

The platform uses AWS IAM roles with strict least-privilege permissions.

Separate IAM roles are provisioned for:

- Company services
- Bureau services
- Employee services

Each role is restricted to only the AWS resources required for its function.

---

# Tenant Isolation Using IAM

## Company Role

Can access:

```text
s3://payroll-documents/company/*
```

Cannot access:

```text
s3://payroll-documents/bureau/*
s3://payroll-documents/employee/*
```

---

## Bureau Role

Can access:

```text
s3://payroll-documents/bureau/*
```

Cannot access Company or Employee resources.

---

## Employee Role

Can access:

```text
s3://payroll-documents/employee/*
```

Cannot access Company or Bureau resources.

---

# Example IAM Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::payroll-documents/company/*"
    }
  ]
}
```

---

# Least Privilege Enforcement

All IAM permissions follow least-privilege principles:

- No wildcard administrative access
- No cross-tenant permissions
- No shared IAM roles across tenant types
- Access limited to required services only

---

# Credential Security

No hardcoded credentials are stored in:

- Terraform files
- GitHub repositories
- CI/CD pipelines
- Application source code

Sensitive values are managed using AWS-native secret management services.

---

# 3b. Secrets Management

# Secrets Storage

Sensitive values are stored using:

- AWS Secrets Manager
- AWS Systems Manager Parameter Store

Examples:

- Database credentials
- API keys
- JWT signing secrets
- SMTP credentials

---

# Example Secret Structure

```json
{
  "username": "postgres",
  "password": "secure_password"
}
```

---

# Runtime Secret Injection

Applications retrieve secrets dynamically during runtime using IAM permissions.

Example flow:

1. EC2 instance assumes IAM role
2. IAM role grants read access to secret
3. Application fetches secret from Secrets Manager
4. Secret loaded into memory only

Secrets are never:

- committed to Git
- exposed in logs
- hardcoded in environment files

---

# Example Retrieval Flow

```text
Application → IAM Role → Secrets Manager → Temporary Secret Access
```

---

# Secret Rotation

Secrets Manager automatic rotation can be enabled for:

- RDS passwords
- API credentials
- Service authentication tokens

This reduces long-term credential exposure risk.

---

# 3c. Encryption

# Encryption at Rest

## RDS Encryption

RDS PostgreSQL uses:

- AWS-managed KMS encryption
- encrypted storage volumes
- encrypted automated backups

Terraform example:

```hcl
storage_encrypted = true
```

---

# S3 Encryption

S3 uses server-side encryption:

```hcl
sse_algorithm = "AES256"
```

This protects payroll documents and reports stored in S3.

---

# Encryption in Transit

All external services use:

```text
HTTPS / TLS 1.2+
```

This includes:

- Web applications
- APIs
- Internal service communication

---

# SSL/TLS Configuration

TLS certificates would be managed using:

- AWS ACM (AWS Certificate Manager)

HTTPS termination would typically occur at:

- Application Load Balancer (ALB)

---

# Internal Service Communication

Data in transit between services is protected using:

- TLS encryption
- Private subnet communication
- Security Group restrictions

Internal services never communicate over public internet paths.

---

# Database Connection Security

Applications connect to PostgreSQL using SSL-enabled connections.

Example:

```text
sslmode=require
```

---

# 3d. Network Security

# Network Segmentation

The infrastructure uses:

- Public subnets
- Private application subnets
- Private database subnets

Sensitive services are isolated inside private subnets.

---

# Public Access Restrictions

## Database

RDS PostgreSQL:

- NOT publicly accessible
- Only reachable from backend EC2 security groups

Terraform example:

```hcl
publicly_accessible = false
```

---

# Security Groups

Separate Security Groups are created for:

- Company EC2
- Bureau EC2
- Employee EC2
- RDS PostgreSQL

Only required ports are allowed.

---

# Example Security Rules

## EC2

Allowed:

- SSH (restricted admin access)
- Application ports

Blocked:

- unnecessary inbound traffic

---

## RDS

Allowed:

- PostgreSQL port 5432 only from backend services

Blocked:

- direct internet access
- public access

---

# Network ACLs

NACLs provide subnet-level filtering.

Rules restrict:

- unauthorized ports
- unwanted protocols
- lateral movement between environments

---

# Tenant Traffic Isolation

Tenant isolation is enforced through multiple layers:

- Separate EC2 instances
- Separate Security Groups
- IAM restrictions
- PostgreSQL Row Level Security
- S3 prefix isolation
- Private subnet segmentation

This prevents one tenant's traffic from reaching another tenant's compute or data layer.

---

# Defense-in-Depth Security Model

The platform uses layered security controls:

| Layer | Protection |
|---|---|
| IAM | AWS resource isolation |
| Security Groups | Traffic filtering |
| NACLs | Subnet filtering |
| RLS | Database isolation |
| S3 Policies | Object-level isolation |
| TLS | Encryption in transit |
| KMS Encryption | Encryption at rest |

Even if one security layer fails, additional layers continue protecting tenant data.

---

# Logging & Monitoring

Security events should be monitored using:

- AWS CloudTrail
- CloudWatch Logs
- GuardDuty
- AWS Config

This improves visibility, compliance, and incident response readiness.

---

# Conclusion

The payroll platform is designed with a security-first architecture using:

- least-privilege IAM
- encryption at rest and in transit
- private network isolation
- tenant-specific access controls
- layered defense mechanisms

This design minimizes the risk of unauthorized access and supports secure handling of sensitive UK payroll data.