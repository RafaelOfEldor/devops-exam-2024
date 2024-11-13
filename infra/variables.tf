variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
}

variable "bucket_name" {
  type        = string
  description = "bucket to store images"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "account_id" {
  type        = string
  description = "AWS account id"
}