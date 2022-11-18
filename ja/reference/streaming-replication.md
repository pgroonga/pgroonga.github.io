---
title: ストリーミングレプリケーション
---

# ストリーミングレプリケーション

PGroongaは1.1.6からPostgreSQL組み込みの[WALベースのストリーミングレプリケーション機能][postgresql-wal]をサポートしています。

WALをサポートしているといってもクラッシュセーフではないことに注意してください。WALベースのストリーミングレプリケーションをサポートしているだけです。もし、PGroongaのインデックスを更新している最中にPostgreSQLがクラッシュしたら、そのPGroongaのインデックスは壊れるかもしれません。もし、PGroongaのインデックスが壊れたら[`REINDEX`][postgresql-reindex]で作り直さなければいけません。

参考：[クラッシュセーフ][crash-safe]

このドキュメントではPostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroonga用に設定する方法を説明します。多くの手順は通常のストリーミングレプリケーションの設定手順です。いくつかPGroonga固有の手順があります。

## 概要

PostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroonga用に設定する手順は次の通りです。「[通常]」タグは通常のストリーミングレプリケーション用の手順であることを示しています。「[固有]」タグはPGroonga固有の手順であることを示しています。

  1. [通常] プライマリーとスタンバイでPostgreSQLをインストールする

  2. [固有] プライマリーとスタンバイでPGroongaをインストールする

  3. [通常] プライマリーでPostgreSQLのデータベース初期化する

  4. [通常] プライマリーで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する

  5. [固有] プライマリーで`postgresql.conf`にPGroonga関連の設定を追加する

  6. [通常] プライマリーでデータを投入する

  7. [固有] プライマリーでPGroongaのインデックスを作成する

  8. [固有] プライマリーでPGroonga関連のデータをフラッシュする

  9. [通常] スタンバイで`pg_basebackup`を実行する

  10. [通常] スタンバイで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する

  11. [固有] スタンバイで`postgresql.conf`にPGroongaのWAL関連の設定を追加する

  12. [通常] スタンバイでPostgreSQLを起動する

## 例で使う環境

このドキュメントでは次の環境を使います。

  * プライマリー：

    * OS：CentOS 7

    * IPアドレス：192.168.0.30

    * データベース名：`blog`

    * レプリケーションユーザー名：`replicator`

    * レプリケーションユーザーのパスワード：`passw0rd`

  * スタンバイ1：

    * OS：CentOS 7

    * IPアドレス：192.168.0.31

  * スタンバイ2：

    * OS：CentOS 7

    * IPアドレス：192.168.0.31

このドキュメントではCentOS 7用のコマンドラインを書いています。もし、他のプラットフォームを使っている場合は自分でコマンドラインを調整してください。

## [通常] プライマリーとスタンバイでPostgreSQLをインストールする

これは通常の手順です。

プライマリーとスタンバイでPostgreSQL 9.6をインストールします。

プライマリー：

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

スタンバイ：

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

