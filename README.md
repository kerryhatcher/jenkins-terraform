# jenkins-terraform
A terraform Module for setting up a jenkins master server in AWS

## Usage

module "jenkins_master" {
  source = "../module"
  dns_zone = "cooldomain.com" # a dns zone that exisits in your account that we can add records to
  config_s3_uri = "all-my-configs-bucket/jenkins.yaml" # a S3 buckt/object contating a JSasC config file
}


## Suggested Plugins
configuration-as-code 
configuration-as-code-secret-ssm  
credentials  
aws-secrets-manager-credentials-provider
mailer
cloudbees-folder
antisamy-markup-formatter
build-timeout
credentials-binding
timestamper
ws-cleanup
ant
gradle
nodejs
htmlpublisher
workflow-aggregator
github-branch-source
pipeline-github-lib
pipeline-stage-view
copyartifact
parameterized-trigger
conditional-buildstep
bitbucket
git
github
ssh-slaves
matrix-auth
pam-auth
ldap
role-strategy
active-directory
authorize-project
email-ext