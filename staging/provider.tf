terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}

# backend "s3" {
#     profile = "terraform"
#     bucket  = "ignition-terraform-backend"
#     key     = "global/terraform.tfstate"
#     region  = "us-east-1"

#     dynamodb_table = "terraform-lock-table-dynamo"
#     encrypt        = true
#   }
