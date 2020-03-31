---
title: ビルド
---

# ビルド

PostgreSQLもPGroonaもどちらもデバッグオプション付きでビルドすることをオススメします。

Groongaもデバッグオプション（Groongaの`configure`には`--enable-debug`オプションがある）で[ビルド][groonga-build]した方が便利なことが多いです。[Groongaのパッケージ][groonga-install]を使う場合は、開発用パッケージをインストールする必要があります。Debian系のディストリビューションでは`libgroonga-dev`で、Red Hat系のディストリビューションでは`groonga-devel`です。

すべてのテストを実行するためには`token_fitlers/stem`というGroongaのプラグインをインストールする必要があります。`groonga-token-filter-stem`パッケージをインストールするとインストールできます。

## PostgreSQLのビルド方法

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

## PGroongaのビルド・テスト方法

リリース版のPGroongaではなく最新のPGroongaを使うことをオススメします。以下は最新のPGroongaのソースをクローンするコマンドラインです。

```console
% git clone --recursive git@github.com:pgroonga/pgroonga.git
% cd pgroonga
```

PGroongaのテストは2種類あります。

  * SQLベースのリグレッションテスト

  * RubyとSQLを使った[`pgroonga_check`][pgroonga-check]のテスト

通常、前者だけを使います。`test/run-sql-test.sh`は前者用のテストランナーです。このスクリプトはPGroongaをビルド・インストールし、続けてSQLベースのリグレッションテストも実行します。`PATH=/tmp/local/bin:$PATH`が必要なのはPostgreSQLを`--prefix=/tmp/local`オプションを指定してビルドしたからです。この場合は`pg_config`は`/tmp/local/bin`にあります。

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh
```

[テスト](test.html)も読んでください。

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:https://groonga.org/docs/install/others.html

[groonga-install]:https://groonga.org/docs/install.html

[pgroonga-check]:../reference/modules/pgroonga-check.html
