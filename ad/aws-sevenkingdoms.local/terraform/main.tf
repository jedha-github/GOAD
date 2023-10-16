provider "aws" {
  profile = "terraform"
  region  = var.REGION
}

resource "aws_key_pair" "terraformkey" {
  key_name   = "${terraform.workspace}-goad"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  # provisioner "local-exec" {
  #   command = "echo '${tls_private_key.pk.private_key_pem}' > ./${aws_key_pair.terraformkey.key_name}.pem"
  # }
}

# Our VPC definition, using a default IP range of 192.168.0.0/16
resource "aws_vpc" "lab-vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Default route required for the VPC to push traffic via gateway
resource "aws_route" "lab-internet-route" {
  route_table_id         = aws_vpc.lab-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab-vpc-gateway.id
}

# Gateway which allows outbound and inbound internet access to the VPC
resource "aws_internet_gateway" "lab-vpc-gateway" {
  vpc_id = aws_vpc.lab-vpc.id
}

# Create our first subnet (Defaults to 192.168.56.0/24)
resource "aws_subnet" "lab-vpc-subnet-1" {
  vpc_id = aws_vpc.lab-vpc.id

  cidr_block        = var.SUBNET1_CIDR
  availability_zone = "${var.REGION}a"

  tags = {
    Name = "GOAD Subnet 1"
  }
}

# Set DHCP options for delivering things like DNS servers
resource "aws_vpc_dhcp_options" "lab-dhcp" {
  domain_name          = "sevenkingdoms.local"
  domain_name_servers  = [var.DC01_IP, var.PUBLIC_DNS]
  ntp_servers          = [var.DC01_IP]
  netbios_name_servers = [var.DC01_IP]
  netbios_node_type    = 2

  tags = {
    Name = "GOAD DHCP sevenkingdoms"
  }
}

# Associate our DHCP configuration with our VPC
resource "aws_vpc_dhcp_options_association" "lab-dhcp-assoc" {
  vpc_id          = aws_vpc.lab-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.lab-dhcp.id
}

# output "dc01" {
#   value       = aws_instance.dc01.public_ip
#   description = "Public IP of DC01"
# }

# output "dc02" {
#   value       = aws_instance.dc02.public_ip
#   description = "Public IP of DC02"
# }

# output "srv02" {
#   value       = aws_instance.srv02.public_ip
#   description = "Public IP of SRV02"
# }

# output "dc03" {
#   value       = aws_instance.dc03.public_ip
#   description = "Public IP of DC03"
# }

# output "srv03" {
#   value       = aws_instance.srv03.public_ip
#   description = "Public IP of SRV03"
# }

output "wg" {
  value       = aws_eip.wg_eip.public_ip
  description = "Public IP of WG"
}

output "admin" {
  value       = aws_instance.admin.public_ip
  description = "Public IP of Admin"
}
