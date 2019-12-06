/*
Lock the module to a spific version of terraform to reduce version issues. 
*/
terraform {
  required_version = "0.12.10"
}

/*
Configure the AWS Provider
Credentails and region should be configured via envorment vars or aws config file per https://www.terraform.io/docs/providers/index.html
*/
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = "$var.region"
}


#What AMI to use? 
#Aviable in Pram Store at /aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id
variable "ami" {
  default = "ami-09bfedafcb3b9889d"
}
