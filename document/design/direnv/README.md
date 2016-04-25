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


## 設定内容の確認

```bash
$ grep -v -e '^\s*#' -e '^\s*$' .envrc
```

