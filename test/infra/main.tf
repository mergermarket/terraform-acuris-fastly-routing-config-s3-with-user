# defaults

provider "aws" {
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  max_retries                 = 1
  access_key                  = "a"
  secret_key                  = "a"
  region                      = "eu-west-1"
}

variable "defaults_vcl_recv_condition" {}
variable "defaults_backend_name" {}
variable "defaults_s3_bucket_name" {}
variable "defaults_user_name" {}

module "defaults" {
  source             = "../.."
  vcl_recv_condition = "${var.defaults_vcl_recv_condition}"
  backend_name       = "${var.defaults_backend_name}"
  s3_bucket_name     = "${var.defaults_s3_bucket_name}"
  user_name          = "${var.defaults_user_name}"
}

output "defaults_vcl_recv" {
  value = "${module.defaults.vcl_recv}"
}

output "defaults_vcl_backend" {
  value = "${module.defaults.vcl_backend}"
}
