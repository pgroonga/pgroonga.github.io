---
title: Install from source
---

# Install from source

This document describes how to build and install PGroonga from source.

Build and install instruction is different between on Windows and on non Windows. This document describes it separately.

  * [On non Windows](#non-windows)

  * [On Windows](#windows)

## On non Windows {#non-windows}

Install PostgreSQL.

[Install Groonga](http://groonga.org/docs/install.html). We recommend that you use package. If you use package to install Groonga, install the following package:

  * `groonga-devel`: on CentOS
  * `libgroonga-dev`: on Debian/GNU Linux and Ubuntu

Extract PGroonga source:

```text
% wget http://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
% tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
% cd pgroonga-{{ site.pgroonga_version }}
```

FYI: If you want to use the unreleased latest version, use the followings:

```text
% git clone --recursive https://github.com/pgroonga/pgroonga.git
% cd pgroonga
```

Build PGroonga:

```text
% make
```

If you get any error, confirm the followings:

  * `pg_config` command exists at any path in `PATH` environment variable.
  * `pkg-config --list-all` includes `groonga`.

If `pg_config` command doesn't exist, you may forget to install the development package of PostgreSQL.

If `pkg-config --list-all` doesn't include `groonga`, you may forget to install the development package of Groonga. Or `groonga.pc` is installed into non-standard directory. You can use `PKG_CONFIG_PATH` environment variable for the case.

Here is an example when you install Groonga with `--prefix=/usr/local`:

```text
% PKG_CONFIG_PATH=/usr/local/lib/pkg-config make
```

Install PGroonga:

```text
% sudo make install
```

Create a database:

```text
% psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.

## On Windows {#windows}

Here is a list of required software to build and install PGroonga from source. Install them:

  * PostgreSQL (You can choose installer version or zip version.)
    * [Installer version](http://www.enterprisedb.com/products-services-training/pgdownload)
    * [Zip version](http://www.enterprisedb.com/products-services-training/pgbindownload)
  * [Microsoft Visual Studio Express 2013 for Windows Desktop](https://www.visualstudio.com/downloads/#d-2013-express)
  * [CMake](http://www.cmake.org/)

Download PGroonga source archive for Windows from packages.groonga.org. Source archive for Windows is zip file. Source archive for Windows bundles Groonga.

  * [pgroonga-{{ site.pgroonga_version }}](http://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.zip)

Extract the downloaded source archive and move to source folder:

```text
> cd c:\Users\%USERNAME%\Downloads\pgroonga-{{ site.pgroonga_version }}
```

Specify build option by `cmake`. The following command line is for building PGroonga for 64bit version PostgreSQL. If you want to build for 32bit version PostgreSQL, use `-G "Visual Studio 12 2013"` parameter instead:

```text
pgroonga-{{ site.pgroonga_version }}> cmake . -G "Visual Studio 12 2013 Win64" -DCMAKE_INSTALL_PREFIX=%POSTGRESQL_INSTALL_FOLDER%
```

If you installed PostgreSQL by installer, `%POSTGRESQL_INSTALL_FOLDER%` is `C:\Program Files\PostgreSQL\{{ site.windows_postgresql_short_version }}`.

If you installed PostgreSQL by zip, `%POSTGRESQL_INSTALL_FOLDER%` is `%POSTGRESQL_ZIP_EXTRACTED_FOLDER%\pgsql`.

Build PGroonga:

```text
pgroonga-{{ site.pgroonga_version }}> cmake --build . --config Release
```

Install PGroonga. You may be required administrator privilege. For example, you installed PostgreSQL by installer, you will be required administrator privilege.

```text
pgroonga-{{ site.pgroonga_version }}> cmake --build . --config Release --target Install
```

Create a database:

```text
postgres=# CREATE DATABASE pgroonga_test;
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
postgres=# \c pgroonga_test
pgroonga_test=# CREATE EXTENSION pgroonga;
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
