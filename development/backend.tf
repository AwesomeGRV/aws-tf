# backend "s3" {
#     profile = "terraform"
#     bucket  = "ignition-terraform-backend"
#     key     = "global/terraform.tfstate"
#     region  = "us-east-1"

#     dynamodb_table = "terraform-lock-table-dynamo"
#     encrypt        = true
#   }

terraform {
  backend "s3" {
    bucket                      = "ignition-terraform-backend"
    key                         = "global/terraform.tfstate"
    endpoint                    = "s3.amazonaws.com"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}