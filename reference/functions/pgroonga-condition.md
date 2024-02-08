---
title: pgroonga_condition function
upper_level: ../
---

# `pgroonga_condition()` function

## Summary

`pgroonga_condition()`関数は`pgroonga_condition`型の値を返します。
関数名と型名が同じですが別物です。
`pgroonga_condition`型は`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型のように複雑な条件式を表現します。

`pgroonga_condition()`関数は`pgroonga_condition`型の値を作るための便利関数です。
特定の属性値のみを指定して`pgroonga_condition`型の値を作れます。

`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、このような便利関数がなかったため
必ず全ての属性値を指定して値を作る必要がありました。

したがって、不要な属性値があっても、`pgroonga_full_text_search_condition`型や`pgroonga_full_text_search_condition_with_scorers`型では、
以下のように不要な属性値には`NULL`を指定する必要がありました。

```
title &@~ ('keyword', NULL, 'index_name')::pgroonga_full_text_search_condition
title &@~ ('keyword', ARRAY[1,1,1,5,0], NULL, 'index_name')::pgroonga_full_text_search_condition_with_scorers
```

型を指定して直接値を作る従来の方法では後方互換性を維持したまま新しい属性を作ることができませんでした。
そのため、新しい属性を追加するたびに`pgroonga_full_text_search_condition_with_XXX`というような新しい型を追加する必要がありました。
たとえば、`pgroogna_full_text_search_condition_with_scorers`型はそのために追加された型です。

`pgroonga_full_text_search_condition`型と`pgroonga_full_text_search_condition_with_scorers`型
の違いは`scorers`が存在するかどうかですが、`pgroonga_full_text_search_condition`型に`scorers`を追加してしまうと、
`scorers`を使わないユーザーも新たに`NULL`を挿入して`pgroonga_full_text_search_condition`型の値を作らなければなりません。

しかし、`pgroonga_condition`型の値を作るための便利関数`pgroonga_condition()`関数を導入することにより後方互換性を維持したまま
`pgroonga_condition`型に新しい属性を追加できます。
`pgroonga_condition()`関数が非互換を吸収してくれるからです。

以下のように、`pgroonga_condition()`関数は不要な属性値を省略できるため、新たに属性値が追加されても既存の書き方を維持できます。
(次の例では、`weights`、`scorers`、`schema_name`、`column_name`を省略しています。
属性値の詳細については、後述の「構文」で記載します。ここでは、不要な属性値が省略できることに注目してください。)

```
title &@~ pgroonga_condition('keyword', index_name => 'index_name')
```

`pgroonga_condition()`関数では、上のように属性値を省略できますが、代わりに、「index_name => 'index name'」のように
キーワード引数のような記載が必要になることに注意してください。

上の例では、キーワード引数のような書き方をしている属性値とそうでない属性値があります。
どのように書き分けるかについては、後述の「構文」で記載します。
ここでは、従来とは異なる書き方が必要になることがあるという点に注目してください。

## Syntax

Here is the syntax of this function:

```
pgroonga_condition pgroonga_condition(query,
                                      weights,
                                      scorers,
                                      schema_name,
                                      index_name,
                                      column_name)
```

`query`は検索キーワードです。`text`型です。

`weights`はそれぞれの値の重要度です。`int[]`型です。

`scorers`はそれぞれの値のスコアーを計算する処理です。`text[]`型です。

`schema_name`はシーケンシャルサーチ実行時に参照するインデックスが属するスキーマです。`text`型です。

`index_name`はシーケンシャルサーチ実行時に参照するインデックスです。`text`型です。

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性です。`text`型です。

`pgroonga_condition()`の引数はすべて省略可能です。そのため、[「`引数名 => 値`」][sql-syntax-calling-funcs-named]という名前付き表記を使うことで特定の引数だけ指定することができます。たとえば、`index_name`だけ指定する場合は`pgroonga_condition(index_name => 'index1')`となります。
ただ、一般的なユースケースでは次の3種類の書き方を覚えておけば十分です。

