locals {
  name = var.user_name
}

resource "aws_iam_user" "user" {
  name = local.name
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:*GetObject*",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
}

resource "aws_iam_user_policy" "user_policy" {
  name   = local.name
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_secretsmanager_secret" "access_key_id" {
  name = "${local.name}-access-key-id"
}

resource "aws_secretsmanager_secret_version" "access_key_id" {
  secret_id     = aws_secretsmanager_secret.access_key_id.id
  secret_string = aws_iam_access_key.key.id
}

resource "aws_secretsmanager_secret" "secret_access_key" {
  name = "${local.name}-secret-access-key"
}

resource "aws_secretsmanager_secret_version" "secret_access_key" {
  secret_id     = aws_secretsmanager_secret.secret_access_key.id
  secret_string = aws_iam_access_key.key.secret
}

data "aws_secretsmanager_secret_version" "access_key_id" {
  secret_id = aws_secretsmanager_secret.access_key_id.id

  depends_on = [aws_secretsmanager_secret_version.access_key_id]
}

data "aws_secretsmanager_secret_version" "secret_access_key" {
  secret_id = aws_secretsmanager_secret.secret_access_key.id

  depends_on = [aws_secretsmanager_secret_version.secret_access_key]
}

module "acuris_assets_config" {
  source = "github.com/mergermarket/terraform-acuris-fastly-routing-config-s3"

  vcl_recv_condition    = var.vcl_recv_condition
  backend_name          = var.backend_name
  s3_bucket_name        = var.s3_bucket_name
  aws_access_key_id     = data.aws_secretsmanager_secret_version.access_key_id.secret_string
  aws_secret_access_key = data.aws_secretsmanager_secret_version.secret_access_key.secret_string
}

