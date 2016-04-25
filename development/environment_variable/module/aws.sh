#!/bin/bash
#
# AWS関連
#

# AWSアカウントID
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)

# デフォルトリージョン
export AWS_DEFAULT_REGION=$(aws configure get region)

# AWSアカウントIDのMD5
export AWS_ACCOUNT_ID_MD5=$(echo $AWS_ACCOUNT_ID | md5)

# S3の接尾辞
# バケット名はグローバルで一意にする必要があるため
# AWSアカウントIDのMD5の先頭12文字を付与することにした。
# 詳細は、[S3の設計](/document/design/s3/README.md)を参照。
export AWS_S3_SUFFIX=$(echo $AWS_ACCOUNT_ID_MD5 | cut -c 1-12)

