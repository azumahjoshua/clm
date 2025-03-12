terraform {
  backend "s3" {
    bucket = "banks3-terraform-bucket-20250203"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
}
