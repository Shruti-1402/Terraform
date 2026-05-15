resource "aws_instance" "company_ec2" {
  ami                    = "ami-0fc32db49bc1b6c18"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app_subnet_1.id
  vpc_security_group_ids = [aws_security_group.company_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.company_profile.name

  tags = {
    Name = "company-ec2"
  }
}

resource "aws_instance" "bureau_ec2" {
  ami                    = "ami-0fc32db49bc1b6c18"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bureau_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.bureau_profile.name

  tags = {
    Name = "bureau-ec2"
  }
}

resource "aws_instance" "employee_ec2" {
  ami                    = "ami-0fc32db49bc1b6c18"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_app_subnet_2.id
  vpc_security_group_ids = [aws_security_group.employee_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.employee_profile.name

  tags = {
    Name = "employee-ec2"
  }
}

resource "aws_iam_instance_profile" "company_profile" {
  name = "company-profile"
  role = aws_iam_role.company_role.name
}

resource "aws_iam_instance_profile" "bureau_profile" {
  name = "bureau-profile"
  role = aws_iam_role.bureau_role.name
}

resource "aws_iam_instance_profile" "employee_profile" {
  name = "employee-profile"
  role = aws_iam_role.employee_role.name
}