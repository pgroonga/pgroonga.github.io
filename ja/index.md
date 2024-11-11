---
title: none
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
    <a href="tutorial/"
       class="btn btn-primary btn-lg"
       role="button">チュートリアルをやってみる</a>
    <a href="install/"
       class="btn btn-primary btn-lg"
       role="button">インストール</a>
  </p>
</div>

## PGroongaについて {#about}

PGroonga（ぴーじーるんが）はインデックスとして[Groonga](http://groonga.org/ja/)を使うPostgreSQLの拡張機能です。

PostgreSQLはアルファベットと数値だけを使った言語の全文検索だけをサポートしています。これは、日本語や中国語などはサポートしていないということです。PGroongaをPostgreSQLにインストールするとゼロETLで全言語対応の超高速全文検索機能を使えるようになります！

## ドキュメント {#documentations}

  * [おしらせ](news/): リリース情報。

  * [概要](overview/): PGroongaについての説明。

  * [インストール](install/): PGroongaのインストール方法。

  * [アップグレード](upgrade/): PGroongaのアップグレード方法。

  * [アンインストール](uninstall/): PGroongaのアンインストール方法。

  * [チュートリアル](tutorial/): PGroongaの使い方を順に説明。

  * [FAQ](faq/): よくある質問。

  * [ハウツー](how-to/): 特定用途向けの有用な情報。

  * [リファレンス](reference/): オプションや関数・演算子などの個々の機能の詳細な説明。

  * [トラブルシューティング](troubleshooting/): 期待通りに動かない場合の参考情報。

  * [コミュニティー](community/): PGroongaのコミュニティーの紹介。

  * [ユーザー](users/): PGroongaユーザー。

  * [開発](development/): PGroongaの開発方法の説明。

## ライセンス {#license}

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

  * [MeCab](http://taku910.github.io/mecab/)（Windows用のパッケージにだけバンドルされている）
    * GPL、LGPLまたはBSDライセンス
    * 著作権者: `Taku Kudo <taku@chasen.org> and Nippon Telegraph and Telephone Corporation`
    * 詳細: [`vendor/groonga/vendor/mecab-0.996/COPYING`](https://github.com/taku910/mecab/blob/master/mecab/COPYING)

  * [NAIST Japanese Dictionary](https://osdn.jp/projects/naist-jdic/)（Windows用のパッケージにだけバンドルされている）
    * 三条項BSDライセンス
    * 著作権者: `Copyright (c) 2009, Nara Institute of Science and Technology, Japan`
    * 詳細: `vendor/groonga/vendor/mecab-naist-jdic-0.6.3b-20111013/COPYING`

  * [LZ4](http://www.lz4.org/)（Windows用のパッケージにだけバンドルされている）
    * ライブラリーは二条項BSDライセンス
    * プログラムはGPLv2+
    * 著作権者: `Copyright (c) 2011-2015, Yann Collet`
    * ライブラリーのライセンス詳細: `vendor/groonga/vendor/lz4-r131/lib/LICENSE`
    * プログラムのライセンス詳細: `vendor/groonga/vendor/lz4-r131/programs/COPYING`

  * [msgpack-c](https://github.com/msgpack/msgpack-c)（Windows用のパッケージにだけバンドルされている）
    * Boost Software License Version 1.0
    * 著作権者: `Copyright (C) 2008-2015 FURUHASHI Sadayuki`
    * 詳細: [`vendor/groonga/vendor/msgpack-1.4.1/LICENSE_1_0.txt`](https://github.com/msgpack/msgpack-c/blob/master/LICENSE_1_0.txt)
