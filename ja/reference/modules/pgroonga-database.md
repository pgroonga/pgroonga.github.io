---
title: pgroonga_databaseモジュール
upper_level: ../
---

# `pgroonga_database`モジュール

2.1.8で追加。

## 概要

`pgroonga_database`モジュールはPGroongaのデータベースを管理する関数を提供します。通常、このモジュールを使う必要はありません。

## 使い方

拡張機能として`pgroonga_database`モジュールをインストールすれば使えます。

```sql
CREATE EXTENSION pgroonga_database;
```

`pgroonga_database`のアップグレード方法は[アップグレード][upgrade]ドキュメントを参照してください。

## 関数

`pgroonga_database`モジュールは次の関数を提供します。

  * [`pgroonga_database_remove`関数][database-remove]

[database-remove]:functions/pgroonga-database-remove.html

[upgrade]:../../upgrade/
