# Task 2 – Multi-Tenancy Architecture

# Overview

The payroll platform serves three distinct tenant types:

- Companies
- Bureaus
- Employees

Each tenant type must remain fully isolated from the others at both the application and infrastructure layers.

The architecture follows a defense-in-depth security model to prevent cross-tenant access even in the event of application-level failures.

---

# 2a. Tenant Isolation Strategy

## Selected Tenancy Model

The platform uses:

```text
Shared Database with tenant_id isolation + Row Level Security (RLS)
```

---

# Why This Model Was Chosen

This model was selected because it provides:

- Better scalability
- Lower operational overhead
- Centralized reporting and management
- Reduced infrastructure cost
- Easier backup and monitoring management

Although payroll data is highly sensitive, security is enforced through multiple isolation layers:

- JWT-based tenant context
- Application-level authorization
- PostgreSQL Row Level Security (RLS)
- IAM restrictions
- S3 prefix isolation
- Security Groups and subnet segmentation

This approach balances security, scalability, and maintainability.

---

# Database Design

Every business table contains:

```sql
tenant_id
```

Example:

```sql
CREATE TABLE payroll_records (
    id UUID PRIMARY KEY,
    tenant_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    salary NUMERIC,
    created_at TIMESTAMP
);
```

---

# Tenant Context Establishment

## Login Flow

1. User authenticates using username/password or SSO
2. Identity service validates credentials
3. JWT token is issued
4. JWT contains:
   - user_id
   - tenant_id
   - tenant_type
   - role

Example JWT payload:

```json
{
  "user_id": "123",
  "tenant_id": "company_abc",
  "tenant_type": "company",
  "role": "admin"
}
```

---

# Request Lifecycle Propagation

For every API request:

1. JWT token is validated
2. Middleware extracts tenant_id
3. tenant_id is injected into application context
4. All database queries are automatically filtered using tenant_id

---

# Preventing Cross-Tenant Data Leakage

Every database query is scoped using tenant_id.

Example:

```sql
SELECT *
FROM payroll_records
WHERE tenant_id = current_tenant_id;
```

---

# PostgreSQL Row Level Security (RLS)

Additional protection is implemented using PostgreSQL RLS policies.

Example:

```sql
CREATE POLICY tenant_isolation_policy
ON payroll_records
USING (tenant_id = current_setting('app.current_tenant')::UUID);
```

This ensures that even if application filtering fails, the database itself prevents unauthorized access.

---

# Employee-Level Restrictions

Employees can only access their own payroll records.

Example query:

```sql
SELECT *
FROM payroll_records
WHERE tenant_id = current_tenant_id
AND employee_id = current_user_id;
```

---

# Bureau Access Restrictions

Bureaus can only access companies assigned to them.

This is enforced through mapping tables:

```sql
bureau_company_mapping
```

All bureau queries validate assignment relationships before returning data.

---

# 2b. Access Boundaries at Infrastructure Layer

# IAM Isolation

Separate IAM roles are created for:

- Company services
- Bureau services
- Employee services

Each role follows least-privilege access principles.

---

# IAM Examples

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

# Bureau Role

Can access:

```text
s3://payroll-documents/bureau/*
```

---

# Employee Role

Can access:

```text
s3://payroll-documents/employee/*
```

---

# S3 Isolation Strategy

The S3 bucket uses tenant-specific prefixes:

```text
company/
bureau/
employee/
```

Bucket policies restrict access by IAM role.

Example:

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject"
  ],
  "Resource": "arn:aws:s3:::payroll-documents/company/*"
}
```

---

# Defense in Depth

Even if application tenant filtering fails:

- IAM policies still restrict AWS resource access
- RLS still restricts database access
- Security Groups prevent unauthorized network access
- Separate EC2 security groups isolate tenant services

This ensures multiple independent enforcement boundaries.

---

# Network Isolation

The infrastructure includes:

- Separate Security Groups per tenant type
- Private subnets for backend services
- Private subnets for databases
- Restricted NACL rules
- No public database exposure

---

# 2c. Tenant Onboarding & Offboarding

# Tenant Onboarding Process

When a new Company or Bureau is onboarded:

## Step 1 – Tenant Record Creation

A new tenant record is created in the platform database.

Example:

```text
tenant_id = company_xyz
```

---

## Step 2 – IAM Scope Assignment

Tenant-specific IAM permissions are assigned.

Example:

```text
company_xyz -> company role
```

---

## Step 3 – S3 Prefix Provisioning

Dedicated logical storage path is created:

```text
company/company_xyz/
```

---

## Step 4 – User Provisioning

Tenant admin users are created with scoped roles.

---

## Step 5 – Audit Logging

Tenant creation events are logged for compliance and traceability.

---

# Tenant Isolation From Day One

Every tenant receives:

- Unique tenant_id
- Scoped IAM permissions
- Isolated S3 prefixes
- Application-level authorization boundaries
- Database-level filtering

This ensures zero cross-tenant visibility from onboarding onward.

---

# Tenant Offboarding Process

When a tenant is offboarded:

## Step 1 – Access Revocation

- Disable user accounts
- Revoke JWT tokens
- Remove IAM access

---

## Step 2 – Data Export (Optional)

If contractually required, payroll data export is generated securely.

---

## Step 3 – Secure Data Deletion

The following data is deleted:

- Database records
- S3 documents
- Cached files
- Temporary exports

Deletion follows UK GDPR right-to-erasure requirements.

---

# Audit Trail

Offboarding activities are logged including:

- who performed deletion
- timestamp
- affected tenant
- deleted resources

---

# Backup & Retention Handling

Backups containing tenant data are retained according to compliance retention policies and securely expired after retention periods.

---

# Conclusion

The platform uses a layered multi-tenant security architecture combining:

- Application-level tenant isolation
- Database Row Level Security
- IAM least-privilege enforcement
- S3 prefix isolation
- Network segmentation

This design minimizes cross-tenant exposure risk while remaining scalable, maintainable, and compliant with UK payroll security requirements.