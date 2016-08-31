---
title: pgroonga.flush関数
---

# `pgroonga.flush`関数

## 概要

`pgroonga.flush`関数はメモリー上にだけある変更を確実にディスクに書き込みます。この処理は自動的に行われるので、通常、この関数を使う必要はありません。しかし、クラッシュ・強制終了によるPGroongaインデックスの破損を防ぎたい場合はこの関数を使う必要があるかもしれません。

通常、ユーザーはサーバーを強制終了してはいけません。しかし、いくつか強制終了してしまうケースがあります。たとえば、Windowsアップデートにより意図せずにWindowsサーバーが再起動することがあるかもしれません。

もし、PGroongaを使っているPostgreSQLが強制終了したらメモリー上にだけある変更が失われるかもしれません。強制終了の前に`pgroonga.flush`関数を呼べばメモリー上にだけある変更がなくなります。つまり、ユーザーがPGroongaを使っているPostgreSQLを強制終了してもPGroongaのインデックスは壊れないということです。

もし、メモリー上にだけある変更が多い場合、`pgroonga.flush`の実行時間が長くなるかもしれません。これは使用しているディスクの書き込み性能に依存します。

## 構文

この関数の構文は次の通りです。

```text
bool pgroonga.flush(pgroonga_index_name)
```

`pgroonga_index_name`は`text`型の値です。フラッシュ対象のインデックス名です。このインデックスは`USING pgroonga`付きで作成してある必要があります。

`pgroonga.flush`は常に`true`を返します。なぜなら、もし`pgroonga.flush`が失敗したら値を返すのではなくエラーになるからです。

## 使い方

以下はサンプルのスキーマとデータです。このスキーマでは、検索対象のデータと出力対象のデータはどちらもインデックス対象のカラムです。

```sql
CREATE TABLE terms (
  id integer,
  title text,
  content text
);

CREATE INDEX pgroonga_terms_index
          ON terms
       USING pgroonga (title, content);
```

以下のように`pgroonga.flush`を呼び出すことでメモリー上にだけある`pgroonga_terms_index`関連の変更をディスクに書き出すことができます。

```sql
SELECT pgroonga.flush('pgroonga_terms_index');
--  flush 
-- -------
--  t
-- (1 row)
```

存在しないインデックス名を指定すると`pgroonga.flush`はエラーになります。

```sql
SELECT pgroonga.flush('nonexistent');
-- ERROR:  relation "nonexistent" does not exist
```
