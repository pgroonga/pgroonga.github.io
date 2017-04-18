---
title: Install on FreeBSD
---

# Install on FreeBSD

This document describes how to install PGroonga on FreeBSD.

## How to install

You can use the following instruction to install PGroonga on FreeBSD.

Install Groonga, PostgreSQL, pkg-config and GNU Make by `pkg`:

```text
% sudo pkg install -y groonga pkgconf postgresql{{ site.freebsd_postgresql_version }}-server
```

If you want to use [MeCab](http://taku910.github.io/mecab/) as tokenizer, install `japanese/mecab-ipadic` additionally

```text
% sudo pkg install -y japanese/mecab-ipadic
```

Create `/etc/rc.conf.d/postgresql` with the following content to enable PostgreSQL:

`/etc/rc.conf.d/postgresql`:

```text
postgresql_enable="YES"
```

Initialize PostgreSQL database:

```text
% sudo -H /usr/local/etc/rc.d/postgresql initdb
```

Start PostgreSQL:

```text
% sudo -H service postgresql start
```

Install PGroonga from source:

```text
% curl -O https://packages.groonga.org/source/pgroonga/pgroonga-{{ site.pgroonga_version }}.tar.gz
% tar xvf pgroonga-{{ site.pgroonga_version }}.tar.gz
% cd pgroonga-{{ site.pgroonga_version }}
% gmake HAVE_MSGPACK=1
% sudo -H gmake install
```

Create a database:

```text
% sudo -H -u postgres psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -H -u postgres psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga;'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
