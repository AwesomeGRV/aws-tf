# General variables
variable "region" {
  description = "aws region code"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_ids" {
  description = "aws accounts ids"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The Deployment environment"
  type        = string
  default     = "staging"
}

variable "environment_new" {
description = "The new Deployment environment"
  type    = string
  default = ""
}

## Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  type        = string
  default     = "10.13.0.0/16"
}

variable "public_subnets" {

  description = "A map of availability zones to public cidrs"
  type        = map(string)
  default = {
    us-east-1a = "10.13.1.0/24",
    us-east-1b = "10.13.5.0/24"
  }
}

variable "private_subnets" {
  description = "A map of availability zones to private cidrs"
  type        = map(string)
  default = {
    us-east-1a = "10.13.11.0/24",
    us-east-1b = "10.13.15.0/24"
  }
}

# Peering Variables
variable "peer_estaging_vpc_id" {
  description = "External AWS Staging Account VPC ID"
  type        = string
  default     = ""
}


variable "peer_estaging_private_domain" {
  description = "External AWS Staging Account Private Hosted Domain Name"
  type        = string
  default     = ""
}


# DNS variables
variable "public_domain" {
  description = "create hosted zones"
  type        = string
  default     = "example.com"
}

variable "private_domain" {
  description = "create hosted zones"
  type        = string
  default     = "example.internal"
}