[PostgreSQL: Linux downloads (Red Hat family)](https://www.postgresql.org/download/linux/redhat/#yum)も参照してください。

## [固有] プライマリーとスタンバイでPGroongaをインストールする

これはPGroonga固有の手順です。

プライマリーとスタンバイでPGroongaをインストールします。

プライマリー：

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-{{ site.centos_groonga_release_version }}.noarch.rpm
% sudo -H yum install -y postgresql96-pgroonga
```

スタンバイ：

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-{{ site.centos_groonga_release_version }}.noarch.rpm
% sudo -H yum install -y epel-release
% sudo -H yum install -y postgresql96-pgroonga
```

[CentOSにインストール](/../install/centos.html#install-on-7)も参照してください。

## [通常] プライマリーでPostgreSQLのデータベースを初期化する

これは通常の手順です。

プライマリーでだけPostgreSQLのデータベースを初期化します。スタンバイではPostgreSQLのデータベースを初期化する必要はありません。

プライマリー：

```text
% sudo -H env PGSETUP_INITDB_OPTIONS="--locale C --encoding UTF-8" /usr/pgsql-9.6/bin/postgresql96-setup initdb
```

## [通常] プライマリーで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

プライマリーでだけ次のストリーミングレプリケーション用の設定を`postgresql.conf`に追加します。

  * `listen_address = '*'`

  * `wal_level = replica`

    * [PostgreSQL：ドキュメント：ログ先行書き込み（WAL）][postgresql-wal-level]も参考にしてください。

  * `max_wal_senders = 4`（`= 2（スタンバイ数） * 2`。`* 2`は意図せず接続が切れた場合のため。)

    * [PostgreSQL：ドキュメント：レプリケーション][postgresql-max-wal-senders]も参照してください。

`/var/lib/pgsql/9.6/data/postgresql.conf`:

変更前：

```text
#listen_address = 'localhost'
#wal_level = minimal
#max_wal_senders = 0
```

変更後：

```text
listen_address = '*'
wal_level = replica
max_wal_senders = 4
```

プライマリーでだけ以下のストリーミングレプリケーション用の設定を`pg_hba.conf`に追加します。

  * `192.168.0.0/24`からのレプリケーションユーザー`replicator`でのレプリケーション接続を許可します。

`/var/lib/pgsql/9.6/data/pg_hba.conf`:

変更前：

```text
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            ident
#host    replication     postgres        ::1/128                 ident
```

変更後：

```text
host    replication     replicator       192.168.0.0/24         md5
```

プライマリーでだけレプリケーションユーザーを作成します。

```text
% sudo -H systemctl start postgresql-9.6
% sudo -u postgres -H createuser --pwprompt --replication replicator
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [固有] プライマリーで`postgresql.conf`にPGroonga関連の設定を追加する

これはPGroonga固有の手順です。

プライマリーでだけ[`pgronga.enable_wal`パラメーター][enable-wal]と[`pgroonga.max_wal_size`パラメーター][max-wal-size]の設定を`postgresql.conf`に追加します。

`/var/lib/pgsql/9.6/data/postgresql.conf`:

```text
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```

この設定を反映するためにPostgreSQLを再起動します。

```text
% sudo -H systemctl restart postgresql-9.6
```

上記のパラメターを設定したかどうかは、以下のSQLで確認できます:

```sql
SELECT name,setting FROM pg_settings WHERE name LIKE '%pgroonga%';
```

## [通常] プライマリーでデータを挿入する

これは通常の手順です。

プライマリーでだけ一般ユーザーを作成します。

```text
% sudo -u postgres -H createuser ${USER}
```

プライマリーでだけデータベースを作成します。

```text
% sudo -u postgres -H createdb --locale C --encoding UTF-8 --owner ${USER} blog
```

プライマリーでだけ作成したデータベースにテーブルを追加します。

作成した`blog`データベースに接続します。

```text
% psql blog
```

`entries`テーブルを作成します。

```sql
CREATE TABLE entries (
  title text,
  body text
);
```

作成した`entries`テーブルにデータを追加します。

```sql
INSERT INTO entries VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.');
INSERT INTO entries VALUES ('Groonga', 'Groonga is a full text search engine used by PGroonga. We did not know about it.');
INSERT INTO entries VALUES ('PGroonga and replication', 'PGroonga 1.1.6 supports WAL based streaming replication. We should try it!');
```

## [固有] プライマリーでPGroongaのインデックスを作成する

これはPGroonga固有の手順です。

このデータベースにPGroongaをインストールします。スーパーユーザー権限が必要です。

```text
% sudo -u postgres -H psql blog --command "CREATE EXTENSION pgroonga;"
% sudo -u postgres -H psql blog --command "GRANT USAGE ON SCHEMA pgroonga TO ${USER};"
```

再度一般ユーザーでPostgreSQLに接続します。

```text
% psql blog
```

プライマリーでだけPGroongaのインデックスを作成します。

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

作成したインデックスを確認します。

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

## [固有] プライマリーでだけPGroonga関連のデータをフラッシュする

これはPGroonga固有の手順です。

プライマリーでだけメモリー上にあるPGroonga関連のデータを確実にディスクに書き出します。以下のどれかの方法を使います。

  1. `SELECT pgroonga_command('io_flush');`を実行する

  2. すべての接続を切断する

`pgroonga_command('io_flush')`を使う場合は次のようになります。

```sql
SELECT pgroonga_command('io_flush') AS command;
--                     command                    
-- -----------------------------------------------
--  [[0,1478446349.2241,0.1413860321044922],true]
-- (1 row)
```

プライマリーでは、次の`pg_basebackup`の手順が終わるまではPGroongaのインデックスを使っているテーブルを変更してはいけません。

## [通常] スタンバイで`pg_basebackup`を実行する

これは通常の手順です。

スタンバイでだけ`pg_basebackup`を実行します。`pg_basebackup`はプライマリーから現在のデータベースをコピーします。

スタンバイ：

```text
% sudo -u postgres -H pg_basebackup --host 192.168.0.30 --pgdata /var/lib/pgsql/9.6/data --xlog --progress --username replicator --password --write-recovery-conf
Password: (passw0rd)
149261/149261 kB (100%), 1/1 tablespace
```

## [通常] スタンバイで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

スタンバイでだけ次のレプリカ用の設定を`postgresql.conf`に追加します。

  * `hot_standby = on`

    * [PostgreSQL：ドキュメント：レプリケーション][postgresql-hot-standby]も参照してください。

スタンバイ：

`/var/lib/pgsql/9.6/data/postgresql.conf`:

変更前：

```text
#hot_standby = off
```

変更後：

```text
hot_standby = on
```

## [固有] スタンバイで`postgresql.conf`にPGroongaのWAL関連の設定を追加する

これはPGroonga固有の手順です。

2.3.3で追加。

[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に[`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]を追加します。