```
title &@~ pgroonga_condition('query', index_name => 'pgroonga_index')
title &@~ pgroonga_condition('query', ARRAY[weight1, weight2, ...])
title &@~ pgroonga_condition('query', ARRAY[weight1, weight2, ...], index_name => 'pgroonga_index')
```

上の例以外の使い方をする場合のために、「`引数名 => 値`」で記述する必要がある引数とそうでない引数の違いを説明します。
例えば、次は引数`weights`、`scorers`、`schema_name`、`column_name`を省略しています。

```
title &@~ pgroonga_condition('query', index_name => 'pgroonga_index')
```

引数`weights`と`scorers`と`schema_name`を省略したことで、引数`index_name`の指定は第2引数の位置にありますが、
関数のシグネチャーでは`index_name`は第5引数なので、このケースでは、`index_name`は関数のシグネチャーと位置が異なる引数となります。
一方、第1引数にある`query`は「`引数名 => 値`」という表記ではないので、関数のシグネチャーと位置が同じ引数となります。

つまり、関数のシグネチャーと同じ位置にある、`query`は、「`引数名 => 値`」の形で書く必要はなく、値をそのまま記述できますが、
関数のシグネチャーと違う位置にある、`index_name`は、「`引数名 => 値`」の形で書く必要があります。

## Usage

Here are sample schema and data:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (title)
        WITH (normalizers='"NormalizerNFKC150(\"unify_katakana_v_sounds\", true)"');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
```

シーケンシャルサーチ実行時でも検索結果が変化しないように、シーケンシャルサーチ実行時でも
`title`属性に設定したインデックスを参照できるようにするには、以下のようにします。

```sql
SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    index_name => 'pgroonga_memos_index');
（結果）
```

`index_name`はシーケンシャルサーチ実行時に参照するインデックスを指定します。

通常、インデックスサーチではなくシーケンシャルサーチが実行されると、PGroongaのインデックスに設定されているトークナイザーとノーマライザーを使えません。
シーケンシャルサーチの場合はPGroongaのインデックスを使わないので、トークナイザーとノーマライザーの設定がどこにあるか判断できないためです。
そのため、シーケンシャルサーチ実行時と、インデックスサーチ実行時で検索結果が変わってしまうことがあります。
上の例で、もし`index_name`を指定しなければ、シーケンシャルサーチ実行時は「ヴァイオリン」で「バイオリン」はヒットしないので、
インデックスサーチ実行時とシーケンシャルサーチ実行時で検索結果が変わってしまいます。
これを防止するため、`index_name`でPGroongaのインデックスを指定しシーケンシャルサーチ実行時でもトークナイザーとノーマライザーの設定を参照できるようにしています。

複数のカラムが検索対象で、カラム毎の重みを設定したい場合は以下のようにします。
`pgroonga_condition()`の第2引数の配列で重みを設定しています。

次の例のように、重みを0にすることで対応するカラムを検索対象外にできます。
次の例では、`content`カラムを検索対象外にしています。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (ARRAY[title, content]::text[])
        WITH (normalizers='"NormalizerNFKC150(\"unify_katakana_v_sounds\", true)"');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
INSERT INTO memos VALUES (2, 'チェロ', 'ヴァイオリンだけではなく、チェロも始めました！');

SELECT *
  FROM memos
 WHERE ARRAY[title, content]::text[] &@~ pgroonga_condition('バイオリン',
                                                            ARRAY[1,0],
                                                            index_name => 'pgroonga_momos_index');
(結果)
```

スコアーを計算する、スコアラーを変更する場合は、以下のように`scorers`を指定してください。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (ARRAY[title, content]::text[])
        WITH (normalizers='"NormalizerNFKC150(\"unify_katakana_v_sounds\", true)"');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');
