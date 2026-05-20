provider "aws" {
  region = var.aws_region
}

# Data source for availability zones to distribute subnets
data "aws_availability_zones" "available" {
  state = "available"
}

# Core VPC
resource "aws_vpc" "core_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-core-vpc"
    Environment = var.environment
  }
}

# Public Subnets (2)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.core_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.core_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Private Subnets (2)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.core_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.core_vpc.cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}
