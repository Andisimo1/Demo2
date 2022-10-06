#create EC2 instance in private subnet
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id	      = "${aws_subnet.private.id}"
  security_groups = [aws_security_group.Terraform.id]
  user_data = <<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
service systemctl enable apache2
EOF

  tags = {
    Name = "Web Server 1"
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
}

resource "aws_instance" "web2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = "${aws_subnet.private2.id}"
  security_groups = [aws_security_group.Terraform.id]
  user_data = <<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
service systemctl enable apache2
EOF

  tags = {
    Name = "Web Server 2"
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
}

resource "aws_instance" "Bastion" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = "${aws_subnet.public.id}"
  security_groups = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion"
  }
}

#create security groups
resource "aws_security_group" "Terraform" {
  name        = "Terraform Security"
  description = "Allow Inbound Traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.bastion.id] 
  }

  tags = {
    Name = "Terraform"
  }
}

resource "aws_security_group" "bastion" {
  name        = "Bastion"
  description = "Allow Inbound Traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks	     = [var.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_block]
  }

  tags = {
    Name = "Bastion"
  }
}

# #create load balancer
# resource "aws_lb" "test" {
#   name               = "LoadBalancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.Terraform.id]
#   subnets            = [aws_subnet.private.id, aws_subnet.private2.id]

#   tags = {
#     Name = "ALB"
#   }
# }