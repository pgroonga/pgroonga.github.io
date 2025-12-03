---
title: CREATE INDEX USING pgroonga
toc: true
---

# `CREATE INDEX USING pgroonga`

インデックスメソッドとしてPGroongaを使うためには`CREATE INDEX`に`USING pgroonga`を指定します。このセクションでは`pgroonga`インデックスメソッドについて説明します。

## 構文 {#syntax}

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

2.3.5から`INCLUDE`も使えます。

### カスタマイズ {#customization}

`CREATE INDEX`の`WITH`オプションを使って次の項目をカスタマイズできます。

  * プラグイン：Groongaの拡張機能です。プラグインを登録することで追加の機能を使うことができます。追加の機能には追加のトークナイザー・ノーマライザー・トークンフィルターなどがあります。

  * トークナイザー：キーワードの抽出方法をカスタマイズするモジュールです。

  * ノーマライザー：`text`型と`varchar`型の等価性をカスタマイズするモジュールです。

  * トークンフィルター：トークナイザーが抽出したキーワードをフィルターするモジュールです。

  * 語彙表の種類：トークンを管理する語彙表の種類です。

  * クエリー構文：[`$@~`演算子][query-v2]が使っている構文です。

  * 言語モデル: エンベディングの生成に使う言語モデルです。`plugins = 'language_model/knn'`と一緒に使います。

    * 4.0.5で追加。

  * Passageプレフィックス: 検索対象のテキストに付与するプレフィックスです。`plugins = 'language_model/knn'`と一緒に使います。

    * 4.0.5で追加。

  * Queryプレフィックス: クエリーのテキストに付与するプレフィックスです。`plugins = 'language_model/knn'`と一緒に使います。

    * 4.0.5で追加。

  * GPUレイヤー数: エンベディングを生成するときに利用するGPUレイヤー数です。`plugins = 'language_model/knn'`と一緒に使います。

    * 4.0.5で追加。

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

#### アルファベットでの部分一致 {#partial-match-alphabetic-languages}

キーワードがアルファベットの場合もキーワードの一部で検索をしたいときは、トークナイザーに`TokenNgram`を設定しオプションでトークナイザーの挙動を指定します。PGroongaのデフォルトのトークナイザーは`TokenBigram`なので、'pp'というキーワードは'Apple'、'Pineapple'、'Ripple'などのキーワードにはマッチしません。次の例のように`TokenNgram`にオプションを指定することでこの問題が回避できます。

TokenNgramベースのトークナイザーを使用する例は次の通りです。`tokenizer='TokenNgram'`を指定します。詳しくは[`TokenNgram`][groonga-token-ngram]を参照してください。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH(tokenizer='TokenNgram("unify_alphabet", false, "unify_symbol", false, "unify_digit", false)');
```

この例で使用したオプションを指定すると`TokenBigramSplitSymbolAlphaDigit`と同じ挙動になりますが、**`TokenNgram(...)`の使用をおすすめします。**

**注意**
`TokenNgram("unify_...)`を使用することでアルファベットの場合もキーワードの一部で検索できるようになりますが、アルファベットでの部分一致は多くのノイズを含む傾向があるため、本当に必要なときのみご利用ください。代わりに`TokenNgram`（オプションの指定なし）や`TokenBigram`の使用をおすすめします。

#### ノーマライザーのカスタマイズ方法 {#custom-normalizer}

次のパラメーターを使ってノーマライザーをカスタマイズできます。通常、ノーマライザーをカスタマイズする必要はありません。

  * `normalizers`：以下のどのパラメーターも使われなかったときに使われるデフォルトのノーマライザーです。

    * 2.3.1で追加。

  * `normalizer`：`normalizers`と同じです。2.3.1から非推奨になりました。

  * `full_text_search_normalizer`：`normalizers_mapping`でインデックス対象のノーマライザーが指定されなかったときに使われる全文検索インデックス用のノーマライザーです。

  * `regexp_search_normalizer`: `normalizers_mapping`でインデックス対象のノーマライザーが指定されなかったときに使われる正規表現検索インデックス用のノーマライザーです。

  * `prefix_search_normalizer`: `normalizers_mapping`でインデックス対象のノーマライザーが指定されなかったときに使われる前方一致検索インデックス用のノーマライザーです。

  * `normalizers_mapping`：指定したインデックス対象用のノーマライザーを指定できます。

    * 2.3.1で追加。

`normalizers=''`のように空の値を指定するとノーマライザーを無効にすることができます。ノーマライザーを無効にすると元のカラムの値そのものでだけ検索できます。もし、ノーマライザーを使うことで誤ヒットが増える場合は無効にした方がよいでしょう。

ノーマライザーを無効にする方法は次の通りです。

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizers='');
```

`normalizers='${NORMALIZER_NAME}(...)'`という構文でノーマライザーのオプションを指定できます。

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
        WITH (normalizers='NormalizerNFKC100("unify_kana", true)');
```

