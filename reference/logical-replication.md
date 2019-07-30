---
title: Logical replication
---

# Logical replication

PGroonga supports PostgreSQL built-in logical replication since 1.2.4. It requires PostgreSQL 10 or later.

This document describes how to configure PostgreSQL built-in logical replication for PGroonga. Most of steps are normal steps. There are some PGroonga specific steps.

It doesn't have to be have same schema for source of replication and
destionation of replication for logical replication.

Therefore, setting an index on only a destination of replication in here.

## Summary

Here are steps to configure PostgreSQL built-in logical replication for PGroonga. "[normal]" tag means that the step is a normal step for logical replication. "[special]" tag means that the step is a PGroonga specific step.

  1. [normal] Install PostgreSQL on Publisher and Subscriber

  2. [special] Install PGroonga on Subscriber

  3. [normal] Initialize PostgreSQL database on Publisher and Subscriber

  4. [normal] Add some logical replication configurations to `postgresql.conf` and `pg_hba.conf` on Publisher

  5. [normal] Create table on Publisher and Subscriber

  6. [normal] Create publication on Publisher

  7. [normal] Create subscription on Subscriber

  8. [special] Create a PGroonga index on Subscriber

  9. [normal] Insert data on Publisher

## Example environment

This document uses the following environment:

  * Publisher:

    * OS: CentOS 7

    * IP Address: 172.16.0.1

    * Database name: `blog`

    * Replication user name: `replicator`

    * Replication user password: `passw0rd`

  * Subscriber:

    * OS: CentOS 7

    * IP Address: 172.16.0.2

    * Database name: `blog`

This document shows command lines for CentOS 7. If you're using other platforms, adjust command lines by yourself.

## [normal] Install PostgreSQL on Publisher and Subscriber

This is a normal step.

Install PostgreSQL {{ site.latest_postgresql_version }} on Publisher and Subscriber.

Publisher and Subscriber:

```console
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo yum install postgresql{{ site.latest_postgresql_version }}-server
```

See also [PostgreSQL: Linux downloads (CentOS)][centos].

## [special] Install PGroonga on Subscriber

This is a PGroonga specific step.

Install PGroonga on Subscriber.

Subscriber:

```console
% sudo -H yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-$(rpm -qf --queryformat="%{VERSION}" /etc/redhat-release)-$(rpm -qf --queryformat="%{ARCH}" /etc/redhat-release)/pgdg-redhat-repo-latest.noarch.rpm
% sudo -H yum install -y https://packages.groonga.org/centos/groonga-release-latest.noarch.rpm
% sudo -H yum install -y postgresql{{ site.latest_postgresql_version}}-pgroonga
```

## [normal] Initialize PostgreSQL database on Publisher and Subscriber

This is a normal step.

Initialize PostgreSQL database on Publisher and Subscriber.

Publisher and Subscriber:

```console
% sudo /usr/pgsql-{{ site.latest_postgresql_version }}/bin/postgresql-{{ site.latest_postgresql_version }}-setup initdb
% sudo systemctl enable --now postgresql-{{ site.latest_postgresql_version }}
```

## [normal] Add some logical replication configurations to `postgresql.conf` on Publisher

This is a normal step.

Add the following logical replication configurations to `postgresql.conf` on only Publisher:

  * `wal_level = logical`

     * See also [PostgreSQL: Documentation: Write Ahead Log][wal].

  * `max_wal_senders = 2` (`= 1 (The number of Subscribers) * 2`. `* 2` is for unexpected connection close.)

     * See also [PostgreSQL: Documentation: Replication][replication].

  * `max_replication_slots = 1` (`= 1 (The number of Subscribers)`).

     * See also [PostgreSQL: Documentation: Replication][replication].

`/var/lib/pgsql/{{ site.latest_postgresql_version }}/data/postgresql.conf`:

Before:

```text
#listen_address = 'localhost'

#wal_level = minimal
#max_wal_senders = 0
#max_replication_slots = 0
```

After:

```text
listen_address = '*'

wal_level = logical
max_wal_senders = 2
max_replication_slots = 1
```

Add the following logical replication configurations to `pg_hba.conf` on only Publisher:

  * Accept replication connection by the replication user `replicator` from `172.16.0.2/32`.

