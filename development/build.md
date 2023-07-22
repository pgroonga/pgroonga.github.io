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

### Setting up build environment

Those who are newcomers to this field usually find it challenging to start contributing to projects based in the C language, mainly due to the extensive library dependencies involved. So we provide setup script in our PGroonga source code.

#### For Debian 12 bookworm

Please use following script:
[https://github.com/pgroonga/pgroonga/blob/master/tools/setup-devenv.sh](https://github.com/pgroonga/pgroonga/blob/master/tools/setup-devenv.sh)

```bash
./setup-devenv.sh debian-bookworm
```

#### For Ubuntu 22.04

Please use following script:
[https://github.com/pgroonga/pgroonga/blob/master/tools/setup-devenv.sh](https://github.com/pgroonga/pgroonga/blob/master/tools/setup-devenv.sh)

```bash
./setup-devenv.sh ubuntu-jammy
```


### Configure PostgreSQL Build
Run `configure` with `CFLAGS="-O0 -g3"` argument. It enables debug build. `--prefix=/tmp/local` is optional:

```console
% ./configure CFLAGS="-O0 -g3" --prefix=/tmp/local
```

Build and install PostgreSQL:

```console
% make -j$(nproc) > /dev/null
% make install > /dev/null
% (cd contrib/postgres_fdw && make install > /dev/null)
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

### Setting up the PATH
You need to set `PATH=/tmp/local/bin:$PATH`. This is because PostgreSQL was built using the `--prefix=/tmp/local` option, which puts `pg_config` in `/tmp/local/bin`. Use the following command to set the PATH:

```console
% export PATH=/tmp/local/bin:$PATH
```

### Building and Installing

To build and install PGroonga, you can simply run the following commands. PGroonga will be installed in the `/tmp/local/share/postgresql/extension` directory.

```console
make
make install
```

### Test

PGroonga has two test types:

  * SQL based regression tests

  * Ruby and SQL based [`pgroonga_check`][pgroonga-check] tests

Normally, you only use the former. `test/run-sql-test.sh` is the test runner for the former. It builds and installs PGroonga and runs SQL based regression tests. 

See also [test](test.html).

[postgresql-source-download]:https://www.postgresql.org/ftp/source/

[groonga-build]:https://groonga.org/docs/install/others.html

[groonga-install]:https://groonga.org/docs/install.html

[pgroonga-check]:../reference/modules/pgroonga-check.html
