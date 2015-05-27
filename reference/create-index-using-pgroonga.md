---
title: CREATE INDEX USING pgroonga
layout: en
---

# `CREATE INDEX USING pgroonga`

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

