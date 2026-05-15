resource "aws_db_subnet_group" "db_subnet_group" {
  name = "payroll-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_subnet_1.id,
    aws_subnet.private_db_subnet_2.id
  ]

  tags = {
    Name = "Payroll DB subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "payroll-postgres"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = "ChangeMe123!"
  publicly_accessible    = false
  storage_encrypted      = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "payroll-rds"
  }
}