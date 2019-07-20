---
title: CREATE INDEX USING pgroonga
---

# `CREATE INDEX USING pgroonga`

インデックスメソッドとしてPGroongaを使うためには`CREATE INDEX`に`USING pgroonga`を指定します。このセクションでは`pgroonga`インデックスメソッドについて説明します。

## 構文

このセクションでは`pgroonga`インデックスメソッド関連の`CREATE INDEX`の構文だけ説明します。完全な`CREATE INDEX`の構文は[PostgreSQLの`CREATE INDEX`のドキュメント]({{ site.postgresql_doc_base_url.ja }}/sql-createindex.html)を参照してください。

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
       USING pgroonga (${COLUMN} pgroonga_varchar_full_text_search_ops_v2);
```

この場合は`pgroonga_varchar_full_text_search_ops_v2`オペレータークラスを指定する必要があります。

### カスタマイズ {#customization}

`CREATE INDEX`の`WITH`オプションを使って次の項目をカスタマイズできます。

  * プラグイン：Groongaの拡張機能です。プラグインを登録することで追加の機能を使うことができます。追加の機能には追加のトークナイザー・ノーマライザー・トークンフィルターなどがあります。

  * トークナイザー：キーワードの抽出方法をカスタマイズするモジュールです。

  * ノーマライザー：`text`型と`varchar`型の等価性をカスタマイズするモジュールです。

  * トークンフィルター：トークナイザーが抽出したキーワードをフィルターするモジュールです。

  * 語彙表の種類：トークンを管理する語彙表の種類です。

  * クエリー構文：[`$@~`演算子][query-v2]が使っている構文です。

通常、これらをカスタマイズする必要はありません。なぜなら多くの場合で適切なようにデフォルト値が設定されているからです。これらをカスタマイズする機能は高度なユーザー向けの機能です。

デフォルトではプラグインとトークンフィルターは使われていません。

デフォルトのトークナイザーとノーマライザーと語彙表の種類は次の通りです。

  * トークナイザー：[`TokenBigram`][groonga-token-bigram]：bigramベースのトークナイザーです。このトークナイザーはbigramベースのトークナイズ方法とスペース区切りベースのトークナイズ方法を組み合わせています。非ASCII文字にはbigramベースのトークナイズ方法を使い、ASCII文字にはスペース区切りベースのトークナイズ方法を使います。これはASCII文字だけのクエリーで検索したときのノイズを減らすためです。

  * ノーマライザー：[`NormalizerAuto`][groonga-normalizer-auto]：対象のエンコーディングに合わせて適切なノーマライズ方法を選びます。たとえば、UTF-8の場合は[Unicode NFKC][unicode-nfkc]ベースのノーマライズ方法を使います。


  * 語彙表の種類：[`patricia_trie`][groonga-table-patricia-trie]：前方一致検索のようなリッチな方法でトークンを検索できます。サイズも小さいです。

#### プラグインの登録方法 {#custom-plugins}

1.2.0で追加。

プラグインを登録するには`plugins='${プラグイン名1}, ${プラグイン名2}, ..., ${プラグイン名N}'`を指定します。

`CREATE INDEX`の最初のオプションとして`plugins`を指定しなければいけないことに注意してください。`CREATE INDEX`のオプションは指定された順に処理されます。指定したプラグインに含まれてるトークナイザー・ノーマライザー・トークンフィルターを使うかもしれないので、他のオプションより先にプラグインを登録しておく必要があります。

以下は`TokenFilterStem`トークンフィルターを使うために`token_filters/stem`プラグインを登録する例です。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (plugins='token_filters/stem',
              token_filters='TokenFilterStem');
```

