terraform {
  backend "s3" {
    bucket         = "vertex-tf-state"
    key            = "orbital-stack/global.tfstate"
    region         = "us-east-1"
    dynamodb_table = "vertex-tf-locks"
    encrypt        = true
  }
}

