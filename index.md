---
layout: en
---
<div class="jumbotron">
  <h1>
    <img alt="{{ site.title }}" title="{{ site.title }}" src="/images/pgroonga-logo.png">
  </h1>
  <p>{{ site.description }}</p>
  <p>
    <a href="/install/" class="btn btn-primary btn-lg" role="button">Use the latest version ({{ site.pgroonga_version }})</a>
  </p>
</div>

## リリース情報

[news.md](https://github.com/pgroonga/pgroonga/blob/master/news.md)を参照してください。

## PGroongaとは

PGroonga（ぴーじーるんが）はPostgreSQLからインデックスとして
[Groonga](http://groonga.org/ja/)を使うための拡張機能です。

PostgreSQLは標準では日本語で全文検索できませんが、PGroongaを使うと日本
語で高速に全文検索できるようになります。

## ドキュメント

 * [Overview](overview/) : PGroongaの概要です。
 * [Install](install/) : PGroongaのインストール手順の説明です。
 * [Tutorial](tutorial/) : PGroongaの使い方を実例を通して解説します。

## ライセンス

ライセンスはBSDライセンスやMITライセンスと類似の
[PostgreSQLライセンス](http://opensource.org/licenses/postgresql)です。

著作権保持者などの詳細は[COPYING](https://github.com/pgroonga/pgroonga/blob/master/COPYING)ファイルを参照してください。

## TODO

  * 実装
    * WAL対応
    * スコアー対応
    * COLLATE対応（今は必ずGroongaのNormalizerAutoを使っている）
  * ドキュメント
    * 英語で書く
    * サイトを用意する

## 感謝

  * 板垣さん
    * PGroongaは板垣さんが開発した[textsearch_groonga](http://textsearch-ja.projects.pgfoundry.org/textsearch_groonga.html)をベースにしています。
