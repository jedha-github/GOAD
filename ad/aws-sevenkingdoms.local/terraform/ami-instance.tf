# Our first domain controller of the "sevenkingdoms.local" domain
resource "aws_instance" "dc01" {
  ami           = data.aws_ami.windows-server-2019.image_id
  instance_type = "t2.micro"
  # associate_public_ip_address = true
  # key_name             = aws_key_pair.terraformkey.key_name
  subnet_id            = aws_subnet.lab-vpc-subnet-1.id
  private_ip           = var.DC01_IP
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC01"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-1.id,
  ]
}

# Our second domain controller of the "north.sevenkingdoms.local" domain
resource "aws_instance" "dc02" {
  ami           = data.aws_ami.windows-server-2019.image_id
  instance_type = "t2.micro"
  # associate_public_ip_address = true
  # key_name             = aws_key_pair.terraformkey.key_name
  subnet_id            = aws_subnet.lab-vpc-subnet-1.id
  private_ip           = var.DC02_IP
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC02"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-2.id,
  ]
}

# Our second domain controller of the "north.sevenkingdoms.local" domain
resource "aws_instance" "srv02" {
  ami           = data.aws_ami.windows-server-2019.image_id
  instance_type = "t2.micro"
  # associate_public_ip_address = true
  # key_name             = aws_key_pair.terraformkey.key_name
  subnet_id            = aws_subnet.lab-vpc-subnet-1.id
  private_ip           = var.SRV02_IP
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-SRV02"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-2.id,
  ]
}

# Our third domain controller of the "essos.local" domain
resource "aws_instance" "dc03" {
  ami           = data.aws_ami.windows-server-2016.image_id
  instance_type = "t2.micro"
  # associate_public_ip_address = true
  # key_name             = aws_key_pair.terraformkey.key_name
  subnet_id            = aws_subnet.lab-vpc-subnet-1.id
  private_ip           = var.DC03_IP
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-DC03"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-3.id,
  ]
}

# Our third server of the "essos.local" domain
resource "aws_instance" "srv03" {
  ami           = data.aws_ami.windows-server-2016.image_id
  instance_type = "t2.micro"
  # associate_public_ip_address = true
  # key_name             = aws_key_pair.terraformkey.key_name
  subnet_id            = aws_subnet.lab-vpc-subnet-1.id
  private_ip           = var.SRV03_IP
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("${path.module}/scripts/ansibleuserdata.ps1")

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-SRV03"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-3.id,
  ]
}

# Our Wireguard server
resource "aws_instance" "wg" {
  ami                         = data.aws_ami.ubuntu-server-22.image_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terraformkey.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.lab-vpc-subnet-1.id
  private_ip                  = var.WG_IP
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.id

  tags = {
    Workspace = "${terraform.workspace}"
    Name      = "GOAD-WG"
  }

  vpc_security_group_ids = [
    aws_security_group.lab-sg-wireguard.id,
  ]
}

