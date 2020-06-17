---
title: pgroonga_index_column_name 関数
upper_level: ../
---

# `pgroonga_index_column_name` 関数

## 概要

PGroongaのインデックスは、PGroongaのバックエンドで動作しているGroongaのデータベースとして管理されています。
この関数は、Groongaのデータベース上のPGroongaのインデックスの名前を出力します。

これは、 `object_inspect` コマンドを使ってインデックスの詳細を確認したい時に便利です。

通常、まず最初に `table_list` コマンドを使ってGroongaのデータベース上のテーブルの一覧を取得します。

```sql
SELECT jsonb_pretty(pgroonga_command('table_list')::jsonb);
```

このリストの中で、 `Lexicon` で始まるテーブルがインデックス用のテーブルです。
このテーブルの名前を使って、 `object_inspect` を実行することで、インデックスの情報を取得できます。

```sql
SELECT * FROM jsonb_each(((pgroonga_command('object_inspect Lexicon17072_0.index')::jsonb)->1->'value'));
```

しかし、この方法では、特定のインデックスを持つテーブルを特定することは困難です。
特に複数のPGroongaのインデックスがあるテーブルの場合、対象のインデックスを指定することは困難です。

`pgroonga_index_column_name` を使えば、特定のインデックスを持つテーブルを簡単に特定できます。`pgroonga_index_column_name` は引数に対象のインデックスを指定できるため、 `table_list` コマンドを実行して、多くのテーブルから対象を特定する必要がありません。

## 構文

この関数の構文は以下の通りです。:

```text
text pgroonga_index_column_name(pgroonga_index_name, column_name)
text pgroonga_index_column_name(pgroonga_index_name, column_index)
```

`pgroonga_index_name` は `text` 型の値です。 PGroongaのインデックス名を指定します。

第二引数には、以下のように二つのパターンがあります。

* `column_name` は、 `text` 型の値です。 対象のPGroongaのインデックス名を指定します。

* `column_index` は `int4` 型の値です。 対象のPGroongaのインデックスの位置を指定します。
位置は、 `0` から始まります。

## 使い方

インデックスの位置を指定する場合のサンプルのスキーマとデータは以下の通りです。:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);
CREATE INDEX pgroonga_index
          ON memos
       USING pgroonga (title, content, tag);
SELECT pgroonga_index_column_name('pgroonga_index', 2);

 pgroonga_index_column_name 
----------------------------
 Lexicon17765_2.index
(1 row)
```

インデックス名を指定する場合のサンプルのスキーマとデータは以下の通りです。:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);
CREATE INDEX pgroonga_index
          ON memos
       USING pgroonga (title, content, tag);
SELECT pgroonga_index_column_name('pgroonga_index', 'tag');

 pgroonga_index_column_name 
----------------------------
 Lexicon17765_2.index
(1 row)
```

`pgroonga_index_column_name` を使ってインデックスの情報を取得する場合のサンプルのスキーマとデータは以下の通りです。:

```sql
CREATE TABLE memos (
  id integer,
  title text,
  content text,
  tag text
);
CREATE INDEX pgroonga_index
          ON memos
       USING pgroonga (title, content, tag);
SELECT * FROM jsonb_each(
                          (
                            (
                              pgroonga_command(
                                'object_inspect',
                                ARRAY[
                                  'name', pgroonga_index_column_name('pgroonga_index', 'tag')
                                ]
                              )::jsonb
                            )->1->'value'
                          )
                        );
    key     |    value
------------+----------------------------------------------------------------------------------------------
 size       | "normal"
 type       | {"id": 263, "name": "Sources21220", "size": 4, "type": {"id": 48, "name": "table:hash_key"}}
 weight     | false
 section    | false
 position   | true
 statistics | {"max_section_id": 0, "n_array_segments": 0, "n_garbage_chunks": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "total_chunk_size": 0, "n_buffer_segments": 0, "n_garbage_segments": 0, "max_in_use_chunk_id": 0, "max_array_segment_id": 0, "n_unmanaged_segments": 0, "max_buffer_segment_id": 0, "max_n_physical_segments": 131072, "next_physical_segment_id": 0, "max_in_use_physical_segment_id": 0}
(6 rows)
```
