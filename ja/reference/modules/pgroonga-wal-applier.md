---
title: pgroonga_wal_applierモジュール
upper_level: ../
---

# `pgroonga_wal_applier`モジュール

2.3.3で追加。

`pgroonga_wal_applier` モジュールは、2.4.2から非推奨です。代わりに [`pgroonga_standby_maintainer` モジュール][pgroonga-standby-maintainer] を使ってください。

## 概要

`pgroonga_wal_applier`モジュールは[`pgroonga_wal_apply`関数][pgroonga-wal-apply]で未適用のWALを定期的に適用します。

[`pgroonga.max_wal_size`パラメーター][max-wal-size]を設定して最大WALサイズを制限したい場合は`pgroonga_wal_applier`モジュールを使ってください。

プライマリーサーバーで`pgroonga_wal_applier`モジュールを使う必要はありません。未適用のWALは存在しないからです。スタンバイサーバーでだけ`pgroonga_wal_applier`モジュールを使う必要があります。

## 使い方

[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に`pgroonga_wal_applier`を追加することで`pgroonga_wal_applier`モジュールを使えます。

例：

```text
shared_preload_libraries = 'pgroonga_wal_applier'
```

## パラメーター

  * [`pgroonga_wal_applier.naptime`パラメーター][pgroonga-wal-applier-naptime]

## 参考

 * [ストリーミングレプリケーション][streaming-replication]

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-apply]:../functions/pgroonga-wal-apply.html

[max-wal-size]:../parameters/max-wal-size.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[pgroonga-wal-applier-naptime]:../parameters/pgroonga-wal-applier-naptime.html

[streaming-replication]:../streaming-replication.html
