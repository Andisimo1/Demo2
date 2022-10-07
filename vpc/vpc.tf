provider "aws" {
  region = "eu-central-1"
}

#creating vpc
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block_vpc

  tags = {
    Name = "VPC"
  }
}

#creating public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public
  availability_zone = var.AvailabilityZone
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

#creating public subnet 2
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public2
  availability_zone = var.AvailabilityZone2
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

#creating private subnet
resource "aws_subnet" "private"{
  vpc_id     = aws_vpc.main.id
  cidr_block    = var.cidr_block_private
  availability_zone = var.AvailabilityZone

  tags = {
    Name = "Private Subnet"
  }
}

#creating private subnet 2
resource "aws_subnet" "private2"{
  vpc_id     = aws_vpc.main.id
  cidr_block    = var.cidr_block_private2
  availability_zone = var.AvailabilityZone2

  tags = {
    Name = "Private Subnet 2"
  }
}

#creating internet gateway
resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet Gateway"
  }
}

#elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  
  tags = {
    Name = "NAT Gateway EIP"
  }
}

#NAT gateway for VPC
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

#route table for public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

#association public Subnet to Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

#route table for public 2
resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table 2"
  }
}

#association public Subnet to Public Route Table 2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public2.id

}

#route table for private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

#association private Subnet to private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

#route table for private 2
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table 2"
  }
}

#association private Subnet to private Route Table 2
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}