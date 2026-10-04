provider "aws" {
  region = "ap-south-1"
}

# ─── VPC ───
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    Workspace   = terraform.workspace
  }
}

# ─── PUBLIC SUBNET ───
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-${var.environment}"
    Environment = var.environment
    Type        = "public"
    Workspace   = terraform.workspace
  }
}

# ─── PRIVATE SUBNET ───
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.project_name}-private-${var.environment}"
    Environment = var.environment
    Type        = "private"
    Workspace   = terraform.workspace
  }
}

# ─── INTERNET GATEWAY ───
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw-${var.environment}"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

# ─── PUBLIC ROUTE TABLE ───
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt-${var.environment}"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

# ─── PUBLIC SUBNET ASSOCIATION ───
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ─── PRIVATE ROUTE TABLE ───
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-rt-${var.environment}"
    Environment = var.environment
    Workspace   = terraform.workspace
  }
}

# ─── PRIVATE SUBNET ASSOCIATION ───
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
