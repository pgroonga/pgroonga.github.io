---
title: pgroonga_wal_truncate関数
upper_level: ../
---

# `pgroonga_wal_truncate`関数

## 概要

`pgroonga_wal_truncate`関数はPGroongaのWALをすべて削除します。PostgreSQLのWALではなくPGroongaのWALであることに注意してください。PGroongaのWALはこの関数を呼ばない限り削除されません。バックアップをとっていればPGroongaのWALを削除できます。

PGroongaのWALをすべて削除してもPGroongaのWALが使っているディスク使用量は減らないことに注意してください。使用されていたディスク領域は新しく追加するWALが再利用します。

PGroongaのWALを使う場合、PGroongaのWALのディスク使用量について検討する必要があります。なにもしないとPGroongaのWALは増え続けます。対策は次のどちらかです。

  1. 定期的にバックアップをとり、PGroongaのWALを削除する。

  2. 定期的にPGroongaのインデックスを再作成する。PGroongaのWALは次の`VACUUM`時に削除される。

## 構文

この関数の構文は次の通りです。

```text
bitint pgroonga_wal_truncate(pgroonga_index_name)
```

`pgroonga_index_name`は`text`型の値です。すべてのWALを削除したいPGroongaのインデックスの名前を指定します。

削除したPostgreSQLのデータブロック数を返します。PGroongaのWALはPostgreSQLのデータブロックに記録してあります。

この関数の別の構文は次の通りです。

```text
bigint pgroonga_wal_truncate()
```

すべてのPGroongaのインデックスのすべてのWALを削除します。

削除したPostgreSQLのデータブロック数を返します。PGroongaのWALはPostgreSQLのデータブロックに記録してあります。

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

PGroongaのデータベースが壊れた状況を再現します。

```sql
SELECT pgroonga_command('delete',
                        ARRAY[
                          'table', 'IndexStatuses',
                          'key', 'pgroonga_memos_index'::regclass::oid::text
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', 'Lexicon' ||
                                  'pgroonga_memos_index'::regclass::oid ||
                                  '_0'
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
SELECT pgroonga_command('table_remove',
                        ARRAY[
                          'name', pgroonga_table_name('pgroonga_memos_index')
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
```

通常、PGroongaのWALを使って自動的にPGroongaのインデックスを復旧できます。しかし、PGroongaのインデックスに対するPGroongaのWALが削除されている場合は自動で復旧できません。（明示的に再作成することで壊れたPGroongaのインデックスを復旧することはできます。）

```sql
SELECT pgroonga_wal_truncate('pgroonga_memos_index');
--  pgroonga_wal_truncate 
-- -----------------------
--                      2
-- (1 row)
SELECT * FROM memos WHERE content &@~ 'Groonga';
-- ERROR:  pgroonga: object isn't found: <Sources555045>
```

PGroongaのインデックスの名前は省力できます。PGroongaのインデックスの名前を省略すると、すべてのPGroongaのインデックスのすべてのWALを削除します。

```sql
SELECT pgroonga_wal_truncate();
--  pgroonga_wal_truncate 
-- -----------------------
--                      2
-- (1 row)
```

## バックアップとPGroongaのWALの削除 {#backup-and-pgroonga-wal-truncation}

PGroongaのデータはクラッシュセーフではありません。PGroongaのWALを有効にしている場合はPGroongaのデータだけバックアップをとればより速く復旧できます。PostgreSQL全体のデータをバックアップする必要はありません。バックアップには[`rsync`][rsync]が便利です。

ストレージ故障に対応するために別のホストにPostgreSQLのバックアップを作るべきだということは忘れないでください。

以下はバックアップを作成し、リストアするシェルスクリプトの例です。

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

# Stop PostgreSQL
systemctl stop postgresql-10

# Create backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${db_dir}/ ${backup_dir}/

# Run PostgreSQL
systemctl start postgresql-10

# Remove PGroonga's WAL
psql --dbname ${db_name} -c "SELECT pgroonga_wal_truncate()"

# ...PostgreSQL is crashed...

# Restore from backup
rsync -a --include '/pgrn*' --exclude '*' --delete ${backup_dir}/ ${db_dir}/

# Run PostgreSQL again
systemctl restart postgresql-10
```

## 参考

  * [`pgroonga.enable_wal`パラメーター][enable-wal]

  * [`pgroonga_wal_apply`関数][wal-apply]

  * [`pgroonga_set_writable`関数][set-writable]

[enable-wal]:../parameters/enable-wal.html

[wal-apply]:pgroonga-wal-apply.html

[set-writable]:pgroonga-set-writable.html

[rsync]:https://rsync.samba.org/
