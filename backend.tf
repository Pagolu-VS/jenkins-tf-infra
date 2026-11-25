terraform {
  backend "s3" {
    bucket       = "iamvidya-terraform-state"
    key          = "practice/jenkins.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}