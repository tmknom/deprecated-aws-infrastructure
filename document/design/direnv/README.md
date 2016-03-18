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
# AWS関連の設定
export AWS_ACCOUNT_ID='xxxxxxxx'
export AWS_ACCOUNT_ID_MD5=$(echo $AWS_ACCOUNT_ID | md5)

# terraform用AWS関連の設定
export TF_VAR_aws_account_id="$AWS_ACCOUNT_ID"
export TF_VAR_s3_suffix=$(echo $AWS_ACCOUNT_ID_MD5 | cut -c 1-12)
```

## 設定内容の確認

```bash
$ grep -v -e '^\s*#' -e '^\s*$' .envrc
```

