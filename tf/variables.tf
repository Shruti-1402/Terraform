variable "aws_region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2" {
  default = "10.0.2.0/24"
}

variable "private_app_subnet_1" {
  default = "10.0.3.0/24"
}

variable "private_app_subnet_2" {
  default = "10.0.4.0/24"
}

variable "private_db_subnet_1" {
  default = "10.0.5.0/24"
}

variable "private_db_subnet_2" {
  default = "10.0.6.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "payrolldb"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  default = "ChangeMe123!"
}