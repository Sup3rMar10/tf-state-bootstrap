# How any other root module uses the bucket. Bucket name and key are placeholders.
terraform {
  backend "s3" {
    bucket       = "REPLACE-with-state-bucket-name"
    key          = "example-app/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true # S3-native locking: no DynamoDB table needed
  }
}
