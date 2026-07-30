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

```console
$ wget https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
$ tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
$ cd pgroonga-{{ site.pgroonga_version }}
```

FYI: If you want to use the unreleased latest version, use the followings:

```console
$ git clone --recursive https://github.com/pgroonga/pgroonga.git
$ cd pgroonga
```

Build and install PGroonga with [Meson](https://mesonbuild.com/) and [Ninja](https://ninja-build.org/):

```console
$ meson setup build
$ meson compile -C build
$ sudo meson install -C build
```

If `pg_config` command doesn't exist in your `PATH`, specify it explicitly with the `pg_config` option:

```console
$ meson setup build -Dpg_config=/path/to/pg_config
```

If you get any error, confirm the followings:

  * `meson` and `ninja` commands are installed.

  * `pg_config` command exists at any path in `PATH` environment variable, or is specified with the `pg_config` option.

  * `pkg-config --list-all` includes `groonga`.

If `pg_config` command doesn't exist, you may forget to install the development package of PostgreSQL.

If `pkg-config --list-all` doesn't include `groonga`, you may forget to install the development package of Groonga. Or `groonga.pc` is installed into non-standard directory. You can use `PKG_CONFIG_PATH` environment variable for the case.

Here is an example when you install Groonga with `--prefix=/usr/local`:

```console
$ PKG_CONFIG_PATH=/usr/local/lib/pkgconfig meson setup build
```

If you use SELinux, you must create a policy package(.pp) and install it. PGroonga makes PostgreSQL map `<data dir>/pgrn*` files into memory, which is not allowed by default. First, install `policycoreutils` and `checkpolicy`.

```console
$ sudo dnf install policycoreutils checkpolicy
```

Let's assume that PostgreSQL binaries are of type `postgresql_t` and PostgreSQL data files are of type `postgresql_db_t`. Allow `postgresql_t` type to memory map files of type `postgresql_db_t`. Then compile it (.mod), package it (.pp) and install the resulting policy package.

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

Create a database:

```console
$ psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```console
$ psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.

## On Windows {#windows}

Here is a list of required software to build and install PGroonga from source. Install them:

  * PostgreSQL (You can choose installer version or zip version.)

    * [Installer version](http://www.enterprisedb.com/products-services-training/pgdownload)

    * [Zip version](http://www.enterprisedb.com/products-services-training/pgbindownload)

  * [Visual Studio](https://visualstudio.microsoft.com/downloads/)

  * [CMake](http://www.cmake.org/)

    * Use for building Groonga

  * [Meson](https://mesonbuild.com/) and [Ninja](https://ninja-build.org/)

    * Use for building PGroonga

Download the Groonga source archive and PGroonga source archive from packages.groonga.org and extract them:

  * [groonga-latest](https://packages.groonga.org/source/groonga/groonga-latest.zip)

  * [pgroonga-{{ site.pgroonga_version }}](https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.zip)

Variables used for the build:

  * `%GROONGA_INSTALL_DIR%` is a folder to install Groonga

  * `%POSTGRESQL_INSTALL_FOLDER%` is a folder where PostgreSQL is installed

    * If you installed PostgreSQL by installer, `%POSTGRESQL_INSTALL_FOLDER%` is `C:\Program Files\PostgreSQL\%POSTGRESQL_VERSION%`.

    * If you installed PostgreSQL by zip, `%POSTGRESQL_INSTALL_FOLDER%` is `%POSTGRESQL_ZIP_EXTRACTED_FOLDER%\pgsql`.

Build and install Groonga:

```text
> cmake -B groonga.build -G Ninja -S groonga-latest -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=%GROONGA_INSTALL_DIR% -DGRN_WITH_MECAB=bundled -DGRN_WITH_MESSAGE_PACK=bundled -DGRN_WITH_MRUBY=yes -DGRN_WITH_RAPIDJSON=bundled -DGRN_WITH_XXHASH=bundled -DGRN_WITH_ZSTD=bundled
> cmake --build groonga.build
> cmake --install groonga.build
```

Build PGroonga:

```text
> meson setup pgroonga.build -S pgroonga-{{ site.pgroonga_version }} --buildtype=release --cmake-prefix-path=%GROONGA_INSTALL_DIR% -Dpg_config=%POSTGRESQL_INSTALL_FOLDER%\bin\pg_config.exe
> meson compile -C pgroonga.build
```

Install PGroonga. You may be required administrator privilege. For example, you installed PostgreSQL by installer, you will be required administrator privilege.

```text
> meson install -C pgroonga.build
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
