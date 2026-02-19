provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "strix_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "strix-vpc"
  }
}

resource "aws_subnet" "strix_public_subnet" {
  vpc_id                  = aws_vpc.strix_vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "strix-public-subnet"
  }
}

resource "aws_subnet" "strix_private_subnet" {
  vpc_id                  = aws_vpc.strix_vpc.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "strix-private-subnet"
  }
}

resource "aws_internet_gateway" "strix_igw" {
  vpc_id = aws_vpc.strix_vpc.id

  tags = {
    Name = "strix-igw"
  }
}

resource "aws_eip" "strix_eip" {
    domain = "vpc"

  tags = {
    Name = "strix-eip"
  }
}

resource "aws_nat_gateway" "strix_nat" {
  allocation_id = aws_eip.strix_eip.id
  subnet_id = aws_subnet.strix_public_subnet.id

  tags = {
    Name = "strix-nat"
  }

  depends_on = [aws_internet_gateway.strix_igw]
}

resource "aws_route_table" "strix_public_routetb" {
  vpc_id = aws_vpc.strix_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strix_igw.id
  }

  tags = {
    Name = "strix-public-routetb"
  }
}

resource "aws_route_table" "strix_private_routetb" {
  vpc_id = aws_vpc.strix_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.strix_nat.id
  }

  tags = {
    Name = "strix-private-routetb"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id = aws_subnet.strix_public_subnet.id
  route_table_id = aws_route_table.strix_public_routetb.id
}

resource "aws_route_table_association" "priv" {
  subnet_id = aws_subnet.strix_private_subnet.id
  route_table_id = aws_route_table.strix_private_routetb.id
}

resource "aws_security_group" "lambda_sg" {
  name        = "strix-lambda-sg"
  description = "Security group for Strix Lambda functions"
  vpc_id      = aws_vpc.strix_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strix-lambda-sg"
  }
}
