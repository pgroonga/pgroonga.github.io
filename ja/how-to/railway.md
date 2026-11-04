---
title: RailwayでPGroongaを使う方法
---

# RailwayでPGroongaを使う方法

このガイドでは[Railwayテンプレート](https://railway.com/deploy/pgroonga)の使い方を説明します。Railwayのスケーラブルなインフラを使えば、永続ストレージ付きのPGroongaをワンクリックで簡単にデプロイできます。

## 使い方の詳細

### セットアップ方法

このテンプレートはPGroongaがインストール済みのPostgreSQLを提供します。どこからでもデータベースにアクセスできるようにTCPプロキシが設定されているため、外部からPGroongaデータベースに接続できます。

**セキュリティに関する注意**:
TCPプロキシを使うと、データベースはどこからでもアクセス可能になります。
このテンプレートを本番環境で使う前に、次の設定をしてください。

* 同じRailwayプロジェクト内の別のサービスから接続する場合は、パブリックなTCPプロキシではなくRailwayの[プライベートネットワーク](https://docs.railway.com/guides/private-networking)を使ってください。
* 外部からのアクセスが不要な場合は、Railwayのダッシュボードのサービス設定からTCPプロキシを削除してください。

環境に合わせて次の環境変数を設定してください。

* POSTGRES_USER
* POSTGRES_PASSWORD
* POSTGRES_DB

### データベースに接続

RailwayサービスのDATABASE_URL変数を使ってPGroongaが使えるデータベースに接続します。

```
$ psql $DATABASE_URL
```

別のRailwayサービスから参照したい場合は、[Reference variables](https://docs.railway.com/variables#referencing-another-services-variable-example)として使えます。

{% raw %}

```
${{PGroonga.DATABASE_URL}}
```

{% endraw %}

### 使い方

接続したら次のSQLでPGroongaを有効にします。

```sql
CREATE EXTENSION pgroonga;
```

#### 全文検索インデックスの作成

全文検索対象の**`text`**型のカラムを持つテーブルを作成します。

```sql
CREATE TABLE memos (
  id integer,
  content text
);
```

対象のカラムにPGroongaで全文検索インデックスを作成します。

```sql
CREATE INDEX pgroonga_content_index ON memos USING pgroonga (content);
```

（オプション）サンプルデータを登録します。

```sql
INSERT INTO memos VALUES (1, 'PostgreSQL is a relational database management system.');
INSERT INTO memos VALUES (2, 'Groonga is a fast full-text search engine that supports all languages.');
INSERT INTO memos VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga as index.');
INSERT INTO memos VALUES (4, 'There is groonga command.');
```

全文検索クエリーを実行します。

```sql
SELECT * FROM memos WHERE content &@~ 'groonga';
--  id |                                content
-- ----+------------------------------------------------------------------------
--   2 | Groonga is a fast full-text search engine that supports all languages.
--   3 | PGroonga is a PostgreSQL extension that uses Groonga as index.
--   4 | There is groonga command.
-- (3 rows)
```

これでセットアップは完了です！すぐに全文検索を使えます。
