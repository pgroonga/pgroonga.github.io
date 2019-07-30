---
title: ロジカルレプリケーション
---

# ロジカルレプリケーション

PGroongaは1.2.4からPostgreSQL組み込みのロジカルレプリケーションをサポートしています。ロジカルレプリケーションはPostgreSQL 10以降が必要です。

このドキュメントではPostgreSQL組み込みのロジカルレプリケーション機能をPGroonga用に設定する方法を説明します。多くの手順は通常のロジカルレプリケーションの設定手順です。いくつかPGroonga固有の手順があります。

ロジカルレプリケーションはレプリケーション元とレプリケーション先で同じスキーマを持つ必要がありません。

そのため、ここでは、レプリケーション先にのみインデックスを設定します。

## 概要

PostgreSQL組み込みのロジカルレプリケーション機能をPGroonga用に設定する手順は次の通りです。「[通常]」タグは通常のロジカルレプリケーションの手順であることを示しています。「[固有]」タグはPGroonga固有の手順であることを示しています。

  1. [通常] パブリッシャーとサブスクライバーにPostgreSQLをインストールします。

  2. [固有] サブスクライバーにPGroongaをインストールします。

  3. [通常] パブリッシャーとサブスクライバーのPostgreSQLデータベースを初期化します。

  4. [通常] パブリッシャーの`postgresql.conf`と`pg_hba.conf`にロジカルレプリケーションの設定を追加します。

  5. [通常] パブリッシャーとサブスクライバーにテーブルを作成します。

  6. [通常] パブリッシャーにパブリケーションを作成します。

  7. [通常] サブスクライバーにサブスクリプションを作成します。

  8. [固有] サブスクライバーにPGroongaのインデックスを作成します。

  9. [通常] パブリッシャーにデータを挿入します。

## 例で使う環境

このドキュメントでは次の環境を使います。

  * パブリッシャー:

    * OS：CentOS 7

    * IPアドレス: 172.16.0.1

    * データベース名： `blog`

    * レプリケーションユーザー名： `replicator`

    * レプリケーションユーザーのパスワード：`passw0rd`

  * サブスクライバー

    * OS：CentOS 7

    * IPアドレス: 172.16.0.2

    * データベース名： `blog`

このドキュメントではCentOS 7用のコマンドラインを書いています。もし、他のプラットフォームを使っている場合は自分でコマンドラインを調整してください。

## [通常] パブリッシャーとサブスクライバーにPostgreSQLをインストールする

これは通常の手順です。

パブリッシャーとサブスクライバーに PostgreSQL {{ site.latest_postgresql_version }} をインストールします。

パブリッシャーとサブスクライバー

```console
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo yum install postgresql{{ site.latest_postgresql_version }}-server
```

[PostgreSQL: Linux downloads (CentOS)][centos]も参照してください。

## [固有] サブスクライバーにPGroongaをインストールする

これはPGroonga固有の手順です。

サブスクライバーにPGroongaをインストールします。

サブスクライバー:

```console
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql{{ site.latest_postgresql_version}}-pgroonga
```

## [通常] パブリッシャーとサブスクライバーのPostreSQLのデータベースを初期化する

これは通常の手順です。

パブリッシャーとサブスクライバーのPostgreSQLのデータベースを初期化します。

パブリッシャーとサブスクライバー

```console
% sudo /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
% sudo systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
```

## [通常] パブリッシャーの`postgresql.con`にロジカルレプリケーションの設定を追加する

これは通常の手順です。

