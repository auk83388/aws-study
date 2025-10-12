#providerの設定

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
#awsの東京を指定している
provider "aws" {
  region = "ap-northeast-1"

}

