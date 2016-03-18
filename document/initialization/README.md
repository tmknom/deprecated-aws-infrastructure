# AWSアカウント取得後にやること

## 事前準備

1. 最低限のAWSアカウントの初期設定
 * http://qiita.com/tmknom/items/303db2d1d928db720888
2. AWS CLIを使用できるようにする
 * 管理コンソールでユーザ作成＆アクセストークン払い出し
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

