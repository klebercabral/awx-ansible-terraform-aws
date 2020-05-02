provider "aws" {
  region                    = var.region
  version                   = "~> 2.0"
}
data "http" "myip" {
  url = "https://api.ipify.org/"
}
module "network" {
  source                    = "terraform-aws-modules/vpc/aws"
  name                      = "awx-ansible-terraform-aws-vpc"
  cidr                      = var.vpc_cidr
  azs                       = var.vpc_azs
  public_subnets            = var.vpc_public_subnets
}
module "firewall" {
  source                    = "terraform-aws-modules/security-group/aws"
  name                      = "awx-ansible-terraform-aws-sg"
  vpc_id                    = module.network.vpc_id
  egress_with_cidr_blocks   = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
  ]
  ingress_with_cidr_blocks  = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "awx http"
    cidr_blocks = "${chomp(data.http.myip.body)}/32"
  },
  ]
}
module "ec2" {
  source                    = "terraform-aws-modules/ec2-instance/aws"
  name                      = "awx-ansible-terraform-aws"
  instance_count            = 1
  ami                       = var.ec2_ami
  instance_type             = var.ec2_instance_type
  key_name                  = var.key_pair_name
  vpc_security_group_ids    = [module.firewall.this_security_group_id]
  subnet_id                 = module.network.public_subnets[0]
}
output "public1" {
  value = module.ec2.public_ip[0]
}