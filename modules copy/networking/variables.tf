variable "aws_region" {
  default = "us-gov-west-1"
  type = string
}

variable env {
  description = "GovCloud deployment environment"
  type = string
  default = "govcloud-dev"
}