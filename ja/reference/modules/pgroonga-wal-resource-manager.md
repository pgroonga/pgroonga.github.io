---
title: pgroonga_wal_resource_manager モジュール
upper_level: ../
---

# `pgroonga_wal_resource_manager` モジュール

3.2.1で追加

PostgreSQL 15以上で利用できます。

## 概要

`pgroonga_wal_resource_manager` モジュールは PostgreSQL の [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers] を利用し、自動的にPGroongaのWALを適用します。

## 使い方

`pgroonga_wal_resource_manager` モジュールを使うには、以下のパラメーターを設定しなければなりません。

  * [`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]

例：

```text
shared_preload_libraries = 'pgroonga_wal_resource_manager'
```

## パラメーター

  * [`pgroonga_wal_resource_manager.log_level`パラメーター][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path`パラメーター][pgroonga-wal-resource-manager-log-path]

## 参考

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

  * [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers]

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html