スタンバイ：

`/var/lib/pgsql/9.6/data/postgresql.conf`:

変更前：

```text
#shared_preload_libraries = ''
```

変更後：

```text
shared_preload_libraries = 'pgroonga_wal_applier'
```

[`shared_preload_libraries` パラメータ][postgresql-shared-preload-libraries] を設定したかどうかは、以下のSQLで確認できます:

```sql
SELECT name,setting FROM pg_settings WHERE name = 'shared_preload_libraries';
```

## [通常] スタンバイでPostgreSQLを起動する

これは通常の手順です。

スタンバイでPostgreSQLを起動します。

```text
% sudo -H systemctl start postgresql-9.6
```

これで、プライマリーで挿入したデータをプライマリーで作成したPGroongaのインデックスで検索できます。

スタンバイ1：

```text
% psql blog
```

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

`pg_basebacup`以降にプライマリーで追加したデータも検索できます。

プライマリー：

```sql
INSERT INTO entries VALUES ('PostgreSQL 9.6 and replication', 'PostgreSQL supports generic WAL since 9.6. It is required for replication for PGroonga.');
```

スタンバイ1：

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

スタンバイ2：

```text
% psql blog
```

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

[postgresql-wal]:{{ site.postgresql_doc_base_url.ja }}/warm-standby.html

[postgresql-reindex]:{{ site.postgresql_doc_base_url.ja }}/sql-reindex.html

[crash-safe]:crash-safe.html

[postgresql-wal-level]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-wal.html#GUC-WAL-LEVEL

[postgresql-max-wal-senders]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-replication.html#GUC-MAX-WAL-SENDERS

[enable-wal]:parameters/enable-wal.html
[max-wal-size]:parameters/max-wal-size.html

[pgroonga-wal-applier]:modules/pgroonga-wal-applier.html

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-hot-standby]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-replication.html#GUC-HOT-STANDBY
