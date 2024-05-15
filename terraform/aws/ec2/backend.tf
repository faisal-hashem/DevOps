terraform {
  backend "s3" {
    bucket = "devopsawsfhprojects"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}