variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "environment" {
  description = "The Deployment environment"
  default     = "test"
}


variable "project" {
  type        = string
  description = "Project Name Tag"
  default     = "ignition"
}

variable "public_subnets" {
  description = "A map of availability zones to public cidrs"
  type        = map(string)
  default = {
    us-east-1a = "10.11.1.0/24",
    us-east-1b = "10.11.5.0/24"
  }
}

variable "private_subnets" {
  description = "A map of availability zones to private cidrs"
  type        = map(string)
  default = {
    us-east-1a = "10.11.11.0/24",
    us-east-1b = "10.11.15.0/24"
  }
}

variable "region" {
  description = "The region to launch the bastion host"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default     = "10.11.0.0/16"
}


variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}