パブリッシャーの `postresql.conf` にのみ、以下のロジカルレプリケーションの設定を追記します。

  * `wal_level = logical`

     * See also [ログ先行書き込み（WAL）][wal]も参考にしてください。

  * `max_wal_senders = 2` (`= 1 (サブスクライバー数) * 2`。 `* 2`は意図せず接続が切れた場合のため。)

     * [レプリケーション][replication]も参照してください。

  * `max_replication_slots = 1` (`= 1 (サブスクライバーの数)`

     * [レプリケーション][replication]も参照してください。

`/var/lib/pgsql/{{ site.latest_postgresql_version }}/data/postgresql.conf`:

変更前：

```text
#listen_address = 'localhost'

#wal_level = minimal
#max_wal_senders = 0
#max_replication_slots = 0
```

変更後：

```text
listen_address = '*'

wal_level = logical
max_wal_senders = 2
max_replication_slots = 1
```

パブリッシャーの `pg_hba.conf` にのみ、以下のロジカルレプリケーションの設定を追加します。

  * `172.16.0.2/32` から レプリケーションユーザー `replicator` による接続を許可します。

`/var/lib/pgsql/{{ site.latest_postgresql_version }}/data/pg_hba.conf`:

変更前：

```text
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                trust
host    replication     all        127.0.0.1/32            trust
host    replication     all        ::1/128                 trust
```

変更後：

```text
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                trust
host    replication     all        127.0.0.1/32            trust
host    replication     all        ::1/128                 trust

# IPv4 remote connections:
host    all             replicator       172.16.0.2/32         md5
```

この設定を反映するためにPostgreSQLを再起動します。

```console
% sudo -H systemctl restart postgresql-{{ site.latest_postgresql_version }}
```

パブリッシャーにのみレプリケーションのためのユーザーを作成します。

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createuser --pwprompt replicator -U postgres
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [通常] パブリッシャーとサブスクライバーにテーブルを作成する

これは通常の手順です。

サブスクライバーに通常ユーザーを作成します。

サブスクライバー:

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createuser ${USER} -U postgres
```

パブリッシャーとサブスクライバーでデータベースを作成します。

パブリッシャーとサブスクライバー

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createdb --owner ${USER} blog -U postgres
```

作成されたデータベース内でテーブルを作成する。
`blog` データベースへ接続する。

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/psql blog -U ${USER}
```

`entries`テーブルを作成します。`

```sql
CREATE TABLE entries (
  title text,
  body text
);
```

## [固有] サブスクライバーにPGroongaのインデックスを作成する

これはPGroonga固有の手順です。

このデータベースにPGroongaをインストールします。スーパーユーザー権限が必要です。

サブスクライバー:

```sql
CREATE EXTENSION pgroonga;
```

サブスクライバーにPGroongaのインデックスを作成します。

サブスクライバー:

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

パブリッシャーにのみ、PUBLICATION を作成します。

```sql
CREATE PUBLICATION pub_srv1_blog FOR TABLE entries;
```

サブスクライバーにのみ、SUBSCRIPTION を作成します。

```sql
CREATE SUBSCRIPTION sub_srv2_blog CONNECTION 'dbname=blog hostaddr=172.16.0.2 port=5432 user=replicator password=passw0rd' PUBLICATION pub_srv1_blog;
```

## [通常] パブリッシャーにのみデータを挿入する

作成した `entries`テーブルにデータを挿入します。

```sql
INSERT INTO entries VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.');
INSERT INTO entries VALUES ('Groonga', 'Groonga is a full text search engine used by PGroonga. We did not know about it.');
INSERT INTO entries VALUES ('PGroonga and replication', 'PGroonga 1.1.6 supports WAL based streaming replication. We should try it!');
```

レプリケーションの確認:

パブリッシャー:

```sql
SELECT * FROM entries;
 title    |                                  body
 ---------+---------------------------------------------------------------------------
 PGroonga | PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.
 Groonga  | Groonga is a full text search engine used by PGroonga. We did not know about it.
 PGroonga and replication | PGroonga 1.1.6 supports WAL based streaming replication. We should try it!
 (3 rows)
```

サブスクライバー:

```sql
SELECT * FROM entries;
 title    |                                  body
 ---------+---------------------------------------------------------------------------
 PGroonga | PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.
 Groonga  | Groonga is a full text search engine used by PGroonga. We did not know about it.
 PGroonga and replication | PGroonga 1.1.6 supports WAL based streaming replication. We should try it!
 (3 rows)
```

これで、サブスクライバーで作成したPGroongaのインデックスで、サブスクライバーで複製したデータを検索できます。

```sql
SET enable_seqscan TO off;
SELECT * FROM entries WHERE body &@ 'Groonga';
  title  |                                       body
---------+----------------------------------------------------------------------------------
 Groonga | Groonga is a full text search engine used by PGroonga. We did not know about it.
(1 row)
```

[wal]:{{ site.postgresql_doc_base_url.en }}/runtime-config-wal.html#GUC-WAL-LEVEL

[replication]:{{ site.postgresql_doc_base_url.en }}/runtime-config-replication.html#GUC-MAX-WAL-SENDERS

[centos]:https://www.postgresql.org/download/linux/redhat/
