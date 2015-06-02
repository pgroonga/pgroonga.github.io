---
title: pgroonga.score function
layout: en
---

# `pgroonga.score` function

TODO

`pgroonga.score` function always returns `0` when full text search is performed by sequential scan not index scan.

スコアーが返るはずなのに`0`が返るときは次の2点を確認してください。

  * プライマリーキーのカラムがインデックス対象に含まれているか
  * インデックスを使って全文検索を実行しているか


現時点では適合度は「キーワードを含んでいる数」になります。Groongaには
キーワードや検索対象カラム毎に重みをつける機能や適合度の計算方法をカス
タマイズする機能があります。しかし、PostgreSQLらしく指定するAPIを思い
ついていないためPGroongaから使うことはできません。
