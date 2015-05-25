---
title: Install
layout: en
---

# Install

There are packages for major platforms. You can install PGroonga easily.

Here are supported PostgreSQL versions:

  * 9.3
  * 9.4

See a document for your platform in the followings for details:

  * [Ubuntu](ubuntu.html)
    * 14.10
  * CentOS
    * [5](centos.html#centos-5)
    * [6](centos.html#centos-6)
    * [7](centos.html#centos-7)
  * Windows
    * [32bit + PostgreSQL 9.4.1](windows.html#windows-32-postgresql-9-4-1)
    * [64bit + PostgreSQL 9.4.1](windows.html#windows-64-postgresql-9-4-1)

If you can't find your platform in the above list, [build and install from source](source.html).

## インストール

次の環境用のパッケージを用意しています。

その他の環境ではソースからインストールしてください。

それぞれの環境でのインストール方法の詳細は以降のセクションで説明します。

### Ubuntu 14.10にインストール

`postgresql-server-9.4-pgroonga`パッケージをインストールします。

    % sudo apt-get install -y software-properties-common
    % sudo add-apt-repository -y universe
    % sudo add-apt-repository -y ppa:groonga/ppa
    % sudo apt-get update
    % sudo apt-get install -y postgresql-server-9.4-pgroonga

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いた
い場合は`groonga-tokenizer-mecab`パッケージもインストールします。

    % sudo apt-get install -y groonga-tokenizer-mecab

データベースを作成します。

    % sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'

（ここで`pgroonga_test`用のユーザーを作成して、そのユーザーで接続する
べき。）

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    % sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'

これでインストールは完了です。

### CentOS 5または6にインストール

`postgresql-pgroonga`パッケージをインストールします。

    % sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
    % sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
    % sudo yum makecache
    % sudo yum install -y postgresql94-pgroonga

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いた
い場合は`groonga-tokenizer-mecab`パッケージもインストールします。

    % sudo yum install -y groonga-tokenizer-mecab

PostgreSQLを起動します。

    % sudo -H /sbin/service postgresql-9.4 initdb
    % sudo -H /sbin/chkconfig postgresql-9.4 on
    % sudo -H /sbin/service postgresql-9.4 start

データベースを作成します。

    % sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'

（ここで`pgroonga_test`用のユーザーを作成して、そのユーザーで接続する
べき。）

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    % sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'

これでインストールは完了です。

### CentOS 7にインストール

`postgresql-pgroonga`パッケージをインストールします。

    % sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
    % sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
    % sudo yum makecache
    % sudo yum install -y postgresql94-pgroonga

[MeCab](http://taku910.github.io/mecab/)ベースのトークナイザーを使いた
い場合は`groonga-tokenizer-mecab`パッケージもインストールします。

    % sudo yum install -y groonga-tokenizer-mecab

PostgreSQLを起動します。

    % sudo -H /usr/pgsql-9.4/bin/postgresql94-setup initdb
    % sudo -H systemctl enable postgresql-9.4
    % sudo -H systemctl start postgresql-9.4

データベースを作成します。

    % sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'

（ここで`pgroonga_test`用のユーザーを作成して、そのユーザーで接続する
べき。）

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    % sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'

これでインストールは完了です。

### Windowsにインストール

PostgreSQLをインストールします。PostgreSQL 9.4.1-3のものであれば
[インストーラーバージョン](http://www.enterprisedb.com/products-services-training/pgdownload)
でも
[zipバージョン](http://www.enterprisedb.com/products-services-training/pgbindownload)
でも構いません。

PGroongaのパッケージをダウンロードします。

  * [32bit版](http://packages.groonga.org/windows/pgroonga/pgroonga-0.5.0-postgresql-9.4.1-3-x86.zip)
  * [64bit版](http://packages.groonga.org/windows/pgroonga/pgroonga-0.5.0-postgresql-9.4.1-3-x64.zip)

PGroongaのパッケージを展開します。展開先としてPostgreSQLのフォルダーを
指定します。PostgreSQLのフォルダーはインストーラーを使ってPostgreSQLを
インストールした場合は`C:\Program Files\PostgreSQL\9.4`です。zipを使っ
てインストールした場合は`%アーカイブを展開したフォルダー%\pgsql`です。

データベースを作成します。

    postgres=# CREATE DATABASE pgroonga_test;

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    postgres=# \c pgroonga_test
    pgroonga_test=# CREATE EXTENSION pgroonga;

これでインストールは完了です。

### ソースからインストール

Windowsの場合とそれ以外の場合でソースからのインストール方法が違います。

まず、Windows以外の場合を説明し、その後、Windowsの場合を説明します。

#### Windows以外の場合

まずPostgreSQLをインストールします。

次に[Groongaをインストール](http://groonga.org/ja/docs/install.html)し
ます。パッケージでのインストールがオススメです。

パッケージでインストールするときは次のパッケージをインストールしてください。

  * `groonga-devel`: CentOSの場合
  * `libgroonga-dev`: Debian GNU/Linux, Ubuntuの場合

PGroongaのソースを展開します。

リリース版の場合:

    % wget http://packages.groonga.org/source/pgroonga/pgroonga-0.5.0.tar.gz
    % tar xvf pgroonga-0.5.0.tar.gz
    % cd pgroonga-0.5.0

未リリースの最新版の場合:

    % git clone https://github.com/pgroonga/pgroonga.git
    % cd pgroonga

PGroongaをビルドしてインストールします。

    % make
    % sudo make install

データベースを作成します。

    % psql --command 'CREATE DATABASE pgroonga_test'

（ここで`pgroonga_test`用のユーザーを作成して、そのユーザーで接続する
べき。）

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    % psql -d db --command 'CREATE EXTENSION pgroonga;'

これでインストールは完了です。

#### Windowsの場合

Windowsでソースからインストールするために必要なものは次の通りです。ま
ずはこれらをインストールしてください。

  * PostgreSQL（インストーラーバージョンでもzipバージョンでも構いません。）
    * [インストーラーバージョン](http://www.enterprisedb.com/products-services-training/pgdownload)
    * [zipバージョン](http://www.enterprisedb.com/products-services-training/pgbindownload)
  * [Microsoft Visual Studio Express 2013 for Windows Desktop](https://www.visualstudio.com/downloads/#d-2013-express)
  * [CMake](http://www.cmake.org/)

次にWindows用のPGroongaのソースアーカイブをpackages.groonga.orgからダ
ウンロードしてください。zipがWindows用のソースアーカイブです。Windows
用のソースアーカイブにはGroongaがバンドルされています。

  * http://packages.groonga.org/source/pgroonga/pgroonga-0.5.0.zip

ソースアーカイブを展開し、ソースフォルダーへ移動します。

    > cd c:\Users\%USERNAME%\Downloads\pgroonga-0.5.0

`cmake`でビルドオプションを設定します。以下のコマンドラインは64bit用の
PostgreSQL用にビルドするためのものです。32bit用のPostgreSQL用にをビル
ドする場合は代わりに`-G "Visual Studio 12 2013"`パラメーターを指定して
ください。

    pgroonga-0.5.0> cmake . -G "Visual Studio 12 2013 Win64" -DCMAKE_INSTALL_PREFIX=%PostgreSQLをインストールしたフォルダー%

`%PostgreSQLをインストールしたフォルダー%`はインストーラーを使って
PostgreSQLをインストールした場合は`C:\Program Files\PostgreSQL\9.4`で
す。zipを使ってインストールした場合は`%アーカイブを展開したフォルダー
%\pgsql`です。

ビルドします。

    pgroonga-0.5.0> cmake --build . --config Release

インストールします。インストールする場所によっては管理者権限が必要にな
ります。（PostgreSQLをインストーラーでインストールしている場合は管理者
権限が必要でしょう。）

    pgroonga-0.5.0> cmake --build . --config Release --target Install

データベースを作成します。

    postgres=# CREATE DATABASE pgroonga_test;

データベースに接続して`CREATE EXTENSION pgroonga`を実行します。

    postgres=# \c pgroonga_test
    pgroonga_test=# CREATE EXTENSION pgroonga;

これでインストールは完了です。

## アンインストール

次のSQLでアンインストールできます。

```sql
DROP EXTENSION pgroonga CASCADE;
DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
```

`pg_catalog.pg_am`から手動でレコードを消さないといけないのはおかしい気
がするので、何がおかしいか知っている人は教えてくれるとうれしいです。
