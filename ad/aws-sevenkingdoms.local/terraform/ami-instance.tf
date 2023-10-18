# Our first domain controller of the "sevenkingdoms.local" domain
resource "aws_instance" "dc01" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.windows_server_2019.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.DC01_IP
  user_data                   = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC01"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_private.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Our second domain controller of the "north.sevenkingdoms.local" domain
resource "aws_instance" "dc02" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.windows_server_2019.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.DC02_IP
  user_data                   = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC02"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_private.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Our second domain controller of the "north.sevenkingdoms.local" domain
resource "aws_instance" "srv02" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.windows_server_2019.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.SRV02_IP
  user_data                   = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-SRV02"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_private.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Our third domain controller of the "essos.local" domain
resource "aws_instance" "dc03" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.windows_server_2016.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.DC03_IP
  user_data                   = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC03"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_private.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Our third server of the "essos.local" domain
resource "aws_instance" "srv03" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.windows_server_2016.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.SRV03_IP
  user_data                   = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-SRV03"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_private.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Our Wireguard server
resource "aws_instance" "wg" {
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu_server_22.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  subnet_id                   = aws_subnet.goad_vpc_subnet_private.id
  private_ip                  = var.WG_IP

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-WG"
  }

  vpc_security_group_ids = [
    aws_security_group.goad_sg_wireguard.id,
    aws_security_group.goad_sg_admins.id,
  ]
}

# Define an Elastic IP
resource "aws_eip" "wg_eip" {
  instance = aws_instance.wg.id

  tags = {
    Name = "GOAD-WG-EIP"
  }
}

# Associate the Elastic IP with your EC2 instance
# NOTE: The aws_eip.wg_eip takes care of this association for you.
# The below association is typically redundant if you've specified the instance ID in the EIP definition, but included for clarity.
resource "aws_eip_association" "wg_eip_association" {
  instance_id   = aws_instance.wg.id
  allocation_id = aws_eip.wg_eip.id
}
