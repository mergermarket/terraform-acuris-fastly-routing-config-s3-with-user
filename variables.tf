variable "vcl_recv_condition" {
  description = "boolean condition to use to select the backend in vcl_recv"
  type        = string
}

variable "backend_name" {
  description = "Identifier for the backend"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "user_name" {
  description = "The name of the user - owner of the credentials with S3 bucket access"
  type        = string
}

