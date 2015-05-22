---
title: Overview
layout: en
---

## 概要

PGroongaはPostgreSQLからインデックスとして
[Groonga](http://groonga.org/ja/)を使うための拡張機能です。

PostgreSQLは標準では日本語で全文検索できませんが、PGroongaを使うと日本
語で高速に全文検索できるようになります。日本語で全文検索機能を実現する
ための類似の拡張機能は次のものがあります。

  * [pg_trgm](https://www.postgresql.jp/document/9.3/html/pgtrgm.html)
    * PostgreSQLに付属しているがデフォルトではインストールされない。
    * 日本語に対応させるにはソースコードを変更する必要がある。
  * [pg_bigm](http://pgbigm.sourceforge.jp/)
    * ソースコードを変更しなくても日本語に対応している。
    * 正確な全文検索機能を使うには
      [Recheck機能](http://pgbigm.sourceforge.jp/pg_bigm-1-1.html#enable_recheck)
      を有効にする必要がある。
    * Recheck機能を有効にするとインデックスを使った検索をしてから、イ
      ンデックスを使って見つかったレコードに対してシーケンシャルに検索
      をするのでインデックスを使った検索でのヒット件数が多くなると遅く
      なりやすい。
    * Recheck機能を無効にするとキーワードが含まれていないレコードもヒッ
      トする可能性がある。

PGroongaはpg\_trgmのようにソースコードを変更しなくても日本語に対応して
います。

PGroongaはpg\_bigmのようにRecheck機能を使わなくてもインデックスを使っ
た検索だけで正確な検索結果を返せます。そのため、インデックスを使った検
索でヒット件数が多くてもpg\_bigmほど遅くなりません。（仕組みの上は。要
ベンチマーク。協力者募集。）

ただし、PGroongaは現時点ではWALに対応していない(*)ためクラッシュリカバ
リー機能やレプリケーションに対応していません。（pg\_trgmとpg\_bigmは対
応しています。正確に言うとpg\_trgmとpg\_bigmが対応しているわけではなく、
pg\_trgmとpg\_bigmが使っているGINやGiSTが対応しています。）

(*) PostgreSQLは拡張機能として実装したインデックスがWALに対応するため
のAPIを提供していません。PostgreSQL本体がそんなAPIを提供したらWALに対
応する予定です。

## 次のステップ

[チュートリアル](../tutorial/) を試してみてください。PGroongaのことをもっとよく知ることができます。
