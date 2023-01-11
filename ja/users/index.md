---
title: ユーザー
---

# ユーザー

以下はPGroongaユーザーです。

## Supabase {#supabase}

Supabaseは、Firebaseに代わるオープンソースのサービスです。PostgreSQLデータベース、認証システム、API機能、エッジファンクション、リアルタイムサブスクリプションやストレージなど、開発者がプロダクトを作るのに必要なバックエンドの全ての機能を提供します。PosgresSQLはSupabaseの中核をなしており、PGroongaを含めて40以上の拡張機能とともにネイティブに動作しています。

[https://supabase.com/blog/launch-week-6-community-day](https://supabase.com/blog/launch-week-6-community-day)

PGroongaはマネージドサービスでは使用できませんでしたが、Supabaseを利用することでマネージドなPostgreSQLでも高速な全言語対応の全文検索ができます！
Supabaseは無料のサービスプランを提供しています。PostgreSQLの運用が負担でPGroongaの使用をためらっていた人は、SupabaseでPGroongaを使ってみてください！

その他のプランやより詳しい情報は、[Supabaseのウェブサイト](https://supabase.com/pricing)を見てください。 

SupabaseにPGroongaを組み込んだのは、PGroongaの機能が日本を含む多くの言語を扱うお客さんに役立つためです。

また、PGroongaがPostgreSQL Licenseで提供されているソフトウェアであるという点に魅力を感じています。Supabaseでは、PostgreSQL LicenseやBSD License、MIT Licenseのソフトウェアを採用してサービスを提供しオープンソースソフトウェアへ貢献しているためです。

また、Supabaseではオープンソースソフトウェアのエコシステムの概念を実践して、PGroongaを含めた様々なオープンソースソフトウェアに対しての[Open Collective](https://opencollective.com/)というサービスを使っての資金サポートもしています。

* [Supabase Open Collective Page](https://opencollective.com/supabase)
* [PGroonga Open Collective Page](https://opencollective.com/pgroonga)

## Zulip {#zulip}

[Zulip](https://zulip.org/)はパワフルなオープンソースのグループチャットアプリケーションです。全言語対応の全文検索機能を実現するためにPGroongaを使っています。なぜなら、[PostgreSQL組み込みの全文検索機能]({{ site.postgresql_doc_base_url.ja }}/textsearch.html)は同時に1つの言語しかサポートできないからです。PGroongaは同時にすべての言語をサポートできます。

## waja {#waja}

ECサイト[waja](https://www.waja.co.jp/)のキーワード検索エンジンに採用しました。

PGroongaを採用した主な理由は次の通りです。

  * 既存の検索処理と整合性を取りやすい

  * インデックスの追加のみで全文検索機能を付与できる

  * 十分に高速である

同義語検索、オートコンプリート機能も備えており、運用でデータベースをメンテナンスすることで機能改善する作りになっています。

[開発者のブログ](https://www.waja.co.jp/corp/6359)も読んでみてください。

## トップスタジオの実績紹介検索 {#topstudio}

当社[株式会社トップスタジオ](https://www.topstudio.co.jp/)は、各出版社さまの刊行物の制作（翻訳・執筆・編集・校閲・デザイン・DTPなど）をお手伝いする制作プロダクションです。

当社のこれまでの制作物を[実績紹介](https://www.topstudio.co.jp/books/)ページでひっそりと公開しているのですが、以前よりPostgreSQLで蓄積はしていたものの、検索機能は設けていませんでした。

「どのような書籍を当社が制作しているのか来訪者さまが探しやすいよう、検索を付けたい」という営業部門からの要望を受けて、検索手法について検討しました。もちろん単純なSQL LIKE句やPostgreSQLの全文検索であるtsqueryもあるのですが、検索文字と格納文字列の正規化に頭を悩ませたり、別途形態素解析のような大掛かりなものの導入が必要になったりします。

その点、PGroongaは、インストールして拡張機能を有効化するだけで、至極簡単にセットアップできます。もともとDebian GNU/Linuxでサービスのシステムを組んでいたので、ガイドの「[Debian GNU/Linuxにインストール][install-debian]」どおりにパッケージをインストールするだけで済みました。

スペースで区切った複数単語を羅列することによる検索絞り込みというのは、もはやコモンの知識でしょう。PGroongaの検索機能でも`&@~`演算子でスペース区切りがAND検索扱いになるので、当初はこの利用を考えていました。

ただ、`&@~`は高機能な[クエリー構文][groonga-query-syntax]を使うもので、内部用であるならともかく、AND検索だけで十分な一般の来訪者さま向けにはやりすぎな印象があります。あまりにいろいろな機能がそのまま使えてしまうと、「SQLインジェクションされてますよ」という親切なご忠告を受けそうな気がしました。

そのため、せっかくの高機能`&@~`演算子ですがそれは見送って、検索文字列をシンプルに分割し、単一検索の`&@`演算子によるマッチをANDで結合したSQLステートメントを構成して実行するようにしています。たいした工夫でもないですが、分割の文字列ルールは単純なスペース文字以外に適当に入力してもANDヒットするよう、`/[\s　,，.．・。、「」『』（）]+/`としてみました。

なお、実績紹介の内部データにはほかにも「Windows」「Linux」「オープンソース」「機械学習」といった書籍の内容に関するメタ情報タグも実は格納しているのですが、それらまで検索対象に含めてテストしてみると、来訪者さまが探したいものが薄まってしまい、希望のものでないもののほうが出やすくなってしまうという残念な結果となりました。とはいえ、登録担当者が付けているせっかくのタグをうまく使いたいので、PGroongaのスコアー機能（[チュートリアルの「スコアー機能」][tutorial-score]参照）と表示の工夫で、いつか改良を試みたいと考えています。

## （サービス名を教えてください）

（サービスの説明、どのようにPGroongaを使っているか、どうしてPGroongaを選んだかを教えてください。）

↑のことを [https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md](https://github.com/pgroonga/pgroonga.github.io/edit/master/users/index.md) で書いて教えてください。英語のページですが日本語で書いても構いません。

[install-debian]: ../install/debian.html

[groonga-query-syntax]: https://groonga.org/ja/docs/reference/grn_expr/query_syntax.html

[tutorial-score]:../tutorial/#score