`normalizers='${NORMALIZER_NAME1}(...), ${NORMALISER_NAME2(...), ...'`という構文で複数のノーマライザーを指定できます。

2.3.1から使えます。

以下は`"unify_kana"`が`true`というオプション付きの`NormalizerNFKC130`ノーマライザーと`"unify_hyphen"`が`true`というオプション付きの`NormalizerNFKC130`ノーマライザーを使う実用的ではない例です。

```sql
CREATE TABLE memos (
  id integer,
  tag text
);

CREATE INDEX pgroonga_tag_index
          ON memos
       USING pgroonga (tag)
        WITH (normalizers='
                NormalizerNFKC130("unify_kana", true),
                NormalizerNFKC130("unify_hyphen", true)
              ');
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

これらのパラメーターを使っていない場合は`normalizers`パラメーターの値を使います。

以下は全文検索用のインデックスだけノーマライザーを無効にする例です。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (full_text_search_normalizer='',
              normalizers='NormalizerAuto');
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

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (regexp_search_normalizer='',
              normalizers='NormalizerAuto');
```

`content`のインデックスは正規表現検索用です。`regular_expression_search_normalizer`が`''`なので、このインデックスはノーマライザーを使いません。`normalizers`が`'NormalizerAuto'`なので、他のインデックスは`NormalizerAuto`を使います。

以下は前方一致検索用のインデックスだけノーマライザーを無効にする例です。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (prefix_search_normalizer='',
              normalizers='NormalizerAuto');
```

`tag`のインデックスは単語検索用です。単語検索は前方一致検索も含んでいます。`prefix_search_normalizer`が`''`なので、このインデックスはノーマライザーを使いません。`normalizers`が`'NormalizerAuto'`なので、他のインデックスは`NormalizerAuto`を使います。

`normalizers_mapping='${MAPPING_IN_JSON}'`を使うと指定したインデックス対象用のノーマライザーを指定できます。

2.3.1から使えます。

以下は`${MAPPING_IN_JSON}`の構文です。

```json
{
  "${index_target_name1}": "${normalizer1}",
  "${index_target_name2}": "${normalizer2}",
  ...
}
```

以下の例では`title`に`NormalizerNFKC130("unify_kana", true)`ノーマライザー、`content`に`NormalizerNFKC130("unify_hyphen", true)`ノーマライザー、それ以外のカラムに`NormalizerAuto`を指定しています。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (
               title pgroonga_text_full_text_search_ops_v2,
               content pgroonga_text_regexp_ops_v2,
               tag pgroonga_text_term_search_ops_v2
             )
        WITH (normalizers_mapping='{
                "title": "NormalizerNFKC130(\"unify_kana\", true)",
                "content": "NormalizerNFKC130(\"unify_hyphen\", true)"
              }',
              normalizers='NormalizerAuto');
```

##### `NormalizerTable`の使い方 {#normalizer-table}

ノーマライザーを指定するテキスト中で`${table:PGROONGA_INDEX_NAME}`という構文を使えます。

2.3.1から使えます。

この値は`PGROONGA_INDEX_NAME`で指定したPGroongaのインデックスに対応するGroongaのテーブル名に置換されます。これは[`NormalizerTable`][groonga-normalizer-table]を使うときに便利です。`NormalizerTable`はGroongaのテーブル名・カラム名を使うからです。

以下は`NormalizerNFKC130`ノーマライザーと`NormalizerTable`ノーマライザーを使う例です。

```sql
CREATE TABLE normalizations (
  target text,
  normalized text
);

CREATE INDEX pgrn_normalizations_index ON normalizations
 USING pgroonga (target pgroonga_text_term_search_ops_v2,
                 normalized);

INSERT INTO normalizations VALUES ('o', '0');
INSERT INTO normalizations VALUES ('ss', '55');

CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (content)
        WITH (normalizers='
                NormalizerNFKC130,
                NormalizerTable(
                  "normalized", "${table:public.pgrn_normalizations_index}.normalized",
                  "target", "target"
                )
             ');

INSERT INTO memos VALUES (1, '0123455');
INSERT INTO memos VALUES (2, 'o1234ss');

SELECT * FROM memos WHERE content &@~ 'o123455';
--  id | content 
-- ----+---------
--   1 | 0123455
--   2 | o1234ss
-- (2 rows)
```

`normalizations`テーブルを変更した後は`REINDEX INDEX pgroonga_memos_index`を実行しないといけないことに注意してください。なぜなら`normalizations`テーブルが変わるとノーマライズ結果も変わるからです。

##### `pgroonga_highlight_html`と一緒に`NormalizerTable`を使う方法 {#normalizer-table-highlight-html}

この`NormalizerTable`と一緒に`pgroonga_highlight_html`関数を使うときは、`TokenNgram`に`"report_source_location", true"`オプションを指定するだけでなく、`NormalizerNFKC*`と`NormalizerTable`それぞれに`"report_source_offset", true"`オプションを指定する必要があります。

詳細は[`pgroonga_highlight_html`関数][highlight-html]を参照してください。

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

