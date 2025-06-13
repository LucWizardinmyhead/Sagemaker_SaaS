provider "aws" {
  region = var.aws_region # Replace with your desired region
}

data "aws_region" "current" {}

locals {
  auth_read_and_list          = var.authenticated_allow_list != "DISALLOW"
  create_auth_private         = var.s3_permissions_authenticated_private != "DISALLOW"
  create_auth_protected       = var.s3_permissions_authenticated_protected != "DISALLOW"
  create_auth_public          = var.s3_permissions_authenticated_public != "DISALLOW"
  create_auth_uploads         = var.s3_permissions_authenticated_uploads != "DISALLOW"
  create_guest_public         = var.s3_permissions_guest_public != "DISALLOW"
  create_guest_uploads        = var.s3_permissions_guest_uploads != "DISALLOW"
  guest_read_and_list         = var.guest_allow_list != "DISALLOW"
  should_not_create_env_resources = var.env == "NONE"
  stack_name                  = "s3-template"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.should_not_create_env_resources ? var.bucket_name : join("", [var.bucket_name, "-", var.env])

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag", "x-amz-version-id"]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_policy" "s3_auth_private_policy" {
  count = local.create_auth_private ? 1 : 0

  name   = var.s3_private_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = split(",", var.s3_permissions_authenticated_private)
        Effect   = "Allow"
        Resource = [
          join("", ["arn:aws:${data.aws_region.current.name}:s3:::", aws_s3_bucket.s3_bucket.id, "/private/${cognito-identity.amazonaws.com:sub}/*"])
        ]
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "s3_auth_protected_policy" {
  count = local.create_auth_protected ? 1 : 0

  name   = var.s3_protected_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = split(",", var.s3_permissions_authenticated_protected)
        Effect   = "Allow"
        Resource = [
          join("", ["arn:aws-us-west-1:s3:::", aws_s3_bucket.s3_bucket.id, "/protected/${cognito-identity.amazonaws.com:sub}/*"])
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_auth_public_policy" {
  count = local.create_auth_public ? 1 : 0

  name   = var.s3_public_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = split(",", var.s3_permissions_authenticated_public)
        Effect   = "Allow"
        Resource = [
          join("", ["arn:aws-us-west-1:s3:::", aws_s3_bucket.s3_bucket.id, "/public/*"])
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_auth_read_policy" {
  count = local.auth_read_and_list ? 1 : 0

  name   = var.s3_read_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:${data.aws_region.current.name}:s3:::${aws_s3_bucket.s3_bucket.id}/protected/*"
      },
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "arn:aws:${data.aws_region.current.name}:s3:::${aws_s3_bucket.s3_bucket.id}"
        Condition = {
          StringLike = {
            "s3:prefix" = [
              "public/",
              "public/*",
              "protected/",
              "protected/*",
              "private/${cognito-identity.amazonaws.com:sub}/",
              "private/${cognito-identity.amazonaws.com:sub}/*"
            ]
          }
        }
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "s3_auth_upload_policy" {
  count = local.create_auth_uploads ? 1 : 0

  name   = var.s3_uploads_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = split(",", var.s3_permissions_authenticated_uploads)
        Effect   = "Allow"
        Resource = [
          join("", ["arn:aws-us-west-1:s3:::", aws_s3_bucket.s3_bucket.id, "/uploads/*"])
        ]
      }
    ]
  })
}
