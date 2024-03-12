provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s_vpc"
  }
}

resource "aws_subnet" "k8s_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "k8s_subnet"
  }
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "Allow Kubernetes cluster traffic"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s_sg"
  }
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-0c2b8ca1dad447f8a" # Example AMI, update this to the latest Ubuntu/Kubernetes AMI in your region
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.k8s_subnet.id
  key_name      = "your-key-name" # Ensure you have this key pair created
  security_groups = [aws_security_group.k8s_sg.name]

  tags = {
    Name = "k8s_master"
  }
}

resource "aws_instance" "k8s_worker" {
  count         = 2 # Number of worker nodes
  ami           = "ami-0c2b8ca1dad447f8a" # As above, ensure this is the correct AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.k8s_subnet.id
  key_name      = "your-key-name"
  security_groups = [aws_security_group.k8s_sg.name]

  tags = {
    Name = "k8s_worker-${count.index}"
  }
}

module "cilium" {
  source = "git::https://github.com/your-repo/terraform-helm-cilium.git?ref=v1.0.0"
  # Configuration parameters for Cilium
}

module "grafana" {
  source = "git::https://github.com/your-repo/terraform-helm-grafana.git?ref=v1.0.0"
  # Configuration parameters for Grafana
}