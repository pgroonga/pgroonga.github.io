---
layout: ja
---

<div class="jumbotron">
  <h1>
    <img alt="{{ site.title }}"
         title="{{ site.title }}"
         src="/images/pgroonga-logo.png">
  </h1>
  <p>{{ site.description.ja }}</p>
  <p>最新版（<a href="news/#version-{{ site.pgroonga_version | replace:".", "-" }}">{{ site.pgroonga_version }}</a>）は{{ site.pgroonga_release_date }}にリリースされました。
  </p>
  <p>
    <a href="/tutorial/"
       class="btn btn-primary btn-lg"
       role="button">チュートリアルをやってみる</a>
  </p>
</div>

## PGroongaについて

PGroonga（ぴーじーるんが）はインデックスとして[Groonga](http://groonga.org/ja/)を使うPostgreSQLの拡張機能です。

PostgreSQLはアルファベットと数値だけを使った言語の全文検索だけをサポートしています。これは、日本語や中国語などはサポートしていないということです。PGroongaをPostgreSQLにインストールすると全言語対応の超高速全文検索機能を使えるようになります！

## ドキュメント

  * [おしらせ](news/): リリース情報
  * [概要](overview/): PGroongaについての説明
  * [インストール](install/): PGroongaのインストール方法
  * [チュートリアル](tutorial/): PGroongaの使い方を順に説明
  * [ハウツー](how-to/): 特定状況向けの有用な情報
  * [リファレンス](reference/): オプションや関数・演算子などの個々の機能の詳細な説明
  * [コミュニティー](community/): PGroongaのコミュニティーの紹介

## ライセンス

PGroongaのライセンスは[PostgreSQLライセンス](http://opensource.org/licenses/postgresql)です。PostgreSQLはBSDライセンス、MITライセンスと似たライセンスです

著作権者など詳細は[COPYING](https://github.com/pgroonga/pgroonga/blob/master/COPYING)を参照してください。

バンドルしているソフトウェアのライセンスは異なります。以下がバンドルしているソフトウェアのライセンス情報です。

  * [xxHash](https://github.com/Cyan4973/xxHash)
    * BSDライセンス
    * 著作権者: `Copyright (c) 2012-2014, Yann Collet`
    * 詳細: [`vendor/xxHash/LICENSE`](https://github.com/Cyan4973/xxHash/blob/master/LICENSE)

  * [Groonga](http://groonga.org/)（Windows用のパッケージにだけバンドルされている）
    * LGPL 2.1
    * 著作権者: `Copyright(C) 2009-2015 Brazil`
    * 詳細: [`vendor/groonga/COPYING`](https://github.com/groonga/groonga/blob/master/COPYING)

