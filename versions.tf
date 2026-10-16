terraform {
  required_version = ">= 1.10" # use_lockfile (S3-native locking) needs 1.10 or later
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
