---
title: WALリソースマネージャーを使ったストリーミングレプリケーション
---

# WALリソースマネージャーを使ったストリーミングレプリケーション

PGroongaは3.2.1からPostgreSQL組み込みの[カスタムWALリソースマネージャー][postgresql-custom-wal-resource-managers]機能をサポートしています。カスタムWALリソースマネージャーはPostgreSQL 15以上で利用できます。

これによりWALベースのストリーミングレプリケーションの運用が楽になります。

PGroongaのWALは次のように処理されます。

```mermaid
sequenceDiagram
    box transparent Primary
        participant User
        participant PGroonga
        participant WAL sender
    end
    box transparent Standby
        participant WAL receiver
        participant PGroonga WAL resource manager
    end

    User->>+PGroonga:INSERT/UPDATE/DELETE
    Note right of PGroonga:Write WAL
    PGroonga->>+WAL sender:Notify write WAL
    WAL sender->>+WAL receiver:Send WAL
    WAL receiver->>+PGroonga WAL resource manager:Call
    Note right of PGroonga WAL resource manager:Apply WAL
```

このドキュメントではPostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroongaのWALリソースマネージャーと組み合わせて利用するときの設定方法を説明します。多くの手順は通常のストリーミングレプリケーションの設定手順です。いくつかPGroonga固有の手順があります。

## 概要

