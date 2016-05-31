---
title: PGroonga対GiST・GIN
---

# PGroonga対GiST・GIN

PostgreSQLは組み込みのインデックスとしてGiSTとGINを提供しています。これらを使って英語のようにアルファベットと数字だけからなる言語用の全文検索を実現することができます。しかし、日本語や中国語などのような言語用の全文検索は実現することはできません。

PGroongaの重要な機能はすべての言語に対する全文検索機能です。PGroongaの機能はそれだけではありません。PGroongaは等価条件・比較条件で使える一般的な用途向けのインデックス機能も提供しています。PGroongaはGiST・GINより多くの機能を提供しています。そのため、GiST・GINの代わりにPGroongaを使うことができます。

このドキュメントはPGroonga・GiST・GINの違いを説明します。

## 特徴

[PostgreSQLのドキュメントはGiSTとGINの特徴を説明](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/textsearch-indexes.html)しています。手短にまとめると次の通りです。GiSTの検索はGINよりも遅いですが、GiSTの更新はGINよりも速いです。GINはGiSTよりも多くのディスク領域を使います。

PGroongaの検索はGINよりも速く、更新はGiSTよりも速いです。しかし、PGroongaはGIN・GiSTよりも多くのディスク領域を使います。

これらの特徴をまとめたものが以下の表です。

インデックス | 検索       | 更新      | ディスク使用量
----------- | ---------- | --------- | -------------
GIN         | 速い       | 遅い       | 多い
GiST        | 遅い       | 速い       | 少ない
PGroonga    | もっと速い | もっと速い | もっと多い

## ベンチマーク

このセクションはサンプルデータを使ってこれらの特徴を示します。

TODO
