variable "REGION" {
  default = "eu-west-3"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "./keys/TerraformKey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "./keys/TerraformKey"
}

variable "VPC_CIDR" {
  default = "192.168.0.0/16"
}

variable "SUBNET1_CIDR" {
  default = "192.168.56.0/24"
}

variable "DC01_IP" {
  default = "192.168.56.10"
}

variable "DC02_IP" {
  default = "192.168.56.11"
}

variable "SRV02_IP" {
  default = "192.168.56.22"
}

variable "DC03_IP" {
  default = "192.168.56.12"
}

variable "SRV03_IP" {
  default = "192.168.56.23"
}

variable "WG_IP" {
  default = "192.168.56.40"
}

variable "PUBLIC_DNS" {
  default = "9.9.9.9"
}

variable "MANAGEMENT_IPS" {
  # Add in the public IP Address you will be hitting the cloud from, for example the public IP of your home address or VPN
  default = ["141.255.129.80/32"]
}
