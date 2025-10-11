terraform {
  backend "s3" {
    bucket         = "retailpulse-tfstate-051826728851-ap-southeast-1"
    key            = "dev/global.tfstate" # choose any path prefix you like
    region         = "ap-southeast-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}