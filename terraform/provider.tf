provider "aws" {
  region     = "eu-west-3"
  access_key = var.aws_access_key                    # la clé d'acces crée pour l'utilisateur qui sera utilisé par terraform
  secret_key = var.aws_secret_key                              # la clé sécrète crée pour l'utilisateur qui sera utilisé par terraform 

}

/* resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "dynamodb-state-locking"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
} */



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "terraform-projetr-bucket1234"
  #   dynamodb_table = "dynamodb-state-locking"
  #   key            = "statefile/terraform.tfstate"
  #   region         = "eu-west-3"
  #   encrypt        = true

  # }

  backend "s3" {
    bucket         = "olegj-bucket-terraform-s3"
    dynamodb_table = "dynamodb-state-locking"
    key            = "terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true

  }


}

variable "aws_access_key" {}
variable "aws_secret_key" {}