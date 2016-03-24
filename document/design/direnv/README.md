# direnvの導入

プロジェクト固有の環境変数の設定に[direnv](https://github.com/direnv/direnv)を導入する。

## インストール

```bash
$ brew install direnv
$ echo 'export EDITOR=vim' >> ~/.bash_profile
$ echo 'eval "$(direnv hook bash)"' >> ~/.bash_profile
$ source ~/.bash_profile
$ echo '.envrc' >> .gitignore
```

## 設定方法

```bash
$ direnv edit .
```

## 設定内容

```bash
#
# 基本設定
#

# AWSアカウント設定
export AWS_ACCOUNT_ID='xxxxxxxx'
export AWS_ACCOUNT_ID_MD5=$(echo $AWS_ACCOUNT_ID | md5)
export AWS_DEFAULT_REGION='ap-northeast-1'

# AWSユーザ設定
export AWS_LOGIN_USER='xxxx'
export AWS_CLI_USER='cli-xxxx'

# SSH設定
export SSH_PORT='xxxx'

# DB設定
export DATABASE_PORT='xxxx'
export DATABASE_USER='xxxx'
export DATABASE_PASSWORD='xxxxxxxx'

#
# terraform環境変数
# TF_VAR_key_nameと定義すると、terraform内でkey_nameでアクセスできる
#

# AWSアカウント設定
export TF_VAR_aws_account_id="$AWS_ACCOUNT_ID"
export TF_VAR_s3_suffix=$(echo $AWS_ACCOUNT_ID_MD5 | cut -c 1-12)
export TF_VAR_aws_default_region="$AWS_DEFAULT_REGION"

# AWSユーザ設定
export TF_VAR_aws_login_user="$AWS_LOGIN_USER"
export TF_VAR_aws_cli_user="$AWS_CLI_USER"

# SSH設定
export TF_VAR_ssh_port="$SSH_PORT"

# 管理者IPアドレス設定
export TF_VAR_administrator_ip_address="XX.XX.XX.XX/32"

# DB設定
export TF_VAR_db_port="$DATABASE_PORT"
export TF_VAR_db_master_user_name="$DATABASE_USER"
export TF_VAR_db_initial_password="xxxxxxxx"
```

## 設定内容の確認

```bash
$ grep -v -e '^\s*#' -e '^\s*$' .envrc
```

