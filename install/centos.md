---
title: Install on CentOS
---

# Install on CnetOS

This document describes how to install PGroonga on CentOS.

## Supported versions

Here are supported CentOS versions:

  * [CentOS 6](#install-on-6)

  * [CentOS 7](#install-on-7)

## How to install on CentOS 6 {#install-on-6}

You can use the following instruction to install PGroonga on CentOS 6.

Install `postgresql-pgroonga` package:

```text
% sudo -H yum install -y http://yum.postgresql.org/10/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos10-10-2.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-1.3.0-1.noarch.rpm
% sudo -H yum install -y postgresql10-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /sbin/service postgresql-10 initdb
% sudo -H /sbin/chkconfig postgresql-10 on
% sudo -H /sbin/service postgresql-10 start
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.

## How to install on CentOS 7 {#install-on-7}

You can use the following instruction to install PGroonga on CentOS 7.

Install `postgresql-pgroonga` package:

```text
% sudo -H yum install -y http://yum.postgresql.org/10/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos10-10-2.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-1.3.0-1.noarch.rpm
% sudo -H yum install -y postgresql10-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo -H yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /usr/pgsql-10/bin/postgresql-10-setup initdb
% sudo -H systemctl enable postgresql-10
% sudo -H systemctl start postgresql-10
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user. See [`GRANT USAGE ON SCHEMA pgroonga`](../reference/grant-usage-on-schema-pgroonga.html) for details.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
