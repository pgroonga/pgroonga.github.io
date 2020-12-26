---
title: pgroonga_match_positions_character関数
upper_level: ../
---

# `pgroonga_match_positions_character`関数

1.1.1で追加。

## 概要

`pgroonga_match_positions_character`関数は指定したテキスト中にある指定したキーワードの位置を返します。単位は文字です。HTML出力用にキーワードをハイライトしたいなら[`pgroonga_snippet_html`関数](pgroonga-snippet-html.html)または[`pgroonga_highlight_html`関数](pgroonga-highlight-html.html)の方が適しているでしょう。`pgroonga_match_positions_character`関数は高度な用途向けです。

バイト単位バージョンが欲しい場合は代わりに[`pgroonga_match_positions_byte`](pgroonga-match-positions-byte.html)を参照してください。

## 構文

使い方は2つあります。

```text
integer[2][] pgroonga_match_positions_character(target, ARRAY[keyword1, keyword2, ...])
integer[2][] pgroonga_match_positions_character(target, ARRAY[keyword1, keyword2, ...], index_name)
```

1つ目の使い方は他の使い方よりもシンプルです。多くの場合は1つ目の使い方で十分です。

2つ目の使い方はノーマライザーを変更しているときに便利です。

2つ目の使い方は2.2.8以降で使えます。

以下は1つ目の使い方の説明です。

```text
integer[2][] pgroonga_match_positions_character(target, ARRAY[keyword1, keyword2, ...])
```

`target`はキーワード検索対象のテキストです。型は`text`です。

`keyword1`、`keyword2`、`...`は見つけたいキーワードです。型は`text`の配列です。1つ以上のキーワードを指定しなければいけません。

`pgroonga_match_positions_character` returns an array of positions.

位置は「オフセット」と「長さ」で表現します。「オフセット」は先頭からキーワードが現れた位置までの文字数です。「長さ」はマッチしたテキストの文字数です。「長さ」はキーワードの長さと違うかもしれません。これはキーワードもマッチしたテキストも正規化されるからです。

以下は2つ目の使い方の説明です。

```text
integer[2][] pgroonga_match_positions_character(target, ARRAY[keyword1, keyword2, ...], index_name)
```

`target`はキーワード検索対象のテキストです。型は`text`です。

`keyword1`、`keyword2`、`...`は見つけたいキーワードです。型は`text`の配列です。1つ以上のキーワードを指定しなければいけません。

`index_name`は対応するPGroongaのインデックス名です。`text`型です。

`index_name`には`NULL`を指定できます。

`NormalizerNFKC100`のように`NormalizerAuto`以外のノーマライザーを使っている場合は、`index_name`を使うとよいです。この関数はデフォルトで`NormalizerAuto`ノーマライザーを使います。これにより意図しない結果になることがあります。

例です。

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (normalizer='NormalizerNFKC121');
```

これで`index_name`に`pgroonga_content_index`を指定できます。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('Reiwa: ㋿',
                                          ARRAY['令和'],
                                          'pgroonga_content_index');
--  pgroonga_match_positions_character 
-- ------------------------------------
--  {{7,1}}
-- (1 row)
```
{% endraw %}

`pgroonga_match_positions_character` returns an array of positions.

位置は「オフセット」と「長さ」で表現します。「オフセット」は先頭からキーワードが現れた位置までの文字数です。「長さ」はマッチしたテキストの文字数です。「長さ」はキーワードの長さと違うかもしれません。これはキーワードもマッチしたテキストも正規化されるからです。

## 使い方

少なくとも1つキーワードを指定しなければいけません。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('PGroonga is a PostgreSQL extension.',
                                          ARRAY['PostgreSQL']) AS match_positions_character;
--  match_positions_character 
-- ---------------------------
--  {{14,10}}
-- (1 row)
```
{% endraw %}

複数のキーワードを指定できます。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('PGroonga is a PostgreSQL extension.',
                                          ARRAY['Groonga', 'PostgreSQL']) AS match_positions_character;
--  match_positions_character 
-- ---------------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

[`pgroonga_query_extract_keywords`関数](pgroonga-query-extract-keywords.html)を使うとクエリーからキーワードを抽出できます。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('PGroonga is a PostgreSQL extension.',
                                          pgroonga_query_extract_keywords('Groonga PostgreSQL -extension')) AS match_positions_character;
--  match_positions_character 
-- ---------------------------
--  {{1,7},{14,10}}
-- (1 row)
```
{% endraw %}

文字は正規化されます。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('PGroonga + pglogical = replicatable!',
                                          ARRAY['Pg']) AS match_positions_character;
--  match_positions_character 
-- ---------------------------
--  {{0,2},{11,2}}
-- (1 row)
```
{% endraw %}

マルチバイト文字にも対応しています。

{% raw %}
```sql
SELECT pgroonga_match_positions_character('10㌖先にある100ｷﾛグラムの米',
                                          ARRAY['キロ']) AS match_positions_character;
--  match_positions_character 
-- ---------------------------
--  {{2,1},{10,2}}
-- (1 row)
```
{% endraw %}

PGroongaのインデックス名を指定するとノーマライザーをカスタマイズできます。

{% raw %}
```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_content_index
          ON memos
       USING pgroonga (content)
        WITH (normalizer='NormalizerNFKC121');

SELECT pgroonga_match_positions_character('Reiwa: ㋿',
                                          ARRAY['令和'],
                                          'pgroonga_content_index');
--  pgroonga_match_positions_character 
-- ------------------------------------
--  {{7,1}}
-- (1 row)
```
{% endraw %}

## 参考

  * [`pgroonga_match_positions_byte`関数][match-positions-byte]

  * [`pgroonga_snippet_html`関数](pgroonga-query-snippet-html.html)

  * [`pgroonga_highlight_html`関数](pgroonga-query-highlight-html.html)

  * [`pgroonga_query_extract_keywords`関数][query-extract-keywords]

[match-positions-byte]:pgroonga-match-positions-byte.html
[query-snippet-html]:pgroonga-query-snippet-html.html
[query-highlight-html]:pgroonga-query-highlight-html.html
[query-extract-keywords]:pgroonga-query-extract-keywords.html
