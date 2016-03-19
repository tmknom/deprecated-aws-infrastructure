# AWSアカウント取得後にやること

## 事前準備

1. 最低限のAWSアカウントの初期設定
 * http://qiita.com/tmknom/items/303db2d1d928db720888
2. AWS CLIを使用できるようにする
 * 管理コンソールでユーザ作成＆アクセスキー払い出し
 * AWS CLIのインストール＆セットアップ
3. 環境変数を定義
 * [direnvの導入](/document/design/direnv/README.md)


## terraformの準備

### ログ格納用のS3バケット定義

```bash
$ cd orchestration/s3/s3_log
$ terraform get; terraform apply
```

### terraform用のS3バケット定義

```bash
$ cd orchestration/s3/terraform
$ terraform get; terraform apply
```

### tfstateファイルをS3に保存

```bash
$ cd orchestration/
$ fab terraform_plan:s3/s3_log
$ fab terraform_plan:s3/terraform
```


## CloudTrailの有効化

先にバケットを作っておかないとエラーになるため、
最初にバケットを作成して、それからCloudTrail自体を作成する。

```bash
$ fab update_s3_cloud_trail
$ fab update_cloud_trail
```


## IAMユーザ作成

### CLI用ユーザ

ユーザ作成後、管理コンソールからアクセスキーを払い出す。

```bash
$ fab update_user_cli
```

払い出したアクセスキーを設定する。

```bash
$ cp -p ~/.aws/credentials ~/.aws/credentials.bak
$ vi ~/.aws/credentials
```

AWS CLIが使えることを確認し、問題なければ、バックアップファイルを削除。

```bash
$ aws ec2 describe-vpcs
$ rm ~/.aws/credentials.bak
```

動作確認後、最初に手動で作成したユーザは削除する。
すぐに削除しない場合も、アクセスキーは無効にしておくこと。

