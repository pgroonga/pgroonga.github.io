---
title: Build
---

# Build

It's recommended that you build both PostgreSQL and PGroonga with debug options.

It's better that you [build Groonga][groonga-build] with debug options (Groonga's `configure` provides `--enable-debug` option) too. If you use [packaged Groonga][groonga-install], you need to install development package. It's `libgroonga-dev` for Debian family distribution and `groonga-devel` for Red Hat family distribution.

You need to install `token_fitlers/stem` Groonga plugin to run all tests. You can install it by `groonga-token-filter-stem` package.

## How to build PostgreSQL

Download source from [the PostgreSQL site][postgresql-source-download]. Here are command lines to download the source of PostgreSQL {{ site.development_postgresql_version }} and extract it:

```console
% wget https://ftp.postgresql.org/pub/source/v{{ site.development_postgresql_version }}/postgresql-{{ site.development_postgresql_version }}.tar.bz2
% tar xf postgresql-{{ site.development_postgresql_version }}.tar.bz2
% cd postgresql-{{ site.development_postgresql_version }}
```

Run `configure` with `CFLAGS="-O0 -g3"` argument. It enables debug build. `--prefix=/tmp/local` is optional:

```console
% ./configure CFLAGS="-O0 -g3" --prefix=/tmp/local
```

Build and install PostgreSQL:

```console
% make -j$(nproc) > /dev/null
% make install > /dev/null
% (cd contrib/postgres_fdw && make install)
```

Initialize and run PostgreSQL:

```console
% mkdir -p /tmp/local/var/lib
% /tmp/local/bin/initdb \
  --locale C \
  --encoding UTF-8 \
  --set=enable_partitionwise_join=on \
  --set=max_prepared_transactions=1 \
  --set=random_page_cost=0 \
  -D /tmp/local/var/lib/postgresql
% /tmp/local/bin/postgres -D /tmp/local/var/lib/postgresql
```

The following one liner is useful to reset all PostgreSQL related data. You store the one liner in your shell history, you can rerun the one linear quickly:

```console
% rm -rf /tmp/local/var/lib/postgresql && \
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

## How to build and test PGroonga

It's recommended that you use the latest PGroonga instead of released PGroonga. Here are command lines to clone the latest PGroonga source:

```console
% git clone --recursive git@github.com:pgroonga/pgroonga.git
% cd pgroonga
```

PGroonga has two test types:

  * SQL based regression tests

  * Ruby and SQL based [`pgroonga_check`][pgroonga-check] tests

Normally, you only use the former. `test/run-sql-test.sh` is the test runner for the former. It builds and installs PGroonga and runs SQL based regression tests. `PATH=/tmp/local/bin:$PATH` is needed because PostgreSQL is built with `--prefix=/tmp/local`. `pg_config` exists in `/tmp/local/bin`:

```console
% PATH=/tmp/local/bin:$PATH test/run-sql-test.sh
```

See also [test](test.html).

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:https://groonga.org/docs/install/others.html

[groonga-install]:https://groonga.org/docs/install.html

[pgroonga-check]:../reference/modules/pgroonga-check.html
