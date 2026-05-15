# Task 5 – Monitoring & Incident Readiness

# Overview

The payroll platform requires strong observability and incident response capabilities due to the sensitive nature of payroll and employee data.

Monitoring is implemented using AWS-native observability services including:

- Amazon CloudWatch
- Amazon SNS
- CloudWatch Logs

The monitoring strategy focuses on:

- Infrastructure health
- Application visibility
- Security incident detection
- Operational alerting

---

# CloudWatch Monitoring

# EC2 Monitoring

CloudWatch alarms are configured for backend EC2 instances.

## Metrics Monitored

- CPU Utilization
- Instance Status Checks
- Disk usage (via CloudWatch Agent)
- Memory utilization (via CloudWatch Agent)

---

# Example EC2 CPU Alarm

Terraform example:

```hcl
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "high-ec2-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_description   = "EC2 CPU usage exceeded 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.company_ec2.id
  }
}
```

---

# RDS Monitoring

CloudWatch alarms are configured for PostgreSQL RDS.

## Metrics Monitored

- Database connections
- CPU utilization
- Free storage space
- Read/write latency

---

# Example RDS Connection Alarm

```hcl
resource "aws_cloudwatch_metric_alarm" "rds_connections_alarm" {
  alarm_name          = "high-rds-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 100

  alarm_description   = "RDS connections exceeded threshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgres.id
  }
}
```

---

# CloudWatch Logs

# Log Groups

CloudWatch Log Groups are configured for:

- Application logs
- EC2 system logs
- Deployment logs
- Security logs

---

# Log Retention Policy

Retention is configured to avoid excessive storage costs while maintaining operational visibility.

Example:

```hcl
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/payroll/application"
  retention_in_days = 30
}
```

---

# Log Categories

## Application Logs

Includes:

- API requests
- Authentication events
- Application errors

---

## Infrastructure Logs

Includes:

- EC2 system logs
- Deployment logs
- Service startup failures

---

## Security Logs

Includes:

- Failed login attempts
- Unauthorized access attempts
- IAM-related events

---

# SNS Alerting

Amazon SNS is used for operational alert notifications.

---

# SNS Topic

Example:

```hcl
resource "aws_sns_topic" "alerts" {
  name = "critical-alerts"
}
```

---

# SNS Email Subscription

```hcl
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "devops-team@example.com"
}
```

---

# Alerting Scenarios

SNS alerts are triggered for:

- High EC2 CPU usage
- High RDS connections
- Instance failures
- Application crashes
- Security-related alarms

---

# Monitoring Architecture

```text
EC2 / RDS / Application
            |
       CloudWatch
            |
        Alarms
            |
           SNS
            |
      DevOps Team
```

---

# Incident Response Runbook

# Scenario

Database accidentally becomes publicly accessible.

---

# Detection

The incident can be detected through:

- AWS Config compliance alerts
- CloudWatch alarms
- Security monitoring tools
- AWS Trusted Advisor
- Manual security audits

Potential indicators:

- RDS public accessibility changed to TRUE
- Unexpected inbound traffic
- Security Group modifications
- Increased failed authentication attempts

---

# Investigation

## Step 1 – Verify Exposure

Check:

- RDS public accessibility status
- Security Group rules
- Route table exposure
- Recent IAM activity
- CloudTrail logs

---

## Step 2 – Identify Root Cause

Investigate:

- Recent Terraform changes
- Manual console modifications
- IAM user actions
- CI/CD deployment history

---

# Recovery

## Step 1 – Immediately Remove Public Access

Update RDS configuration:

```text
publicly_accessible = false
```

Restrict Security Groups to private backend subnets only.

---

## Step 2 – Rotate Credentials

Rotate:

- database passwords
- API credentials
- application secrets

using AWS Secrets Manager.

---

## Step 3 – Audit Access Logs

Review:

- CloudTrail logs
- PostgreSQL logs
- VPC Flow Logs
- IAM activity

Determine whether unauthorized access occurred.

---

## Step 4 – Validate Environment

Verify:

- RDS private subnet placement
- Security Group restrictions
- NACL rules
- IAM access boundaries

---

# Post-Incident Actions

After recovery:

- Document incident timeline
- Perform root cause analysis
- Update monitoring rules
- Improve security controls
- Conduct security review

---

# Preventive Measures

To prevent recurrence:

- Use AWS Config rules
- Enforce Terraform-only infrastructure changes
- Enable approval workflows for production changes
- Restrict console access
- Enable automated compliance scanning

---

# Conclusion

The monitoring and incident response strategy provides:

- Infrastructure visibility
- Proactive alerting
- Operational monitoring
- Security event detection
- Structured incident recovery procedures

This approach supports secure and reliable operation of a sensitive payroll platform.