---
title: Troubleshooting
---
# Troubleshooting

PGroongaの検索時の問題でよくある問題としては PGroongaのインデックスが正しくないことです。このトラブルシューティングではこれらの問題へのガイドを提供します。

次に続くQ&Aセクションは、このような問題の詳細について書かれています。

## Q: PGroongaのインデックスを作ったのですが、検索自体は遅いままです。

A: 検索が遅い時は、PostgreSQLでPGroongaのインデックスではなく、シーケンシャルサーチが使われていることが多いです。これを確認するにはクエリに`EXPLAIN ANALYZE`を付けて実行します。 

もし出力結果に"Seq Scan"が含まれている場合には、インデックスが使われていません。ここでのゴールは"Index Scan using pgrn_content_index"のようなインデックスが使われている状況が確認できることです。

テーブルの設定を確認し、PGRoongaのインデックスが正しくセットされていることを確認しましょう。

<details markdown="block">

<summary markdown="span">シーケンシャルサーチが実行されたかどうかを確認する</summary>
  
ここでは次のテーブルを例として用います。
  
ここでの例では確実にシーケンシャルサーチで検索している状態にしたいので、インデックスもプライマリーキーも設定していません。

```sql
CREATE TABLE memos (
  title text,
  content text
);

INSERT INTO memos VALUES ('PostgreSQL', 'PostgreSQL is an RDBMS.');
INSERT INTO memos VALUES ('Groonga', 'Groonga is a super-fast full-text search engine.');
INSERT INTO memos VALUES ('PGroonga', 'PGroonga is an extension that brings super-fast full-text search to PostgreSQL.');
```

ここでは次のクエリーを使って検証します。

```sql
SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
```

では、このクエリがシーケンシャルサーチを使用しているかどうか確認しましょう。

先述の通り、確認するためには`EXPLAIN ANALYZE`を使用します。

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                              QUERY PLAN                                              
-- -----------------------------------------------------------------------------------------------------
--  Seq Scan on memos  (cost=0.00..678.80 rows=1 width=64) (actual time=2.803..4.664 rows=2 loops=1)
--    Filter: (content &@~ 'PostgreSQL'::text)
--    Rows Removed by Filter: 1
--  Planning Time: 0.113 ms
--  Execution Time: 4.731 ms
-- (5 rows)
```

結果は上記の通りです。

シーケンシャルサーチの場合は、"Seq Scan"が表示されます。

ここでの目標は、この"Seq Scan"を下記のように"Index Scan using #{PGroonga index name}"に変えることです。

```sql
EXPLAIN ANALYZE SELECT * FROM memos WHERE content &@~ 'PostgreSQL';
--                                                           QUERY PLAN                                                          
-- ------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using pgrn_content_index on memos  (cost=0.00..4.02 rows=1 width=64) (actual time=0.778..0.782 rows=2 loops=1)
--    Index Cond: (content &@~ 'PostgreSQL'::text)
--  Planning Time: 0.835 ms
--  Execution Time: 1.002 ms
-- (4 rows)
```

</details>

