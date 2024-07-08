---
title: Replication
---

# Replication

PGroonga supports PostgreSQL's built-in [WAL based streaming replication][postgresql-wal] and [logical replication][postgresql-logical-replication].

See the following pages for details:

  * [Streaming replication by WAL resource manager][streaming-replication-wal-resource-manager]

    * This requires PGroonga 3.2.1 or later and PostgreSQL 15 or later

    * This is recommended than [streaming replication][streaming-replication]

  * [Streaming replication][streaming-replication]

    * This requires PGroonga 1.1.6 or later

  * [Logical replication][logical-replication]

    * This requires PGroonga 1.2.4 or later

[postgresql-wal]:{{ site.postgresql_doc_base_url.en }}/warm-standby.html

[postgresql-logical-replication]:{{ site.postgresql_doc_base_url.en }}/logical-replication.html

[streaming-replication-wal-resource-manager]:streaming-replication-wal-resource-manager.html

[streaming-replication]:streaming-replication.html

[logical-replication]:logical-replication.html
