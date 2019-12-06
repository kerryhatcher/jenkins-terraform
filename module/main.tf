/*
Lock the module to a spific version of terraform to reduce version issues. 
*/
terraform {
  required_version = "0.12.10"
}

/*
Configure the AWS Provider
TODO: Credentails and region should be configured via envorment vars or aws config file per https://www.terraform.io/docs/providers/index.html
*/
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

#TODO: Get the default VPC dynamicly
variable "vpc_id" {
  default = "vpc-0f96cd8c79b11e806"
}

data "aws_vpc" "main" {
  id = "${var.vpc_id}"
}


#What AMI to use? 
#Aviable in Pram Store at /aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id
#TODO: make this dynamic
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id"
}

#TODO: Get VPC subnets dynamicly

#TODO: Auto Scaling Group
resource "aws_autoscaling_group" "jenkis_master" {
  name                      = "jenkins_master_${terraform.workspace}"
  max_size                  = 1
  min_size                  = 1

  vpc_zone_identifier = ["subnet-0deb343f60510e3e7"]

  launch_template {
    id      = "${aws_launch_template.jenkins_master.id}"
    version = "$Latest"
  }
}

#TODO: ELB

#TODO: ACM

#TODO: R53

#TODO: EC2 Launch Templates
//data.aws_ssm_parameter.ecs_ami.image_id

resource "aws_launch_template" "jenkins_master" {
  name = "jenkins_master_${terraform.workspace}"

  #ebs_optimized = true

  instance_type = "t2.micro"
  #TODO need to make create the profile later
  iam_instance_profile {
      name = "${aws_iam_instance_profile.jenkins_master_profile.name}"
    }
  image_id = data.aws_ssm_parameter.ecs_ami.value
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    #TODO Change this to the ELB SG or VPC CIDR
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


# Instance Profile sets what IAM role to use
resource "aws_iam_instance_profile" "jenkins_master_profile" {
  name = "jenkins_master_${terraform.workspace}"
  role = aws_iam_role.jenkins_master.name

}

resource "aws_iam_role" "jenkins_master" {
  name = "jenkins_master_${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}



#TODO: EFS

#TODO: EFS BACKUP

#TODO: Init Script

