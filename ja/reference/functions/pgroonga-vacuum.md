---
title: pgroonga_vacuum関数
upper_level: ../
---

# `pgroonga_vacuum`関数

## 概要

`pgroonga_vacuum`関数は内部的に不要になったGroongaのテーブル・カラム・レコードを削除します。PGroongaのものではなくGroongaのものであることに注意してください。通常、この関数を呼ぶ必要はありません。 なぜなら`VACUUM`時に同等の処理を実行するからです。

次のケースのときはこの関数を呼ぶ必要があります。

  * すべてのPGroongaのインデックスを削除したとき。PGroongaのインデックスがないと`VACUUM`時に同等の処理を実行できません。

  * ストリーミングレプリケーションを使っているとき。スレーブ上でだけこの関数を実行する必要があります。なぜなら、スレーブでは`VACUUM`が実行されないからです。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga_vacuum()
```

常に`true`を返します。処理中に問題があった場合は、エラーが発生します。

## 使い方

以下はサンプルスキーマです。

```sql
CREATE TABLE memos (
  content text
);

CREATE INDEX pgroonga_index ON memos USING PGroonga (content);
```

現在の内部的に使っているGroongaのテーブル名を保存します。`\gset`と`\echo`は`psql`のメタコマンドです。

```sql
SELECT pgroonga_table_name('pgroonga_index')
\gset old_
\echo :old_pgroonga_table_name
-- Sources17058
```

`REINDEX`を実行すると現在の内部的なGroongaのテーブルが変わります。

```sql
REINDEX INDEX pgroonga_index;
SELECT pgroonga_table_name('pgroonga_index');
--  pgroonga_table_name 
-- ---------------------
--  Sources17059
-- (1 row)
```

`VACUUM`を実行するまでは古い内部的なGroongaのテーブルはまだ存在します。

```sql
SELECT pgroonga_command('object_exist',
                        ARRAY[
                          'name', :'old_pgroonga_table_name'
                        ])::json->>1;
--  ?column? 
-- ----------
--  true
-- (1 row)
```

`pgroonga_vacuum()`を呼ぶと古い内部的なGroongaのテーブルを削除できます。

```sql
SELECT pgroonga_vacuum();
--  pgroonga_vacuum 
-- -----------------
--  t
-- (1 row)
SELECT pgroonga_command('object_exist',
                        ARRAY[
                          'name', :'old_pgroonga_table_name'
                        ])::json->>1;
--  ?column? 
-- ----------
--  false
-- (1 row)
```
