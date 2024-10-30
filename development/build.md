---
title: Build
---

# Build

This document describes how to build PGroonga as a developer. For example, a developer who wants to add a new feature, fix a bug and so on.

If you want to be a casual PGroonga developer, [build as a casual developers](build-casual.html) is better than this.

## Setting up build environment

It's recommended that you build both PostgreSQL and PGroonga with debug options.

It's better that you [build Groonga][groonga-build] with debug options too. You can use `cmake --preset=debug-maximum ...` for it.

If you use [packaged Groonga][groonga-install], you need to install development package. It's `libgroonga-dev` for Debian family distribution and `groonga-devel` for Red Hat family distribution.

You need to install `token_fitlers/stem` Groonga plugin to run all tests. You can install it by `groonga-token-filter-stem` package.

## How to build PostgreSQL

Download source from [the PostgreSQL site][postgresql-source-download]. Here are command lines to download the source of PostgreSQL {{ site.development_postgresql_version }} and extract it:

```bash
wget https://ftp.postgresql.org/pub/source/v{{ site.development_postgresql_version }}/postgresql-{{ site.development_postgresql_version }}.tar.bz2
tar xf postgresql-{{ site.development_postgresql_version }}.tar.bz2
```

Run `meson setup` with `--buildtype=debug` argument. It enables debug build. `--prefix=/tmp/local` is optional:

```bash
meson setup \
  --buildtype=debug \
  --prefix=/tmp/local \
  postgresql-{{ site.development_postgresql_version }}.build \
  postgresql-{{ site.development_postgresql_version }}
```

Build and install PostgreSQL:

```bash
meson compile -C postgresql-{{ site.development_postgresql_version }}
meson install -C postgresql-{{ site.development_postgresql_version }}
```

Initialize and run PostgreSQL:

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

The following one liner is useful to reset all PostgreSQL related data. You store the one liner in your shell history, you can rerun the one linear quickly:

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

## Prepare your fork repository

You need to fork <https://github.com/pgroonga/pgroonga/> for development. You will open a pull request from your fork repository later. See also GitHub documents:

* <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks>

* <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork>

Here are command lines to clone your fork repository:

```bash
git clone --recursive git@github.com:${YOUR_GITHUB_ACCOUNT}/pgroonga.git
cd pgroonga
```

## How to build PGroonga and run tests

You can use the following command line to build PGroonga and run PGroonga tests:

```bash
HAVE_XXHASH=1 test/run-sql-test.sh
```

PGroonga has two test types:

  * SQL based regression tests

  * Complex tests that can't be implemented only with SQL

Normally, you only use the former. `test/run-sql-test.sh` is the test runner for the former. It builds and installs PGroonga and runs SQL based regression tests.

See also [test](test.html).

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:https://groonga.org/docs/install/cmake.html

[groonga-install]:https://groonga.org/docs/install.html