`/var/lib/pgsql/{{ site.latest_postgresql_version }}/data/pg_hba.conf`:

Before:

```text
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                trust
host    replication     all        127.0.0.1/32            trust
host    replication     all        ::1/128                 trust
```

After:

```text
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                trust
host    replication     all        127.0.0.1/32            trust
host    replication     all        ::1/128                 trust

# IPv4 remote connections:
host    all             replicator       172.16.0.2/32         md5
```

Restart PostgreSQL to apply the configuration:

```console
% sudo -H systemctl restart postgresql-{{ site.latest_postgresql_version }}
```

Create the user for replication on only Publisher:

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createuser --pwprompt replicator -U postgres
Enter password for new role: (passw0rd)
Enter it again: (passw0rd)
```

## [normal] Create table on Publisher and Subscriber

This is a normal step.

Create a normal user on Subscriber:

Subscriber:

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createuser ${USER} -U postgres
```

Create a database on Publisher and Subscriber:

Publisher and Subscriber:

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/createdb --owner ${USER} blog -U postgres
```

Create a table in the created database.
Connect to the created `blog` database:

```console
% /usr/pgsql-{{ site.latest_postgresql_version }}/bin/psql blog -U ${USER}
```

Create `entries` table:

```sql
CREATE TABLE entries (
  title text,
  body text
);
```

## [special] Create a PGroonga index on Subscriber

This is a PGroonga specific step.

Install PGroonga to the database. It requires superuser privilege:

Subscriber:

```sql
CREATE EXTENSION pgroonga;
```

Create a PGroonga index on Subscriber:

Subscriber:

```sql
CREATE INDEX entries_full_text_search ON entries USING pgroonga (title, body);
```

Create a PUBLICATION on Publisher only:

```sql
CREATE PUBLICATION pub_srv1_blog FOR TABLE entries;
```

Create a SUBSCRIPTION on Subscriber only:

```sql
CREATE SUBSCRIPTION sub_srv2_blog CONNECTION 'dbname=blog hostaddr=172.16.0.2 port=5432 user=replicator password=passw0rd' PUBLICATION pub_srv1_blog;
```

## [normal] Insert data on Publisher only:

Insert data to the created `entries` table:

```sql
INSERT INTO entries VALUES ('PGroonga', 'PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.');
INSERT INTO entries VALUES ('Groonga', 'Groonga is a full text search engine used by PGroonga. We did not know about it.');
INSERT INTO entries VALUES ('PGroonga and replication', 'PGroonga 1.1.6 supports WAL based streaming replication. We should try it!');
```

Confirm replication:

Publisher:

```sql
SELECT * FROM entries;
 title    |                                  body
 ---------+---------------------------------------------------------------------------
 PGroonga | PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.
 Groonga  | Groonga is a full text search engine used by PGroonga. We did not know about it.
 PGroonga and replication | PGroonga 1.1.6 supports WAL based streaming replication. We should try it!
 (3 rows)
```

Subscriber:

```sql
SELECT * FROM entries;
 title    |                                  body
 ---------+---------------------------------------------------------------------------
 PGroonga | PGroonga is a PostgreSQL extension for fast full text search that supports all languages. It will help us.
 Groonga  | Groonga is a full text search engine used by PGroonga. We did not know about it.
 PGroonga and replication | PGroonga 1.1.6 supports WAL based streaming replication. We should try it!
 (3 rows)
```

Now, we can search data replicated on subscriber by PGroonga index created on subscriber.

```sql
SET enable_seqscan TO off;
SELECT * FROM entries WHERE body &@ 'Groonga';
  title  |                                       body
---------+----------------------------------------------------------------------------------
 Groonga | Groonga is a full text search engine used by PGroonga. We did not know about it.
(1 row)
```

[wal]:{{ site.postgresql_doc_base_url.en }}/runtime-config-wal.html#GUC-WAL-LEVEL

[replication]:{{ site.postgresql_doc_base_url.en }}/runtime-config-replication.html#GUC-MAX-WAL-SENDERS

[centos]:https://www.postgresql.org/download/linux/redhat/
