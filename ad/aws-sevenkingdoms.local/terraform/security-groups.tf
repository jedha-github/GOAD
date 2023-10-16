## Security group subnet 1
resource "aws_security_group" "lab-sg-1" {
  vpc_id = aws_vpc.lab-vpc.id
  name   = "goad-sg-1"

  ingress {
    protocol    = "-1"
    cidr_blocks = [var.SUBNET1_CIDR]
    from_port   = 0
    to_port     = 0
  }

  # Allow management from our IP
  # ingress {
  #   protocol    = "-1"
  #   cidr_blocks = var.MANAGEMENT_IPS
  #   from_port   = 0
  #   to_port     = 0
  # }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5985
    to_port     = 5986
  }

  # Allow traffic from WireGuard SG
  ingress {
    protocol        = "-1"
    security_groups = [aws_security_group.lab-sg-wireguard.id]
    from_port       = 0
    to_port         = 0
  }

  # Allow global outbound
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

## Security group subnet 2
resource "aws_security_group" "lab-sg-2" {
  vpc_id = aws_vpc.lab-vpc.id
  name   = "goad-sg-2"

  ingress {
    protocol    = "-1"
    cidr_blocks = [var.SUBNET1_CIDR]
    from_port   = 0
    to_port     = 0
  }

  # Allow management from our IP
  # ingress {
  #   protocol    = "-1"
  #   cidr_blocks = var.MANAGEMENT_IPS
  #   from_port   = 0
  #   to_port     = 0
  # }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5985
    to_port     = 5986
  }

  # Allow traffic from WireGuard SG
  ingress {
    protocol        = "-1"
    security_groups = [aws_security_group.lab-sg-wireguard.id]
    from_port       = 0
    to_port         = 0
  }

  # Allow global outbound
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

## Security group subnet 3
resource "aws_security_group" "lab-sg-3" {
  vpc_id = aws_vpc.lab-vpc.id
  name   = "goad-sg-3"

  ingress {
    protocol    = "-1"
    cidr_blocks = [var.SUBNET1_CIDR]
    from_port   = 0
    to_port     = 0
  }

  # Allow management from our IP
  # ingress {
  #   protocol    = "-1"
  #   cidr_blocks = var.MANAGEMENT_IPS
  #   from_port   = 0
  #   to_port     = 0
  # }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5985
    to_port     = 5986
  }

  # Allow traffic from WireGuard SG
  ingress {
    protocol        = "-1"
    security_groups = [aws_security_group.lab-sg-wireguard.id]
    from_port       = 0
    to_port         = 0
  }

  # Allow global outbound
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

## Security group WireGuard
resource "aws_security_group" "lab-sg-wireguard" {
  vpc_id = aws_vpc.lab-vpc.id
  name   = "goad-sg-wireguard"

  # Allow WireGuard traffic from anywhere
  ingress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 51820
    to_port     = 51820
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  # Allow global outbound
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}
