output "vpc_id" {
  value = aws_vpc.main.id
}

output "company_ec2_private_ip" {
  value = aws_instance.company_ec2.private_ip
}

output "bureau_ec2_private_ip" {
  value = aws_instance.bureau_ec2.private_ip
}

output "employee_ec2_private_ip" {
  value = aws_instance.employee_ec2.private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.documents.bucket
}