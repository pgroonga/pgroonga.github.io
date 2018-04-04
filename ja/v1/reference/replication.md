---
title: レプリケーション
---

# レプリケーション

PGroongaは1.1.6からPostgreSQL組み込みの[WALベースのストリーミングレプリケーション機能]({{ site.postgresql_doc_base_url.ja }}/warm-standby.html)をサポートしています。この機能を使うにはPostgreSQL 9.6以降が必要です。

PostgreSQL 9.5以前を使っている場合は、PGroongaと一緒に使える別のストリーミングレプリケーションの実装を使ってください。

  * [pglogical](https://2ndquadrant.com/en/resources/pglogical/)

  * [pg\_shard](https://github.com/citusdata/pg_shard)（pg\_shardは非推奨になりました。pg\_shardの後継プロジェクトの[Citus](https://github.com/citusdata/citus)もおそらくPGroongaと一緒に使えます。もし、CitusがPGroongaと一緒に使えることを確認したら、[報告](https://github.com/pgroonga/pgroonga/issues/new)してください。）

WALをサポートしているといってもクラッシュセーフではないことに注意してください。WALベースのストリーミングレプリケーションをサポートしているだけです。もし、PGroongaのインデックスを更新している最中にPostgreSQLがクラッシュしたら、そのPGroongaのインデックスは壊れるかもしれません。もし、PGroongaのインデックスが壊れたら[`REINDEX`]({{ site.postgresql_doc_base_url.ja }}/sql-reindex.html)で作り直さなければいけません。

このドキュメントではPostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroonga用に設定する方法を説明します。多くの手順は通常のストリーミングレプリケーションの設定手順です。いくつかPGroonga固有の手順があります。

## 概要

PostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroonga用に設定する手順は次の通りです。「[通常]」タグは通常のストリーミングレプリケーション用の手順であることを示しています。「[固有]」タグはPGroonga固有の手順であることを示しています。

  1. [通常] マスターとスレーブでPostgreSQLをインストールする

  2. [固有] マスターとスレーブでPGroongaをインストールする

  3. [通常] マスターでPostgreSQLのデータベース初期化する

  4. [通常] マスターで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する

  5. [固有] マスターで`postgresql.conf`にPGroonga関連の設定を追加する

  6. [通常] マスターでデータを投入する

  7. [固有] マスターでPGroongaのインデックスを作成する

  8. [固有] マスターでPGroonga関連のデータをフラッシュする

  9. [通常] スレーブで`pg_basebackup`を実行する

  10. [通常] スレーブで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する

  11. [通常] スレーブでPostgreSQLを起動する

## 例で使う環境

このドキュメントでは次の環境を使います。

  * マスター：

    * OS：CentOS 7

    * IPアドレス：192.168.0.30

    * データベース名：`blog`

    * レプリケーションユーザ名：`replicator`

    * レプリケーションユーザーのパスワード：`passw0rd`

  * スレーブ1：

    * OS：CentOS 7

    * IPアドレス：192.168.0.31

  * スレーブ2：

    * OS：CentOS 7

    * IPアドレス：192.168.0.31

このドキュメントではCentOS 7用のコマンドラインを書いています。もし、他のプラットフォームを使っている場合は自分でコマンドラインを調整してください。

2017年7月03日現在、WALをサポートしている公式のPGroongaパッケージは次の通りです。これはWALサポートにはMessagePackとPostgreSQL 9.6以降が必要だからです。他のプラットフォームはこれら2つの条件を満たしていません。PGroongaをソースからビルドする場合は、[ソースからインストール](../install/source.html)を読んでください。MessagePackと一緒にビルドする方法が書いています。

  * [Debian GNU/Linux Stretch][debian-stretch]

  * [Ubuntu 17.04][ubuntu]

  * [CentOS 6][centos-6]

  * [CentOS 7][centos-7]

  * [Windows][windows]

## [通常] マスターとスレーブでPostgreSQLをインストールする

これは通常の手順です。

マスターとスレーブでPostgreSQL 9.6をインストールします。

マスター：

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

スレーブ：

```text
% sudo -H yum install -y http://yum.postgresql.org/9.6/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos96-9.6-3.noarch.rpm
% sudo -H yum install -y postgresql96-server
% sudo -H systemctl enable postgresql-9.6
```

[PostgreSQL: Linux downloads (Red Hat family)](https://www.postgresql.org/download/linux/redhat/#yum)も参照してください。

## [固有] マスターとスレーブでPGroongaをインストールする

これはPGroonga固有の手順です。

マスターとスレーブでPGroongaをインストールします。

マスター：

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql96-pgroonga
```

スレーブ：

```text
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y epel-release
% sudo -H yum install -y postgresql96-pgroonga
```

[CentOSにインストール](/../install/centos.html#install-on-7)も参照してください。

## [通常] マスターでPostgreSQLのデータベースを初期化する

これは通常の手順です。

マスターでだけPostgreSQLのデータベースを初期化します。スレーブではPostgreSQLのデータベースを初期化する必要はありません。

マスター：

```text
% sudo -H env PGSETUP_INITDB_OPTIONS="--locale C --encoding UTF-8" /usr/pgsql-9.6/bin/postgresql96-setup initdb
```

## [通常] マスターで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

マスターでだけ次のストリーミングレプリケーション用の設定を`postgresql.conf`に追加します。

  * `listen_address = '*'`

  * `wal_level = replica`

     * [ログ先行書き込み（WAL）]({{ site.postgresql_doc_base_url.ja }}/runtime-config-wal.html#guc-wal-level)も参照してください。.

  * `max_wal_senders = 4`（`= 2（スレーブ数） * 2`。`* 2`は意図せず接続が切れた場合のため。)

     * [レプリケーション]({{ site.postgresql_doc_base_url.ja }}/runtime-config-replication.html#guc-max-wal-senders)も参照してください。

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

マスターでだけ以下のストリーミングレプリケーション用の設定を`pg_hba.conf`に追加します。

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

マスターでだけレプリケーションユーザーを作成します。

```text
% sudo -H systemctl start postgresql-9.6
% sudo -u postgres -H createuser --pwprompt --replication replicator
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [固有] マスターで`postgresql.conf`にPGroonga関連の設定を追加する

これはPGroonga固有の手順です。

マスターでだけ[`pgronga.enable_wal`パラメーター](parameters/enable-wal.html)の設定を`postgresql.conf`に追加します。

`/var/lib/pgsql/9.6/data/postgresql.conf`:

```text
pgroonga.enable_wal = on
```

この設定を反映するためにPostgreSQLを再起動します。

```text
% sudo -H systemctl restart postgresql-9.6
```

## [通常] マスターでデータを挿入する

これは通常の手順です。

マスターでだけ一般ユーザーを作成します。

```text
% sudo -u postgres -H createuser ${USER}
```

マスターでだけデータベースを作成します。

```text
% sudo -u postgres -H createdb --locale C --encoding UTF-8 --owner ${USER} blog
```

マスターでだけ作成したデータベースにテーブルを追加します。

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

## [固有] マスターでPGroongaのインデックスを作成する

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

マスターでだけPGroongaのインデックスを作成します。

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

## [固有] マスターでだけPGroonga関連のデータをフラッシュする

これはPGroonga固有の手順です。

マスターでだけメモリー上にあるPGroonga関連のデータを確実にディスクに書き出します。以下のどれかの方法を使います。

  1. `SELECT pgroonga.command('io_flush');`を実行する

  2. すべての接続を切断する

`pgroonga.command('io_flush')`を使う場合は次のようになります。

```sql
SELECT pgroonga.command('io_flush');
--                     command                    
-- -----------------------------------------------
--  [[0,1478446349.2241,0.1413860321044922],true]
-- (1 row)
```

マスターでは、次の`pg_basebackup`の手順が終わるまではPGroongaのインデックスを使っているテーブルを変更してはいけません。

## [通常] スレーブで`pg_basebackup`を実行する

これは通常の手順です。

スレーブでだけ`pg_basebackup`を実行します。`pg_basebackup`はマスターから現在のデータベースをコピーします。

スレーブ：

```text
% sudo -u postgres -H pg_basebackup --host 192.168.0.30 --pgdata /var/lib/pgsql/9.6/data --xlog --progress --username replicator --password --write-recovery-conf
Password: (passw0rd)
149261/149261 kB (100%), 1/1 tablespace
```

## [通常] スレーブで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

スレーブでだけ次のレプリカ用の設定を`postgresql.conf`に追加します。

  * `hot_standby = on`

    * [レプリケーション]({{ site.postgresql_doc_base_url.ja }}/runtime-config-replication.html#guc-hot-standby)も参照してください。

スレーブ：

`/var/lib/pgsql/9.6/data/postgresql.conf`:

変更前：

```text
#hot_standby = off
```

変更後：

```text
hot_standby = on
```

## [通常] スレーブでPostgreSQLを起動する

これは通常の手順です。

スレーブでPostgreSQLを起動します。

```text
% sudo -H systemctl start postgresql-9.6
```

これで、masterで挿入したデータをmasterで作成したPGroongaのインデックスで検索できます。

スレーブ1：

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

`pg_basebacup`以降にマスターで追加したデータも検索できます。

マスター：

```sql
INSERT INTO entries VALUES ('PostgreSQL 9.6 and replication', 'PostgreSQL supports generic WAL since 9.6. It is required for replication for PGroonga.');
```

スレーブ1：

```sql
SELECT title FROM entries WHERE title %% 'replication';
--              title              
-- --------------------------------
--  PGroonga and replication
--  PostgreSQL 9.6 and replication
-- (2 rows)
```

スレーブ2：

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

[debian-stretch]:../install/debian.html#install-on-stretch

[ubuntu]:../install/ubuntu.html

[centos-6]:../install/centos.html#install-on-6

[centos-7]:../install/centos.html#install-on-7

[windows]:../install/windows.html
