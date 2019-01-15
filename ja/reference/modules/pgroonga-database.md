---
title: pgroonga_databaseモジュール
upper_level: ../
---

# `pgroonga_database`モジュール

2.1.8で追加。

## 概要

`pgroonga_database`モジュールはPGroongaのデータベースを管理する関数を提供します。通常、このモジュールを使う必要はありません。

このモジュールは危険な関数をていんきょうするので気をつけてください。必要になるまでこのモジュールは有効にしないでください。

## 使い方

`pgroonga_database`モジュールは拡張機能としてインストールできます。しかし、このモジュールが提供する関数をどのユーザーで使えるようにするかは注意深く検討してください。

スキーマを使うとこのモジュールが提供する関数を使えるユーザーを制限できます。

以下は、`pgroonga_admin`スキーマを作ってそこに`pgroonga_database`モジュールをインストールすることで「admin」ユーザーだけ使えるように制限する例です。

```sql
CREATE ROLE admin LOGIN;
CREATE SCHEMA pgroonga_admin AUTHORIZATION admin;
CREATE EXTENSION pgroonga_database SCHEMA pgroonga_admin;
```

この例では「admin」ユーザー以外はこのモジュールが提供する関数を使えません。

「admin」ユーザーは`pgroonga_admin.`プレフィクスをつけるとこのモジュールの関数を使えます。

```sql
SELECT pgroonga_admin.pgoronga_database_remove();
```

`pgroonga_database`のアップグレード方法は[アップグレード][upgrade]ドキュメントを参照してください。

## 関数

`pgroonga_database`モジュールは次の関数を提供します。

  * [`pgroonga_database_remove`関数][database-remove]

[database-remove]:../functions/pgroonga-database-remove.html

[upgrade]:../../upgrade/
