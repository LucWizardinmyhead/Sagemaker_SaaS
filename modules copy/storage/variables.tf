variable "authenticated_allow_list" {
  type    = string
  default = "DISALLOW"
}

variable "guest_allow_list" {
  type    = string
  default = "DISALLOW"
}

variable "auth_policy_name" {
  type = string
}

variable "auth_role_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "env" {
  type = string
}

variable "s3_permissions_authenticated_private" {
  type    = string
  default = "DISALLOW"
}

variable "s3_permissions_authenticated_protected" {
  type    = string
  default = "DISALLOW"
}

variable "s3_permissions_authenticated_public" {
  type    = string
  default = "DISALLOW"
}

variable "s3_permissions_authenticated_uploads" {
  type    = string
  default = "DISALLOW"
}

variable "s3_permissions_guest_public" {
  type    = string
  default = "DISALLOW"
}

variable "s3_permissions_guest_uploads" {
  type    = string
  default = "DISALLOW"
}

variable "s3_private_policy" {
  type    = string
  default = "NONE"
}

variable "s3_protected_policy" {
  type    = string
  default = "NONE"
}

variable "s3_public_policy" {
  type    = string
  default = "NONE"
}

variable "s3_read_policy" {
  type    = string
  default = "NONE"
}

variable "s3_uploads_policy" {
  type    = string
  default = "NONE"
}

variable "unauth_policy_name" {
  type = string
}

variable "unauth_role_name" {
  type = string
}