#### テーブルスペースのカスタマイズ方法 {#custom-tablespace}

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

#### 語彙表の種類のカスタマイズ方法 {#custom-lexicon-type}

2.0.6で追加。

語彙表の種類をカスタマイズするには`lexicon_type='${LEXICON_TYPE}'`を指定します。

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

#### インデックスカラムフラグのカスタマイズ方法 {#custom-index-flags}

2.3.2で追加。

指定したインデックス対象のインデックスカラムフラグをカスタマイズするには`index_flags_mappings='${MAPPING_IN_JSON}'`を指定します。

以下は`${MAPPING_IN_JSON}`の構文です。

```json
{
  "${index_target_name1}": ["${flag1_1}", "${flag1_2}", ..., "${flag1_N}"],
  "${index_target_name2}": ["${flag2_1}", "${flag2_2}", ..., "${flag2_N}"],
  ...
}
```

以下は利用可能なインデックスカラムのフラグです。それぞれ[Groongaのフラグ][groonga-index-column-flags]に対応しています。

  * `SMALL`: Groongaでの`INDEX_SMALL`

  * `MEDIUM`: Groongaでの`INDEX_MEDIUM`

  * `LARGE`: Groongaでの`INDEX_LARGE`

  * `WITH_WEIGHT`: Groongaでの`WITH_WEIGHT`

  * `WEIGHT_FLOAT32`: Groongaでの`WEIGHT_FLOAT32`

`["SMALL", "MEDIUM", "LARGE"]`というように競合するフラグを同時に指定することはできません。

通常、これをカスタマイズする必要はありません。なぜなら多くの場合はデフォルト値が適切だからです。

以下は大量データのために大きいインデックスカラムを使う例です。

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (index_flags_mapping='{
                "content": ["LARGE"]
              }');
```

#### セマンティックサーチを使う方法 {#semantic-search}

4.0.5で追加。

インデックスを作成する際には、以下のオプションを指定する必要があります。

* `pgroonga_text_semantic_search_ops_v2`演算子クラス。

* `plugins = 'language_model/knn'`

* `model = '${HUGGING_FACE_URI}'`

  * 利用したい言語モデルのHugging FaceのURIを指定します。

* `passage_prefix = '${PASSAGE_PREFIX}'`

  * 言語モデルの仕様に応じて指定してください。

* `query_prefix = '${QUERY_PREFIX}'`

  * 言語モデルの仕様に応じて指定してください。

* `n_gpu_layers = ${n_gpu_layers}`

  * 通常は指定する必要はありません。

最小限のオプションでインデックスを作成する例は次のとおりです:

```sql
CREATE TABLE memos (
  id integer,
  content text
);

CREATE INDEX pgrn_index ON memos
 USING pgroonga (id, content pgroonga_text_semantic_search_ops_v2)
 WITH (plugins = 'language_model/knn',
       model = 'hf:///groonga/multilingual-e5-base-Q4_K_M-GGUF');
```

`&@*`演算子を使ってセマンティックサーチができます。

[query-v2]:operators/query-v2.html

[highlight-html]:functions/pgroonga-highlight-html.html

[groonga-token-bigram]:http://groonga.org/ja/docs/reference/tokenizers.html#token-bigram

[groonga-normalizer-auto]:http://groonga.org/ja/docs/reference/normalizers.html#normalizer-auto

[groonga-table-patricia-trie]:http://groonga.org/ja/docs/reference/tables.html#table-pat-key

[groonga-table-hash-table]:http://groonga.org/ja/docs/reference/tables.html#table-hash-key

[groonga-table-double-array-trie]:http://groonga.org/ja/docs/reference/tables.html#table-dat-key

[unicode-nfkc]:http://unicode.org/reports/tr15/

[mecab]:http://taku910.github.io/mecab/

[groonga-token-ngram]:https://groonga.org/ja/docs/reference/tokenizers/token_ngram.html

[groonga-token-mecab]:http://groonga.org/ja/docs/reference/tokenizers.html#token-mecab

[groonga-token-delimit]:http://groonga.org/ja/docs/reference/tokenizers.html#token-delimit

[groonga-tokenizers]:http://groonga.org/ja/docs/reference/tokenizers.html

[groonga-normalizers]:http://groonga.org/ja/docs/reference/normalizers.html

[groonga-normalizer-table]:https://groonga.org/ja/docs/reference/normalizers/normalizer_table.html

[groonga-token-filters]:http://groonga.org/ja/docs/reference/token_filters.html

[postgresql-tablespace]:{{ site.postgresql_doc_base_url.ja }}/manage-ag-tablespaces.html

[text-full-text-search-ops-v2]:./#text-full-text-search-ops-v2

[text-regexp-ops-v2]:./#text-regexp-ops-v2

[text-term-search-ops-v2]:./#text-term-search-ops-v2

[groonga-query-syntax]:http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[groonga-index-column-flags]:https://groonga.org/ja/docs/reference/commands/column_create.html#flags
