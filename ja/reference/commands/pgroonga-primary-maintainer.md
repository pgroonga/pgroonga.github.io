---
title: pgroonga-primary-maintainer.sh コマンド
upper_level: ../
---

# `pgroonga-primary-maintainer.sh` コマンド

3.2.1で追加

## 概要

`pgroonga-primary-maintainer.sh` コマンドはPGroongaのWALのサイズがしきい値を超えたをインデックスに対して、`REINDEX INDEX CONCURRENTLY` を実行します。

このコマンドを実行することで、WALが有効になっているプライマリーサーバーにおいてWALのサイズの肥大化を防ぐことができます。

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

* `--threshold` option

  * `REINDEX INDEX CONCURRENTLY` を実行するWALサイズのしきい値を指定します

* `--psql` option

  * `psql` コマンドのパスを指定します

* 環境変数

  * DBへの接続情報などは環境変数で指定します

  * [PostgreSQLの環境変数][environment-variables]

## 実行例

Bashで実行する例

* 環境変数でDB名を指定

  * `PGDATABASE=test_database`

* しきい値を10GBで指定

  * `--threshold 10G`

### しきい値を超えていないとき

出力はありません。

```console
$ PGDATABASE=test_database \
  pgroonga-primary-maintainer.sh \
  --threshold 10G
```

### しきい値を超えたとき

実行するSQL、`REINDEX` の開始時間、 `REINDEX` の終了時間を出力します。

```console
$ PGDATABASE=test_database \
  pgroonga-primary-maintainer.sh \
  --threshold 10G
Run 'REINDEX INDEX CONCURRENTLY test_index'
Thu Jun 27 07:24:34 UTC 2024
REINDEX
Thu Jun 27 07:24:34 UTC 2024
```

複数のインデックスのWALのサイズがしきい値を超えていた場合は、シーケンシャルに `REINDEX` を実行します。

## 参考

  * [PostgreSQLの環境変数][environment-variables]

  * [`pgroonga_wal_status`関数][wal-status]

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

[environment-variables]:{{ site.postgresql_doc_base_url.ja }}/libpq-envars.html

[enable-wal]:../parameters/enable-wal.html

[wal-status]:pgroonga-wal-status.html
