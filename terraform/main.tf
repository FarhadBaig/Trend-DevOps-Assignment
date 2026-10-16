
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

locals {
  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc" "trend" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "trend" {
  vpc_id = aws_vpc.trend.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.trend.id
  cidr_block              = cidrsubnet(aws_vpc.trend.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                     = "${var.project_name}-public-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.trend.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trend.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

output "vpc_id" {
  value = aws_vpc.trend.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
