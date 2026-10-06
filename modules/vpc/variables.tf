variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "AZ for subnets"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}