トークンフィルターについては[トークンフィルターのカスタマイズ方法](#custom-token-filters)を参照してください。

#### トークナイザーのカスタマイズ方法 {#custom-tokenizers}

トークナイザーをカスタマイズするには`tokenizer='${トークナイザー名}'`を指定します。通常、トークナイザーをカスタマイズする必要はありません。

以下は[MeCab][mecab]ベースのトークナイザーを使う例です。`tokenizer='TokenMecab'`を指定する必要があります。[`TokenMecab`][groonga-token-mecab]はMeCabベースのトークナイザーの名前です。

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

`tokenizer='TokenDelimit'`はタグ検索で便利です。[`TokenDelimit`][groonga-token-delimit]も参照してください。

`tokenizer='${TOKENIZER_NAME}(...)'`という構文でトークナイザーのオプションを指定できます。

2.0.6から使えます。

以下は`"n"`オプションと`3`オプションを指定して`TokenNgram`トークナイザーを使う例です。

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (tokenizer='TokenNgram("n", 3)');
```

他のトークナイザーについては[トークナイザー][groonga-tokenizers]を参照してください。

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

`normalizer='${NORMALIZER_NAME}(...)'`という構文でノーマライザーのオプションを指定できます。

2.0.6から使えます。

以下は`"unify_kana"`オプションと`true`オプションを指定して`NormalizerNFKC100`ノーマライザーを使う例です。

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizer='NormalizerNFKC100("unify_kana", true)');
```

他のノーマライザーについては[ノーマライザー][groonga-normalizers]を参照してください。

全文検索・正規表現検索・前方一致検索それぞれに別のノーマライザーを使うこともできます。これらの検索用の代表的な演算子クラスは次の通りです。

  * 全文検索：[`pgroonga_text_full_text_search_ops_v2`][text-full-text-search-ops-v2]

  * 正規表現検索：[`pgroonga_text_regexp_ops_v2`][text-regexp-ops-v2]

  * 前方一致検索：[`pgroonga_text_term_search_ops_v2`][text-term-search-ops-v2]

次のパラメーターを使うことでそれぞれの検索方法ごとに異なるノーマライザーを使えます。

  * 全文検索：`full_text_search_normalizer`

  * 正規表現検索：`regexp_search_normalizer`

  * 前方一致検索：`prefix_search_normalizer`

これらのパラメーターを使っていない場合は`normalizer`パラメーターの値を使います。

以下は全文検索用のインデックスだけノーマライザーを無効にする例です。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (
               title pgroonga_full_text_search_ops_v2,
               content pgroonga_regexp_ops_v2,
               tag pgroonga_term_search_ops_v2
             )
        WITH (full_text_search_normalizer='',
              normalizer='NormalizerAuto');
```

`title`のインデックスは全文検索用です。`full_text_search_normalizer`が`''`なので、このインデックスはノーマライザーを使いません。`normalizer`が`'NormalizerAuto'`なので、他のインデックスは`NormalizerAuto`を使います。

以下は正規表現検索用のインデックスだけノーマライザーを無効にする例です。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (
               title pgroonga_full_text_search_ops_v2,
               content pgroonga_regexp_ops_v2,
               tag pgroonga_term_search_ops_v2
             )
        WITH (regexp_search_normalizer='',
              normalizer='NormalizerAuto');
```

`content`のインデックスは正規表現検索用です。`regular_expression_search_normalizer`が`''`なので、このインデックスはノーマライザーを使いません。`normalizer`が`'NormalizerAuto'`なので、他のインデックスは`NormalizerAuto`を使います。

以下は前方一致検索用のインデックスだけノーマライザーを無効にする例です。<

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (
               title pgroonga_full_text_search_ops_v2,
               content pgroonga_regexp_ops_v2,
               tag pgroonga_term_search_ops_v2
             )
        WITH (prefix_search_normalizer='',
              normalizer='NormalizerAuto');
```

`tag`のインデックスは単語検索用です。単語検索は前方一致検索も含んでいます。`prefix_search_normalizer`が`''`なので、このインデックスはノーマライザーを使いません。`normalizer`が`'NormalizerAuto'`なので、他のインデックスは`NormalizerAuto`を使います。<

#### トークンフィルターのカスタマイズ方法 {#custom-token-filter}

1.2.0で追加。

トークンフィルターを使うには`token_filters='${トークンフィルター1}, ${トークンフィルター2}, ..., ${トークンフィルターN}'`を指定します。

Groongaはデフォルトでは1つもトークンフィルターを提供していません。すべてのトークンフィルターはプラグインとして提供しています。トークンフィルターを使う場合はプラグインを登録する必要があります。

以下は`token_filters/stem`プラグインに含まれている`TokenFilterStem`トークンフィルターを使う例です。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (plugins='token_filters/stem',
              token_filters='TokenFilterStem');
```

`token_filters`より前に`plugins`を指定しなければいけないことに注意してください。`CREATE INDEX`に指定したオプションは指定した順に処理されます。トークンフィルターを使う前にプラグインを登録しておく必要があります。

他のトークンフィルターについては[トークンフィルター][groonga-token-filters]を参照してください。

#### テーブルスペースの変更方法 {#custom-tablespace}

1.1.6で追加。

[テーブルスペース][postgresql-tablespace]をカスタマイズするには`TABLESPACE ${TABLESPACE_NAME}`を指定してください。もし高速なストレージがある場合は、テーブルスペースを変更してそのストレージにPGroongaのインデックスを置きたくなるかもしれません。

以下はテーブルスペースを変更する例です。

```sql
CREATE TABLESPACE fast LOCATION '/data/fast_disk';

CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
  TABLESPACE fast;
```

#### 語彙表の種類の変更方法 {#custom-lexicon-type}

2.0.6で追加。

語彙表の種類を変更するには`lexicon_type='${LEXICON_TYPE}'`を指定します。

利用可能な語彙表の種類は次の通りです。

  * [`hash_table`][groonga-table-hash-table]

  * [`patricia_trie`][groonga-table-patricia-trie]

    * デフォルト

  * [`double_array_trie`][groonga-table-double-array-trie]

通常、これをカスタマイズする必要はありません。なぜなら多くの場合はデフォルト値が適切だからです。

以下はトークンの前方一致検索を無効にするために語彙表の種類を`hash_table`にする例です。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (lexicon_type='hash_table');
```

#### クエリーで`column:...`構文を使う方法 {#query-allow-column}

2.1.3で追加。

クエリー中で`column:...`構文を使うには`query_allow_column=true`を指定します。

`column:...`構文を使うと、他のカラムを使ったり、マッチ以外の演算子も使うことができます。

`column:...`構文はシーケンシャルサーチでは動かないことに注意してください。インデックスサーチでしか動きません。

以下は同じインデックス内の他のカラムを使うために`query_allow_column`を使う例です。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text,
  content text
);

CREATE INDEX pgroonga_memo_texts_index
          ON memos
       USING pgroonga (title, content)
        WITH (query_allow_column=true);

INSERT INTO memos VALUES
  ('PGroonga = PostgreSQL + Groonga', 'Very fast full text search extension.'),
  ('PostGIS', 'GIS extension.');

SELECT *
  FROM memos
    -- contentカラムは'extension'を含んでいて、かつ、
    -- titleカラムは'Groonga'を含んでいなければいけない。
 WHERE content &@~ 'extension title:@Groonga';
--               title              |                content                
-- ---------------------------------+---------------------------------------
--  PGroonga = PostgreSQL + Groonga | Very fast full text search extension.
-- (1 row)
```

以下は他の演算を使うために`query_allow_column`を使う例です。

```sql
DROP TABLE IF EXISTS memos;
CREATE TABLE memos (
  title text
);

CREATE INDEX pgroonga_title_index
          ON memos
       USING pgroonga (title)
        WITH (query_allow_column=true);

INSERT INTO memos VALUES ('PGroonga');
INSERT INTO memos VALUES ('PGroonga = PostgreSQL + Groonga');

SELECT *
  FROM memos
    -- titleカラムは'PGroonga'でなければいけない。
    -- この演算はインデックスを使わないことに注意すること。
 WHERE title &@~ 'title:PGroonga';
--   title   
-- ----------
--  PGroonga
-- (1 row)
```

使える演算は[Groongaのクエリー構文][groonga-query-syntax]を参照してください。

[query-v2]:operators/query-v2.html

[groonga-token-bigram]:http://groonga.org/ja/docs/reference/tokenizers.html#token-bigram

[groonga-normalizer-auto]:http://groonga.org/ja/docs/reference/normalizers.html#normalizer-auto

[groonga-table-patricia-trie]:http://groonga.org/ja/docs/reference/tables.html#table-pat-key

[groonga-table-hash-table]:http://groonga.org/ja/docs/reference/tables.html#table-hash-key

[groonga-table-double-array-trie]:http://groonga.org/ja/docs/reference/tables.html#table-dat-key

[unicode-nfkc]:http://unicode.org/reports/tr15/

[mecab]:http://taku910.github.io/mecab/

[groonga-token-mecab]:http://groonga.org/ja/docs/reference/tokenizers.html#token-mecab

[groonga-token-delimit]:http://groonga.org/ja/docs/reference/tokenizers.html#token-delimit

[groonga-tokenizers]:http://groonga.org/ja/docs/reference/tokenizers.html

[groonga-normalizers]:http://groonga.org/ja/docs/reference/normalizers.html

[groonga-token-filters]:http://groonga.org/ja/docs/reference/token_filters.html

[postgresql-tablespace]:{{ site.postgresql_doc_base_url.ja }}/manage-ag-tablespaces.html

[text-full-text-search-ops-v2]:./#text-full-text-search-ops-v2

[text-regexp-ops-v2]:./#text-regexp-ops-v2

[text-term-search-ops-v2]:./#text-term-search-ops-v2

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html