PostgreSQL組み込みのWALベースのストリーミングレプリケーション機能をPGroongaのWALリソースマネージャと組み合わせて利用する設定手順は次の通りです。「[通常]」タグは通常のストリーミングレプリケーション用の手順であることを示しています。「[固有]」タグはPGroonga固有の手順であることを示しています。

  1. [通常] [プライマリーとスタンバイでPostgreSQLをインストールする](#install-postgresql)

  2. [固有] [プライマリーとスタンバイでPGroongaをインストールする](#install-pgroonga)

  3. [通常] [プライマリーでストリーミングレプリケーション用にPostgreSQLを設定する](#configure-replication-primary)

  4. [固有] [プライマリーでPGroonga用にPostgreSQLを設定する](#configure-pgroonga-primary)

  5. [通常] [プライマリーでデータを追加する](#insert-primary)

  6. [固有] [プライマリーでPGroongaのインデックスを作る](#create-pgroonga-index-primary)

  7. [固有] [プライマリーでPGroonga関連のデータを書き出す](#flush-pgroonga-data-primary)

  8. [通常] [スタンバイで`pg_basebackup`を実行する](#pg-basebackup-standbys)

  9. [固有] [スタンバイでPGroonga用にPostgreSQLを設定する](#configure-pgroonga-standbys)

  10. [通常] [スタンバイでPostgreSQLを起動する](#start-standbys)

このドキュメントでは次の環境を使います。

  * プライマリー：

    * OS: Ubuntu 24.04

    * IPアドレス：192.168.0.30

    * データベース名：`blog`

    * レプリケーションユーザー名：`replicator`

    * レプリケーションユーザーのパスワード：`passw0rd`

  * スタンバイ1：

    * OS: Ubuntu 24.04

    * IPアドレス：192.168.0.31

  * スタンバイ2：

    * OS: Ubuntu 24.04

    * IPアドレス：192.168.0.32

このドキュメントではUbuntu 24.04用のコマンドラインを書いています。もし、他のプラットフォームを使っている場合は自分でコマンドラインを調整してください。

## [通常] プライマリーとスタンバイでPostgreSQLをインストールする {#install-postgresql}

これは通常の手順です。

プライマリーとスタンバイでPostgreSQL 16をインストールします。

```bash
sudo apt install -y gpg lsb-release wget
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/pdgd-keyring.gpg --import -
echo "deb [signed-by=/usr/share/keyrings/pdgd-keyring.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install -y postgresql-16
```

## [固有] プライマリーとスタンバイでPGroongaをインストールする {#install-pgroonga}

これはPGroonga固有の手順です。

プライマリーとスタンバイでPGroongaをインストールします。

```bash
sudo apt install -y lsb-release
wget https://packages.groonga.org/ubuntu/groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
rm -f groonga-apt-source-latest-$(lsb_release --codename --short).deb
sudo apt update
sudo apt install -y -V postgresql-16-pgdg-pgroonga
```

## [通常] プライマリーでストリーミングレプリケーション用にPostgreSQLを設定する {#configure-replication-primary}

これは通常の手順です。

プライマリーでだけ次のストリーミングレプリケーション用の設定を`postgresql.conf`に追加します。

  * `listen_addresses = 'localhost,192.168.0.30'`

多くのスタンバイがいる場合は`max_wal_senders`も設定する必要があります。`max_wal_senders`のデフォルト値は`10`です。スタンバイ2台では`10`で十分です。

[PostgreSQL：ドキュメント：レプリケーション][postgresql-replication]も参照してください。

`/etc/postgresql/16/main/postgresql.conf`:

変更前：

```conf
#listen_addresses = 'localhost'
```

変更後：

```conf
listen_addresses = 'localhost,192.168.0.30'
```

プライマリーでだけ以下のストリーミングレプリケーション用の設定を`pg_hba.conf`に追加します。

  * `192.168.0.0/24`からのレプリケーションユーザー`replicator`でのレプリケーション接続を許可します。

`/etc/postgresql/16/main/pg_hba.conf`:

変更前：

```conf
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

変更後：

```conf
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
host    replication     all             192.168.0.0/24          scram-sha-256
```

プライマリーでだけレプリケーションユーザーを作成します。

```console
$ sudo -u postgres -H createuser --pwprompt --replication replicator
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [固有] プライマリーでPGroonga用にPostgreSQLを設定する {#configure-pgroonga-primary}

これはPGroonga固有の手順です。

PGroongaのWALリソースマネージャー関連の設定とクラッシュセーフ関連の設定を追加する必要があります。

PGroonga WALリソースマネージャー用には[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]を[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に追加して[`pgronga.enable_wal_resource_manager = on`][enable-wal-resource-manager]も追加する必要があります。

クラッシュセーフ用には、[`pgroonga_crash_safer`モジュール][pgroonga-crash-safer]を[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に追加して`pgroonga.enable_crash_safe = on`も追加する必要があります。

注意：`pgroonga_crash_safer`モジュールを使うと書き込み性能が低下します。メンテナンス性と性能のトレードオフがあります。最大の書き込み性能が必要な場合はこのモジュールを使えません。このトレードオフについては[クラッシュセーフ][crash-safe]も参照してください。

`/etc/postgresql/16/main/postgresql.conf`:

変更前：

```conf
#shared_preload_libraries = ''
```

変更後：

```conf
shared_preload_libraries = 'pgroonga_wal_resource_manager,pgroonga_crash_safer'
```

`/etc/postgresql/16/main/conf.d/pgroonga.conf`:

```conf
pgroonga.enable_wal_resource_manager = on
pgroonga.enable_crash_safe = on
```

`pgroonga_crash_safer`モジュールを使わない場合は、`shared_preload_libraries`から`pgroonga_crash_safer`を除いて、`pgroonga.enable_crash_safe = on`も消します。

この設定を反映するためにPostgreSQLを再起動します。

```bash
sudo -H systemctl restart postgresql
```

## [通常] プライマリーでデータを挿入する {#insert-primary}

これは通常の手順です。

プライマリーでだけ一般ユーザーを作成します。

```bash
sudo -u postgres -H createuser ${USER}
```

プライマリーでだけデータベースを作成します。

```bash
sudo -u postgres -H createdb --template template0 --locale C --encoding UTF-8 --owner ${USER} blog
```

プライマリーでだけ作成したデータベースにテーブルを追加します。

作成した`blog`データベースに接続します。

```bash
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
INSERT INTO entries VALUES ('PGroonga and replication', 'PGroonga 3.2.1 supports custom WAL resource manager. We should try it!');
```

## [固有] プライマリーでPGroongaのインデックスを作成する {#create-pgroonga-index-primary}

これはPGroonga固有の手順です。

このデータベースにPGroongaをインストールします。スーパーユーザー権限が必要です。

```bash
sudo -u postgres -H psql blog --command "CREATE EXTENSION pgroonga;"
sudo -u postgres -H psql blog --command "GRANT USAGE ON SCHEMA pgroonga TO ${USER};"
```

再度一般ユーザーでPostgreSQLに接続します。

```bash
psql blog
```

プライマリーでPGroongaのインデックスを作成します。

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

作成したインデックスを確認します。

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title &@~ 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

## [固有] プライマリーでだけPGroonga関連のデータをフラッシュする {#flush-pgroonga-data-primary}

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

## [通常] スタンバイで`pg_basebackup`を実行する {#pg-basebackup-standbys}

これは通常の手順です。

スタンバイでだけ`pg_basebackup`を実行します。`pg_basebackup`はプライマリーから現在のデータベースをコピーします。

スタンバイ：

```bash
sudo -H systemctl stop postgresql
sudo -u postgres -H rm -rf /var/lib/postgresql/16/main
```

スタンバイ1：

WALの管理がシンプルになるので[レプリケーションスロット][postgresql-replication-slots]を使うべきです。

* `--create-slot`

* `--slot standby1`

  * `standby1`は例です。わかりやすい名前を設定してください

```console
$ sudo -u postgres -H pg_basebackup --create-slot --slot standby1 \
  --host 192.168.0.30 --pgdata /var/lib/postgresql/16/main --progress --username replicator --write-recovery-conf
Password: (passw0rd)
158949/158949 kB (100%), 1/1 tablespace
```

スタンバイ2：

WALの管理がシンプルになるので[レプリケーションスロット][postgresql-replication-slots]を使うべきです。

* `--create-slot`

* `--slot standby2`

  * `standby2`は例です。わかりやすい名前を設定してください

```console
$ sudo -u postgres -H pg_basebackup --create-slot --slot standby2 \
  --host 192.168.0.30 --pgdata /var/lib/postgresql/16/main --progress --username replicator --write-recovery-conf
Password: (passw0rd)
158949/158949 kB (100%), 1/1 tablespace
```

## [固有] スタンバイでPGroonga用にPostgreSQLを設定する {#configure-pgroonga-standbys}

これはPGroonga固有の手順です。

次のモジュールを[`shared_preload_libraries`パラメーター][postgresql-shared-preload-libraries]に追加します。

  * [`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]

注意: スタンバイでは`pgroonga_crash_safer`は必要ありません。[`pgroonga_wal_resource_manager`モジュール][pgroonga-wal-resource-manager]はクラッシュリカバリーもできます。

スタンバイ：

`/etc/postgresql/16/main/postgresql.conf`:

変更前：

```conf
#shared_preload_libraries = ''
```

変更後：

```conf
shared_preload_libraries = 'pgroonga_wal_resource_manager'
```

## [通常] スタンバイでPostgreSQLを起動する {#start-standbys}

これは通常の手順です。

スタンバイでPostgreSQLを起動します。

```bash
sudo -H systemctl start postgresql
```

これで、プライマリーで挿入したデータをプライマリーで作成したPGroongaのインデックスで検索できます。

スタンバイ1：

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title &@~ 'replication';
--           title           
-- --------------------------
--  PGroonga and replication
-- (1 row)
```

`pg_basebacup`以降にプライマリーで追加したデータも検索できます。

プライマリー：

```sql
INSERT INTO entries VALUES ('PostgreSQL 15 and replication', 'PostgreSQL supports custom WAL resource manager since 15.');
```

スタンバイ1：

```sql
SELECT title FROM entries WHERE title &@~ 'replication';
-              title              
-- -------------------------------
--  PGroonga and replication
--  PostgreSQL 15 and replication
-- (2 rows)
```

スタンバイ2：

```sql
SET enable_seqscan TO off;
SELECT title FROM entries WHERE title &@~ 'replication';
--             title              
-- -------------------------------
--  PGroonga and replication
--  PostgreSQL 15 and replication
-- (2 rows)
```

[crash-safe]:crash-safe.html

[enable-wal-resource-manager]:parameters/enable-wal-resource-manager.html

[pgroonga-crash-safer]:modules/pgroonga-crash-safer.html

[pgroonga-wal-resource-manager]:modules/pgroonga-wal-resource-manager.html

[postgresql-custom-wal-resource-managers]:{{ site.postgresql_doc_base_url.ja }}/custom-rmgr.html

[postgresql-replication]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-replication.html

[postgresql-replication-slots]:{{ site.postgresql_doc_base_url.ja }}/warm-standby.html#STREAMING-REPLICATION-SLOTS

[postgresql-shared-preload-libraries]:{{ site.postgresql_doc_base_url.ja }}/runtime-config-client.html#GUC-SHARED-PRELOAD-LIBRARIES

[postgresql-wal]:{{ site.postgresql_doc_base_url.ja }}/warm-standby.html
