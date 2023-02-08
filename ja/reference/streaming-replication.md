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

  1. [通常][固有] [プライマリーとスタンバイでPostgreSQLとPGroongaをインストールする](#通常固有-プライマリーとスタンバイでpostgresqlとpgroongaをインストールする)

  2. [通常] [プライマリーで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する](#通常-プライマリーでpostgresqlconfとpg_hbaconfにストリーミングレプリケーション用の設定を追加する)

  3. [固有] [プライマリーで`postgresql.conf`にPGroonga関連の設定を追加する](#固有-プライマリーでpostgresqlconfにpgroonga関連の設定を追加する)

  4. [通常] [スタンバイで`pg_basebackup`を実行する](#通常-スタンバイでpg_basebackupを実行する)

  5. [通常] [スタンバイで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する](#通常-スタンバイでpostgresqlconfにストリーミングレプリケーション用の設定を追加する)

  6. [通常] [スタンバイでPostgreSQLを再起動する](#通常-スタンバイでpostgresqlを再起動する)

  7. [通常] [プライマリーでデータを挿入する](#通常-プライマリーでデータを挿入する)

  8. [固有] [プライマリーでPGroongaのインデックスを作成し、スタンバイから動作を確認する](#固有-プライマリーでpgroongaのインデックスを作成しスタンバイから動作を確認する)


  プライマリーでPGroongaのインデックスを作成し、スタンバイから動作を確認する

## 例で使う環境

このドキュメントでは次の環境を使います。

  * プライマリー：

    * OS：Ubuntu 22.04

    * IPアドレス：192.168.0.30

    * データベース名：`blog`

    * レプリケーションユーザー名：`replicator`

  * スタンバイ1：

    * OS：Ubuntu 22.04

    * IPアドレス：192.168.0.31

  * スタンバイ2：

    * OS：Ubuntu 22.04

    * IPアドレス：192.168.0.32

このドキュメントではCentOS 7用のコマンドラインを書いています。もし、他のプラットフォームを使っている場合は自分でコマンドラインを調整してください。

## [通常][固有] プライマリーとスタンバイでPostgreSQLとPGroongaをインストールする

プライマリーとスタンバイでPostgreSQL 15をインストールします。

プライマリー：

```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install -y postgresql-15 postgresql-contrib-15

sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt install -y wget lsb-release
wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release --codename --short)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y -V postgresql-15-pgdg-pgroonga
```

スタンバイ：

```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install -y postgresql-15 postgresql-contrib-15

sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:groonga/ppa
sudo apt install -y wget lsb-release
wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release --codename --short)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y -V postgresql-15-pgdg-pgroonga
```

## [通常] プライマリーで`postgresql.conf`と`pg_hba.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

プライマリーでだけ次のストリーミングレプリケーション用の設定を`postgresql.conf`に追加します。

  * `listen_address = '*'`

  * `wal_level = replica`

    * [PostgreSQL：ドキュメント：ログ先行書き込み（WAL）][postgresql-wal-level]も参考にしてください。

  * `max_wal_senders = 4`（`= 2（スタンバイ数） * 2`。`* 2`は意図せず接続が切れた場合のため。)

    * [PostgreSQL：ドキュメント：レプリケーション][postgresql-max-wal-senders]も参照してください。

`/etc/postgresql/15/main/postgresql.conf`:

変更前：

```vim
#listen_address = 'localhost'
#wal_level = minimal
#max_wal_senders = 0
```

変更後：

```vim
listen_address = '*'
wal_level = replica
max_wal_senders = 4
```

プライマリーでだけ以下のストリーミングレプリケーション用の設定を`pg_hba.conf`に追加します。

  * `192.168.0.0/24`からのレプリケーションユーザー`replicator`でのレプリケーション接続を許可します。

`/etc/postgresql/15/main/pg_hba.conf`:

変更前：

```vim
#local   replication     postgres                                peer
#host    replication     postgres        127.0.0.1/32            ident
#host    replication     postgres        ::1/128                 ident
```

変更後：

```vim
host    replication     replicator       192.168.0.0/24         trust
```

プライマリーでだけレプリケーションユーザーを作成します。

```bash
sudo su - postgres

psql postgres
CREATE USER replicator WITH REPLICATION;
```

## [固有] プライマリーで`postgresql.conf`にPGroonga関連の設定を追加する

これはPGroonga固有の手順です。

プライマリーでだけ[`pgronga.enable_wal`パラメーター][enable-wal]と[`pgroonga.max_wal_size`パラメーター][max-wal-size]の設定を`postgresql.conf`に追加します。

`/etc/postgresql/15/main/postgresql.conf`:

```vim
# 末尾に追加します
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```

この設定を反映するためにPostgreSQLを再起動します。

```bash
sudo -H systemctl restart postgresql
```

上記のパラメターを設定したかどうかは、以下のSQLで確認できます:

```sql
SELECT name,setting FROM pg_settings WHERE name LIKE '%pgroonga%';
```

## [通常] スタンバイで`pg_basebackup`を実行する

これは通常の手順です。

スタンバイでだけ`pg_basebackup`を実行します。`pg_basebackup`はプライマリーから現在のデータベースをコピーします。

スタンバイ：

```bash
sudo -u postgres -H pg_basebackup --host 192.168.0.30 -D /var/lib/postgresql/15/data --progress -U replicator -R

149261/149261 kB (100%), 1/1 tablespace
```

## [通常] スタンバイで`postgresql.conf`にストリーミングレプリケーション用の設定を追加する

これは通常の手順です。

スタンバイでだけ次のレプリカ用の設定を`postgresql.conf`に追加します。

  * `hot_standby = on`

    * [PostgreSQL：ドキュメント：レプリケーション][postgresql-hot-standby]も参照してください。

スタンバイ：

`/etc/postgresql/15/main/postgresql.conf`:

変更前：

```vim
data_directory = '/var/lib/postgresql/15/main'

#hot_standby = off
```

変更後：

```vim
data_directory = '/var/lib/postgresql/15/data'

hot_standby = on
```

## [固有] スタンバイで`postgresql.conf`にPGroongaのWAL関連の設定を追加する

これはPGroonga固有の手順です。

2.3.3で追加。

[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に[`pgroonga_wal_applier`モジュール][pgroonga-wal-applier]を追加します。

スタンバイ：

`/etc/postgresql/15/main/postgresql.conf`:

変更前：

```vim
#shared_preload_libraries = ''
```

変更後：

```vim
shared_preload_libraries = 'pgroonga_wal_applier'

# 末尾にプライマリ同様下記を追加
pgroonga.enable_wal = on
# You may need more large size
pgroonga.max_wal_size = 100MB
```

[`shared_preload_libraries` パラメータ][postgresql-shared-preload-libraries] を設定したかどうかは、以下のSQLで確認できます:

```sql
SELECT name,setting FROM pg_settings WHERE name = 'shared_preload_libraries';
```

## [通常] スタンバイでPostgreSQLを再起動する

これは通常の手順です。

スタンバイでPostgreSQLを再起動sします。

```bash
% sudo -H systemctl restart postgresql
```

これで、セカンダリーサーバでもプライマリーで挿入したデータをPGroongaのインデックスを利用して検索できます。

## [通常] プライマリーでデータを挿入する

これは通常の手順です。

プライマリーでデータベースを作成します。

```bash
sudo su - postgres

createdb blog
```

プライマリーでだけ作成したデータベースにテーブルを追加します。

作成した`blog`データベースに接続します。

```bash
sudo su - postgres

psql blog
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


## [固有] プライマリーでPGroongaのインデックスを作成し、スタンバイから動作を確認する

これはPGroonga固有の手順です。

このデータベースにPGroongaをインストールします。スーパーユーザー権限が必要です。

```bash
sudo su - postgres

psql blog
```

プライマリーでだけPGroongaのインデックスを作成します。

```sql
CREATE EXTENSION pgroonga;
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

スタンバイ1側でレプリケーションされてるデータの確認：

```bash
sudo su - postgres
psql blog
```

```sql
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```


スタンバイ2側でレプリケーションされてるデータの確認：

```bash
sudo su - postgres
psql blog
```

```sql
SELECT title FROM entries WHERE title %% 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
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
