---
title: ビルド
---

# ビルド

このドキュメントは開発者としてPGroongaをビルドする方法を説明しています。たとえば、新しい機能を開発したりバグを直したりするような開発者が対象になります。

もし、カジュアルなPGroonga開発者になりたい場合は、このドキュメントよりも[カジュアル開発者としてビルド](build-casual.html)の方が適切です。

## ビルド環境のセットアップ

PostgreSQLもPGroonaもどちらもデバッグオプション付きでビルドすることをオススメします。

デバッグオプション付きで[Groongaもビルド][groonga-build]した方がよいです。そのためには、`cmake --preset=debug-maximum ...`を使えます。

[Groongaのパッケージ][groonga-install]を使う場合は、開発用パッケージをインストールする必要があります。Debian系のディストリビューションでは`libgroonga-dev`で、Red Hat系のディストリビューションでは`groonga-devel`です。

すべてのテストを実行するためには`token_fitlers/stem`というGroongaのプラグインをインストールする必要があります。`groonga-token-filter-stem`パッケージをインストールするとインストールできます。

## PostgreSQLのビルド方法

[PostgreSQLのサイト][postgresql-source-download]からソースをダウンロードします。以下はPostgreSQL {{ site.development_postgresql_version }}のソースをダウンロードして展開するコマンドラインです。

```bash
wget https://ftp.postgresql.org/pub/source/v{{ site.development_postgresql_version }}/postgresql-{{ site.development_postgresql_version }}.tar.bz2
tar xf postgresql-{{ site.development_postgresql_version }}.tar.bz2
```

`--buildtype=debug`引数付きで`meson setup`を実行します。これでデバッグビルドになります。`--prefix=/tmp/local`は指定してもしなくてもどちらでもよいです。

```bash
mseon setup \
  --buildtype=debug \
  --prefix=/tmp/local \
  postgresql-{{ site.development_postgresql_version }}.build \
  postgresql-{{ site.development_postgresql_version }}
```

PostgreSQLをビルドしてインストールします。

```bash
meson compile -C postgresql-{{ site.development_postgresql_version }}
meson install -C postgresql-{{ site.development_postgresql_version }}
```

PostgreSQLを初期化して実行します。

```bash
mkdir -p /tmp/local/var/lib
/tmp/local/bin/initdb \
  --locale C \
  --encoding UTF-8 \
  --set=enable_partitionwise_join=on \
  --set=max_prepared_transactions=1 \
  --set=random_page_cost=0 \
  -D /tmp/local/var/lib/postgresql
/tmp/local/bin/postgres -D /tmp/local/var/lib/postgresql
```

以下のワンライナーはPostgreSQL関連のすべてのデータをリセットするときに便利です。このワンライナーをシェルのヒストリーに入れておけば、すぐにこのワンライナーを再実行できます。

```bash
rm -rf /tmp/local/var/lib/postgresql && \
  mkdir -p /tmp/local/var/lib/postgresql &&
  /tmp/local/bin/initdb \
    --locale C \
    --encoding UTF-8 \
    --set=enable_partitionwise_join=on \
    --set=max_prepared_transactions=1 \
    --set=random_page_cost=0 \
    -D /tmp/local/var/lib/postgresql && \
 /tmp/local/bin/postgres -D /tmp/local/var/lib/postgresql
```

## フォークリポジトリーの準備

開発するために<https://github.com/pgroonga/pgroonga/>をフォークする必要があります。後でフォークしたリポジトリーからプルリクエストを作るかもしれません。GitHubのドキュメントも参照してください。

* <https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/working-with-forks>

* <https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork>

フォークしたリポジトリーをクローンするコマンドラインは次のとおりです。

```bash
git clone --recursive git@github.com:${YOUR_GITHUB_ACCOUNT}/pgroonga.git
cd pgroonga
```

## PGroongaをビルドしてテストを実行する方法

PGroongaをビルドしてPGroongaのテストを実行するには次のコマンドラインを使います。

```bash
HAVE_XXHASH=1 test/run-sql-test.sh
```

PGroongaのテストは2種類あります。

  * SQLベースのリグレッションテスト

  * SQLだけでは実装できない複雑なテスト

通常、前者だけを使います。`test/run-sql-test.sh`は前者用のテストランナーです。PGroongaをビルド・インストールしてSQLベースのリグレッションテストを実行します。

[テスト](test.html)も読んでください。

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:https://groonga.org/ja/docs/install/cmake.html

[groonga-install]:https://groonga.org/ja/docs/install.html
