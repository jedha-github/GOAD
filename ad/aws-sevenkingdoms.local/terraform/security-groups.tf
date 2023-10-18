## Security group subnet 1
resource "aws_security_group" "goad_sg_private" {
  vpc_id = aws_vpc.goad_vpc.id
  name   = "goad_sg_private"

  ingress {
    protocol    = "-1"
    cidr_blocks = [var.SUBNET1_CIDR]
    from_port   = 0
    to_port     = 0
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.SUBNET1_CIDR]
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

## Security group WireGuard
resource "aws_security_group" "goad_sg_wireguard" {
  vpc_id = aws_vpc.goad_vpc.id
  name   = "goad_sg_wireguard"

  # Allow WireGuard traffic from anywhere
  ingress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 51820
    to_port     = 51820
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  egress {
    protocol    = "-1"
    cidr_blocks = [var.SUBNET1_CIDR]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "goad_sg_admins" {
  vpc_id = aws_vpc.goad_vpc.id
  name   = "goad_sg_admins"

  # Used for SSH
  ingress {
    protocol    = "tcp"
    cidr_blocks = var.MANAGEMENT_IPS
    from_port   = 22
    to_port     = 22
  }

  # Used for Ansible
  ingress {
    protocol    = "tcp"
    cidr_blocks = var.MANAGEMENT_IPS
    from_port   = 5985
    to_port     = 5986
  }

  # Used for RDP
  ingress {
    protocol    = "tcp"
    cidr_blocks = var.MANAGEMENT_IPS
    from_port   = 3389
    to_port     = 3389
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}
