#!/bin/bash
#
# terraform関連
#
# TF_VAR_key_nameと定義すると、terraform内でkey_nameでアクセスできる
#

# AWSアカウント設定
export TF_VAR_aws_account_id="$AWS_ACCOUNT_ID"
export TF_VAR_aws_default_region="$AWS_DEFAULT_REGION"

# S3の接尾辞
export TF_VAR_s3_suffix="$AWS_S3_SUFFIX"

# AWSユーザ設定
export TF_VAR_aws_login_user="$AWS_LOGIN_USER"
export TF_VAR_aws_cli_user="$AWS_CLI_USER"

# SSH設定
export TF_VAR_ssh_port="$SSH_PORT"

# DB設定
export TF_VAR_db_port="$DATABASE_PORT"
export TF_VAR_db_master_user_name="$DATABASE_MASTER_USER_NAME"
# DB設定：初期パスはtfstateファイルに平文で書かれることに注意
export TF_VAR_db_initial_password="$DATABASE_INITIAL_PASSWORD"
