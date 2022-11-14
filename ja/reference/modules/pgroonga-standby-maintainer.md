---
title: pgroonga_standby_maintainer module
upper_level: ../
---

# `pgroonga_standby_maintainer` module

2.4.2で追加。

まだ実験的な機能です。

## 概要

`pgroonga_standby_maintainer` モジュールは、 [`pgroonga_wal_apply()` 関数][pgroonga-wal-apply] と [`pgroonga_vacuum()` 関数][pgroonga-vacuum] をスタンバイのデータベース上で自動的に実行します。

通常、PGroongaとストリーミングレプリケーションを一緒に使っている場合、PGroongaのWALはスタンバイのデータベースには適用されません。
したがって、例えば、スタンバイのデータベースをプライマリーのデータベースに切り替えた後の最初の"SELECT"は遅い可能性があります。
未適用のPGroongaのWALを適用する時間があるためです。

また、スタンバイのデータベース上で定期的に [`pgroonga_vacuum()` 関数][pgroonga-vacuum] を使って不要なGroongaの内部テーブル、カラム、レコードを削除する必要があります。 スタンバイのデータベースでは、 `VACUUM` が実行されないためです。

前者のケースでは、 [`pgroonga_wal_applier` モジュール][pgroonga-wal-applier] を使って自動的にPGroongaのWALをスタンバイのデータベースに適用できますが、後者のケースでは、 [`pgroonga_vacuum()` 関数][pgroonga-vacuum]をスタンバイのデータベースで自動的に実行することができません。

`pgroonga_standby_maintainer` モジュールを使うことで、スタンバイのデータベースで [`pgroonga_wal_apply()` 関数][pgroonga-wal-apply] と [`pgroonga_vacuum()` 関数][pgroonga-vacuum] を自動的に実行できます。

したがって、 `pgroonga_standby_maintainer`モジュールを使えば、スタンバイのデータベース上で、 [`pgroonga_wal_applier` モジュール][pgroonga-wal-applier] と [`pgroonga_vacuum()` 関数][pgroonga-vacuum] を使う必要がありません。

## 使い方

`pgroonga_standby_maintainer` モジュールを使うには、以下のパラメーターを設定しなければなりません。

  * [`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]

例：

```text
shared_preload_libraries = 'pgroonga_standby_maintainer'
```

## パラメーター

  * [`pgroonga_standby_maintainer.naptime` パラメーター][pgroonga-standby-maintainer-naptime]

## 参考

  * [`pgroonga_wal_applier` モジュール][pgroonga-wal-applier]
  * [`pgroonga-wal-apply()` 関数][pgroonga-wal-apply]
  * [`pgroonga-vacuum()` 関数][pgroonga-vacuum]


[pgroonga-wal-applier]:./pgroonga-wal-applier.html
[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html
[pgroonga-vacuum]:../functions/pgroonga-vacuum.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-max-worker-processes]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-resource.html#GUC-MAX-WORKER-PROCESSES

[pgroonga-standby-maintainer-naptime]:../parameters/pgroonga-standby-maintainer-naptime.html