INSERT INTO memos VALUES (2, 'チェロ', 'ヴァイオリンだけではなく、チェロも始めました！');

SELECT *, pgroonga_scorers(tableoid, ctid) AS socre
  FROM memos
 WHERE ARRAY[title, content]::text[] &@~ pgroonga_condition('バイオリン',
                                                            ARRAY[5,1],
                                                            ARRAY[NULL, 'scorer_tf_at_most($index, 0.5)']
                                                            index_name => 'pgroonga_momos_index');
(結果)
```

postgres_fdwを使って外部データベースを検索する場合でも、シーケンシャルサーチの検索結果とインデックスサーチの検索結果が変わらないようにするには、
以下のように`schema_name`を使用してください。

```sql
SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    schema_name => 'public',
                                    index_name => 'pgroonga_memos_index');
(結果)
```

`schema_name`はシーケンシャルサーチ実行時に参照するインデックスが属するスキーマを指定します。
通常のケースでは指定する必要はありません。

PostgreSQLは、スキーマ未指定の場合`search_path`に登録されているスキーマから該当するインデックスを検索します。
通常は、`search_path`に存在するスキーマ内に該当するインデックスがあるため`schema_name`を指定しなくても適切なインデックスを参照できます。

しかし、 上の例のように[postgres_fdw][postgres-fdw]を使って外部のPostgreSQLのデータベースへアクセスする場合、`search_path`は`pg_catalog`のみになります。
このケースでは、`pg_catalog`スキーマ内に参照したいインデックスが存在しない場合、スキーマ未指定では該当のインデックスを発見できません。

このように、`search_path`に登録されているスキーマ以外のスキーマに参照したいインデックスがある場合は、`schema_name`で明示的にスキーマを指定することで
該当のインデックスを発見できます。

特定の属性に紐付いているインデックスを参照したい場合は、以下のように`column_name`を指定してください。

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_memos_index
          ON memos
       USING pgroonga (title, content)
        WITH (normalizers_mapping='{
                "title": "NormalizerNFKC150(\"unify_katakana_v_sounds\", true)",
                "content": "NormalizerNFKC150"
              }',
              normalizers='NormalizerAuto');

INSERT INTO memos VALUES (1, 'ヴァイオリン', E'Let\'s play violin!');

SELECT *
  FROM memos
 WHERE title &@~ pgroonga_condition('バイオリン',
                                    index_name => 'pgroonga_memos_index',
                                    column_name => 'title');
```

`column_name`はシーケンシャルサーチ実行時に参照するインデックスが紐付けられている属性を指定します。

PGroongaには、インデックスのオプションに[`normalizers_mapping`][normalizers-mapping]があります。
これは上の例のように特定の属性に対して、特定のノーマライザーとそのオプションを指定できるものです。

上の例では、`title`属性に`unify_katakana_v_sounds`が設定されています。
「バイオリン」で「ヴァイオリン」をヒットさせるためには、`unify_katakana_v_sounds`が有効である必要がありますが、
シーケンシャルサーチが実施された場合、PGroongaのインデックスを参照できず`unify_katakana_v_sounds`が効きません。
そこで、以下のように`pgroonga_condition()`の`column_name`で`title`属性を指定することで、`title`属性に
設定されている`unify_katakana_v_sounds`を使えます。

その結果、上の例のようにシーケンシャルサーチでも「バイオリン」で「ヴァイオリン」をヒットさせることができます。

## See also

* [postgres_fdw][postgres-fdw]
* [normalizers_mapping][normalizers-mapping]
* [名前付け表記][sql-syntax-calling-funcs-named]


[postgres-fdw]:https://www.postgresql.org/docs/current/postgres-fdw.html
[normalizers-mapping]:../create-index-using-pgroonga.html
[sql-syntax-calling-funcs-named]:https://www.postgresql.org/docs/current/sql-syntax-calling-funcs.html#SQL-SYNTAX-CALLING-FUNCS-NAMED
