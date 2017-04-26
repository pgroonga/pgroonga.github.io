---
title: pgroonga_checkモジュール
upper_level: ../
---

# `pgroonga_check`モジュール

1.2.0で追加。

## 概要

`pgroonga_check`モジュールは起動時にPGroongaのデータベースの一貫性をチェックします。PGroongaのデータベースが壊れている場合は自動でそのデータベースを復旧します。

## 設定

`postgresql.conf`の[`shared_preload_libraries`]({{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES)に`pgroonga_check`を追加します。

```text
shared_preload_libraries = 'pgroonga_check'
```

この変更を反映するためにPostgreSQLを再起動する必要があります。

## 使い方

何もする必要はありません。`pgroonga_check`モジュールはPostgreSQL起動時にすべてのPGroongaのデータベースをチェックします。もし、`pgroonga_check`モジュールが壊れているPGroongaのデータベースを見つけたら、自動で復旧します。

復旧に失敗した場合は該当PGroongaデータベースを自動で削除します。PGroongaのデータベース内には復旧不可能なデータはありません。手動で[`REINDEX`]({{ site.postgresql_doc_base_url.ja }}/sql-reindex.html)を実行することでPGroongaのデータベースを復旧できます。
