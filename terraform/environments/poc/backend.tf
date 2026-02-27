terraform {
  backend "s3" {
    bucket         = "opsfleet-tfstate-624654857501"
    key            = "opsfleet/environments/poc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
