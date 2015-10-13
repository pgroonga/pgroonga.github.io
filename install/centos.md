---
title: Install on CentOS
layout: en
---

# Install on CnetOS

This document describes how to install PGroonga on CentOS.

## Supported versions

Here are supported CentOS versions:

  * [CentOS 5](#install-on-5-or-6)
  * [CentOS 6](#install-on-5-or-6)
  * [CentOS 7](#install-on-7)

## How to install on CentOS 5 or CentOS 6 {#install-on-5-or-6}

You can use the following instruction to install PGroonga on CentOS 5 or CentOS 6.

Install `postgresql-pgroonga` package:

```text
% sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
% sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo yum makecache
% sudo yum install -y postgresql94-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /sbin/service postgresql-9.4 initdb
% sudo -H /sbin/chkconfig postgresql-9.4 on
% sudo -H /sbin/service postgresql-9.4 start
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user.)

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
% sudo rpm -ivh http://yum.postgresql.org/9.4/redhat/rhel-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-centos94-9.4-1.noarch.rpm
% sudo rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
% sudo yum makecache
% sudo yum install -y postgresql94-pgroonga
```

If you want to use [MeCab](http://taku910.github.io/mecab/) based tokenizer, you also need to install `groonga-tokenizer-mecab` package:

```text
% sudo yum install -y groonga-tokenizer-mecab
```

Run PostgreSQL:

```text
% sudo -H /usr/pgsql-9.4/bin/postgresql94-setup initdb
% sudo -H systemctl enable postgresql-9.4
% sudo -H systemctl start postgresql-9.4
```

Create a database:

```text
% sudo -u postgres -H psql --command 'CREATE DATABASE pgroonga_test'
```

(Normally, you should create a user for `pgroonga_test` database and use the user.)

Connect to the created database and execute `CREATE EXTENSION pgroonga`:

```text
% sudo -u postgres -H psql -d pgroonga_test --command 'CREATE EXTENSION pgroonga'
```

That's all!

Try [tutorial](../tutorial/). You can understand more about PGroonga.
