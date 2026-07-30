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

```console
$ wget https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
$ tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
$ cd pgroonga-{{ site.pgroonga_version }}
```

参考：未リリースの最新版を使いたい場合は次のようにしてください。

```console
$ git clone --recursive https://github.com/pgroonga/pgroonga.git
$ cd pgroonga
```

[Meson](https://mesonbuild.com/)と[Ninja](https://ninja-build.org/)を使って、PGroongaをビルドしてインストールします。

```console
$ meson setup build
$ meson compile -C build
$ sudo meson install -C build
```

`pg_config`コマンドが`PATH`環境変数に含まれていない場合は、`pg_config`オプションで明示的に指定してください。

```console
$ meson setup build -Dpg_config=/path/to/pg_config
```

エラーが発生した場合は次のことを確認してください。

  * `meson`と`ninja`がインストール済であること。

  * `PATH`環境変数内のパスに`pg_config`コマンドが存在しているか、`pg_config`で正しいパスを指定していること。

  * `pkg-config --list-all`に`groonga`が含まれていること。

もし、`pg_config`コマンドが存在しない場合、PostgreSQLの開発用パッケージをインストールし忘れているかもしれません。

もし、`pkg-config --list-all`に`groonga`が含まれていない場合、Groongaの開発用パッケージをインストールし忘れているかもしれません。あるいは、`groonga.pc`が標準的なディレクトリーではないディレクトリーにインストールされているのかもしれません。その場合は`PKG_CONFIG_PATH`環境変数を使ってください。

以下は`--prefix=/usr/local`オプション付きでGroongaをインストールした場合の例です。

```console
$ PKG_CONFIG_PATH=/usr/local/lib/pkgconfig meson setup build
```

もし、SELinuxを使っているなら、ポリシーパッケージ(.pp)を作成し、インストールしなければなりません。PGroongaは、 `<data dir>/pgrn*` ファイルをメモリー内にマップさせますが、これはデフォルトでは許可されていません。初めに、 `policycoreutils` と `checkpolicy` をインストールします。 

```console
$ sudo dnf install policycoreutils checkpolicy
```

PostgreSQLのバイナリーのタイプを `postgresql_t` 、 PostgreSQｌのデータファイルのタイプを `postgresql_db_t` とします。 `postgresql_t` が `postgresql_db_t` のファイルをメモリーにマップすることを許可します。そして、それをコンパイル(.mod)、パッケージ(.pp)したポリシーパッケージをインストールします。

```console
$ cat > my-pgroonga.te << EOF
module my-pgroonga 1.0;

require {
    type postgresql_t;
    type postgresql_db_t;
    class file map;
}

allow postgresql_t postgresql_db_t:file map;
EOF

$ checkmodule -M -m -o my-pgroonga.mod my-pgroonga.te
$ semodule_package -o my-pgroonga.pp -m my-pgroonga.mod
$ sudo semodule -i my-pgroonga.pp
```

データベースを作成します。

```console
$ psql --command 'CREATE DATABASE pgroonga_test'
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```console
$ psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。

## Windows {#windows}

ソースからPGroongaをビルド・インストールするために必要なソフトウェアは次の通りです。これらをインストールしてください。

  * PostgreSQL（インストーラーバージョンでもzipバージョンでもどちらでも構いません。）

    * [インストーラーバージョン](http://www.enterprisedb.com/products-services-training/pgdownload)

    * [zipバージョン](http://www.enterprisedb.com/products-services-training/pgbindownload)

  * [Visual Studio](https://visualstudio.microsoft.com/downloads/)

  * [CMake](http://www.cmake.org/)

    * Groongaのビルドに使います

  * [Meson](https://mesonbuild.com/) and [Ninja](https://ninja-build.org/)

    * PGroongaのビルドに使います

packages.groonga.orgからGroongaとPGroongaのソースアーカイブをダウンロードして展開します。

  * [groonga-latest](https://packages.groonga.org/source/groonga/groonga-latest.zip)

  * [pgroonga-{{ site.pgroonga_version }}](https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.zip)

ビルドで使う変数

  * `%GROONGA_INSTALL_DIR%`はGroongaをインストールするフォルダです。

  * `%POSTGRESQL_INSTALL_FOLDER%`はPostgreSQLをインストールしたフォルダです。

    * インストーラーを使ってPostgreSQLをインストールした場合は`%POSTGRESQL_INSTALL_FOLDER%`は`C:\Program Files\PostgreSQL\%POSTGRESQL_VERSION%`になります。

    * zipバージョンのPostgreSQLをインストールした場合は`%POSTGRESQL_INSTALL_FOLDER%`は`%PostgreSQLのzipを展開したフォルダー%\pgsql`になります。

Groongaをビルドしてインストールします。

```text
> cmake -B groonga.build -G Ninja -S groonga-latest -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=%GROONGA_INSTALL_DIR% -DGRN_WITH_MECAB=bundled -DGRN_WITH_MESSAGE_PACK=bundled -DGRN_WITH_MRUBY=yes -DGRN_WITH_RAPIDJSON=bundled -DGRN_WITH_XXHASH=bundled -DGRN_WITH_ZSTD=bundled
> cmake --build groonga.build
> cmake --install groonga.build
```

PGroongaをビルドします。

```text
> meson setup pgroonga.build -S pgroonga-{{ site.pgroonga_version }} --buildtype=release --cmake-prefix-path=%GROONGA_INSTALL_DIR% -Dpg_config=%POSTGRESQL_INSTALL_FOLDER%\bin\pg_config.exe
> meson compile -C pgroonga.build
```

PGroongaをインストールします。管理者権限が必要かもしれません。たとえば、インストーラーを使ってPostgreSQLをインストールした場合は管理者権限が必要でしょう。

```text
> meson install -C pgroonga.build
```

データベースを作成します。

```text
postgres=# CREATE DATABASE pgroonga_test;
```

（通常は`pgroonga_test`データベース用のユーザーを作ってそのユーザーを利用するべきです。詳細は[`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html)を参照してください。）

作成したデータベースに接続し、`CREATE EXTENSION pgroonga`を実行します。

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

これで終わりです！

[チュートリアル](../tutorial/)を試してください。PGroongaについてもっと理解できるはずです。
