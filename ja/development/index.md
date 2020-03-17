---
title: 開発
---

# 開発

このドキュメントではPGroongaの開発方法を説明します。

## ビルド

PostgreSQLもPGroonaもどちらもデバッグオプション付きでビルドすることをオススメします。

Groongaもデバッグオプション（Groongaの`configure`には`--enable-debug`オプションがある）で[ビルド][groonga-build]した方が便利なことが多いです。[Groongaのパッケージ][groonga-install]を使う場合は、開発用パッケージをインストールする必要があります。Debian系のディストリビューションでは`libgroonga-dev`で、Red Hat系のディストリビューションでは`groonga-devel`です。

すべてのテストを実行するためには`token_fitlers/stem`というGroongaのプラグインをインストールする必要があります。`groonga-token-filter-stem`パッケージをインストールするとインストールできます。

### PostgreSQLのビルド方法

[PostgreSQLのサイト][postgresql-source-download]からソースをダウンロードします。以下はPostgreSQL {{ site.development_postgresql_version }}のソースをダウンロードして展開するコマンドラインです。

```console
% wget https://ftp.postgresql.org/pub/source/v{{ site.development_postgresql_version }}/postgresql-{{ site.development_postgresql_version }}.tar.bz2
% tar xf postgresql-{{ site.development_postgresql_version }}.tar.bz2
% cd postgresql-{{ site.development_postgresql_version }}
```

`CFLAGS="-O0 -g3"`引数付きで`configure`を実行します。これでデバッグビルドになります。`--prefix=/tmp/local`は指定してもしなくてもどちらでもよいです。

```console
% ./configure CFLAGS="-O0 -g3" --prefix=/tmp/local
```

PostgreSQLをビルドしてインストールします。

```console
% make -j$(nproc) > /dev/null
% make install > /dev/null
```

PostgreSQLを初期化して実行します。

```console
% mkdir -p /tmp/local/var/lib
% /tmp/local/bin/initdb --locale C --encoding UTF-8 -D /tmp/local/var/lib/postgresql
% /tmp/local/bin/postgres -D /tmp/local/var/lib/postgresql
```

以下のワンライナーはPostgreSQL関連のすべてのデータをリセットするときに便利です。このワンライナーをシェルのヒストリーに入れておけば、すぐにこのワンライナーを再実行できます。

```console
% rm -rf /tmp/local/var/lib/postgresql && \
    mkdir -p /tmp/local/var/lib/postgresql &&
    /tmp/local/bin/initdb \
      --locale C \
      --encoding UTF-8 \
      -D /tmp/local/var/lib/postgresql && \
   /tmp/local/bin/postgres -D /tmp/local/var/lib/postgresql
```

### PGroongaのビルド・テスト方法

リリース版のPGroongaではなく最新のPGroongaを使うことをオススメします。以下は最新のPGroongaのソースをクローンするコマンドラインです。

```console
% git clone --rerursive git@github.com:pgroonga/pgroonga.git
% cd pgroonga
```

PGroongaのテストは2種類あります。

  * SQLベースのリグレッションテスト

  * RubyとSQLを使った[`pgroonga_check`][pgroonga-check]のテスト

通常、前者だけを使います。`test/run-sql-test.sh`は前者用のテストランナーです。このスクリプトはPGroongaをビルド・インストールし、続けてSQLベースのリグレッションテストも実行します。`PATH=/tmp/local/bin:$PATH`が必要なのはPostgreSQLを`--prefix=/tmp/local`オプションを指定してビルドしたからです。この場合は`pg_config`は`/tmp/local/bin`にあります。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh
```

## テスト

新しい機能を実装した時・バグを直した時は、リグレッションテストを作ります。

### 概要

リグレッションテストは`sql/`ディレクトリー以下にあります。例えば、`sql/full-text-search/text/single/match-v2/indexscan.sql`は次のケース用のテストです。

  * 全文検索

  * `text`型

  * [`&@`][match-v2]（マッチ演算子v2）

  * インデックススキャン

出力の期待値は`expected/`ディレクトリー以下にあります。ディレクトリー構造は`sql/`と同じですが、拡張子は`.out`になります。たとえば、`expected/full-text-search/text/single/match-v2/indexscan.out`となります。

### リグレッションテストの作成方法

新しいファイルを`sql/`以下に作り、SQLで作ったテストシナリオをそのファイルに書きます。それからこのファイルを次のように実行します。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

この新しく作ったテストは失敗します。`test/run-sql-test.sh`はこのテストシナリオの出力を表示します。出力が正しければ、出力をコピーして`expected/.../XXX.out`に貼ります。

`expected/.../XXX.out`を更新してテストがパスするようになったかを確認してください。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh sql/.../XXX.sql
```

## [リリース方法](release.html)

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:http://groonga.org/ja/docs/install/others.html

[groonga-install]:http://groonga.org/ja/docs/install.html

[pgroonga-check]:../reference/modules/pgroonga-check.html

[match-v2]:../reference/operators/match-v2.html
