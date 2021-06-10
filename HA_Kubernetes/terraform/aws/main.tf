# Create a VPC
resource "aws_key_pair" "deployment" {
  key_name   = "deployment-key"
  public_key = var.ssh_public_key

  tags = {
    name = "deployment",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.5.0.0/16"

  tags = {
    name = "main",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true

  associate_with_private_ip = "10.5.0.1"
  depends_on                = [aws_internet_gateway.igw]

  tags = {
    Name = "nat_eip",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.5.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_subnet" "rancher_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.5.98.0/24"

  tags = {
    Name = "rancher_subnet",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.5.99.0/24"

  tags = {
    Name = "dev_subnet",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.5.100.0/24"

  tags = {
    Name = "prod_subnet",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat_gw",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_route_table" "public_subnet_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_subnet_table",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_route_table" "private_subnet_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_subnet_table",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_route_table_association" "public_subnet_routes" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_table.id
}

resource "aws_route_table_association" "rancher_subnet_routes" {
  subnet_id      = aws_subnet.rancher_subnet.id
  route_table_id = aws_route_table.private_subnet_table.id
}

resource "aws_route_table_association" "dev_subnet_routes" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.private_subnet_table.id
}

resource "aws_route_table_association" "prod_subnet_routes" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.private_subnet_table.id
}

resource "aws_security_group" "public_subnet_sg" {
  name        = "public_subnet_sg"
  description = "Allow Rules for Public Subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public_subnet_sg",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_security_group" "private_subnet_sg" {
  name        = "private_subnet_sg"
  description = "Allow Rules for Private Subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from Public Subnet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "private_subnet_sg",
    environment = var.environment,
    vpc = "main"
  }
}

data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["packer-ubuntu-2004-minimal-base-*"]
  }

}

# Build an Instance to be the Ansible jumpbox

resource "aws_network_interface" "jumpbox_eth0" {
  subnet_id   = aws_subnet.public_subnet.id
  private_ips = ["10.5.0.100"]
  security_groups = [
    aws_security_group.public_subnet_sg.id
  ]

  tags = {
    Name = "jumpbox_eth0",
    environment = var.environment,
    vpc = "main"
  }
}

resource "aws_instance" "jumpbox" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.deployment.key_name
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.jumpbox_eth0.id
    device_index         = 0
  }

  tags = {
    Name = "jumpbox",
    environment = var.environment,
    vpc = "main"
  }
}
