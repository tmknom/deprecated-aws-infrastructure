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

設定サンプルとして、[envrc.example](/development/environment_variable/envrc.example) を参考に行う。


### SSH_SHADOW_PASSWORD

SSH_SHADOW_PASSWORD にはSSHログインユーザのパスワードをshadow化した文字列を設定する。

パスワードのshadow化には **unix-crypt** を使う。

Gemfileには追加済みなので、bundle installしていればすぐに使用可能。

```bash
$ bundle exec mkunixcrypt
Enter password:＜パスワード入力＞
Verify password:＜もう一回パスワード入力＞
```


## 設定内容の確認

```bash
$ grep -v -e '^\s*#' -e '^\s*$' .envrc
```

