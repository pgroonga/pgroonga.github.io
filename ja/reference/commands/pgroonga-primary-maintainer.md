---
title: pgroonga-primary-maintainer.sh コマンド
upper_level: ../
---

# `pgroonga-primary-maintainer.sh` コマンド

3.2.1で追加

## お知らせ

PostgreSQL 15以上であれば[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]をご利用ください。そのモジュールを利用するほうがより良い方法でおすすめです。

## 概要

`pgroonga-primary-maintainer.sh`コマンドはPGroongaのWALのサイズがしきい値を超えたインデックスに対して、`REINDEX INDEX CONCURRENTLY` を実行します。

このコマンドを実行することで、WALが有効になっている(`pgroonga.enable_wal = yes`が設定されている)プライマリーサーバーにおいてWALのサイズの肥大化を防ぐことができます。

注意:

* このコマンドはプライマリーで動かすことを前提としているため、スタンバイでは実行しないでください。

* このコマンドは定期実行することを前提としているため、[`pgroonga-generate-primary-maintainer-service.sh`マンド][generate-primary-maintainer-service]と[`pgroonga-generate-primary-maintainer-timer.sh`コマンド][generate-primary-maintainer-timer]を使って定期実行の設定をしてください。

## 使い方

```
pgroonga-primary-maintainer.sh --threshold REINDEX_THRESHOLD_SIZE [--psql PSQL_COMMAND_PATH]

Options:
-t, --threshold:
  If the specified value is exceeded, `REINDEX INDEX CONCURRENTLY` is run.
  Specify by size.
  Example: --threshold 10M, -t 1G
-c, --psql:
  Specify the path to `psql` command.
-h, --help:
  Display help text and exit.

Connection information such as `dbname` should be set in environment variables.
See also: https://www.postgresql.org/docs/current/libpq-envars.html
```

* `--threshold` オプション

  * `REINDEX INDEX CONCURRENTLY` を実行するWALサイズのしきい値を指定します

* `--psql` オプション

  * `psql` コマンドのパスを指定します

* 環境変数

  * DBへの接続情報などは環境変数で指定します

  * [PostgreSQLの環境変数][postgresql-environment-variables]

## 実行例

[`pgroonga-generate-primary-maintainer-service.sh`コマンド][generate-primary-maintainer-service]と[`pgroonga-generate-primary-maintainer-timer.sh`コマンド][generate-primary-maintainer-timer]で定期実行の設定をした例です。

[`pgroonga-generate-primary-maintainer-service.sh`コマンド][generate-primary-maintainer-service]と[`pgroonga-generate-primary-maintainer-timer.sh`コマンド][generate-primary-maintainer-timer]についてはリンク先を参照してください。

この例ではしきい値を `--threshold 20K` で指定しました。これは `last_block >= 2`のときに`REINDEX`が動くサイズです。

### クエリの例

```sql
CREATE TABLE notes (content text);
CREATE INDEX ${NOTES_INDEX_NAME} ON notes USING pgroonga (content);
INSERT INTO notes SELECT 'NOTES' FROM generate_series(1, 200);
DELETE FROM notes;
```

`pgroonga_wal_status()`の結果を確認します:

```sql
SELECT name, last_block FROM pgroonga_wal_status();
    name     | last_block 
-------------+------------
 notes_index |          2
(1 row)
```

### ログの確認

#### しきい値を超えたとき

実行するSQL、`REINDEX` の開始時間、 `REINDEX` の終了時間を出力します。

```console
$ grep pgroonga-primary-maintainer.sh /var/log/messages
...
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84272]: Run 'REINDEX INDEX CONCURRENTLY notes_index'
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84289]: Thu Jul  4 00:39:26 UTC 2024
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84290]: REINDEX
Jul  4 00:39:26 example pgroonga-primary-maintainer.sh[84343]: Thu Jul  4 00:39:26 UTC 2024
...
```

複数のインデックスのWALのサイズがしきい値を超えていた場合は、シーケンシャルに `REINDEX` を実行します。

`pgroonga_wal_status()`の結果を確認します:

```sql
SELECT name, last_block FROM pgroonga_wal_status();
    name     | last_block 
-------------+------------
 notes_index |          1
(1 row)
```

#### しきい値を超えていないとき

出力はありません。

## 参考

  * [`pgroonga-generate-primary-maintainer-service.sh` コマンド][generate-primary-maintainer-service]

  * [`pgroonga-generate-primary-maintainer-timer.sh` コマンド][generate-primary-maintainer-timer]

  * [PostgreSQLの環境変数][postgresql-environment-variables]

  * [`pgroonga_wal_status`関数][wal-status]

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

[enable-wal]:../parameters/enable-wal.html

[generate-primary-maintainer-service]:pgroonga-generate-primary-maintainer-service.html

[generate-primary-maintainer-timer]:pgroonga-generate-primary-maintainer-timer.html

[pgroonga-wal-resource-manager]:../modules/pgroonga-wal-resource-manager.html

[postgresql-environment-variables]:{{ site.postgresql_doc_base_url.en }}/libpq-envars.html

[wal-status]:../functions/pgroonga-wal-status.html
