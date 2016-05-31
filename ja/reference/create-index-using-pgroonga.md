---
title: CREATE INDEX USING pgroonga
---

# `CREATE INDEX USING pgroonga`

インデックスメソッドとしてPGroongaを使うためには`CREATE INDEX`に`USING pgroonga`を指定します。このセクションでは`pgroonga`インデックスメソッドについて説明します。

## 構文

このセクションでは`pgroonga`インデックスメソッド関連の`CREATE INDEX`の構文だけ説明します。完全な`CREATE INDEX`の構文は[PostgreSQLの`CREATE INDEX`のドキュメント](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/sql-createindex.html)を参照してください。

シングルカラムインデックスを作成する基本的な構文は次の通りです。

```sql
CREATE INDEX ${INDEX_NAME}
          ON ${TABLE_NAME}
       USING pgroonga (${COLUMN});
```

次のケースのときはこの構文を使えます。

  * `text`型のカラム用の全文検索インデックスを作るとき
  * `text`型の配列のカラム用の全文検索インデックスを作るとき
  * `text`型以外の型のカラム用の等価条件・比較条件検索用インデックスを作るとき
  * `text`型以外の型の配列のカラム用の等価条件・比較条件検索用インデックスを作るとき
  * `jsonb`型のカラム用のサブセット検索・高度な検索用のインデックスを作るとき

`varchar`型のカラム用の全文検索インデックスを作るときの基本的な構文は次の通りです。

```sql
CREATE INDEX ${INDEX_NAME}
          ON ${TABLE_NAME}
       USING pgroonga (${COLUMN} pgroonga.varchar_full_text_search_ops);
```

この場合は`pgroonga.varchar_full_text_search_ops`オペレータークラスを指定する必要があります。

### カスタマイズ {#customization}

`CREATE INDEX`の`WITH`オプションを使って次の項目をカスタマイズできます。

  * トークナイザー：キーワードの抽出方法をカスタマイズするモジュールです。
  * ノーマライザー：`text`型と`varchar`型の等価性をカスタマイズするモジュールです。

通常、これらをカスタマイズする必要はありません。なぜなら多くの場合で適切なようにデフォルト値が設定されているからです。これらをカスタマイズする機能は高度なユーザー向けの機能です。

デフォルトのトークナイザーとノーマライザーは次の通りです。

  * トークナイザー：[`TokenBigram`](http://groonga.org/ja/docs/reference/tokenizers.html#token-bigram)：bigramベースのトークナイザーです。このトークナイザーはbigramベースのトークナイズ方法とスペース区切りベースのトークナイズ方法を組み合わせています。非ASCII文字にはbigramベースのトークナイズ方法を使い、ASCII文字にはスペース区切りベースのトークナイズ方法を使います。これはASCII文字だけのクエリーで検索したときのノイズを減らすためです。
  * ノーマライザー：[`NormalizerAuto`](http://groonga.org/ja/docs/reference/normalizers.html#normalizer-auto)：対象のエンコーディングに合わせて適切なノーマライズ方法を選びます。たとえば、UTF-8の場合は[Unicode NFKC](http://unicode.org/reports/tr15/)ベースのノーマライズ方法を使います。

#### トークナイザーのカスタマイズ方法 {#custom-tokenizer}

トークナイザーをカスタマイズするには`tokenizer='${トークナイザー名}'`を指定します。通常、トークナイザーをカスタマイズする必要はありません。

以下は[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使う例です。`tokenizer='TokenMecab'`を指定する必要があります。[`TokenMecab`](http://groonga.org/ja/docs/reference/tokenizers.html#token-mecab)はMeCabベースのトークナイザーの名前です。

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

`tokenizer=''`と指定することでトークナイザーを無効にすることができます。トークナイザーを無効にすると、完全一致検索または前方一致検索のみでカラムの値を検索できます。これにより誤ヒットが少なくなるケースがあります。例えば、タグ検索・名前検索などのときは有用です。

以下はトークナイザーを無効にする例です。

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

`tokenizer='TokenDelimit'`はタグ検索で便利です。[`TokenDelimit`](http://groonga.org/ja/docs/reference/tokenizers.html#token-delimit)も参照してください。

他のトークナイザーについては[トークナイザー](http://groonga.org/ja/docs/reference/tokenizers.html)を参照してください。

#### ノーマライザーのカスタマイズ方法 {#custom-normalizer}

ノーマライザーをカスタマイズするには`normalizer='${ノーマライザー名}'`を指定してください。通常はノーマライザーをカスタマイズする必要はありません。

`normalizer=''`を指定するとノーマライザーを無効にすることができます。ノーマライザーを無効にすると元のカラムの値そのものでだけ検索できます。もし、ノーマライザーを使うことで誤ヒットが増える場合は無効にした方がよいでしょう。

ノーマライザーを無効にする方法は次の通りです。

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

他のノーマライザーについては[ノーマライザー](http://groonga.org/ja/docs/reference/normalizers.html)を参照してください。
