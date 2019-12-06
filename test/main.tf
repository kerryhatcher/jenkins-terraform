terraform {
  required_version = "0.12.10"
}

module "jenkins_master" {
  source = "../module"
  region = ""
}
