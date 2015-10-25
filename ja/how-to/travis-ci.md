---
title: Travis CI上でPGroongaを使う方法
layout: ja
---

# Travis CI上でPGroongaを使う方法

[Travis CI](https://travis-ci.org/)上でPGroongaを使うことができます。

PGroongaはTravis CI上でPGroongaをセットアップするシェルスクリプトを提供しています。

`.travis.yml`に次の設定を追加してください。

```yaml
sudo: required
install:
  - curl --silent --location https://github.com/pgroonga/pgroonga/raw/master/data/travis/setup.sh | sh
```

`sudo: required`は重要です。このセットアップスクリプトは`sudo`を使っています。そのため、`sudo: required`が必要なのです。

このセットアップスクリプトは`template1`データベースに対して`CREATE EXTENSION pgroonga`を実行します。これは新しいデータベースを作成したら何もしなくてもPGroongaを使える状態になっているということです。
