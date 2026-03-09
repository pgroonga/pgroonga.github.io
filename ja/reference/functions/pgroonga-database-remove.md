---
title: pgroonga_database_remove関数
upper_level: ../
---

# `pgroonga_database_remove`関数

2.1.8で追加。

## 概要

`pgroonga_database_remove`関数はPostgreSQLのデータベースディレクトリー内のPGroonga関連のすべてのファイル（`pgrn*`ファイル）を削除します。

この関数を使うには[`pgroonga_database`モジュール][pgroonga-database]をインストールする必要があります。

この関数は危険な関数です。この関数が必要になるまでこの関数を有効にしないでください。

通常、PGroonga関連のファイルを削除する必要はありません。もしPGroongaのインデックスが破損した場合は、[`REINDEX`][postgresql-reindex]で復旧できます。しかし、PGroonga内部のデータベースが壊れたときは`REINDEX`では復旧できません。


PGroongaの内部データベースが壊れたときに復旧する手順は次の通りです。

  1. PostgreSQLへの接続をすべて切断する


  2. PostgreSQLのデータディレクトリーにあるすべての`pgrn*`ファイルを削除する

     もし、テーブルスペースを使っているならテーブルスペースのディレクトリー内にある`pgrn*`ファイルも削除します。

     PostgreSQLが動いているホストにログインする必要があります。

  3. PostgreSQLに接続する

  4. すべてのPGroongaのインデックスに対して`REINDEX`を実行する

     これでPGroongaの内部データベースが作られ、PostgreSQL内のデータを使ってすべてのPGroongaのインデックスが再作成されます。

`pgroonga_database_remove`関数はすべての`pgrn*`ファイルを削除します。この関数はテーブルスペースにも対応しています。

`pgroonga_database_remove`関数を使うとPostgreSQLが動いているホストにログインする必要はありません。`pgroonga_database_remove`関数を使った復旧手順は次の通りです。

  1. PostgreSQLへの接続をすべて切断する


  2. PostgreSQLに接続する

  3. `SELECT pgroonga_database_remove()`を実行する

  4. すべてのPGroongaのインデックスに対して`REINDEX`を実行する

     これでPGroongaの内部データベースが作られ、PostgreSQL内のデータを使ってすべてのPGroongaのインデックスが再作成されます。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga_database_remove()
```

この関数は常に`true`を返します。なぜなら、もし問題があった場合は`false`を返すのではなくエラーにするからです。

## 使い方

壊れたPGroongaの内部データベースを復旧する手順は次の通りです。

最初にすべての接続を切断します。PGroongaの内部データベースを使っている接続が残っているとそれらの接続はクラッシュするかもしれません。

次にPostgreSQLに再度接続し、`pgroonga_database_remove()`関数を実行します。

```sql
SELECT pgroonga_database_remove();
```

次にこの接続を切断します。

この接続では`pgroonga_database`モジュールが提供する機能以外はPGroongaのどの機能も使ってはいけません。もしPGroongaの機能を使うとこの接続でPGroongaの内部データベースを開こうとします。そうするとクラッシュするかもしれません。

次にPostgreSQLに再接続してすべてのPGroongaのインデックスを再作成します。

```sql
REINDEX INDEX pgroonga_index1;
REINDEX INDEX pgroonga_index2;
-- ...
```

これで復旧完了です。PostgreSQLが動いているホストにログインする必要はありません。

## 参考

  * [`pgroonga_database`モジュール][pgroonga-database]

[pgroonga-database]:../modules/pgroonga-database.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.ja }}/sql-reindex.html
