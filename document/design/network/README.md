# ネットワーク設計

## VPC

VPCはリージョン毎に作成する。また、東京リージョンのみ、管理用VPC(Administration)を作成する。

### 東京リージョン

* Production
 * 10.10.0.0/16
* Administration
 * 192.168.0.0/16

### 北米リージョン

* Production
 * 10.20.0.0/16


## ネットワーク種別

以下では、VPCに10.10.0.0/16を割り当てた場合について例示する。

### Public

The Internetからアクセス可能。

ELBやNAT、踏み台サーバを置く。

* 10.10.0.0/18
* 10.10.0.0〜10.10.63.255

### Protected

The InternetからはELB/踏み台サーバ経由でアクセス。
The Internetへ通信を行う場合はNATを経由。

EC2で構築したアプリケーションサーバを置く。

* 10.10.64.0/18
* 10.10.64.0～10.10.127.255

### Private

The Internetとの通信不可。

RDSやElastiCacheなど、AWSのフルマネージドサービスを置く。

* 10.10.128.0/18
* 10.10.128.0～10.10.191.255

### Reserved

将来の拡張のため残してあるネットワーク。
現時点では使用しないため、terraformによる定義も行っていない。

* 10.10.192.0/18
* 10.10.192.0～10.10.255.255


## サブネット

/24でサブネットを切る。
アベイラビリティゾーンごとにサブネットを作成する。

例えばPublicネットワークの場合、下記のように設定する。

* Public-0
 * 10.10.0.0/24
 * ap-northeast-1a
* Public-1
 * 10.10.1.0/24
 * ap-northeast-1c
* Public-2
 * 10.10.2.0/24
 * ap-northeast-1a
* Public-3
 * 10.10.3.0/24
 * ap-northeast-1c

## 参考

* これだけ押さえておけば大丈夫！Webサービス向けVPCネットワークの設計指針
 * https://developers.eure.jp/tech/vpc_networking/
* AWSのネットワーク設計をサボらないでちゃんとやる
 * http://qiita.com/nisshiee/items/df4261132ec686964605
* VPCのSubnetのCIDRの設計方針(一例として)
 * http://blog.cloudpack.jp/2013/02/25/aws-news-vpc-cidr-az/

