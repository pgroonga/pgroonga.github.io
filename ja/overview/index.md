---
title: 概要
layout: ja
---

# 概要

PGroongaはPostgreSQLの拡張機能です。PGroongaは[Groonga](http://groonga.org/ja/)を使った新しいインデックスアクセスメソッドを提供します。

Groongaは組み込み可能な超高速全文検索エンジンです。GroongaはMySQLにも組み込めます。[Mroonga](http://mroonga.org/ja/)はGroongaベースのストレージエンジンです。Groongaはスタンドアローンの検索エンジンとしても使えます。 

PostgreSQLはアルファベットと数値だけを使った言語の全文検索だけをサポートしています。これは、日本語や中国語などはサポートしていないということです。PGroongaをPostgreSQLにインストールすると全言語対応の超高速全文検索機能を使えるようになります！

さらに、PGroongaはJSON内のすべてのテキスト値に対する全文検索もサポートしています。これは他にはない機能です。組み込みのPostgreSQLの機能でも[JsQuery](https://github.com/postgrespro/jsquery)でもサポートしていません。

## 関連する拡張機能

あらゆる言語をサポートした全文検索を実現するための拡張機能がいくつかあります。

  * [pg_trgm](http://www.postgresql.jp/document/{{ site.postgresql_short_version }}/html/pgtrgm.html)
    * PostgreSQLにバンドルされていますが、デフォルトではインストールされていません。
    * あらゆる言語に対応するためにはpg\_trgmのソースコードを変更する必要があります。

  * [pg_bigm](http://pgbigm.osdn.jp/)
    * ソースコードを変更しなくてもあらゆる言語をサポートした全文検索を実現できます。
    * 誤検出を防ぐために[Recheck](http://pgbigm.osdn.jp/pg_bigm-1-1.html#enable_recheck)をする必要があります。
    * Recheckはヒット数が多くなるほど遅くなります。なぜならRecheckはインデックスを使った検索でマッチしたレコードに対してシーケンシャルサーチをするからです。
    * Recheckを無効にすると誤検出したレコードも返ってくる可能性があります。

PGroongaはソースコードを変更しなくてもあらゆる言語をサポートした全文検索を実現できます。

PGroongaはRecheckなしで動きます。インデックスを使った検索で誤検出をしないからです。そのため、PGroongaはヒット数が多くなる場合でも高速です。

PGroongaはクラッシュリカバリーとストリーミングレプリケーションをサポートしてません。なぜならPGroongaはWALをサポートしていないからです。どうしてWALをサポートしていないのかというと、PostgreSQLには拡張機能がWALをサポートするAPIがないからです。PostgreSQLがそのようなAPIを提供するようになったらPGroongaもWALをサポートする予定です。

参考：pg\_trgmとpg\_bigmはWALをサポートしています。正確に言うと、pg\_trgmとpg\_bigmが使っているGINとGiSTがWALをサポートしています。

## 歴史

PGroongaは[textsearch_groonga](http://textsearch-ja.projects.pgfoundry.org/textsearch_groonga.html)をベースにしています。textsearch\_groongaは板垣貴裕さんが開発しました。感謝します。

## 次のステップ

使ってみたくなりましたか？PGroongaを[インストール](../install/)して[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
