---
title: pgroonga_wal_resource_manager モジュール
upper_level: ../
---

# `pgroonga_wal_resource_manager` モジュール

3.2.1で追加

PostgreSQL 15以上で利用できます。

## 概要

`pgroonga_wal_resource_manager`モジュールは PostgreSQL の [Custom WAL Resource Managers][postgresql-custom-wal-resource-managers] を利用し、自動的にPGroongaのWALを適用します。

## 使い方

`pgroonga_wal_resource_manager` モジュールを使うには、以下のパラメーターをプライマリーとスタンバイで設定しなければなりません。

  * [`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]

例：

```text
shared_preload_libraries = 'pgroonga_wal_resource_manager'
```

プライマリでは合わせて[`pgroonga.enable_wal_resource_manager`パラメーター][enable-wal-resource-manager]を設定する必要があります。

例：

```text
pgroonga.enable_wal_resource_manager = yes
```

## 注意

* [`pgroonga.enable_wal = yes`][enable-wal] は同時に設定しないでください

  * このモジュールの利点であるWALサイズが増加し続けなくなる効果がなくなります

* このモジュールを有効にした場合、スタンバイで[crash-safer][pgroonga-crash-safer]を有効にしないでください

  * スタンバイではこのモジュールがリカバリーするためです

  * プライマリーではリカバリーしないので、プライマリーでクラッシュセーフにしたい場合は[crash-safer][pgroonga-crash-safer]を有効にする必要があります

## パラメーター

  * [`pgroonga.enable_wal_resource_manager` parameter][enable-wal-resource-manager]

  * [`pgroonga_wal_resource_manager.log_level`パラメーター][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path`パラメーター][pgroonga-wal-resource-manager-log-path]

## 参考

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

  * [カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]

[enable-wal-resource-manager]:../parameters/enable-wal-resource-manager.html

[enable-wal]:../parameters/enable-wal.html

[pgroonga-crash-safer]:../reference/modules/pgroonga-crash-safer.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES
