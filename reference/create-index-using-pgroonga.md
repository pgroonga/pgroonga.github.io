---
title: CREATE INDEX USING pgroonga
layout: en
---

# `CREATE INDEX USING pgroonga`

You need to specify `USING pgroonga` to `CREATE INDEX` to use PGroonga as index method. This section describes about `pgroonga` index method.

## Syntax

This section describes only `pgroonga` index method related `CREATE INDEX` syntaxes. See [CREATE INDEX document by PostgreSQL](http://www.postgresql.org/docs/{{ postgresql_short_version }}/static/sql-createindex.html) for full `CREATE INDEX` syntax.

Here is a syntax for creating single column index:

```sql
CREATE INDEX ${INDEX_NAME} ON ${TABLE_NAME} USING pgroonga (${COLUMN});
```

This syntax can be used for the following cases:

  * Creating a full text search index for a `text` type column
  * Creating a full text search index for an array of `text` type column
  * Creating a equality condition and comparison conditions search for a non `text` type columns
  * Creating a equality condition and comparison conditions search for an array of non `text` type columns

TODO

（`varchar`型に対して全文検索をする場合は追加で
`pgroonga.varchar_fulltext_search_ops`演算子クラスを指定する必要があり
ます。）


### Customize

`CREATE INDEX`の`WITH`でトークナイザーとノーマライザーをカスタマイズす
ることができます。デフォルトで適切なトークナイザーとノーマライザーが設
定されているので、通常はカスタマイズする必要はありません。上級者向けの
機能です。

なお、デフォルトのトークナイザーとノーマライザーは次の通りです。

  * トークナイザー: `TokenBigram`: Bigramベースのトークナイザーです。
  * ノーマライザー: [NormalizerAuto](http://groonga.org/ja/docs/reference/normalizers.html#normalizer-auto): エンコーディングに合わせて適切な正規化を行います。たとえば、UTF-8の場合はUnicodeのNFKCベースの正規化を行います。

トークナイザーをカスタマイズするときは`tokenizer='トークナイザー名'`を
指定します。例えば、[MeCab](http://taku910.github.io/mecab/)ベースのトー
クナイザーを指定する場合は次のように`tokenizer='TokenMecab'`を指定しま
す。（`TokenMecab`を使う場合は`groonga-tokenizer-mecab`パッケージをイ
ンストールしておく必要があります。）

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (tokenizer='TokenMecab');
```

次のように`tokenizer=''`を指定することでトークナイザーを無効にできます。
トークナイザーを無効にするとカラムの値そのもの、あるいは値の前方一致検
索でのみヒットするようになります。これは、タグ検索や名前検索などに有用
です。（タグ検索には`tokenizer='TokenDelimit'`も有用です。）

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (tokenizer='');
```

ノーマライザーをカスタマイズするときは`normalizer='ノーマライザー名'`を
指定します。通常は指定する必要はありません。

次のように`normalizer=''`を指定することでノーマライザーを無効にできま
す。ノーマライザーを無効にするとカラムの値そのものでのみヒットするよう
になります。正規化によりノイズが増える場合は有用な機能です。

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizer='');
```

