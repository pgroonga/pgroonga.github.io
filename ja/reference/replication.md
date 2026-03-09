---
title: レプリケーション
---

# レプリケーション

PGroongaは、PostgreSQL組み込みの[WALベースのストリーミングレプリケーション機能][postgresql-wal]と[ロジカルレプリケーション][postgresql-logical-replication]をサポートしています。

詳細は以下のページを参照してください:

  * [WALリソースマネージャーを使ったストリーミングレプリケーション][streaming-replication-wal-resource-manager]

    * PGroonga 3.2.1以降とPostgreSQL 15以降が必要

    * [ストリーミングレプリケーション][streaming-replication]よりオススメ

  * [ストリーミングレプリケーション][streaming-replication]

    * PGroonga 1.1.6以降が必要

  * [ロジカルレプリケーション][logical-replication]

    * PGroonga 1.2.4以降が必要

[postgresql-wal]:{{ site.postgresql_doc_base_url.ja }}/warm-standby.html

[postgresql-logical-replication]:{{ site.postgresql_doc_base_url.ja }}/logical-replication.html

[streaming-replication-wal-resource-manager]:streaming-replication-wal-resource-manager.html

[streaming-replication]:streaming-replication.html

[logical-replication]:logical-replication.html
