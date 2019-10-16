provider "aws" {
  region  = "eu-west-1"
  version = "1.60.0"

  assume_role {
    role_arn = "arn:aws:iam::760097843905:role/platform-developer"
  }
}
