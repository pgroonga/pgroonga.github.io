---
title: ソースからインストール
---

# ソースからインストール

このドキュメントはソースからPGroongaをビルドしてインストールする方法を説明します。

ビルド・インストール方法はWindowsとWindows以外のプラットフォームで違います。このドキュメントではそれぞれ別々に説明します。

  * [Windows以外のプラットフォーム](#non-windows)

  * [Windows](#windows)

## Windows以外のプラットフォーム {#non-windows}

PostgreSQLをインストールします。

[Groongaをインストール](http://groonga.org/ja/docs/install.html)します。パッケージを使うことをおすすめします。パッケージを使ってGroongaをインストールする場合は次のパッケージをインストールしてください。

  * `groonga-devel`: CentOSの場合
  * `libgroonga-dev`: Debian/GNU LinuxとUbuntuの場合

PGroongaのソースを展開します。

```text
% wget http://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
% tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
% cd pgroonga-{{ site.pgroonga_version }}
```

参考：未リリースの最新版を使いたい場合は次のようにしてください。

```text
% git clone --recursive https://github.com/pgroonga/pgroonga.git
% cd pgroonga
```

PGroongaをビルドします。

```text
% make
```

エラーが発生した場合は次のことを確認してください。

  * `PATH`環境変数内のパスに`pg_config`コマンドが存在していること。
  * `pkg-config --list-all`に`groonga`が含まれていること。

もし、`pg_config`コマンドが存在しない場合、PostgreSQLの開発用パッケージをインストールし忘れているかもしれません。

もし、`pkg-config --list-all`に`groonga`が含まれていない場合、Groongaの開発用パッケージをインストールし忘れているかもしれません。あるいは、`groonga.pc`が標準的なディレクトリーではないディレクトリーにインストールされているのかもしれません。その場合は`PKG_CONFIG_PATH`環境変数を使ってください。

以下は`--prefix=/usr/local`オプション付きでGroongaをインストールした場合の例です。

```text
% PKG_CONFIG_PATH=/usr/local/lib/pkg-config make
```

PGroongaをインストールします。

```text
% sudo make install
```

データベースを作成します。

```text
% psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
% psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

## Windows {#windows}

ソースからPGroongaをビルド・インストールするために必要なソフトウェアは次の通りです。これらをインストールしてください。

PostgreSQL（インストーラーバージョンでもzipバージョンでもどちらでも構いません。）

    * [インストーラーバージョン](http://www.enterprisedb.com/products-services-training/pgdownload)

    * [zipバージョン](http://www.enterprisedb.com/products-services-training/pgbindownload)

  * [Microsoft Visual Studio Express 2013 for Windows Desktop](https://www.visualstudio.com/downloads/#d-2013-express)

  * [CMake](http://www.cmake.org/)

packages.groonga.orgからWindows用のPGroongaソースアーカイブをダウンロードしてください。Windows用のソースアーカイブはzipファイルです。Windows用のソースアーカイブにはGroongaがバンドルされています。

  * [pgroonga-{{ site.pgroonga_version }}](http://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.zip)

ダウンロードしたソースアーカイブを展開し、ソースフォルダーに移動してください。

```text
> cd c:\Users\%USERNAME%\Downloads\pgroonga-{{ site.pgroonga_version }}
```

`cmake`のビルドオプションを指定します。64bitバージョンのPostgreSQL用にPGroongaをビルドするためのコマンドラインは次の通りです。もし、32bitバージョンのPostgreSQL用にビルドしたい場合は、代わりに`-G "Visual Studio 12 2013"`パラメーターを使ってください。

```text
pgroonga-{{ site.pgroonga_version }}> cmake . -G "Visual Studio 12 2013 Win64" -DCMAKE_INSTALL_PREFIX=%POSTGRESQL_INSTALL_FOLDER%
```

インストーラーを使ってPostgreSQLをインストールした場合は`%POSTGRESQL_INSTALL_FOLDER%`は`C:\Program Files\PostgreSQL\%POSTGRESQL_VERSION%`になります。

zipバージョンのPostgreSQLをインストールした場合は`%POSTGRESQL_INSTALL_FOLDER%`は`%PostgreSQLのzipを展開したフォルダー%\pgsql`になります。

PGroongaをビルドします。

```text
pgroonga-{{ site.pgroonga_version }}> cmake --build . --config Release
```

PGroongaをインストールします。管理者権限が必要かもしれません。たとえば、インストーラーを使ってPostgreSQLをインストールした場合は管理者権限が必要でしょう。

```text
pgroonga-{{ site.pgroonga_version }}> cmake --build . --config Release --target Install
```

データベースを作成します。

```text
postgres=# CREATE DATABASE pgroonga_test;
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを作るべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
