# AWSのリージョン指定とTerraformのバージョン固定
provider "aws" {
  //バージョンを固定
  version = "3.14.1"
  //東京リージョン
  region = "ap-northeast-1"
}

terraform {
  //バージョンを固定
  required_version = "0.13.4"
}