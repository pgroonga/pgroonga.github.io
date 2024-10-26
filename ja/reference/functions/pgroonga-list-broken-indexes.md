---
title: pgroonga_list_broken_indexes 関数
upper_level: ../
---

# `pgroonga_list_broken_indexes` 関数

3.2.1で追加

## 概要

`pgroonga_list_broken_indexes` 関数はPGroongaインデックスで破損の可能性があるインデックスを表示します。

データの更新中にクラッシュするとPGroongaのインデックスが破損している可能性が高いです。そのとき、以下の2つの状態になることが多いため、その状態をを破損とみなし検出します。

1. ロックが残留する

2. あるべきファイルが存在しない

簡易的なチェックのため破損していても検出できない場合があることに注意してください。

## 構文

この関数の構文は次の通りです。

```text
SETOF text pgroonga_list_broken_indexes()
```

この関数は、PGroongaインデックスで破損の可能性があるインデックスを取得します。

以下のようなレコードを返します。

```sql
 pgroonga_list_broken_indexes 
------------------------------
 pgrn_memos_index
```

## 使い方

```sql
SELECT pgroonga_list_broken_indexes();
```

## 実行例

以下はサンプルスキーマです。

```sql
CREATE TABLE memos (
  content text
);
CREATE INDEX pgrn_memos_index ON memos USING PGroonga (content);
```

破損の可能性なし。

```sql
SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes
------------------------------
(0 rows)
```

破損の可能性あり。（ロックが残留）

```sql
SELECT pgroonga_command(
  'lock_acquire',
  ARRAY['target_name', pgroonga_table_name('pgrn_memos_index')]
);
                 pgroonga_command
---------------------------------------------------
 [[0,1716796614.02342,6.723403930664062e-05],true]
(1 row)

SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes 
------------------------------
 pgrn_memos_index
(1 row)
```

破損の可能性なし。（ロックを解放済）

```sql
SELECT pgroonga_command(
  'lock_release',
  ARRAY['target_name', pgroonga_table_name('pgrn_memos_index')]
);
                  pgroonga_command
----------------------------------------------------
 [[0,1716796558.739785,4.720687866210938e-05],true]
(1 row)

SELECT pgroonga_list_broken_indexes();
 pgroonga_list_broken_indexes 
------------------------------
(0 rows)
```

## 参考

  * [`pgroonga_command`関数][command]

  * [`pgroonga_table_name`関数][table-name]

[command]:pgroonga-command.html

[table-name]:pgroonga-table-name.html
