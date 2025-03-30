terraform {
  backend "s3" {
    bucket = "clm-terraform-bucket-202502040-joshua"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
}
