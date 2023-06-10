# TODO: Designate a cloud provider, region, and credentials
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = "AKIAVWQKGVM23A336LHL"
  secret_key = "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"
  region  = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "t2_instances" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  count         = "4"
  subnet_id = "subnet-0dc38c77bd5952093"
  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "m4_instances" {
#   ami           = "ami-053b0d53c279acc90"
#   instance_type = "m4.large"
#   count         = "2"
#   subnet_id = "subnet-0dc38c77bd5952093"
#   tags = {
#     Name = "Udacity M4"
#   }
# }