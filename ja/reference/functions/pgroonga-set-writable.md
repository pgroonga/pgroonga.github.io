---
title: pgroonga_set_writable関数
upper_level: ../
---

# `pgroonga_set_writable`関数

## 概要

`pgroonga_set_writable`関数はPGroongaのデータを変更できるかどうか設定します。通常、この設定をする必要はありません。

この関数を使うことでオンラインバックアップを実現できます。この使い方をする場合は以下の条件を満たす必要があります。

  * データを変更したあとは同一セッション内で必ず`SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])`を実行します。

  * PGroongaのインデックスを使っているテーブルは[オートバキューム][postgresql-autovacuum]を無効にします。該当テーブルだけオートバキュームを無効にするために[`CREATE TABLE`][postgresql-create-table]の`autovacuum_enabled`ストレージパラメーターを使えます。オートバキュームを無効にした場合は手動で`VACUUM`を実行しなければいけないことに注意してください。

  * PGroongaのWALを有効にします。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga_set_writable(new_writable)
```

`new_writable`は`bool`型の値です。`true`は変更可能で`false`は変更不可能という意味です。

変更する前は変更可能だったかどうかを返します。

## 使い方

サンプルスキーマとデータは次の通りです。

```sql
SET pgroonga.enable_wal = yes;

CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);

INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
```

`pgroonga_writable`関数に`false`を渡した後はPGroongaのインデックスを変更できません。

```sql
SELECT pgroonga_set_writable(false);
--  pgroonga_set_writable 
-- -----------------------
--  t
-- (1 row)
INSERT INTO memos VALUES ('Groonga is great!');
-- ERROR:  pgroonga: can't insert a record while pgroonga.writable is false
```

```sql
SELECT pgroonga_set_writable(true);
--  pgroonga_set_writable 
-- -----------------------
--  f
-- (1 row)
INSERT INTO memos VALUES ('Groonga is great!');
-- INSERT 0 1
```

## オンラインバックアップ {#online-backup}

この関数を使うことでオンラインバックアップを実現できます。この使い方をする場合は以下の条件を満たす必要があります。

  * データを変更したあとは同一セッション内で必ず`SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])`を実行します。

  * PGroongaのインデックスを使っているテーブルは[オートバキューム][postgresql-autovacuum]を無効にします。該当テーブルだけオートバキュームを無効にするために[`CREATE TABLE`][postgresql-create-table]の`autovacuum_enabled`ストレージパラメーターを使えます。オートバキュームを向こうにした場合は手動で`VACUUM`を実行しなければいけないことに注意してください。

  * PGroongaのWALを有効にします。

次の設定を`postgresql.conf`に追加します。

```text
pgroonga.enable_wal = yes
```

オートバキュームを無効にします。

```sql
CREATE TABLE memos (
  content text
) WITH (autovacuum_enabled = false);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content);
```

データを変更した後は同一セッション内で`SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes'])`を呼びます。

```sql
INSERT INTO memos VALUES ('PGroonga (PostgreSQL+Groonga) is great!');
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

バックアップ作成前に手動で[`VACUUM`][postgresql-vacuum]を実行することを推奨します。

```sql
VACUUM ANALYZE memos;
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

バックアップ作成前にPGroongaのデータを変更できないようにします。

```sql
SELECT pgroonga_set_writable(false);
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

これでPostgreSQLを止めずにバックアップを作成できます。

```shell
db_name="YOUR_DB_NAME"

# Detect database information
db_oid=$(psql \
  --dbname ${db_name} \
  --no-psqlrc \
  --no-align \
  --tuples-only \
  -c "SELECT datid FROM pg_stat_database WHERE datname = '${db_name}'")
data_dir=$(psql \
  --dbname ${db_name} \
  --no-psqlrc \
  --no-align \
  --tuples-only \
  -c "SHOW data_directory")

# Define directories
db_dir=${data_dir}/base/${db_oid}
backup_dir=${data_dir}/../../backup

# Create backup directory
mkdir -p ${backup_dir}

# Create backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${db_dir}/ ${backup_dir}/
```

PGroongaのWALを削除することを推奨します。[`pgroonga_wal_truncate`関数][wal-truncate]は変更不可のときでも実行できます。

```sql
SELECT pgroonga_wal_truncate();
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

If you truncate PGroonga's WAL, you must create backup again with the above shell script. The process will be fast because `rsync` copies only different data.

PGroongaのデータを変更可能に戻します。

```sql
SELECT pgroonga_set_writable(true);
SELECT pgroonga_command('io_flush', ARRAY['only_opened', 'yes']);
```

## 参考

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga_wal_truncate`関数][wal-truncate]

[postgresql-autovacuum]:{{ site.postgresql_doc_base_url.ja }}/routine-vacuuming.html#AUTOVACUUM

[postgresql-create-table]:{{ site.postgresql_doc_base_url.ja }}/sql-createtable.html

[postgresql-vacuum]:{{ site.postgresql_doc_base_url.ja }}/sql-vacuum.html

[enable-wal]:../parameters/enable-wal.html

[wal-truncate]:pgroonga-wal-truncate.html
