---
title: pgroonga_wal_resource_manager モジュール
upper_level: ../
---

# `pgroonga_wal_resource_manager` モジュール

3.2.1で追加

PostgreSQL 15以上で利用できます。

## 概要

`pgroonga_wal_resource_manager`モジュールは PostgreSQL の [カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers] を利用し、自動的にPGroongaのWALを適用します。

WALリソースマネージャーサポートを有効にするとPostgreSQLの[カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]機能を利用します。詳細は[WALリソースマネージャーを使ったストリーミングレプリケーション][streaming-replication-wal-resource-manager]を参照してください。

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

* PGroonga 4.1.0以前のプライマリーでこのモジュールを[crash-safer][pgroonga-crash-safer]なしで使っていた場合、プライマリーにGroongaのWALファイルが残っています

  * 詳細は[crash-saferなしのプライマリーにあるGroongaのWALファイル](#groonga-wal-files-in-primary-without-crash-safer)を参照してください

## crash-saferなしのプライマリーにあるGroongaのWALファイル {#groonga-wal-files-in-primary-without-crash-safer}

このセクションは、このモジュールを[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]なしで使っているプライマリーだけが対象です。

PGroonga 3.2.1から4.1.0は、この構成でGroongaのWAL（PostgreSQLのWALではありません）を書きます。GroongaのWALはデータベースディレクトリーにある`pgrn*.wal`ファイルに書かれます。[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]がないと、これらのファイルを使う人も削除する人もいません。そのため、`pgrn*.wal`ファイルは増え続けます。PostgreSQLを再起動しても削除されません。

PGroonga 4.1.1以降は、この構成ではGroongaのWALを書きません。しかし、PGroonga 4.1.1以降はPGroonga 4.1.0以前が書いた`pgrn*.wal`ファイルを削除しません。PGroongaを4.1.1以降にアップグレードした後に、手動で削除する必要があります。アップグレードする前に削除しても、PGroonga 4.1.0以前がまた書いてしまいます。削除手順は次の通りです。

  1. PostgreSQLを正常終了する

  2. PGroongaを使っているすべてのデータベースディレクトリーにあるすべての`pgrn*.wal`ファイルを削除する

  3. PostgreSQLを起動する

例：

```bash
sudo -H systemctl stop postgresql
sudo -u postgres -H find /var/lib/postgresql/18/main/base -name 'pgrn*.wal' -delete
sudo -H systemctl start postgresql
```

この例はDebianとUbuntuでのPostgreSQL 18のデフォルトのデータディレクトリーを想定しています。テーブルスペースを使っている場合は、テーブルスペースのディレクトリーにある`pgrn*.wal`ファイルも削除する必要があります。それらは`base/`にはありません。

PostgreSQLが動いている間は`pgrn*.wal`ファイルを削除してはいけません。

プライマリーで[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を有効にする場合は、その前にこれらのファイルを削除しなければいけません。残っていると、[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]はこれらのファイルからPGroongaのインデックスをリカバリーしようとします。これらのファイルは古いので、PGroongaをアップグレードした後に追加したデータがPGroongaのインデックスから失われることがあります。これらのファイルが残ったまま[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を有効にしてしまった場合は、すべてのPGroongaのインデックスに対して[`REINDEX`][postgresql-reindex]を実行する必要があります。

## パラメーター

  * [`pgroonga.enable_wal_resource_manager`パラメーター][enable-wal-resource-manager]

  * [`pgroonga_wal_resource_manager.log_level`パラメーター][pgroonga-wal-resource-manager-log-level]

  * [`pgroonga_wal_resource_manager.log_path`パラメーター][pgroonga-wal-resource-manager-log-path]

## 参考

  * [`pgroonga_standby_maintainer`モジュール][pgroonga-standby-maintainer]

  * [カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]

[enable-wal-resource-manager]:../parameters/enable-wal-resource-manager.html

[enable-wal]:../parameters/enable-wal.html

[pgroonga-crash-safer]:pgroonga-crash-safer.html

[pgroonga-standby-maintainer]:../modules/pgroonga-standby-maintainer.html

[pgroonga-wal-resource-manager-log-level]:../parameters/pgroonga-wal-resource-manager-log-level.html

[pgroonga-wal-resource-manager-log-path]:../parameters/pgroonga-wal-resource-manager-log-path.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.ja }}/sql-reindex.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[streaming-replication-wal-resource-manager]:../streaming-replication-wal-resource-manager.html
