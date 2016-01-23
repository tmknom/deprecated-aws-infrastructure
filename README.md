# aws-infrastructure

## コマンドチートシート

### SSHアクセス

```bash
ssh -l <user_name> -i <key_path> -p <port> <ip_address>
```

### itamae

#### baseロール

```bash
itamae ssh configuration/roles/base.rb -u ec2-user -p 22 -i ~/.ssh/aws/initialize.pem -h <ip_address>
```

#### railsロール

```bash
itamae ssh configuration/roles/rails.rb -u ec2-user -p <port>> -i ~/.ssh/aws/initialize.pem -h <ip_address>
```

### Serverspec

#### パスワード聞いてほしい場合

```bash
ASK_SUDO_PASSWORD=true \
PORT=<port> \
USER=<user_name> \
KEY_PATH=<key_path> \
ROLE=<role> \
HOST_IP=<ip_address> \
bundle exec rake spec
```

#### パスワードを直接渡す場合

```bash
SUDO_PASSWORD=xxxx \
PORT=<port> \
USER=<user_name> \
KEY_PATH=<key_path> \
ROLE=<role> \
HOST_IP=<ip_address> \
bundle exec rake spec
```
