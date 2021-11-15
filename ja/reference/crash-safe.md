---
title: クラッシュセーフ
---

# クラッシュセーフ

PGroongaは2.3.3からクラッシュセーフ機能に対応しています。

この機能はまだ実験的です。もし問題を見つけたら [PGroonga Issues][pgroonga-issues] に報告してください。

このドキュメントは次のことを説明します。

  * PGroonga用のクラッシュセーフ機能の設定方法

  * PGroonga用のクラッシュセーフ機能はどう動くか

## 概要

PGroonga用のクラッシュセーフ機能はGroongaのクラッシュセーフ機能を使っています。PostgreSQLのWALを使ったPostgreSQLのクラッシュセーフ機能は使っていません。

メリット：

  * PostgreSQLのプロセスがクラッシュしたとき、PGroongaのインデックスが自動で復旧する

    * 手動で[`REINDEX`][postgresql-reindex]を実行する必要はない

欠点：

  * 書き込み性能が悪化する

## クラッシュセーフ機能の設定方法

このセクションではクラッシュセーフ機能の設定方法を説明します。

`postgresql.conf`で次のパラメーターを指定しなければいけません。

```text
shared_preload_libraries = 'pgroonga_crash_safer'
pgroonga.enable_crash_safe = on
```

[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]はワーカープロセスを使います。[`max_worker_processes`パラメーター][postgresql-max-worker-processes]の値を増やさないといけないかもしれません。詳細は[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を参照してください。

## クラッシュセーフ機能はどう動くか

このセクションではクラッシュセーフ機能はどう動くかを説明します。

PGroongaのクラッシュセーフ機能はGroongaのクラッシュセーフ機能を使っています。

Groongaのクラッシュセーフ機能は、他のすべてのプロセスがGroongaのデータベースを開く前にデータベースを開き、他のすべてのプロセスがGroongaのデータベースを閉じた後にデータベースを閉じるプロセスが必要です。このプロセスを「プライマリープロセス」と呼びます。プライマリープロセスはメモリー上にある変更を定期的にストレージにフラッシュします。

[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]はPostgreSQLのデータベースごとにプライマリープロセスを起動します。PGroongaの機能を使う接続が現れると、この接続用のプロセスは[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]に対象のPostgreSQLのデータベース用にプライマリープロセスを起動するように依頼します。その後、プライマリープロセスがGroongaのデータベースを開くまで待ちます。

PGroongaの機能を使う接続用のプロセスを「セカンダリープロセス」と呼びます。プライマリープロセスは1つだけですが、セカンダリープロセスは0個以上存在できます。

セカンダリープロセスはPGroongaのインデックスが更新されるごとに（PostgreSQLのWALではなく）GroongaのWALを書き出します。メモリー上のWALの内容は確実にストレージにフラッシュします。ここで書き込み性能が落ちます。

プライマリープロセスはシャットダウン時にメモリー上のすべての変更をストレージに書き出してGroongaのすべてのWALファイルを削除します。つまり、正常にシャットダウンしたときはGroongaのWALファイルは存在しません。スタートアップ時にWALファイルがあった場合はプライマリープロセスは対象データベースを自動で復旧します。プライマリープロセスはGroongaのWALからの復旧を試みます。これが失敗すると既存のGroongaのデータベースを削除し、新しくGroongaのデータベースを作ります。その後、[`REINDEX`][postgresql-reindex]を実行します。これによりPostgreSQL内のデータからPGroongaのインデックスを再構築します。

プライマリープロセスが定期的にフラッシュするときにGroongaのWALファイルは削除されます。そのため、GroongaのWALのサイズが永遠に増え続けるということはありません。フラッシュする間隔は[`pgroonga_crash_safer.flush_naptime`パラメーター][pgroonga-crash-safer-flush-naptime]で設定できます。


[postgresql-reindex]:{{ site.postgresql_doc_base_url.ja }}/sql-reindex.html

[pgroonga-crash-safer]:modules/pgroonga-crash-safer.html

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-crash-safer-flush-naptime]:parameters/pgroonga-crash-safer-flush-naptime.html

[pgroonga-issues]:https://github.com/pgroonga/pgroonga/issues
